USE PetShop

GO
<<<<<<< HEAD
CREATE FUNCTION fn_PetAge(@pet_id INT)
=======
CREATE FUNCTION GetPetAge(@pet_id INT)
>>>>>>> edf4001c2eb6429774a1a9338884f49dcf034b14
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

GO
<<<<<<< HEAD
CREATE FUNCTION fn_TotalTransact(@cust_id INT)
=======
CREATE FUNCTION GetTotalTransact(@cust_id INT)
>>>>>>> edf4001c2eb6429774a1a9338884f49dcf034b14
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = SUM(p.price)
    FROM TRANSACT t
    JOIN [PRODUCT] p ON t.product_id = p.id
<<<<<<< HEAD
    WHERE t.cust_id = @cust_id AND t.[status] = 0;
=======
    WHERE t.cust_id = @cust_id;
>>>>>>> edf4001c2eb6429774a1a9338884f49dcf034b14

    RETURN ISNULL(@total, 0);
END;

GO
<<<<<<< HEAD
CREATE FUNCTION fn_TotalTreatment(@cust_id INT)
=======
CREATE FUNCTION GetTotalTreatment(@cust_id INT)
>>>>>>> edf4001c2eb6429774a1a9338884f49dcf034b14
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = SUM(ts.price)
    FROM PET p
    JOIN TREATMENT t ON t.pet_id = pet_id
    JOIN TREATMENT_SERVICES ts ON ts.treatment_id = t.treatment_id
<<<<<<< HEAD
    WHERE p.cust_id = @cust_id AND t.[status] = 0;
=======
    WHERE p.cust_id = @cust_id;
>>>>>>> edf4001c2eb6429774a1a9338884f49dcf034b14

    RETURN ISNULL(@total, 0);
END;

GO
<<<<<<< HEAD
CREATE FUNCTION fn_TotalServes(@cust_id INT)
=======
CREATE FUNCTION GetTotalServes(@cust_id INT)
>>>>>>> edf4001c2eb6429774a1a9338884f49dcf034b14
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = SUM(ss.price)
    FROM PET p
    JOIN SERVES s ON s.pet_id = p.id
    JOIN SERVES_SERVICES ss ON ss.serves_id = s.serves_id
<<<<<<< HEAD
    WHERE p.cust_id = @cust_id AND s.[status] = 0;

    RETURN ISNULL(@total, 0);
END;

SELECT dbo.fn_PetAge(3) AS pet_age;
SELECT dbo.fn_TotalTransact(1) AS total_transact;
SELECT dbo.fn_TotalTreatment(1) AS total_transact;
SELECT dbo.fn_TotalServes(1) AS total_serves;
=======
    WHERE p.cust_id = @cust_id;

    RETURN ISNULL(@total, 0);
END;
>>>>>>> edf4001c2eb6429774a1a9338884f49dcf034b14
