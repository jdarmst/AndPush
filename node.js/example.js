/*
  AndPush Node.js Example (v0.0.1) - By Louis T.
*/
var AndPush = require("./");

/*
  AndPush.send(<apikeys (Array)>,<request (Object)>[,<callback (Function)>]);
  Note: "apikeys" is an Array of up to 25 API keys.
        "request" is an Object with any of the allowed API parameters. (http://andpush.net/#api)
*/
AndPush.send(["API Key 1","API Key 2"], {message:"Example from Node.js!", title:"Example Message", url: "http://andpush.net/", urltitle: "AndPush"}, function (err, data) {
    if (!err && !("error" in data)) {
       console.log("Message sent!");
     } else {
       console.log("Message failed! ("+((!err&&"error" in data)?data.error:err.message)+")");
    };
});

/*
  AndPush.verify(<apikey (String)>;
  Note: "apikey" is a single API key to verify.
*/
AndPush.verify("API Key",function (err, data) {
     if (!err && ("success" in data)) {
        console.log("Valid API key!");
      } else {
        console.log("Invalid API key! ("+((!err&&"error" in data)?data.error:err.message)+")");
     }
});

