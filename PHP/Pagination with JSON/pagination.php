<?php
$base_url = "{base url}/rest/latest/";

# Username and password should be stored according
# to your organization's security policies
$username = "API_User";
$password = "********";

$resource = "projects";

$allowed_results = 20;
$max_results = "maxResults=" . $allowed_results;

$result_count = -1;
$start_index = 0;

while($result_count != 0) {
    $start_at = "startAt=" . $start_index;

    $url = $base_url . $resource . "?" . $start_at . "&" . $max_results;

    $curl_request = curl_init();
    curl_setopt($curl_request, CURLOPT_URL, $url);
    curl_setopt($curl_request, CURLOPT_USERPWD, "$username:$password");
    curl_setopt($curl_request, CURLOPT_RETURNTRANSFER, True);

    $result = curl_exec($curl_request);
    curl_close($curl_request);

    $json_response = json_decode($result, true);
    $page_info = $json_response['meta']['pageInfo'];
    $start_index = $page_info['startIndex'] + $allowed_results;
    $result_count = $page_info['resultCount'];

    $projects = $json_response['data'];
    foreach($projects as $project) {
        echo $project['fields']['name'] . "\n";
    }
}
?>
