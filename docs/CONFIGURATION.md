# Configuração do Aurora

O Aurora é projetado para ser altamente configurável, mantendo padrões sensatos.

## Configurações Globais

A configuração global é armazenada em `~/.config/aurora/config.json`.

```json
{
  "default_shell": "zsh",
  "theme_path": "/home/user/git/aurora/themes",
  "auto_load": true,
  "plugin_enabled": true
}
```

## Definições de Temas

Os temas são definidos usando arquivos simples JSON ou YAML.

```yaml
# exemplo-tema.yaml
name: "Meia-noite"
author: "Helton"
colors:
  background: "#121212"
  foreground: "#ffffff"
  black: "#000000"
  red: "#ff5555"
  # ... e assim por diante
```

## Variáveis de Ambiente

- `AURORA_THEME`: Sobrescreve o tema atual para a sessão ativa.
- `AURORA_HOME`: Caminho para o diretório de instalação do Aurora.
