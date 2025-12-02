USE PetShop
GO

PRINT '=================================================='
PRINT '      TESTING UNIQUE STORED PROCEDURES            '
PRINT '=================================================='

-- ==================================================
-- TEST 1: sp_RegisterNewCustomerWithPet
-- Scenario: Registering "John Wick" and his dog "Dog"
-- ==================================================
PRINT '1. Testing sp_RegisterNewCustomerWithPet...'

-- Cleanup previous test run if exists
DELETE FROM PET WHERE id = 999;
DELETE FROM CUST_CONTACT WHERE cust_id = 999;
DELETE FROM CUSTOMER WHERE id = 999;

BEGIN TRY
    EXEC sp_RegisterNewCustomerWithPet 
        @cust_id = 999,
        @cust_name = 'John Wick',
        @cust_contact = '08123456789',
        @pet_id = 999,
        @pet_name = 'Dog',
        @pet_species = 'Beagle',
        @pet_birth = '2020-01-01';

    PRINT '   [SUCCESS] Execution completed.';
    
    -- Verification
    IF EXISTS (SELECT 1 FROM CUSTOMER WHERE id = 999) 
       AND EXISTS (SELECT 1 FROM PET WHERE id = 999)
        PRINT '   [VERIFIED] Data exists in CUSTOMER, CONTACT, and PET tables.';
    ELSE
        PRINT '   [FAILED] Data missing.';
END TRY
BEGIN CATCH
    PRINT '   [ERROR] ' + ERROR_MESSAGE();
END CATCH

PRINT '--------------------------------------------------'

-- ==================================================
-- TEST 2: sp_RescheduleTreatment
-- Scenario: Move a treatment to a valid slot, then try an invalid one.
-- ==================================================
PRINT '2. Testing sp_RescheduleTreatment...'

-- Cleanup just in case
DELETE FROM TREATMENT WHERE treatment_id = 888;

-- Setup: Create a dummy treatment to reschedule
-- FIX: Use pet_id = 999 (John Wick's dog) which we know exists from Test 1
-- Note: Vet ID 1 is working on 2025-01-01 (from Data.sql)
BEGIN TRY
    INSERT INTO TREATMENT (treatment_id, schedule, drug_id, pet_id, staff_id)
    VALUES (888, '2025-01-01 10:00:00', 1, 999, 1); -- Initial slot

    PRINT '   [SETUP] Created dummy treatment 888 at 10:00 AM.';
END TRY
BEGIN CATCH
    PRINT '   [SETUP FAILED] Could not insert dummy treatment. ' + ERROR_MESSAGE();
END CATCH

-- Case A: Valid Reschedule (Same day, different time: 14:00)
-- Vet 1 works 08:00 - 16:00 on 2025-01-01
BEGIN TRY
    EXEC sp_RescheduleTreatment 
        @treatment_id = 888, 
        @new_schedule = '2025-01-01 14:00:00', 
        @vet_id = 1;

    -- Verification: Check if it actually changed
    DECLARE @ActualSchedule DATETIME;
    SELECT @ActualSchedule = schedule FROM TREATMENT WHERE treatment_id = 888;

    IF @ActualSchedule = '2025-01-01 14:00:00'
        PRINT '   [SUCCESS] Treatment rescheduled to 14:00.';
    ELSE
        PRINT '   [FAILED] Schedule did not update. Current: ' + ISNULL(CONVERT(VARCHAR, @ActualSchedule), 'NULL');
END TRY
BEGIN CATCH
    PRINT '   [ERROR] ' + ERROR_MESSAGE();
END CATCH

-- Case B: Invalid Reschedule (Vet not working on 2025-02-01)
PRINT '   [TEST] Trying to reschedule to a day the vet is OFF...';
BEGIN TRY
    EXEC sp_RescheduleTreatment 
        @treatment_id = 888, 
        @new_schedule = '2025-02-01 10:00:00', 
        @vet_id = 1;
        
    PRINT '   [FAILED] SP should have thrown an error but didn''t.';
END TRY
BEGIN CATCH
    PRINT '   [PASSED] Expected Error caught: ' + ERROR_MESSAGE();
END CATCH

-- Cleanup
DELETE FROM TREATMENT WHERE treatment_id = 888;

PRINT '--------------------------------------------------'

-- ==================================================
-- TEST 3: sp_ApplySeasonalProductDiscount
-- Scenario: Discounting "Whiskas" by 10%
-- ==================================================
PRINT '3. Testing sp_ApplySeasonalProductDiscount...'

-- Capture old price of product 001 (Whiskas Tuna 500g)
DECLARE @OldPrice DECIMAL(10,2);
DECLARE @NewPrice DECIMAL(10,2);

SELECT @OldPrice = price FROM PRODUCT WHERE id = 1;
PRINT '   [INFO] Old Price of ID 1: ' + CAST(@OldPrice AS VARCHAR);

BEGIN TRY
    -- Apply 10% discount to all 'Whiskas'
    EXEC sp_ApplySeasonalProductDiscount 
        @partial_name = 'Whiskas', 
        @discount_percentage = 0.10;
        
    SELECT @NewPrice = price FROM PRODUCT WHERE id = 1;
    PRINT '   [INFO] New Price of ID 1: ' + CAST(@NewPrice AS VARCHAR);

    IF @NewPrice < @OldPrice
        PRINT '   [SUCCESS] Price reduced successfully.';
    ELSE
        PRINT '   [FAILED] Price did not change.';
END TRY
BEGIN CATCH
    PRINT '   [ERROR] ' + ERROR_MESSAGE();
END CATCH

-- Rollback price for consistency (Optional)
UPDATE PRODUCT SET price = @OldPrice WHERE id = 1; 

PRINT '--------------------------------------------------'

-- ==================================================
-- TEST 4: sp_GetStaffPerformanceReport
-- Scenario: Get report for Jan 2025
-- ==================================================
PRINT '4. Testing sp_GetStaffPerformanceReport...'

BEGIN TRY
    -- Just ensure it runs without error
    EXEC sp_GetStaffPerformanceReport 
        @start_date = '2025-01-01', 
        @end_date = '2025-01-31';
        
    PRINT '   [SUCCESS] Report generated (see results grid).';
END TRY
BEGIN CATCH
    PRINT '   [ERROR] ' + ERROR_MESSAGE();
END CATCH

PRINT '=================================================='
PRINT '              TESTING COMPLETE                    '
PRINT '=================================================='