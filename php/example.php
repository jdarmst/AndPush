<?php
/*
  AndPush PHP Example (v0.0.1) - By Louis T.
*/

/*
  send(<request (Array)>);
  Note: "request" is the full request to the API. "apikey" and "message" are required at minimum.
        "apikey" is a string containing at least one valid API key, multiple separated by commas (maximum of 25).
        "message" is the message you wish to push. Can contain BB code. (http://andpush.net/#bbcode)
        Other valid options are any other paramaters the API supports. (http://andpush.net/#api)

  Returns an array of: Array(<error (Boolean)>,<response (Array)>)
*/
function send ($req) {
         $opts = Array('http' =>
             Array (
                 'method'  => 'POST',
                 'header'  => 'Content-type: application/x-www-form-urlencoded',
                 'content' => http_build_query($req),
             )
         );
         $result = @file_get_contents('http://api.andpush.net/send', false, stream_context_create($opts));
         if ($result) {
            $json = @json_decode($result,true);
            if ($json && !isset($json["error"])) {
               return Array(false,$json);
             } else {
               return Array(true,($json?$json["error"]:Array("code" => -1, "error"=>"Error parsing JSON.")_);
            };
          } else {
            return Array(true,Array("code" => -2, "error"=>"Error connecting to API."));
         };
};

/*
  verify(<apikey (String)>)
  Note: "apikey" is a single API key you wish to verify.

  Returns an array of: Array(<error (Boolean)>,<response (Array)>)
*/
function verify ($apikey) {
         $opts = Array('http' =>
             Array (
                 'method'  => 'POST',
                 'header'  => 'Content-type: application/x-www-form-urlencoded',
                 'content' => http_build_query(Array("apikey"=>$apikey)),
             )
         );
         $result = @file_get_contents('http://api.andpush.net/verify', false, stream_context_create($opts));
         if ($result) {
            $json = @json_decode($result,true);
            if ($json && !isset($json["error"])) {
               return Array(false,$json);
             } else {
               return Array(true,($json?$json["error"]:Array("code" => -1, "error"=>"Error parsing JSON.")_);
            };
          } else {
            return Array(true,Array("code" => -2, "error"=>"Error connecting to API."));
         };
}
?>
