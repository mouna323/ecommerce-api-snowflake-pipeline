# fetch api data 
import requests
url = "https://dummyjson.com/users"
response = requests.get(url)
data = response.json()

# and save as json file
import json
with open("users.json", "w") as file:
    json.dump(data, file, indent=4)
print("Users JSON saved")

#explore data
print(type(data))
print(data.keys())
print(data["users"][0])
print(data["users"][0].keys())

