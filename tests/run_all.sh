#!/bin/bash
# ==============================================================================
# TEST - Runner Principal
# Executa todos os testes unitários e de integração
# ==============================================================================

set -euo pipefail

# Exportar PROJECT_ROOT
export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

print_header() {
	local title="$1"
	echo ""
	echo "═════════════════════════════════════════════════════════════"
	echo "  $title"
	echo "═════════════════════════════════════════════════════════════"
	echo ""
}

print_summary() {
	local total_passed=$1
	local total_failed=$2
	local total_tests=$((total_passed + total_failed))

	echo ""
	echo "═════════════════════════════════════════════════════════════"
	echo "  📊 RESUMO FINAL"
	echo "═════════════════════════════════════════════════════════════"
	echo ""
	echo "  Total de testes:     $total_tests"
	echo "  ✅ Passaram:        $total_passed"
	echo "  ❌ Falharam:       $total_failed"
	echo ""

	if [[ $total_failed -eq 0 ]]; then
		echo "  🎉 TODOS OS TESTES PASSARAM!"
		return 0
	else
		echo "  ⚠ ALGUNS TESTES FALHARAM"
		return 1
	fi
}

# ============================================================================
# EXECUTAR TESTES UNITÁRIOS
# ============================================================================

run_unit_tests() {
	print_header "🔬 TESTES UNITÁRIOS"

	local passed=0
	local failed=0

	for test_file in "$PROJECT_ROOT/tests/unit/"*.sh; do
		if [[ -x "$test_file" ]]; then
			local test_name
			test_name=$(basename "$test_file" .sh)

			echo "📄 Executando: $test_name"
			if bash "$test_file" 2>&1; then
				((passed++))
				echo "  ✅ $test_name passou"
			else
				((failed++))
				echo "  ❌ $test_name falhou"
			fi
			echo ""
		fi
	done

	print_summary "$passed" "$failed"
	return $failed
}

# ============================================================================
# EXECUTAR TESTES DE INTEGRAÇÃO
# ============================================================================

run_integration_tests() {
	print_header "🔗 TESTES DE INTEGRAÇÃO"

	local passed=0
	local failed=0

	for test_file in "$PROJECT_ROOT/tests/integration/"*.sh; do
		if [[ -x "$test_file" ]]; then
			local test_name
			test_name=$(basename "$test_file" .sh)

			echo "📄 Executando: $test_name"
			if bash "$test_file" 2>&1; then
				((passed++))
				echo "  ✅ $test_name passou"
			else
				((failed++))
				echo "  ❌ $test_name falhou"
			fi
			echo ""
		fi
	done

	print_summary "$passed" "$failed"
	return $failed
}

# ============================================================================
# EXECUTAR TESTES ESPECÍFICOS
# ============================================================================

run_specific_test() {
	local test_type="$1"
	local test_name="$2"

	local test_path="$PROJECT_ROOT/tests/$test_type/$test_name.sh"

	if [[ ! -f "$test_path" ]]; then
		echo "❌ Erro: Teste não encontrado: $test_path"
		return 1
	fi

	print_header "📄 EXECUTANDO: $test_name"
	bash "$test_path"
}

# ============================================================================
# FUNÇÃO PRINCIPAL
# ============================================================================

main() {
	local test_type="${1:-all}"

	case "$test_type" in
	unit | u)
		run_unit_tests
		exit $?
		;;
	integration | i)
		run_integration_tests
		exit $?
		;;
	all | a)
		local total_passed=0
		local total_failed=0

		if run_unit_tests; then
			total_passed=$((total_passed + 1))
		else
			total_failed=$((total_failed + 1))
		fi

		if run_integration_tests; then
			total_passed=$((total_passed + 1))
		else
			total_failed=$((total_failed + 1))
		fi

		print_summary "$total_passed" "$total_failed"
		exit $total_failed
		;;
	*)
		echo "❌ Erro: Tipo de teste inválido '$test_type'"
		echo ""
		echo "Uso: $0 [unit|integration|all]"
		echo ""
		echo "  unit   - Executa apenas testes unitários"
		echo "  integration - Executa apenas testes de integração"
		echo "  all    - Executa todos os testes (padrão)"
		echo ""
		echo "Ou execute um teste específico:"
		echo "  $0 unit test_ansi"
		echo "  $0 integration test_theme_loading"
		exit 1
		;;
	esac
}

main "$@"
