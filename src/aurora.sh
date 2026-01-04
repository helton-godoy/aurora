#!/bin/bash

# ============================================================================
# AURORA - Gerenciador de Temas Visuais para Servidores Headless
# Versão: 2.2
# Autor: Kilo Code
# Descrição: Gerenciador de temas para terminal kmscon e prompt Starship
# Paleta: Ganache (tons de chocolate)
# Dependências: gum, kmscon, starship, FiraCode Nerd Font
# ============================================================================

set -euo pipefail

# ============================================================================
# CONFIGURAÇÕES GLOBAIS
# ============================================================================

readonly SCRIPT_NAME="aurora"
readonly SCRIPT_VERSION="2.2"
readonly THEME_DIR="/etc/aurora/themes"
readonly CONFIG_DIR="/etc/aurora"
readonly KMSCON_CONF="/etc/kmscon/kmscon.conf"
readonly STARSHIP_CONFIG="$HOME/.config/starship.toml"
readonly BASHRC="$HOME/.bashrc"
readonly FONT_DIR="/usr/local/share/fonts"

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
# VERIFICAÇÃO DO GUM
# ============================================================================

check_gum() {
	if ! command -v gum &>/dev/null; then
		echo "❌ ERRO: 'gum' não está instalado."
		echo ""
		echo "Instale com:"
		echo "  sudo mkdir -p /etc/apt/keyrings"
		echo "  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg"
		echo "  echo 'deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *' | sudo tee /etc/apt/sources.list.d/charm.list"
		echo "  sudo apt update && sudo apt install gum"
		exit 1
	fi
}

# ============================================================================
# FUNÇÕES DE UI COM GUM
# ============================================================================

# Banner principal
show_banner() {
	gum style \
		--border double \
		--border-foreground "$UI_BORDER" \
		--foreground "$UI_TEXT" \
		--align center \
		--width 76 \
		--margin "0 2" \
		--padding "0 2" \
		"$SYM_CHOCOLATE AURORA v$SCRIPT_VERSION" \
		"Gerenciador de Temas Visuais para Servidores Headless" \
		"Paleta: Ganache (Chocolate) $SYM_SPARKLE"
	echo
}

# Caixa estilo "heavy" (títulos principais)
box_heavy() {
	local title="$1"
	shift
	local content="$*"

	gum style \
		--border thick \
		--border-foreground "$UI_BORDER" \
		--foreground "$UI_TEXT" \
		--align left \
		--width 76 \
		--margin "0 2" \
		--padding "0 2" \
		"$(gum style --bold --foreground "$UI_ACCENT" "$title")" \
		"" \
		"$content"
}

# Caixa estilo "light" (informações)
box_light() {
	local title="$1"
	shift
	local content="$*"

	gum style \
		--border rounded \
		--border-foreground "$UI_BORDER" \
		--foreground "$UI_TEXT" \
		--align left \
		--width 76 \
		--margin "0 2" \
		--padding "0 2" \
		"$(gum style --bold --foreground "$UI_ACCENT" "$title")" \
		"" \
		"$content"
}

# Caixas de status
box_success() {
	local message="$1"
	gum style \
		--border rounded \
		--border-foreground "$UI_SUCCESS" \
		--foreground "$COLOR_MILK_FOAM" \
		--width 76 --margin "0 2" --padding "0 2" \
		"$(gum style --bold --foreground "$UI_SUCCESS" "$SYM_SUCCESS SUCESSO")" "" "$message"
}

box_error() {
	local message="$1"
	gum style \
		--border rounded \
		--border-foreground "$UI_ERROR" \
		--foreground "$COLOR_MILK_FOAM" \
		--width 76 --margin "0 2" --padding "0 2" \
		"$(gum style --bold --foreground "$UI_ERROR" "$SYM_ERROR ERRO")" "" "$message"
}

box_warning() {
	local message="$1"
	gum style \
		--border rounded \
		--border-foreground "$UI_WARNING" \
		--foreground "$COLOR_MILK_FOAM" \
		--width 76 --margin "0 2" --padding "0 2" \
		"$(gum style --bold --foreground "$UI_WARNING" "$SYM_WARN AVISO")" "" "$message"
}

box_info() {
	local message="$1"
	gum style \
		--foreground "$UI_TEXT" \
		--margin "0 2" \
		"$SYM_CHOCOLATE $message"
}

# Animação de loading
show_loading() {
	local message="$1"

	# Verificar se há TTY disponível (modo interativo)
	if [[ -t 1 ]] && [[ -t 0 ]]; then
		gum spin --spinner dot --title "$message" -- sleep 1
	else
		# Modo não-interativo: usar echo simples
		echo "  $message..."
		sleep 1
	fi
}

# ============================================================================
# PASSO 1: BOOTSTRAP - INSTALAÇÃO DE DEPENDÊNCIAS
# ============================================================================

check_root() {
	if [[ $EUID -ne 0 ]]; then
		box_error "Este comando deve ser executado como root (sudo)"
		exit 1
	fi
}

