USE PetShop;

GO
CREATE PROCEDURE sp_UpdateCustomer
    @id INT,
    @name VARCHAR(100)
AS
BEGIN
    UPDATE CUSTOMER
    SET [name] = @name
    WHERE id = @id;
END

GO
CREATE PROCEDURE sp_UpdateCustContact
    @cust_id INT,
    @cust_contact VARCHAR(50),
    @new_cust_contact VARCHAR(50)
AS
BEGIN
    UPDATE CUST_CONTACT
    SET cust_contact = @new_cust_contact
    WHERE cust_id = @cust_id
        AND cust_contact = @cust_contact;
END

GO
CREATE PROCEDURE sp_UpdateProduct
    @id INT,
    @name VARCHAR(100),
    @stock INT,
    @price DECIMAL(10,2)
AS
BEGIN
    UPDATE [PRODUCT]
    SET [name] = @name,
        stock = @stock,
        price = @price
    WHERE id = @id;
END

GO
CREATE PROCEDURE sp_UpdateDrug
    @id INT,
    @name VARCHAR(100)
AS
BEGIN
    UPDATE DRUG
    SET [name] = @name
    WHERE id = @id;
END

GO
CREATE PROCEDURE sp_UpdateStaff
    @id INT,
    @name VARCHAR(100),
    @address VARCHAR(255)
AS
BEGIN
    UPDATE STAFF
    SET [name] = @name,
        [address] = @address
    WHERE id = @id;
END

GO
CREATE PROCEDURE sp_UpdateStaffAttendance
    @attendance_id INT,
    @staff_id INT,
    @login DATETIME,
    @logout DATETIME
AS
BEGIN
    UPDATE STAFF_ATTENDANCE
    SET [login] = @login,
        logout = @logout
    WHERE attendance_id = @attendance_id
        AND staff_id = @staff_id;
END

GO
CREATE PROCEDURE sp_UpdateVeterinarian
    @staff_id INT,
    @license VARCHAR(50)
AS
BEGIN
    UPDATE VETERINARIAN
    SET license = @license
    WHERE staff_id = @staff_id;
END

GO
CREATE PROCEDURE sp_UpdateCareTaker
    @staff_id INT,
    @certificate VARCHAR(50)
AS
BEGIN
    UPDATE CARE_TAKER
    SET [certificate] = @certificate
    WHERE staff_id = @staff_id;
END

GO
CREATE PROCEDURE sp_UpdateCashier
    @staff_id INT,
    @training_id VARCHAR(50)
AS
BEGIN
    UPDATE CASHIER
    SET training_id = @training_id
    WHERE staff_id = @staff_id;
END

GO
CREATE PROCEDURE sp_UpdatePet
    @id INT,
    @name VARCHAR(100),
    @species VARCHAR(50),
    @birth_date DATE,
    @cust_id INT
AS
BEGIN
    UPDATE PET
    SET [name] = @name,
        species = @species,
        birth_date = @birth_date,
        cust_id = @cust_id
    WHERE id = @id;
END

GO
CREATE PROCEDURE sp_UpdateMedicalRecord
    @id INT,
    @diagnosis TEXT,
    @prescription TEXT,
    @date DATETIME,
    @pet_id INT
AS
BEGIN
    UPDATE MEDICAL_RECORD
    SET diagnosis = @diagnosis,
        prescription = @prescription,
        [date] = @date,
        pet_id = @pet_id
    WHERE id = @id;
END

GO
CREATE PROCEDURE sp_UpdatePays
    @payment_id INT,
    @cust_id INT,
    @staff_id INT,
    @pay_method VARCHAR(50),
    @datetime DATETIME
AS
BEGIN
    UPDATE PAYS
    SET pay_method = @pay_method,
        [datetime] = @datetime
    WHERE payment_id = @payment_id
        AND cust_id = @cust_id
        AND staff_id = @staff_id;
END

GO
CREATE PROCEDURE sp_UpdateTransact
    @transact_id INT,
    @cust_id INT,
    @staff_id INT,
    @product_id INT,
    @schedule DATETIME,
    @status BIT
AS
BEGIN
    UPDATE TRANSACT
    SET schedule = @schedule,
        [status] = @status
    WHERE transact_id = @transact_id
        AND cust_id = @cust_id
        AND staff_id = @staff_id
        AND product_id = @product_id;
END

GO
CREATE PROCEDURE sp_UpdateTreatment
    @treatment_id INT,
    @drug_id INT,
    @pet_id INT,
    @staff_id INT,
    @schedule DATETIME,
    @status BIT
AS
BEGIN
    UPDATE TREATMENT
    SET schedule = @schedule,
        [status] = @status
    WHERE treatment_id = @treatment_id
        AND drug_id = @drug_id
        AND pet_id = @pet_id
        AND staff_id = @staff_id;
END

GO
CREATE PROCEDURE sp_UpdatePriceTreatmentServices
    @treatment_id INT,
    @drug_id INT,
    @pet_id INT,
    @staff_id INT,
    @type VARCHAR(100),
    @price DECIMAL(10,2)
AS
BEGIN
    UPDATE TREATMENT_SERVICES
    SET price = @price
    WHERE treatment_id = @treatment_id
        AND drug_id = @drug_id
        AND pet_id = @pet_id
        AND staff_id = @staff_id
        AND [type] = @type;
END

GO
CREATE PROCEDURE sp_UpdateServes
    @serves_id INT,
    @pet_id INT,
    @staff_id INT,
    @schedule DATETIME,
    @status BIT
AS
BEGIN
    UPDATE SERVES
    SET schedule = @schedule,
        [status] = @status
    WHERE serves_id = @serves_id
        AND pet_id = @pet_id
        AND staff_id = @staff_id;
END

GO
CREATE PROCEDURE sp_UpdatePriceServesServices
    @serves_id INT,
    @pet_id INT,
    @staff_id INT,
    @type VARCHAR(100),
    @price DECIMAL(10,2)
AS
BEGIN
    UPDATE SERVES_SERVICES
    SET price = @price
    WHERE serves_id = @serves_id
        AND pet_id = @pet_id
        AND staff_id = @staff_id
        AND [type] = @type;
END