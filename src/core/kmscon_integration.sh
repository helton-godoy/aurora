#!/bin/bash
# ==============================================================================
# AURORA - Módulo Kmscon Integration
# Suporte específico para terminal kmscon em servidores headless
# ==============================================================================

# Detectar se está rodando em ambiente kmscon
is_kmscon() {
	[[ "$TERM" == "linux" ]] || [[ -n "${KMSCON_SESSION:-}" ]]
}

# Aplicar tema ao kmscon (requer root)
kmscon_apply_theme() {
	# Verificar se é kmscon
	if ! is_kmscon; then
		echo "Info: Ambiente kmscon não detectado, pulando configuração kmscon"
		return 0
	fi

	# Verificar se é root
	if [[ $EUID -ne 0 ]]; then
		echo "Aviso: Kmscon requer privilégios root para configurar"
		return 1
	fi

	# Converter cores para formato kmscon
	local bg_rgb fg_rgb
	bg_rgb=$(hex_to_rgb_for_kmscon "$THEME_BG")
	fg_rgb=$(hex_to_rgb_for_kmscon "$THEME_FG")

	# Atualizar arquivo de configuração kmscon
	update_kmscon_config "$bg_rgb" "$fg_rgb"

	echo "Tema aplicado ao kmscon"

	return 0
}

# Atualizar configuração do kmscon
update_kmscon_config() {
	local bg_rgb="$1"
	local fg_rgb="$2"

	local kmscon_dir="/etc/kmscon"
	local kmscon_conf="$kmscon_dir/kmscon.conf"

	mkdir -p "$kmscon_dir"

	# Criar configuração básica se não existir
	if [[ ! -f "$kmscon_conf" ]]; then
		cat >"$kmscon_conf" <<KMSCON_EOF
# ============================================================================
# Configuração Kmscon gerada por Aurora
# ============================================================================

# Terminal
terminal-type=kmscon

# Fonte
font-name=FiraCode Nerd Font
font-size=12

# Cores
KMSCON_EOF
	fi

	# Atualizar cores de background/foreground
	if grep -q "^default-bg=" "$kmscon_conf" 2>/dev/null; then
		sed -i "s/^default-bg=.*/default-bg=$bg_rgb/" "$kmscon_conf"
	else
		echo "default-bg=$bg_rgb" >>"$kmscon_conf"
	fi

	if grep -q "^default-fg=" "$kmscon_conf" 2>/dev/null; then
		sed -i "s/^default-fg=.*/default-fg=$fg_rgb/" "$kmscon_conf"
	else
		echo "default-fg=$fg_rgb" >>"$kmscon_conf"
	fi
}

# Converter cor hex (#RRGGBB) para formato kmscon (R,G,B)
hex_to_rgb_for_kmscon() {
	local hex="$1"
	hex=${hex#\#}

	local r g b
	r=$((16#${hex:0:2}))
	g=$((16#${hex:2:2}))
	b=$((16#${hex:4:2}))

	echo "${r},${g},${b}"
}

# Reiniciar kmscon (opcional, requer root)
kmscon_restart() {
	if [[ $EUID -eq 0 ]] && command -v systemctl &>/dev/null; then
		systemctl restart kmscon.service
		echo "Kmscon reiniciado"
	else
		echo "Aviso: Não foi possível reiniciar kmscon (requer root)"
	fi
}
