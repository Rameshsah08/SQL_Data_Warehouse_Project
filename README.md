
# Data Warehouse and Analytics Project

Welcome to my **Data Warehouse and Analytics Project** repository! 🚀
This project demonstrates a comprehensive data warehousing and analytics solution — from building a data warehouse to generating actionable insights. Built as a **portfolio project** to showcase industry best practices in data engineering and analytics, with a focus on real-world skills relevant to data roles.

---

## 🏗️ Data Architecture

The data architecture follows **Medallion Architecture** with **Bronze**, **Silver**, and **Gold** layers:

<img width="616" height="344" alt="Screenshot 2026-05-07 234822" src="https://github.com/user-attachments/assets/7b5b9335-dd14-4003-8326-ae7abd0e7145" />


1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV files into a MySQL database.
2. **Silver Layer**: Includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a **star schema** optimized for reporting and analytics.

---

## 📖 Project Overview

This project demonstrates a production-style data warehouse built from scratch using MySQL Workbench, designed to consolidate raw business data into meaningful, analytics-ready insights. It covers the full data engineering lifecycle — from ingesting raw source files to delivering business-ready models for reporting and decision-making.

🔷What I Built

1. **Data Architecture** — Designed a modern data warehouse following Medallion Architecture (Bronze → Silver → Gold), ensuring clean separation between raw, processed, and analytical data layers. 
2. **ETL Pipelines** — Engineered end-to-end pipelines to extract data from ERP and CRM source systems (CSV files), apply multi-stage transformations, and load into MySQL using a Batch Processing / Truncate & Insert strategy. 
3. **Data Modelin** — Developed a Star Schema with optimized fact and dimension tables in the Gold Layer to support fast, reliable analytical queries. 
4. **Analytics & Reporting** — Wrote SQL-based reports uncovering insights across customer behaviour, product performance, and sales trends to support strategic business decisions.

🎯 Skills Demonstrated: 
SQL Development | 
Data Architecture  | 
Data Engineering  | 
ETL Pipeline Development  | 
Data Modeling  | 
Data Analytics
 
---

## 🛠️ Tools & Technologies

Everything used in this project is **free and open-source!**

- **[Datasets](datasets/):** Project dataset (CSV files for ERP and CRM systems).
- **[MySQL Community Server](https://dev.mysql.com/downloads/mysql/):** Free, open-source relational database for hosting your data warehouse.
- **[MySQL Workbench](https://dev.mysql.com/downloads/workbench/):** Official GUI for designing, managing, and querying your MySQL database.
- **[Git & GitHub](https://github.com/):** Version control and collaboration for managing project code efficiently.
- **[DrawIO](https://app.diagrams.net/#G1BS49VMa_6rNBMVTftVlIBNWJD5B8kVr4#%7B%22pageId%22%3A%22pyaN47I_QU9WjZoiCXYB%22%7D):** Design data architecture diagrams, data flow diagrams, and data models.
- **[Notion](https://www.notion.so/Data-Warehouse-Project-354a12eedddc80eebaa7fcc708d45c9b):** Project planning template for tracking phases and tasks.

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using **MySQL** to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

### BI: Analytics & Reporting (Data Analysis)

#### Objective
Develop SQL-based analytics to deliver detailed insights into:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

For more details, refer to [docs/requirements.md](docs/requirements.md).

---

## 📂 Repository Structure

```
sql-data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Draw.io file showing ETL techniques and methods
│   ├── data_architecture.drawio        # Draw.io file showing the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality assurance files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project
```

---

## ⚙️ Getting Started

Follow these steps to set up and run the project on your local machine:

1. **Install MySQL Community Server** from [mysql.com](https://dev.mysql.com/downloads/mysql/)
2. **Install MySQL Workbench** from [mysql.com](https://dev.mysql.com/downloads/workbench/)
3. **Clone this repository:**
   ```bash
   git clone https://github.com/Rameshsah08/SQL_Data_Warehouse_Project.git
   ```
4. **Open MySQL Workbench** and connect to your local MySQL server.
5. **Run scripts in order:**
   - `scripts/bronze/` → Load raw data
   - `scripts/silver/` → Clean and transform data
   - `scripts/gold/` → Build analytical models
6. **Explore the analytics** using the SQL queries in the `tests/` folder.

---

## 🌟 About Me

Hi there! I'm Ramesh Sah, a Computer Science student at the University for the Creative Arts, Farnham, passionate about turning raw data into meaningful insights. I'm actively building my portfolio through hands-on projects in SQL, data engineering, and analytics — with the goal of landing a job or internship in the data industry.
This project is part of my personal portfolio to demonstrate real-world data engineering skills to potential employers.
Feel free to check out my work and connect with me:

[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Rameshsah08/SQL_Data_Warehouse_Project)
[![Linkdln](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/feed/)

---

## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.
