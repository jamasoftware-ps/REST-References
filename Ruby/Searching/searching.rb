require "net/http"
require "json"
require "uri"

base_url = "{base url}/rest/latest/"

# Username and password should be stored according
# to your organization's security policies
username = "API_User"
password = "********"

string_to_find = "Unique string"

contains_parameter = URI.escape("contains=#{string_to_find}")

uri = URI("#{base_url}abstractitems?#{contains_parameter}")
Net::HTTP.start(uri.host, uri.port, 
    :use_ssl => uri.scheme == 'https') do |http| 
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(username, password)
    response = http.request(request)
    
    json_response = JSON.parse(response.body)
    total_results = json_response["meta"]["pageInfo"]["totalResults"]

    if total_results == 1 then
        data = json_response["data"]
        item = data[0]

        puts item["fields"]["name"]
    else
        puts "string_to_find wasn't unique"
    end
end
