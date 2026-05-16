-- ============================================================
-- Script  : silver_layer_load.sql
-- Project : Data Warehouse Project
-- Layer   : Silver (Cleansed Layer)
-- ============================================================
-- What does this script do?
--
--   This script cleanses, standardizes, and transforms raw
--   data from the Bronze Layer into the Silver Layer tables.
--
--   It processes data from 2 source systems:
--     - CRM (Customer Relationship Management)
--         bronze_crm_cust_info      → silver_crm_cust_info
--         bronze_crm_prd_info       → silver_crm_prd_info
--         bronze_crm_sales_details  → silver_crm_sales_details
--
--     - ERP (Enterprise Resource Planning)
--         bronze_erp_cust_az12      → silver_erp_cust_az12
--         bronze_erp_loc_a101       → silver_erp_loc_a101
--         bronze_erp_px_cat_g1v2    → silver_erp_px_cat_g1v2
--
--   For each table it will:
--     1. Clear the existing data        (TRUNCATE)
--     2. Cleanse and transform the data (INSERT INTO ... SELECT)
--     3. Log the start time, end time, and duration
--
--   Transformations Applied:
--     - Removed duplicates using ROW_NUMBER()
--     - Trimmed whitespace from string fields
--     - Decoded coded values (e.g. 'M' → 'Male', 'S' → 'Single')
--     - Converted integer dates (YYYYMMDD) to DATE type
--     - Fixed invalid sales/price/quantity values
--     - Derived missing prices from sales / quantity
--     - Nullified future birth dates
--     - Standardized country names
--     - Extracted category ID and product key from product key
--
--   At the end a summary report is displayed showing
--   the total transformation time for all tables.
--
--   Before Running This Script:
--     1. Run init_database.sql first        (create the database)
--     2. Run bronze_layer_ddl.sql first     (create bronze tables)
--     3. Run bronze_layer_load.sql first    (load raw data)
--     4. Run silver_layer_ddl.sql first     (create silver tables)
-- ============================================================


-- ================================================
-- CREATE TEMP LOG TABLE
-- ================================================
DROP TEMPORARY TABLE IF EXISTS silver_load_log;

CREATE TEMPORARY TABLE silver_load_log (
    log_id  INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(500)
);


-- ================================================
-- OVERALL START TIME
-- ================================================
SET @overall_start = NOW();

INSERT INTO silver_load_log (message) VALUES
(CONCAT('>> Overall Start Time : ', @overall_start)),
('');


-- ============================================================
-- SOURCE CRM TABLES
-- ============================================================
INSERT INTO silver_load_log (message) VALUES ('=== TRANSFORMING SOURCE_CRM TABLES ===');


-- --------------------------------------------
-- silver_crm_cust_info
-- Transformations:
--   - Remove duplicate customers (keep latest record)
--   - Trim whitespace from name fields
--   - Decode marital status: 'S' → 'Single', 'M' → 'Married'
--   - Decode gender: 'F' → 'Female', 'M' → 'Male'
--   - Exclude NULL or invalid customer IDs
-- --------------------------------------------
SET @start_time = NOW();
INSERT INTO silver_load_log (message) VALUES
(CONCAT('>> Loading  : silver_crm_cust_info      | Start : ', @start_time));

TRUNCATE TABLE silver_crm_cust_info;

INSERT INTO silver_crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname)  AS cst_firstname,      
    TRIM(cst_lastname)   AS cst_lastname,       
    CASE
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'    
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'N/A'
    END    AS cst_marital_status,
    CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'  
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'N/A'
    END   AS cst_gndr,
    cst_create_date
FROM (
    -- Rank records per customer to identify the most recent one
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY cst_id
            ORDER BY cst_create_date DESC
        )                                            AS flag_last
    FROM bronze_crm_cust_info
    WHERE cst_id IS NOT NULL  
      AND cst_id != 0         
) AS t
WHERE flag_last = 1;  

SET @end_time = NOW();
INSERT INTO silver_load_log (message) VALUES
(CONCAT('>> Loaded   : silver_crm_cust_info      | End   : ', @end_time)),
(CONCAT('>> Duration : silver_crm_cust_info      | Took  : ', TIMEDIFF(@end_time, @start_time), ' (HH:MM:SS)'));


-- --------------------------------------------
-- silver_crm_prd_info
-- Transformations:
--   - Extract category ID from first 5 chars of product key
--   - Extract clean product key from position 7 onwards
--   - Cleanse product cost (handle NULLs and empty strings)
--   - Decode product line: 'M' → 'Mountain', 'R' → 'Road', etc.
--   - Cast start date to DATE type
--   - Derive end date as 1 day before next product version
-- --------------------------------------------
SET @start_time = NOW();
INSERT INTO silver_load_log (message) VALUES
(CONCAT('>> Loading  : silver_crm_prd_info       | Start : ', @start_time));

