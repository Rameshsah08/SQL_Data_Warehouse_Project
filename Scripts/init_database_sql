/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'Warehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'Warehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

-- Drop and recreate the 'Warehouse' database
DROP DATABASE IF EXISTS Warehouse;

-- Create the 'Warehouse' database
CREATE DATABASE Warehouse;

USE Warehouse;

-- Create Schemas (In MySQL, schemas = separate databases)
CREATE DATABASE IF NOT EXISTS bronze;
CREATE DATABASE IF NOT EXISTS silver;
CREATE DATABASE IF NOT EXISTS gold;

/* drop schema bronze;
drop schema silver;
drop schema gold ; */
