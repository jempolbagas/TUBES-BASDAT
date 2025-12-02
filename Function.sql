USE PetShop

GO
CREATE FUNCTION GetPetAge(@pet_id INT)
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
CREATE FUNCTION GetTotalTransact(@cust_id INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = SUM(p.price)
    FROM TRANSACT t
    JOIN [PRODUCT] p ON t.product_id = p.id
    WHERE t.cust_id = @cust_id;

    RETURN ISNULL(@total, 0);
END;

GO
CREATE FUNCTION GetTotalTreatment(@cust_id INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = SUM(ts.price)
    FROM PET p
    JOIN TREATMENT t ON t.pet_id = pet_id
    JOIN TREATMENT_SERVICES ts ON ts.treatment_id = t.treatment_id
    WHERE p.cust_id = @cust_id;

    RETURN ISNULL(@total, 0);
END;

GO
CREATE FUNCTION GetTotalServes(@cust_id INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = SUM(ss.price)
    FROM PET p
    JOIN SERVES s ON s.pet_id = p.id
    JOIN SERVES_SERVICES ss ON ss.serves_id = s.serves_id
    WHERE p.cust_id = @cust_id;

    RETURN ISNULL(@total, 0);
END;