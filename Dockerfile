FROM ubuntu:20.04
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN apt-get update && apt-get install -y git
ENTRYPOINT ["/entrypoint.sh"]