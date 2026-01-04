#!/bin/bash
# ==============================================================================
# AURORA - Módulo Theme Manager
# Responsável por carregar, validar e aplicar temas YAML
# ==============================================================================

# Carregar tema YAML para variáveis globais
load_theme() {
	local theme_name="$1"
	local theme_file="$THEME_DIR/${theme_name}.yml"

	# Validar existência
	if [[ ! -f "$theme_file" ]]; then
		echo "Erro: Tema '$theme_name' não encontrado em $THEME_DIR"
		return 1
	fi

	# Validar formato YAML
	if ! validate_theme_file "$theme_file"; then
		return 1
	fi

	# Carregar variáveis do tema usando yq
	THEME_NAME=$(yq -r '.name' "$theme_file" 2>/dev/null || echo "$theme_name")
	THEME_DESCRIPTION=$(yq -r '.description' "$theme_file" 2>/dev/null || echo "Sem descrição")
	THEME_BG=$(yq -r '.colors.background' "$theme_file" 2>/dev/null)
	THEME_FG=$(yq -r '.colors.foreground' "$theme_file" 2>/dev/null)
	THEME_ACCENT=$(yq -r '.colors.accent' "$theme_file" 2>/dev/null)

	# Validar cores obrigatórias
	if [[ -z "$THEME_BG" ]] || [[ -z "$THEME_FG" ]] || [[ -z "$THEME_ACCENT" ]]; then
		echo "Erro: Tema '$theme_name' incompleto (falta background, foreground ou accent)"
		return 1
	fi

	# Exportar variáveis do tema
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

# Listar temas disponíveis
list_themes() {
	if [[ ! -d "$THEME_DIR" ]]; then
		echo "Erro: Diretório de temas não encontrado: $THEME_DIR"
		return 1
	fi

	echo "🎨 Temas disponíveis:"
	echo ""

	for theme_file in "$THEME_DIR"/*.yml; do
		if [[ -f "$theme_file" ]]; then
			local theme_name
			theme_name=$(basename "$theme_file" .yml)

			local name desc
			name=$(yq -r '.name' "$theme_file" 2>/dev/null || echo "$theme_name")
			desc=$(yq -r '.description' "$theme_file" 2>/dev/null || echo "Sem descrição")

			echo "  📦 $name ($theme_name)"
			echo "     $desc"
			echo ""
		fi
	done

	return 0
}

# Obter informações de um tema específico
get_theme_info() {
	local theme_name="$1"
	local theme_file="$THEME_DIR/${theme_name}.yml"

	if [[ ! -f "$theme_file" ]]; then
		echo ""
		return 1
	fi

	yq -r '.' "$theme_file" 2>/dev/null
	return 0
}
