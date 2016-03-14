<?php
$base_url = "{base url}/rest/latest/";

# Username and password should be stored according
# to your organization's security policies
$username = "API_User";
$password = "********";

$string_to_find = "Unique string";

$item_id = getId($string_to_find);
update_item($item_id);

function get($url) {
    global $username, $password;

    $curl_request = curl_init();
    curl_setopt($curl_request, CURLOPT_URL, $url);
    curl_setopt($curl_request, CURLOPT_USERPWD, "$username:$password");
    curl_setopt($curl_request, CURLOPT_RETURNTRANSFER, True);

    $result = curl_exec($curl_request);
    curl_close($curl_request);

    return json_decode($result, true);
}

function put($url, $payload) {
    global $username, $password;

    $curl_request = curl_init();
    curl_setopt($curl_request, CURLOPT_URL, $url);
    curl_setopt($curl_request, CURLOPT_USERPWD, "$username:$password");
    curl_setopt($curl_request, CURLOPT_RETURNTRANSFER, True);
    curl_setopt($curl_request, CURLOPT_CUSTOMREQUEST, 'PUT');
    curl_setopt($curl_request, CURLOPT_POSTFIELDS, json_encode($payload));
    curl_setopt($curl_request, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
    curl_setopt($curl_request, CURLOPT_RETURNTRANSFER, True);

    curl_exec($curl_request);
    $response_code = curl_getinfo($curl_request, CURLINFO_HTTP_CODE);
    curl_close($curl_request);
    return $response_code;
}

function getId($to_find) {
    global $base_url;

    $url = $base_url . "abstractitems?contains=" . urlencode($to_find);
    $json_response = get($url);

    $total_results = $json_response['meta']['pageInfo']['totalResults'];

    if($total_results == 1) {
        $data = $json_response['data'];
        $item = $data[0];
        return $item['id'];
    }
    else {
        echo "string_to_find wasn't unique";
        exit(1);
    }
}

function update_item($item_id) {
    set_lock_state(True, $item_id);
    $item = get_item($item_id);
    $item['fields']['description'] .= test_results();
    put_item($item_id, $item);
    set_lock_state(False, $item_id);
}

function set_lock_state($new_lock_state, $item_id) {
    global $base_url;

    $payload = array('locked' => $new_lock_state);
    $url = $base_url . "items/" . $item_id . "/lock";   
    put($url, $payload);
}

function get_item($item_id) {
    global $base_url;

    $url = $base_url . "items/" . $item_id;
    $json_response = get($url);

    return $json_response['data'];
}

function put_item($item_id, $item) {
    global $base_url;

    $url = $base_url . "items/" . $item_id;
    $status_code = put($url, $item);
    if($status_code < 400) {
        echo "Success";
    }
}

function test_results() {
    $template = "<p><strong>Imported test results:</strong></p>Status:&nbsp;";
    $test_passed = rand(0, 1);
    if($test_passed == 1) {
        return $template . "pass";
    }
    return $template . "fail";
}


?>
