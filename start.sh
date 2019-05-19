#!/usr/bin/env sh
mkdir -p /run/openrc
touch /run/openrc/softlevel
touch /var/log/mail.log

CONF_DIR="/etc/postfix"
DCONF_DIR=/app/config"
CONF_PARAM="-c ${CONF_DIR}"
if [ ! -d ${CONF_DIR} ]; then
	(>&2 echo "${CONF_DIR} does not exist")
	exit 1
fi
if [ ! -d ${DCONF_DIR} ]; then
	(>&2 echo "${DCONF_DIR} does not exist")
	exit 1
fi
echo "..."
if [ ! -f $DCONF_DIR/relaydomain.map ]; then
 echo "$DCONF_DIR/relaydomain.map file does not exist. Creating sample file."
 echo "example.com OK" > $DCONF_DIR/relaydomain.map
fi

if [ ! -f $DCONF_DIR/sender-whitelist.map ]; then
 echo "$DCONF_DIR/sender-whitelist.map file does not exist. Creating sample file."
 echo "example.com OK" > $DCONF_DIR/sender-whitelist.map
fi

postmap ${CONF_DIR}/relaydomain.map
postmap ${CONF_DIR}/sender-whitelist.map

openrc
sleep 1
  rc-service rsyslog start 2> /dev/null
  rc-service postfix start 2> /dev/null
watch -n 60 'sh ./watch.sh' 1>/dev/null &
tail -f /var/log/mail.log
