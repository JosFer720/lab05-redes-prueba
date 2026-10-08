# DNS

Servidor autoritativo BIND9 para `aerolinea.redes.test`.

## Instalación

Ejecutar en la VM DNS con las direcciones reales:

```bash
sudo LOCAL_NETWORK='192.168.50.0/24' \
  DNS_IP='192.168.50.10' \
  LDAP_IP='192.168.50.11' \
  WEB_IP='192.168.50.12' \
  MAIL_IP='192.168.50.13' \
  FTP_IP='192.168.50.14' \
  ./scripts/install.sh

sudo ./scripts/verify-local.sh
```

El script respalda la configuración existente, valida BIND9 y habilita el
servicio al arranque. No cambia Netplan ni UFW.

Desde el cliente:

```bash
DNS_SERVER='192.168.50.10' ../client/tests/test-dns.sh
```
