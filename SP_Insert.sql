USE PetShop;

GO
CREATE PROCEDURE sp_InsertCustomer
    @id INT,
    @name VARCHAR(100)
AS
BEGIN
    INSERT INTO CUSTOMER (id, [name]) 
    VALUES (@id, @name);
END

GO
CREATE PROCEDURE sp_InsertCustContact
    @contact VARCHAR(50),
    @cust_id INT
AS
BEGIN
    INSERT INTO CUST_CONTACT (cust_contact, cust_id) 
    VALUES (@contact, @cust_id);
END

GO
CREATE PROCEDURE sp_InsertProduct
    @id INT,
    @name VARCHAR(100),
    @stock INT,
    @price DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO [PRODUCT] (id, [name], stock, price) 
    VALUES (@id, @name, @stock, @price);
END

GO
CREATE PROCEDURE sp_InsertDrug
    @id INT,
    @name VARCHAR(100)
AS
BEGIN
    INSERT INTO DRUG (id, [name]) 
    VALUES (@id, @name);
END

GO
CREATE PROCEDURE sp_InsertVeterinarian
    @staff_id INT,
    @name VARCHAR(100),
    @address VARCHAR(255),
    @license VARCHAR(50)
AS
BEGIN
    INSERT INTO STAFF (id, [name], [address]) VALUES (@staff_id, @name, @address);
    INSERT INTO VETERINARIAN (staff_id, license) VALUES (@staff_id, @license);
END

GO
CREATE PROCEDURE sp_InsertCareTaker
    @staff_id INT,
    @name VARCHAR(100),
    @address VARCHAR(255),
    @certificate VARCHAR(50)
AS
BEGIN
    INSERT INTO STAFF (id, [name], [address]) VALUES (@staff_id, @name, @address);
    INSERT INTO CARE_TAKER (staff_id, [certificate]) VALUES (@staff_id, @certificate);
END

GO
CREATE PROCEDURE sp_InsertCashier
    @staff_id INT,
    @name VARCHAR(100),
    @address VARCHAR(255),
    @training_id VARCHAR(50)
AS
BEGIN
    INSERT INTO STAFF (id, [name], [address]) VALUES (@staff_id, @name, @address);
    INSERT INTO CASHIER (staff_id, training_id) VALUES (@staff_id, @training_id);
END

GO
CREATE PROCEDURE sp_InsertStaffLogIn
    @staff_id INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM STAFF_ATTENDANCE WHERE staff_id = @staff_id AND logout IS NULL)
    BEGIN 
        RAISERROR('Staff is already logged in!', 16, 1);
        RETURN;
    END

    INSERT INTO STAFF_ATTENDANCE (staff_id, [login])
    VALUES (@staff_id, GETDATE());
END

GO
CREATE PROCEDURE sp_InsertStaffLogOut
    @staff_id INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM STAFF_ATTENDANCE WHERE staff_id = @staff_id AND logout IS NULL)
    BEGIN
        RAISERROR('No active shift found for this staff member.', 16, 1);
        RETURN;
    END

    UPDATE STAFF_ATTENDANCE
    SET logout = GETDATE()
    WHERE staff_id = @staff_id AND logout IS NULL;
END

GO
CREATE PROCEDURE sp_InsertPet
    @id INT,
    @name VARCHAR(100),
    @species VARCHAR(50),
    @birth_date DATE,
    @cust_id INT
AS
BEGIN
    INSERT INTO PET (id, [name], species, birth_date, cust_id) 
    VALUES (@id, @name, @species, @birth_date, @cust_id);
END

GO
CREATE PROCEDURE sp_InsertMedicalRecord
    @id INT,
    @diagnosis TEXT,
    @prescription TEXT,
    @date DATETIME,
    @pet_id INT
AS
BEGIN
    INSERT INTO MEDICAL_RECORD (id, diagnosis, prescription, [date], pet_id) 
    VALUES (@id, @diagnosis, @prescription, @date, @pet_id);
END

GO
CREATE PROCEDURE sp_InsertTreatment
    @treatment_id INT,
    @drug_id INT,
    @pet_id INT,
    @vet_id INT,
    @schedule DATETIME,
    @status BIT
AS
BEGIN
    INSERT INTO TREATMENT (treatment_id, drug_id, pet_id, staff_id, schedule, [status]) 
    VALUES (@treatment_id, @drug_id, @pet_id, @vet_id, @schedule, @status);
END

GO
CREATE PROCEDURE sp_InsertTreatmentService
    @treatment_id INT,
    @drug_id INT,
    @pet_id INT,
    @staff_id INT,
    @type VARCHAR(100),
    @price DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO TREATMENT_SERVICES (treatment_id, drug_id, pet_id, staff_id, [type], price)
    VALUES (@treatment_id, @drug_id, @pet_id, @staff_id, @type, @price);
END

GO
CREATE PROCEDURE sp_InsertServes
    @serves_id INT,
    @pet_id INT,
    @staff_id INT,
    @schedule DATETIME,
    @status BIT
AS
BEGIN
    INSERT INTO SERVES (serves_id, pet_id, staff_id, schedule, [status]) 
    VALUES (@serves_id, @pet_id, @staff_id, @schedule, @status);
END

GO
CREATE PROCEDURE sp_InsertServesService
    @serves_id INT,
    @pet_id INT,
    @staff_id INT,
    @type VARCHAR(100),
    @price DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO SERVES_SERVICES (serves_id, pet_id, staff_id, [type], price)
    VALUES (@serves_id, @pet_id, @staff_id, @type, @price);
END

GO
ALTER PROCEDURE sp_InsertTransact
    @transact_id INT,
    @cust_id INT,
    @staff_id INT,
    @product_id INT,
    @status BIT
AS
BEGIN
    IF NOT EXISTS(
        SELECT 1 
        FROM STAFF_ATTENDANCE 
        WHERE staff_id = @staff_id
            AND CAST(login AS DATE) = CAST(GETDATE() AS DATE)
            AND login <= GETDATE()
    )
    BEGIN
        RAISERROR('Staff has not logged in today!', 16, 1);
        RETURN;
    END;
    
    IF (SELECT stock FROM [PRODUCT] WHERE id = @product_id) <= 0
    BEGIN
        RAISERROR('Insufficient stock!', 16, 1);
        RETURN;
    END;

    BEGIN TRANSACTION;
    BEGIN TRY
        INSERT INTO TRANSACT (transact_id, cust_id, staff_id, product_id, schedule, [status])
        VALUES (@transact_id, @cust_id, @staff_id, @product_id, GETDATE(), @status);

        UPDATE [PRODUCT]
        SET stock = stock - 1
        WHERE id = @product_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH
END;

GO
CREATE PROCEDURE sp_InsertPays
    @payment_id INT,
    @pay_method VARCHAR(50),
    @cust_id INT,
    @staff_id INT
AS
BEGIN
    IF NOT EXISTS(
        SELECT 1 
        FROM STAFF_ATTENDANCE 
        WHERE staff_id = @staff_id
            AND CAST(login AS DATE) = CAST(GETDATE() AS DATE)
            AND login <= GETDATE()
    )
    BEGIN
        RAISERROR('Staff has not logged in today!', 16, 1);
        RETURN;
    END;

    INSERT INTO PAYS (payment_id, pay_method, [datetime], cust_id, staff_id) 
    VALUES (@payment_id, @pay_method, GETDATE(), @cust_id, @staff_id);
END