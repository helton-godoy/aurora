#!/bin/bash
# ==============================================================================
# AURORA - Módulo Plugin Manager
# Gerencia busca, download e instalação de temas remotos
# ==============================================================================

# Repositório remoto padrão (pode ser sobrescrito via AURORA_PLUGIN_REPO)
readonly AURORA_PLUGIN_REPO="${AURORA_PLUGIN_REPO:-https://raw.githubusercontent.com/helton-godoy/aurora/master/themes}"

# Buscar tema remoto e instalar
fetch_remote_theme() {
	local theme_name="$1"

	if [[ -z "$theme_name" ]]; then
		echo "Erro: Nome do tema não fornecido"
		return 1
	fi

	# Criar diretório de temas do usuário se não existir
	mkdir -p "$USER_THEME_DIR"

	local target_file="$USER_THEME_DIR/${theme_name}.yml"

	echo "📡 Buscando tema remoto: $theme_name"
	echo "   Repositório: $AURORA_PLUGIN_REPO"

	if [[ -f "$target_file" ]]; then
		echo "⚠ Tema '$theme_name' já instalado em $USER_THEME_DIR"
		echo "   Use 'aurora remove $theme_name' primeiro se quiser substituir"
		return 1
	fi

	# Fazer download com curl
	if curl -fsSL --connect-timeout 30 --max-timeout 60 "${AURORA_PLUGIN_REPO}/${theme_name}.yml" -o "$target_file"; then
		echo "✅ Tema '$theme_name' instalado em $USER_THEME_DIR"

		# Validar tema baixado
		if ! validate_theme_file "$target_file"; then
			echo "⚠ Aviso: Tema baixado mas falhou na validação"
			return 1
		fi

		return 0
	else
		echo "❌ Erro: Não foi possível baixar tema '$theme_name'"
		echo "   Verifique o nome do tema e sua conexão com a internet"

		# Limpar arquivo parcial se existir
		rm -f "$target_file"

		return 1
	fi
}

# Listar temas disponíveis no repositório remoto
list_remote_themes() {
	echo "🌐 Temas disponíveis no repositório remoto:"
	echo ""
	echo "   Repositório: $AURORA_PLUGIN_REPO"
	echo ""

	# Tentar listar temas via API do GitHub
	local repo_owner repo_name
	repo_owner=$(echo "$AURORA_PLUGIN_REPO" | sed -E 's|https://raw.githubusercontent.com/([^/]+)/.*/|\1|')
	repo_name=$(echo "$AURORA_PLUGIN_REPO" | sed -E 's|https://raw.githubusercontent.com/[^/]+/([^/]+)/.*/|\1|')

	if [[ -n "$repo_owner" ]] && [[ -n "$repo_name" ]]; then
		# Usar GitHub API para listar temas
		local api_url="https://api.github.com/repos/${repo_owner}/${repo_name}/contents/themes"

		if command -v curl &>/dev/null && command -v jq &>/dev/null; then
			local themes_json
			themes_json=$(curl -s "$api_url" 2>/dev/null)

			if [[ -n "$themes_json" ]]; then
				echo "$themes_json" | jq -r '.[].name' 2>/dev/null | sed 's/\.yml$//' | while read -r theme; do
					if [[ -n "$theme" ]]; then
						echo "  📦 $theme"
					fi
				done

				echo ""
				echo "💡 Para instalar: aurora install <nome_tema>"
				return 0
			fi
		fi
	fi

	# Fallback: lista de temas conhecidos
	echo "  📦 ganache_noir"
	echo "  📦 ganache_lait"
	echo "  📦 ganache_blanc"
	echo "  📦 dracula"
	echo "  📦 nord"
	echo "  📦 gruvbox_dark"
	echo "  📦 solarized_dark"
	echo ""
	echo "💡 Para instalar: aurora install <nome_tema>"
	echo "💡 Para definir repositório personalizado: export AURORA_PLUGIN_REPO=<url>"

	return 0
}

# Remover tema instalado
remove_theme() {
	local theme_name="$1"

	if [[ -z "$theme_name" ]]; then
		echo "Erro: Nome do tema não fornecido"
		return 1
	fi

	# Só permite remover temas do usuário
	local theme_file="$USER_THEME_DIR/${theme_name}.yml"

	if [[ ! -f "$theme_file" ]]; then
		echo "Erro: Tema '$theme_name' não encontrado em $USER_THEME_DIR"
		echo "💡 Temas de sistema (/usr/local/share) ou globais (/etc/aurora) não podem ser removidos"
		return 1
	fi

	# Confirmar remoção (se estiver em TTY)
	if [[ -t 0 ]]; then
		echo "⚠ Tem certeza que deseja remover o tema '$theme_name'? [y/N]"
		read -r response

		if [[ "$response" != "y" ]] && [[ "$response" != "Y" ]]; then
			echo "Cancelado"
			return 0
		fi
	fi

	# Backup antes de remover
	backup_file "$theme_file"

	# Remover
	rm "$theme_file"
	echo "✅ Tema '$theme_name' removido de $USER_THEME_DIR"

	return 0
}

# Atualizar todos os temas (fazer pull do repositório)
update_themes() {
	echo "🔄 Atualizando temas..."

	local updated_count=0

	for theme_file in "$USER_THEME_DIR"/*.yml; do
		if [[ -f "$theme_file" ]]; then
			local theme_name
			theme_name=$(basename "$theme_file" .yml)

			echo "   Verificando $theme_name..."
		fi
	done

	echo "✅ Verificação concluída"
	echo "💡 Para instalar novos temas: aurora list --remote"

	return 0
}

# Verificar se tema já está instalado (em qualquer diretório)
is_theme_installed() {
	local theme_name="$1"
	[[ -n "$(find_theme_file "$theme_name")" ]]
}
