CREATE DATABASE PetShop;
USE PetShop;

CREATE TABLE CUSTOMER (
    id INT PRIMARY KEY ,
    [name] VARCHAR(100)
);

CREATE TABLE CUST_CONTACT (
    cust_contact VARCHAR(50), 
    cust_id INT,
    
    PRIMARY KEY (cust_contact, cust_id), 
    FOREIGN KEY (cust_id) REFERENCES CUSTOMER(id) ON DELETE CASCADE
);

CREATE TABLE [PRODUCT] (
    id INT PRIMARY KEY,
    [name] VARCHAR(100),
    stock INT,
    price DECIMAL(10, 2)
);

CREATE TABLE DRUG (
    id INT PRIMARY KEY,
    [name] VARCHAR(100)
);

CREATE TABLE STAFF (
    id INT PRIMARY KEY,
    [name] VARCHAR(100),
    [address] VARCHAR(255)
);

CREATE TABLE STAFF_ATTENDANCE (
    attendance_id INT,
    staff_id INT,
    [login] DATETIME,
    logout DATETIME,

    PRIMARY KEY (attendance_id, staff_id),
    FOREIGN KEY (staff_id) REFERENCES STAFF(id) ON DELETE CASCADE
);

CREATE TABLE VETERINARIAN (
    staff_id INT PRIMARY KEY, 
    license VARCHAR(50),
    
    FOREIGN KEY (staff_id) REFERENCES STAFF(id) ON DELETE CASCADE
);

CREATE TABLE CARE_TAKER (
    staff_id INT PRIMARY KEY,
    [certificate] VARCHAR(50),
    
    FOREIGN KEY (staff_id) REFERENCES STAFF(id) ON DELETE CASCADE
);

CREATE TABLE CASHIER (
    staff_id INT PRIMARY KEY,
    training_id VARCHAR(50),
    
    FOREIGN KEY (staff_id) REFERENCES STAFF(id) ON DELETE CASCADE
);

CREATE TABLE PET (
    id INT PRIMARY KEY,
    [name] VARCHAR(100),
    species VARCHAR(50),
    birth_date DATE,
    cust_id INT,
    
    FOREIGN KEY (cust_id) REFERENCES CUSTOMER(id) ON DELETE CASCADE
);

CREATE TABLE MEDICAL_RECORD (
    id INT PRIMARY KEY,
    diagnosis TEXT,
    prescription TEXT,
    [date] DATETIME,
    pet_id INT,
    
    FOREIGN KEY (pet_id) REFERENCES PET(id) ON DELETE CASCADE
);

CREATE TABLE PAYS (
    payment_id INT,
    cust_id INT,
    staff_id INT,
    pay_method VARCHAR(50),
    [datetime] DATETIME,
    
    PRIMARY KEY (payment_id, cust_id, staff_id),
    FOREIGN KEY (cust_id) REFERENCES CUSTOMER(id),
    FOREIGN KEY (staff_id) REFERENCES CASHIER(staff_id)
);

CREATE TABLE TRANSACT (
    transact_id INT,
    cust_id INT,
    staff_id INT,  
    product_id INT,
    schedule DATETIME,
    [status] BIT,
    
    PRIMARY KEY (transact_id, cust_id, staff_id, product_id),
    FOREIGN KEY (cust_id) REFERENCES CUSTOMER(id),
    FOREIGN KEY (staff_id) REFERENCES CASHIER(staff_id),
    FOREIGN KEY (product_id) REFERENCES [PRODUCT](id)
);

CREATE TABLE TREATMENT (
    treatment_id INT,
    drug_id INT,
    pet_id INT,
    staff_id INT, 
    schedule DATETIME,
    [status] BIT,
    
    PRIMARY KEY (treatment_id, drug_id, pet_id, staff_id),
    FOREIGN KEY (drug_id) REFERENCES DRUG(id),
    FOREIGN KEY (pet_id) REFERENCES PET(id),
    FOREIGN KEY (staff_id) REFERENCES VETERINARIAN(staff_id)
);

