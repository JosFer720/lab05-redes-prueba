#!/usr/bin/env bash
set -Eeuo pipefail

DOMAIN=${DOMAIN:-aerolinea.redes.test}
DNS_SERVER=${DNS_SERVER:-127.0.0.1}
failed=0

check() {
  local description=$1
  shift
  if "$@"; then printf '[PASS] %s\n' "${description}"; else printf '[FAIL] %s\n' "${description}" >&2; failed=1; fi
}

check 'configuración válida' named-checkconf
check 'zona válida' named-checkzone "${DOMAIN}" "/etc/bind/zones/db.${DOMAIN}"
check 'servicio activo' systemctl is-active --quiet named
check 'servicio habilitado' systemctl is-enabled --quiet named
check 'puerto 53 TCP escuchando' bash -c "ss -lnt | grep -Eq '[:.]53[[:space:]]'"
check 'puerto 53 UDP escuchando' bash -c "ss -lnu | grep -Eq '[:.]53[[:space:]]'"
check 'respuesta autoritativa' bash -c "dig +norecurse @'${DNS_SERVER}' '${DOMAIN}' SOA | grep -q 'flags:.* aa'"
check 'registro MX presente' bash -c "dig +short @'${DNS_SERVER}' '${DOMAIN}' MX | grep -q 'mail.${DOMAIN}'"

exit "${failed}"
