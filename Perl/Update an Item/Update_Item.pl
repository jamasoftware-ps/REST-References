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

my $item_id = get_id($string_to_find);
update_item($item_id);

sub get {
    my ($url) = @_;

    my $browser = LWP::UserAgent->new;
    my $req = HTTP::Request->new( GET => $url );
    $req->authorization_basic( $username, $password );
    my $res = $browser->request( $req );

    return from_json( $res->content );
}

sub put {
    my ($url, $payload) = @_;
    my $json = JSON->new->encode($payload);

    my $browser = LWP::UserAgent->new;
    my $req = HTTP::Request->new( PUT => $url);
    $req->authorization_basic( $username, $password );
    $req->header( "Content-Type" => "application/json" );
    $req->content( "$json" );

    my $res = $browser->request( $req );
    return $res->code();
}

sub get_id {
    my ($string_to_find) = @_;

    my $url = $base_url . "abstractitems?contains=" . $string_to_find;
    my $json_response = get($url);

    my $total_results = $json_response->{"meta"}->{"pageInfo"}->{"totalResults"};    

    if($total_results == 1) {
        my $data = $json_response->{"data"};
        my $item = $data->[0];
        return $item->{"id"};
    }
    else {
        print "string_to_find wasn't unique\n";
        exit 1;
    }
}

sub update_item {
    my ($item_id) = @_;

    set_lock_state("true", $item_id);
    my $item = get_item($item_id);
    $item->{"fields"}->{"description"} .= test_results();
    put_item($item_id, $item);
    set_lock_state("false", $item_id);

}

sub set_lock_state {
    my ($lock_state, $item_id) = @_;

    my $payload = {"locked" => $lock_state};
    my $url = $base_url . "items/" . $item_id . "/lock";
    put($url, $payload);
}

sub get_item {
    my ($item_id) = @_;

    my $url = $base_url . "items/" . $item_id;
    my $json_response = get($url);

    return $json_response->{"data"};
}

sub put_item {
    my ($item_id, $item) = @_;

    my $url = $base_url . "items/" . $item_id;
    my $status_code = put($url, $item);

    if($status_code < 400) {
        print "Success\n";
    }
}

sub test_results {
    my $template = "<p><strong>Imported test results:</strong></p>Status:&nbsp;";
    my $test_passed = int(rand(2));
    if($test_passed) {
        return $template . "pass";
    }
    return $template . "fail";
}