CREATE TABLE TREATMENT_SERVICES (
    treatment_id INT,
    drug_id INT,
    pet_id INT,
    staff_id INT, 
    [type] VARCHAR(100), 
    price DECIMAL(10, 2),

    PRIMARY KEY (treatment_id, drug_id, pet_id, staff_id, [type]), 
    FOREIGN KEY (treatment_id, drug_id, pet_id, staff_id) 
    REFERENCES TREATMENT(treatment_id, drug_id, pet_id, staff_id) 
    ON DELETE CASCADE
);

CREATE TABLE SERVES (
    serves_id INT,
    pet_id INT,
    staff_id INT,
    schedule DATETIME,
    [status] BIT,
    
    PRIMARY KEY (serves_id, pet_id, staff_id),
    FOREIGN KEY (pet_id) REFERENCES PET(id),
    FOREIGN KEY (staff_id) REFERENCES CARE_TAKER(staff_id)
);

CREATE TABLE SERVES_SERVICES (
    serves_id INT,
    pet_id INT,
    staff_id INT,
    [type] VARCHAR(100), 
    price DECIMAL(10, 2),
    
    PRIMARY KEY (serves_id, pet_id, staff_id, [type]),
    FOREIGN KEY (serves_id, pet_id, staff_id) 
    REFERENCES SERVES(serves_id, pet_id, staff_id) 
    ON DELETE CASCADE
);

SELECT * FROM CUSTOMER
SELECT * FROM CUST_CONTACT
SELECT * FROM STAFF
SELECT * FROM STAFF_ATTENDANCE
SELECT * FROM CARE_TAKER
SELECT * FROM CASHIER
SELECT * FROM VETERINARIAN
SELECT * FROM PET
SELECT * FROM MEDICAL_RECORD
SELECT * FROM DRUG
SELECT * FROM [PRODUCT]
SELECT * FROM TRANSACT
SELECT * FROM TREATMENT
SELECT * FROM TREATMENT_SERVICES
SELECT * FROM SERVES
SELECT * FROM SERVES_SERVICES
SELECT * FROM PAYS

DELETE FROM CUSTOMER
DELETE FROM CUST_CONTACT
DELETE FROM STAFF
DELETE FROM STAFF_ATTENDANCE
DELETE FROM CARE_TAKER
DELETE FROM CASHIER
DELETE FROM VETERINARIAN
DELETE FROM PET
DELETE FROM MEDICAL_RECORD
DELETE FROM DRUG
DELETE FROM [PRODUCT]
DELETE FROM TRANSACT
DELETE FROM TREATMENT
DELETE FROM TREATMENT_SERVICES
DELETE FROM SERVES
DELETE FROM SERVES_SERVICES
DELETE FROM PAYS

SELECT COUNT(*) AS Total_Customer_Data FROM CUSTOMER
SELECT COUNT(*) AS Total_CustContact_Data FROM CUST_CONTACT
SELECT COUNT(*) AS Total_Staff_Data FROM STAFF
SELECT COUNT(*) AS Total_StaffAttendance_Data FROM STAFF_ATTENDANCE -- 96
SELECT COUNT(*) AS Total_CareTaker_Data FROM CARE_TAKER -- 33
SELECT COUNT(*) AS Total_Cashier_Data FROM CASHIER -- 33
SELECT COUNT(*) AS Total_Veterinarian_Data FROM VETERINARIAN -- 34
SELECT COUNT(*) AS Total_Pet_Data FROM PET
SELECT COUNT(*) AS Total_MedicalRecord_Data FROM MEDICAL_RECORD
SELECT COUNT(*) AS Total_Drug_Data FROM DRUG
SELECT COUNT(*) AS Total_Product_Data FROM [PRODUCT]
SELECT COUNT(*) AS Total_Transact_Data FROM TRANSACT
SELECT COUNT(*) AS Total_Treatment_Data FROM TREATMENT
SELECT COUNT(*) AS Total_TreatmentServices_Data FROM TREATMENT_SERVICES
SELECT COUNT(*) AS Total_Serves_Data FROM SERVES
SELECT COUNT(*) AS Total_ServesServices_Data FROM SERVES_SERVICES
SELECT COUNT(*) AS Total_Pays_Data FROM PAYS