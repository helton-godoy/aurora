#!/bin/bash
# ==============================================================================
# AURORA - Módulo Utils
# Utilidades matemáticas e de sistema
# ==============================================================================

# Converte hex para decimal (R G B)
hex_to_rgb() {
	local hex="${1#\#}"
	local r=$((16#${hex:0:2}))
	local g=$((16#${hex:2:2}))
	local b=$((16#${hex:4:2}))
	echo "$r $g $b"
}

# Calcula luminância relativa (aproximada para shell)
# L = 0.2126*R + 0.7152*G + 0.0722*B
get_luminance() {
	local rgb
	rgb=$(hex_to_rgb "$1")
	read -r r g b <<<"$rgb"

	# Usando awk para precisão decimal
	awk "BEGIN { print (0.2126 * $r + 0.7152 * $g + 0.0722 * $b) / 255 }"
}

# Valida contraste WCAG AA entre duas cores (Ratio 4.5:1)
check_contrast_wcag() {
	local bg="$1"
	local fg="$2"

	local lum_bg lum_fg
	lum_bg=$(get_luminance "$bg")
	lum_fg=$(get_luminance "$fg")

	local lighter darker
	if (($(awk "BEGIN { print ($lum_bg > $lum_fg) }"))); then
		lighter=$lum_bg
		darker=$lum_fg
	else
		lighter=$lum_fg
		darker=$lum_bg
	fi

	local ratio
	ratio=$(awk "BEGIN { printf \"%.2f\", ($lighter + 0.05) / ($darker + 0.05) }")

	if (($(awk "BEGIN { print ($ratio >= 4.5) }"))); then
		echo "PASS ($ratio:1)"
		return 0
	else
		echo "FAIL ($ratio:1)"
		return 1
	fi
}

# Backup de segurança de arquivo
backup_file() {
	local file="$1"
	if [ -f "$file" ]; then
		local timestamp
		timestamp=$(date +%Y%m%d_%H%M%S)
		cp "$file" "${file}.aurora_${timestamp}.bak"
		echo "Backup criado: ${file}.aurora_${timestamp}.bak"
	fi
}
