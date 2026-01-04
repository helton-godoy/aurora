# Aurora - Guia do Usuário

Aurora é um gerenciador de temas visuais multi-shell que permite personalizar seu terminal com facilidade.

## 📦 Instalação

### Requisitos

- Sistema Linux baseado em Debian (Debian, Ubuntu, etc.)
- Bash ou shell compatível
- Conexão com internet (para plugins remotos)

### Instalação Automática

```bash
# Clonar repositório
git clone https://github.com/helton-godoy/aurora.git
cd aurora

# Executar instalador
sudo ./bin/aurora-install
```

O instalador irá:

1. Atualizar repositórios do sistema
2. Instalar yq (parser YAML)
3. Instalar gum (interface interativa)
4. Instalar Starship (prompt moderno)
5. Instalar kmscon (terminal para headless)
6. Baixar e configurar FiraCode Nerd Font

### Instalação Manual

Se preferir instalar manualmente:

```bash
# 1. yq (parser YAML)
pip3 install yq
# ou baixar binário: https://github.com/mikefarah/yq/releases

# 2. gum (interface UI)
mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt-get update
sudo apt-get install gum

# 3. Starship
curl -fsSL https://starship.rs/install.sh | sh -s -- --bin-dir /usr/local/bin -y

# 4. kmscon (opcional, para headless)
sudo apt-get install kmscon

# 5. Copiar Aurora para PATH
sudo cp bin/aurora /usr/local/bin/
```

## 🎨 Uso Básico

### Listar Temas Disponíveis

```bash
aurora list
```

Lista todos os temas instalados localmente.

### Listar Temas Remotos

```bash
aurora list --remote
```

Mostra temas disponíveis no repositório oficial.

### Preview de Tema

Visualize um tema antes de aplicar permanentemente:

```bash
aurora preview ganache_lait
```

O preview aplica o tema temporariamente por 10 segundos, depois reverte para as cores originais.

### Aplicar Tema

Aplique um tema permanentemente:

```bash
aurora apply ganache_lait
```

Isto irá:

- Salvar o tema como sua escolha
- Aplicar cores ao terminal atual
- Configurar kmscon (se disponível)
- Instalar hooks nos shells (Bash, Zsh, Fish)
- Gerar configuração dinâmica do Starship

### Instalar Tema Remoto

```bash
aurora install dracula
```

Baixa e instala um tema do repositório oficial.

### Remover Tema

```bash
aurora remove ganache_lait
```

Remove um tema instalado localmente.

### Instalar Hooks de Shell

```bash
aurora install-hooks
```

Injeta automaticamente o carregamento do tema em Bash, Zsh e Fish.

### Ver Status do Sistema

```bash
aurora status
```

Mostra informações sobre:

- Tema atualmente ativo
- Dependências instaladas
- Ambiente (kmscon vs terminal padrão)
- Diretórios de configuração

### Gerenciar Backups

```bash
# Listar backups disponíveis
aurora backup list

# Restaurar backup específico
aurora backup restore /home/usuario/.config/aurora/backups/state.yml.20240104_120000.bak
```

## 🔧 Configuração Multi-Shell

Aurora suporta automaticamente três shells:

### Bash

- Arquivo de configuração: `~/.bashrc`
- Hook adicionado automaticamente
- Recarregue com: `source ~/.bashrc`

### Zsh

- Arquivo de configuração: `~/.zshrc`
- Hook adicionado automaticamente
- Recarregue com: `source ~/.zshrc`

### Fish

- Arquivo de configuração: `~/.config/fish/config.fish`
- Hook adicionado automaticamente
- Recarregue com: `source ~/.config/fish/config.fish`

## 🖥 Suporte Kmscon

Para servidores headless sem ambiente gráfico:

### Verificar Ambiente Kmscon

Aurora detecta automaticamente se está rodando em kmscon:

- Variável `TERM=linux`
- Variável de ambiente `KMSCON_SESSION`

### Aplicação Kmscon

Ao executar `aurora apply <tema>`, Aurora:

1. Aplica cores via ANSI (imediato)
2. Configura arquivo `/etc/kmscon/kmscon.conf`
3. Define cores de background/foreground

### Reiniciar Kmscon

```bash
sudo systemctl restart kmscon.service
```

Ou reinicie a sessão do terminal.

## 🌐 Sistema de Plugins

### Instalar Temas de Repositório

```bash
aurora install nome_tema
```

Por padrão, Aurora busca em:

```
https://raw.githubusercontent.com/helton-godoy/aurora/master/themes
```

### Repositórios Personalizados

Defina seu próprio repositório:

```bash
export AURORA_PLUGIN_REPO="https://seu-repositorio.com/themes"
aurora install tema_customizado
```

### Criar e Compartilhar Temas

Veja [docs/THEME_FORMAT.md](THEME_FORMAT.md) para especificação do formato YAML.

Para compartilhar:

1. Fork do repositório de temas
2. Adicionar seu arquivo `.yml`
3. Criar Pull Request

## 🎨 Formato de Tema

Os temas usam formato YAML simples:

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
    - "#00FF00"
    # ... (16 cores no total)
```

### Validar Cores

Aurora valida automaticamente:

- Contraste WCAG AA (mínimo 4.5:1 entre BG e FG)
- Formato hexadecimal correto (#RRGGBB)
- Presença de 16 cores na paleta

## 🔍 Solução de Problemas

### Tema não é aplicado

1. Verifique se o tema existe:

   ```bash
   aurora list
   ```

2. Recarregue seu shell:

   ```bash
   source ~/.bashrc
   ```

3. Se usando kmscon, reinicie o serviço:
   ```bash
   sudo systemctl restart kmscon
   ```

### Cores não aparecem

1. Verifique se gum está instalado:

   ```bash
   which gum
   ```

2. Verifique se hooks foram instalados:

   ```bash
   aurora install-hooks
   ```

3. Verifique arquivo de estado:
   ```bash
   cat ~/.config/aurora/state.yml
   ```

### Erro "yq não instalado"

Instale o parser YAML:

```bash
pip3 install yq
# ou
sudo apt install yq
```

### Erro "gum não instalado"

Instale a interface UI:

```bash
sudo apt install gum
```

## 📁 Estrutura de Arquivos

```
~/.config/aurora/
├── state.yml           # Tema atual
├── starship.toml       # Configuração Starship
├── current_theme.sh    # Script para Bash/Zsh
├── current_theme.fish  # Script para Fish
└── backups/            # Backups de arquivos
```

## 🆘 Atualizações

Para atualizar o Aurora:

```bash
cd /home/usuario/git/aurora
git pull
sudo ./bin/aurora-install  # se necessário
```

## 📞 Ajuda

Para ver todos os comandos:

```bash
aurora help
```

Para mais informações:

- Documento de arquitetura: [ARCHITECTURE.md](ARCHITECTURE.md)
- Guia de desenvolvedor: [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)
- Perguntas frequentes: [FAQ.md](FAQ.md)
- Especificação de temas: [THEME_FORMAT.md](THEME_FORMAT.md)

## 🤝 Contribuindo

Contribuições são bem-vindas! Veja [GitHub](https://github.com/helton-godoy/aurora) para mais informações.