TRUNCATE TABLE silver_crm_prd_info;

INSERT INTO silver_crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
FROM (
    SELECT
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_')   AS cat_id,    
        SUBSTRING(prd_key, 7, LENGTH(prd_key))  AS prd_key,   
        prd_nm,
        CAST(
            IFNULL(NULLIF(TRIM(prd_cost), ''), 0)
        AS DECIMAL(10, 2))   AS prd_cost,  
        CASE
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'            
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'N/A'
        END   AS prd_line,
        CAST(prd_start_dt AS DATE)  AS prd_start_dt, -- Cast start date to DATE type
        DATE_SUB(
            LEAD(prd_start_dt) OVER (
                PARTITION BY prd_key
                ORDER BY prd_start_dt
            ),
            INTERVAL 1 DAY
        )  AS prd_end_dt   -- End date = 1 day before next product version starts
    FROM bronze_crm_prd_info
) AS t;

SET @end_time = NOW();
INSERT INTO silver_load_log (message) VALUES
(CONCAT('>> Loaded   : silver_crm_prd_info       | End   : ', @end_time)),
(CONCAT('>> Duration : silver_crm_prd_info       | Took  : ', TIMEDIFF(@end_time, @start_time), ' (HH:MM:SS)'));


-- --------------------------------------------
-- silver_crm_sales_details
-- Transformations:
--   - Convert integer dates (YYYYMMDD) to DATE type
--   - Nullify invalid or malformed date values
--   - Derive correct price from sales / quantity when invalid
--   - Recalculate sales as quantity * price when inconsistent
-- --------------------------------------------
SET @start_time = NOW();
INSERT INTO silver_load_log (message) VALUES
(CONCAT('>> Loading  : silver_crm_sales_details  | Start : ', @start_time));

TRUNCATE TABLE silver_crm_sales_details;

INSERT INTO silver_crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
WITH corrected_price AS (
    -- Step 1: Derive correct price when original price is NULL or invalid
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price,
        CASE
            WHEN sls_price IS NULL OR sls_price <= 0
            THEN sls_sales / NULLIF(sls_quantity, 0)          
            ELSE sls_price                                    
        END                                          AS new_sls_price
    FROM bronze_crm_sales_details
)
-- Step 2: Use corrected price to fix sales, and convert integer dates to DATE type
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE
        WHEN sls_order_dt = 0
          OR LENGTH(sls_order_dt) != 8 THEN NULL                
        ELSE STR_TO_DATE(CAST(sls_order_dt AS CHAR), '%Y%m%d')  -- Convert YYYYMMDD integer to DATE
    END                                              AS sls_order_dt,
    CASE
        WHEN sls_ship_dt = 0
          OR LENGTH(sls_ship_dt) != 8 THEN NULL                 
        ELSE STR_TO_DATE(CAST(sls_ship_dt AS CHAR), '%Y%m%d')   -- Convert YYYYMMDD integer to DATE
    END                                              AS sls_ship_dt,
    CASE
        WHEN sls_due_dt = 0
          OR LENGTH(sls_due_dt) != 8 THEN NULL                 
        ELSE STR_TO_DATE(CAST(sls_due_dt AS CHAR), '%Y%m%d')    -- Convert YYYYMMDD integer to DATE
    END                                              AS sls_due_dt,
    CASE
        WHEN sls_sales IS NULL
          OR sls_sales <= 0
          OR sls_sales != sls_quantity * ABS(new_sls_price)
        THEN sls_quantity * ABS(new_sls_price)      -- Recalculate sales if invalid
        ELSE sls_sales                                           
    END   AS sls_sales,
    sls_quantity,
    new_sls_price  AS sls_price
FROM corrected_price;

SET @end_time = NOW();
INSERT INTO silver_load_log (message) VALUES
(CONCAT('>> Loaded   : silver_crm_sales_details  | End   : ', @end_time)),
(CONCAT('>> Duration : silver_crm_sales_details  | Took  : ', TIMEDIFF(@end_time, @start_time), ' (HH:MM:SS)')),
('');


-- ============================================================
-- SOURCE ERP TABLES
-- ============================================================
INSERT INTO silver_load_log (message) VALUES ('=== TRANSFORMING SOURCE_ERP TABLES ===');


