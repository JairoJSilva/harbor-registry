#!/bin/bash

# ==============================
# Validação da mensagem
# ==============================
if [ -z "$1" ]; then
  echo "❌ Erro: informe a mensagem do commit."
  echo "👉 Uso correto:"
  echo "   ./git-push-tag.sh \"sua mensagem de commit\""
  exit 1
fi

COMMIT_MSG="$1"
BRANCH=$(git branch --show-current)
TAG=$(date +"%y%m%d_%H%M%S")

# ==============================
# Validação do repositório
# ==============================
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "❌ Este diretório não é um repositório Git."
  exit 1
fi

if [ -z "$(git status --porcelain)" ]; then
  echo "⚠️ Nenhuma alteração para commit."
  exit 0
fi

# ==============================
# Commit
# ==============================
echo "📦 Adicionando arquivos..."
git add .

echo "📝 Criando commit..."
git commit -m "$COMMIT_MSG"

# ==============================
# Push do commit
# ==============================
echo "⬆️ Enviando commit para o Bitbucket (branch: ${BRANCH})..."
git push origin "${BRANCH}"

# ==============================
# Pergunta sobre TAG
# ==============================
echo
read -p "🏷️ Deseja criar uma tag para este commit? (s/n): " RESP

case "$RESP" in
  s|S|sim|SIM|y|Y|yes|YES)
    echo "🏷️ Criando tag: ${TAG}"
    git tag "${TAG}"

    echo "⬆️ Enviando tag para o Bitbucket..."
    git push origin "${TAG}"

    echo "🔖 Tag criada: ${TAG}"
    ;;
  *)
    echo "➡️ Tag não criada."
    ;;
esac

# ==============================
# Finalização
# ==============================
echo "✅ Processo finalizado com sucesso!"
