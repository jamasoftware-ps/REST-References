#!/usr/bin/env perl
use LWP;
use JSON;
use URI::Escape;

$base_url = "{base url}/rest/latest/";

# Username and password should be stored according
# to your organization's security policies
$username = "API_User";
$password = "********";

my $string_to_find = "Unique string";

my $contains_parameter = "contains=" . uri_escape($string_to_find);

my $browser = LWP::UserAgent->new;
my $url = $base_url . "abstractitems?" . $contains_parameter;
my $req = HTTP::Request->new( GET => $url );
$req->authorization_basic( $username, $password );
my $res = $browser->request( $req );

my $json_response = from_json( $res->content );

my $total_results = $json_response->{"meta"}->{"pageInfo"}->{"totalResults"};    

if($total_results == 1) {
    my $data = $json_response->{"data"};
    my $item = $data->[0];

    print $item->{"fields"}->{"name"} . "\n";
}
else {
    print "string_to_find wasn't unique" . "\n";
}