install_dependencies() {
	check_root
	clear
	show_banner

	# ⚠️ AVISO DE SEGURANÇA IMPORTANTE
	box_warning "⚠️  AVISO DE SEGURANÇA IMPORTANTE

O Aurora foi atualizado com correções de segurança após
detectar conflitos críticos com kmscon que causavam
tela preta no sistema.

🔧 CORREÇÕES IMPLEMENTADAS:
  • Configuração kmscon segura (sem TrueColor por padrão)
  • Verificação de fonte antes de configuração
  • Serviço systemd removido para evitar conflitos no boot
  • Aplicação manual de temas (mais segura)

🚨 ANTES DE CONTINUAR:
  • Certifique-se de ter um backup do sistema
  • Teste primeiro com 'aurora preview <tema>'
  • Aplique temas permanentemente apenas se satisfeito"

	# Verificar se foi passado --yes para instalação não-interativa
	if [[ "${2:-}" == "--yes" ]] || [[ "${FORCE_INSTALL:-}" == "true" ]]; then
		gum style --foreground "$UI_INFO" "  $SYM_INFO Instalação não-interativa ativada"
		gum style --foreground "$UI_INFO" "  $SYM_INFO Continuando automaticamente..."
	else
		if ! gum confirm "Continuar com a instalação?" --default=false; then
			box_info "Instalação cancelada pelo usuário."
			exit 0
		fi
	fi

	box_info "Iniciando instalação das dependências do AURORA..."
	echo

	# Atualizar repositórios
	show_loading "Atualizando repositórios do sistema..."
	apt update -qq 2>/dev/null

	# Instalar pacotes básicos
	local packages=("kmscon" "curl" "fontconfig" "git")
	for package in "${packages[@]}"; do
		if ! dpkg -l 2>/dev/null | grep -q "^ii  $package "; then
			show_loading "Instalando $package..."
			apt install -y "$package" >/dev/null 2>&1
			gum style --foreground "$UI_SUCCESS" "  ✅ $package instalado"
		else
			gum style --foreground "$UI_ACCENT" "  🍫 $package já está instalado"
		fi
	done

	# Instalar gum se não estiver presente
	if ! command -v gum &>/dev/null; then
		show_loading "Configurando repositório Charm..."
		mkdir -p /etc/apt/keyrings
		curl -fsSL https://repo.charm.sh/apt/gpg.key | gpg --dearmor -o /etc/apt/keyrings/charm.gpg 2>/dev/null
		echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" >/etc/apt/sources.list.d/charm.list
		apt update -qq 2>/dev/null
		show_loading "Instalando gum..."
		apt install -y gum >/dev/null 2>&1
		gum style --foreground "$UI_SUCCESS" "  ✅ gum instalado"
	else
		gum style --foreground "$UI_ACCENT" "  🍫 gum já está instalado"
	fi

	# Instalar Starship
	if ! command -v starship &>/dev/null; then
		show_loading "Instalando Starship..."
		curl -fsSL https://starship.rs/install.sh | sh -s -- --bin-dir /usr/local/bin -y >/dev/null 2>&1
		gum style --foreground "$UI_SUCCESS" "  ✅ Starship instalado"
	else
		gum style --foreground "$UI_ACCENT" "  🍫 Starship já está instalado"
	fi

	# Instalar FiraCode Nerd Font
	install_nerd_font

	# Configurar kmscon
	configure_kmscon

	# Gerar arquivos de tema
	generate_theme_files

	# Configurar bashrc
	configure_bashrc

	# Criar serviço systemd para persistência após reboot
	create_systemd_service

	echo
	box_success "Todas as dependências foram instaladas com sucesso!

$SYM_ARROW_POINT Próximos passos:
  $SYM_BULLET Execute 'aurora list' para ver temas disponíveis
  $SYM_BULLET Execute 'aurora apply ganache_lait' para aplicar o tema padrão
  $SYM_BULLET Execute 'aurora preview <tema>' para visualizar antes de aplicar"
}

