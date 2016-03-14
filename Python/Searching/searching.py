# This example makes use of the excellent library at python-requests.org
import requests
import urllib
import json

base_url = "{base url}/rest/latest/"

# Username and password should be stored according
# to your organization's security policies
username = "API_User"
password = "********"

string_to_find = "Unique string"

contains_parameter = "contains=" + urllib.quote_plus(string_to_find)

url = base_url + "abstractitems?" + contains_parameter
response = requests.get(url, auth=(username, password))

json_response = json.loads(response.text)
total_results = json_response["meta"]["pageInfo"]["totalResults"]

if total_results == 1:
    data = json_response["data"]
    item = data[0]

    print item["fields"]["name"]

else:
    print "string_to_find wasn't unique"

