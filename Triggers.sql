USE PetShop;

GO
CREATE TRIGGER trg_ValidateAttendance
ON STAFF_ATTENDANCE
AFTER UPDATE
AS
BEGIN
    IF UPDATE(logout)
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM inserted i
            WHERE i.logout IS NOT NULL
            AND i.logout <= i.[login]
        )
        BEGIN
            RAISERROR('Invalid Attendance: Logout cannot be before or equal to Login time.', 16, 1);
            ROLLBACK TRANSACTION
        END
    END
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
        RAISERROR('Input Failed: Cannot schedule a treatment in the past.', 16, 1);
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
        RAISERROR('Input Failed: Vet already has a treatment scheduled at that time.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    INSERT INTO TREATMENT (treatment_id, schedule, drug_id, pet_id, staff_id)
    SELECT treatment_id, schedule, drug_id, pet_id, staff_id
    FROM inserted;
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
        RAISERROR('Invalid Data: Pet birth date cannot be in the future', 16, 1);
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
        RAISERROR('Update Denied: Product stock cannot be less than 0', 16, 1);
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