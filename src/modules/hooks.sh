#!/bin/bash
# ==============================================================================
# AURORA - Módulo de Hooks de Shell
# Gera e injeta configurações nos shells do usuário
# ==============================================================================

# Injeta o hook no arquivo de configuração do shell se não estiver lá
inject_hook_to_rc() {
	local rc_file="$1"
	local hook_line="[ -f \"\$HOME/.config/aurora/current_theme.sh\" ] && source \"\$HOME/.config/aurora/current_theme.sh\""

	# Sintaxe específica para Fish
	if [[ "$rc_file" == *"config.fish" ]]; then
		hook_line="if test -f \$HOME/.config/aurora/current_theme.fish; source \$HOME/.config/aurora/current_theme.fish; end"
	fi

	# Validar que o arquivo de RC existe antes de tentar injetar
	if [[ ! -f "$rc_file" ]]; then
		echo "Aviso: Arquivo de configuração $rc_file não encontrado, criando..."
		mkdir -p "$(dirname "$rc_file")"
		touch "$rc_file"
	fi

	# Verificar se hook já existe
	if ! grep -q "aurora/current_theme" "$rc_file" 2>/dev/null; then
		backup_file "$rc_file" 2>/dev/null || true
		echo -e "\n# >>> Aurora Theme Hook >>>\n$hook_line\n# <<< Aurora Theme Hook <<<" >>"$rc_file"
		echo "✅ Hook injetado em $rc_file"
	else
		echo "ℹ Hook já existe em $rc_file"
	fi
}

install_shell_hooks() {
	inject_hook_to_rc "$HOME/.bashrc"
	inject_hook_to_rc "$HOME/.zshrc"
	inject_hook_to_rc "$HOME/.config/fish/config.fish"
}

generate_starship_config() {
	local theme_name="$1"
	local config_file="$HOME/.config/aurora/starship.toml"

	cat >"$config_file" <<EOF
# Gerado dinamicamente por Aurora para o tema: $theme_name

[palettes.aurora]
background = "$THEME_BG"
foreground = "$THEME_FG"
accent = "$THEME_ACCENT"

[palette]
aurora = "aurora"

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"

[directory]
style = "bold accent"
EOF
	echo "Configuração Starship gerada em $config_file"
}

apply_shell_hooks() {
	local theme_name="$1"

	# Verificar se o tema foi carregado
	if [[ -z "$THEME_NAME" ]]; then
		echo "Aviso: Tema não carregado, tentando carregar $theme_name..."
		if ! load_theme "$theme_name"; then
			echo "Erro: Não foi possível carregar tema $theme_name"
			return 1
		fi
	fi

	local target_dir="$HOME/.config/aurora"
	mkdir -p "$target_dir"

	#1. Script para Bash/Zsh
	cat >"$target_dir/current_theme.sh" <<EOF
# Gerado por Aurora para $THEME_NAME ($theme_name)
export AURORA_THEME="$theme_name"
alias aurora-theme-apply="source $target_dir/current_theme.sh"

# Aplicar cores ANSI se for terminal Linux
if [[ "\$TERM" == "linux" ]]; then
    echo -ne "\033]11;${THEME_BG#\#}\007"
    echo -ne "\033]10;${THEME_FG#\#}\007"
fi

# Apontar para configuração Starship
export STARSHIP_CONFIG="$target_dir/starship.toml"
EOF

	#2. Script para Fish
	cat >"$target_dir/current_theme.fish" <<EOF
# Gerado por Aurora para $THEME_NAME ($theme_name)
set -gx AURORA_THEME "$theme_name"
alias aurora-theme-apply="source $target_dir/current_theme.fish"

# Aplicar cores ANSI se for terminal Linux
if test "\$TERM" = "linux"
    echo -ne "\033]11;${THEME_BG#\#}\007"
    echo -ne "\033]10;${THEME_FG#\#}\007"
end

# Apontar para configuração Starship
set -gx STARSHIP_CONFIG "$target_dir/starship.toml"
EOF

	#3. Gerar Starship dinâmico
	generate_starship_config "$theme_name"

	echo "✅ Hooks de shell configurados para: Bash, Zsh, Fish"
}
