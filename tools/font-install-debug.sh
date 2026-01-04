#!/bin/bash

echo "=== DEBUG INSTALAÇÃO DE FONTES ==="
echo

# Simular a lógica do script
echo "1. Verificando se já existem fontes Nerd..."
echo "Comando: fc-list 2>/dev/null | grep -qi 'firacode.*nerd\|hack.*nerd\|source.*code.*pro.*nerd\|jetbrains.*mono.*nerd\|cascadia.*code.*nerd'"
echo

if fc-list 2>/dev/null | grep -qi "firacode.*nerd\|hack.*nerd\|source.*code.*pro.*nerd\|jetbrains.*mono.*nerd\|cascadia.*code.*nerd"; then
	echo "✅ DETECTOU - Deveria pular instalação"
	installed_font=$(fc-list 2>/dev/null | grep -i "nerd" | head -1 | cut -d: -f2 | sed 's/^ *//')
	echo "Fonte encontrada: $installed_font"
else
	echo "❌ NÃO DETECTOU - Vai tentar instalar"
fi

echo
echo "2. Testando padrões individuais:"

patterns=("firacode.*nerd" "hack.*nerd" "jetbrains.*mono.*nerd" "cascadia.*code.*nerd")
for pattern in "${patterns[@]}"; do
	echo "Testando '$pattern':"
	if fc-list 2>/dev/null | grep -qi "$pattern"; then
		echo "  ✅ Encontrado"
		fc-list 2>/dev/null | grep -i "$pattern" | head -1
	else
		echo "  ❌ Não encontrado"
	fi
	echo
done

echo "3. Fontes Nerd disponíveis:"
fc-list 2>/dev/null | grep -i nerd | head -5
