# Aurora - Guia do Desenvolvedor

Este guia ajuda contribuidores a entender, desenvolver e estender o Aurora.

## 🏗️ Arquitetura do Projeto

```shell
aurora/
├── bin/                           # Scripts executáveis (pontos de entrada)
│   ├── aurora                     # CLI principal
│   └── aurora-install             # Instalador de dependências
│
├── src/                           # Código fonte
│   ├── config/                    # Configurações e constantes
│   │   ├── constants.sh           # Paleta Ganache, paths, símbolos
│   │   └── loader.sh              # Carregador automático de módulos
│   ├── core/                      # Funcionalidades principais
│   │   ├── theme_manager.sh       # Carregamento/aplicação de temas
│   │   ├── kmscon_integration.sh  # Suporte específico kmscon
│   │   ├── backup_manager.sh      # Sistema de backup
│   │   └── plugin_manager.sh      # Sistema de plugins remotos
│   └── modules/                   # Módulos reutilizáveis
│       ├── ansi.sh                # Sequências ANSI
│       ├── parser.sh              # Parser YAML (via yq)
│       ├── plugins.sh             # Wrappers de plugins
│       ├── state.sh               # Persistência de estado
│       ├── ui.sh                  # Interface do usuário (gum + ANSI)
│       ├── utils.sh               # Utilitários gerais
│       └── hooks.sh               # Hooks de shell (Bash/Zsh/Fish)
│
├── themes/                        # Temas em formato YAML
│
├── tests/                         # Suite de testes
│   ├── unit/                      # Testes unitários
│   ├── integration/               # Testes de integração
│   └── fixtures/                  # Arquivos de teste
│
├── tools/                         # Ferramentas de desenvolvimento
│   └── font-install-debug.sh      # Debug de instalação de fontes
│
├── scripts/                       # Scripts de desenvolvimento
│   ├── setup.sh                   # Setup do ambiente
│   ├── git-commit-classify.sh     # Classificação de commits
│   └── release.sh                 # Gerador de releases
│
├── docs/                          # Documentação
│   ├── USER_GUIDE.md              # Guia do usuário
│   ├── THEME_FORMAT.md            # Formato de temas
│   ├── ARCHITECTURE.md            # Arquitetura
│   └── FAQ.md                     # Perguntas frequentes
│
└── etc/aurora/                    # Arquivos de instalação no sistema
    ├── config/
    │   └── default.yml            # Configurações padrão
    └── themes/                    # Temas instalados no sistema
```

## 🔨 Adicionando Novo Tema

### 1. Criar Arquivo de Tema

Crie um novo arquivo YAML em `themes/`:

```yaml
name: "Nome do Tema"
description: "Descrição curta"

colors:
  background: "#RRGGBB" # Obrigatório
  foreground: "#RRGGBB" # Obrigatório
  accent: "#RRGGBB" # Obrigatório
  warning: "#RRGGBB" # Opcional

  palette: # Obrigatório (16 cores)
    - "#000000"
    - "#FF0000"
    # ... (total de 16 cores)
```

### 2. Validar Tema

```bash
# Validar sintaxe YAML
yq . themes/meu_tema.yml

# Testar carregamento
aurora preview meu_tema
```

### 3. Testar Tema

```bash
# Aplicar tema
aurora apply meu_tema

# Verificar contraste
aurora preview meu_tema
# O validador WCAG é executado automaticamente
```

Veja [THEME_FORMAT.md](THEME_FORMAT.md) para mais detalhes.

## 🔨 Adicionando Novo Módulo

### 1. Escolher Tipo de Módulo

**Core Module** (`src/core/`)

- Funcionalidades principais do sistema
- Ex: `theme_manager.sh`, `kmscon_integration.sh`

**Module** (`src/modules/`)

- Funções reutilizáveis e utilitários
- Ex: `ansi.sh`, `parser.sh`, `utils.sh`

### 2. Estrutura do Arquivo

```bash
#!/bin/bash
# ==============================================================================
# AURORA - Módulo [Nome do Módulo]
# [Descrição breve do propósito do módulo]
# ==============================================================================

# Dependências (se necessário)
# source "$AURORA_ROOT/src/modules/outro_modulo.sh"

# ============================================================================
# FUNÇÕES PÚBLICAS
# ============================================================================

# Função principal do módulo
funcao_publica() {
    local param1="$1"
    local param2="${2:-valor_padrao}"

    # Validação de parâmetros
    if [[ -z "$param1" ]]; then
        echo "Erro: param1 é obrigatório" >&2
        return 1
    fi

    # Implementação
    # ...

    return 0
}

# ============================================================================
# FUNÇÕES PRIVADAS (opcional)
# ============================================================================

# Função auxiliar interna
_funcao_privada() {
    # ...
}

# ============================================================================
# FIM DO MÓDULO
# ============================================================================
```

