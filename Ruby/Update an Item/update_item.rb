require "net/http"
require "json"
require "uri"

$base_url = "{base url}/rest/latest/"

# Username and password should be stored according
# to your organization's security policies
$username = "API_User"
$password = "********"

string_to_find = "Unique string"

def get(url)
    uri = URI(url)
    Net::HTTP.start(uri.host, uri.port,
        :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new(uri)
        request.basic_auth($username, $password)
        response = http.request(request)

        return JSON.parse(response.body)
    end
end

def put(url, payload)
    uri = URI(url)
    Net::HTTP.start(uri.host, uri.port,
        :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Put.new(
            uri,
            initheader = {"Content-Type" => "application/json"} 
        )
        request.basic_auth($username, $password)
        request.body = payload.to_json
        response = http.request(request)
        return response.code
    end
end

def get_id(string_to_find)
    url = "#{$base_url}abstractitems?contains=#{URI.escape(string_to_find)}"
    json_response = get(url)

    total_results = json_response["meta"]["pageInfo"]["totalResults"]

    if total_results == 1
        data = json_response["data"]
        item = data[0]
        return item["id"]
    else
        puts "string_to_find wasn't unique"
        exit
    end
end

def update_item(item_id)
    set_lock_state(true, item_id)
    item = get_item(item_id)
    item["fields"]["description"] += test_results
    put_item(item_id, item)
    set_lock_state(false, item_id)
end

def set_lock_state(new_lock_state, item_id)
    payload = {
        "locked" => new_lock_state
    }

    url = "#{$base_url}items/#{item_id}/lock"
    put(url, payload)
end

def get_item(item_id)
    url = "#{$base_url}items/#{item_id}"
    json_response = get(url)

    return json_response["data"]
end

def put_item(item_id, item)
    url = "#{$base_url}items/#{item_id}"
    status_code = put(url, item)
    if status_code.to_i < 400
        puts "Success"
    end
end

def test_results()
    template = "<p><strong>Imported test results:</strong></p>Status:&nbsp;"
    test_passed = rand(2)
    if test_passed == 1
        return "#{template}pass"
    end
    return "#{template}fail"
end 

item_id = get_id(string_to_find)
update_item(item_id)

