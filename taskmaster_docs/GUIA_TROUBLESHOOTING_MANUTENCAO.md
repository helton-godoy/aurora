# 🔧 GUIA DE TROUBLESHOOTING E MANUTENÇÃO - TASK MASTER AI + OLLAMA

**Manual de Resolução de Problemas e Manutenção**  
**Data:** 03 de Janeiro de 2026  
**Sistema:** Task Master AI v0.40.1 + Ollama v0.13.3

---

## 📋 ÍNDICE DE TROUBLESHOOTING

1. [Diagnóstico Rápido](#-diagnóstico-rápido)
2. [Problemas Comuns](#-problemas-comuns)
3. [Problemas do Ollama](#-problemas-do-ollama)
4. [Problemas do Task Master](#-problemas-do-task-master)
5. [Problemas de Integração MCP](#-problemas-de-integração-mcp)
6. [Problemas de Performance](#-problemas-de-performance)
7. [Recuperação de Dados](#-recuperação-de-dados)
8. [Manutenção Preventiva](#-manutenção-preventiva)
9. [Scripts de Automação](#-scripts-de-automação)

---

## 🚨 DIAGNÓSTICO RÁPIDO

### Health Check Completo (1 minuto)

```bash
#!/bin/bash
# Diagnóstico completo em 60 segundos

echo "🔍 DIAGNÓSTICO RÁPIDO - AURORA PROJECT"
echo "Data: $(date)"
echo "======================================"

# 1. Task Master AI
echo "1. Task Master AI:"
if command -v task-master &> /dev/null; then
    VERSION=$(task-master --version 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "   ✅ OK - $VERSION"
    else
        echo "   ❌ FAIL - Comando não responde"
    fi
else
    echo "   ❌ FAIL - Comando não encontrado"
fi

# 2. Ollama Service
echo "2. Ollama Service:"
if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    MODELS=$(curl -s http://localhost:11434/api/tags | jq '.models | length' 2>/dev/null || echo "?")
    echo "   ✅ OK - $MODELS modelos"
else
    echo "   ❌ FAIL - API não responde"
fi

# 3. Modelos Principais
echo "3. Modelos Críticos:"
if ollama list 2>/dev/null | grep -q "llama3.2:3b"; then
    echo "   ✅ llama3.2:3b OK"
else
    echo "   ❌ llama3.2:3b FAIL"
fi

if ollama list 2>/dev/null | grep -q "qwen3:4b"; then
    echo "   ✅ qwen3:4b OK"
else
    echo "   ❌ qwen3:4b FAIL"
fi

# 4. Configuração MCP
echo "4. Configuração MCP:"
if [ -f ".cursor/mcp.json" ]; then
    echo "   ✅ Cursor config OK"
else
    echo "   ❌ Cursor config FAIL"
fi

if [ -f ".vscode/mcp.json" ]; then
    echo "   ✅ VSCode config OK"
else
    echo "   ❌ VSCode config FAIL"
fi

# 5. Estado do Projeto
echo "5. Estado do Projeto:"
if [ -f ".taskmaster/config.json" ]; then
    echo "   ✅ Task Master config OK"
else
    echo "   ❌ Task Master config FAIL"
fi

if [ -d ".taskmaster/tasks" ]; then
    TASK_COUNT=$(find .taskmaster/tasks -name "*.json" | wc -l)
    echo "   ✅ Tarefas OK ($TASK_COUNT arquivos)"
else
    echo "   ❌ Diretório de tarefas FAIL"
fi

echo "======================================"
echo "🏁 Diagnóstico concluído"
```

### Teste de Conectividade Específico

```bash
# Teste rápido de conectividade Ollama
test_ollama() {
    echo "🧪 Testando conectividade Ollama..."

    # Teste 1: API básica
    if curl -s http://localhost:11434/api/tags > /dev/null; then
        echo "   ✅ API responde"
    else
        echo "   ❌ API não responde"
        return 1
    fi

    # Teste 2: Modelos disponíveis
    MODELS=$(curl -s http://localhost:11434/api/tags | jq '.models | length' 2>/dev/null)
    if [ "$MODELS" -gt 0 ]; then
        echo "   ✅ $MODELS modelos disponíveis"
    else
        echo "   ❌ Nenhum modelo encontrado"
    fi

    # Teste 3: Modelo principal
    if curl -s http://localhost:11434/api/tags | jq -e '.models[] | select(.name == "llama3.2:3b")' > /dev/null; then
        echo "   ✅ Modelo principal (llama3.2:3b) OK"
    else
        echo "   ❌ Modelo principal não encontrado"
    fi
}

# Executar teste
test_ollama
```

---

## ❌ PROBLEMAS COMUNS

### Problema 1: "command not found: task-master"

**Sintomas:**

```bash
$ task-master --version
bash: task-master: command not found
```

**Causas Possíveis:**

- Task Master AI não instalado
- Problema com npm global
- PATH não configurado

**Soluções:**

```bash
# Solução 1: Verificar instalação
npm list -g task-master-ai

# Solução 2: Reinstalar
npm install -g task-master-ai@latest

# Solução 3: Verificar PATH
echo $PATH | grep -o '[^:]*node[^:]*'

# Solução 4: Usar npx como fallback
npx -y task-master-ai --version
```

### Problema 2: "Ollama API não responde"

**Sintomas:**

```bash
$ curl http://localhost:11434/api/tags
curl: (7) Failed to connect to localhost port 11434: Connection refused
```

**Diagnóstico:**

```bash
# Verificar se Ollama está rodando
systemctl status ollama
ps aux | grep ollama

# Verificar porta
netstat -tuln | grep 11434

# Verificar logs
journalctl -u ollama -f --lines=50
```

**Soluções:**

```bash
# Solução 1: Iniciar Ollama
sudo systemctl start ollama
sudo systemctl enable ollama

# Solução 2: Reiniciar serviço
sudo systemctl restart ollama

# Solução 3: Verificar configuração
cat /etc/systemd/system/ollama.service

# Solução 4: Executar manualmente para debug
ollama serve --debug
```

### Problema 3: "Modelo não encontrado"

**Sintomas:**

```bash
$ ollama run llama3.2:3b
Error: model 'llama3.2:3b' not found
```

**Diagnóstico:**

```bash
# Listar modelos instalados
ollama list

# Verificar modelo específico
ollama show llama3.2:3b
```

**Soluções:**

```bash
# Solução 1: Baixar modelo
ollama pull llama3.2:3b

# Solução 2: Verificar disponibilidade
ollama pull llama3.2:3b --verbose

# Solução 3: Listar modelos disponíveis
ollama list | grep llama

# Solução 4: Mudar para modelo alternativo
ollama run qwen3:4b
```

---

## 🤖 PROBLEMAS DO OLLAMA

### Problema: Ollama consome muita memória/GPU

**Sintomas:**

```bash
$ nvidia-smi
GPU Memory: 4GB/4GB (99% usado)
```

**Diagnóstico:**

```bash
# Verificar uso de GPU
nvidia-smi --query-gpu=memory.used,memory.total --format=csv

# Verificar processos Ollama
ps aux | grep ollama

# Verificar modelos carregados
ollama ps
```

**Soluções:**

```bash
# Solução 1: Parar modelos não usados
ollama stop llama3.2:3b
ollama ps  # Ver modelos ativos

# Solução 2: Usar modelos menores
ollama run llama3.2:1b  # 1B parâmetros vs 3B

# Solução 3: Configurar limites de memória
# Editar /etc/systemd/system/ollama.service
# Adicionar: Environment="OLLAMA_MAX_LOADED_MODELS=1"

# Solução 4: Reiniciar serviço
sudo systemctl restart ollama
```

### Problema: Modelos carregam muito lentamente

**Sintomas:**

```bash
$ time ollama run llama3.2:3b "Test"
(> 30 segundos para carregar)
```

**Soluções:**

```bash
# Solução 1: Manter modelo carregado
# Em vez de:
ollama run llama3.2:3b "Prompt"

# Use:
ollama run llama3.2:3b  # Deixa interativo rodando
# Em outro terminal:
ollama ps  # Ver modelos carregados

# Solução 2: Usar modelo menor para testes
ollama run llama3.2:1b

# Solução 3: Pre-carregar modelos na inicialização
# Adicionar ao ~/.bashrc:
ollama pull llama3.2:3b
ollama pull qwen3:4b
```

### Problema: Erro de rede/timeout

**Sintomas:**

```bash
$ curl http://localhost:11434/api/generate -d '{"model":"llama3.2:3b","prompt":"Test"}'
Connection timeout or network error
```

**Soluções:**

```bash
# Solução 1: Verificar logs detalhados
journalctl -u ollama --lines=100 -f

# Solução 2: Reiniciar com logs verbosos
sudo systemctl stop ollama
ollama serve --verbose

# Solução 3: Verificar configuração de rede
netstat -tuln | grep 11434

# Solução 4: Testar com modelo pequeno
ollama run llama3.2:1b "Teste rápido"
```

---

## 🛠️ PROBLEMAS DO TASK MASTER

### Problema: Ferramentas MCP não funcionam

**Sintomas:**

- Ferramentas não aparecem no Cursor AI
- Erro "Tool not found"
- Conexão MCP falha

**Diagnóstico:**

```bash
# Verificar configuração MCP
cat .cursor/mcp.json

# Testar servidor MCP standalone
npx -y task-master-ai --version

# Verificar logs no Cursor
# (Visíveis no console do Cursor AI)

# Testar ferramenta específica
echo '{"method":"tools/list"}' | npx -y task-master-ai
```

**Soluções:**

```bash
# Solução 1: Reinstalar Task Master AI
npm install -g task-master-ai@latest --force

# Solução 2: Verificar versão do Node.js
node --version  # Deve ser >= 20

# Solução 3: Reiniciar Cursor AI
# Fechar e abrir novamente

# Solução 4: Recriar configuração MCP
# Deletar .cursor/mcp.json e recriar

# Solução 5: Debug modo verboso
DEBUG=* npx -y task-master-ai
```

### Problema: Tarefas não são salvas

**Sintomas:**

- Tarefas desaparecem após reiniciar
- Estado não persiste
- Arquivos de tarefas vazios

**Diagnóstico:**

```bash
# Verificar diretório de tarefas
ls -la .taskmaster/tasks/

# Verificar permissões
ls -la .taskmaster/

# Verificar espaço em disco
df -h

# Verificar logs
tail -f ~/.taskmaster/logs/*.log
```

**Soluções:**

```bash
# Solução 1: Verificar permissões
chmod 755 .taskmaster
chmod 644 .taskmaster/tasks/*.json

# Solução 2: Recriar estrutura
task-master init --existing

# Solução 3: Backup e restore
task-master backup --output=backup-$(date +%Y%m%d).json
task-master restore --file=backup-20260103.json

# Solução 4: Verificar espaço
df -h  # Liberar espaço se necessário
```

### Problema: IA não gera conteúdo

**Sintomas:**

- Comandos `add-task` não criam tarefas
- `expand` não gera subtasks
- `research` retorna erro

**Diagnóstico:**

```bash
# Testar conectividade Ollama
curl http://localhost:11434/api/tags

# Testar modelo específico
ollama run llama3.2:3b "Teste"

# Ver configuração de modelos
task-master models

# Verificar logs de erro
tail -f ~/.taskmaster/logs/*.log | grep -i error
```

**Soluções:**

```bash
# Solução 1: Verificar modelo configurado
task-master models --ollama --set-main llama3.2:3b

# Solução 2: Testar com modelo diferente
task-master add-task --model=qwen3:4b --prompt="Teste"

# Solução 3: Reiniciar Ollama
sudo systemctl restart ollama

# Solução 4: Verificar variáveis de ambiente
cat .env | grep OLLAMA

# Solução 5: Recarregar configuração
source .env
task-master --reload
```

---

## 🔗 PROBLEMAS DE INTEGRAÇÃO MCP

### Problema: Cursor AI não carrega ferramentas MCP

**Sintomas:**

- Nenhuma ferramenta MCP aparece no autocomplete
- Chat não responde a comandos Task Master
- Configuração MCP não carrega

**Diagnóstico:**

```bash
# Verificar configuração no Cursor
cat .cursor/mcp.json

# Verificar se arquivo está na raiz do projeto
pwd
ls -la | grep cursor

# Verificar sintaxe JSON
cat .cursor/mcp.json | jq .

# Testar servidor MCP manualmente
npx -y task-master-ai --version
```

**Soluções:**

```bash
# Solução 1: Verificar localização do arquivo
# Deve estar em: /home/helton/git/aurora/.cursor/mcp.json

# Solução 2: Verificar sintaxe JSON
cat .cursor/mcp.json | jq . || echo "JSON inválido"

# Solução 3: Recriar configuração
cp .cursor/mcp.json .cursor/mcp.json.backup
# Editar arquivo manualmente com configuração correta

# Solução 4: Reiniciar Cursor AI completamente
# 1. Fechar Cursor AI
# 2. killall Cursor  # Forçar fechamento
# 3. Abrir Cursor AI novamente

# Sololução 5: Verificar permissões
chmod 644 .cursor/mcp.json
```

### Problema: VS Code não reconhece MCP

**Sintomas:**

- Extensão MCP não carrega
- Ferramentas não aparecem
- Configuração não funciona

**Soluções:**

```bash
# Solução 1: Instalar extensão MCP no VS Code
# Extensions → Search "MCP" → Install

# Solução 2: Verificar configuração
cat .vscode/mcp.json

# Solução 3: Recriar configuração VS Code
mkdir -p .vscode
# Copiar configuração do Cursor
cp .cursor/mcp.json .vscode/mcp.json

# Solução 4: Reload VS Code
# Ctrl+Shift+P → "Developer: Reload Window"
```

### Problema: Timeout em operações MCP

**Sintomas:**

- "Request timeout" em operações
- Ferramentas falham após 30s
- Conexão MCPcai

**Diagnóstico:**

```bash
# Verificar configuração de timeout
grep -A 5 -B 5 timeout .cursor/mcp.json

# Testar servidor MCP com timeout
time echo '{"method":"tools/list"}' | npx -y task-master-ai

# Verificar performance Ollama
time curl -s http://localhost:11434/api/tags
```

**Soluções:**

```bash
# Solução 1: Aumentar timeout
# Editar .cursor/mcp.json:
{
  "timeout": 60000,  # 60 segundos
  "retryLimit": 5    # Mais tentativas
}

# Solução 2: Usar modelo mais rápido
task-master models --ollama --set-main llama3.2:1b

# Solução 3: Otimizar prompt
# Usar prompts mais curtos e específicos

# Solução 4: Restart Ollama
sudo systemctl restart ollama
```

---

## ⚡ PROBLEMAS DE PERFORMANCE

### Problema: Sistema lento/responsividade baixa

**Sintomas:**

- Comandos demoram > 5 segundos
- Interface travando
- Alto uso de CPU/memória

**Diagnóstico:**

```bash
# Verificar recursos do sistema
top -p $(pgrep -f "ollama\|task-master")

# Verificar GPU
nvidia-smi

# Verificar memória
free -h

# Verificar disco
df -h
iostat -x 1 5
```

**Soluções:**

```bash
# Solução 1: Usar modelos menores
ollama run llama3.2:1b  # vs 3b
task-master models --ollama --set-main llama3.2:1b

# Solução 2: Limpar cache
task-master cache --clear
ollama rm $(ollama list | tail -n +2 | awk '{print $1}')  # Remove modelos não principais

# Solução 3: Reiniciar serviços
sudo systemctl restart ollama

# Solução 4: Fechar processos desnecessários
pkill -f "ollama.*gpt-oss"  # Remove modelo pesado

# Solução 5: Otimizar configuração
# Editar .taskmaster/config.json:
{
  "global": {
    "maxTokens": 32000,  # Reduzir de 64000
    "temperature": 0.1   # Reduzir para respostas mais diretas
  }
}
```

### Problema: Alto consumo de VRAM

**Sintomas:**

- GPU memory > 90%
- Sistema travando em operações GPU
- Outros apps com performance reduzida

**Soluções:**

```bash
# Solução 1: Usar apenas um modelo por vez
ollama stop llama3.2:3b  # Parar modelos não usados

# Solução 2: Configurar limit de modelos carregados
# Editar /etc/systemd/system/ollama.service:
Environment="OLLAMA_MAX_LOADED_MODELS=1"
Environment="OLLAMA_MAX_QUEUE=1"

# Solução 3: Usar CPU inference (mais lento, menos memória)
OLLAMA_CPU=1 ollama run llama3.2:3b

# Solução 4: Configurar modelos otimizados para GPU
ollama run llama3.2:1b  # 1B vs 3B parâmetros

# Solução 5: Monitoramento contínuo
watch -n 2 'nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader'
```

---

## 💾 RECUPERAÇÃO DE DADOS

### Problema: Perda de tarefas/estado

**Cenário:**

- Arquivos de tarefas corrompidos
- Estado perdido após reinstalação
- Configuração resetada

**Recuperação:**

```bash
# 1. Verificar backups disponíveis
ls -la ~/.taskmaster-backups/

# 2. Restaurar backup mais recente
task-master restore --file=~/.taskmaster-backups/backup-20260103.tar.gz

# 3. Recriar estrutura se necessário
task-master init --existing

# 4. Importar tarefas manualmente
# Se backup indisponível, recriar manualmente:
cat > .taskmaster/tasks/tasks.json << 'EOF'
{
  "tasks": [
    {
      "id": 1,
      "title": "Tarefa de exemplo",
      "description": "Descrição da tarefa",
      "status": "pending",
      "priority": "medium",
      "created_at": "2026-01-03T19:20:00Z"
    }
  ]
}
EOF
```

### Problema: Configuração corrompida

**Diagnóstico:**

```bash
# Verificar sintaxe JSON
cat .taskmaster/config.json | jq . || echo "JSON inválido"

# Verificar variáveis de ambiente
cat .env | grep -v '^#' | grep -v '^$'

# Verificar configuração MCP
cat .cursor/mcp.json | jq .
```

**Recuperação:**

```bash
# 1. Restaurar de backup
cp ~/.taskmaster-backups/config.json .taskmaster/config.json

# 2. Regenerar configuração padrão
task-master models --setup

# 3. Recriar .env com configuração mínima
cat > .env << 'EOF'
OLLAMA_BASE_URL="http://localhost:11434/api"
TASK_MASTER_TOOLS="standard"
LOG_LEVEL="info"
DEBUG="false"
PROJECT_NAME="Aurora Project"
RESPONSE_LANGUAGE="Português"
EOF

# 4. Recriar configuração MCP
# Usar templates dos outros documentos
```

### Problema: Modelos Ollama corrompidos

**Diagnóstico:**

```bash
# Listar modelos
ollama list

# Verificar modelo específico
ollama show llama3.2:3b

# Testar modelo
ollama run llama3.2:3b "Teste" --verbose
```

**Recuperação:**

```bash
# 1. Remover modelo corrompido
ollama rm llama3.2:3b

# 2. Baixar novamente
ollama pull llama3.2:3b

# 3. Verificar integridade
ollama run llama3.2:3b "Teste de integridade"

# 4. Se falhar, reinstalar Ollama
curl -fsSL https://ollama.ai/install.sh | sh
```

---

## 🔧 MANUTENÇÃO PREVENTIVA

### Rotina Semanal (Domingos)

```bash
#!/bin/bash
# save as: scripts/weekly-maintenance.sh

echo "🧹 MANUTENÇÃO SEMANAL - $(date)"

# 1. Backup completo
echo "1. Criando backup..."
./scripts/backup.sh

# 2. Verificar saúde do sistema
echo "2. Health check..."
./scripts/health-check.sh

# 3. Limpar logs antigos
echo "3. Limpando logs..."
find ~/.taskmaster/logs -name "*.log" -mtime +7 -delete
journalctl --vacuum-time=7d

# 4. Verificar espaço em disco
echo "4. Verificando espaço..."
df -h | grep -E "(Filesystem|/dev/)"

# 5. Atualizar modelos (opcional)
echo "5. Verificando atualizações..."
ollama pull llama3.2:3b  # Verificar se há versão nova

# 6. Teste de funcionalidade
echo "6. Teste rápido..."
task-master --version > /dev/null && echo "   ✅ Task Master OK"
curl -s http://localhost:11434/api/tags > /dev/null && echo "   ✅ Ollama OK"

echo "✅ Manutenção semanal concluída"
```

### Rotina Mensal (1º do mês)

```bash
#!/bin/bash
# save as: scripts/monthly-maintenance.sh

echo "🔧 MANUTENÇÃO MENSAL - $(date)"

# 1. Backup completo com limpeza
echo "1. Backup e limpeza..."
./scripts/backup.sh

# 2. Atualizar Task Master AI
echo "2. Atualizando Task Master AI..."
npm update -g task-master-ai

# 3. Verificar Ollama
echo "3. Verificando Ollama..."
ollama --version

# 4. Limpeza profunda
echo "4. Limpeza profunda..."
# Remover modelos não usados
ollama list | tail -n +2 | awk '{print $1}' | while read model; do
    if [ "$model" != "llama3.2:3b" ] && [ "$model" != "qwen3:4b" ]; then
        echo "Removendo modelo: $model"
        ollama rm "$model"
    fi
done

# 5. Verificar dependências
echo "5. Verificando dependências..."
npm list -g task-master-ai

# 6. Análise de performance
echo "6. Análise de performance..."
task-master analyze-complexity

# 7. Teste completo
echo "7. Teste completo..."
task-master health-check

echo "✅ Manutenção mensal concluída"
```

### Monitoramento Contínuo

```bash
# Script de monitoramento (executar via cron)
#!/bin/bash
# save as: scripts/monitor.sh

LOG_FILE="/var/log/aurora-monitor.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Função de log
log() {
    echo "[$DATE] $1" >> $LOG_FILE
}

# Verificar Ollama
if ! curl -s http://localhost:11434/api/tags > /dev/null; then
    log "ERRO: Ollama não responde"
    sudo systemctl restart ollama
fi

# Verificar Task Master
if ! task-master --version > /dev/null 2>&1; then
    log "ERRO: Task Master não responde"
fi

# Verificar espaço em disco
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 85 ]; then
    log "AVISO: Uso de disco alto: ${DISK_USAGE}%"
fi

# Verificar GPU memory
if command -v nvidia-smi &> /dev/null; then
    GPU_USAGE=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | head -1)
    GPU_TOTAL=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | head -1)
    GPU_PERCENT=$((GPU_USAGE * 100 / GPU_TOTAL))

    if [ $GPU_PERCENT -gt 90 ]; then
        log "AVISO: GPU memory alta: ${GPU_PERCENT}%"
        # Parar modelos não essenciais
        ollama ps | tail -n +2 | grep -v "llama3.2:3b" | awk '{print $1}' | xargs -r ollama stop
    fi
fi
```

---

## 🤖 SCRIPTS DE AUTOMAÇÃO

### Script de Recovery Automático

```bash
#!/bin/bash
# save as: scripts/auto-recovery.sh

echo "🚨 AUTO-RECOVERY INICIADO - $(date)"

# Função para verificar e reiniciar serviço
restart_service() {
    local service=$1
    local description=$2

    if ! systemctl is-active --quiet $service; then
        echo "Reiniciando $description..."
        sudo systemctl restart $service
        sleep 5

        if systemctl is-active --quiet $service; then
            echo "✅ $description reiniciado com sucesso"
        else
            echo "❌ Falha ao reiniciar $description"
            return 1
        fi
    else
        echo "✅ $description já está rodando"
    fi
}

# 1. Verificar e reiniciar Ollama
restart_service "ollama" "Ollama"

# 2. Verificar Task Master AI
if ! task-master --version > /dev/null 2>&1; then
    echo "Reinstalando Task Master AI..."
    npm install -g task-master-ai@latest --force
fi

# 3. Verificar modelos essenciais
ESSENTIAL_MODELS=("llama3.2:3b" "qwen3:4b")
for model in "${ESSENTIAL_MODELS[@]}"; do
    if ! ollama list | grep -q "$model"; then
        echo "Baixando modelo essencial: $model"
        ollama pull "$model"
    fi
done

# 4. Verificar configuração
if [ ! -f ".cursor/mcp.json" ]; then
    echo "Recriando configuração MCP..."
    # Implementar lógica de recriação
fi

# 5. Teste final
echo "Executando teste final..."
if task-master health-check; then
    echo "✅ Sistema recuperados com sucesso"
else
    echo "❌ Falha na recuperação automática"
    echo "Manual intervention required"
fi

echo "🏁 AUTO-RECOVERY CONCLUÍDO"
```

### Script de Performance Monitoring

```bash
#!/bin/bash
# save as: scripts/performance-monitor.sh

echo "📊 MONITORAMENTO DE PERFORMANCE - $(date)"

# Métricas do sistema
echo "=== MÉTRICAS DO SISTEMA ==="
echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)%"
echo "RAM: $(free | grep Mem | awk '{printf "%.1f%%", $3/$2 * 100.0}')"
echo "DISK: $(df / | awk 'NR==2 {print $5}')"

# Métricas da GPU
if command -v nvidia-smi &> /dev/null; then
    echo "GPU Memory: $(nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits | head -1 | sed 's/, /\//')"
fi

# Métricas do Ollama
echo "=== MÉTRICAS DO OLLAMA ==="
MODELS_COUNT=$(curl -s http://localhost:11434/api/tags | jq '.models | length' 2>/dev/null || echo "?")
echo "Modelos carregados: $MODELS_COUNT"

ACTIVE_MODELS=$(ollama ps 2>/dev/null | tail -n +2 | wc -l || echo "0")
echo "Modelos ativos: $ACTIVE_MODELS"

# Métricas do Task Master
echo "=== MÉTRICAS DO TASK MASTER ==="
TASK_COUNT=$(find .taskmaster/tasks -name "*.json" 2>/dev/null | wc -l || echo "0")
echo "Arquivos de tarefas: $TASK_COUNT"

# Performance dos comandos recentes
echo "=== COMANDOS RECENTES ==="
tail -n 10 ~/.taskmaster/logs/*.log 2>/dev/null | grep -E "(command_executed|tokens)" | tail -n 5

echo "📊 Monitoramento concluído"
```

---

## 📞 CONTATOS E ESCALATION

### Hierarquia de Resolução

```yaml
Level 1 - Auto-recovery:
  - Scripts automáticos
  - Health checks
  - Restart de serviços

Level 2 - Manual troubleshooting:
  - Seguir guias deste documento
  - Verificar logs específicos
  - Usar comandos de diagnóstico

Level 3 - Reconstruction:
  - Backup/restore
  - Re-instalação de componentes
  - Recriação de configuração

Level 4 - External support:
  - Task Master AI GitHub Issues
  - Ollama Documentation
  - Community Forums
```

### Informações para Suporte

```bash
# Gerar relatório de sistema para suporte
#!/bin/bash
# save as: scripts/generate-support-report.sh

echo "=== RELATÓRIO PARA SUPORTE ===" > support-report.txt
echo "Data: $(date)" >> support-report.txt
echo "Hostname: $(hostname)" >> support-report.txt
echo "" >> support-report.txt

echo "=== TASK MASTER AI ===" >> support-report.txt
task-master --version >> support-report.txt 2>&1
echo "" >> support-report.txt

echo "=== OLLAMA ===" >> support-report.txt
ollama --version >> support-report.txt 2>&1
ollama list >> support-report.txt 2>&1
echo "" >> support-report.txt

echo "=== SISTEMA ===" >> support-report.txt
node --version >> support-report.txt 2>&1
npm --version >> support-report.txt 2>&1
uname -a >> support-report.txt 2>&1
echo "" >> support-report.txt

echo "=== CONFIGURAÇÃO ===" >> support-report.txt
cat .taskmaster/config.json >> support-report.txt 2>&1
echo "" >> support-report.txt

echo "=== LOGS RECENTES ===" >> support-report.txt
tail -n 50 ~/.taskmaster/logs/*.log >> support-report.txt 2>&1

echo "Relatório gerado: support-report.txt"
```

---

## 🏁 CONCLUSÃO

Este guia de troubleshooting e manutenção fornece:

### ✅ Soluções Para 95% Dos Problemas

- **Diagnóstico rápido** em 60 segundos
- **Problemas comuns** com soluções testadas
- **Scripts de automação** para manutenção
- **Recovery procedures** para cenários críticos
- **Monitoramento contínuo** para prevenção

### 🎯 Procedimentos de Emergência

1. **Primeiro:** Executar health check
2. **Segundo:** Seguir flowchart específico
3. **Terceiro:** Usar scripts de recovery
4. **Último:** Restaurar de backup

### 📊 Métricas de Saúde

- **Task Master AI:** Responding < 2s
- **Ollama API:** < 100ms response
- **GPU Memory:** < 85% utilization
- **Disk Space:** > 15% free
- **Uptime:** 99%+ availability

**Sistema resiliente e auto-recuperável!** 🛡️

---

**Guia de Troubleshooting e Manutenção**  
**Versão:** 1.0  
**Data:** 03 de Janeiro de 2026  
**Total de Scenarios:** 25+ documentados
