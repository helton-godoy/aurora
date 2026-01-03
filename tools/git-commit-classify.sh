#!/bin/bash

# ==============================================================================
# GitCom-Analyzer (v3.3 - Security Guard)
# Autor: Helton Carlos Lima Godoy (UISTI/HUJM)
# Descrição: Analisa git, protege segredos, gerencia staging e gera prompt IA.
# ==============================================================================

set -euo pipefail

# --- Variáveis ---
DIFF_CHAR_LIMIT=4000
LANGUAGE="pt-br"
SENSITIVE_PATTERNS='(\.env|\.key|\.pem|_rsa|id_rsa|\.crt|\.p12|\.kdbx|password|secret|credential|\.aws\/credentials)'

# --- Cores ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Funções de Segurança ---

check_sensitive_files() {
	# 1. Verificação de Perigo Imediato (Arquivos Staged)
	local staged_sensitive
	staged_sensitive=$(git diff --cached --name-only | grep -E "$SENSITIVE_PATTERNS" || true)

	if [ -n "$staged_sensitive" ]; then
		echo -e "${RED}[PERIGO]${NC} Arquivos sensíveis detectados no Staging:" >&2
		echo "$staged_sensitive" >&2
		echo "" >&2
		echo -e "${YELLOW}Estes arquivos seriam enviados para a IA e gravados no histórico do Git.${NC}" >&2
		echo -n "Deseja removê-los do stage imediatamente? [S/n] " >&2
		read -r response </dev/tty

		if [[ "$response" =~ ^([nN][oO]|[nN])$ ]]; then
			echo -e "${RED}[ABORTADO]${NC} Operação cancelada por segurança. Remova os arquivos manualmente se desejar prosseguir." >&2
			exit 1
		else
			echo "$staged_sensitive" | xargs git restore --staged
			echo -e "${GREEN}[SUCESSO]${NC} Arquivos removidos do stage. O commit foi bloqueado." >&2
			exit 1
		fi
	fi

	# 2. Verificação de Higiene (Arquivos Untracked não ignorados)
	# Lista arquivos não rastreados que não estão no .gitignore
	local untracked_sensitive
	untracked_sensitive=$(git ls-files --others --exclude-standard | grep -E "$SENSITIVE_PATTERNS" || true)

	if [ -n "$untracked_sensitive" ]; then
		echo -e "${YELLOW}[SEGURANÇA]${NC} Encontrei arquivos sensíveis que não estão no .gitignore:" >&2
		echo "$untracked_sensitive" >&2
		echo "" >&2
		echo -n "Deseja adicionar estes arquivos ao .gitignore agora? [Y/n] " >&2
		read -r response </dev/tty

		if [[ ! "$response" =~ ^([nN][oO]|[nN])$ ]]; then
			for file in $untracked_sensitive; do
				echo "$file" >>.gitignore
				echo "Adicionado $file ao .gitignore" >&2
			done
			echo -e "${GREEN}[SUCESSO]${NC} Arquivos protegidos." >&2
		fi
	fi
}

# --- Funções de Análise ---

detect_file_category() {
	local filename="$1"
	if [[ "$filename" =~ (\.github\/workflows|\.gitlab-ci\.yml|jenkinsfile|\.circleci|azure-pipelines) ]]; then
		echo "ci"
		return
	fi
	if [[ "$filename" =~ (package\.json|package-lock\.json|yarn\.lock|requirements\.txt|pom\.xml|build\.gradle|go\.mod|dockerfile|makefile) ]]; then
		echo "build"
		return
	fi
	if [[ "$filename" =~ \.(md|txt|doc|docx)$ ]]; then
		echo "docs"
		return
	fi
	if [[ "$filename" =~ (test|spec)\. ]]; then
		echo "test"
		return
	fi
	if [[ "$filename" =~ \.(json|yaml|yml|conf|config|ini|\.gitignore|\.env.*)$ ]]; then
		echo "chore"
		return
	fi
	if [[ "$filename" =~ \.(css|scss|less|sass|styl)$ ]]; then
		echo "style"
		return
	fi
	echo "code"
}

detect_scope() {
	local filepath="$1"
	local dir=$(dirname "$filepath")
	if [ "$dir" == "." ]; then echo "root"; else echo "$dir" | sed -E 's/.*(src|lib|pkg|app|internal)\///' | awk -F/ '{print $1}'; fi
}

