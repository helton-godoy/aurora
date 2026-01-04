# Guia de Operações do Aurora

Este guia cobre operações comuns para gerenciar temas com o Aurora v3.0.

## Instalação

### Instalação Completa

```bash
# 1. Instalar dependências
echo "Instalando dependências do sistema..."
sudo bash bin/aurora-install

# 2. Verificar instalação
aurora list

# 3. Instalar hooks de shell
aurora install-hooks
```

### Desenvolvimento Local

```bash
# Clonar repositório
git clone https://github.com/helton-godoy/aurora.git
cd aurora

# Criar wrapper local
bash scripts/setup.sh

# Usar em modo desenvolvimento
./aurora list
```

## Operações Básicas

### Listar Temas

```bash
# Todos os temas disponíveis
aurora list

# Apenas temas remotos
aurora list --remote

# Temas do usuário vs sistema
aurora status
```

### Visualizar e Aplicar Temas

```bash
# Preview temporário (10 segundos)
aurora preview ganache_noir

# Aplicar permanentemente
aurora apply ganache_noir

# Aplicar tema claro
aurora apply ganache_blanc
```

### Gerenciar Temas Remotos

```bash
# Instalar tema do repositório oficial
aurora install dracula

# Instalar de repositório personalizado
export AURORA_PLUGIN_REPO="https://raw.githubusercontent.com/usuario/repo/main/themes"
aurora install meu_tema

# Remover tema do usuário
aurora remove meu_tema
```

## Backup e Restauração

### Sistema de Backup

```bash
# Listar backups disponíveis
aurora backup list

# Restaurar backup específico
aurora backup restore ~/.local/share/aurora/backups/state.yml.20260104_120000.bak
```

### Backup Manual

```bash
# Backup da configuração
git clone ~/.config/aurora/ ~/aurora-backup-$(date +%Y%m%d)

# Backup dos temas personalizados
cp -r ~/.local/share/aurora/themes/ ~/aurora-themes-backup-$(date +%Y%m%d)
```

## Multi-Shell Management

### Bash

```bash
# Recarregar após mudanças
source ~/.bashrc

# Verificar se hook está ativo
tail ~/.bashrc | grep aurora
```

### Zsh

```bash
# Recarregar após mudanças
source ~/.zshrc

# Verificar se hook está ativo
tail ~/.zshrc | grep aurora
```

### Fish

```bash
# Recarregar após mudanças
source ~/.config/fish/config.fish

# Verificar se hook está ativo
tail ~/.config/fish/config.fish | grep aurora
```

## Kmscon (Servidores Headless)

### Detectar Ambiente Kmscon

```bash
# Verificar variáveis de ambiente
echo $TERM
echo $KMSCON_SESSION

# Verificar se kmscon está instalado
which kmscon
```

### Configurar Kmscon

```bash
# Aplicar tema ao kmscon
aurora apply ganache_noir

# Reiniciar serviço kmscon
sudo systemctl restart kmscon

# Verificar configuração
aurora status
```

## Troubleshooting

### Tema Não Aplica

```bash
# 1. Verificar se tema existe
aurora list

# 2. Verificar dependências
aurora status

# 3. Recarregar shell
source ~/.bashrc  # ou ~/.zshrc

# 4. Reinstaurar hooks
aurora install-hooks

# 5. Para kmscon, reiniciar serviço
sudo systemctl restart kmscon
```

### Problemas de Dependência

```bash
# Instalar yq (obrigatório)
sudo apt install yq
# ou
pip3 install yq

# Instalar gum (opcional)
sudo apt install gum

# Instalar starship (opcional)
curl -fsSL https://starship.rs/install.sh | sh
```

### Debug e Logs

```bash
# Executar com debug
aurora DEBUG=1 aurora apply ganache_noir

# Verificar estado atual
cat ~/.config/aurora/state.yml

# Verificar logs de backup
ls -la ~/.local/share/aurora/backups/
```

## Empacotamento e Distribuição

### Criar Pacote

```bash
# Criar pacote de distribuição
bash scripts/package.sh

# Resultado: dist/aurora-3.0.0.tar.gz
ls -la dist/
```

### Testar Pacote

```bash
# Descompactar em ambiente limpo
cd /tmp
tar xzf aurora-3.0.0.tar.gz
cd aurora-3.0.0

# Testar instalação
sudo bash bin/aurora-install

# Verificar funcionalidade
aurora list
```

## Atualização e Manutenção

### Atualizar Aurora

```bash
# Para instalação via git
cd ~/aurora  # ou onde está o repositório
git pull

# Para instalação via pacote
wget https://github.com/helton-godoy/aurora/releases/latest/download/aurora-3.0.0.tar.gz
tar xzf aurora-3.0.0.tar.gz
cd aurora-3.0.0
sudo bash bin/aurora-install
```

### Limpeza de Sistema

```bash
# Limpar backups antigos (mantém 10 mais recentes)
ls -t ~/.local/share/aurora/backups/ | tail -n +11 | xargs -r rm

# Verificar uso de espaço
du -sh ~/.config/aurora/
du -sh ~/.local/share/aurora/
```

### Performance

```bash
# Verificar tempo de carregamento
aurora time aurora list

# Testar contraste WCAG
aurora preview ganache_noir | grep "Contraste"
```

## Integração com Outras Ferramentas

### Starship

```bash
# Aurora gera ~/.config/starship.toml automaticamente
# Verificar configuração
aurora status | grep starship

# Aplicar tema atualiza starship automaticamente
aurora apply ganache_lait
```

### Hooks Customizados

```bash
# Hooks são instalados automaticamente em:
# ~/.bashrc, ~/.zshrc, ~/.config/fish/config.fish

# Verificar conteúdo do hook
cat ~/.config/aurora/current_theme.sh
```
