USE PetShop;

-- View total bill all customer
GO
CREATE VIEW view_TotalBill
AS
SELECT
	c.id AS customer_id,
	c.[name] AS customer_name,

	dbo.fn_TotalTransact(c.id) AS total_transact,
	dbo.fn_TotalTreatment(c.id) AS total_treatment,
	dbo.fn_TotalServes(c.id) AS total_serves,

	dbo.fn_TotalTransact(c.id) + dbo.fn_TotalTreatment(c.id)
	+ dbo.fn_TotalServes(c.id) AS total_bill
FROM CUSTOMER c;

-- View products that are low in stock
GO
CREATE VIEW view_LowStockProducts
AS
SELECT
    id AS product_id,
    [name] AS product_name,
    stock,
    price
FROM [PRODUCT]
WHERE stock < 10;

-- View today's vet schedule
GO
CREATE VIEW view_TodayVetSchedule
AS
SELECT
    t.treatment_id,
    v.staff_id AS vet_id,
    s.[name] AS vet_name,
    p.[name] AS pet_name,
    t.schedule,
    d.[name] AS drug_used,
    t.[status] AS treatment_status
FROM TREATMENT t
JOIN VETERINARIAN v ON v.staff_id = t.staff_id
JOIN STAFF s ON s.id = v.staff_id
JOIN PET p ON p.id = t.pet_id
LEFT JOIN DRUG d ON d.id = t.drug_id
WHERE CAST(t.schedule AS DATE) = CAST(GETDATE() AS DATE);

-- Execution
SELECT * FROM view_TotalBill;
SELECT * FROM view_TotalBill WHERE customer_id = 3;
SELECT * FROM view_TotalBill ORDER BY total_bill DESC;
SELECT * FROM view_LowStockProducts;
SELECT * FROM view_TodayVetSchedule;
SELECT * FROM view_TodayVetSchedule WHERE vet_id = 3;