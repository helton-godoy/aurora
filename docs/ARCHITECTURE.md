# Arquitetura do Aurora

## 📋 Visão Geral

Aurora é um gerenciador de temas visuais multi-shell escrito em Bash. Sua arquitetura é modular, separando responsabilidades em módulos especializados.

## 🏗️ Componentes Principais

```diagram
┌──────────────────────────────────────────┐
│             CLI (bin/aurora)             │
│       Pontos de entrada do usuário       │
└───────────────────┬──────────────────────┘
                    │
     ┌──────────────┼──────────────┐
     │              │              │
 ┌───▼────┐     ┌───▼─────┐    ┌───▼─────┐
 │ Config │     │  Core   │    │ Modules │
 │ Loader │────▶│ Manager │───▶│ (Utils) │
 └────────┘     └─────────┘    └─────────┘
     │              │              │
     └──────────────┼──────────────┘
                    │
           ┌────────▼────────┐
           │   Theme Files   │
           │     (YAML)      │
           └─────────────────┘
```

## 📁 Estrutura de Diretórios

### `/bin` - Scripts Executáveis

- **aurora**: CLI principal do usuário

  - Roteamento de comandos
  - Validação de dependências
  - Orquestração de operações

- **aurora-install**: Instalador de dependências
  - Instala yq, gum, starship, kmscon
  - Configura ambiente do sistema

### `/src` - Código Fonte

#### `/src/config` - Configurações

- **constants.sh**: Definições globais

  - Paleta de cores Ganache (CONSTANTE)
  - Paths do sistema
  - Símbolos UI
  - URLs de plugins

- **loader.sh**: Carregador automático de módulos
  - Carrega todos os módulos em ordem correta
  - Gerencia dependências entre módulos

#### `/src/core` - Funcionalidades Principais

- **theme_manager.sh**: Gerenciamento de temas

  - Carrega temas YAML
  - Valida estrutura de temas
  - Aplica cores ao terminal (ANSI)
  - Lista temas disponíveis

- **kmscon_integration.sh**: Suporte específico kmscon

  - Detecta ambiente kmscon
  - Aplica configurações específicas
  - Converte cores para formato kmscon

- **backup_manager.sh**: Sistema de backup

  - Backup antes de modificações
  - Limpa backups antigos (máx 10)
  - Restauração de backups

- **plugin_manager.sh**: Sistema de plugins
  - Busca temas em repositórios remotos
  - Instala/desinstala temas
  - Lista temas disponíveis

#### `/src/modules` - Módulos Reutilizáveis

- **ansi.sh**: Sequências ANSI

  - Conversão hex → RGB
  - Geração de códigos de escape
  - Reset de cores

- **parser.sh**: Parser YAML

  - Leitura de arquivos YAML via yq
  - Extração de valores específicos

- **plugins.sh**: Wrappers de plugins (legado)

  - Interface compatível com plugin_manager

- **state.sh**: Persistência de estado

  - Salva tema atual
  - Carrega tema anterior
  - Metadata de estado

- **ui.sh**: Interface do usuário

  - Funções de exibição (gum + ANSI)
  - Caixas decorativas
  - Visualização de temas

- **utils.sh**: Utilitários gerais

  - Conversão hex → RGB
  - Cálculo de luminância
  - Validação de contraste WCAG

- **hooks.sh**: Hooks de shell
  - Injeção em Bash/Zsh/Fish
  - Geração de scripts de carregamento
  - Integração com Starship

### `/themes` - Arquivos de Tema

- Formato YAML (veja [THEME_FORMAT.md](THEME_FORMAT.md))
- Temas padrão do projeto
- Usuário pode adicionar temas personalizados

### `/tests` - Suite de Testes

#### `/tests/unit` - Testes Unitários

- **test_ansi.sh**: Testa sequências ANSI
- **test_parser.sh**: Testa parser YAML

#### `/tests/integration` - Testes de Integração

- **test_font_detection.sh**: Detecção de fontes
- **test_theme_loading.sh**: Carregamento completo de temas
- **test_kmscon.sh**: Suporte kmscon

#### `/tests/fixtures` - Arquivos de Teste

Arquivos de suporte para testes (futuro)

### `/tools` - Ferramentas de Desenvolvimento

- **font-install-debug.sh**: Debug de instalação de fontes

### `/scripts` - Scripts de Desenvolvimento

