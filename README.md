# 📦 `pydio-arm64-image`
Automatically build ARM64 container image for Pydio Cells server.

## Quick preview
Simply,
```
docker run -itp 8080:8080 ghcr.io/pmh-only/pydio
```

## docker-compose
```yml
version: '3'

services:
  mindustry:
    image: ghcr.io/pmh-only/pydio
    restart: always
    tty: true
    stdin_open: true
    ports:
      - '8080:8080'
```
