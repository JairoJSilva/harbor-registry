## Pré-requisitos

No host:

```bash
docker --version
docker compose version

```

Recomendado:

- Docker >= 20.x
- Docker Compose v2
- Pelo menos **4GB de RAM**
- Porta **80 e/ou 443 livres**

---

## 1️⃣ Baixar o Harbor

```bash
mkdir -p /opt/harbor
cd /opt/harbor

```

Baixe a versão mais recente (exemplo):

```bash
wget https://github.com/goharbor/harbor/releases/download/v2.9.4/harbor-offline-installer-v2.9.4.tgz

```

Extraia:

```bash
tar -xvf harbor-offline-installer-v2.9.4.tgz
cd harbor

```

---

## 2️⃣ Configurar o arquivo `harbor.yml`

Copie o template:

```bash
cp harbor.yml.tmpl harbor.yml

```

Edite:

```bash
vim harbor.yml

```

### Configuração mínima (HTTP – LAB)

```yaml
hostname: harbor.local

http:
  port: 80

harbor_admin_password: Harbor12345

data_volume: /data/harbor
```

💡 Se não tiver DNS, adicione no `/etc/hosts`:

```
IP_DO_SERVIDOR harbor.local

```

---

## 3️⃣ Instalar e gerar o Docker Compose

Rode o script de instalação:

```bash
./install.sh

```

Se tudo estiver certo, você verá algo como:

```
✔----Harbor has been installed and started successfully.----

```

📁 Isso vai gerar:

- `docker-compose.yml`
- `.env`
- Certificados (se HTTPS)

---

## 4️⃣ Subir / Gerenciar o Harbor

O Harbor já sobe automaticamente, mas depois você pode controlar com:

```bash
docker compose ps
docker compose down
docker compose up -d

```

---

## 5️⃣ Acessar o Harbor

🌐 No navegador:

```
http://harbor.local

```

🔐 Login:

- **Usuário:** `admin`
- **Senha:** `Harbor12345`

---

## 6️⃣ Teste com Docker CLI

### Login no registry

```bash
docker login harbor.local

```

### Subir uma imagem

```bash
docker tag nginx:latest harbor.local/library/nginx:1.0
docker push harbor.local/library/nginx:1.0

```

---

## 7️⃣ Estrutura de dados no host

```bash
/data/harbor
├── database
├── registry
├── job_logs
├── redis

```



## 💥 Se ocorrer o erro:

```
Error: The protocolis https but attribute ssl_certisnotset
Error happenedin config validation...

```

## ✅ SOLUÇÃO (LAB / HTTP)

Se você quer rodar **em HTTP** (lab/local), precisa **desabilitar completamente o HTTPS** no `harbor.yml`.

### 1️⃣ Edite o `harbor.yml`

```bash
vim harbor.yml
```

**2️⃣ Procure este bloco (HTTPS)**

```yaml
https:
  port: 443
  certificate: /your/certificate/path
  private_key: /your/private/key/path
```

**3️⃣ COMENTE ou REMOVA esse bloco inteiro**

```yaml
# https:
#   port: 443
#   certificate: /your/certificate/path
#   private_key: /your/private/key/path
```

4️⃣ Salve e rode novamente

```yaml
docker compose down 
./install.sh
```

⚠️ Faça backup disso em produção.

---







## Realizar instalação em outros ambientes.

**✅ O que PODE ser reaproveitado sem problema**

**Copiar** para outro servidor:

**1️⃣ Diretório do Harbor (config + compose).**

```bash
/opt/harbor/harbor
```

### Contem:

- `docker-compose.yml`
- `.env`
- `harbor.yml`
- `install.sh`

**✔️ Reutilizável, desde que:**

- hostname seja válido no novo local
- portas não estejam ocupadas

**2️⃣ Diretório de dados (SE quiser preservar imagens)**

```bash
/data/harbor
```

### Contém:

- registry (imagens)
- banco
- redis
- jobs
- logs

✔️ **Essencial se quiser manter repositórios, usuários e configs**

## ❌ O que NÃO deve simplesmente copiar (ou precisa cuidado)

### 🚫 Certificados HTTPS

Se tiver HTTPS:

- certificados costumam ter **paths absolutos**
- hostname diferente quebra o cert

👉 Melhor **regerar**.

---

### 🚫 IP fixo / DNS diferente

Se mudar:

- `hostname:` precisa bater com DNS
- senão o login e push falham

---

## 🔥 FORMAS CORRETAS DE MIGRAR

### 🟢 Cenário 1 — LAB / DEV (rápido)

> “Quero subir igual em outro host, não me importo com dados”
> 
1. Copia só:

```bash
/opt/harbor/harbor
```

1. Ajusta:

```yaml
hostname:
http.port:
```

1. Roda:

```bash
./install.sh
```

❇️ Documentação criada com auxilio do Google Gemini
