# Laboratorio 5: Servicios de capa 7

Repositorio de configuración y evidencias para `aerolinea.redes.test`.

La relación entre los servidores está documentada en
[`docs/diagramas/arquitectura.md`](docs/diagramas/arquitectura.md).
El orden de despliegue y los puertos están en
[`docs/puesta-en-marcha.md`](docs/puesta-en-marcha.md).

## Estructura

```text
.
├── dns/                 # BIND9 y zona DNS
├── ldap/                # OpenLDAP y usuarios LDIF
├── web/                 # Apache y autenticación LDAP
├── mail/                # Postfix y Dovecot
├── ftp/                 # Implementación de vsftpd
├── client/              # Pruebas ejecutadas desde el cliente
├── docs/                # Reporte, diagramas, tablas y evidencias
└── shared/              # Valores compartidos y plantillas
```

## Web

La implementación de Apache con login LDAP está en [`web/README.md`](web/README.md).
El sitio se compila con `npm run build` en `web/site` y luego se despliega en la
VM web:

```bash
cd web
sudo ./scripts/install.sh
sudo ./scripts/verify-local.sh
```

Desde el cliente:

```bash
WEB_USER='usuario' WEB_PASSWORD='clave-ldap' ./client/tests/test-web.sh
```

## DNS, LDAP y correo

Cada servicio incluye configuración, instalador, verificación local y prueba
desde el cliente:

- [`dns/README.md`](dns/README.md)
- [`ldap/README.md`](ldap/README.md)
- [`mail/README.md`](mail/README.md)

Para probar todo junto se usa `client/tests/test-all.sh` con las variables de
`shared/lab.example.env`.

## FTP

La implementación lista para desplegar está en [`ftp/README.md`](ftp/README.md).
Debe ejecutarse en la VM Ubuntu destinada exclusivamente a FTP. No modifica
Netplan, DNS ni UFW automáticamente.

```bash
cd ftp
sudo FTP_PASSWORD='Lab5-ftp' ./scripts/install.sh
sudo ./scripts/verify-local.sh
```

Desde el cliente, cuya resolución DNS debe apuntar a `ns1`:

```bash
FTP_PASSWORD='Lab5-ftp' ./client/tests/test-ftp.sh
```
