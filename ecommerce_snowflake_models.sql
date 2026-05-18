-- Set working environment
-- create database and use it

CREATE DATABASE IF NOT EXISTS ECOMMERCE_DB;
USE DATABASE ECOMMERCE_DB;

--raw layer
-- create schema and use it 
--  RAW SCHEMA
CREATE SCHEMA IF NOT EXISTS ECOMMERCE_DB.RAW;
USE SCHEMA ECOMMERCE_DB.RAW;


--create tables
CREATE OR REPLACE TABLE ECOMMERCE_DB.RAW.RAW_PRODUCTS(
    raw_data variant
);
CREATE OR REPLACE TABLE ECOMMERCE_DB.RAW.RAW_USERS(
    raw_data variant
);
CREATE OR REPLACE TABLE ECOMMERCE_DB.RAW.RAW_CARTS(
    raw_data variant
);

--exploratory transformation queries
SELECT*FROM ECOMMERCE_DB.RAW.RAW_PRODUCTS LIMIT 5;
SELECT 
    raw_data:id as product_id,
    raw_data:title as product_title,
    raw_data:category as product_category,
    raw_data:price as product_price
FROM ECOMMERCE_DB.RAW.RAW_PRODUCTS ;


SELECT * FROM ECOMMERCE_DB.RAW.RAW_USERS ;
SELECT 
    raw_data:id as user_id,
    raw_data:age as user_age,
    raw_data:gender as user_gender,
    raw_data:address.country as user_country, /* nested json object*/
    raw_data:company.department as user_job /* nested object*/
from ECOMMERCE_DB.RAW.RAW_USERS ;

SELECT * FROM ECOMMERCE_DB.RAW.RAW_CARTS ;
-- nested list/array need to flattening to convert array into row
SELECT 
    raw_data:id as cart_id,
    product.value:id as product_id ,
    product.value:title as product_title ,
    product.value:price as product_price,
    product.value:quantity as product_quantity,
    product.value:total as item_total
FROM ECOMMERCE_DB.RAW.RAW_CARTS ,
LATERAL FLATTEN(INPUT => raw_data:products)product;
/* get nested array by (raw_data:products) and explode it with (LATERAL FLATTEN) item by item (product.value) */


-- create schema or staging
-- staging layer
-- STAGING SCHEMA
CREATE  SCHEMA IF NOT EXISTS ECOMMERCE_DB.STAGING;
USE SCHEMA ECOMMERCE_DB.STAGING;

-- create view stages/reusable staging views
CREATE OR REPLACE VIEW ECOMMERCE_DB.STAGING.STG_PRODUCTS AS
    SELECT 
        raw_data:id::INT as product_id,
        raw_data:title::STRING as product_title,
        raw_data:category::STRING as product_category,
        raw_data:brand::STRING as product_brand,
        raw_data:stock::INT as product_stock,
        raw_data:price::FLOAT as product_price
    FROM ECOMMERCE_DB.RAW.RAW_PRODUCTS ;
    

CREATE OR REPLACE VIEW ECOMMERCE_DB.STAGING.STG_USERS AS
    SELECT 
        raw_data:id::INT as user_id,
        raw_data:firstName::string as first_name,
        raw_data:lastName::string as last_name,
        raw_data:age::INT as user_age,
        raw_data:gender::STRING as user_gender,
        raw_data:address.country::STRING as user_country, -- nested json object
        raw_data:company.department::STRING as user_job -- nested object
    FROM ECOMMERCE_DB.RAW.RAW_USERS ;
    

CREATE OR REPLACE VIEW ECOMMERCE_DB.STAGING.STG_CARTS AS 
    SELECT 
        raw_data:id::INT as cart_id,
        product.value:id::INT as product_id ,
        product.value:title::STRING as product_title ,
        product.value:price::FLOAT as product_price,
        product.value:quantity::INT as product_quantity,
        product.value:total::FLOAT as item_total
    FROM ECOMMERCE_DB.RAW.RAW_CARTS ,
    LATERAL FLATTEN(INPUT => raw_data:products)product;

--Build MART layer
CREATE SCHEMA IF NOT EXISTS ECOMMERCE_DB.MARTS;

-- cart_items view table
--fact transacitional table
    CREATE OR REPLACE VIEW ECOMMERCE_DB.MARTS.CART_ITEMS AS 
        SELECT
        raw_data:id::INT as cart_id,
        product.value:id::INT as product_id ,
        product.value:title::STRING as product_title ,
        product.value:price::FLOAT as product_price,
        product.value:quantity::INT as product_quantity,
        product.value:total::FLOAT as item_total,
        product.value:discountPercentage::FLOAT as discount_percentage,
        product.value:discountedTotal::FLOAT as total_discount
    FROM ECOMMERCE_DB.RAW.RAW_CARTS ,
    LATERAL FLATTEN(INPUT => raw_data:products)product;

SELECT * FROM ECOMMERCE_DB.MARTS.CART_ITEMS LIMIT 10;


--view dimensional tables 
--products DIMENSION
CREATE OR REPLACE VIEW ECOMMERCE_DB.MARTS.DIM_PRODUCTS AS 
    SELECT
        product_id,
        product_title,
        product_category,
        product_brand,
        product_stock,
        product_price 
    FROM ECOMMERCE_DB.STAGING.STG_PRODUCTS ;

-- USERS DIMENSION
 CREATE OR REPLACE VIEW ECOMMERCE_DB.MARTS.DIM_USERS AS 
    SELECT
        user_id,
        first_name,
        last_name,
        user_age,
        user_gender,
        user_job,
        user_countr
    FROM ECOMMERCE_DB.STAGING.STG_USERS;

--VALIDATION QUERIES
-- REVENUE
SELECT 
    SUM(item_total)
FROM ECOMMERCE_DB.MARTS.CART_ITEMS;

--TOP PRODUCTS 
SELECT 
    product_title,
    SUM(product_quantity) as product_quantity
FROM ECOMMERCE_DB.MARTS.CART_ITEMS
GROUP BY product_title
ORDER BY product_quantity DESC
LIMIT 10;

--CUSTOMER SPENDS
SELECT 
    user_id,
    SUM(total_discount) AS total_discounts
    FROM ECOMMERCE_DB.MARTS.CART_ITEMS 
    GROUP BY user_id 
    ORDER BY total_discounts DESC
    LIMIT 10;



SELECT DISTINCT product_id
FROM ECOMMERCE_DB.MARTS.CART_ITEMS
WHERE product_id NOT IN (
    SELECT product_id
    FROM ECOMMERCE_DB.MARTS.DIM_PRODUCTS
);
        
        
