#!/usr/bin/env bash
set -Eeuo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Error: ejecute este script con sudo." >&2
  exit 1
fi

DOMAIN=${DOMAIN:-aerolinea.redes.test}
LOCAL_NETWORK=${LOCAL_NETWORK:-}
DNS_IP=${DNS_IP:-}
LDAP_IP=${LDAP_IP:-}
WEB_IP=${WEB_IP:-}
MAIL_IP=${MAIL_IP:-}
FTP_IP=${FTP_IP:-}

for variable in LOCAL_NETWORK DNS_IP LDAP_IP WEB_IP MAIL_IP FTP_IP; do
  if [[ -z ${!variable} ]]; then
    echo "Error: falta definir ${variable}." >&2
    exit 1
  fi
done

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
CONFIG_DIR=${SCRIPT_DIR}/../config
ZONE_SOURCE=${SCRIPT_DIR}/../zones/db.aerolinea.redes.test
SERIAL=${SERIAL:-$(date +%Y%m%d)01}
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y bind9 bind9-utils dnsutils

install -d -o root -g bind -m 0755 /etc/bind/zones
for file in named.conf.options named.conf.local; do
  if [[ -f /etc/bind/${file} ]]; then
    cp -a "/etc/bind/${file}" "/etc/bind/${file}.bak.$(date +%Y%m%d%H%M%S)"
  fi
done

sed -e "s|LOCAL_NETWORK|${LOCAL_NETWORK}|g" \
  "${CONFIG_DIR}/named.conf.options" > /etc/bind/named.conf.options
sed -e "s|DOMAIN|${DOMAIN}|g" \
  "${CONFIG_DIR}/named.conf.local" > /etc/bind/named.conf.local
sed -e "s|aerolinea.redes.test|${DOMAIN}|g" \
    -e "s|SERIAL|${SERIAL}|g" \
    -e "s|DNS_IP|${DNS_IP}|g" \
    -e "s|LDAP_IP|${LDAP_IP}|g" \
    -e "s|WEB_IP|${WEB_IP}|g" \
    -e "s|MAIL_IP|${MAIL_IP}|g" \
    -e "s|FTP_IP|${FTP_IP}|g" \
    "${ZONE_SOURCE}" > "/etc/bind/zones/db.${DOMAIN}"

chown root:bind "/etc/bind/zones/db.${DOMAIN}"
chmod 0644 /etc/bind/named.conf.options /etc/bind/named.conf.local "/etc/bind/zones/db.${DOMAIN}"
named-checkconf
named-checkzone "${DOMAIN}" "/etc/bind/zones/db.${DOMAIN}"
systemctl enable --now named
systemctl restart named
systemctl --no-pager --full status named
