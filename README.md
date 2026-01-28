⚓ Harbor Registry SetupEste repositório contém o guia passo a passo e as configurações necessárias para provisionar o Harbor, um registro de artefatos open-source que armazena, assina e varre conteúdos em busca de vulnerabilidades.[!IMPORTANT]Esta configuração inicial foi projetada para ambientes de Laboratório (HTTP). Para ambientes de produção, recomenda-se fortemente o uso de HTTPS/TLS.🚀 Guia de Instalação1. Preparação do AmbienteCrie o diretório de trabalho e realize o download do instalador offline (versão v2.9.4):Bashmkdir -p /opt/harbor
cd /opt/harbor

# Download do instalador
wget https://github.com/goharbor/harbor/releases/download/v2.9.4/harbor-offline-installer-v2.9.4.tgz

# Extração dos arquivos
tar -xvf harbor-offline-installer-v2.9.4.tgz
cd harbor
2. Configuração do harbor.ymlO arquivo de configuração define o comportamento do registro. Copie o template e edite os campos principais:Bashcp harbor.yml.tmpl harbor.yml
vim harbor.yml
Configuração Mínima Recomendada:hostname: harbor.localhttp.port: 80harbor_admin_password: Harbor12345trivy.enabled: true (Para scan de vulnerabilidades)[!TIP]Caso não possua DNS configurado, adicione o mapeamento no seu arquivo hosts local:echo "IP_DO_SERVIDOR harbor.local" >> /etc/hosts3. Executando o InstaladorInicie o script de instalação automatizada:Bash./install.sh
Após o término, o Harbor estará rodando via Docker Compose. Você verá a mensagem:✔ ----Harbor has been installed and started successfully.----🛠 Gerenciamento do ServiçoO gerenciamento do ciclo de vida da aplicação é feito via Docker Compose dentro do diretório /opt/harbor/harbor:AçãoComandoVerificar statusdocker compose psParar o Harbordocker compose downIniciar o Harbordocker compose up -d🌐 Acesso e Teste de ConexãoAcesso via Web UIURL: http://harbor.localUsuário: adminSenha: Harbor12345Teste via Docker CLIPara enviar imagens para o seu novo registro, siga o fluxo abaixo:Bash# 1. Login no Registry
docker login harbor.local

# 2. Taggear uma imagem existente
docker tag nginx:latest harbor.local/library/nginx:1.0

# 3. Enviar para o Harbor
docker push harbor.local/library/nginx:1.0
📂 Estrutura de Persistência no HostOs dados do Harbor são persistidos em /data/harbor. É essencial incluir este diretório em sua rotina de backup:Plaintext/data/harbor
├── database   # Dados do PostgreSQL
├── registry   # Imagens Docker e Artefatos
├── job_logs   # Logs de replicação e scans
└── redis      # Dados de cache
🔧 Próximos Passos (Hardening & Escalonamento)Para evoluir este setup para um nível corporativo, considere:[ ] Implementação de HTTPS com certificados válidos.[ ] Integração com LDAP/Active Directory.[ ] Configuração de Replicação entre instâncias para HA.[ ] Integração como Registry padrão em clusters Kubernetes.Mantenedor: [Seu Nome/GitHub]Status: 🟢 Funcional (LAB)
