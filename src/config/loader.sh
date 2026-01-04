#!/bin/bash
# ==============================================================================
# AURORA - Carregador de Módulos
# Carrega automaticamente todos os módulos do projeto
# ==============================================================================

# Carregar configurações e constantes
source "$AURORA_ROOT/src/config/constants.sh"

# Carregar módulos principais
modules_list=($AURORA_ROOT/src/modules/*.sh)
for module in "${modules_list[@]}"; do
    if [[ -r "$module" ]]; then
        source "$module"
    fi
done

# Carregar módulos core
core_list=($AURORA_ROOT/src/core/*.sh)
for module in "${core_list[@]}"; do
    if [[ -r "$module" ]]; then
        source "$module"
    fi
done