-- --------------------------------------------
-- silver_erp_cust_az12
-- Transformations:
--   - Remove 'NAS' prefix from customer ID if present
--   - Nullify future birth dates (invalid data)
--   - Decode gender: 'F'/'Female' → 'Female', 'M'/'Male' → 'Male'
-- --------------------------------------------
SET @start_time = NOW();
INSERT INTO silver_load_log (message) VALUES
(CONCAT('>> Loading  : silver_erp_cust_az12      | Start : ', @start_time));

TRUNCATE TABLE silver_erp_cust_az12;

INSERT INTO silver_erp_cust_az12 (
    cid,
    bdate,
    gen
)
SELECT
    CASE
        WHEN cid LIKE 'NAS%'
        THEN SUBSTRING(cid, 4, LENGTH(cid))    -- Remove 'NAS' prefix from customer ID
        ELSE cid
    END  AS cid,
    CASE
        WHEN bdate > CURDATE() THEN NULL     -- Nullify future birth dates (invalid)
        ELSE bdate
    END   AS bdate,
    CASE
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'   
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE')   THEN 'Male'
        ELSE 'N/A'
    END  AS gen
FROM bronze_erp_cust_az12;

SET @end_time = NOW();
INSERT INTO silver_load_log (message) VALUES
(CONCAT('>> Loaded   : silver_erp_cust_az12      | End   : ', @end_time)),
(CONCAT('>> Duration : silver_erp_cust_az12      | Took  : ', TIMEDIFF(@end_time, @start_time), ' (HH:MM:SS)'));


-- --------------------------------------------
-- silver_erp_loc_a101
-- Transformations:
--   - Remove '-' from customer ID to standardize format
--   - Standardize country names to full English names
--   - Replace NULL or empty country values with 'N/A'
-- --------------------------------------------
SET @start_time = NOW();
INSERT INTO silver_load_log (message) VALUES
(CONCAT('>> Loading  : silver_erp_loc_a101       | Start : ', @start_time));

TRUNCATE TABLE silver_erp_loc_a101;

INSERT INTO silver_erp_loc_a101 (
    cid,
    cntry
)
SELECT
    REPLACE(cid, '-', '')  AS cid,      -- Remove dashes from customer ID
    CASE
        WHEN TRIM(cntry) = 'De' THEN 'Germany'    
        WHEN TRIM(cntry) IN ('US', 'USA')      THEN 'United States'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'        -- Handle empty or NULL country values
        ELSE TRIM(cntry)
    END  AS cntry
FROM bronze_erp_loc_a101;

SET @end_time = NOW();
INSERT INTO silver_load_log (message) VALUES
(CONCAT('>> Loaded   : silver_erp_loc_a101       | End   : ', @end_time)),
(CONCAT('>> Duration : silver_erp_loc_a101       | Took  : ', TIMEDIFF(@end_time, @start_time), ' (HH:MM:SS)'));


-- --------------------------------------------
-- silver_erp_px_cat_g1v2
-- Transformations:
--   - No cleansing required
--   - Data is loaded as-is from Bronze layer
-- --------------------------------------------
SET @start_time = NOW();
INSERT INTO silver_load_log (message) VALUES
(CONCAT('>> Loading  : silver_erp_px_cat_g1v2    | Start : ', @start_time));

TRUNCATE TABLE silver_erp_px_cat_g1v2;

INSERT INTO silver_erp_px_cat_g1v2 (
    id,
    cat,
    subcat,
    maintenance
)
SELECT
    id,
    cat,
    subcat,
    maintenance
FROM bronze_erp_px_cat_g1v2;

SET @end_time = NOW();
INSERT INTO silver_load_log (message) VALUES
(CONCAT('>> Loaded   : silver_erp_px_cat_g1v2    | End   : ', @end_time)),
(CONCAT('>> Duration : silver_erp_px_cat_g1v2    | Took  : ', TIMEDIFF(@end_time, @start_time), ' (HH:MM:SS)'));


-- ================================================
-- OVERALL SUMMARY
-- ================================================
SET @overall_end = NOW();

INSERT INTO silver_load_log (message) VALUES
(''),
('======================================================'),
('            TRANSFORMATION SUMMARY                   '),
('======================================================'),
(CONCAT('  Overall Start Time : ', @overall_start)),
(CONCAT('  Overall End Time   : ', @overall_end)),
(CONCAT('  Total Duration     : ', TIMEDIFF(@overall_end, @overall_start), ' (HH:MM:SS)')),
('******** ALL TABLES LOADED SUCCESSFULLY ********'),
('======================================================');


-- ================================================
-- SHOW ALL LOGS IN ONE RESULT SET
-- ================================================
SELECT message AS '******* SUMMARY **********' FROM silver_load_log ORDER BY log_id;
