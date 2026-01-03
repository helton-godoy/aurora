# 🎯 PROMPT ESTRUTURADO: CONTINUAÇÃO DO DESENVOLVIMENTO AURORA

## 📋 **CONTEXTO DA TAREFA**

Com base na análise detalhada do projeto Aurora TTY Engine (85% implementado), você deve implementar as funcionalidades faltantes identificadas, priorizando correções críticas e melhorias de usabilidade. O projeto já possui uma base sólida com script principal funcional, sistema de temas e interface moderna usando Gum.

---

## 🎯 **OBJETIVOS PRINCIPAIS**

### **PRIORIDADE MÁXIMA (Implementar nesta ordem)**

#### 1. **Sistema de Estado Persistente** 
- **Problema**: Temas aplicados não são persistidos, `aurora status` não mostra tema ativo
- **Arquivo**: `/usr/local/bin/aurora` (linhas ~460, ~583, ~880)
- **Solução**: Implementar sistema de estado JSON em `/etc/aurora/state`

#### 2. **Integração KMSCON Automática**
- **Problema**: KMSCON não inicia automaticamente após reboot, linha 176 comentada
- **Solução**: Criar serviço systemd `/etc/systemd/system/aurora-kmscon.service`

#### 3. **Sistema de Retry Robusto para Fontes**
- **Problema**: Download da FiraCode Nerd Font falha silenciosamente (linha 393)
- **Solução**: Implementar 3 tentativas com backoff e cache local

### **PRIORIDADE ALTA**

#### 4. **Configuração Starship Avançada**
- **Problema**: Configuração Starship muito básica (linha 648), não aproveita potencial completo
- **Solução**: Templates dinâmicos para diferentes cenários (minimalista, developer, server)

#### 5. **Sistema de Backup Automático**
- **Problema**: Não há backup das configurações originais do sistema
- **Solução**: Backup automático de arquivos de configuração antes de modificações

#### 6. **Validador de Contraste WCAG**
- **Problema**: Temas podem ter contraste insuficiente para acessibilidade
- **Solução**: Algoritmo de verificação de contraste 4.5:1 mínimo

---

## 🛠️ **INSTRUÇÕES DE IMPLEMENTAÇÃO**

### **ETAPA 1: Sistema de Estado (30 minutos)**

1. **Adicionar função de salvamento de estado** após linha 460:
```bash
save_current_theme() {
    local theme_name="$1"
    local state_file="/etc/aurora/state"
    mkdir -p "$(dirname "$state_file")"
    
    cat > "$state_file" << EOF
{
  "current_theme": "$theme_name",
  "last_applied": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "script_version": "$SCRIPT_VERSION"
}
EOF
}
```

2. **Modificar função `apply_theme()`** (após linha 583) para salvar estado:
```bash
save_current_theme "$theme_name"
```

3. **Modificar função `show_status()`** (após linha 880) para ler estado atual:
```bash
if [[ -f "/etc/aurora/state" ]]; then
    local current_theme=$(jq -r '.current_theme' /etc/aurora/state 2>/dev/null || echo "Desconhecido")
    status_items+="✅ Tema Atual: $current_theme"$'\n'
fi
```

### **ETAPA 2: Serviço KMSCON Systemd (20 minutos)**

1. **Criar arquivo de serviço**:
```bash
cat > /etc/systemd/system/aurora-kmscon.service << 'EOF'
[Unit]
Description=Aurora KMSCON Theme Engine
After=systemd-user-sessions.service plymouth-quit.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/aurora apply-current
RemainAfterExit=yes
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
```

2. **Adicionar comando `apply-current`** ao case statement principal:
```bash
"apply-current")
    if [[ -f "/etc/aurora/state" ]]; then
        local theme_name=$(jq -r '.current_theme' /etc/aurora/state 2>/dev/null)
        if [[ "$theme_name" != "null" && -n "$theme_name" ]]; then
            apply_theme "$theme_name"
        fi
    fi
    ;;
```

3. **Habilitar serviço** na função `install_dependencies()`:
```bash
systemctl enable aurora-kmscon.service 2>/dev/null || true
```

### **ETAPA 3: Sistema de Fontes Robusto (45 minutos)**

