#!/bin/bash
# ==============================================================================
# AURORA - Módulo de Estado (Persistência)
# Gerencia a persistência do tema atual
# ==============================================================================

[[ -z "${STATE_FILE:-}" ]] && STATE_FILE="$HOME/.config/aurora/state.yml"

# Salvar estado atual do tema
save_state() {
	local theme_name="$1"

	# Backup antes de salvar (se existir)
	if [[ -f "$STATE_FILE" ]]; then
		backup_file "$STATE_FILE" 2>/dev/null || true
	fi

	mkdir -p "$(dirname "$STATE_FILE")"

	cat >"$STATE_FILE" <<EOF
current_theme: "$theme_name"
updated_at: "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
shell: "$SHELL"
EOF
}

# Carregar tema atual do estado
load_state() {
	if [[ -f "$STATE_FILE" ]]; then
		yq -r ".current_theme" "$STATE_FILE" 2>/dev/null || echo ""
	else
		echo ""
	fi
}

# Obter timestamp da última atualização
get_state_timestamp() {
	if [[ -f "$STATE_FILE" ]]; then
		yq -r ".updated_at" "$STATE_FILE" 2>/dev/null || echo ""
	else
		echo ""
	fi
}

# Obter shell usado quando o tema foi aplicado
get_state_shell() {
	if [[ -f "$STATE_FILE" ]]; then
		yq -r ".shell" "$STATE_FILE" 2>/dev/null || echo ""
	else
		echo ""
	fi
}
