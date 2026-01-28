📋 Pré-requisitosDocker instalado e rodando.Docker Compose instalado.Acesso root ou sudo.
🚀 Passo a Passo de Instalação1.
Preparar o diretório e baixar o HarborCrie a pasta de instalação e faça o download da versão offline estável (v2.9.4).Bash# Criar diretório
mkdir -p /opt/harbor
cd /opt/harbor

# Download do instalador offline
wget https://github.com/goharbor/harbor/releases/download/v2.9.4/harbor-offline-installer-v2.9.4.tgz

# Extrair arquivos
tar -xvf harbor-offline-installer-v2.9.4.tgz
cd harbor
2. Configuração do harbor.ymlCopie o template de configuração e edite os parâmetros básicos.Bashcp harbor.yml.tmpl harbor.yml
vim harbor.yml
Configurações essenciais para Lab (HTTP):YAMLhostname: harbor.local

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
[!NOTE]Se não possuir um servidor DNS, aponte o IP do servidor no seu arquivo /etc/hosts:127.0.0.1  harbor.local3. Executar o Script de InstalaçãoO script irá validar o ambiente e gerar o arquivo docker-compose.yml.Bash./install.sh
⚙️ Gerenciamento do ServiçoO Harbor utiliza Docker Compose para orquestrar seus componentes. Use os comandos abaixo dentro de /opt/harbor/harbor:ComandoDescriçãodocker compose psVerifica o status dos containers.docker compose downDesliga todos os serviços do Harbor.docker compose up -dSobe o Harbor em background.🔐 Acesso e Primeiros PassosInterface WebURL: http://harbor.localUsuário: adminSenha: Harbor12345Teste de Push (Docker CLI)Para enviar imagens para o Harbor via terminal:Bash# Efetuar o login
docker login harbor.local

# Taggear uma imagem local
docker tag nginx:latest harbor.local/library/nginx:1.0

# Subir a imagem para o registry
docker push harbor.local/library/nginx:1.0
📂 Persistência de DadosOs dados do Harbor ficam armazenados no host em:/data/harbor/database: Banco de dados PostgreSQL./registry: Camadas das imagens Docker./job_logs: Logs de execução do sistema.⚠️ Dica de SRE: Em ambientes produtivos, este diretório deve ser incluído na sua política de backup.🛡️ Próximos Passos recomendados:[ ] Configuração de HTTPS com Let's Encrypt ou CA interna.[ ] Integração com LDAP/AD para gestão de usuários.[ ] Configuração de políticas de retenção de imagens.
