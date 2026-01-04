#!/bin/bash
# ==============================================================================
# AURORA - Script de Empacotamento
# Cria um pacote .tar.gz pronto para distribuição
# ==============================================================================

set -euo pipefail

# Configurações
VERSION="3.0.0"
PACKAGE_NAME="aurora-${VERSION}"
OUTPUT_DIR="dist"

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}>>> Empacotando Aurora v${VERSION}...${NC}"

# Criar diretório de saída
mkdir -p "$OUTPUT_DIR"

# Criar arquivo de versão
cat >VERSION <<EOF
AURORA Theme Manager v${VERSION}
Release Date: $(date +%Y-%m-%d)
EOF

# Criar pacote
echo "📦 Criando pacote tar.gz..."
tar czf "${OUTPUT_DIR}/${PACKAGE_NAME}.tar.gz" \
	--exclude='.git' \
	--exclude='.gitignore' \
	--exclude='dist/' \
	--exclude='*.log' \
	--exclude='.env*' \
	--exclude='node_modules' \
	--exclude='.cursor' \
	--exclude='.idea' \
	--exclude='.vscode' \
	./

# Verificar se o pacote foi criado
if [[ -f "${OUTPUT_DIR}/${PACKAGE_NAME}.tar.gz" ]]; then
	PACKAGE_SIZE=$(du -h "${OUTPUT_DIR}/${PACKAGE_NAME}.tar.gz" | cut -f1)
	echo -e "${GREEN}✓${NC} Pacote criado: ${OUTPUT_DIR}/${PACKAGE_NAME}.tar.gz"
	echo "   Tamanho: ${PACKAGE_SIZE}"
	echo ""
	echo "Para instalar:"
	echo "  1. Descompactar: tar xzf ${PACKAGE_NAME}.tar.gz"
	echo "  2. Entrar no diretório: cd ${PACKAGE_NAME}"
	echo "  3. Executar: sudo bash bin/aurora-install"
else
	echo -e "${RED}✗${NC} Erro ao criar pacote"
	exit 1
fi
