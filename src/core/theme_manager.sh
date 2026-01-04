#!/bin/bash
# ==============================================================================
# AURORA - Módulo Theme Manager
# Responsável por carregar, validar e aplicar temas YAML
# ==============================================================================

# Encontrar arquivo de tema considerando precedência
# Ordem: usuário > global > sistema
find_theme_file() {
	local theme_name="$1"
	local theme_file="${theme_name}.yml"

	if [[ -f "$USER_THEME_DIR/$theme_file" ]]; then
		echo "$USER_THEME_DIR/$theme_file"
		return 0
	fi

	if [[ -f "$GLOBAL_THEME_DIR/$theme_file" ]]; then
		echo "$GLOBAL_THEME_DIR/$theme_file"
		return 0
	fi

	if [[ -f "$SYSTEM_THEME_DIR/$theme_file" ]]; then
		echo "$SYSTEM_THEME_DIR/$theme_file"
		return 0
	fi

	return 1
}

# Carregar tema YAML para variáveis globais
load_theme() {
	local theme_name="$1"
	local theme_file

	theme_file=$(find_theme_file "$theme_name")

	if [[ -z "$theme_file" ]]; then
		echo "Erro: Tema '$theme_name' não encontrado"
		echo "  Buscado em:"
		echo "    - $USER_THEME_DIR"
		echo "    - $GLOBAL_THEME_DIR"
		echo "    - $SYSTEM_THEME_DIR"
		return 1
	fi

	if ! validate_theme_file "$theme_file"; then
		return 1
	fi

	THEME_NAME=$(yq -r '.name' "$theme_file" 2>/dev/null || echo "$theme_name")
	THEME_DESCRIPTION=$(yq -r '.description' "$theme_file" 2>/dev/null || echo "Sem descrição")
	THEME_BG=$(yq -r '.colors.background' "$theme_file" 2>/dev/null)
	THEME_FG=$(yq -r '.colors.foreground' "$theme_file" 2>/dev/null)
	THEME_ACCENT=$(yq -r '.colors.accent' "$theme_file" 2>/dev/null)

	if [[ -z "$THEME_BG" ]] || [[ -z "$THEME_FG" ]] || [[ -z "$THEME_ACCENT" ]]; then
		echo "Erro: Tema '$theme_name' incompleto (falta background, foreground ou accent)"
		return 1
	fi

	export THEME_NAME THEME_DESCRIPTION THEME_BG THEME_FG THEME_ACCENT

	return 0
}

# Validar arquivo de tema YAML
validate_theme_file() {
	local theme_file="$1"

	# Verificar se yq está instalado
	if ! command -v yq &>/dev/null; then
		echo "Aviso: yq não instalado, validação limitada"
		return 0
	fi

	# Validar campos obrigatórios
	local required_fields=("name" "description" "colors.background" "colors.foreground" "colors.accent")

	for field in "${required_fields[@]}"; do
		local value
		value=$(yq -r ".$field" "$theme_file" 2>/dev/null)

		if [[ "$value" == "null" ]] || [[ -z "$value" ]]; then
			echo "Erro: Campo obrigatório '$field' ausente em $theme_file"
			return 1
		fi
	done

	# Validar formato de cores (hex #RRGGBB)
	local bg fg accent
	bg=$(yq -r '.colors.background' "$theme_file" 2>/dev/null)
	fg=$(yq -r '.colors.foreground' "$theme_file" 2>/dev/null)
	accent=$(yq -r '.colors.accent' "$theme_file" 2>/dev/null)

	for color in "$bg" "$fg" "$accent"; do
		if [[ ! "$color" =~ ^#[0-9A-Fa-f]{6}$ ]]; then
			echo "Aviso: Cor '$color' não segue formato hexadecimal #RRGGBB"
		fi
	done

	return 0
}

# Aplicar tema ao terminal atual via ANSI
apply_theme_terminal() {
	# Aplicar background
	echo -ne "\033]11;${THEME_BG#\#}\007"

	# Aplicar foreground
	echo -ne "\033]10;${THEME_FG#\#}\007"

	return 0
}

# Criar string de preview das cores do tema
create_theme_preview() {
	local bg="$1"
	local fg="$2"
	local accent="$3"

	local bg_hex="${bg#\#}"
	local fg_hex="${fg#\#}"
	local accent_hex="${accent#\#}"

	local bg_r bg_g bg_b fg_r fg_g fg_b acc_r acc_g acc_b
	bg_r="0x${bg_hex:0:2}"
	bg_g="0x${bg_hex:2:2}"
	bg_b="0x${bg_hex:4:2}"
	fg_r="0x${fg_hex:0:2}"
	fg_g="0x${fg_hex:2:2}"
	fg_b="0x${fg_hex:4:2}"
	acc_r="0x${accent_hex:0:2}"
	acc_g="0x${accent_hex:2:2}"
	acc_b="0x${accent_hex:4:2}"

	printf "\033[48;2;%d;%d;%dm▓▓▓\033[0m \033[48;2;%d;%d;%dm▓▓▓\033[0m \033[48;2;%d;%d;%dm▓▓▓\033[0m" \
		$((16#${bg_hex:0:2})) $((16#${bg_hex:2:2})) $((16#${bg_hex:4:2})) \
		$((16#${accent_hex:0:2})) $((16#${accent_hex:2:2})) $((16#${accent_hex:4:2})) \
		$((16#${fg_hex:0:2})) $((16#${fg_hex:2:2})) $((16#${fg_hex:4:2}))
}

# Listar temas disponíveis com preview inline usando gum
list_themes() {
	declare -A seen_themes

	echo ""
	gum style --foreground "#ae998b" --bold "🎨 Temas disponíveis:"
	echo ""

	list_from_dir() {
		local dir="$1"
		local tag="$2"

		if [[ ! -d "$dir" ]]; then
			return
		fi

		for theme_file in "$dir"/*.yml; do
			if [[ -f "$theme_file" ]]; then
				local theme_name
				theme_name=$(basename "$theme_file" .yml)

				if [[ -z "${seen_themes[$theme_name]:-}" ]]; then
					seen_themes["$theme_name"]=1

					local name desc bg fg accent preview

					name=$(yq -r '.name' "$theme_file" 2>/dev/null || echo "$theme_name")
					desc=$(yq -r '.description' "$theme_file" 2>/dev/null || echo "Sem descrição")
					bg=$(yq -r '.colors.background' "$theme_file" 2>/dev/null)
					fg=$(yq -r '.colors.foreground' "$theme_file" 2>/dev/null)
					accent=$(yq -r '.colors.accent' "$theme_file" 2>/dev/null)

					preview=$(create_theme_preview "$bg" "$fg" "$accent")

					gum style \
						--border rounded \
						--border-foreground "$accent" \
						--padding "0 1" \
						--margin "0 2" \
						--width 64 \
						"$(gum style --foreground "$accent" --bold "📦 $name [$tag]")" \
						"$(gum style --foreground "$fg" "$desc")" \
						"BG: $bg  FG: $fg  ACC: $accent" \
						"Preview: $preview"
					echo ""
				fi
			fi
		done
	}

	list_from_dir "$USER_THEME_DIR" "usuário"
	list_from_dir "$GLOBAL_THEME_DIR" "global"
	list_from_dir "$SYSTEM_THEME_DIR" "sistema"

	return 0
}

# Obter informações de um tema específico
get_theme_info() {
	local theme_name="$1"
	local theme_file

	theme_file=$(find_theme_file "$theme_name")

	if [[ -z "$theme_file" ]]; then
		echo ""
		return 1
	fi

	yq -r '.' "$theme_file" 2>/dev/null
	return 0
}
