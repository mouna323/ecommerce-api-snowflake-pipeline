
# fetch api data 
import requests
url = "https://dummyjson.com/carts"
response = requests.get(url)
data = response.json()

# and save as json file
import json
with open("carts.json", "w") as file:
    json.dump(data, file, indent=4)
print("Carts JSON saved")

#explore data
print(type(data))
print(data.keys()) 
print(data["carts"][0])
print(data["carts"][0].keys())
print(type(data["carts"][0]["products"]))
print(data["carts"][0]["products"][0])
print(data["carts"][0]["products"][0].keys())
