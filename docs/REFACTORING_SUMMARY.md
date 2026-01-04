# Resumo de Reestruturação - Aurora v3.0

## ✅ Mudanças Implementadas

### 1. Estrutura de Diretórios (FHS + XDG)

#### Antes (duplicações)

```
aurora/
├── bin/
│   └── aurora               ← Duplicado
├── src/                     ← Duplicado
├── themes/                  ← Duplicado (1 de 4)
├── usr/
│   ├── local/
│   │   ├── bin/
│   │   │   └── aurora      ← Cópia #2
│   │   └── share/
│   │       └── aurora/
│   │           ├── bin/
│   │           │   └── aurora  ← Cópia #3
│   │           ├── src/     ← Cópia #2
│   │           └── themes/  ← Cópia #2
└── etc/
    └── aurora/
        └── themes/          ← Cópia #3 (14 temas)
```

**Problemas:**

- 56 arquivos de temas duplicados (14 × 4)
- 3 cópias do binário principal
- 3 cópias do código fonte
- Impossível manter sincronizado

#### Depois (estrutura limpa)

```
aurora/                           # Código fonte (último)
├── bin/
│   └── aurora-install          # Instalador do sistema
├── src/
│   ├── aurora.sh               # CLI principal (movido de bin/)
│   ├── config/
│   ├── core/
│   └── modules/
├── themes/                      # Temas YAML (único)
├── scripts/
│   ├── package.sh              # Script de empacotamento
│   └── setup.sh                # Script de desenvolvimento
└── aurora                       # Wrapper local
```

---

### 2. Estrutura de Instalação (FHS + XDG)

```
/usr/local/bin/aurora              → Wrapper aponta para sysroot

/usr/local/share/aurora/           → Sistema (read-only, pacote)
├── src/
│   ├── aurora.sh
│   ├── config/
│   ├── core/
│   └── modules/
└── themes/                        → 14 temas padrão

/etc/aurora/                       → Global (admin)
├── aurora.yml                     → Configurações globais
└── themes/                        → Temas do admin (opcional)

~/.config/aurora/                  → Configuração do usuário (XDG_CONFIG)
├── aurora.yml                     → Configurações pessoais
└── state.yml                      → Estado atual

~/.local/share/aurora/             → Dados do usuário (XDG_DATA)
├── themes/                        → Temas personalizados
└── backups/                       → Backups

~/.local/state/aurora/             → Estado da aplicação (XDG_STATE)
```

---

### 3. Precedência de Temas

```python
def find_theme(name):
    # 1. Temas do usuário (alta precedência)
    if exists("~/.local/share/aurora/themes/{name}.yml"):
        return USER_THEME

    # 2. Temas globais (admin)
    if exists("/etc/aurora/themes/{name}.yml"):
        return GLOBAL_THEME

    # 3. Temas do sistema (padrão, pacote)
    if exists("/usr/local/share/aurora/themes/{name}.yml"):
        return SYSTEM_THEME

    raise ThemeNotFound
```

---

### 4. Variáveis Atualizadas

#### `src/config/constants.sh`

```bash
# Sistema (FHS)
readonly AURORA_ROOT="/usr/local/share/aurora"
readonly SYSTEM_THEME_DIR="$AURORA_ROOT/themes"
readonly GLOBAL_THEME_DIR="/etc/aurora/themes"

# Usuário (XDG)
readonly XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
readonly XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
readonly XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

readonly CONFIG_DIR="$XDG_CONFIG_HOME/aurora"
readonly DATA_DIR="$XDG_DATA_HOME/aurora"
readonly USER_THEME_DIR="$DATA_DIR/themes"
readonly BACKUP_DIR="$DATA_DIR/backups"
readonly STATE_DIR="$XDG_STATE_HOME/aurora"
```

---

### 5. Funções Modificadas

#### `src/core/theme_manager.sh`

- ✅ `find_theme_file()` → Busca em 3 diretórios com precedência
- ✅ `load_theme()` → Usa `find_theme_file()`
- ✅ `list_themes()` → Lista de todos os diretórios com tags [usuário|global|sistema]
- ✅ `get_theme_info()` → Usa `find_theme_file()`

#### `src/core/plugin_manager.sh`

- ✅ `fetch_remote_theme()` → Instala em `~/.local/share/aurora/themes/`
- ✅ `remove_theme()` → Remove apenas de `~/.local/share/aurora/themes/`
- ✅ `update_themes()` → Atualiza apenas temas do usuário
- ✅ `is_theme_installed()` → Checa todos os diretórios

---

### 6. Instalador Atualizado

#### `bin/aurora-install`

