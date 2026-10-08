# Cliente

Scripts para ejecutar la matriz desde el equipo cliente.

Instalar las herramientas necesarias:

```bash
sudo apt update
sudo apt install -y dnsutils ldap-utils curl swaks
```

Copiar `shared/lab.example.env` como un archivo local terminado en `.env`,
completar las credenciales y cargarlo antes de ejecutar:

```bash
set -a
source ../shared/lab.env
set +a
./tests/test-all.sh | tee resultados.txt
```

El archivo `.env` y los resultados generados no se guardan en Git.