- **setup.sh**: Configuração do ambiente
- **git-commit-classify.sh**: Classificação de commits
- **release.sh**: Geração de releases

### `/docs` - Documentação

- **USER_GUIDE.md**: Guia para usuários finais
- **DEVELOPER_GUIDE.md**: Guia para desenvolvedores
- **THEME_FORMAT.md**: Especificação de formato de temas
- **ARCHITECTURE.md**: Este documento
- **FAQ.md**: Perguntas frequentes

### `/etc/aurora` - Instalação no Sistema

- `/config/`: Configurações do sistema
- `/themes`: Temas instalados no sistema

## 🔄 Fluxo de Execução

### Aplicação de Tema

```
1. Usuario executa:
   aurora apply tema_x

2. CLI valida dependências

3. theme_manager carrega tema:
   → parser.sh lê YAML
   → Valida campos obrigatórios
   → Calcula contraste WCAG

4. backup_manager faz backup:
   → Backup de state.yml
   → Backup de starship.toml

5. state_manager salva novo estado:
   → Atualiza state.yml
   → Adiciona timestamp

6. kmscon_integration (se aplicável):
   → Detecta ambiente kmscon
   → Aplica configurações

7. hooks.sh instala hooks:
   → Gera scripts para Bash/Zsh/Fish
   → Injeta em arquivos RC

8. Tema aplicado com sucesso
```

### Preview de Tema

```
1. Usuario executa:
   aurora preview tema_x

2. theme_manager carrega tema

3. ansi.sh aplica cores temporárias:
   → \033]11;#RRGGBB\007 (BG)
   → \033]10;#RRGGBB\007 (FG)

4. ui.sh mostra preview
   → Cores aplicadas
   → Paleta visualizada
   → Contraste WCAG verificado

5. Apos 10s, cores resetadas
```

### Instalação de Plugin

```
1. Usuario executa:
   aurora install tema_y

2. plugin_manager busca tema:
   → Faz curl para repositório remoto
   → Baixa arquivo YAML

3. theme_manager valida tema baixado:
   → Verifica estrutura YAML
   → Valida campos obrigatórios
   → Calcula contraste WCAG

4. Tema salvo em /themes
```

## 🔌 Multi-Shell Support

Aurora suporta automaticamente três shells:

### Bash

- Hook em `~/.bashrc`
- Script de carregamento: `~/.config/aurora/current_theme.sh`
- Variável de ambiente: `$AURORA_THEME`

### Zsh

- Hook em `~/.zshrc`
- Usa mesmo script de Bash (compatível)
- Variável de ambiente: `$AURORA_THEME`

### Fish

- Hook em `~/.config/fish/config.fish`
- Script próprio: `~/.config/aurora/current_theme.fish`
- Variável universal: `$AURORA_THEME`

## 🖥️ Kmscon Integration

Suporte especial para terminais kmscon em servidores headless:

### Detecção Automática

- Verifica `$TERM == "linux"`
- Verifica variável `$KMSCON_SESSION`

### Aplicação

- Configura arquivo `/etc/kmscon/kmscon.conf`
- Formato de cores específico (comma-separated RGB)
- Suporta fontes Nerd Font

### Limitações

- kmscon não suporta TrueColor por padrão
- Cores mapeadas para paleta de 16 cores básica
- Preview ANSI pode não funcionar perfeitamente

## 🔒 Segurança

### Validação de Temas

- Campos obrigatórios verificados
- Formato de cores validado (hexadecimal)
- Contraste WCAG AA verificado (≥ 4.5:1)
- Estrutura YAML validada

### Backup Automático

- Backup antes de todas as modificações
- Limitado a 10 backups mais recentes
- Armazenado em `~/.config/aurora/backups`

### Execução Segura

- `set -euo pipefail` em todos os scripts
- Validação de parâmetros
- Tratamento de erros apropriado

## 🧩 Paleta Ganache

A paleta de cores Ganache é imutável e define a identidade visual do Aurora:

### Cores Escuras

- Caramel, Dark Caramel, Cocoa, Dark Cocoa
- Coffee, Dark Coffee, Espresso, Dark Espresso
- Bitter, Deep Dark

### Cores Claras

- Soft Brown, Roasted Almond, Cream
- Milk Foam, White Chocolate

### Constantes

Todas as cores são definidas como `readonly` e não devem ser alteradas.

Veja `src/config/constants.sh` para definição completa.

## 📦 Dependências

