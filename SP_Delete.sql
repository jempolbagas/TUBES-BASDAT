USE PetShop

GO
CREATE PROCEDURE sp_DeleteCustomer
    @id INT
AS
BEGIN
    DELETE FROM CUSTOMER
    WHERE id = @id;
END

GO
CREATE PROCEDURE sp_DeleteCustContact
    @cust_contact VARCHAR(50)
AS
BEGIN
    DELETE FROM CUST_CONTACT
    WHERE cust_contact = @cust_contact;
END

GO
CREATE PROCEDURE sp_DeleteProduct
    @id INT
AS
BEGIN
    DELETE FROM [PRODUCT]
    WHERE id = @id;
END

GO
CREATE PROCEDURE sp_DeleteDrug
    @id INT
AS
BEGIN
    DELETE FROM DRUG
    WHERE id = @id;
END

GO
CREATE PROCEDURE sp_DeleteStaff
    @id INT
AS
BEGIN
    DELETE FROM STAFF
    WHERE id = @id;
END

GO
CREATE PROCEDURE sp_DeleteStaffAttendance
    @login DATETIME
AS
BEGIN
    DELETE FROM STAFF_ATTENDANCE
    WHERE [login] = @login;
END

GO
CREATE PROCEDURE sp_DeleteVeterinarian
    @staff_id INT
AS
BEGIN
    DELETE FROM VETERINARIAN
    WHERE staff_id = @staff_id;
END

GO
CREATE PROCEDURE sp_DeleteCareTaker
    @staff_id INT
AS
BEGIN
    DELETE FROM CARE_TAKER
    WHERE staff_id = @staff_id;
END

GO
CREATE PROCEDURE sp_DeleteCashier
    @staff_id INT
AS
BEGIN
    DELETE FROM CASHIER
    WHERE staff_id = @staff_id;
END

GO
CREATE PROCEDURE sp_DeletePet
    @id INT
AS
BEGIN
    DELETE FROM PET
    WHERE id = @id;
END

GO
CREATE PROCEDURE sp_DeleteMedicalRecord
    @id INT
AS
BEGIN
    DELETE FROM MEDICAL_RECORD
    WHERE id = @id;
END

GO
CREATE PROCEDURE sp_DeletePays
    @payment_id INT
AS
BEGIN
    DELETE FROM PAYS
    WHERE payment_id = @payment_id;
END

GO
CREATE PROCEDURE sp_DeleteTransact
    @cust_id INT
AS
BEGIN
    DELETE FROM TRANSACT
    WHERE cust_id = @cust_id;
END

GO
CREATE PROCEDURE sp_DeleteTreatment
    @treatment_id INT
AS
BEGIN
    DELETE FROM TREATMENT
    WHERE treatment_id = @treatment_id;
END

GO
CREATE PROCEDURE sp_DeleteTreatmentServices
    @treatment_id INT
AS
BEGIN
    DELETE FROM TREATMENT_SERVICES
    WHERE treatment_id = @treatment_id;
END

GO
CREATE PROCEDURE sp_DeleteServes
    @serves_id INT
AS
BEGIN
    DELETE FROM SERVES
    WHERE serves_id = @serves_id;
END

GO
CREATE PROCEDURE sp_DeleteServesServices
    @serves_id INT
AS
BEGIN
    DELETE FROM SERVES_SERVICES
    WHERE serves_id = @serves_id;
END