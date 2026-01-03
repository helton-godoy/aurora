#!/bin/bash
# ==============================================================================
# AURORA - Módulo Parser YAML
# Interface para leitura de temas via yq (Python version)
# ==============================================================================

# Lê um valor específico do tema YAML
# Uso: get_theme_val "ganache_noir" "colors.background"
get_theme_val() {
	local theme_name="$1"
	local query="$2"
	local theme_file="$AURORA_ROOT/themes/${theme_name}.yml"

	if [ ! -f "$theme_file" ]; then
		return 1
	fi

	# Sintaxe para yq 3.x (Python-based)
	yq -r ".${query}" "$theme_file"
}

# Carrega todas as cores básicas do tema para variáveis globais
load_theme() {
	local theme_name="$1"

	THEME_BG=$(get_theme_val "$theme_name" "colors.background")
	THEME_FG=$(get_theme_val "$theme_name" "colors.foreground")
	THEME_ACCENT=$(get_theme_val "$theme_name" "colors.accent")

	export THEME_BG THEME_FG THEME_ACCENT
}
