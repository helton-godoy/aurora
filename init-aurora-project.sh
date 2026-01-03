#!/bin/bash
# ==============================================================================
# SCRIPT DE INICIALIZAÇÃO DA ARQUITETURA "AURORA" (GANACHE EDITION)
# ==============================================================================
# Este script cria a estrutura de diretórios, os arquivos de tema e o
# esqueleto do executável principal em /usr/local/bin.
# ==============================================================================

set -e

# Cores para feedback
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}>>> Iniciando o scaffolding do projeto Aurora...${NC}"

# 1. Verificar Permissões
if [ "$EUID" -ne 0 ]; then
	echo "Por favor, execute como root para criar arquivos em /etc e /usr/local/bin."
	exit 1
fi

# 2. Definir Diretórios
AURORA_BIN="/usr/local/bin/aurora"
CONFIG_DIR="/etc/aurora"
THEMES_DIR="$CONFIG_DIR/themes"
KMSCON_DIR="/etc/kmscon"

# 3. Criar Estrutura de Pastas
echo -e "${BLUE}>>> Criando diretórios...${NC}"
mkdir -p "$THEMES_DIR"
mkdir -p "$KMSCON_DIR"
echo "    [OK] $THEMES_DIR criado."
echo "    [OK] $KMSCON_DIR verificado."

# 4. Criar Arquivos de Tema (Coleção Ganache)
echo -e "${BLUE}>>> Gerando temas da coleção Ganache...${NC}"

# --- TEMA 1: GANACHE NOIR (Dark) ---
cat <<EOF >"$THEMES_DIR/ganache_noir.theme"
# TEMA: Ganache Noir (Chocolate Amargo)
# Descrição: Alto contraste escuro, ideal para pouca luz.

THEME_NAME="Ganache Noir"
BG_COLOR="#0b0704"    # Deep Dark Cocoa
FG_COLOR="#beada2"    # Roasted Almond
ACCENT="#6a4928"      # Caramel (Usado para prompt/cursor)
WARN="#ae998b"        # Aviso

# Paleta ANSI (Mapeada para Kmscon)
PALETTE="0:#150f08 1:#402c18 2:#553a20 3:#6a4928 4:#4a331c 5:#5f4224 6:#ae998b 7:#cec2b9 8:#352514 9:#5f4224 10:#6a4928 11:#ae998b 12:#beada2 13:#cec2b9 14:#ded6d1 15:#efebe8"
EOF

# --- TEMA 2: GANACHE AU LAIT (Standard) ---
cat <<EOF >"$THEMES_DIR/ganache_lait.theme"
# TEMA: Ganache Au Lait (Chocolate ao Leite)
# Descrição: Equilíbrio clássico, tons de café e creme.

THEME_NAME="Ganache Au Lait"
BG_COLOR="#2a1d10"    # Espresso
FG_COLOR="#ded6d1"    # Milk Foam
ACCENT="#ae998b"      # Soft Brown
WARN="#20160c"        # Aviso escuro

PALETTE="0:#20160c 1:#553a20 2:#6a4928 3:#ae998b 4:#4a331c 5:#5f4224 6:#beada2 7:#ded6d1 8:#352514 9:#6a4928 10:#ae998b 11:#beada2 12:#cec2b9 13:#ded6d1 14:#efebe8 15:#ffffff"
EOF

# --- TEMA 3: GANACHE BLANC (Light) ---
cat <<EOF >"$THEMES_DIR/ganache_blanc.theme"
# TEMA: Ganache Blanc (Chocolate Branco)
# Descrição: Modo claro elegante, inverte a lógica tradicional.

THEME_NAME="Ganache Blanc"
BG_COLOR="#efebe8"    # White Chocolate
FG_COLOR="#352514"    # Coffee Bean
ACCENT="#5f4224"      # Chocolate
WARN="#6a4928"        # Aviso

PALETTE="0:#efebe8 1:#5f4224 2:#4a331c 3:#6a4928 4:#2a1d10 5:#402c18 6:#553a20 7:#20160c 8:#ded6d1 9:#ae998b 10:#beada2 11:#cec2b9 12:#4a331c 13:#5f4224 14:#6a4928 15:#0b0704"
EOF

echo "    [OK] Temas gerados em $THEMES_DIR."

