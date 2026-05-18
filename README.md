
# Ecommerce API Snowflake Pipeline
## 1. Project Overview
Built an end-to-end ELT pipeline using Python and Snowflake to ingest and transform semi-structured API JSON data into analytics-ready dimensional models.
The project focuses on handling nested JSON data, applying cloud warehouse modeling concepts, and transforming raw API data into structured analytical layers.

## 2. Workflow
The project workflow included:
1. Fetching API data, saving JSON files, and exploring data structure
2. Creating a connection between Python and Snowflake
3. Creating databases and schemas in Snowflake
4. Ingesting semi-structured JSON data into Snowflake RAW tables
5. Applying SQL transformations to handle JSON data across RAW, STAGING, and MARTS layers
6. Building analytical fact and dimension models for reporting and visualization

## 3. Tech Stack
- Python
- Snowflake
- SQL
- Tableau
- REST APIs
- JSON

## 4. Pipeline Architecture
API → Python → Snowflake RAW → STAGING → MARTS

## 5. Key Concepts Applied
- Semi-structured data handling
- Snowflake VARIANT columns
- JSON parsing
- LATERAL FLATTEN
- Dimensional modeling
- ELT workflow design
- Data validation and debugging

## 6. Challenges
- Inconsistent mock API relationships
- Orphan product IDs
- Limitations of demo datasets
- Handling nested JSON arrays and objects

## 7. Project Structure
ecommerce-api-snowflake-pipeline/
- README.md
- carts.py
- products.py
- users.py
- load_api_to_snowflake.py
- ecommerce_snowflake_models.sql

## 8.dataset links: 
carts url = "https://dummyjson.com/carts"
products url = "https://dummyjson.com/products"
users url = "https://dummyjson.com/users"

## Author
Mouna Al-Nasser  
Data Analyst