smart_staging_check() {
	if ! git diff --cached --quiet; then return 0; fi

	local unstaged_files
	unstaged_files=$(git diff --name-only)

	if [ -z "$unstaged_files" ]; then
		echo -e "${RED}[ERRO]${NC} Não há alterações para commitar." >&2
		exit 0
	fi

	echo -e "${YELLOW}[AVISO]${NC} Stage vazio. Encontrei modificações:" >&2
	echo -e "${BLUE}$unstaged_files${NC}" >&2
	echo -e -n "Adicionar arquivos rastreados (git add -u)? [s/N] " >&2
	read -r response </dev/tty

	if [[ "$response" =~ ^([sS][iI]|[sS])$ ]]; then
		git add -u
		echo -e "${GREEN}[SUCESSO]${NC} Stage atualizado." >&2
	else
		echo -e "${RED}[CANCELADO]${NC}" >&2
		exit 1
	fi
}

analyze_changes() {
	local files=$(git diff --cached --name-only)
	local has_code=false
	local has_test=false
	local has_docs=false
	local has_ci=false
	local has_build=false
	local has_chore=false
	local has_style=false
	local scopes=()

	for file in $files; do
		local cat=$(detect_file_category "$file")
		local scope=$(detect_scope "$file")
		[[ "$cat" == "code" ]] && has_code=true
		[[ "$cat" == "test" ]] && has_test=true
		[[ "$cat" == "docs" ]] && has_docs=true
		[[ "$cat" == "ci" ]] && has_ci=true
		[[ "$cat" == "build" ]] && has_build=true
		[[ "$cat" == "chore" ]] && has_chore=true
		[[ "$cat" == "style" ]] && has_style=true
		if [ "$scope" != "root" ] && [ "$scope" != "." ]; then scopes+=("$scope"); fi
	done

	local detected_type="chore"
	if $has_code; then
		local new_files=$(git diff --cached --diff-filter=A --name-only | wc -l)
		local fix_keywords=$(git diff --cached | grep -iE "fix|bug|resolve|error|erro|falha|correção" | wc -l)
		if [ "$new_files" -gt 0 ]; then
			detected_type="feat"
		elif [ "$fix_keywords" -gt 0 ]; then
			detected_type="fix"
		else detected_type="refactor"; fi
	elif $has_ci; then
		detected_type="ci"
	elif $has_build; then
		detected_type="build"
	elif $has_chore; then
		detected_type="chore"
	elif $has_test; then
		detected_type="test"
	elif $has_docs; then
		detected_type="docs"
	elif $has_style; then
		detected_type="style"
	fi

	local detected_scope=""
	if [ ${#scopes[@]} -gt 0 ]; then
		detected_scope=$(echo "${scopes[@]}" | tr ' ' '\n' | sort | uniq -c | sort -nr | head -n1 | awk '{print $2}')
	fi

	echo "TYPE_SUGGESTION=$detected_type"
	echo "SCOPE_SUGGESTION=$detected_scope"
}

# --- Main ---

main() {
	if ! git rev-parse --is-inside-work-tree &>/dev/null; then
		echo -e "${RED}[ERRO]${NC} Não é um repositório git." >&2
		exit 1
	fi

	# 1. Guardião de Segurança (Executa antes de tudo)
	check_sensitive_files

	# 2. Gestão de Staging
	smart_staging_check

	# 3. Re-checagem de Segurança (caso o smart_staging tenha adicionado algo novo)
	check_sensitive_files

	local staged_files=$(git diff --cached --name-only)
	local analysis=$(analyze_changes)
	local suggested_type=$(echo "$analysis" | grep TYPE_SUGGESTION | cut -d= -f2)
	local suggested_scope=$(echo "$analysis" | grep SCOPE_SUGGESTION | cut -d= -f2)
	local diff_content=$(git diff --cached | head -c "$DIFF_CHAR_LIMIT")

	cat <<EOF
--- INSTRUÇÕES DO SISTEMA ---
Atue como um Especialista em DevOps e Conventional Commits.
Idioma: $LANGUAGE.

Parâmetros detectados:
* Tipo: ${suggested_type^^}
* Escopo: ${suggested_scope:-"global/indefinido"}

Tarefa:
Gere APENAS a mensagem de commit (sem aspas/markdown):
<tipo>(${suggested_scope:-<escopo>}): <descrição>

--- CONTEXTO ---
Arquivos:
$staged_files

Diff:
$diff_content
EOF
}

main "$@"
