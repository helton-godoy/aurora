#!/bin/bash
# ==============================================================================
# AURORA - Constantes Globais
# ==============================================================================

# Versão
readonly SCRIPT_VERSION="3.0"

# Diretórios
readonly AURORA_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
readonly THEME_DIR="$AURORA_ROOT/themes"
readonly SYSTEM_THEME_DIR="/etc/aurora/themes"
readonly CONFIG_DIR="$HOME/.config/aurora"
readonly BACKUP_DIR="$CONFIG_DIR/backups"

# Arquivos de configuração
readonly STATE_FILE="$CONFIG_DIR/state.yml"
readonly KMSCON_CONF="/etc/kmscon/kmscon.conf"
readonly STARSHIP_CONFIG="$HOME/.config/starship.toml"

# ============================================================================
# PALETA DE CORES GANACHE (ESTRITA - NÃO ALTERAR)
# ============================================================================

# Tons Escuros (Dark/Chocolate)
readonly COLOR_CARAMEL="#6a4928"
readonly COLOR_DARK_CARAMEL="#5f4224"
readonly COLOR_COCOA="#553a20"
readonly COLOR_DARK_COCOA="#4a331c"
readonly COLOR_COFFEE="#402c18"
readonly COLOR_DARK_COFFEE="#352514"
readonly COLOR_ESPRESSO="#2a1d10"
readonly COLOR_DARK_ESPRESSO="#20160c"
readonly COLOR_BITTER="#150f08"
readonly COLOR_DEEP_DARK="#0b0704"

# Tons Claros (Leite/Creme)
readonly COLOR_SOFT_BROWN="#ae998b"
readonly COLOR_ROASTED_ALMOND="#beada2"
readonly COLOR_CREAM="#cec2b9"
readonly COLOR_MILK_FOAM="#ded6d1"
readonly COLOR_WHITE_CHOCOLATE="#efebe8"

# Cores para UI (baseadas na paleta)
readonly UI_BORDER="$COLOR_CARAMEL"
readonly UI_TEXT="$COLOR_ROASTED_ALMOND"
readonly UI_ACCENT="$COLOR_SOFT_BROWN"
readonly UI_SUCCESS="#26a048"
readonly UI_ERROR="#b03a24"
readonly UI_WARNING="#bf9000"
readonly UI_INFO="$COLOR_SOFT_BROWN"

# ============================================================================
# SÍMBOLOS ESPECIAIS (Fonte: github.com/helton-godoy/SpecialSymbol)
# ============================================================================

# Box Drawing - Cantos e Linhas
readonly SYM_TL="╭" # Top-left corner
readonly SYM_TR="╮" # Top-right corner
readonly SYM_BL="╰" # Bottom-left corner
readonly SYM_BR="╯" # Bottom-right corner
readonly SYM_H="─"  # Horizontal line
readonly SYM_V="│"  # Vertical line
readonly SYM_CROSS="┼"
readonly SYM_T_DOWN="┬"
readonly SYM_T_UP="┴"
readonly SYM_T_RIGHT="├"
readonly SYM_T_LEFT="┤"

# Box Drawing - Estilo Duplo
readonly SYM_DBL_TL="╔"
readonly SYM_DBL_TR="╗"
readonly SYM_DBL_BL="╚"
readonly SYM_DBL_BR="╝"
readonly SYM_DBL_H="═"
readonly SYM_DBL_V="║"

# Box Drawing - Estilo Grosso
readonly SYM_THICK_TL="┏"
readonly SYM_THICK_TR="┓"
readonly SYM_THICK_BL="┗"
readonly SYM_THICK_BR="┛"
readonly SYM_THICK_H="━"
readonly SYM_THICK_V="┃"

# Status e Indicadores
readonly SYM_SUCCESS="✓"
readonly SYM_ERROR="✗"
readonly SYM_WARN="⚠"
readonly SYM_INFO="ℹ"
readonly SYM_CHECK="☑"
readonly SYM_UNCHECK="☐"
readonly SYM_CROSS_BOX="☒"

# Bullets e Marcadores
readonly SYM_BULLET="•"
readonly SYM_DIAMOND="◆"
readonly SYM_DIAMOND_EMPTY="◇"
readonly SYM_STAR="★"
readonly SYM_STAR_EMPTY="☆"
readonly SYM_CIRCLE="●"
readonly SYM_CIRCLE_EMPTY="○"
readonly SYM_SQUARE="■"
readonly SYM_SQUARE_EMPTY="□"
readonly SYM_TRIANGLE="▲"
readonly SYM_TRIANGLE_DOWN="▼"

# Setas
readonly SYM_ARROW_RIGHT="→"
readonly SYM_ARROW_LEFT="←"
readonly SYM_ARROW_UP="↑"
readonly SYM_ARROW_DOWN="↓"
readonly SYM_ARROW_DOUBLE="↔"
readonly SYM_ARROW_POINT="➤"
readonly SYM_ARROW_FANCY="➜"

# Decorativos e Especiais
readonly SYM_CHOCOLATE="🍫"
readonly SYM_COFFEE="☕"
readonly SYM_SUN="☀"
readonly SYM_MOON="☾"
readonly SYM_CLOUD="☁"
readonly SYM_HEART="❤"
readonly SYM_SPARKLE="✦"
readonly SYM_SPARKLE2="✧"
readonly SYM_FLOWER="✿"
readonly SYM_SNOWFLAKE="❄"
readonly SYM_MUSIC="♪"
readonly SYM_YIN_YANG="☯"
readonly SYM_PEACE="☮"

# Indicadores de Progresso
readonly SYM_PROGRESS_FULL="█"
readonly SYM_PROGRESS_HALF="▌"
readonly SYM_PROGRESS_EMPTY="░"
readonly SYM_SHADE_LIGHT="░"
readonly SYM_SHADE_MED="▒"
readonly SYM_SHADE_DARK="▓"

# Faces e Emoticons
readonly SYM_SMILE="☺"
readonly SYM_SMILE_FILLED="☻"
readonly SYM_SAD="☹"

# Matemáticos e Lógicos
readonly SYM_INFINITY="∞"
readonly SYM_APPROX="≈"
readonly SYM_NOT_EQUAL="≠"
readonly SYM_LESS_EQ="≤"
readonly SYM_GREATER_EQ="≥"
readonly SYM_SIGMA="Σ"
readonly SYM_PI="Π"
readonly SYM_DELTA="Δ"
readonly SYM_OMEGA="Ω"

# Moedas e Símbolos Comerciais
readonly SYM_COPYRIGHT="©"
readonly SYM_REGISTERED="®"
readonly SYM_TRADEMARK="™"
readonly SYM_EURO="€"
readonly SYM_POUND="£"
readonly SYM_YEN="¥"

# ============================================================================
# CONSTANTES DE PLUGIN
# ============================================================================

readonly AURORA_REMOTE_REPO="${AURORA_PLUGIN_REPO:-https://raw.githubusercontent.com/helton-godoy/aurora/master/themes}"
