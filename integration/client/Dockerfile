FROM ftp-ftp:latest
ENTRYPOINT []
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends dnsutils ldap-utils curl swaks ca-certificates && rm -rf /var/lib/apt/lists/*
COPY client/tests/ /tests/
RUN chmod 0755 /tests/*.sh
