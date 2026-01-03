#!/bin/bash
# ==============================================================================
# AURORA - Script de Inicialização Modular
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YEL='\033[0;33m'
NC='\033[0m'

echo -e "${BLUE}>>> Inicializando Projeto Aurora (Estrutura Modular)...${NC}"

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

# 2. Criar estrutura de diretórios
dirs=("src/modules" "themes" "docs" "config" "taskmaster_docs")
for d in "${dirs[@]}"; do
	mkdir -p "$d"
	echo -e "    ${GREEN}✓${NC} Diretório '$d' verificado."
done

# 3. Criar arquivo de configuração padrão se não existir
if [ ! -f "config/default.yml" ]; then
	cat >config/default.yml <<EOF
theme_dir: "./themes"
config_dir: "~/.config/aurora"
default_shell: "auto"
persistence_enabled: true
backup_enabled: true
check_contrast: true
EOF
	echo -e "    ${GREEN}✓${NC} Arquivo config/default.yml criado."
fi

# 4. Criar o ponto de entrada principal do aurora (binário local)
cat >aurora <<'EOF'
#!/bin/bash
# Aurora CLI Entry Point
AURORA_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export AURORA_ROOT

# Carregar módulos
for module in "$AURORA_ROOT"/src/modules/*.sh; do
    [ -r "$module" ] && source "$module"
done

# TODO: Implementar lógica de roteamento de comandos aqui
case "${1:-help}" in
    list)
        echo "Temas disponíveis:"
        ls "$AURORA_ROOT/themes"/*.yml | xargs -n1 basename | sed 's/\.yml//'
        ;;
    *)
        echo "Uso: ./aurora {list|apply|preview}"
        ;;
esac
EOF

chmod +x aurora
echo -e "    ${GREEN}✓${NC} Executável './aurora' criado."

echo -e "\n${GREEN}>>> Inicialização concluída!${NC}"
echo -e "Você já pode executar ${BLUE}./aurora list${NC} para ver os temas em YAML."
