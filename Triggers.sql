USE PetShop
GO

CREATE TRIGGER trg_ValidateAttendance
ON STAFF_ATTENDANCE
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE logout <= [login])
    BEGIN
        RAISERROR('Data Absensi Tidak Valid: Logout tidak boleh lebih awal atau sama dengan Login.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    INSERT INTO STAFF_ATTENDANCE ([login], logout, staff_id)
    SELECT [login], logout, staff_id
    FROM inserted;
    
    PRINT 'Data absensi berhasil divalidasi dan disimpan.';
END;
GO

CREATE TRIGGER trg_ValidateTreatmentInsert
ON TREATMENT
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE schedule < GETDATE())
    BEGIN
        RAISERROR('Gagal Input: Tidak dapat membuat treatment di waktu yang sudah berlalu.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF EXISTS (
        SELECT 1 
        FROM TREATMENT t
        JOIN inserted i ON t.staff_id = i.staff_id 
        WHERE t.schedule = i.schedule -- Asumsi durasi per slot waktu sama persis
    )
    BEGIN
        RAISERROR('Gagal Input: Dokter Hewan ini sudah memiliki jadwal treatment di waktu tersebut.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    INSERT INTO TREATMENT (treatment_id, schedule, drug_id, pet_id, staff_id)
    SELECT treatment_id, schedule, drug_id, pet_id, staff_id
    FROM inserted;

    PRINT 'Jadwal Treatment berhasil dibuat.';
END;
GO

CREATE TRIGGER trg_ValidatePetBirthDate
ON PET
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE birth_date > GETDATE())
    BEGIN
        RAISERROR('Data Invalid: Tanggal lahir hewan tidak boleh di masa depan.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    
    -- Handle INSERT
    IF NOT EXISTS (SELECT 1 FROM deleted) 
    BEGIN
        INSERT INTO PET (id, [name], species, birth_date, cust_id)
        SELECT id, [name], species, birth_date, cust_id FROM inserted;
    END

    -- Handle UPDATE
    ELSE 
    BEGIN
        UPDATE P
        SET P.[name] = i.[name],
            P.species = i.species,
            P.birth_date = i.birth_date,
            P.cust_id = i.cust_id
        FROM PET P
        JOIN inserted i ON P.id = i.id;
    END
END;
GO

CREATE TRIGGER trg_PreventNegativeStock
ON [PRODUCT]
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE stock < 0)
    BEGIN
        RAISERROR('Update Ditolak: Stok produk tidak boleh kurang dari 0.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    UPDATE P
    SET P.[name] = i.[name],
        P.stock = i.stock,
        P.price = i.price
    FROM [PRODUCT] P
    JOIN inserted i ON P.id = i.id;
END;
GO