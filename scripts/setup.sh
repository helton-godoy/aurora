#!/bin/bash
# ==============================================================================
# AURORA - Script de Inicialização (Desenvolvimento)
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YEL='\033[0;33m'
NC='\033[0m'

echo -e "${BLUE}>>> Inicializando Projeto Aurora (Desenvolvimento)...${NC}"

# 1. Verificar dependências
check_dep() {
	if ! command -v "$1" &>/dev/null; then
		echo -e "${YEL}[AVISO]${NC} '$1' não encontrado. Por favor, instale para funcionalidade completa."
	else
		echo -e "${GREEN}[OK]${NC} '$1' detectado."
	fi
}

check_dep "gum"
check_dep "yq"
check_dep "starship"

# 2. Criar estrutura de diretórios (se necessário)
dirs=("src/modules" "themes" "docs")
for d in "${dirs[@]}"; do
	mkdir -p "$d"
	echo -e "    ${GREEN}✓${NC} Diretório '$d' verificado."
done

# 3. Criar wrapper local para desenvolvimento
cat >aurora <<'EOF'
#!/bin/bash
# Aurora CLI Entry Point (Development Wrapper)
AURORA_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export AURORA_ROOT
exec bash "$AURORA_ROOT/src/aurora.sh" "$@"
EOF

chmod +x aurora
echo -e "    ${GREEN}✓${NC} Executável './aurora' criado (wrapper de desenvolvimento)."

echo -e "\n${GREEN}>>> Inicialização concluída!${NC}"
echo -e "Você já pode executar ${BLUE}./aurora list${NC} para ver os temas disponíveis."
echo -e "Para instalação no sistema, execute ${BLUE}sudo bash bin/aurora-install${NC}"
