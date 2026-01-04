#!/bin/bash
# ==============================================================================
# TEST - ANSI Module
# Testes unitários para módulo ANSI
# ==============================================================================

# Carregar módulo a testar
source "$PROJECT_ROOT/src/modules/ansi.sh"

test_hex_to_rgb() {
	echo "TEST: hex_to_rgb()"

	# Teste 1: Vermelho
	local result
	result=$(hex_to_rgb "#FF0000")
	if [[ "$result" == "255 0 0" ]]; then
		echo "  ✓ #FF0000 → 255 0 0"
	else
		echo "  ✗ #FF0000 → esperado 255 0 0, got $result"
		return 1
	fi

	# Teste 2: Verde
	result=$(hex_to_rgb "#00FF00")
	if [[ "$result" == "0 255 0" ]]; then
		echo "  ✓ #00FF00 → 0 255 0"
	else
		echo "  ✗ #00FF00 → esperado 0 255 0, got $result"
		return 1
	fi

	# Teste 3: Azul
	result=$(hex_to_rgb "#0000FF")
	if [[ "$result" == "0 0 255" ]]; then
		echo "  ✓ #0000FF → 0 0 255"
	else
		echo "  ✗ #0000FF → esperado 0 0 255, got $result"
		return 1
	fi

	return 0
}

test_ansi_bg() {
	echo "TEST: ansi_bg()"

	local bg_output
	bg_output=$(ansi_bg "#FF0000")

	if [[ "$bg_output" =~ $'\033[48;2;255;0;0m' ]]; then
		echo "  ✓ ansi_bg() gera sequência correta"
		return 0
	else
		echo "  ✗ ansi_bg() falhou ao gerar sequência"
		return 1
	fi
}

test_ansi_fg() {
	echo "TEST: ansi_fg()"

	local fg_output
	fg_output=$(ansi_fg "#00FF00")

	if [[ "$fg_output" =~ $'\033[38;2;0;255;0m' ]]; then
		echo "  ✓ ansi_fg() gera sequência correta"
		return 0
	else
		echo "  ✗ ansi_fg() falhou ao gerar sequência"
		return 1
	fi
}

test_ansi_reset() {
	echo "TEST: ansi_reset()"

	local reset_output
	reset_output=$(ansi_reset)

	if [[ "$reset_output" == $'\033[0m' ]]; then
		echo "  ✓ ansi_reset() gera sequência correta"
		return 0
	else
		echo "  ✗ ansi_reset() falhou ao gerar sequência"
		return 1
	fi
}

# Runner de testes
main() {
	echo "════════════════════════════════════════════════════════════"
	echo "  TESTES UNITÁRIOS - MÓDULO ANSI"
	echo "════════════════════════════════════════════════════════════"
	echo ""

	local failed=0

	test_hex_to_rgb || ((failed++))
	echo ""

	test_ansi_bg || ((failed++))
	echo ""

	test_ansi_fg || ((failed++))
	echo ""

	test_ansi_reset || ((failed++))
	echo ""

	echo "════════════════════════════════════════════════════════════"
	if [[ $failed -eq 0 ]]; then
		echo "  ✅ TODOS OS TESTES PASSARAM"
		return 0
	else
		echo "  ❌ $failed TESTE(S) FALHARAM"
		return 1
	fi
}

# Exportar PROJECT_ROOT para uso nos testes
export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

main "$@"
