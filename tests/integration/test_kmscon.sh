#!/bin/bash
# TEST - Kmscon Integration
source "$PROJECT_ROOT/src/config/loader.sh"

test_kmscon_detection() {
    echo "TEST: detecção de ambiente kmscon"
    local old_term="$TERM"
    export TERM="linux"
    
    if is_kmscon; then
        echo "  ✓ Ambiente kmscon detectado"
    else
        echo "  ✗ Falhou ao detectar kmscon"
        export TERM="$old_term"
        return 1
    fi
    
    export TERM="$old_term"
    return 0
}

test_rgb_conversion() {
    echo "TEST: conversão hex para formato kmscon"
    local result
    result=$(hex_to_rgb_for_kmscon "#FF0000")
    
    if [[ "$result" == "255,0,0" ]]; then
        echo "  ✓ #FF0000 → 255,0,0"
        return 0
    else
        echo "  ✗ Esperado 255,0,0, got $result"
        return 1
    fi
}

test_kmscon_config_update() {
    echo "TEST: atualização configuração kmscon"
    local test_dir="/tmp/test-kmscon-$$"
    mkdir -p "$test_dir"
    
    local test_conf="$test_dir/kmscon.conf"
    echo "# Test config" > "$test_conf"
    
    local old_conf="$KMSCON_CONF"
    export KMSCON_CONF="$test_conf"
    
    update_kmscon_config "10,20,30" "240,230,220"
    
    if grep -q "default-bg=10,20,30" "$test_conf"; then
        echo "  ✓ Background atualizado"
    else
        echo "  ✗ Background não atualizado"
        rm -rf "$test_dir"
        export KMSCON_CONF="$old_conf"
        return 1
    fi
    
    if grep -q "default-fg=240,230,220" "$test_conf"; then
        echo "  ✓ Foreground atualizado"
    else
        echo "  ✗ Foreground não atualizado"
        rm -rf "$test_dir"
        export KMSCON_CONF="$old_conf"
        return 1
    fi
    
    rm -rf "$test_dir"
    export KMSCON_CONF="$old_conf"
    return 0
}

main() {
    echo "══════════════════════════════════════════════════════"
    echo "  TESTES KMSCON INTEGRATION"
    echo "══════════════════════════════════════════════════════"
    echo ""
    
    local failed=0
    
    test_kmscon_detection || ((failed++))
    echo ""
    
    test_rgb_conversion || ((failed++))
    echo ""
    
    test_kmscon_config_update || ((failed++))
    echo ""
    
    echo "══════════════════════════════════════════════════════"
    if [[ $failed -eq 0 ]]; then
        echo "  ✅ TODOS OS TESTES PASSARAM"
        return 0
    else
        echo "  ❌ $failed TESTE(S) FALHARAM"
        return 1
    fi
}

export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd"

main "$@"
