#!/bin/bash

echo "=== TESTE DE DETECÇÃO DE FONTES ==="
echo

echo "Executando: fc-list 2>/dev/null | grep -qi 'firacode.*nerd\|hack.*nerd\|source.*code.*pro.*nerd\|jetbrains.*mono.*nerd\|cascadia.*code.*nerd'"
echo

if fc-list 2>/dev/null | grep -qi "firacode.*nerd\|hack.*nerd\|source.*code.*pro.*nerd\|jetbrains.*mono.*nerd\|cascadia.*code.*nerd"; then
    echo "✅ DETECTOU FONTE NERD EXISTENTE"
    installed_font=$(fc-list 2>/dev/null | grep -i "nerd" | head -1 | cut -d: -f2 | sed 's/^ *//')
    echo "Fonte instalada: $installed_font"
else
    echo "❌ NÃO DETECTOU FONTE NERD"
fi

echo
echo "=== FONTES NERD ENCONTRADAS ==="
fc-list 2>/dev/null | grep -i "nerd" | head -5

echo
echo "=== TODAS AS FONTES ==="
fc-list 2>/dev/null | wc -l
echo "fontes totais encontradas"
