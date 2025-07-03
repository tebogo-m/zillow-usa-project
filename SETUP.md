# Project Setup 
## How I setup Snowflake and dbt to build the ELT pipeline

Project Step by Step

***Environment Setup:***

***Install dbt core***  
Enter the following commands in your terminal to install dbt core
- python3 -m pip install dbt-core==1.9
- python3 -m pip show dbt-core (this command checks if dbt downloaded correctly)

Then Install Snowflake connector to be able to use it for databases and warehousing
-python3 -m pip install dbt-snowflake


Then Login to Snowflake and create warehouse, database and role:

use role accountadmin;

create warehouse if not exists zillow_wh with warehouse_size='x-small';
create database if not exists zillow_dbt_project_db;
create role if not exists dbt_role;

show grants on warehouse zillow_wh;

grant usage on warehouse zillow_wh to role dbt_role;
grant role dbt_role to user <your snowflake username>;
grant all on database zillow_dbt_project_db to role dbt_role;

use role dbt_role;







Extraction:

**Downloading Raw Data Files**
- Navigate to the NASDAQ Data Link site
- Download the Zillow Real Estate Data Files:
  - ZILLOW_REGIONS
  - ZILLOW_INDICATORS
  - ZILLOW_DATA (aliased as zillow_home_values for this project)
 
**Note** : The ZILLOW_DATA file is greater than 5GB and has over 158M records so you will not be able to upload the data via Snowflake UI, you will have to use SnowSQL CLI.

Convert the large csv file to parquet format using the python pandas library (parquet file format might take longer to upload to Snowflake however it is known for making it easier to query the data

screenshot of python pandas pandas conversion


Loading:
***Loading the raw data files to Snowflake using SnowSQL**

