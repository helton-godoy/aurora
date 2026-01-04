#!/bin/bash
# ==============================================================================
# TEST - Theme Manager Integration
# Testes de integração para carregamento e aplicação de temas
# ==============================================================================

# Carregar todos os módulos
source "$PROJECT_ROOT/src/config/loader.sh"

test_load_valid_theme() {
	echo "TEST: carregamento de tema válido"

	if load_theme "ganache_lait"; then
		echo "  ✓ Tema carregado com sucesso"
		echo "    Nome: $THEME_NAME"
		echo "    BG: $THEME_BG"
		echo "    FG: $THEME_FG"
		echo "    Accent: $THEME_ACCENT"
		return 0
	else
		echo "  ✗ Falhou ao carregar tema"
		return 1
	fi
}

test_load_invalid_theme() {
	echo "TEST: carregamento de tema inválido"

	if ! load_theme "nonexistent_theme" 2>/dev/null; then
		echo "  ✓ Tema inválido corretamente rejeitado"
		return 0
	else
		echo "  ✗ Tema inválido foi aceito (erro)"
		return 1
	fi
}

test_validate_theme() {
	echo "TEST: validação de arquivo de tema"

	local theme_file="$PROJECT_ROOT/themes/ganache_lait.yml"

	if validate_theme_file "$theme_file"; then
		echo "  ✓ Tema validado com sucesso"
		return 0
	else
		echo "  ✗ Validação falhou"
		return 1
	fi
}

test_apply_terminal() {
	echo "TEST: aplicação de tema ao terminal"

	if ! load_theme "ganache_lait"; then
		echo "  ✗ Não foi possível carregar tema"
		return 1
	fi

	if apply_theme_terminal; then
		echo "  ✓ Cores aplicadas ao terminal"

		# Resetar cores após teste
		echo -ne "\033]111\007"
		echo -ne "\033]110\007"
		echo -ne "\033[0m"

		return 0
	else
		echo "  ✗ Falhou ao aplicar cores"
		return 1
	fi
}

test_list_themes() {
	echo "TEST: listagem de temas"

	if list_themes; then
		echo "  ✓ Listagem de temas funcionou"
		return 0
	else
		echo "  ✗ Listagem falhou"
		return 1
	fi
}

# Runner
main() {
	echo "═══════════════════════════════════════════════════════════"
	echo "  TESTES DE INTEGRAÇÃO - THEME MANAGER"
	echo "═══════════════════════════════════════════════════════════"
	echo ""

	local failed=0

	test_load_valid_theme || ((failed++))
	echo ""

	test_load_invalid_theme || ((failed++))
	echo ""

	test_validate_theme || ((failed++))
	echo ""

	test_apply_terminal || ((failed++))
	echo ""

	test_list_themes || ((failed++))
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