install_nerd_font() {
	local cache_dir="/var/cache/aurora/fonts"
	mkdir -p "$cache_dir" "$FONT_DIR"

	# Verificar se já existe uma fonte adequada instalada
	if fc-list 2>/dev/null | grep -qi "firacode.*nerd\|hack.*nerd\|source.*code.*pro.*nerd\|jetbrains.*mono.*nerd\|cascadia.*code.*nerd"; then
		local installed_font
		installed_font=$(fc-list 2>/dev/null | grep -i "nerd" | head -1 | cut -d: -f2 | sed 's/^ *//')
		gum style --foreground "$UI_ACCENT" "  $SYM_CHOCOLATE Fonte Nerd já instalada: $installed_font"
		return 0
	fi

	show_loading "Instalando fonte Nerd Font..."

	# Lista de fontes para tentar (prioridade: FiraCode, Hack, JetBrains, Cascadia)
	local fonts=(
		"FiraCode:FiraCode.zip:https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
		"Hack:Hack.zip:https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
		"JetBrainsMono:JetBrainsMono.zip:https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
		"CascadiaCode:CascadiaCode.zip:https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"
	)

	# Tentar instalar cada fonte
	for font_info in "${fonts[@]}"; do
		IFS=':' read -r font_name zip_name font_url <<<"$font_info"

		gum style --foreground "$UI_INFO" "  $SYM_INFO Tentando instalar $font_name..."

		# Limpar cache anterior
		rm -rf "$cache_dir"/*
		mkdir -p "$cache_dir"

		# Tentar download com múltiplas tentativas
		local attempt=1
		local max_attempts=3
		local success=false

		while [[ $attempt -le $max_attempts ]] && [[ $success == false ]]; do
			if curl -fsSL --connect-timeout 15 --max-time 60 "$font_url" -o "$cache_dir/$zip_name" 2>/dev/null; then
				# Extrair e instalar
				if unzip -oq "$cache_dir/$zip_name" -d "$cache_dir" 2>/dev/null; then
					# Copiar apenas arquivos .ttf para o diretório de fontes
					find "$cache_dir" -name "*.ttf" -exec cp {} "$FONT_DIR/" \; 2>/dev/null || true

					# Atualizar cache de fontes
					if fc-cache -fv >/dev/null 2>&1; then
						# Verificar se a fonte foi instalada corretamente
						sleep 1
						if fc-list 2>/dev/null | grep -qi "$font_name.*nerd"; then
							rm -rf "$cache_dir"
							gum style --foreground "$UI_SUCCESS" "  $SYM_SUCCESS $font_name Nerd Font instalada com sucesso"
							return 0
						fi
					fi
				fi
			fi

			if [[ $attempt -lt $max_attempts ]]; then
				gum style --foreground "$UI_WARNING" "  $SYM_WARN Tentativa $attempt falhou, tentando novamente..."
				sleep 2
			fi
			((attempt++))
		done

		gum style --foreground "$UI_WARNING" "  $SYM_WARN Falha ao instalar $font_name, tentando próxima fonte..."
	done

	# Fallback: tentar instalar via apt se disponível
	gum style --foreground "$UI_INFO" "  $SYM_INFO Tentando instalar via apt..."

	local apt_fonts=("fonts-firacode" "fonts-hack" "fonts-jetbrains-mono" "fonts-cascadia-code")
	for apt_font in "${apt_fonts[@]}"; do
		if apt-cache show "$apt_font" >/dev/null 2>&1; then
			if apt install -y "$apt_font" >/dev/null 2>&1; then
				fc-cache -fv >/dev/null 2>&1
				sleep 1
				if fc-list 2>/dev/null | grep -qi "nerd\|hack\|firacode\|jetbrains\|cascadia"; then
					rm -rf "$cache_dir"
					gum style --foreground "$UI_SUCCESS" "  $SYM_SUCCESS Fonte instalada via apt: $apt_font"
					return 0
				fi
			fi
		fi
	done

	# Último fallback: tentar fonte básica do sistema
	rm -rf "$cache_dir"
	gum style --foreground "$UI_WARNING" "  $SYM_WARN Nenhuma fonte Nerd Font pôde ser instalada"
	gum style --foreground "$UI_INFO" "  $SYM_INFO Usando fontes padrão do sistema (funcionalidade reduzida)"
	return 1
}

configure_kmscon() {
	show_loading "Configurando kmscon..."
	mkdir -p "/etc/kmscon"

	# Verificar se FiraCode Nerd Font está disponível antes de configurar
	local font_available=false
	if fc-list 2>/dev/null | grep -qi "firacode.*nerd"; then
		font_available=true
	fi

	cat >"$KMSCON_CONF" <<KMSCON_EOF
# ============================================================================
# Configuração do KMSCON para AURORA
# Gerado automaticamente - Não edite manualmente
# ============================================================================

# Fonte - Usar fonte segura se FiraCode não estiver disponível
$(if [[ "\$font_available" == "true" ]]; then
	echo "font-name=FiraCode Nerd Font"
	echo "font-size=12"
	echo "font-force-scalable=true"
else
	echo "# FiraCode Nerd Font não encontrada - usando fonte padrão do sistema"
	echo "# font-name=FiraCode Nerd Font"
	echo "# font-size=12"
	echo "# font-force-scalable=true"
fi)

# Cores (TrueColor) - Desabilitado por segurança
# color-truecolor=true

# Paleta de 16 cores básica (compatível com kmscon)
color-0=0,0,0          # Black
color-1=255,0,0        # Red
color-2=0,255,0        # Green
color-3=255,255,0      # Yellow
color-4=0,0,255        # Blue
color-5=255,0,255      # Magenta
color-6=0,255,255      # Cyan
color-7=255,255,255    # White
color-8=128,128,128    # Bright Black
color-9=255,128,128    # Bright Red
color-10=128,255,128   # Bright Green
color-11=255,255,128   # Bright Yellow
color-12=128,128,255   # Bright Blue
color-13=255,128,255   # Bright Magenta
color-14=128,255,255   # Bright Cyan
color-15=255,255,255   # Bright White

# Console - Configurações mínimas para evitar conflitos
console=true
# xkb-layout=us
# xkb-variant=
# xkb-options=caps:escape
KMSCON_EOF

	gum style --foreground "$UI_SUCCESS" "  ✅ kmscon configurado com segurança"
}

configure_bashrc() {
	local starship_init='eval "$(starship init bash)"'

	if ! grep -q "starship init bash" "$BASHRC" 2>/dev/null; then
		show_loading "Configurando Starship no bashrc..."
		echo "" >>"$BASHRC"
		echo "# Aurora Theme Manager - Starship initialization" >>"$BASHRC"
		echo "$starship_init" >>"$BASHRC"
		gum style --foreground "$UI_SUCCESS" "  ✅ Starship adicionado ao bashrc"
	else
		gum style --foreground "$UI_ACCENT" "  $SYM_CHOCOLATE Starship já está no bashrc"
	fi
}

# ============================================================================
# PASSO 1.1: SISTEMA DE ESTADO PERSISTENTE
# ============================================================================

readonly STATE_FILE="/etc/aurora/state"

# Salvar tema atualmente aplicado
save_current_theme() {
	local theme_name="$1"
	mkdir -p "$(dirname "$STATE_FILE")"

	cat >"$STATE_FILE" <<EOF
{
  "current_theme": "$theme_name",
  "last_applied": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "script_version": "$SCRIPT_VERSION"
}
EOF
}

# Ler tema atual do estado
get_current_theme() {
	if [[ -f "$STATE_FILE" ]]; then
		# Usar grep/sed para parsing simples (sem dependência de jq)
		grep -oP '"current_theme":\s*"\K[^"]+' "$STATE_FILE" 2>/dev/null || echo ""
	else
		echo ""
	fi
}

# ============================================================================
# PASSO 1.2: SISTEMA DE BACKUP AUTOMÁTICO
# ============================================================================

readonly BACKUP_DIR="/etc/aurora/backups"

# Backup das configurações do sistema
backup_system_config() {
	local backup_timestamp
	backup_timestamp=$(date +%Y%m%d_%H%M%S)
	local current_backup="$BACKUP_DIR/$backup_timestamp"
	mkdir -p "$current_backup"

	# Backup kmscon
	if [[ -f "$KMSCON_CONF" ]]; then
		cp "$KMSCON_CONF" "$current_backup/kmscon.conf.backup"
	fi

	# Backup bashrc
	if [[ -f "$BASHRC" ]]; then
		cp "$BASHRC" "$current_backup/bashrc.backup"
	fi

	# Backup starship
	if [[ -f "$STARSHIP_CONFIG" ]]; then
		cp "$STARSHIP_CONFIG" "$current_backup/starship.toml.backup"
	fi

	# Limitar a 10 backups mais recentes
	local backup_count
	backup_count=$(find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
	if ((backup_count > 10)); then
		find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort | head -n $((backup_count - 10)) | xargs rm -rf
	fi

	gum style --foreground "$UI_SUCCESS" "  $SYM_SUCCESS Backup salvo em $current_backup"
}

# ============================================================================
# PASSO 1.3: VALIDADOR DE CONTRASTE WCAG
# ============================================================================

# Converter hex para RGB
hex_to_rgb() {
	local hex="$1"
	hex=${hex#\#}
	echo "$((16#${hex:0:2})) $((16#${hex:2:2})) $((16#${hex:4:2}))"
}

# Calcular luminância relativa (simplificado para bash)
calculate_luminance() {
	local r="$1" g="$2" b="$3"

	# Normalizar para 0-1 e aplicar fórmula simplificada
	# L = 0.2126 * R + 0.7152 * G + 0.0722 * B
	local lum
	lum=$(awk "BEGIN { printf \"%.4f\", (0.2126 * $r + 0.7152 * $g + 0.0722 * $b) / 255 }")
	echo "$lum"
}

# Validar contraste entre duas cores (WCAG AA = 4.5:1)
validate_color_contrast() {
	local bg_color="$1"
	local fg_color="$2"

	local bg_rgb fg_rgb
	read -r bg_r bg_g bg_b <<<"$(hex_to_rgb "$bg_color")"
	read -r fg_r fg_g fg_b <<<"$(hex_to_rgb "$fg_color")"

	local bg_lum fg_lum
	bg_lum=$(calculate_luminance "$bg_r" "$bg_g" "$bg_b")
	fg_lum=$(calculate_luminance "$fg_r" "$fg_g" "$fg_b")

	# Calcular ratio de contraste
	local lighter darker contrast
	lighter=$(awk "BEGIN { print ($bg_lum > $fg_lum) ? $bg_lum : $fg_lum }")
	darker=$(awk "BEGIN { print ($bg_lum > $fg_lum) ? $fg_lum : $bg_lum }")
	contrast=$(awk "BEGIN { printf \"%.2f\", ($lighter + 0.05) / ($darker + 0.05) }")

	# Verificar WCAG AA (4.5:1)
	local valid
	valid=$(awk "BEGIN { print ($contrast >= 4.5) ? 1 : 0 }")

	if [[ "$valid" == "1" ]]; then
		return 0
	else
		echo "$contrast"
		return 1
	fi
}

# ============================================================================
# PASSO 1.4: SERVIÇO SYSTEMD PARA KMSCON
# ============================================================================

create_systemd_service() {
	if [[ $EUID -ne 0 ]]; then
		return 1
	fi

	# ⚠️ AVISO: Serviço systemd desabilitado por segurança
	# O serviço pode causar conflitos durante o boot do sistema
	# Os temas serão aplicados manualmente via comandos aurora

	gum style --foreground "$UI_WARNING" "  $SYM_WARN Serviço systemd desabilitado por segurança"
	gum style --foreground "$UI_INFO" "  $SYM_INFO Use 'sudo aurora apply <tema>' para aplicar temas"

	# Remover serviço se existir (para limpeza)
	if [[ -f "/etc/systemd/system/aurora-kmscon.service" ]]; then
		systemctl disable aurora-kmscon.service 2>/dev/null || true
		rm -f "/etc/systemd/system/aurora-kmscon.service" 2>/dev/null || true
		systemctl daemon-reload 2>/dev/null || true
	fi

	# Não criar o serviço - usar abordagem manual segura
	return 0
}

# ============================================================================
# PASSO 5: GERAÇÃO DOS ARQUIVOS DE TEMA
# ============================================================================

generate_theme_files() {
	show_loading "Gerando arquivos de tema..."
	mkdir -p "$THEME_DIR"

	# Tema 1: Ganache Noir (Dark Mode)
	cat >"$THEME_DIR/ganache_noir.theme" <<'THEME_EOF'
# ============================================================================
# AURORA Theme: Ganache Noir (Dark Mode)
# Paleta: Chocolate Escuro Intenso
# ============================================================================
THEME_NAME="Ganache Noir"
THEME_DESCRIPTION="Modo escuro intenso - Deep Dark com Roasted Almond"

# Cores principais
BG_COLOR="#0b0704"
FG_COLOR="#beada2"
ACCENT="#6a4928"

# Cores adicionais (para Starship)
CURSOR_COLOR="#6a4928"
SELECTION_BG="#2a1d10"
SELECTION_FG="#ded6d1"

# Mapeamento para kmscon
KMSCON_BG="11,7,4"
KMSCON_FG="190,173,162"
THEME_EOF

	# Tema 2: Ganache Lait (Standard Mode)
	cat >"$THEME_DIR/ganache_lait.theme" <<'THEME_EOF'
# ============================================================================
# AURORA Theme: Ganache Lait (Standard Mode)
# Paleta: Café com Leite Equilibrado
# ============================================================================
THEME_NAME="Ganache Lait"
THEME_DESCRIPTION="Modo padrão equilibrado - Espresso com Milk Foam"

# Cores principais
BG_COLOR="#2a1d10"
FG_COLOR="#ded6d1"
ACCENT="#ae998b"

# Cores adicionais (para Starship)
CURSOR_COLOR="#ae998b"
SELECTION_BG="#402c18"
SELECTION_FG="#efebe8"

# Mapeamento para kmscon
KMSCON_BG="42,29,16"
KMSCON_FG="222,214,209"
THEME_EOF

	# Tema 3: Ganache Blanc (Light Mode)
	cat >"$THEME_DIR/ganache_blanc.theme" <<'THEME_EOF'
# ============================================================================
# AURORA Theme: Ganache Blanc (Light Mode)
# Paleta: Chocolate Branco Elegante
# ============================================================================
THEME_NAME="Ganache Blanc"
THEME_DESCRIPTION="Modo claro elegante - White Chocolate com Coffee Bean"

# Cores principais
BG_COLOR="#efebe8"
FG_COLOR="#352514"
ACCENT="#5f4224"

# Cores adicionais (para Starship)
CURSOR_COLOR="#5f4224"
SELECTION_BG="#cec2b9"
SELECTION_FG="#2a1d10"

# Mapeamento para kmscon
KMSCON_BG="239,235,232"
KMSCON_FG="53,37,20"
THEME_EOF

	gum style --foreground "$UI_SUCCESS" "  ✅ Arquivos de tema gerados em $THEME_DIR"
}

# ============================================================================
# PASSO 3: APLICAÇÃO DE TEMA
# ============================================================================

apply_theme() {
	local theme_name="$1"
	local theme_file="$THEME_DIR/${theme_name}.theme"

	clear
	show_banner

	if [[ ! -f "$theme_file" ]]; then
		box_error "Tema '$theme_name' não encontrado em $THEME_DIR"
		echo
		gum style --foreground "$UI_TEXT" "Use 'aurora list' para ver temas disponíveis"
		exit 1
	fi

	# Fazer backup antes de modificar
	if [[ $EUID -eq 0 ]]; then
		backup_system_config
	fi

	show_loading "Aplicando tema: $theme_name..."

	# Carregar variáveis do tema
	# shellcheck source=/dev/null
	source "$theme_file"

	# Validar contraste WCAG
	local contrast_ratio
	if ! contrast_ratio=$(validate_color_contrast "$BG_COLOR" "$FG_COLOR"); then
		box_warning "Contraste insuficiente entre background ($BG_COLOR) e foreground ($FG_COLOR)
        
Ratio atual: ${contrast_ratio}:1 (mínimo recomendado: 4.5:1)
Este tema pode ter problemas de legibilidade."
		echo
		if ! gum confirm "Aplicar tema mesmo assim?" --default=false; then
			gum style --foreground "$UI_TEXT" "Aplicação cancelada."
			return 1
		fi
	fi

	# Gerar configuração do Starship
	generate_starship_config "$theme_name"

	# Atualizar kmscon (requer root)
	if [[ $EUID -eq 0 ]]; then
		update_kmscon_theme
		save_current_theme "$theme_name"
	else
		gum style --foreground "$UI_WARNING" "  $SYM_WARN Execute como root para aplicar tema no kmscon"
	fi

	echo
	box_success "Tema '$THEME_NAME' aplicado com sucesso!

$SYM_CHOCOLATE Cores aplicadas:
  $SYM_BULLET Background: $BG_COLOR
  $SYM_BULLET Foreground: $FG_COLOR  
  $SYM_BULLET Accent: $ACCENT

$SYM_ARROW_POINT Para ver as mudanças:
  $SYM_BULLET Reinicie o terminal ou execute: source ~/.bashrc
  $SYM_BULLET Para kmscon: reinicie o serviço ou a sessão"
}

generate_starship_config() {
	local theme_name="$1"

	mkdir -p "$(dirname "$STARSHIP_CONFIG")"

	cat >"$STARSHIP_CONFIG" <<STARSHIP_EOF
# ============================================================================
# Starship Configuration - AURORA Theme: $THEME_NAME
# Gerado automaticamente por aurora apply
# ============================================================================

# Paleta de cores do tema
palette = "ganache"

[palettes.ganache]
background = "$BG_COLOR"
foreground = "$FG_COLOR"
accent = "$ACCENT"
caramel = "#6a4928"
espresso = "#2a1d10"
milk = "#ded6d1"
cream = "#cec2b9"

# Prompt principal
format = """
[┌──](accent)\$username\$hostname[─](accent)\$directory\$git_branch\$git_status
[└─](accent)\$character"""

# Usuário
[username]
style_user = "fg:milk"
style_root = "fg:red bold"
format = "[\\[](accent)[\$user](fg:milk)[\\]](accent)"
show_always = true

# Hostname
[hostname]
ssh_only = false
format = "[@](accent)[\$hostname](fg:cream)"
style = "fg:cream"

# Diretório
[directory]
style = "fg:accent"
format = "[─\\[](accent)[\$path](fg:milk)[\\]](accent)"
truncation_length = 3
truncate_to_repo = true

# Git
[git_branch]
symbol = "🍫 "
style = "fg:caramel"
format = "[─\\[](accent)[\$symbol\$branch](fg:caramel)[\\]](accent)"

[git_status]
style = "fg:caramel"
format = "[\$all_status\$ahead_behind](fg:caramel)"

# Caractere do prompt
[character]
success_symbol = "[→](fg:accent)"
error_symbol = "[✗](fg:red)"
STARSHIP_EOF

	gum style --foreground "$UI_SUCCESS" "  ✅ Starship configurado"
}

update_kmscon_theme() {
	# Atualizar cores de background/foreground no kmscon
	if [[ -f "$KMSCON_CONF" ]] && [[ -n "${KMSCON_BG:-}" ]]; then
		# Adicionar ou atualizar linhas de default-bg/fg
		if grep -q "^default-bg=" "$KMSCON_CONF" 2>/dev/null; then
			sed -i "s/^default-bg=.*/default-bg=$KMSCON_BG/" "$KMSCON_CONF"
		else
			echo "default-bg=$KMSCON_BG" >>"$KMSCON_CONF"
		fi

		if grep -q "^default-fg=" "$KMSCON_CONF" 2>/dev/null; then
			sed -i "s/^default-fg=.*/default-fg=$KMSCON_FG/" "$KMSCON_CONF"
		else
			echo "default-fg=$KMSCON_FG" >>"$KMSCON_CONF"
		fi

		gum style --foreground "$UI_SUCCESS" "  ✅ kmscon atualizado"
	fi
}

