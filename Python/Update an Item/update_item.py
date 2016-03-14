# This example makes use of the excellent library at python-requests.org
import requests
import random
import urllib
import json
import sys

base_url = "{base url}/rest/latest/"

# Username and password should be stored according
# to your organization's security policies
username = "API_User"
password = "********"

string_to_find = "Unique string"

def main():
    item_id = get_id(string_to_find)
    update_item(item_id)

def get(url):
    response = requests.get(url, auth=(username, password))
    return json.loads(response.text)

def put(url, payload):
    response = requests.put(url, json=payload, auth=(username, password))
    return response.status_code

def get_id(string_to_find):
    url = base_url + "abstractitems?contains=" + string_to_find
    json_response = get(url)

    total_results = json_response["meta"]["pageInfo"]["totalResults"]

    if total_results == 1:
        data = json_response["data"]
        item = data[0]
        return item["id"]

    else:
        print "string_to_find wasn't unique"
        sys.exit(1)

def update_item(item_id):
    set_lock_state(True, item_id)
    item = get_item(item_id)
    item["fields"]["description"] += test_results()
    put_item(item_id, item)
    set_lock_state(False, item_id)

def set_lock_state(new_lock_state, item_id):
    payload = {
        "locked": new_lock_state
    }
    url = base_url + "items/" + str(item_id) + "/lock"
    put(url, payload)

def get_item(item_id):
    url = base_url + "items/" + str(item_id)
    json_response = get(url)

    return json_response["data"]

def put_item(item_id, item):
    url = base_url + "items/" + str(item_id)
    status_code = put(url, item)
    if status_code < 400:
        print "Success"

def test_results():
    template = "<p><strong>Imported test results:</strong></p>Status:&nbsp;"
    test_passed = random.randrange(0,2)
    if test_passed == 1:
        return template + "pass"
    return template + "fail"

if __name__ == "__main__":
    main()

