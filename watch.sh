#!/bin/sh
 
CONF_DIR=/etc/postfix
RELAY=$CONF_DIR/relaydomain.map
SENDER=$CONF_DIR/sender-whitelist.map
RELOAD=n
FRELAY=/tmp/relay.md5
FSENDER=/tmp/sender.md5

MD5_relaydomain=$( md5sum $RELAY )
MD5_sender=$( md5sum $SENDER )
if [ -f $FRELAY ]; then 
 MD5_relaydomain1=$( cat $FRELAY )
fi
if [ -f $FSENDER ]; then
 MD5_sender1=$( cat $FSENDER )
fi

if [[ -z "$MD5_relaydomain1" ]] && [[ "$MD5_relaydomain1" != "$MD5_relaydomain" ]]; then
 postmap $RELAY
 export MD5_relaydomain1=$MD5_relaydomain
 RELOAD=y
fi

if [[ -z "$MD5_sender1" ]] && [[ "$MD5_sender1" != "$MD5_sender" ]]; then 
 postmap $SENDER
 export MD5_sender1=$MD5_sender
 RELOAD=y
fi

if [[ "$RELOAD" == "y" ]]; then
 service postfix reload 2> /dev/null 1>/dev/null
 echo MD5_relaydomain > $FRELAY
 echo MD5_sender > $FSENDER
 RELOAD=n
fi
