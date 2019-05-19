FROM alpine
RUN apk update && \
    apk add --no-cache postfix postfix-pcre postfix-mysql rsyslog openrc
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