### 3. Padrões de Código

#### Strict Mode

Sempre use no início do script:

```bash
set -euo pipefail
```

#### Validação de Parâmetros

```bash
funcao_exemplo() {
    local required_param="$1"
    local optional_param="${2:-padrao}"

    if [[ -z "$required_param" ]]; then
        echo "Erro: required_param é obrigatório" >&2
        return 1
    fi

    # Continuar implementação
    # ...
}
```

#### Uso de Variáveis Globais

As variáveis globais do tema (`THEME_*`) são definidas pelo `theme_manager.sh`:

```bash
funcao_exemplo() {
    # Verificar se o tema foi carregado
    if [[ -z "$THEME_NAME" ]]; then
        echo "Aviso: Tema não carregado" >&2
        return 1
    fi

    # Usar variáveis do tema
    local bg_color="$THEME_BG"
    # ...
}
```

#### Error Handling

```bash
funcao_exemplo() {
    # Tentar operação que pode falhar
    if ! comando_que_pode_falhar; then
        echo "Erro: comando falhou" >&2
        return 1
    fi

    # Retornar sucesso
    return 0
}
```

## 🧪 Rodando Testes

### Executar Todos os Testes

```bash
# Testes unitários
./tests/run_all.sh unit

# Testes de integração
./tests/run_all.sh integration

# Todos os testes
./tests/run_all.sh all
```

### Executar Teste Específico

```bash
# Teste específico
./tests/run_all.sh unit test_ansi

# Integração específica
./tests/run_all.sh integration test_theme_loading
```

### Adicionar Novos Testes

#### Teste Unitário

Crie um novo arquivo em `tests/unit/`:

```bash
#!/bin/bash
# ==============================================================================
# TEST - [Nome do Módulo]
# ==============================================================================

# Carregar módulos
source "$PROJECT_ROOT/src/config/loader.sh"

test_minha_funcao() {
    echo "TEST: descrição do teste"

    # Executar teste
    # ...

    if [[ condicao ]]; then
        echo "  ✓ Teste passou"
        return 0
    else
        echo "  ✗ Teste falhou"
        return 1
    fi
}

main() {
    echo "════════════════════════════════════════════════"
    echo "  TESTES - [Nome do Módulo]"
    echo "════════════════════════════════════════════════"
    echo ""

    local failed=0

    test_minha_funcao || ((failed++))

    echo ""
    echo "════════════════════════════════════════════════"
    if [[ $failed -eq 0 ]]; then
        echo "  ✅ TODOS OS TESTES PASSARAM"
    else
        echo "  ❌ $failed TESTE(S) FALHARAM"
    fi

    return $failed
}

export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

main "$@"
```

#### Teste de Integração

Crie um novo arquivo em `tests/integration/`:

```bash
#!/bin/bash
# ==============================================================================
# TEST - [Funcionalidade a testar]
# ==============================================================================

source "$PROJECT_ROOT/src/config/loader.sh"

test_fluxo_completo() {
    echo "TEST: descrição do fluxo completo"

    # Testar múltiplos passos
    # ...

    return 0
}

main() {
    echo "════════════════════════════════════════════════"
    echo "  TESTES DE INTEGRAÇÃO - [Nome]"
    echo "════════════════════════════════════════════════"
    echo ""

    local failed=0

    test_fluxo_completo || ((failed++))

    echo ""
    echo "════════════════════════════════════════════════"
    if [[ $failed -eq 0 ]]; then
        echo "  ✅ TODOS OS TESTES PASSARAM"
        return 0
    else
        echo "  ❌ $failed TESTE(S) FALHARAM"
        return 1
    fi
}

export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

main "$@"
```

## 🔧 Ferramentas de Desenvolvimento

### ShellCheck

Validação estática de scripts Bash:

```bash
# Instalar
sudo apt install shellcheck

# Validar todos os scripts
shellcheck src/**/*.sh bin/**/*.sh

# Validar arquivo específico
shellcheck src/modules/ansi.sh
```

### Depuração

Adicionar mensagens de debug:

```bash
debug() {
    if [[ "${AURORA_DEBUG:-}" == "1" ]]; then
        echo "DEBUG: $1" >&2
    fi
}

# Usar
debug "Informação de depuração"
```

Ativar debug:

```bash
AURORA_DEBUG=1 aurora apply tema
```

### Linting com ShellCheck

Ignorar avisos específicos quando necessário:

```bash
# shellcheck disable=SC2001
```

## 📝 Convenções de Commit

### Formato de Mensagem de Commit

Use o formato conventional commits:

