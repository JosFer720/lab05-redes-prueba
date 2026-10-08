# LDAP

OpenLDAP con usuarios `inetOrgPerson` bajo `ou=People`.

Copiar `ldif/users.example.tsv` fuera del repositorio, completar una fila por
cuenta y ejecutar en la VM LDAP:

```bash
sudo LDAP_ADMIN_PASSWORD='clave-administrativa' \
  USERS_FILE='/ruta/users.tsv' \
  ./scripts/install.sh

sudo LDAP_TEST_USER='usuario1' \
  LDAP_TEST_PASSWORD='clave-del-usuario' \
  ./scripts/verify-local.sh
```

El archivo usa cinco columnas separadas por tabuladores:

```text
uid    cn    sn    mail    password
```

Si la VM ya tenía una base LDAP de otro dominio, respaldarla y ejecutar una
vez con `RECONFIGURE_LDAP=1`. Sin esa variable el instalador conserva la base
existente.

Desde el cliente:

```bash
LDAP_USER='usuario1' LDAP_PASSWORD='clave-del-usuario' \
  ../client/tests/test-ldap.sh
```
