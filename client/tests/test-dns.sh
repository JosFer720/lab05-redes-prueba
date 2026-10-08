#!/usr/bin/env bash
set -Eeuo pipefail

DOMAIN=${DOMAIN:-aerolinea.redes.test}
DNS_SERVER=${DNS_SERVER:-ns1.${DOMAIN}}
failed=0

check() {
  local id=$1 description=$2
  shift 2
  if "$@"; then printf '[PASS] %s %s\n' "${id}" "${description}"; else printf '[FAIL] %s %s\n' "${id}" "${description}" >&2; failed=1; fi
}

check DNS-01 'servidor DNS' bash -c "[[ -n \$(dig +short @'${DNS_SERVER}' ns1.'${DOMAIN}' A) ]]"
for host in ldap www mail ftp; do
  check DNS-02 "registro de ${host}" bash -c "[[ -n \$(dig +short @'${DNS_SERVER}' '${host}.${DOMAIN}' A) ]]"
done
check DNS-03 'respuesta autoritativa' bash -c "dig +norecurse @'${DNS_SERVER}' '${DOMAIN}' SOA | grep -q 'flags:.* aa'"
check DNS-04 'registro MX' bash -c "dig +short @'${DNS_SERVER}' '${DOMAIN}' MX | grep -q 'mail.${DOMAIN}'"
check DNS-05 'nombre inexistente' bash -c "dig @'${DNS_SERVER}' noexiste.'${DOMAIN}' A | grep -q 'status: NXDOMAIN'"
exit "${failed}"
