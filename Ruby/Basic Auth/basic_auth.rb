require "net/http"

base_url = "{base url}/rest/latest/"

# Username and password should be stored according
# to your organization's security policies
username = "API_User"
password = "********"

resource = "projects"

uri = URI(base_url + resource)

Net::HTTP.start(uri.host, uri.port, 
    :use_ssl => uri.scheme == 'https') do |http| 
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(username, password)
    response = http.request(request)

    puts response.body
end
