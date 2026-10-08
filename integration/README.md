# Integración local

```bash
cd integration
docker compose up -d --build
docker compose exec client /tests/test-all.sh
```

Servicios publicados en macOS:

- DNS en 5353
- LDAP en 1389
- Web en 8080
- SMTP en 2525
- Submission en 1587
- IMAP en 1143
