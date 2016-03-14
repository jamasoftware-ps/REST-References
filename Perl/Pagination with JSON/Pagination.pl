#!/usr/bin/env perl
use LWP;
use JSON;

$base_url = "{base url}/rest/latest/";

# Username and password should be stored according
# to your organization's security policies
$username = "API_User";
$password = "********";

$resource = "projects";

my $browser = LWP::UserAgent->new;

my $allowed_results = 20;
my $max_results = "maxResults=" . $allowed_results;

my $result_count = -1;
my $start_index = 0;

while ($result_count != 0) {
    my $start_at = "startAt=" . $start_index;
    my $url = $base_url . $resource . "?" . $start_at . "&" . $max_results;
    my $req = HTTP::Request->new( GET => $url );
    $req->authorization_basic( $username, $password );
    my $res = $browser->request( $req );

    my $json_response = from_json( $res->content );

    my $page_info = $json_response->{"meta"}{"pageInfo"};
    $start_index = $page_info->{"startIndex"} + $allowed_results;
    $result_count = $page_info->{"resultCount"};

    
    foreach (@{ $json_response->{"data"} }) {
        print $_->{"fields"}->{"name"} . "\n";
    }
}