# 5. Criar o Esqueleto do Script Principal (Aurora)
echo -e "${BLUE}>>> Criando esqueleto do executável 'aurora'...${NC}"

cat <<'EOF' >"$AURORA_BIN"
#!/bin/bash
# ==============================================================================
# AURORA - TTY Theme Engine (Monolith Modular Architecture)
# ==============================================================================

# 1. CONSTANTES E CONFIGURAÇÃO
AURORA_DIR="/etc/aurora"
THEMES_DIR="$AURORA_DIR/themes"
KMSCON_CONF="/etc/kmscon/kmscon.conf"
STARSHIP_GLOBAL="/etc/starship.toml" # Opcional, ou usar ~/.config/
LOG_FILE="/var/log/aurora.log"

# 2. FUNÇÕES UTILITÁRIAS (UI & Logs)
log_msg() { echo -e "[\e[34mAURORA\e[0m] $1"; }
log_err() { echo -e "[\e[31mERRO\e[0m] $1"; }

draw_box() {
    # TODO: Implementar lógica de Box Drawing Unicode aqui
    echo "╭──────────────────────────────────────────────╮"
    echo "│ $1"
    echo "├──────────────────────────────────────────────┤"
    echo "│ $2"
    echo "╰──────────────────────────────────────────────╯"
}

# 3. MÓDULO DE BOOTSTRAP (Instalação)
check_dependencies() {
    log_msg "Verificando dependências (kmscon, fonts, starship)..."
    # TODO: Lógica de apt-get install, curl starship, fc-cache
}

setup_environment() {
    log_msg "Configurando ambiente inicial..."
    # TODO: Criar pastas de usuário se necessário
}

# 4. MÓDULO DO MOTOR KMSCON
update_kmscon_config() {
    local theme_path="$THEMES_DIR/$1.theme"
    if [ ! -f "$theme_path" ]; then
        log_err "Tema '$1' não encontrado!"
        return 1
    fi
    
    source "$theme_path"
    log_msg "Aplicando tema: $THEME_NAME no Kmscon..."
    
    # TODO: Lógica para editar $KMSCON_CONF
    # Exemplo: sed -i "s/palette=.*/palette=$PALETTE/" $KMSCON_CONF
}

# 5. MÓDULO DE INTEGRAÇÃO STARSHIP
generate_starship_toml() {
    log_msg "Atualizando prompt Starship..."
    # TODO: Gerar ~/.config/starship.toml com as cores $BG_COLOR e $ACCENT
}

# 6. MÓDULO DE VISUALIZAÇÃO (Preview)
preview_theme() {
    local theme_path="$THEMES_DIR/$1.theme"
    if [ -f "$theme_path" ]; then
        source "$theme_path"
        # TODO: printf "\033]11;${BG_COLOR}\007"
        log_msg "Preview do tema $THEME_NAME (5 segundos...)"
        sleep 5
        # TODO: Resetar cores
    fi
}

# 7. CONTROLADOR PRINCIPAL (CLI Router)
case "$1" in
    setup)
        check_dependencies
        setup_environment
        ;;
    list)
        ls -1 "$THEMES_DIR" | sed 's/\.theme//'
        ;;
    preview)
        [ -z "$2" ] && echo "Uso: aurora preview <nome_tema>" && exit 1
        preview_theme "$2"
        ;;
    apply)
        [ -z "$2" ] && echo "Uso: aurora apply <nome_tema>" && exit 1
        update_kmscon_config "$2"
        generate_starship_toml "$2"
        log_msg "Reiniciando serviço kmscon..."
        # systemctl restart kmscon
        ;;
    help|*)
        echo "Uso: aurora {setup|list|preview|apply <tema>}"
        exit 1
        ;;
esac
EOF

# Tornar executável
chmod +x "$AURORA_BIN"
echo "    [OK] Script criado em $AURORA_BIN e permissões definidas."

echo -e "${GREEN}>>> ESTRUTURA CRIADA COM SUCESSO!${NC}"
echo -e "Agora você pode pedir ao LLM para preencher a lógica detalhada dentro do arquivo:"
echo -e "    ${BLUE}$AURORA_BIN${NC}"
echo -e "Os temas já estão prontos em:"
echo -e "    ${BLUE}$THEMES_DIR${NC}"
