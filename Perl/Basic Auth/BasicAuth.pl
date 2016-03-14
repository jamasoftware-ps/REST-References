#!/usr/bin/env perl
use LWP;

$base_url = "{base url}/rest/latest/";

# Username and password should be stored according
# to your organization's security policies
$username = "API_User";
$password = "********";

$resource = "projects";

my $browser = LWP::UserAgent->new;
my $req = HTTP::Request->new( GET => $base_url . $resource );
$req->authorization_basic( $username, $password );
my $res = $browser->request( $req );

print $res->content;

