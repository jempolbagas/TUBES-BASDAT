USE PetShop;

-- Function to count age of pet from pet birth date
GO
CREATE FUNCTION fn_PetAge(@pet_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @age INT,
            @birth DATE;

    SELECT @birth = birth_date FROM PET WHERE id = @pet_id;

    IF @birth IS NULL RETURN NULL;

    SET @age = DATEDIFF(YEAR, @birth, GETDATE());

    IF (MONTH(@birth) > MONTH(GETDATE()))
    OR (MONTH(@birth) = MONTH(GETDATE())
        AND DAY(@birth) > DAY(GETDATE())
    )
    BEGIN
        SET @age = @age - 1;
    END

    RETURN @age;
END;

-- Function to count total transact price of a specific customer
GO
CREATE FUNCTION fn_TotalTransact(@cust_id INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = SUM(p.price)
    FROM TRANSACT t
    JOIN [PRODUCT] p ON t.product_id = p.id
    WHERE t.cust_id = @cust_id 
    AND t.[status] = 0;

    RETURN ISNULL(@total, 0);
END;

-- Function to count total treatment price of a specific customer
GO
CREATE FUNCTION fn_TotalTreatment(@cust_id INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = SUM(ts.price)
    FROM PET p
    JOIN TREATMENT t ON t.pet_id = p.id
    JOIN TREATMENT_SERVICES ts 
        ON ts.treatment_id = t.treatment_id
        AND ts.drug_id = t.drug_id
        AND ts.pet_id = t.pet_id
        AND ts.staff_id = t.staff_id
    WHERE 
        p.cust_id = @cust_id 
        AND t.[status] = 0 
        AND CAST(t.schedule AS DATE) = CAST(GETDATE() AS DATE);

    RETURN ISNULL(@total, 0);
END;

-- Function to count total serves price of a specific customer
GO
CREATE FUNCTION fn_TotalServes(@cust_id INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = SUM(ss.price)
    FROM PET p
    JOIN SERVES s ON s.pet_id = p.id
    JOIN SERVES_SERVICES ss 
        ON ss.serves_id = s.serves_id
        AND ss.pet_id = s.pet_id
        AND ss.staff_id = s.staff_id
    WHERE 
        p.cust_id = @cust_id 
        AND s.[status] = 0 
        AND CAST(s.schedule AS DATE) = CAST(GETDATE() AS DATE);

    RETURN ISNULL(@total, 0);
END;

-- Execution
SELECT dbo.fn_PetAge(3) AS pet_age;
SELECT dbo.fn_TotalTransact(1) AS total_transact;
SELECT dbo.fn_TotalTreatment(1) AS total_transact;
SELECT dbo.fn_TotalServes(1) AS total_serves;