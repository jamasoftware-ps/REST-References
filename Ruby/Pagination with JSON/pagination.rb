require "net/http"
require "json"

base_url = "{base url}/rest/latest/"

# Username and password should be stored according
# to your organization's security policies
username = "API_User"
password = "********"

resource = "projects"

allowed_results = 20
max_results = "maxResults=#{allowed_results}"

result_count = -1
start_index = 0

while result_count != 0 do
    start_at = "startAt=#{start_index}"

    uri = URI("#{base_url}#{resource}?#{start_at}&#{max_results}")
    Net::HTTP.start(uri.host, uri.port, 
        :use_ssl => uri.scheme == 'https') do |http| 
        request = Net::HTTP::Get.new(uri)
        request.basic_auth(username, password)
        response = http.request(request)
        
        json_response = JSON.parse(response.body)

        page_info = json_response["meta"]["pageInfo"]
        start_index = page_info["startIndex"] + allowed_results
        result_count = page_info["resultCount"]

        projects = json_response["data"]
        projects.each do |project| 
            puts project["fields"]["name"]
        end
    end
end
