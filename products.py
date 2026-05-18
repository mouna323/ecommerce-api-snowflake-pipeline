# fetch api data 
import requests
url = "https://dummyjson.com/products"
response = requests.get(url)
data = response.json()

# and save as json file
#dump Converts Python dictionary back into JSON string
import json
with open("products.json", "w") as file:
    json.dump(data, file, indent=4)
print("Products JSON saved")


#explore data
print(type(data))
print(data.keys())
print(data["products"][0])
print(data["products"][0].keys())