# ============================================================================
# PASSO 4: PREVIEW DE TEMA
# ============================================================================

preview_theme() {
	local theme_name="$1"
	local theme_file="$THEME_DIR/${theme_name}.theme"

	if [[ ! -f "$theme_file" ]]; then
		box_error "Tema '$theme_name' não encontrado"
		exit 1
	fi

	# Salvar cores atuais (se possível)
	local original_bg=""
	local original_fg=""

	# Carregar tema
	# shellcheck source=/dev/null
	source "$theme_file"

	clear

	# Aplicar cores via escape ANSI (OSC sequences)
	# \033]11;#RRGGBB\007 - background
	# \033]10;#RRGGBB\007 - foreground
	printf '\033]11;%s\007' "$BG_COLOR"
	printf '\033]10;%s\007' "$FG_COLOR"

	show_banner

	local preview_text
	preview_text=$(
		cat <<EOF
🎨 PREVIEW: $THEME_NAME

$THEME_DESCRIPTION

┌─ Paleta de Cores ─────────────────────────────────────┐
│  Background: $BG_COLOR                                │
│  Foreground: $FG_COLOR                                │
│  Accent:     $ACCENT                                  │
└───────────────────────────────────────────────────────┘

┌─ Exemplo de Prompt ───────────────────────────────────┐
│  ┌──[user]@aurora─[~/projetos/aurora]─[🍫 main]       │
│  └─→ git status                                       │
│  On branch main                                       │
│  nothing to commit, working tree clean                │
└───────────────────────────────────────────────────────┘

┌─ Símbolos e Ícones ───────────────────────────────────┐
│  🍫 Chocolate  ✅ Sucesso  ❌ Erro  🚀 Pronto         │
│  ★ Favorito   ✦ Especial  → Seta   • Ponto           │
└───────────────────────────────────────────────────────┘
EOF
	)

	gum style \
		--border double \
		--border-foreground "$ACCENT" \
		--foreground "$FG_COLOR" \
		--align left \
		--width 76 \
		--margin "0 2" \
		--padding "1 2" \
		"$preview_text"

	echo
	gum style --foreground "$UI_ACCENT" --margin "0 2" \
		"⏳ Preview ativo por 5 segundos... As cores serão revertidas automaticamente."

	sleep 5

	# Reverter cores (reset para padrão do terminal)
	printf '\033]111\007' # Reset background
	printf '\033]110\007' # Reset foreground

	clear
	show_banner
	box_success "Preview do tema '$theme_name' finalizado.

Para aplicar permanentemente, execute:
  sudo aurora apply $theme_name"
}

