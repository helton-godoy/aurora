#!/bin/bash
# ==============================================================================
# AURORA - Módulo ANSI
# Gerador de sequências de escape ANSI para TrueColor (24-bit)
# ==============================================================================

# Converte HEX (#RRGGBB) para RGB (R G B)
hex_to_rgb() {
	local hex="${1#\#}"
	local r=$((16#${hex:0:2}))
	local g=$((16#${hex:2:2}))
	local b=$((16#${hex:4:2}))
	echo "$r $g $b"
}

# Gera sequência ANSI para cor de fundo (Background)
ansi_bg() {
	local rgb
	rgb=$(hex_to_rgb "$1")
	read -r r g b <<<"$rgb"
	echo -ne "\033[48;2;${r};${g};${b}m"
}

# Gera sequência ANSI para cor do texto (Foreground)
ansi_fg() {
	local rgb
	rgb=$(hex_to_rgb "$1")
	read -r r g b <<<"$rgb"
	echo -ne "\033[38;2;${r};${g};${b}m"
}

# Reset ANSI
ansi_reset() {
	echo -ne "\033[0m"
}
