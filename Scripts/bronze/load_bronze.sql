-- ============================================================
-- Script  : bronze_layer_load.sql
-- Project : Data Warehouse Project
-- Layer   : Bronze (Raw Layer)
-- ============================================================
-- What does this script do?
--
--   This script loads raw data from 6 CSV files into the
--   Bronze Layer tables in the 'warehouse' database.
--
--   It loads data from 2 source systems:
--     - CRM (Customer Relationship Management)
--         cust_info.csv      → bronze_crm_cust_info
--         prd_info.csv       → bronze_crm_prd_info
--         sales_details.csv  → bronze_crm_sales_details
--
--     - ERP (Enterprise Resource Planning)
--         CUST_AZ12.csv      → bronze_erp_cust_AZ12
--         LOC_A101.csv       → bronze_erp_LOC_A101
--         PX_CAT_G1V2.csv    → bronze_erp_PX_CAT_G1V2
--
--   For each table it will:
--     1. Clear the existing data (TRUNCATE)
--     2. Load fresh data from the CSV file
--     3. Log the start time, end time, and duration
--
--   At the end a summary report is displayed showing
--   the total loading time for all tables.
--
--  Before Running This Script:
--   1. Run init_database.sql first     (create the database)
--   2. Run bronze_layer_ddl.sql first  (create the tables)
--   3. Update the file paths below to match your local folder
--   4. In MySQL Workbench go to:
--      Edit → Preferences → SQL Editor
--      → tick "Allow loading local files" → OK
--      → Disconnect and Reconnect
--
--  Update These File Paths to Match Your Local Machine:
--   'D:/data engineer/sql-data-warehouse-project-main/datasets/...'
-- ============================================================

-- Enable file loading
SET GLOBAL local_infile = 1;

-- ================================================
-- CREATE TEMP LOG TABLE
-- ================================================
DROP TEMPORARY TABLE IF EXISTS load_log;

CREATE TEMPORARY TABLE load_log (
    log_id  INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(500)
);

-- ================================================
-- OVERALL START TIME
-- ================================================
SET @overall_start = NOW();

INSERT INTO load_log (message) VALUES
(CONCAT('>> Overall Start Time : ', @overall_start)),
('');

-- ================================================
-- SOURCE CRM FILES
-- ================================================
INSERT INTO load_log (message) VALUES ('=== LOADING SOURCE_CRM FILES ===');

-- --------------------------------------------
-- CUST_INFO.CSV
-- --------------------------------------------
SET @start_time = NOW();
INSERT INTO load_log (message) VALUES
(CONCAT('>> Loading  : cust_info.csv     | Start : ', @start_time));

TRUNCATE TABLE bronze_crm_cust_info;

LOAD DATA LOCAL INFILE 'D:/data engineer/sql-data-warehouse-project-main/datasets/source_crm/cust_info.csv'
INTO TABLE bronze_crm_cust_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date);

SET @end_time = NOW();
INSERT INTO load_log (message) VALUES
(CONCAT('>> Loaded   : cust_info.csv     | End   : ', @end_time)),
(CONCAT('>> Duration : cust_info.csv     | Took  : ', TIMEDIFF(@end_time, @start_time), ' (HH:MM:SS)'));

-- --------------------------------------------
-- PRD_INFO.CSV
-- --------------------------------------------
SET @start_time = NOW();
INSERT INTO load_log (message) VALUES
(CONCAT('>> Loading  : prd_info.csv      | Start : ', @start_time));

TRUNCATE TABLE bronze_crm_prd_info;

LOAD DATA LOCAL INFILE 'D:/data engineer/sql-data-warehouse-project-main/datasets/source_crm/prd_info.csv'
INTO TABLE bronze_crm_prd_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(prd_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt);

SET @end_time = NOW();
INSERT INTO load_log (message) VALUES
(CONCAT('>> Loaded   : prd_info.csv      | End   : ', @end_time)),
(CONCAT('>> Duration : prd_info.csv      | Took  : ', TIMEDIFF(@end_time, @start_time), ' (HH:MM:SS)'));

-- --------------------------------------------
-- SALES_DETAILS.CSV
-- --------------------------------------------
SET @start_time = NOW();
INSERT INTO load_log (message) VALUES
(CONCAT('>> Loading  : sales_details.csv | Start : ', @start_time));