1. **Substituir função `install_nerd_font()`** (linhas 368-394) por versão melhorada:
```bash
install_nerd_font() {
    local font_name="FiraCodeNerdFont"
    local font_file="$FONT_DIR/${font_name}-Regular.ttf"
    local cache_dir="/var/cache/aurora/fonts"
    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
    
    # Verificar se já está instalada
    if fc-list 2>/dev/null | grep -qi "FiraCode.*Nerd"; then
        gum style --foreground "$UI_ACCENT" "  🍫 FiraCode Nerd Font já está instalada"
        return 0
    fi
    
    mkdir -p "$cache_dir"
    show_loading "Baixando FiraCode Nerd Font..."
    
    # Tentar 3 vezes com backoff exponencial
    local attempt=1
    local delay=2
    while [[ $attempt -le 3 ]]; do
        if curl -fsSL "$font_url" -o "$cache_dir/FiraCode.zip" 2>/dev/null; then
            mkdir -p "$FONT_DIR"
            unzip -q "$cache_dir/FiraCode.zip" -d "$cache_dir" 2>/dev/null || true
            cp "$cache_dir"/*.ttf "$FONT_DIR/" 2>/dev/null || true
            fc-cache -fv >/dev/null 2>&1
            rm -rf "$cache_dir"
            gum style --foreground "$UI_SUCCESS" "  ✅ FiraCode Nerd Font instalada"
            return 0
        else
            gum style --foreground "$UI_WARNING" "  ⚠️ Tentativa $attempt falhou, tentando novamente em ${delay}s..."
            sleep $delay
            delay=$((delay * 2))
            ((attempt++))
        fi
    done
    
    # Fallback: tentar URL alternativa
    local fallback_url="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf"
    if curl -fsSL "$fallback_url" -o "$font_file" 2>/dev/null; then
        fc-cache -fv >/dev/null 2>&1
        gum style --foreground "$UI_SUCCESS" "  ✅ FiraCode Nerd Font instalada (fallback)"
    else
        gum style --foreground "$UI_ERROR" "  ❌ Falha ao instalar FiraCode Nerd Font"
        return 1
    fi
}
```

### **ETAPA 4: Configuração Starship Avançada (60 minutos)**

1. **Criar função para gerar configuração avançada** (após linha 650):
```bash
generate_advanced_starship_config() {
    local theme_name="$1"
    local template_type="${2:-standard}"  # minimal, developer, server
    
    local config_content=""
    
    case "$template_type" in
        "minimal")
            config_content=$(cat << 'STARSHIP_EOF'
# Starship Minimal Configuration
format = "[$directory]($ACCENT) $character"
directory.style = "fg:accent"
character.success_symbol = "[→](fg:accent)"
character.error_symbol = "[✗](fg:red)"
STARSHIP_EOF
            ;;
        "developer")
            config_content=$(cat << 'STARSHIP_EOF'
# Starship Developer Configuration
format = """[┌──](accent)$username$hostname[─](accent)$directory$git_branch$git_status$line_break$character"""

[username]
style_user = "fg:milk"
style_root = "fg:red bold"
show_always = true

[hostname]
ssh_only = false
style = "fg:cream"

[directory]
style = "fg:accent"
truncation_length = 3

[git_branch]
symbol = "🍫 "
style = "fg:caramel"

[git_status]
style = "fg:caramel"

[character]
success_symbol = "[→](fg:accent)"
error_symbol = "[✗](fg:red)"

[python]
symbol = "🐍 "
style = "fg:blue"

[nodejs]
symbol = "🟢 "
style = "fg:green"
STARSHIP_EOF
            ;;
        "server")
            config_content=$(cat << 'STARSHIP_EOF'
# Starship Server Configuration
format = """[┌──](accent)$username$hostname[─](accent)$directory$system_load$uptime$character"""

[username]
show_always = true

[hostname]
ssh_only = false

[directory]
style = "fg:accent"

[system_load]
style = "fg:yellow"
format = "[[ $load_average ](fg:yellow)]"

[uptime]
style = "fg:blue"
format = "[[ $style ](fg:blue)]"

[character]
success_symbol = "[→](fg:accent)"
error_symbol = "[✗](fg:red)"
STARSHIP_EOF
            ;;
        *)
            # Template padrão (atual)
            config_content=$(cat << 'STARSHIP_EOF'
# Starship Configuration - AURORA Theme
format = """
[┌──](accent)$username$hostname[─](accent)$directory$git_branch$git_status
[└─](accent)$character"""

[username]
style_user = "fg:milk"
style_root = "fg:red bold"
show_always = true

[hostname]
ssh_only = false

[directory]
style = "fg:accent"
truncation_length = 3

[git_branch]
symbol = "🍫 "

[git_status]
style = "fg:caramel"

[character]
success_symbol = "[→](fg:accent)"
error_symbol = "[✗](fg:red)"
STARSHIP_EOF
            ;;
    esac
    
    # Adicionar paleta de cores
    cat > "$STARSHIP_CONFIG" << EOF
# Starship Configuration - AURORA Theme: $theme_name
palette = "ganache"

[palettes.ganache]
background = "$BG_COLOR"
foreground = "$FG_COLOR"
accent = "$ACCENT"
caramel = "#6a4928"
espresso = "#2a1d10"
milk = "#ded6d1"
cream = "#cec2b9"

$config_content
EOF
}
```

