#!/bin/bash
# ==============================================================================
# AURORA - Módulo de Estado (Persistência)
# Gerencia a persistência do tema atual
# ==============================================================================

STATE_FILE="$HOME/.config/aurora/state.yml"

save_state() {
	local theme_name="$1"
	mkdir -p "$(dirname "$STATE_FILE")"

	cat >"$STATE_FILE" <<EOF
current_theme: "$theme_name"
updated_at: "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
EOF
}

load_state() {
	if [ -f "$STATE_FILE" ]; then
		yq -r ".current_theme" "$STATE_FILE"
	else
		echo ""
	fi
}