TRUNCATE TABLE bronze_crm_sales_details;

LOAD DATA LOCAL INFILE 'D:/data engineer/sql-data-warehouse-project-main/datasets/source_crm/sales_details.csv'
INTO TABLE bronze_crm_sales_details
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt,
 sls_due_dt, sls_sales, sls_quantity, sls_price);

SET @end_time = NOW();
INSERT INTO load_log (message) VALUES
(CONCAT('>> Loaded   : sales_details.csv | End   : ', @end_time)),
(CONCAT('>> Duration : sales_details.csv | Took  : ', TIMEDIFF(@end_time, @start_time), ' (HH:MM:SS)')),
('');

-- ================================================
-- SOURCE ERP FILES
-- ================================================
INSERT INTO load_log (message) VALUES ('=== LOADING SOURCE_ERP FILES ===');

-- --------------------------------------------
-- CUST_AZ12.CSV
-- --------------------------------------------
SET @start_time = NOW();
INSERT INTO load_log (message) VALUES
(CONCAT('>> Loading  : CUST_AZ12.csv     | Start : ', @start_time));

TRUNCATE TABLE bronze_erp_cust_AZ12;

LOAD DATA LOCAL INFILE 'D:/data engineer/sql-data-warehouse-project-main/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE bronze_erp_cust_AZ12
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(CID, BDATE, GEN);

SET @end_time = NOW();
INSERT INTO load_log (message) VALUES
(CONCAT('>> Loaded   : CUST_AZ12.csv     | End   : ', @end_time)),
(CONCAT('>> Duration : CUST_AZ12.csv     | Took  : ', TIMEDIFF(@end_time, @start_time), ' (HH:MM:SS)'));

-- --------------------------------------------
-- LOC_A101.CSV
-- --------------------------------------------
SET @start_time = NOW();
INSERT INTO load_log (message) VALUES
(CONCAT('>> Loading  : LOC_A101.csv      | Start : ', @start_time));

TRUNCATE TABLE bronze_erp_LOC_A101;

LOAD DATA LOCAL INFILE 'D:/data engineer/sql-data-warehouse-project-main/datasets/source_erp/LOC_A101.csv'
INTO TABLE bronze_erp_LOC_A101
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(CID, CNTRY);

SET @end_time = NOW();
INSERT INTO load_log (message) VALUES
(CONCAT('>> Loaded   : LOC_A101.csv      | End   : ', @end_time)),
(CONCAT('>> Duration : LOC_A101.csv      | Took  : ', TIMEDIFF(@end_time, @start_time), ' (HH:MM:SS)'));

-- --------------------------------------------
-- PX_CAT_G1V2.CSV
-- --------------------------------------------
SET @start_time = NOW();
INSERT INTO load_log (message) VALUES
(CONCAT('>> Loading  : PX_CAT_G1V2.csv   | Start : ', @start_time));

TRUNCATE TABLE bronze_erp_PX_CAT_G1V2;

LOAD DATA LOCAL INFILE 'D:/data engineer/sql-data-warehouse-project-main/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE bronze_erp_PX_CAT_G1V2
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ID, CAT, SUBCAT, MAINTENANCE);

SET @end_time = NOW();
INSERT INTO load_log (message) VALUES
(CONCAT('>> Loaded   : PX_CAT_G1V2.csv   | End   : ', @end_time)),
(CONCAT('>> Duration : PX_CAT_G1V2.csv   | Took  : ', TIMEDIFF(@end_time, @start_time), ' (HH:MM:SS)'));

-- ================================================
-- OVERALL SUMMARY
-- ================================================
SET @overall_end = NOW();

INSERT INTO load_log (message) VALUES
(''),
('======================================================'),
('            LOADING SUMMARY                          '),
('======================================================'),
(CONCAT('  Overall Start Time : ', @overall_start)),
(CONCAT('  Overall End Time   : ', @overall_end)),
(CONCAT('  Total Duration     : ', TIMEDIFF(@overall_end, @overall_start), ' (HH:MM:SS)')),
('******** ALL TABLES LOADED SUCCESSFULLY ********'),
('======================================================');

-- ================================================
-- SHOW ALL LOGS IN ONE RESULT SET
-- ================================================
SELECT message AS "******* SUMMARY **********" FROM load_log ORDER BY log_id;
