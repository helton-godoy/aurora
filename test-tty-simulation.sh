#!/bin/bash
# ==============================================================================
# AURORA - Teste de Terminal Puro (Simulação)
# ==============================================================================

set -euo pipefail

echo "🧪 Modo de Simulação de Terminal Puro (TTY)"
echo "=========================================="
echo ""
echo "Este script simula o ambiente de um terminal TTY para testar o Aurora."
echo ""
echo "📋 Características do TTY:"
echo "   • TERM=linux (não cores 256/truecolor)"
echo "   • Sem suporte a gum (apenas ANSI básico)"
echo "   • Sem interface gráfica"
echo "   • Compatibilidade máxima"
echo ""

# Simular ambiente TTY
export TERM="linux"
echo "🔧 Variável TERM definida como: $TERM"
echo ""

# Desabilitar gum temporariamente para simulação
function gum() {
	echo "[Simulação TTY] gum seria: $@"
}

echo "🧪 Testando Aurora em modo TTY..."
echo ""

# Exportar AURORA_ROOT
export AURORA_ROOT="/usr/local/share/aurora"

# Testar comandos
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Teste 1: aurora status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash "$AURORA_ROOT/src/aurora.sh" status 2>&1 | head -40
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Teste 2: aurora list"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash "$AURORA_ROOT/src/aurora.sh" list 2>&1 | head -80
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Teste 3: Verificar variáveis de ambiente"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   TERM=$TERM"
echo "   SHELL=$SHELL"
echo "   DISPLAY=${DISPLAY:-<não definido>}"
echo "   WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-<não definido>}"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Teste 4: Capacidades do terminal"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   Cores disponíveis: $(tput colors 2>/dev/null || echo 'não determinado')"
echo "   TTY ativo: $(tty 2>/dev/null || echo 'não determinado')"
echo "   Kmscon detectado: $(command -v kmscon &>/dev/null && echo 'SIM' || echo 'NÃO')"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Teste 5: Exemplo de cores ANSI básicas"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   Texto normal"
echo -e "   \033[31mVermelho\033[0m"
echo -e "   \033[32mVerde\033[0m"
echo -e "   \033[33mAmarelo\033[0m"
echo -e "   \033[34mAzul\033[0m"
echo -e "   \033[35mMagenta\033[0m"
echo -e "   \033[36mCiano\033[0m"
echo -e "   \033[37mBranco\033[0m"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Teste concluído"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 Dicas para testar no TTY real:"
echo "   1. Use: sudo chvt 1 (para ir ao TTY1)"
echo "   2. Faça login"
echo "   3. Execute: aurora list"
echo "   4. Execute: aurora apply <tema>"
echo "   5. Execute: aurora status"
echo "   6. Para voltar: Alt+SetaEsquerda (ou sudo chvt 7)"
echo ""
