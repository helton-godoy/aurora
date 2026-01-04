#!/bin/bash
# ==============================================================================
# AURORA - Módulo de Plugins
# Gerencia a busca e instalação de temas de repositórios remotos
# ==============================================================================

[[ -z "${AURORA_REMOTE_REPO:-}" ]] && AURORA_REMOTE_REPO="https://raw.githubusercontent.com/helton-godoy/aurora/master/themes"

fetch_remote_theme() {
	local theme_name="$1"
	local target_file="$AURORA_ROOT/themes/${theme_name}.yml"

	if command -v gum &>/dev/null; then
		gum spin --spinner dot --title "Buscando tema remoto '$theme_name'..." -- sleep 1
	else
		echo "Buscando tema remoto '$theme_name'..."
	fi

	if curl -fsSL "$AURORA_REMOTE_REPO/${theme_name}.yml" -o "$target_file"; then
		echo "Tema '$theme_name' instalado com sucesso em $target_file"
	else
		echo "Erro: Não foi possível encontrar o tema '$theme_name' no repositório remoto."
		return 1
	fi
}
