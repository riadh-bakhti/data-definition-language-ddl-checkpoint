# Data Definition Language (DDL) Checkpoint

GoMyCode **Data definition language (DDL)** checkpoint.

## Given relational model

```
Customer (Customer_id, Customer_Name, Customer_Tel)
Product  (Product_id, Product_Name, Price)
Orders   (#Customer_id, #Product_id, Quantity, Total_amount)
```

`#` marks a foreign key. `Orders` has a **composite primary key**
`(Customer_id, Product_id)`, since the model does not define an order
identifier.

## Data types and constraints

### Customer

| Column | Data type | Constraint |
|--------|-----------|------------|
| Customer_id | `VARCHAR2(20)` | Primary key |
| Customer_Name | `VARCHAR2(20)` | NOT NULL |
| Customer_Tel | `NUMBER` | |

### Product

| Column | Data type | Constraint |
|--------|-----------|------------|
| Product_id | `VARCHAR2(20)` | Primary key |
| Product_Name | `VARCHAR2(20)` | NOT NULL |
| Price | `NUMBER` | Positive value (`CHECK (Price > 0)`) |

### Orders

| Column | Data type | Constraint |
|--------|-----------|------------|
| Customer_id | `VARCHAR2(20)` | Foreign key → `Customer(Customer_id)` |
| Product_id | `VARCHAR2(20)` | Foreign key → `Product(Product_id)` |
| Quantity | `NUMBER` | |
| Total_amount | `NUMBER` | |

## SQL script

The full script is in [`ddl.sql`](ddl.sql). It is written for **Oracle**
(`VARCHAR2`, `SYSDATE`) and runs as-is on Oracle Live SQL or SQL\*Plus.

```sql
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
```

### Structure updates

```sql
-- 1. Add a Category column (VARCHAR2(20)) to PRODUCT.
ALTER TABLE Product ADD (Category VARCHAR2(20));

-- 2. Add an OrderDate column (DATE) to ORDERS, defaulting to SYSDATE.
ALTER TABLE Orders ADD (OrderDate DATE DEFAULT SYSDATE);
```

## How each constraint is implemented

| Requirement | Implementation |
|-------------|----------------|
| Customer identifier | `PRIMARY KEY (Customer_id)` |
| Product identifier | `PRIMARY KEY (Product_id)` |
| Orders identifier | Composite `PRIMARY KEY (Customer_id, Product_id)` |
| Customer name required | `Customer_Name ... NOT NULL` |
| Product name required | `Product_Name ... NOT NULL` |
| Price must be positive | `CHECK (Price > 0)` |
| Orders → Customer | `FOREIGN KEY (Customer_id) REFERENCES Customer` |
| Orders → Product | `FOREIGN KEY (Product_id) REFERENCES Product` |
| Category on products | `ALTER TABLE Product ADD (Category VARCHAR2(20))` |
| Order date defaults to today | `ALTER TABLE Orders ADD (OrderDate DATE DEFAULT SYSDATE)` |

## Notes

- Tables are created **Customer → Product → Orders** so that the foreign
  keys always reference an existing table.
- `DROP TABLE` statements are placed at the top in reverse dependency order
  (`Orders`, `Product`, `Customer`) so the script can be re-run.
- The `Category` and `OrderDate` columns are added **after** the tables are
  created, exactly as the checkpoint instructions require.

## Files

```
data-definition-language-ddl-checkpoint/
├── README.md   # this document
└── ddl.sql     # CREATE TABLE + ALTER TABLE script
```
