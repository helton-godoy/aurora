#!/bin/bash
# ==============================================================================
# AURORA - Carregador de Módulos
# Suporta hierarquia de configurações: GLOBAL (/etc/aurora/) → USUÁRIO (~/.config/aurora/)
# ==============================================================================

# 1. Carregar constantes primeiro (definem caminhos base)
source "$AURORA_ROOT/src/config/constants.sh"

# 2. Carregar configurações GLOBAIS (/etc/aurora/config/)
if [[ -d "/etc/aurora/config" ]]; then
	for config in /etc/aurora/config/*.sh; do
		if [[ -r "$config" ]]; then
			source "$config"
		fi
	done
fi

# 3. Carregar configurações do USUÁRIO (~/.config/aurora/) - sobrescreve global
if [[ -d "$HOME/.config/aurora" ]]; then
	for config in "$HOME/.config/aurora"/*.sh; do
		if [[ -r "$config" ]]; then
			source "$config"
		fi
	done
fi

# 4. Carregar módulos principais
for module in "$AURORA_ROOT/src/modules"/*.sh; do
	[[ -f "$module" ]] && [[ -r "$module" ]] && source "$module"
done

# 5. Carregar módulos core
for module in "$AURORA_ROOT/src/core"/*.sh; do
	[[ -f "$module" ]] && [[ -r "$module" ]] && source "$module"
done
