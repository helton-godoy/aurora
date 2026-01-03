#!/bin/bash
# ==============================================================================
# AURORA - Módulo UI
# Componentes visuais usando gum e ANSI
# ==============================================================================

show_preview() {
	local theme_name="$1"
	load_theme "$theme_name"

	clear
	ansi_bg "$THEME_BG"
	ansi_fg "$THEME_FG"

	echo "=========================================================="
	echo "  AURORA PREVIEW: $(get_theme_val "$theme_name" "name")"
	echo "=========================================================="
	echo "  Descrição: $(get_theme_val "$theme_name" "description")"
	echo "  BG: $THEME_BG | FG: $THEME_FG | ACCENT: $THEME_ACCENT"

	# Validação WCAG no Preview
	echo -n "  Acessibilidade: "
	if check_contrast_wcag "$THEME_BG" "$THEME_FG" >/dev/null; then
		echo -e "$(ansi_fg "#00ff00")✔ WCAG PASS$(ansi_fg "$THEME_FG")"
	else
		echo -e "$(ansi_fg "#ff0000")✘ WCAG FAIL (Contraste Baixo)$(ansi_fg "$THEME_FG")"
	fi

	echo "=========================================================="
	echo -e "  $(ansi_fg "$THEME_ACCENT")TEXTO COM DESTAQUE$(ansi_fg "$THEME_FG")"
	echo "=========================================================="

	# Exibir Gradiente da Paleta
	echo -n "  Paleta: "
	local i=0
	while true; do
		local color
		color=$(get_theme_val "$theme_name" "colors.palette[$i]")
		if [ "$color" == "null" ] || [ -z "$color" ]; then break; fi
		echo -ne "$(ansi_bg "$color")  $(ansi_reset)$(ansi_bg "$THEME_BG")"
		i=$((i + 1))
		if [ $i -gt 15 ]; then break; fi
	done
	echo -e "\n=========================================================="

	ansi_reset
	echo -e "\n(Pressione qualquer tecla para sair)"
	read -n 1
}

show_theme_list() {
	clear
	gum style --foreground "#ae998b" --bold "🎨 Temas Disponíveis no Aurora"
	echo ""

	for theme_file in "$AURORA_ROOT/themes"/*.yml; do
		[ -e "$theme_file" ] || continue
		local theme_name
		theme_name=$(basename "$theme_file" .yml)

		local name desc bg fg accent
		name=$(get_theme_val "$theme_name" "name")
		desc=$(get_theme_val "$theme_name" "description")
		bg=$(get_theme_val "$theme_name" "colors.background")
		fg=$(get_theme_val "$theme_name" "colors.foreground")
		accent=$(get_theme_val "$theme_name" "colors.accent")

		# Se os valores falharem (YAML inválido ou yq erro), usa o nome do arquivo
		if [ "$name" == "null" ] || [ -z "$name" ]; then name="$theme_name"; fi

		gum style \
			--border rounded \
			--border-foreground "$accent" \
			--padding "0 1" \
			--margin "0 2" \
			--width 60 \
			"$(gum style --foreground "$accent" --bold "🍫 $name")" \
			"$(gum style --italic "$desc")" \
			"" \
			"BG: $bg  FG: $fg  ACC: $accent"
	done

	echo ""
	gum style --foreground "#ae998b" "Dica: Use 'aurora preview <nome>' para ver detalhes."
}

draw_fancy_box() {
	local title="$1"
	local content="$2"
	local width=65
	local border_color="\033[38;2;106;73;40m"
	local text_color="\033[38;2;190;173;162m"
	local reset="\033[0m"

	local inner_width=$((width - 2))
	local h_line=$(printf '%.0s─' $(seq 1 $inner_width))

	# Topo
	echo -e "${border_color}╭${h_line}╮${reset}"

	# Título Centralizado
	local title_len=${#title}
	local left_pad=$(((inner_width - title_len) / 2))
	local right_pad=$((inner_width - title_len - left_pad))
	echo -e "${border_color}│${reset}$(printf "%*s" $left_pad "")${text_color}${title}${reset}$(printf "%*s" $right_pad "")${border_color}│${reset}"

	# Separador Físico (Junction)
	echo -e "${border_color}├${h_line}┤${reset}"

	# Conteúdo com Padding
	while IFS= read -r line; do
		# Limpar escapes ANSI da linha para cálculo de largura se necessário
		local clean_line=$(echo "$line" | sed 's/\x1b\[[0-9;]*m//g')
		local line_len=${#clean_line}
		local pad=$((inner_width - 2 - line_len))
		[ $pad -lt 0 ] && pad=0
		echo -e "${border_color}│${reset}  ${text_color}${line}${reset}$(printf "%*s" $pad "")${border_color}│${reset}"
	done <<<"$(printf "%b" "$content")"

	# Base
	echo -e "${border_color}╰${h_line}╯${reset}"
}

show_status() {
	clear
	local current_theme
	current_theme=$(load_state)

	local status_text=""
	if [ -n "$current_theme" ]; then
		status_text="✅ Tema Ativo: $current_theme\n\n"
	else
		status_text="❌ Nenhum tema aplicado\n\n"
	fi

	status_text="${status_text}📦 DEPENDÊNCIAS:\n"
	status_text="${status_text}$(check_dep_status_text "gum")\n"
	status_text="${status_text}$(check_dep_status_text "yq")\n"
	status_text="${status_text}$(check_dep_status_text "starship")\n\n"

	status_text="${status_text}⚙️ CONFIGURAÇÕES:\n"
	status_text="${status_text}$([ -f "$HOME/.config/aurora/state.yml" ] && echo "  ✓ state.yml (OK)" || echo "  ⚠ state.yml (Faltante)")\n"
	status_text="${status_text}$([ -f "$HOME/.config/starship.toml" ] && echo "  ✓ starship.toml (OK)" || echo "  ⚠ starship.toml (Faltante)")"

	draw_fancy_box "📊 AURORA - STATUS DO SISTEMA" "$status_text"
}

check_dep_status_text() {
	if command -v "$1" &>/dev/null; then
		echo "  ✓ $1: Instalado"
	else
		echo "  ✗ $1: Não encontrado"
	fi
}
