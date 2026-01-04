# Perguntas Frequentes (FAQ) do Aurora

## Perguntas Gerais

### O que é o Aurora?

O Aurora é um gerenciador de temas de terminal multi-shell que simplifica o processo de descoberta e aplicação de esquemas de cores ao ambiente do seu terminal. Suporte completo para Bash, Zsh e Fish com 14 temas integrados.

### Quais shells são suportados?

O Aurora suporta oficialmente:

- **Bash** (~/.bashrc)
- **Zsh** (~/.zshrc)
- **Fish** (~/.config/fish/config.fish)

### Funciona no Windows?

O Aurora é projetado principalmente para sistemas Unix/Linux. Funciona no WSL (Windows Subsystem for Linux) e em macOS com Bash/Zsh.

### Quantos temas estão disponíveis?

O Aurora inclui 14 temas integrados:

- **10 temas Ganache** (paleta exclusiva de tons de chocolate)
- **4 temas populares** (Dracula, Nord, Gruvbox Dark, Solarized Dark)

## Instalação e Configuração

### Como instalar o Aurora?

```bash
# Instalar dependências
sudo bash bin/aurora-install

# Usar (após instalação)
aurora list
aurora apply ganache_noir
aurora install-hooks
```

### Quais são as dependências obrigatórias?

- **yq** - Parser YAML (obrigatório)
- **bash** - Shell compatível (obrigatório)

### Quais são as dependências opcionais?

- **gum** - Interface UI interativa
- **starship** - Prompt moderno
- **kmscon** - Terminal para servidores headless

## Personalização

### Posso criar meu próprio tema?

Sim! Crie um arquivo YAML seguindo o formato definido em [THEME_FORMAT.md](THEME_FORMAT.md). Salve em `~/.local/share/aurora/themes/seu_tema.yml`.

### Como compartilho meus temas?

Você pode:

1. Contribuir para o projeto principal via Pull Request
2. Usar repositório personalizado com `AURORA_PLUGIN_REPO`
3. Distribuir arquivos YAML diretamente

### Onde ficam meus temas personalizados?

Temas personalizados são salvos em:

- `~/.local/share/aurora/themes/` (XDG Data Home)

## Aspectos Técnicos

### O Aurora deixa a inicialização do terminal lenta?

Não. O Aurora utiliza hooks leves que apenas carregam o estado atual do tema, adicionando menos de 50ms à inicialização do shell.

### Como funciona o sistema de backup?

O Aurora faz backup automático antes de qualquer modificação:

- Backups salvos em `~/.local/share/aurora/backups/`
- Máximo de 10 backups mantidos
- Restauração com `aurora backup restore <arquivo>`

### Suporte para kmscon?

Sim! O Aurora detecta automaticamente ambientes kmscon:

- Aplicação via `/etc/kmscon/kmscon.conf`
- Cores convertidas para formato kmscon
- Reinicialização: `sudo systemctl restart kmscon`

### Validação de contraste WCAG?

O Aurora valida automaticamente contraste WCAG AA (≥ 4.5:1) entre cores de background e foreground dos temas.

## Solução de Problemas

### Tema não é aplicado

1. Verifique se o tema existe: `aurora list`
2. Recarregue o shell: `source ~/.bashrc`
3. Reinstale hooks: `aurora install-hooks`
4. Para kmscon: `sudo systemctl restart kmscon`

### Erro "yq não instalado"

```bash
# Ubuntu/Debian
sudo apt install yq

# Ou via pip
pip3 install yq
```

### Erro "gum não instalado"

```bash
# Instalação automática
sudo bash bin/aurora-install

# Ou manual
sudo apt install gum
```

### Hooks não funcionam

1. Verifique se foram instalados: `aurora install-hooks`
2. Recarregue arquivo RC: `source ~/.bashrc`
3. Verifique permissões do arquivo de hook

## Performance e Recursos

### Quanto espaço ocupa?

- **Pacote completo**: ~68KB (tar.gz)
- **Instalado**: ~200KB
- **Temas**: ~50KB (14 temas)

### Uso de memória?

- **Overhead**: <1MB RAM
- **Carregamento**: <150ms até CLI pronta
- **Hook por terminal**: <50ms startup

## Estrutura de Arquivos

### Onde ficam as configurações?

- **Global**: `/etc/aurora/` (admin)
- **Usuário**: `~/.config/aurora/` (XDG Config)
- **Temas**: `~/.local/share/aurora/themes/` (XDG Data)
- **Estado**: `~/.local/state/aurora/` (XDG State)

### Posso mover o diretório de configuração?

Não é recomendado. O Aurora segue padrões XDG e detecta automaticamente as localizações corretas.
