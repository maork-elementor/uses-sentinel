FROM alpine:3.7
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN apk add --no-cache git
ENTRYPOINT ["/entrypoint.sh"]