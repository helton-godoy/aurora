#!/bin/bash
# ==============================================================================
# AURORA - CLI Principal v3.0
# Gerenciador de Temas Visuais Multi-Shell
# ==============================================================================

set -euo pipefail

# ============================================================================
# INICIALIZAÇÃO
# ============================================================================

# Detectar root do projeto
# Prioridade: 1) Variável de ambiente, 2) Diretório do script, 3) Caminhos comuns
if [[ -n "${AURORA_ROOT:-}" ]] && [[ -f "$AURORA_ROOT/src/config/loader.sh" ]]; then
	: # AURORA_ROOT já está definido corretamente
elif [[ -f "${BASH_SOURCE[0]%/*}/../src/config/loader.sh" ]]; then
	AURORA_ROOT="$(cd "${BASH_SOURCE[0]%/*}/.." && pwd)"
elif [[ -f "/usr/local/share/aurora/src/config/loader.sh" ]]; then
	AURORA_ROOT="/usr/local/share/aurora"
elif [[ -f "$HOME/.local/share/aurora/src/config/loader.sh" ]]; then
	AURORA_ROOT="$HOME/.local/share/aurora"
else
	echo "❌ Erro: Não foi possível localizar os arquivos do Aurora" >&2
	echo "Tente definir AURORA_ROOT antes de executar" >&2
	exit 1
fi
export AURORA_ROOT

# Carregar todos os módulos
source "$AURORA_ROOT/src/config/loader.sh"

# ============================================================================
# FUNÇÕES DE VALIDAÇÃO
# ============================================================================

check_dependencies() {
	local missing_deps=()

	# Verificar dependências obrigatórias
	if ! command -v yq &>/dev/null; then
		missing_deps+=("yq (parser YAML)")
	fi

	# Verificar dependências opcionais
	if ! command -v gum &>/dev/null; then
		echo "⚠ Aviso: 'gum' não instalado - UI básica será usada"
	else
		# gum está instalado, verificar se há TTY
		if ! [[ -t 1 ]] && ! [[ -t 0 ]]; then
			echo "ℹ Modo não-interativo detectado - UI simplificada"
		fi
	fi

	if [[ ${#missing_deps[@]} -gt 0 ]]; then
		echo "❌ Erro: Dependências faltando:"
		for dep in "${missing_deps[@]}"; do
			echo "   - $dep"
		done
		echo ""
		echo "Instale com: sudo apt install yq"
		exit 1
	fi
}

# ============================================================================
# FUNÇÕES PRINCIPAIS
# ============================================================================

show_help() {
	clear
	gum style \
		--border rounded \
		--border-foreground "#6a4928" \
		--padding "1 2" \
		--width 60 \
		--align center \
		"$(gum style --foreground "#6a4928" --bold "🍫 AURORA v3.0")" \
		"Gerenciador de Temas Visuais Multi-Shell" \
		"" \
		"$(gum style --foreground "#6a4928" --bold "📚 COMANDOS DISPONÍVEIS:")" \
		"aurora list                    - Listar temas disponíveis" \
		"aurora list --remote           - Listar temas no repositório" \
		"aurora preview <tema>          - Visualizar tema temporariamente" \
		"aurora apply <tema>            - Aplicar tema permanentemente" \
		"aurora install <tema_remoto>   - Instalar tema do repositório" \
		"aurora remove <tema>           - Remover tema local" \
		"aurora install-hooks           - Instalar hooks nos shells" \
		"aurora status                  - Mostrar status do sistema" \
		"aurora backup [list|restore]   - Gerenciar backups" \
		"aurora help                    - Mostrar esta ajuda" \
		"" \
		"$(gum style --foreground "#6a4928" --bold "🔧 MULTI-SHELL SUPPORT:")" \
		"aurora suporta Bash, Zsh e Fish" \
		"" \
		"$(gum style --foreground "#6a4928" --bold "🖥 KMSCON SUPPORT:")" \
		"Suporte especial para terminais kmscon em servidores headless"
}

# Listar temas locais
cmd_list() {
	local remote_flag="${1:-}"

	if [[ "$remote_flag" == "--remote" ]]; then
		list_remote_themes
	else
		list_themes
	fi
}

# Preview de tema
cmd_preview() {
	local theme_name="${2:-}"

	if [[ -z "$theme_name" ]]; then
		echo "❌ Erro: Nome do tema não fornecido"
		echo ""
		echo "Uso: aurora preview <nome_tema>"
		exit 1
	fi

	# Carregar tema
	if ! load_theme "$theme_name"; then
		exit 1
	fi

	# Limpar tela
	clear

	# Aplicar cores ao terminal
	apply_theme_terminal

	# Mostrar preview
	echo ""
	gum style \
		--border rounded \
		--border-foreground "$THEME_ACCENT" \
		--padding "0 1" \
		--width 60 \
		"$(gum style --foreground "$THEME_ACCENT" --bold "🎨 PREVIEW: $THEME_NAME")"
	echo ""
	echo "  📝 Descrição: $THEME_DESCRIPTION"
	echo ""
	echo "  🎨 Cores:"
	echo "     Background:  $THEME_BG"
	echo "     Foreground:  $THEME_FG"
	echo "     Accent:      $THEME_ACCENT"
	echo ""
	gum style \
		--border rounded \
		--border-foreground "$THEME_ACCENT" \
		--padding "0 1" \
		--width 60 \
		"$(gum style --foreground "$THEME_ACCENT" --bold "📄 Exemplo de texto:")"
	echo ""
	echo "     Normal: Este é um texto normal"
	echo "     Destaque: Texto com $(tput setaf 3)destaque$(tput sgr0)"
	echo ""
	gum style \
		--border rounded \
		--border-foreground "$THEME_ACCENT" \
		--padding "0 1" \
		--width 60 \
		"$(gum style --foreground "$THEME_ACCENT" --bold "⏱ Preview ativo por 10 segundos... Pressione qualquer tecla para sair")"
	echo ""

	# Aguardar ou timeout
	read -t 10 -n 1 2>/dev/null || true

	# Resetar cores
	echo -ne "\033]111\007" # Reset background
	echo -ne "\033]110\007" # Reset foreground
	echo -ne "\033[0m"      # Reset all

	clear
	echo "✅ Preview finalizado"

	return 0
}

# Aplicar tema permanentemente
cmd_apply() {
	local theme_name="${2:-}"

	if [[ -z "$theme_name" ]]; then
		echo "❌ Erro: Nome do tema não fornecido"
		echo ""
		echo "Uso: aurora apply <nome_tema>"
		exit 1
	fi

	# Carregar tema
	if ! load_theme "$theme_name"; then
		exit 1
	fi

	echo "🔄 Aplicando tema: $THEME_NAME..."

	# Backup do estado atual
	backup_file "$STATE_FILE"

	# Salvar novo estado
	save_state "$theme_name"

	# Aplicar ao terminal
	apply_theme_terminal

	# Aplicar ao kmscon se disponível
	kmscon_apply_theme

	# Aplicar hooks de shell
	if [[ -f "$AURORA_ROOT/src/modules/hooks.sh" ]]; then
		install_shell_hooks
	fi

	echo ""
	echo "✅ Tema '$THEME_NAME' aplicado com sucesso!"
	echo ""
	echo "📋 Para ver as mudanças:"
	echo "   • Reinicie o terminal ou execute: source ~/.bashrc (ou ~/.zshrc)"
	echo "   • Se estiver usando kmscon, reinicie o serviço: sudo systemctl restart kmscon"

	return 0
}

# Instalar tema remoto
cmd_install() {
	local theme_name="${2:-}"

	if [[ -z "$theme_name" ]]; then
		echo "❌ Erro: Nome do tema não fornecido"
		echo ""
		echo "Uso: aurora install <nome_tema>"
		echo ""
		echo "💡 Veja temas disponíveis com: aurora list --remote"
		exit 1
	fi

	if ! fetch_remote_theme "$theme_name"; then
		exit 1
	fi
}

# Remover tema local
cmd_remove() {
	local theme_name="${2:-}"

	if [[ -z "$theme_name" ]]; then
		echo "❌ Erro: Nome do tema não fornecido"
		echo ""
		echo "Uso: aurora remove <nome_tema>"
		echo ""
		echo "💡 Veja temas instalados com: aurora list"
		exit 1
	fi

	if ! remove_theme "$theme_name"; then
		exit 1
	fi
}

# Instalar hooks de shell
cmd_install_hooks() {
	if [[ -f "$AURORA_ROOT/src/modules/hooks.sh" ]]; then
		install_shell_hooks
		echo "✅ Hooks instalados!"
	else
		echo "❌ Erro: Módulo hooks.sh não encontrado"
		exit 1
	fi
}

# Mostrar status
cmd_status() {
	clear

	# Tema atual
	local current_theme
	current_theme=$(load_state)

	local theme_status=""
	if [[ -n "$current_theme" ]]; then
		theme_status="🎨 Tema Ativo: $current_theme"
	else
		theme_status="⚠ Nenhum tema aplicado"
	fi

	# Dependências
	local deps_status=""
	deps_status+="📦 Dependências:\n"
	if command -v yq &>/dev/null; then
		deps_status+="   ✓ yq instalado\n"
	else
		deps_status+="   ✗ yq não instalado\n"
	fi

	if command -v gum &>/dev/null; then
		deps_status+="   ✓ gum instalado\n"
	else
		deps_status+="   ⚠ gum não instalado (opcional)\n"
	fi

	if command -v starship &>/dev/null; then
		local starship_ver
		starship_ver=$(starship --version 2>/dev/null | head -1)
		deps_status+="   ✓ starship instalado ($starship_ver)\n"
	else
		deps_status+="   ⚠ starship não instalado (opcional)\n"
	fi

	# Ambiente
	local env_status=""
	env_status+="🖥 Ambiente:\n"
	if is_kmscon; then
		env_status+="   ✓ Kmscon detectado\n"
	else
		env_status+="   ℹ Terminal padrão (não-kmscon)\n"
	fi
	env_status+="   Shell: $SHELL\n"

	# Diretórios
	local dirs_status=""
	dirs_status+="📁 Diretórios:\n"
	dirs_status+="   Sistema:  $SYSTEM_THEME_DIR\n"
	dirs_status+="   Global:   $GLOBAL_THEME_DIR\n"
	dirs_status+="   Usuário:  $USER_THEME_DIR\n"
	dirs_status+="   Config:   $CONFIG_DIR"

	gum style \
		--border rounded \
		--border-foreground "#6a4928" \
		--padding "1 2" \
		--width 60 \
		"$(gum style --foreground "#6a4928" --bold "📊 STATUS DO AURORA")" \
		"$theme_status" \
		"" \
		"$deps_status" \
		"" \
		"$env_status" \
		"" \
		"$dirs_status"
}

# Gerenciar backups
cmd_backup() {
	local action="${2:-list}"

	case "$action" in
	list)
		list_backups
		;;
	restore)
		local backup_file="${3:-}"

		if [[ -z "$backup_file" ]]; then
			echo "❌ Erro: Arquivo de backup não especificado"
			echo ""
			echo "Uso: aurora backup restore <arquivo_backup>"
			echo ""
			echo "💡 Veja backups disponíveis com: aurora backup list"
			exit 1
		fi

		restore_backup "$backup_file" "$STATE_FILE"
		;;
	*)
		echo "❌ Erro: Ação inválida '$action'"
		echo ""
		echo "Uso: aurora backup [list|restore]"
		echo ""
		echo "  list    - Listar backups disponíveis"
		echo "  restore - Restaurar backup específico"
		exit 1
		;;
	esac
}

# ============================================================================
# FUNÇÃO PRINCIPAL
# ============================================================================

main() {
	# Verificar dependências
	check_dependencies

	# Roteamento de comandos
	case "${1:-help}" in
	list)
		cmd_list "${2:-}"
		;;
	preview)
		cmd_preview "$@"
		;;
	apply)
		cmd_apply "$@"
		;;
	install)
		cmd_install "$@"
		;;
	remove)
		cmd_remove "$@"
		;;
	install-hooks)
		cmd_install_hooks
		;;
	status)
		cmd_status
		;;
	backup)
		cmd_backup "$@"
		;;
	help | --help | -h)
		show_help
		;;
	*)
		echo "❌ Erro: Comando desconhecido '$1'"
		echo ""
		echo "💡 Use 'aurora help' para ver comandos disponíveis"
		exit 1
		;;
	esac
}

# Executar
main "$@"
