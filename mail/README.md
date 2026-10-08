# Correo

Postfix y Dovecot con buzones Maildir y autenticación LDAP.

La implementación habilita SMTP en los puertos 25 y 587, IMAP en el puerto
143 y entrega local mediante LMTP. Las cuentas se validan contra OpenLDAP.

## Instalación

Ejecutar en la VM de correo cuando DNS y LDAP ya respondan:

```bash
sudo ./scripts/install.sh
sudo MAIL_TEST_USER='usuario1' \
  MAIL_TEST_PASSWORD='clave-del-usuario' \
  ./scripts/verify-local.sh
```

Desde el cliente se necesitan `dig`, `curl` y `swaks`:

```bash
MAIL_USER='usuario1' \
MAIL_PASSWORD='clave-del-usuario' \
MAIL_RECIPIENT='usuario2@aerolinea.redes.test' \
MAIL_RECIPIENT_USER='usuario2' \
MAIL_RECIPIENT_PASSWORD='clave-del-destinatario' \
  ../client/tests/test-mail.sh
```

Configuración del cliente de correo:

- IMAP en `mail.aerolinea.redes.test`, puerto 143, sin cifrado
- SMTP en `mail.aerolinea.redes.test`, puerto 587, sin cifrado
- autenticación con contraseña normal
- nombre de usuario igual al `uid` LDAP

Esta configuración sin TLS solo debe usarse en la red aislada del laboratorio.
