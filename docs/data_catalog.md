# Data Catalog — Gold Layer

## Overview

The **Gold Layer** is the business-level data representation, structured to support analytical and reporting use cases.
All tables are implemented as **SQL Views** built on top of the Silver Layer, and are organised into **dimension tables** and one **fact table**.

---

## Table of Contents

- [gold\_dim\_customer](#1-gold_dim_customer)
- [gold\_dim\_product](#2-gold_dim_product)
- [gold\_fact\_sales](#3-gold_fact_sales)

---

## 1. `gold_dim_customer`

**Purpose:** Stores customer details enriched with demographic and geographic data. Gender is resolved by treating CRM as the master source, falling back to ERP where CRM holds `'N/A'`.

**Source tables:** `silver_crm_cust_info`, `silver_erp_cust_AZ12`, `silver_erp_LOC_A101`

| Column Name          | Data Type      | Description                                                                                      |
|----------------------|----------------|--------------------------------------------------------------------------------------------------|
| `customer_key`       | `INT`          | Surrogate key uniquely identifying each customer record (generated via `ROW_NUMBER()`).          |
| `customer_id`        | `INT`          | Unique numerical identifier assigned to each customer (`cst_id`).                               |
| `customer_number`    | `VARCHAR(50)`  | Alphanumeric identifier used for tracking and referencing the customer (`cst_key`).              |
| `customer_name`      | `VARCHAR(50)`  | The customer's first name as recorded in the CRM system (`cst_firstname`).                       |
| `customer_last_name` | `VARCHAR(50)`  | The customer's last name or family name (`cst_lastname`).                                        |
| `country`            | `VARCHAR(50)`  | Country of residence sourced from ERP location data (`CNTRY`).                                   |
| `marital_status`     | `VARCHAR(30)`  | Marital status of the customer, e.g. `'Married'`, `'Single'` (`cst_marital_status`).            |
| `gender`             | `VARCHAR(30)`  | Resolved gender: CRM value used when available; falls back to ERP value, defaulting to `'N/A'`. |
| `birthdate`          | `DATE`         | Date of birth from ERP, formatted as `YYYY-MM-DD` (`bdate`).                                    |
| `create_date`        | `DATE`         | Date the customer record was originally created in the CRM system (`cst_create_date`).           |

---

## 2. `gold_dim_product`

**Purpose:** Provides information about products and their attributes, including category classification and cost details.

**Source tables:** `silver_crm_prd_info`, `silver_erp_PX_CAT_G1V2`

| Column Name      | Data Type       | Description                                                                                     |
|------------------|-----------------|-------------------------------------------------------------------------------------------------|
| `product_key`    | `INT`           | Surrogate key uniquely identifying each product record (generated via `ROW_NUMBER()`).          |
| `product_id`     | `INT`           | Unique internal identifier assigned to each product (`prd_id`).                                 |
| `product_number` | `VARCHAR(50)`   | Structured alphanumeric code used for inventory and categorisation (`prd_key`).                 |
| `product_name`   | `VARCHAR(50)`   | Descriptive name of the product, including type, colour, and size details (`prd_nm`).           |
| `category_id`    | `VARCHAR(50)`   | Identifier linking the product to its high-level category classification (`cat_id`).            |
| `category`       | `VARCHAR(50)`   | Broader product classification, e.g. `'Bikes'`, `'Components'` (`cat`).                        |
| `subcategory`    | `VARCHAR(50)`   | More detailed classification within the category, e.g. product type (`subcat`).                 |
| `maintenance`    | `VARCHAR(60)`   | Indicates whether the product requires maintenance, e.g. `'Yes'`, `'No'` (`maintenance`).      |
| `cost`           | `DECIMAL(10,2)` | Base cost/price of the product in monetary units (`prd_cost`).                                  |
| `product_line`   | `VARCHAR(50)`   | Product line or series the product belongs to, e.g. `'Road'`, `'Mountain'` (`prd_line`).       |
| `start_date`     | `DATE`          | Date the product became available for sale, formatted as `YYYY-MM-DD` (`prd_start_dt`).         |

---

## 3. `gold_fact_sales`

**Purpose:** Stores transactional sales data for analytical and reporting purposes. Links to dimension tables via surrogate keys.

**Source tables:** `silver_crm_sales_details`, `gold_dim_product`, `gold_dim_customer`

| Column Name     | Data Type     | Description                                                                              |
|-----------------|---------------|------------------------------------------------------------------------------------------|
| `order_number`  | `VARCHAR(50)` | Unique alphanumeric identifier for each sales order, e.g. `'SO54496'` (`sls_ord_num`).  |
| `product_key`   | `INT`         | Surrogate key linking the order line to `gold_dim_product`.                              |
| `customer_key`  | `INT`         | Surrogate key linking the order line to `gold_dim_customer`.                             |
| `order_date`    | `DATE`        | Date the order was placed (`sls_order_dt`).                                              |
| `shipping_date` | `DATE`        | Date the order was shipped to the customer (`sls_ship_dt`).                              |
| `due_date`      | `DATE`        | Date the order payment was due (`sls_due_dt`).                                           |
| `sales_amount`  | `INT`         | Total monetary value of the sales line item in whole currency units (`sls_sales`).       |
| `quantity`      | `INT`         | Number of product units ordered for the line item (`sls_quantity`).                      |
| `price`         | `INT`         | Price per unit of the product for the line item in whole currency units (`sls_price`).   |

---

*Generated from Gold Layer view definitions. Source: `gold_layer_build.sql`*