```bash
# Cria estrutura completa:
/usr/local/bin/aurora                 # Wrapper
/usr/local/share/aurora/src/         # Código
/usr/local/share/aurora/themes/      # Temas padrão
/etc/aurora/aurora.yml               # Config global
/etc/aurora/themes/                  # Temas do admin (vazio)
~/.config/aurora/                    # Config usuário
~/.local/share/aurora/themes/        # Temas do usuário (vazio)
~/.local/share/aurora/backups/       # Backups (vazio)
~/.local/state/aurora/               # Estado (vazio)
```

---

### 7. Scripts de Desenvolvimento

#### `aurora` (wrapper local)

```bash
#!/bin/bash
# Aurora CLI Entry Point (Development Wrapper)
AURORA_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export AURORA_ROOT
source "$AURORA_ROOT/src/aurora.sh" && main "$@"
```

#### `scripts/package.sh`

```bash
# Cria: dist/aurora-3.0.0.tar.gz (68K)
# Exclui: .git, node_modules, logs, etc.
```

---

## 📊 Comparativo

| Aspecto               | Antes                      | Depois                       |
| --------------------- | -------------------------- | ---------------------------- |
| **Arquivos de temas** | 56 (14 × 4)                | 14                           |
| **Cópias do binário** | 3                          | 1                            |
| **Cópias do código**  | 3                          | 1                            |
| **Locais de temas**   | Confuso                    | 3 com precedência clara      |
| **Padrão FHS**        | ❌                         | ✅                           |
| **Padrão XDG**        | ❌                         | ✅                           |
| **Empacotamento**     | Manual (usr/, etc/, home/) | Simples (scripts/package.sh) |
| **Tamanho do pacote** | ~100K+                     | 68K                          |

---

## 🎯 Benefícios

### 1. Separação de Responsabilidades

- **Sistema**: `/usr/local/share/` → Pacote, imutável
- **Admin**: `/etc/aurora/` → Configurações globais
- **Usuário**: `~/.config/` e `~/.local/share/` → Personalização

### 2. Multi-tenant Friendly

- Cada usuário tem seus próprios temas
- Admin pode definir temas globais obrigatórios
- Sistema fornece temas padrão

### 3. Backup Simples

- `~/.config/aurora/` → Backup de configs
- `~/.local/share/aurora/themes/` → Backup de temas
- Não precisa backup de `/usr/local/share/`

### 4. Facilita Criação de Pacotes

- **Debian**: `dpkg` espera FHS
- **Arch**: `pacman` espera XDG
- **Snap/Flatpak**: Seguem padrões similares

---

## 🔄 Migração

### Para Desenvolvedores

```bash
# 1. Clonar o projeto
git clone https://github.com/helton-godoy/aurora.git
cd aurora

# 2. Criar wrapper local
bash scripts/setup.sh

# 3. Usar como desenvolvedor
./aurora list
./aurora preview dracula
```

### Para Usuários Finais

```bash
# 1. Descompactar
tar xzf aurora-3.0.0.tar.gz
cd aurora-3.0.0

# 2. Instalar no sistema
sudo bash bin/aurora-install

# 3. Usar
aurora list
aurora apply ganache_noir
```

### De Versões Anteriores

```bash
# A instalação nova preserva:
# - ~/.config/aurora/ (configurações)
# - ~/.local/share/aurora/themes/ (temas do usuário)

# Remove duplicações antigas:
sudo rm -rf /usr/local/share/aurora
sudo rm -rf /etc/aurora
```

---

## 📝 Conformidade com Padrões

### ✅ FHS (Filesystem Hierarchy Standard)

- `/usr/local/bin/` → Binários
- `/usr/local/share/` → Dados compartilhados
- `/etc/` → Configurações globais

### ✅ XDG Base Directory Specification

- `$XDG_CONFIG_HOME` → Configurações
- `$XDG_DATA_HOME` → Dados
- `$XDG_STATE_HOME` → Estado da aplicação

### ✅ Exemplos de Outros Projetos

| Projeto      | Estrutura                                                     |
| ------------ | ------------------------------------------------------------- |
| **Neovim**   | `/usr/share/nvim/`, `~/.config/nvim/`, `~/.local/share/nvim/` |
| **Starship** | `/usr/local/bin/starship`, `~/.config/starship.toml`          |
| **Homebrew** | `/usr/local/Homebrew/`, `/etc/homebrew/`, `~/.homebrew/`      |

---

## 🧪 Testes Realizados

```bash
# ✅ Listar temas (com tags)
./aurora list

# ✅ Preview de tema
./aurora preview dracula

# ✅ Status (mostra estrutura)
./aurora status

# ✅ Empacotamento
bash scripts/package.sh
# Criado: dist/aurora-3.0.0.tar.gz (68K)

# ✅ Descompactação e teste
cd /tmp && tar xzf aurora-3.0.0.tar.gz
```

---

## 📚 Documentação

- `docs/FILESYSTEM_STRUCTURE.md` → Explicação detalhada de FHS + XDG
- `docs/ARCHITECTURE.md` → Arquitetura geral
- `AGENTS.md` → Instruções para agentes de IA
