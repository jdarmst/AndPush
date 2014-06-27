/*
  AndPush Node.js Example (v0.0.1) - By Louis T.
*/
var http = require("http"),
    qs = require("querystring"),
    url = require("url");
function AndPush () {
         if (!(this instanceof AndPush)) {
            return new AndPush();
         };
         this.apipath = "http://api.andpush.net";
         this.endpoints = {
              send: "/send",
              verify: "/verify"
         };
};
AndPush.prototype.isURL = function (url) {
         return /^https?:\/\/(?:(.[^\s@]*)@)?(?:([^:\s@\/?#]*)(?::(\d+))?)(\/[^\s\?#]*)?(\?[^\s#]*|)?(#.[^\s]*|)?$/i.test(url);
};
AndPush.prototype.send = function (apikeys, obj, cb) {
         var obj = {
             apikey: (Array.isArray(apikeys)?apikeys:[apikeys]).join(','),
             message: obj.message||"Hello from [b]AndPush[/b]!",
             title: obj.title||"AndPush w/ Node.js",
             icon: (this.isURL(obj.icon)?obj.icon:false),
             url: (this.isURL(obj.url)?obj.url:false),
             urltitle: obj.urltitle||false,
             alert: obj.alert||false,
         };
         Object.keys(obj).filter(function(key){ return obj[key]; });
         this.sendRequest(url.parse(this.apipath+this.endpoints.send),qs.stringify(obj),cb||function(){});
};
AndPush.prototype.verify = function (apikey, cb) {
         var obj = {
             apikey: (Array.isArray(apikey)?apikey[0]:apikey),
         };
         Object.keys(obj).filter(function(key){ return obj[key]; });
         this.sendRequest(url.parse(this.apipath+this.endpoints.verify),qs.stringify(obj),cb||function(){});
};
AndPush.prototype.sendRequest = function (opts, qstr, cb) {
         var resp = [];
         opts.method = "POST";
         opts.headers = {
             'Content-Type': 'application/x-www-form-urlencoded',
             'Content-Length': qstr.length
         }
         var req = http.request(opts, function(res) {
             res.setEncoding('utf8');
             res.on('data', function (chunk) {
                 resp.push(chunk);
             });
             res.on('end',function () {
                 if (resp.length >= 0) {
                    cb(null,JSON.parse(resp.join('')));
                 };
             });
         });
         req.on('error', function(e) {
             cb(e);
         });
         req.write(qstr);
         req.end();
};
module.exports = AndPush();