# ============================================================================
# INTERFACES VISUAIS
# ============================================================================

show_welcome() {
	clear
	show_banner

	local welcome_text
	welcome_text=$(
		cat <<'EOF'
🍫 Bem-vindo ao AURORA - Gerenciador de Temas Visuais

Este sistema gerencia a aparência do terminal kmscon e do
prompt Starship em servidores Debian headless, usando a
paleta de cores Ganache (tons de chocolate).

✦ Recursos:
  • Temas predefinidos: Noir, Lait, Blanc
  • Preview instantâneo sem reiniciar
  • Configuração automática de kmscon e Starship
  • Suporte a FiraCode Nerd Font

★ Para começar:
  • sudo aurora install   → Instalar dependências
  • aurora list           → Ver temas disponíveis
  • aurora preview <tema> → Visualizar tema
  • sudo aurora apply <tema> → Aplicar tema
  • aurora help           → Ver todos os comandos
EOF
	)

	box_heavy "BEM-VINDO AO AURORA" "$welcome_text"
}

show_help() {
	clear
	show_banner

	local help_text
	help_text=$(
		cat <<'EOF'
🍫 Sistema de gerenciamento de temas visuais

★ COMANDOS DISPONÍVEIS:

  sudo aurora install       → Instalar dependências
                              (kmscon, starship, gum, fonts)

  aurora list               → Listar temas disponíveis

  aurora preview <tema>     → Visualizar tema temporariamente
                              (5 segundos, cores revertidas)

  sudo aurora apply <tema>  → Aplicar tema permanentemente
                              (configura kmscon e starship)

  aurora status             → Mostrar status do sistema

  aurora help               → Mostrar esta ajuda


♦ TEMAS DISPONÍVEIS:

  ganache_noir   → 🌑 Modo escuro intenso
                   Background: #0b0704 (Deep Dark)
                   Foreground: #beada2 (Roasted Almond)

  ganache_lait   → ☕ Modo padrão equilibrado
                   Background: #2a1d10 (Espresso)
                   Foreground: #ded6d1 (Milk Foam)

  ganache_blanc  → 🍦 Modo claro elegante
                   Background: #efebe8 (White Chocolate)
                   Foreground: #352514 (Coffee Bean)
EOF
	)

	box_heavy "AJUDA DO AURORA" "$help_text"
}

