<?PHP
$base_url = "{base url}/rest/latest/";

# Username and password should be stored according
# to your organization's security policies
$username = "API_User";
$password = "********";

$resource = "projects";

$options = array(
    "http"=>array(
        "method"=>"GET",
        "header"=> "Authorization: Basic " . base64_encode("$username:$password")
    )
);
$context = stream_context_create($options);

$result = file_get_contents($base_url . $resource, false, $context);

echo $result;
?>

