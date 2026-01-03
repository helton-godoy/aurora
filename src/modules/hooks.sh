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

	if [ -f "$rc_file" ]; then
		if ! grep -q "aurora/current_theme" "$rc_file"; then
			backup_file "$rc_file"
			echo -e "\n# >>> Aurora Theme Hook >>>\n$hook_line\n# <<< Aurora Theme Hook <<<" >>"$rc_file"
			echo "Hook injetado em $rc_file"
		else
			echo "Hook já existe em $rc_file"
		fi
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
	load_theme "$theme_name"

	local target_dir="$HOME/.config/aurora"
	mkdir -p "$target_dir"

	# 1. Script para Bash/Zsh
	cat >"$target_dir/current_theme.sh" <<EOF
# Gerado por Aurora para $theme_name
export AURORA_THEME="$theme_name"
alias aurora-theme-apply="source $target_dir/current_theme.sh"

if [[ "\$TERM" == "linux" ]]; then
    echo -ne "\033]P0$(echo ${THEME_BG#\#})"
fi

export STARSHIP_CONFIG="$target_dir/starship.toml"
EOF

	# 2. Script para Fish
	cat >"$target_dir/current_theme.fish" <<EOF
# Gerado por Aurora para $theme_name
set -gx AURORA_THEME "$theme_name"
alias aurora-theme-apply="source $target_dir/current_theme.fish"

set -gx STARSHIP_CONFIG "$target_dir/starship.toml"
EOF

	# 3. Gerar Starship dinâmico
	generate_starship_config "$theme_name"
}
