USE PetShop
GO

-- =============================================
-- 1. sp_RegisterNewCustomerWithPet
-- Description: Streamlines onboarding by adding Customer, Contact, and Pet in one transaction.
-- =============================================
CREATE PROCEDURE sp_RegisterNewCustomerWithPet
    -- Customer Info
    @cust_id INT,
    @cust_name VARCHAR(100),
    @cust_contact VARCHAR(50),
    -- Pet Info
    @pet_id INT,
    @pet_name VARCHAR(100),
    @pet_species VARCHAR(50),
    @pet_birth DATE
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- 1. Insert Customer
        INSERT INTO CUSTOMER (id, [name]) 
        VALUES (@cust_id, @cust_name);

        -- 2. Insert Contact
        INSERT INTO CUST_CONTACT (cust_contact, cust_id) 
        VALUES (@cust_contact, @cust_id);

        -- 3. Insert Pet
        INSERT INTO PET (id, [name], species, birth_date, cust_id) 
        VALUES (@pet_id, @pet_name, @pet_species, @pet_birth, @cust_id);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Re-throw error for the application to handle
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- =============================================
-- 2. sp_RescheduleTreatment
-- Description: Reschedules a vet appointment while ensuring the vet is working and not double-booked.
-- =============================================
CREATE PROCEDURE sp_RescheduleTreatment
    @treatment_id INT,
    @new_schedule DATETIME,
    @vet_id INT -- Optional: Can be used to change the vet too
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- 1. Validate: Is the Vet logged in/working during the new schedule?
        IF NOT EXISTS (
            SELECT 1 FROM STAFF_ATTENDANCE 
            WHERE staff_id = @vet_id 
            AND CONVERT(DATE, [login]) = CONVERT(DATE, @new_schedule)
        )
        BEGIN
            RAISERROR('The Veterinarian is not scheduled to work on this date.', 16, 1);
        END

        -- 2. Validate: Is the Vet already busy at that specific time?
        IF EXISTS (
            SELECT 1 FROM TREATMENT 
            WHERE staff_id = @vet_id 
            AND schedule = @new_schedule 
            AND treatment_id <> @treatment_id
        )
        BEGIN
            RAISERROR('The Veterinarian already has another treatment scheduled at this time.', 16, 1);
        END

        -- 3. Update the Schedule
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

-- =============================================
-- 3. sp_ApplySeasonalProductDiscount
-- Description: Applies a percentage discount to a category of products (by name) in bulk.
-- =============================================
CREATE PROCEDURE sp_ApplySeasonalProductDiscount
    @partial_name VARCHAR(50), -- e.g., 'Whiskas'
    @discount_percentage DECIMAL(5, 2) -- e.g., 0.10 for 10%
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if any products match
        IF NOT EXISTS (SELECT 1 FROM [PRODUCT] WHERE [name] LIKE '%' + @partial_name + '%')
        BEGIN
            RAISERROR('No products found matching the criteria.', 16, 1);
        END

        -- Apply Discount
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

-- =============================================
-- 4. sp_GetStaffPerformanceReport
-- Description: Generates a report of staff activity (transactions, treatments, or care services)
-- =============================================
CREATE PROCEDURE sp_GetStaffPerformanceReport
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SELECT 
        s.id AS StaffID,
        s.[name] AS StaffName,
        -- Count Transactions (Cashier)
        (SELECT COUNT(*) FROM TRANSACT t 
         WHERE t.staff_id = s.id) AS TotalTransactions,
        -- Count Treatments (Vet)
        (SELECT COUNT(*) FROM TREATMENT tr 
         WHERE tr.staff_id = s.id AND tr.schedule BETWEEN @start_date AND @end_date) AS TotalTreatments,
        -- Count Serves (CareTaker)
        (SELECT COUNT(*) FROM SERVES sv 
         WHERE sv.staff_id = s.id AND sv.schedule BETWEEN @start_date AND @end_date) AS TotalServes
    FROM STAFF s
    ORDER BY TotalTransactions DESC, TotalTreatments DESC;
END;
GO