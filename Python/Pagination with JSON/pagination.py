# This example makes use of the excellent library at python-requests.org
import requests
import json

base_url = "{base url}/rest/latest/"

# Username and password should be stored according
# to your organization's security policies
username = "API_User"
password = "********"

resource = "projects"

allowed_results = 20
max_results = "maxResults=" + str(allowed_results)

result_count = -1
start_index = 0

while result_count != 0:
    startAt = "startAt=" + str(start_index)

    url = base_url + resource + "?" + startAt + "&" + max_results
    response = requests.get(url, auth=(username, password))
    json_response = json.loads(response.text)

    page_info = json_response["meta"]["pageInfo"]
    start_index = page_info["startIndex"] + allowed_results
    result_count = page_info["resultCount"]

    projects = json_response["data"]
    for project in projects:
        print project["fields"]["name"]

