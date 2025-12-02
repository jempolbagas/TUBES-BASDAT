USE PetShop
GO

CREATE PROCEDURE sp_RegisterNewCustomerWithPet
    @cust_id INT,
    @cust_name VARCHAR(100),
    @cust_contact VARCHAR(50),

    @pet_id INT,
    @pet_name VARCHAR(100),
    @pet_species VARCHAR(50),
    @pet_birth DATE
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        INSERT INTO CUSTOMER (id, [name]) 
        VALUES (@cust_id, @cust_name);

        
        INSERT INTO CUST_CONTACT (cust_contact, cust_id) 
        VALUES (@cust_contact, @cust_id);


        INSERT INTO PET (id, [name], species, birth_date, cust_id) 
        VALUES (@pet_id, @pet_name, @pet_species, @pet_birth, @cust_id);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO


CREATE PROCEDURE sp_RescheduleTreatment
    @treatment_id INT,
    @new_schedule DATETIME,
    @vet_id INT 
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN 
        IF NOT EXISTS (
            SELECT 1 FROM STAFF_ATTENDANCE 
            WHERE staff_id = @vet_id 
            AND CONVERT(DATE, [login]) = CONVERT(DATE, @new_schedule)
        )
        BEGIN
            RAISERROR('The Veterinarian is not scheduled to work on this date.', 16, 1);
        END

        
        IF EXISTS (
            SELECT 1 FROM TREATMENT 
            WHERE staff_id = @vet_id 
            AND schedule = @new_schedule 
            AND treatment_id <> @treatment_id
        )
        BEGIN
            RAISERROR('The Veterinarian already has another treatment scheduled at this time.', 16, 1);
        END

        
        UPDATE TREATMENT
        SET schedule = @new_schedule,
            staff_id = @vet_id
        WHERE treatment_id = @treatment_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO


CREATE PROCEDURE sp_ApplySeasonalProductDiscount
    @partial_name VARCHAR(50), -- e.g., 'Whiskas'
    @discount_percentage DECIMAL(5, 2) -- e.g., 0.10 for 10%
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        
        IF NOT EXISTS (SELECT 1 FROM [PRODUCT] WHERE [name] LIKE '%' + @partial_name + '%')
        BEGIN
            RAISERROR('No products found matching the criteria.', 16, 1);
        END

        UPDATE [PRODUCT]
        SET price = price - (price * @discount_percentage)
        WHERE [name] LIKE '%' + @partial_name + '%';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO


CREATE PROCEDURE sp_GetStaffPerformanceReport
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SELECT 
        s.id AS StaffID,
        s.[name] AS StaffName,

        (SELECT COUNT(*) FROM TRANSACT t 
         WHERE t.staff_id = s.id) AS TotalTransactions,

        (SELECT COUNT(*) FROM TREATMENT tr 
         WHERE tr.staff_id = s.id AND tr.schedule BETWEEN @start_date AND @end_date) AS TotalTreatments,

        (SELECT COUNT(*) FROM SERVES sv 
         WHERE sv.staff_id = s.id AND sv.schedule BETWEEN @start_date AND @end_date) AS TotalServes
    FROM STAFF s
    ORDER BY TotalTransactions DESC, TotalTreatments DESC;
END;
GO