### Obrigatórias

- **yq**: Parser YAML (Python ou binário)
- **bash**: Shell compatível (Bash 4.0+)

### Opcionais

- **gum**: Interface UI interativa
- **starship**: Prompt moderno
- **kmscon**: Terminal headless

### Validação

O CLI verifica dependências obrigatórias ao executar e reporta erros.

## 🚀 Performance

### Carregamento de Temas

- Parser YQ: ~100-200ms por tema
- Validação: ~50-100ms por tema
- Aplicação ANSI: <10ms

### Startup

- Carregamento de todos os módulos: ~50ms
- Validação de dependências: ~20ms
- Tempo total até CLI pronta: <150ms

### Backups

- Backup de arquivo pequeno (<10KB): <100ms
- Limpeza automática (manter 10): <50ms

## 🧪 Extensibilidade

### Adicionar Novo Tema

1. Criar arquivo YAML em `themes/`
2. Seguir formato especificado em [THEME_FORMAT.md](THEME_FORMAT.md)
3. Testar com `aurora preview tema`
4. Validar contraste WCAG

### Adicionar Novo Módulo Core

1. Criar arquivo em `src/core/`
2. Seguir estrutura padrão
3. Carregado automaticamente por `loader.sh`
4. Adicionar testes em `tests/unit/` e/ou `tests/integration/`

### Adicionar Suporte a Novo Terminal

1. Criar módulo em `src/core/` (ex: `alacritty_integration.sh`)
2. Implementar funções:
   - Detectar terminal
   - Aplicar configurações específicas
   - Converter cores para formato do terminal
3. Integrar com `apply_theme_terminal()` no `theme_manager.sh`

## 🔄 Ciclo de Vida do Tema

```
┌─────────────┐
│  Download   │← aurora install tema
│   ou        │
│  Criação    │← Criar manualmente
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Validaçã o │← Verificar estrutura, cores, contraste
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Preview    │← aurora preview tema
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Aplicação  │← aurora apply tema
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Ativação   │← Hooks carregam em novo terminal
└─────────────┘
```

## 📊 Estado e Configuração

### state.yml

Localização: `~/.config/aurora/state.yml`

```yaml
current_theme: "ganache_lait"
updated_at: "2026-01-04T02:55:30Z"
shell: "/bin/bash"
```

### starship.toml

Localização: `~/.config/aurora/starship.toml`

Gerado dinamicamente com cores do tema atual.

### kmscon.conf

Localização: `/etc/kmscon/kmscon.conf`

Atualizado com cores do tema (requer root).

## 🧪 Design Decisions

### Por que Bash?

- Máxima compatibilidade (presente em todos os sistemas Unix)
- Leveza (sem dependência de runtime)
- Fácil de debugar e modificar
- Instalação simples (cp para PATH)

### Por que YAML para Temas?

- Legível por humanos
- Fácil de editar
- Estruturado
- Comum em ferramentas modernas

### Por que yq?

- Parser YAML estável e bem mantido
- Disponível como binário standalone
- Compatível com Python (pip)

### Por que Hooks em Vários Shells?

- Máxima cobertura de usuários
- Cada shell tem sua sintaxe
- Detecção automática de shell

## 🔮 Futuras Melhorias

### Curto Prazo

- [ ] Suporte para terminais adicionais (Alacritty, Kitty)
- [ ] Sistema de presets de cores personalizáveis
- [ ] Interface TUI completa para seleção de temas
- [ ] Histórico de temas aplicados

### Médio Prazo

- [ ] Marketplace de temas (GitHub API)
- [ ] Plugins locais (não apenas remotos)
- [ ] Exportação/importação de configurações
- [ ] Preview em tela separada

### Longo Prazo

- [ ] Temas dinâmicos com múltiplas variantes
- [ ] Editor de temas visual
- [ ] Integração mais profunda com Starship
- [ ] Suporte para outras ferramentas de prompt

## 📚 Referências

- [Bash Guide](https://www.gnu.org/software/bash/manual/)
- [YAML Specification](https://yaml.org/spec/)
- [ANSI Escape Codes](https://en.wikipedia.org/wiki/ANSI_escape_code)
- [WCAG Contrast](https://www.w3.org/WAI/WCAG21/quickref/#contrast-minimum)
- [Starship Prompt](https://starship.rs/)
- [kmscon Terminal](https://github.com/dvdhrm/kmscon)