2. **Modificar função `generate_starship_config()`** para usar template inteligente:
```bash
generate_starship_config() {
    local theme_name="$1"
    
    # Detectar tipo de ambiente automaticamente
    local template_type="standard"
    if [[ -f "/.dockerenv" ]] || grep -q docker /proc/1/cgroup 2>/dev/null; then
        template_type="server"
    elif command -v git &>/dev/null && [[ -d ".git" ]]; then
        template_type="developer"
    fi
    
    generate_advanced_starship_config "$theme_name" "$template_type"
    gum style --foreground "$UI_SUCCESS" "  ✅ Starship configurado ($template_type)"
}
```

### **ETAPA 5: Sistema de Backup (30 minutos)**

1. **Adicionar função de backup** (após linha 455):
```bash
backup_system_config() {
    local backup_dir="/etc/aurora/backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup kmscon
    if [[ -f "$KMSCON_CONF" ]]; then
        cp "$KMSCON_CONF" "$backup_dir/kmscon.conf.original"
    fi
    
    # Backup bashrc
    if [[ -f "$BASHRC" ]]; then
        cp "$BASHRC" "$backup_dir/bashrc.original"
    fi
    
    # Backup starship
    if [[ -f "$STARSHIP_CONFIG" ]]; then
        cp "$STARSHIP_CONFIG" "$backup_dir/starship.toml.original"
    fi
    
    gum style --foreground "$UI_SUCCESS" "  ✅ Backup salvo em $backup_dir"
}
```

2. **Chamar backup** no início da função `apply_theme()`:
```bash
backup_system_config
```

### **ETAPA 6: Validador de Contraste (45 minutos)**

1. **Adicionar funções de validação** (após linha 670):
```bash
hex_to_rgb() {
    local hex="$1"
    hex=${hex#\#}
    echo "$((0x${hex:0:2})) $((0x${hex:2:2})) $((0x${hex:4:2}))"
}

calculate_luminance() {
    local rgb="$1"
    local r g b
    read -r r g b <<< "$rgb"
    
    # Converter para luminosidade relativa
    r=$(echo "scale=4; $r/255" | bc)
    g=$(echo "scale=4; $g/255" | bc)
    b=$(echo "scale=4; $b/255" | bc)
    
    # Aplicar função de transferência
    r=$(echo "if ($r <= 0.03928) { $r/12.92 } else { (($r+0.055)/1.055)^2.4 }" | bc -l)
    g=$(echo "if ($g <= 0.03928) { $g/12.92 } else { (($g+0.055)/1.055)^2.4 }" | bc -l)
    b=$(echo "if ($b <= 0.03928) { $b/12.92 } else { (($b+0.055)/1.055)^2.4 }" | bc -l)
    
    # Calcular luminância
    echo "scale=4; 0.2126*$r + 0.7152*$g + 0.0722*$b" | bc -l
}

validate_color_contrast() {
    local bg_color="$1"
    local fg_color="$2"
    
    local bg_rgb=$(hex_to_rgb "$bg_color")
    local fg_rgb=$(hex_to_rgb "$fg_color")
    
    local bg_lum=$(calculate_luminance "$bg_rgb")
    local fg_lum=$(calculate_luminance "$fg_rgb")
    
    # Calcular contraste
    local lighter
    local darker
    if (( $(echo "$bg_lum > $fg_lum" | bc -l) )); then
        lighter="$bg_lum"
        darker="$fg_lum"
    else
        lighter="$fg_lum"
        darker="$bg_lum"
    fi
    
    local contrast=$(echo "scale=2; ($lighter + 0.05) / ($darker + 0.05)" | bc -l)
    
    # Verificar se atende WCAG AA (4.5:1)
    local valid=$(echo "$contrast >= 4.5" | bc -l)
    
    if [[ "$valid" == "1" ]]; then
        return 0  # Válido
    else
        return 1  # Inválido
    fi
}
```

