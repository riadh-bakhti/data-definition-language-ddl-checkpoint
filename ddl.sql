-- ============================================================
-- Data definition language (DDL) checkpoint
-- Oracle SQL (VARCHAR2 / SYSDATE)
-- ============================================================

-- Clean start (drop in reverse dependency order).
DROP TABLE Orders;
DROP TABLE Product;
DROP TABLE Customer;

-- ------------------------------------------------------------
-- 1. Tables
-- ------------------------------------------------------------

CREATE TABLE Customer (
    Customer_id   VARCHAR2(20) CONSTRAINT pk_customer PRIMARY KEY,
    Customer_Name VARCHAR2(20) NOT NULL,
    Customer_Tel  NUMBER
);

CREATE TABLE Product (
    Product_id   VARCHAR2(20) CONSTRAINT pk_product PRIMARY KEY,
    Product_Name VARCHAR2(20) NOT NULL,
    Price        NUMBER       CONSTRAINT ck_product_price CHECK (Price > 0)
);

CREATE TABLE Orders (
    Customer_id  VARCHAR2(20),
    Product_id   VARCHAR2(20),
    Quantity     NUMBER,
    Total_amount NUMBER,
    CONSTRAINT pk_orders PRIMARY KEY (Customer_id, Product_id),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (Customer_id) REFERENCES Customer (Customer_id),
    CONSTRAINT fk_orders_product
        FOREIGN KEY (Product_id) REFERENCES Product (Product_id)
);

-- ------------------------------------------------------------
-- 2. Structure updates
-- ------------------------------------------------------------

-- Add a Category column (VARCHAR2(20)) to PRODUCT.
ALTER TABLE Product ADD (Category VARCHAR2(20));

-- Add an OrderDate column (DATE) to ORDERS, defaulting to SYSDATE.
ALTER TABLE Orders ADD (OrderDate DATE DEFAULT SYSDATE);