show_status() {
	clear
	show_banner

	local status_items=""

	# Tema atual (do estado persistente)
	local current_theme
	current_theme=$(get_current_theme)
	if [[ -n "$current_theme" ]]; then
		status_items+="$SYM_STAR Tema Atual: $current_theme"$'\n'
		status_items+=""$'\n'
	else
		status_items+="$SYM_INFO Tema Atual: Nenhum aplicado"$'\n'
		status_items+=""$'\n'
	fi

	# Verificar dependências
	if command -v gum &>/dev/null; then
		status_items+="$SYM_SUCCESS gum: Instalado"$'\n'
	else
		status_items+="$SYM_ERROR gum: Não instalado"$'\n'
	fi

	if command -v starship &>/dev/null; then
		local ver
		ver=$(starship --version 2>/dev/null | head -1 || echo "?")
		status_items+="$SYM_SUCCESS Starship: $ver"$'\n'
	else
		status_items+="$SYM_ERROR Starship: Não instalado"$'\n'
	fi

	if command -v kmscon &>/dev/null; then
		status_items+="$SYM_SUCCESS kmscon: Instalado"$'\n'
	else
		status_items+="$SYM_ERROR kmscon: Não instalado"$'\n'
	fi

	if fc-list 2>/dev/null | grep -qi "firacode.*nerd"; then
		status_items+="$SYM_SUCCESS FiraCode Nerd Font: Instalada"$'\n'
	else
		status_items+="$SYM_ERROR FiraCode Nerd Font: Não instalada"$'\n'
	fi

	# Verificar configurações
	if [[ -f "$KMSCON_CONF" ]]; then
		status_items+="$SYM_SUCCESS kmscon.conf: Configurado"$'\n'
	else
		status_items+="$SYM_WARN kmscon.conf: Não encontrado"$'\n'
	fi

	if [[ -f "$STARSHIP_CONFIG" ]]; then
		status_items+="$SYM_SUCCESS starship.toml: Configurado"$'\n'
	else
		status_items+="$SYM_WARN starship.toml: Não encontrado"$'\n'
	fi

	if [[ -d "$THEME_DIR" ]]; then
		local count
		count=$(find "$THEME_DIR" -name "*.theme" 2>/dev/null | wc -l)
		status_items+="$SYM_SUCCESS Temas: $count disponíveis"$'\n'
	else
		status_items+="$SYM_WARN Diretório de temas: Não existe"$'\n'
	fi

	# Verificar serviço systemd
	if systemctl is-enabled aurora-kmscon.service &>/dev/null; then
		status_items+="$SYM_SUCCESS Serviço Aurora: Habilitado"$'\n'
	else
		status_items+="$SYM_INFO Serviço Aurora: Não habilitado"$'\n'
	fi

	box_light "$SYM_CHOCOLATE STATUS DO SISTEMA" "$status_items"

	echo

	local quick_text
	quick_text=$(
		cat <<EOF
$SYM_ARROW_POINT COMANDOS RÁPIDOS

  $SYM_ARROW_RIGHT sudo aurora install          (instalar tudo)
  $SYM_ARROW_RIGHT aurora list                  (ver temas)
  $SYM_ARROW_RIGHT aurora preview ganache_lait  (visualizar)
  $SYM_ARROW_RIGHT sudo aurora apply ganache_lait (aplicar)
EOF
	)

	box_light "COMANDOS RÁPIDOS" "$quick_text"
}

