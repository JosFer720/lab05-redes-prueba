#!/usr/bin/env bash
set -Eeuo pipefail

DOMAIN=${DOMAIN:-aerolinea.redes.test}
BASE_DN=${BASE_DN:-dc=aerolinea,dc=redes,dc=test}
LDAP_HOST=${LDAP_HOST:-ldap.${DOMAIN}}
LDAP_USER=${LDAP_USER:-}
LDAP_PASSWORD=${LDAP_PASSWORD:-}
failed=0

if [[ -z ${LDAP_USER} || -z ${LDAP_PASSWORD} ]]; then
  echo "Error: defina LDAP_USER y LDAP_PASSWORD." >&2
  exit 1
fi

check() {
  local id=$1 description=$2
  shift 2
  if "$@"; then printf '[PASS] %s %s\n' "${id}" "${description}"; else printf '[FAIL] %s %s\n' "${id}" "${description}" >&2; failed=1; fi
}
reject() {
  local id=$1 description=$2
  shift 2
  if "$@" >/dev/null 2>&1; then printf '[FAIL] %s %s\n' "${id}" "${description}" >&2; failed=1; else printf '[PASS] %s %s\n' "${id}" "${description}"; fi
}

USER_DN="uid=${LDAP_USER},ou=People,${BASE_DN}"
check LDAP-01 'consulta de usuarios' bash -c "ldapsearch -x -LLL -H 'ldap://${LDAP_HOST}' -b 'ou=People,${BASE_DN}' -s one uid | grep -q '^uid:'"
check LDAP-02 'autenticación válida' ldapwhoami -x -H "ldap://${LDAP_HOST}" -D "${USER_DN}" -w "${LDAP_PASSWORD}"
reject LDAP-03 'autenticación inválida' ldapwhoami -x -H "ldap://${LDAP_HOST}" -D "${USER_DN}" -w incorrecta
check LDAP-04 'atributos requeridos' bash -c "ldapsearch -x -LLL -H 'ldap://${LDAP_HOST}' -b '${USER_DN}' -s base uid cn sn mail | grep -Eq '^(uid|cn|sn|mail):'"
exit "${failed}"
