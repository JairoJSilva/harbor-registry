1️⃣ Baixar o Harbor
mkdir -p /opt/harbor
cd /opt/harbor


Baixe a versão mais recente (exemplo):

wget https://github.com/goharbor/harbor/releases/download/v2.9.4/harbor-offline-installer-v2.9.4.tgz


Extraia:

tar -xvf harbor-offline-installer-v2.9.4.tgz
cd harbor

2️⃣ Configurar o arquivo harbor.yml

Copie o template:

cp harbor.yml.tmpl harbor.yml


Edite:

vim harbor.yml

Configuração mínima (HTTP – LAB)
hostname: harbor.local

http:
  port: 80

harbor_admin_password: Harbor12345

database:
  password: root123
  max_idle_conns: 50
  max_open_conns: 100

data_volume: /data/harbor

trivy:
  enabled: true


💡 Se não tiver DNS, adicione no /etc/hosts:

IP_DO_SERVIDOR harbor.local

3️⃣ Instalar e gerar o Docker Compose

Rode o script de instalação:

./install.sh


Se tudo estiver certo, você verá algo como:

✔ ----Harbor has been installed and started successfully.----


📁 Isso vai gerar:

docker-compose.yml

.env

Certificados (se HTTPS)

4️⃣ Subir / Gerenciar o Harbor

O Harbor já sobe automaticamente, mas depois você pode controlar com:

docker compose ps
docker compose down
docker compose up -d

5️⃣ Acessar o Harbor

🌐 No navegador:

http://harbor.local


🔐 Login:

Usuário: admin

Senha: Harbor12345

6️⃣ Teste com Docker CLI
Login no registry
docker login harbor.local

Subir uma imagem
docker tag nginx:latest harbor.local/library/nginx:1.0
docker push harbor.local/library/nginx:1.0

7️⃣ Estrutura de dados no host
/data/harbor
├── database
├── registry
├── job_logs
├── redis


⚠️ Faça backup disso em produção.

Quer ir além?

Posso te ajudar a:

🔐 Configurar HTTPS com certificado próprio

👥 Integrar com LDAP / AD

🔁 Criar replicação entre registries

🔍 Ajustar scan de vulnerabilidades (Trivy)

☸️ Usar Harbor como registry de um cluster Kubernetes

🧪 Versão 100% lab ou produção

Me conta:
👉 LAB ou PRODUÇÃO?
👉 Vai rodar local, VM ou cloud (AWS/GCP/Azure)?

Aí eu deixo isso redondinho no padrão DevOps/SRE 🔥