```
<tipo>(escopo): <descrição>

<body opcional>
```

### Tipos

- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Mudança na documentação
- `style`: Mudança de formato (sem afetar código)
- `refactor`: Refatoração de código
- `test`: Adição de testes
- `chore`: Outras mudanças

### Exemplos

```
feat(theme): adicionar validação WCAG
fix(parser): corrigir erro de parsing YAML vazio
docs(theme): atualizar documentação de formato de tema
refactor(core): simplificar função load_theme
test(ansi): adicionar testes para sequências ANSI
chore(deps): atualizar lista de dependências
```

### Script de Classificação

O projeto inclui um script automático:

```bash
./scripts/git-commit-classify.sh
```

Este script sugere tipo e escopo automaticamente.

## 🚀 Processo de Desenvolvimento

### 1. Setup do Ambiente

```bash
# Clonar repositório
git clone https://github.com/helton-godoy/aurora.git
cd aurora

# Executar setup
./scripts/setup.sh
```

### 2. Criar Branch de Feature

```bash
git checkout -b feature/nova-funcionalidade
```

### 3. Desenvolver

- Seguir padrões de código
- Adicionar testes para novas funcionalidades
- Atualizar documentação conforme necessário

### 4. Testar

```bash
# Rodar testes
./tests/run_all.sh all

# Testar manualmente
./bin/aurora preview meu_tema
./bin/aurora apply meu_tema
```

### 5. Commit

```bash
git add .
git commit -m "feat(modulo): descrição da mudança"
```

### 6. Push e PR

```bash
git push origin feature/nova-funcionalidade
# Abrir PR no GitHub
```

## 🎯 Próximos Passos

### Roadmap do Projeto

- [ ] Suporte para terminais adicionais (Alacritty, Kitty)
- [ ] Sistema de presets de cores personalizáveis
- [ ] Interface gráfica (TUI) para seleção de temas
- [ ] Importação/exportação de configurações
- [ ] Marketplace de temas (API GitHub)
- [ ] Integração com Starship mais profunda
- [ ] Suporte para plugins locais (não apenas remotos)

## 📚 Recursos

### Documentação Interna

- [Arquitetura](ARCHITECTURE.md) - Visão geral da arquitetura
- [Formato de Tema](THEME_FORMAT.md) - Especificação de temas
- [Guia do Usuário](USER_GUIDE.md) - Documentação para usuários finais
- [FAQ](FAQ.md) - Perguntas frequentes

### Ferramentas Externas

- [yq](https://github.com/mikefarah/yq) - Parser YAML
- [gum](https://github.com/charmbracelet/gum) - CLI interativa
- [starship](https://starship.rs) - Prompt moderno
- [kmscon](https://github.com/deficient/kmscon) - Terminal headless
- [shellcheck](https://www.shellcheck.net/) - Linter Bash

### Referências

- [Bash Guide](https://www.shellcheck.net/wiki/Style)
- [YAML Spec](https://yaml.org/spec/)
- [ANSI Escape Codes](https://en.wikipedia.org/wiki/ANSI_escape_code)
- [WCAG Contrast](https://www.w3.org/WAI/WCAG21/quickref/#contrast-minimum)

## 🐛 Solução de Problemas Comuns

### Módulo Não é Carregado

**Problema:** Função não encontrada

**Solução:**

1. Verificar se o módulo está sendo carregado
2. Verificar ordem de carregamento no `loader.sh`
3. Verificar se o arquivo existe e é executável

### Variáveis do Tema Vazias

**Problema:** `THEME_BG`, `THEME_FG`, etc. estão vazias

**Solução:**

1. Chamar `load_theme()` antes de usar as variáveis
2. Verificar se o tema foi carregado com sucesso
3. Verificar se o arquivo YAML é válido

### Testes Falham

**Problema:** Testes falham no CI

**Solução:**

1. Verificar se dependências estão instaladas no ambiente de CI
2. Verificar paths relativos nos testes (`$PROJECT_ROOT`)
3. Verificar permissões de execução dos scripts de teste

### Hook de Shell Não Funciona

**Problema:** Tema não é carregado ao abrir novo terminal

**Solução:**

1. Verificar se hooks foram instalados (`aurora install-hooks`)
2. Verificar se arquivo de RC está sendo carregado pelo shell
3. Recarregar arquivo de RC (`source ~/.bashrc`)

## 📝 Licença

Este projeto é licenciado sob [MIT License](LICENSE).

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. Leia este guia completamente
2. Siga os padrões de código
3. Adicione testes para novas funcionalidades
4. Atualize a documentação
5. Use conventional commits
6. Teste suas mudanças completamente

Para questões ou sugestões, abra uma [issue](https://github.com/helton-godoy/aurora/issues).
