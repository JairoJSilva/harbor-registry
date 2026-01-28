#!/bin/sh

# ==============================
# Configurações do Harbor
# ==============================
HARBOR_URL="harbor.local"
PROJECT="cartaovem"

# ==============================
# Entrada do usuário
# ==============================
printf "Nome da aplicação (repository no Harbor): "
read APP_NAME

printf "Imagem de origem (ex: thanatos:260116_163320): "
read SOURCE_IMAGE

# ==============================
# Validações
# ==============================
if [ -z "$APP_NAME" ] || [ -z "$SOURCE_IMAGE" ]; then
  echo "❌ Nome da aplicação e imagem de origem são obrigatórios."
  exit 1
fi

# Verifica se a imagem contém tag
case "$SOURCE_IMAGE" in
  *:*) ;;
  *)
    echo "❌ A imagem de origem deve conter uma tag (ex: thanatos:260116_163320)"
    exit 1
    ;;
esac

# Extrai a tag (parte depois do :)
IMAGE_TAG=$(echo "$SOURCE_IMAGE" | awk -F: '{print $NF}')

TARGET_IMAGE="${HARBOR_URL}/${PROJECT}/${APP_NAME}:${IMAGE_TAG}"

# ==============================
# Execução
# ==============================
echo ""
echo "🏷 Reutilizando a tag existente: $IMAGE_TAG"
echo ""

echo "🔖 Criando tag no Harbor:"
echo "docker tag $SOURCE_IMAGE $TARGET_IMAGE"

docker tag "$SOURCE_IMAGE" "$TARGET_IMAGE" || {
  echo "❌ Erro ao criar tag"
  exit 1
}

echo ""
echo "📤 Enviando imagem para o Harbor:"
echo "docker push $TARGET_IMAGE"

docker push "$TARGET_IMAGE" || {
  echo "❌ Erro ao enviar imagem para o Harbor"
  exit 1
}

echo ""
echo "✅ Imagem enviada com sucesso!"
echo "📦 $TARGET_IMAGE"

