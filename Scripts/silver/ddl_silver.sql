-- ============================================================
-- Script  : silver_layer_ddl.sql
-- Project : SQL Data Warehouse Project
-- Author  : [Your Name]
-- Date    : 2024
-- ============================================================
-- Purpose : Creates all Silver Layer tables for CRM and ERP
--           source systems. Silver Layer holds cleaned and
--           standardized data transformed from the Bronze Layer.
--
--   ⚠ WARNING: Drops and recreates all Silver Layer tables.
--      Run silver_layer_load.sql afterwards to reload data.
-- ============================================================


-- ============================================================
-- CRM TABLES
-- ============================================================
-- Stores customer personal details (name, gender, marital status)
DROP TABLE IF EXISTS silver_crm_cust_info;
CREATE TABLE silver_crm_cust_info (
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_firstname      VARCHAR(50),
    cst_lastname       VARCHAR(50),
    cst_marital_status VARCHAR(30),
    cst_gndr           VARCHAR(30),
    cst_create_date    DATE,
    wh_create_date datetime default CURRENT_TIMESTAMP()
);

-- Stores product details (name, cost, product line, active dates)
DROP TABLE IF EXISTS silver_crm_prd_info;
CREATE TABLE silver_crm_prd_info (
    prd_id       INT,
    cat_id       VARCHAR(50),
    prd_key      VARCHAR(50),
    prd_nm       VARCHAR(50),
    prd_cost     DECIMAL(10, 2),   
    prd_line     VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt   DATE,
    wh_create_date datetime default CURRENT_TIMESTAMP()
);

-- Stores sales transactions (order, shipment, quantity, price)
DROP TABLE IF EXISTS silver_crm_sales_details;
CREATE TABLE silver_crm_sales_details (
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt DATE,
    sls_ship_dt  DATE,
    sls_due_dt   DATE,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT,
    wh_create_date datetime default CURRENT_TIMESTAMP()
);


-- ============================================================
-- ERP TABLES
-- ============================================================
-- Stores customer birth date and gender 
DROP TABLE IF EXISTS silver_erp_cust_AZ12;
CREATE TABLE silver_erp_cust_AZ12 (
    cid   VARCHAR(50),
    bdate DATE,
    gen   VARCHAR(50),
    wh_create_date datetime default CURRENT_TIMESTAMP()
);

-- Stores customer country/location 
DROP TABLE IF EXISTS silver_erp_LOC_A101;
CREATE TABLE silver_erp_LOC_A101 (
    cid   VARCHAR(50),
    CNTRY VARCHAR(50),
    wh_create_date datetime default CURRENT_TIMESTAMP()
);

-- Stores product category and subcategory
DROP TABLE IF EXISTS silver_erp_PX_CAT_G1V2;
CREATE TABLE silver_erp_PX_CAT_G1V2 (
    id          VARCHAR(60),
    cat         VARCHAR(50),
    subcat      VARCHAR(50),
    maintenance VARCHAR(60),
    wh_create_date datetime default CURRENT_TIMESTAMP()
);


-- ============================================================
-- End of Script
-- ============================================================
