
;API Keys, comma delimited
alias -l _API_KEY return KEY HERE

;Channel ignore list, space delimited
alias -l _CH_IGNORE return

;Nick ignore list, space delimited
alias -l _NICK_IGNORE return

;Channel highlight template (title and message)
alias -l _CH_TITLE return Highlight on $network
alias -l _CH_TEMPLATE return $nick just said your name in $chan $+ :

;PM template (title and message)
alias -l _PM_TITLE return PM on $network
alias -l _PM_TEMPLATE return $nick just PM'd you:

;Idle time before sending pushes (in seconds)
;Set to $false to disable
alias -l _IDLE_TIME return 600

;Send pushes while away
alias -l _AWAY_PUSH return $true

;Flood control. Minimum time between pushes (in seconds).
;Strongly recommend not setting this below 30 seconds.
alias -l _FLOOD_TIME return 10

; DO NOT MODIFY ANYTHING BELOW THIS POINT
; UNLESS YOU KNOW WHAT YOU ARE DOING!

; Encodes URLs
alias -l urlEncode {
  return $regsubex($replace($1,[,&lsqb;,],&rsqb;), /(\W)/g, $+(%, $base($asc(\t), 10, 16, 2)))
}
alias -l flood_control {
  if ($calc($ctime - $hget(andpush,flood_time)) > $_FLOOD_TIME) {
    hadd -m andpush flood_time $ctime
    return $true
  }
  halt
}
alias -l sslCheck {
  if (!$sslready) {
    .timer 1 0 noop $input(AndPush requires SSL. $crlf $+ Please update mIRC to v7.36 or later or $crlf $+ install the OpenSSL binaries. $crlf $+ This script will now unload.,ho,AndPush)
    .unload -rs $script
  }
}
on *:LOAD:{
  sslCheck
}
on *:TEXT:$($iif($highlight($1-),$1-)):#:{
  if ($istok($_CH_IGNORE,$chan,32)) return
  if ($istok($_NICK_IGNORE,$nick,32)) return
  var %push = $false
  if ($_AWAY_PUSH && $away) { goto continue }
  if ($idle >= $_IDLE_TIME && $_IDLE_TIME != $false) { goto continue }
  return
  :continue
  flood_control

  hadd -m andpush title $_CH_TITLE
  hadd -m andpush message $_CH_TEMPLATE $1-

  sslCheck

  sockopen -e andpush. $+ $ticks api.andpush.net 443
}

on *:TEXT:*:?:{
  if ($istok($_NICK_IGNORE,$nick,32)) return
  var %push = $false
  if ($_AWAY_PUSH && $away) { goto continue }
  if ($idle >= $_IDLE_TIME && $_IDLE_TIME != $false) { goto continue }
  return
  :continue
  flood_control

  hadd -m andpush title $_PM_TITLE
  hadd -m andpush message $_PM_TEMPLATE $1-

  sockopen andpush. $+ $ticks api.andpush.net 80
}
on *:SOCKOPEN:andpush.*:{
  if ($sockerr) return
  var %content = apikey= $+ $_API_KEY $+ $&
    &title= $+ $urlEncode($hget(andpush,title)) $+ $&
    &message= $+ $urlEncode($hget(andpush,message))
  var %w sockwrite -n $sockname
  %w POST /send HTTP/1.1
  %w User-Agent: mIRC-andpush/0.1
  %w Content-Type: application/x-www-form-urlencoded
  %w Content-Length: $len(%content)
  %w Host: api.andpush.net
  %w $crlf $+ %content
  %w $crlf
}
on *:SOCKCLOSE:andpush.*:{
  hdel andpush title
  hdel andpush message
}
