# Brazilian E-Commerce Data Engineering Project

This project is a data engineering pipeline that processes the [Brazilian E-Commerce Dataset from Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?select=olist_order_items_dataset.csv). It uses Snowflake as the data warehouse, dbt (Data Build Tool) for data transformation, GitHub Actions for CI/CD, and Power BI for visualization. The project also implements Slowly Changing Dimension (SCD) Type 2 using dbt snapshots to track historical changes in dimension tables.

## Table of Contents

1. Dataset Description
2. Architecture
3. CI/CD Pipeline
4. SCD Type 2 Implementation
5. Visualization
6. Documentation

## Dataset Description

This is a Brazilian ecommerce public dataset of orders made at Olist Store. The dataset has information of 100k orders from 2016 to 2018 made at multiple marketplaces in Brazil. Its features allows viewing an order from multiple dimensions: from order status, price, payment and freight performance to customer location, product attributes and finally reviews written by customers. it also contains a geolocation dataset that relates Brazilian zip codes to lat/lng coordinates. Below is the data schema

![Data Schema](https://i.imgur.com/HRhd2Y0.png)

## Architecture

The project follows a modular architecture:

1. Data Source: Brazilian E-Commerce Dataset (Kaggle).
2. Data Warehouse: Snowflake (raw and transformed data storage).
3. Transformation: dbt (fact and dimension tables, SCD Type 2 snapshots).
4. CI/CD: GitHub Actions (automated testing and deployment).
5. Visualization: Power BI (dashboards and reports).

A visual representation of the project architecture is shown below
![alt text](https://github.com/ShawonSimon/brazilian-ecommerce-dbt-snowflake/blob/main/screenshots/dbtSnowflake.drawio.png)

## CI/CD Pipeline

The CI/CD pipeline is implemented using GitHub Actions:
-Automatically runs dbt deps, dbt test, and dbt run on push, pull requests, and merges to the main branch. Additionally, the pipeline is scheduled to run at midnight on the first day of every month and can be triggered manually via GitHub Actions.

## SCD Type 2 Implementation

SCD Type 2 is implemented using dbt snapshots to track historical changes in dimension tables (e.g., customers, products). The snapshot tables include:
- snapshot_sellers: Tracks changes in the dimSellers table using the timestamp strategy, monitoring the updated_at column.
- snapshot_customers: Tracks changes in the dimCustomer table using the check strategy, monitoring the customer_city and customer_state columns

## Visualization

An interactive dashboard is then created to visualize the data using Power BI as shown below
![alt text](https://github.com/ShawonSimon/brazilian-ecommerce-dbt-snowflake/blob/main/screenshots/Dashboard.png)

## Documentation

The project includes comprehensive documentation generated using dbt docs. The documentation provides:
- Data Lineage: Visual representation of how data flows through the pipeline.
- Model Descriptions: Details about each dbt model, including SQL code and dependencies.
- Column Descriptions: Metadata about columns in each table.
- Tests: Information about data quality tests applied to the models.
A snapshot of the DBT Completed DAG can be seen below
![alt text](https://github.com/ShawonSimon/brazilian-ecommerce-dbt-snowflake/blob/main/screenshots/dbt-DAG.png)

