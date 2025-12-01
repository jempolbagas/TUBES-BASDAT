USE PetShop

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
    COMMIT;
END

GO
CREATE PROCEDURE sp_InsertStaffAttendance
    @login DATETIME,
    @logout DATETIME,
    @staff_id INT
AS
BEGIN
    INSERT INTO STAFF_ATTENDANCE ([login], logout, staff_id) VALUES (@login, @logout, @staff_id);
    COMMIT;
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
    @schedule DATETIME,
    @drug_id INT,
    @pet_id INT,
    @vet_id INT
AS
BEGIN

    IF NOT EXISTS(
        SELECT 1 
        FROM STAFF_ATTENDANCE 
        WHERE staff_id = @vet_id
            AND CONVERT(date, login) = CONVERT(date, GETDATE())
            AND login <= GETDATE()
    )
    BEGIN
        RAISERROR('Vet Has Not Logged In!', 16, 1);
        RETURN;
    END;

    BEGIN TRANSACTION;

    BEGIN TRY
        INSERT INTO TREATMENT (treatment_id, schedule, drug_id, pet_id, staff_id) 
        VALUES (@treatment_id, @schedule, @drug_id, @pet_id, @vet_id);
        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH
END

GO
CREATE PROCEDURE sp_InsertTreatmentService
    @treatment_id INT,
    @type VARCHAR(100),
    @price DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO TREATMENT_SERVICES (treatment_id, [type], price) 
    VALUES (@treatment_id, @type, @price);
END

GO
CREATE PROCEDURE sp_InsertServes
    @serves_id INT,
    @schedule DATETIME,
    @pet_id INT,
    @staff_id INT
AS
BEGIN

    IF NOT EXISTS(
        SELECT 1 
        FROM STAFF_ATTENDANCE 
        WHERE staff_id = @staff_id
            AND CONVERT(date, login) = CONVERT(date, GETDATE())
            AND login <= GETDATE()
    )
    BEGIN
        RAISERROR('Staff Has Not Logged In!', 16, 1);
        RETURN;
    END;

    BEGIN TRANSACTION;

    BEGIN TRY
        INSERT INTO SERVES (serves_id, schedule, pet_id, staff_id) 
        VALUES (@serves_id, @schedule, @pet_id, @staff_id);
        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH
END

GO
CREATE PROCEDURE sp_InsertServesService
    @serves_id INT,
    @type VARCHAR(100),
    @price DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO SERVES_SERVICES (serves_id, [type], price) 
    VALUES (@serves_id, @type, @price);
END

GO
CREATE PROCEDURE sp_InsertPays
    @payment_id INT,
    @pay_method VARCHAR(50),
    @datetime DATETIME,
    @cust_id INT,
    @staff_id INT
AS
BEGIN
    INSERT INTO PAYS (payment_id, pay_method, [datetime], cust_id, staff_id) 
    VALUES (@payment_id, @pay_method, @datetime, @cust_id, @staff_id);
END

GO
CREATE PROCEDURE sp_InsertTransact
    @cust_id INT,
    @staff_id INT,
    @product_id INT
AS
BEGIN

    IF NOT EXISTS(
        SELECT 1 
        FROM STAFF_ATTENDANCE 
        WHERE staff_id = @staff_id
            AND CONVERT(date, login) = CONVERT(date, GETDATE())
            AND login <= GETDATE()
    )
    BEGIN
        RAISERROR('Staff Has Not Logged In!', 16, 1);
        RETURN;
    END;
    
    IF (SELECT stock FROM [PRODUCT] WHERE id = @product_id) <= 0
    BEGIN
        RAISERROR('Insufficient Stock!', 16, 1);
        RETURN;
    END;

    BEGIN TRANSACTION;

    BEGIN TRY
        INSERT INTO TRANSACT (cust_id, staff_id, product_id) 
        VALUES (@cust_id, @staff_id, @product_id);

        UPDATE [PRODUCT]
        SET stock = stock - 1
        WHERE id = @product_id;
        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH
END;