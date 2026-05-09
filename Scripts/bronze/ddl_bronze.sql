-- ============================================================
-- Script  : bronze_layer_ddl.sql
-- Project : Data Warehouse Project
-- Layer   : Bronze (Raw Layer)
-- ============================================================
-- What does this script do?
--
--   This script creates 6 empty tables in the Bronze Layer
--   of the data warehouse. The Bronze Layer is where raw data
--   is stored exactly as it comes from the source systems,
--   with no changes or transformations applied.
--
--   Tables are loaded from 2 source systems:
--     - CRM (Customer Relationship Management)
--     - ERP (Enterprise Resource Planning)
--
--   Run this script FIRST before loading any data from CSV files.
-- ============================================================

USE warehouse;

-- ============================================================
-- CRM TABLES
-- ============================================================

-- Stores customer personal details (name, gender, marital status)
DROP TABLE IF EXISTS bronze_crm_cust_info;
CREATE TABLE bronze_crm_cust_info (
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_firstname      VARCHAR(50),
    cst_lastname       VARCHAR(50),
    cst_marital_status VARCHAR(30),
    cst_gndr           VARCHAR(30),
    cst_create_date    DATE
);

-- Stores product details (name, cost, product line, active dates)
DROP TABLE IF EXISTS bronze_crm_prd_info;
CREATE TABLE bronze_crm_prd_info (
    prd_id       INT,
    prd_key      VARCHAR(50),
    prd_nm       VARCHAR(50),
    prd_cost     VARCHAR(50),
    prd_line     VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt   DATE
);

-- Stores sales transactions (order, shipment, quantity, price)
DROP TABLE IF EXISTS bronze_crm_sales_details;
CREATE TABLE bronze_crm_sales_details (
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt int,
    sls_ship_dt  int,
    sls_due_dt   int,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);

-- ============================================================
-- ERP TABLES
-- ============================================================

-- Stores customer birth date and gender from ERP file
DROP TABLE IF EXISTS bronze_erp_cust_AZ12;
CREATE TABLE bronze_erp_cust_AZ12 (
    cid   VARCHAR(50),
    bdate DATE,
    gen   VARCHAR(50)
);

-- Stores customer country/location from ERP file
DROP TABLE IF EXISTS bronze_erp_LOC_A101;
CREATE TABLE bronze_erp_LOC_A101 (
    cid   VARCHAR(50),
    CNTRY VARCHAR(50)
);

-- Stores product category and subcategory from ERP file
DROP TABLE IF EXISTS bronze_erp_PX_CAT_G1V2;
CREATE TABLE bronze_erp_PX_CAT_G1V2 (
    id          VARCHAR(60),
    cat         VARCHAR(50),
    subcat      VARCHAR(50),
    maintenance VARCHAR(60)
);

-- ============================================================
-- End of Script
-- ============================================================