2. **Validar contraste** na função `apply_theme()`:
```bash
if ! validate_color_contrast "$BG_COLOR" "$FG_COLOR"; then
    box_warning "Contraste insuficiente entre background ($BG_COLOR) e foreground ($FG_COLOR)
    
Este tema pode ter problemas de legibilidade. Continue mesmo assim?"
    
    if ! gum confirm "Aplicar tema com contraste insuficiente?" --default=false; then
        return 1
    fi
fi
```

---

## 🧪 **TESTES OBRIGATÓRIOS**

Após cada etapa, execute os seguintes testes:

### **Teste 1: Sistema de Estado**
```bash
# Aplicar tema
sudo aurora apply ganache_lait

# Verificar estado
cat /etc/aurora/state

# Verificar status
aurora status
```

### **Teste 2: Serviço KMSCON**
```bash
# Habilitar serviço
sudo systemctl enable aurora-kmscon.service

# Simular reboot (opcional)
sudo systemctl restart aurora-kmscon.service
```

### **Teste 3: Sistema de Fontes**
```bash
# Forçar nova instalação
sudo rm -rf /usr/local/share/fonts/FiraCode*

# Reinstalar
sudo aurora install
```

### **Teste 4: Configuração Starship**
```bash
# Aplicar tema e verificar configuração
sudo aurora apply ganache_noir
cat ~/.config/starship.toml
```

### **Teste 5: Backup**
```bash
# Verificar se backup foi criado
ls -la /etc/aurora/backups/
```

### **Teste 6: Validação de Contraste**
```bash
# Criar tema com contraste baixo (temporário)
echo 'BG_COLOR="#ffffff"
FG_COLOR="#ffffff"' > /tmp/test_contrast.theme

# Tentar aplicar (deve mostrar warning)
aurora apply /tmp/test_contrast.theme
```

---

## 📋 **CHECKLIST DE ENTREGA**

### **Funcionalidades Implementadas**
- [ ] Sistema de estado persistente funcionando
- [ ] Serviço KMSCON habilitado e funcional  
- [ ] Sistema de fontes com retry robusto
- [ ] Configuração Starship avançada (templates)
- [ ] Sistema de backup automático
- [ ] Validador de contraste WCAG

### **Testes Realizados**
- [ ] Todos os 6 testes obrigatórios passaram
- [ ] `aurora status` mostra tema atual corretamente
- [ ] KMSCON aplica tema após reboot simulado
- [ ] Download de fontes funciona com falha simulada
- [ ] Starship usa configuração apropriada ao ambiente
- [ ] Backup é criado antes de modificações
- [ ] Tema com contraste baixo mostra warning

### **Qualidade do Código**
- [ ] Todas as funções têm documentação inline
- [ ] Tratamento de erros adequado em todas as novas funções
- [ ] Compatibilidade com Bash 4.0+ mantida
- [ ] Performance não foi degradada
- [ ] Estrutura modular preservada

---

## 🎯 **ENTREGA FINAL**

Após completar todas as etapas, forneça:

1. **Resumo executivo** das funcionalidades implementadas
2. **Lista de arquivos modificados** com linha numbers específicas
3. **Resultado dos testes** obrigatórios
4. **Instruções de instalação** atualizadas
5. **Próximos passos recomendados** para evolução

**Tempo estimado total: 4-6 horas de desenvolvimento**

**Prioridade de revisão: CRÍTICA** - Estas funcionalidades são essenciais para o projeto Aurora ser considerado production-ready.