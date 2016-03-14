<?php
$base_url = "{base url}/rest/latest/";

# Username and password should be stored according
# to your organization's security policies
$username = "API_User";
$password = "********";

$string_to_find = "Unique string";

$contains_parameter = "contains=" . urlencode($string_to_find);

$url = $base_url . "abstractitems?" . $contains_parameter;

$curl_request = curl_init();
curl_setopt($curl_request, CURLOPT_URL, $url);
curl_setopt($curl_request, CURLOPT_USERPWD, "$username:$password");
curl_setopt($curl_request, CURLOPT_RETURNTRANSFER, True);

$result = curl_exec($curl_request);
curl_close($curl_request);

$json_response = json_decode($result, true);
$total_results = $json_response['meta']['pageInfo']['totalResults'];

if($total_results == 1) {
    $data = $json_response['data'];
    $item = $data[0];

    echo $item['fields']['name'] . "\n";
}
else {
    echo "string_to_find wasn't unique\n";
}

?>
