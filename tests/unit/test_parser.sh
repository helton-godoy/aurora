#!/bin/bash
# ==============================================================================
# TEST - Parser Module
# Testes unitários para módulo Parser YAML
# ==============================================================================

# Carregar módulo
source "$PROJECT_ROOT/src/modules/parser.sh"

test_get_theme_val() {
	echo "TEST: get_theme_val()"

	# Teste com tema existente
	local name
	name=$(get_theme_val "ganache_lait" "name")
	if [[ -n "$name" ]]; then
		echo "  ✓ get_theme_val() retorna nome de tema"
	else
		echo "  ✗ get_theme_val() falhou"
		return 1
	fi

	# Teste com campo existente
	local bg
	bg=$(get_theme_val "ganache_lait" "colors.background")
	if [[ "$bg" =~ ^#[0-9A-Fa-f]{6}$ ]]; then
		echo "  ✓ get_theme_val() retorna cor hexadecial"
	else
		echo "  ✗ get_theme_val() não retorna cor válida: $bg"
		return 1
	fi

	# Teste com tema inexistente
	local invalid
	invalid=$(get_theme_val "nonexistent_theme" "name")
	if [[ -z "$invalid" ]]; then
		echo "  ✓ get_theme_val() retorna vazio para tema inexistente"
	else
		echo "  ✗ get_theme_val() deveria retornar vazio"
		return 1
	fi

	return 0
}

test_yq_installed() {
	echo "TEST: yq instalado?"

	if command -v yq &>/dev/null; then
		local version
		version=$(yq --version 2>/dev/null | head -1)
		echo "  ✓ yq instalado ($version)"
		return 0
	else
		echo "  ✗ yq não instalado"
		echo "  ℹ Para instalar: pip3 install yq"
		return 1
	fi
}

# Runner de testes
main() {
	echo "═══════════════════════════════════════════════════════════"
	echo "  TESTES UNITÁRIOS - MÓDULO PARSER"
	echo "═══════════════════════════════════════════════════════════"
	echo ""

	local failed=0

	test_yq_installed || ((failed++))
	echo ""

	test_get_theme_val || ((failed++))
	echo ""

	echo "═══════════════════════════════════════════════════════════"
	if [[ $failed -eq 0 ]]; then
		echo "  ✅ TODOS OS TESTES PASSARAM"
		return 0
	else
		echo "  ❌ $failed TESTE(S) FALHARAM"
		return 1
	fi
}

export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

main "$@"
