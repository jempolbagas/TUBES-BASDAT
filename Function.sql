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
CREATE FUNCTION GetTotalTransact(
    @cust_id INT,
    @staff_id INT,
    @product_id INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = price
    FROM [PRODUCT]
    WHERE id = @product_id;

    RETURN @total;
END;

GO
CREATE FUNCTION GetTotalTreatment(@treatment_id INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = SUM(price)
    FROM TREATMENT_SERVICES
    WHERE treatment_id = @treatment_id;

    RETURN @total;
END;

GO
CREATE FUNCTION GetTotalServes(@serves_id INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = SUM(price)
    FROM SERVES_SERVICES
    WHERE serves_id = @serves_id;

    RETURN @total;
END;