show_theme_list() {
	clear
	show_banner

	gum style \
		--foreground "$UI_ACCENT" \
		--margin "0 2" \
		"🎨 TEMAS DISPONÍVEIS"
	echo

	if [[ ! -d "$THEME_DIR" ]]; then
		box_error "Diretório de temas não encontrado.

Execute primeiro: sudo aurora install"
		return 1
	fi

	local themes=("$THEME_DIR"/*.theme)
	local theme_count=0

	for theme_file in "${themes[@]}"; do
		if [[ -f "$theme_file" ]]; then
			local name desc bg fg accent
			name=$(basename "$theme_file" .theme)

			# Carregar informações do tema
			desc=$(grep "^THEME_DESCRIPTION=" "$theme_file" 2>/dev/null | cut -d'"' -f2 || echo "")
			bg=$(grep "^BG_COLOR=" "$theme_file" 2>/dev/null | cut -d'"' -f2 || echo "")
			fg=$(grep "^FG_COLOR=" "$theme_file" 2>/dev/null | cut -d'"' -f2 || echo "")
			accent=$(grep "^ACCENT=" "$theme_file" 2>/dev/null | cut -d'"' -f2 || echo "")

			gum style \
				--border rounded \
				--border-foreground "$accent" \
				--foreground "$UI_TEXT" \
				--width 72 \
				--margin "0 4" \
				--padding "0 2" \
				"$(gum style --bold "🍫 $name")" \
				"$desc" \
				"" \
				"BG: $bg  FG: $fg  Accent: $accent"

			echo
			((theme_count++))
		fi
	done

	if [[ $theme_count -eq 0 ]]; then
		box_warning "Nenhum tema encontrado. Execute: sudo aurora install"
	else
		gum style \
			--foreground "$UI_SUCCESS" \
			--margin "0 2" \
			"✅ $theme_count tema(s) disponível(is)"
		echo
		gum style \
			--foreground "$UI_TEXT" \
			--margin "0 2" \
			"Para visualizar: aurora preview <nome-do-tema>"
		gum style \
			--foreground "$UI_TEXT" \
			--margin "0 2" \
			"Para aplicar:    sudo aurora apply <nome-do-tema>"
	fi
}

# ============================================================================
# FUNÇÃO PRINCIPAL
# ============================================================================

main() {
	check_gum

	case "${1:-}" in
	"install")
		install_dependencies
		;;
	"apply")
		if [[ -z "${2:-}" ]]; then
			box_error "Uso: aurora apply <tema>

Exemplo: sudo aurora apply ganache_lait"
			exit 1
		fi
		apply_theme "$2"
		;;
	"preview")
		if [[ -z "${2:-}" ]]; then
			box_error "Uso: aurora preview <tema>

Exemplo: aurora preview ganache_noir"
			exit 1
		fi
		preview_theme "$2"
		;;
	"list")
		show_theme_list
		;;
	"status")
		show_status
		;;
	"apply-current")
		# Comando interno para serviço systemd
		local saved_theme
		saved_theme=$(get_current_theme)
		if [[ -n "$saved_theme" ]]; then
			apply_theme "$saved_theme"
		else
			gum style --foreground "$UI_WARNING" "Nenhum tema salvo para aplicar"
		fi
		;;
	"help" | "--help" | "-h")
		show_help
		;;
	"")
		show_welcome
		;;
	*)
		box_error "Comando desconhecido: $1"
		echo
		gum style --foreground "$UI_TEXT" "Use 'aurora help' para ver comandos disponíveis"
		exit 1
		;;
	esac
}

# ============================================================================
# EXECUÇÃO
# ============================================================================

main "$@"
