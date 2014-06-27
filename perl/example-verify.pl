#
# AndPush Perl Example (v0.0.1) - By Louis T.
#
# Requires LWP::UserAgent (cpan install LWP::UserAgent)
# Note: API returns JSON, you might want to parse that.

use LWP::UserAgent;
 
my $ua = LWP::UserAgent->new;

my $resp = $ua->post(
   'http://api.andpush.net/verify',
   {
      apikey => 'API Key', # Only a single API key may be passed.
   }
); 
 
if ($resp->is_success) {
   my $message = $resp->decoded_content;
   print "Result: $message\n";
 } else {
   print "POST Error: ", $resp->code, "\n", $resp->message, "\n";
}
