#import libraries
import json
import pandas as pd
import snowflake.connector

# Connect to Snowflake /conn = connection to Snowflake database
conn=snowflake.connector.connect(
    user='MOUNA92',
    password='Dbtraining@2026',
    account='ZAJUNLK-KZ51773',
    warehouse='COMPUTE_WH',
    database='ECOMMERCE_DB',
    schema='RAW'
)
#test connection
print("Connected to Snowflake")

#create cursor /object used to send  SQL commands to snowflake and  executeit and fetch(return) results from the database
cursor=conn.cursor()


#ingest json file to snowflake
# Read local JSON file
#PRODUCT FILE
with open("products.json", "r") as file:
    products_data = json.load(file)

#Insert records into Snowflake
#json.dump:Converts Python dictionary back into JSON string
#PARSE_JSON:Converts JSON string into Snowflake VARIANT

for product in products_data["products"]:
    cursor.execute(
        """
        INSERT INTO ECOMMERCE_DB.RAW.RAW_PRODUCTS(raw_data)
        SELECT PARSE_JSON(%s)
        """,
        (json.dumps(product),)
    )
    #Commit changes to Snowflake
    conn.commit()
    #test 
    print("Products loaded into Snowflake")
    
  #CARTS FILE
with open("carts.json", "r") as file:
    carts_data = json.load(file)
    
for cart in carts_data["carts"]:
    cursor.execute(
        """
        INSERT INTO ECOMMERCE_DB.RAW.RAW_CARTS(raw_data)
        SELECT PARSE_JSON(%s)
        """,
        (json.dumps(cart),)
    )
    conn.commit()
    print("Carts loaded into Snowflake")    
    
    #USERS FILE
with open("users.json", "r") as file:
    users_data = json.load(file)
    
for user in users_data["users"]:
    cursor.execute(
        """
        INSERT INTO ECOMMERCE_DB.RAW.RAW_USERS(raw_data)
        SELECT PARSE_JSON(%s)
        """,
        (json.dumps(user),)
    )
conn.commit()
print("Users loaded into Snowflake")    