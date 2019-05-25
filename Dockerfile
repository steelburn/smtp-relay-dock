FROM alpine
RUN apk update && \
    apk add --no-cache postfix postfix-pcre postfix-mysql inetutils-syslogd openrc
RUN rc-update del syslog boot; rc-update add inetutils-syslogd boot
RUN sed -i -e 's/need clock hostname/need clock/g' /etc/init.d/inetutils-syslogd

COPY postfix/* /etc/postfix/
COPY start.sh .
COPY watch.sh .
RUN chmod +x start.sh && \
    mkdir -p /app/config && \
    mv /etc/postfix/relaydomain.map /app/config && \
    mv /etc/postfix/sender-whitelist.map /app/config && \
    ln -sf /app/config/relaydomain.map /etc/postfix/relaydomain.map && \
    ln -sf /app/config/sender-whitelist.map /etc/postfix/sender-whitelist.map 


VOLUME /app/config
EXPOSE 25
ENTRYPOINT ["sh","./start.sh"]
