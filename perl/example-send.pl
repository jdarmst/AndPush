#
# AndPush Perl Example (v0.0.1) - By Louis T.
#
# Requires LWP::UserAgent (cpan install LWP::UserAgent)
# Note: API returns JSON, you might want to parse that.

use LWP::UserAgent;
 
my $ua = LWP::UserAgent->new;

my $resp = $ua->post(
   'http://api.andpush.net/send',
   { # You can pass anything the API supports. (http://andpush.net/#api)
      apikey => 'API Key 1, API Key 2', # Multiple keys may be passed, comma separated (maximum of 25).
      message => 'Example from Perl!', # Can include BB code. (http://andpush.net/#bbcode)
      title => 'Example Message',
   }
); 
 
if ($resp->is_success) {
   my $message = $resp->decoded_content;
   print "Result: $message\n";
 } else {
   print "POST Error: ", $resp->code, "\n", $resp->message, "\n";
}
