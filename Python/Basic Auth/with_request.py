# This example makes use of the excellent library at python-requests.org
import requests

base_url = "{base url}/rest/latest/"

# Username and password should be stored according
# to your organization's security policies
username = "API_User"
password = "********"

resource = "projects"

response = requests.get(base_url + resource, auth=(username, password))

print response.text

