

/*
====================================================================================

DDL Script: Create gold views
====================================================================================

   Purpose:
   Builds the Gold Layer of the data warehouse by creating three views 
   (gold_dim_customer, gold_dim_product, gold_fact_sales) that transform and combine 
   cleaned Silver Layer data into business-ready dimension and fact tables, structured 
   for analytical and reporting use cases.
   
   Usages:
    These view can be queried directly for analytics and reporting.
    =================================================================================
    
*/

-- ======================= build gold layer ================================

-- ======================= build gold layer ================================

-- ======= drop view gold_dim_customer ===================
drop view gold_dim_customer;

-- ======= create view gold_dim_customer ===================
create view gold_dim_customer as  
select 
row_number() over(order by cst_id) as customer_key, 
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as customer_name,
ci.cst_lastname as customer_last_name,
la.CNTRY as country,
ci.cst_marital_status as marital_status,
 case when ci.cst_gndr != "N/A" then ci.cst_gndr  -- CRM IS THE MASTER for gender info
   else coalesce(ca.gen, "N/A")
   end as gender,
ca.bdate as birthdate,
ci.cst_create_date as create_date
from silver_crm_cust_info as ci
left join silver_erp_cust_az12 as ca
on ci.cst_key = ca.cid
left join silver_erp_loc_a101 as la
on ci.cst_key = la.cid;


-- ================ drop view gold_dim_product =====================
drop view gold_dim_product;

-- ================== create view gold_dim_product ==================

create view gold_dim_product as
select
row_number() over(order by pr.prd_id) as product_key,
pr.prd_id as product_id,
pr.prd_key as product_number,
pr.prd_nm as product_name,
pr.cat_id as category_id,
ct.cat as category,
ct.subcat as subcategory,
ct.maintenance,
pr.prd_cost as cost,
pr.prd_line as product_line,
pr.prd_start_dt as start_date
from silver_crm_prd_info as pr
left join silver_erp_px_cat_g1v2 as ct
on  pr.cat_id = ct.id;


-- ============ drop view gold_fact_sales ===============
drop view if exists gold_fact_sales;

-- ============= create view gold_fact_sales =================
create view gold_fact_sales as 
select 
si.sls_ord_num as order_number,
pr.product_key,
cu.customer_key,
si.sls_order_dt as order_date,
si.sls_ship_dt as shipping_date,
si.sls_due_dt as due_date,
si.sls_sales as sales_amount,
si.sls_quantity as quantity,
si.sls_price as price
from silver_crm_sales_details as si
left join gold_dim_product as pr
on si. sls_prd_key = pr.product_number
left join gold_dim_customer as cu
on si.sls_cust_id = cu.customer_id
;
