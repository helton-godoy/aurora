# Estrutura de Arquivos do Aurora (FHS + XDG)

## Padrões Seguidos

### FHS (Filesystem Hierarchy Standard)

Define a organização de arquivos em sistemas Unix/Linux.

### XDG Base Directory Specification

Define onde aplicações devem armazenar:

- Configurações: `$XDG_CONFIG_HOME` (~/.config/)
- Dados: `$XDG_DATA_HOME` (~/.local/share/)
- Cache: `$XDG_CACHE_HOME` (~/.cache/)
- Estado: `$XDG_STATE_HOME` (~/.local/state/)

---

## Estrutura de Instalação no Sistema

### 1. Código e Arquivos do Sistema

```shell
/usr/local/bin/aurora              → Executável (wrapper)
/usr/local/share/aurora/           → Dados compartilhados (read-only)
├── src/
│   ├── aurora.sh                  → CLI principal
│   ├── config/
│   ├── core/
│   └── modules/
└── themes/                        → Temas padrão (14 temas)
    ├── dracula.yml
    ├── ganache_*.yml
    ├── gruvbox_dark.yml
    └── ...
```

### 2. Configurações Globais (Sistema)

```
/etc/aurora/                       → Configurações do administrador
├── aurora.yml                     → Configurações globais
└── themes/                        → Temas globais (sobreposição)
```

### 3. Configurações por Usuário

```
~/.config/aurora/                  → Configurações do usuário
├── aurora.yml                     → Configurações pessoais
└── state.yml                      → Estado atual do tema (XDG_STATE seria ideal)
```

### 4. Dados por Usuário

```
~/.local/share/aurora/             → Dados pessoais (XDG_DATA)
├── themes/                        → Temas personalizados do usuário
│   └── my_theme.yml
├── backups/                       → Backups de configurações
│   └── state.20250104_143022.yml
├── current_theme.sh               → Hook Bash/Zsh
└── current_theme.fish             → Hook Fish
```

---

## Hierarquia de Precedência

### Temas (busca em ordem):

1. `~/.local/share/aurora/themes/` → Temas do usuário (mais alta)
2. `/etc/aurora/themes/` → Temas globais (adm)
3. `/usr/local/share/aurora/themes/` → Temas padrão (sistema)

### Configurações (merge):

1. `~/.config/aurora/aurora.yml` → Substitui valores globais
2. `/etc/aurora/aurora.yml` → Valores padrão do sistema

---

## Exemplos de Outros Projetos

### Homebrew (macOS/Linux)

```bash
/usr/local/bin/brew                  → Binário
/usr/local/Homebrew/                 → Código e dados
/etc/homebrew/                       → Configurações globais
~/.homebrew/                         → Dados do usuário
```

### Pacman (Arch Linux)

```bash
/usr/bin/pacman                      → Binário
/usr/share/pacman/                   → Dados compartilhados
/etc/pacman.conf                     → Configurações globais
~/.cache/pacman/                     → Cache
```

### Neovim

```bash
/usr/bin/nvim                    → Binário
/usr/share/nvim/                 → Código e plugins
/etc/xdg/nvim/                   → Configurações globais
~/.config/nvim/                  → Configurações do usuário
~/.local/share/nvim/             → Dados e plugins do usuário
~/.local/state/nvim/             → Estado (shada)
```

### Starship Prompt

```bash
/usr/local/bin/starship          → Binário
~/.config/starship.toml          → Configuração do usuário
```

---

## Benefícios desta Estrutura

### 1. Separação Clara de Responsabilidades

- **Sistema**: `/usr/local/share/` (pacote, imutável)
- **Admin**: `/etc/aurora/` (configurações globais)
- **Usuário**: `~/.config/` e `~/.local/share/` (personalização)

### 2. Facilita Criação de Pacotes

- **Debian/Ubuntu**: `dpkg`, `apt`
- **Arch Linux**: `pacman`
- **RedHat/CentOS**: `rpm`
- **Snap**: `snapcraft`
- **Flatpak**: `flatpak`

Todos esperam esta estrutura.

### 3. Multi-tenant Friendly

- Cada usuário pode ter temas personalizados
- Admin pode definir temas globais obrigatórios
- Sistema fornece temas padrão

### 4. Backup Simples

- `~/.config/aurora/` → Backup de configs
- `~/.local/share/aurora/themes/` → Backup de temas
- Não é necessário backup de `/usr/local/share/` (pacote)

---

## Configuração vs Dados

### Configuração (Settings)

O que o usuário **configura**:

- Preferências de comportamento
- Opções de ativação/desativação
- Chaves de API, tokens
- **Local**: `~/.config/aurora/`

### Dados (Data)

O que o usuário **cria** ou o sistema **gera**:

- Temas personalizados
- Backups
- Estado atual (poderia ser `~/.local/state/`)
- **Local**: `~/.local/share/aurora/`

---

## Por que não usar `/etc/aurora/themes`?

**Histórico**:

- Tradicionalmente, `/etc/` era para **configurações** (text files)
- Temas são **dados** (YAML com cores), não configurações
- Porém, muitos projetos modernos aceitam temas em `/etc/` para sobreposição global

**Solução Adotada**:

- **Temas padrão**: `/usr/local/share/aurora/themes/` (pacote)
- **Temas globais**: `/etc/aurora/themes/` (adm - opcional)
- **Temas do usuário**: `~/.local/share/aurora/themes/` (pessoal)

---

## Implementação no Aurora

### Variáveis no `constants.sh`

```bash
# Sistema
readonly AURORA_ROOT="/usr/local/share/aurora"
readonly SYSTEM_THEME_DIR="/etc/aurora/themes"

# Usuário (XDG)
readonly XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
readonly XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
readonly XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

readonly CONFIG_DIR="$XDG_CONFIG_HOME/aurora"
readonly DATA_DIR="$XDG_DATA_HOME/aurora"
readonly STATE_DIR="$XDG_STATE_HOME/aurora"

readonly STATE_FILE="$CONFIG_DIR/state.yml"  # ou "$STATE_DIR/state.yml"
readonly BACKUP_DIR="$DATA_DIR/backups"
readonly USER_THEME_DIR="$DATA_DIR/themes"
```

---

## Conclusão

Sim, esta estrutura:

1. **Segue padrões FHS + XDG** ✅
2. **Permite configurações globais e por usuário** ✅
3. **Facilita criação de pacotes** ✅
4. **É utilizada pela maioria dos projetos modernos** ✅
5. **É a melhor organização para distribuição** ✅
