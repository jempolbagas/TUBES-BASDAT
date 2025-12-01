CREATE DATABASE PetShop
USE PetShop

CREATE TABLE CUSTOMER (
    id INT PRIMARY KEY ,
    [name] VARCHAR(100)
);

CREATE TABLE CUST_CONTACT (
    cust_contact VARCHAR(50), 
    cust_id INT,
    
    PRIMARY KEY (cust_contact), 
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
    [login] DATETIME,
    logout DATETIME,
    staff_id INT,

    PRIMARY KEY (login,logout),
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
    payment_id INT PRIMARY KEY,
    pay_method VARCHAR(50),
    [datetime] DATETIME,
    cust_id INT,
    staff_id INT,
    
    FOREIGN KEY (cust_id) REFERENCES CUSTOMER(id),
    FOREIGN KEY (staff_id) REFERENCES CASHIER(staff_id)
);

CREATE TABLE TRANSACT (
    cust_id INT,
    staff_id INT,  
    product_id INT,
    
    PRIMARY KEY (cust_id, staff_id, product_id),
    FOREIGN KEY (cust_id) REFERENCES CUSTOMER(id),
    FOREIGN KEY (staff_id) REFERENCES CASHIER(staff_id),
    FOREIGN KEY (product_id) REFERENCES [PRODUCT](id)
);

CREATE TABLE TREATMENT (
    treatment_id INT PRIMARY KEY,
    schedule DATETIME,
    drug_id INT,
    pet_id INT,
    staff_id INT, 
    
    FOREIGN KEY (drug_id) REFERENCES DRUG(id),
    FOREIGN KEY (pet_id) REFERENCES PET(id),
    FOREIGN KEY (staff_id) REFERENCES VETERINARIAN(staff_id)
);

CREATE TABLE TREATMENT_SERVICES (
    treatment_id INT,
    [type] VARCHAR(100), 
    price DECIMAL(10, 2),
    

    PRIMARY KEY (treatment_id, type), 
    FOREIGN KEY (treatment_id) REFERENCES TREATMENT(treatment_id) ON DELETE CASCADE
);

CREATE TABLE SERVES (
    serves_id INT PRIMARY KEY,
    schedule DATETIME,
    pet_id INT,
    staff_id INT,
    
    FOREIGN KEY (pet_id) REFERENCES PET(id),
    FOREIGN KEY (staff_id) REFERENCES CARE_TAKER(staff_id)
);

CREATE TABLE SERVES_SERVICES (
    serves_id INT,
    [type] VARCHAR(100), 
    price DECIMAL(10, 2),
    
    PRIMARY KEY (serves_id, type),
    FOREIGN KEY (serves_id) REFERENCES SERVES(serves_id) ON DELETE CASCADE
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