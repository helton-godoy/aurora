# Configuração do Aurora

O Aurora é projetado para ser altamente configurável, seguindo padrões FHS + XDG.

## Estrutura de Configuração

### Configurações Globais (`/etc/aurora/aurora.yml`)

```yaml
# Configurações globais do Aurora
# Pode ser sobrescrito por ~/.config/aurora/aurora.yml

default_theme: "ganache_noir"
check_contrast: true
backup_enabled: true
auto_apply_hooks: false
```

### Configurações do Usuário (`~/.config/aurora/aurora.yml`)

```yaml
# Configurações pessoais do usuário
# Sobrescreve configurações globais

default_theme: "ganache_lait"
check_contrast: true
backup_enabled: true
auto_apply_hooks: true
```

## Estado da Aplicação

### Arquivo de Estado (`~/.config/aurora/state.yml`)

```yaml
current_theme: "ganache_lait"
updated_at: "2026-01-04T12:47:00Z"
shell: "/bin/bash"
```

## Definições de Temas

Os temas são definidos usando formato YAML. Veja [THEME_FORMAT.md](THEME_FORMAT.md) para especificação completa.

```yaml
# exemplo-tema.yaml
name: "Meu Tema Customizado"
description: "Descrição do tema personalizado"

colors:
  background: "#121212"
  foreground: "#ffffff"
  accent: "#ff5555"
  warning: "#ffff00"

  palette:
    - "#000000" # Preto
    - "#ff5555" # Vermelho
    - "#55ff55" # Verde
    # ... (16 cores total)
```

## Variáveis de Ambiente

- `AURORA_ROOT`: Caminho para o diretório raiz do Aurora
- `AURORA_THEME`: Sobrescreve o tema atual para a sessão ativa
- `AURORA_PLUGIN_REPO`: URL do repositório de temas remotos
- `AURORA_DEBUG`: Define como "1" para habilitar debug

## Diretórios de Configuração

### Sistema (Read-only)

- `/usr/local/share/aurora/` - Código e temas padrão

### Global (Admin)

- `/etc/aurora/` - Configurações globais e temas do administrador

### Usuário (XDG)

- `~/.config/aurora/` - Configurações pessoais
- `~/.local/share/aurora/themes/` - Temas personalizados
- `~/.local/share/aurora/backups/` - Backups automáticos
- `~/.local/state/aurora/` - Estado da aplicação
