# 🚀 GUIA COMPLETO DE COMANDOS - TASK MASTER AI + OLLAMA

**Manual de Referência de Comandos**  
**Data:** 03 de Janeiro de 2026  
**Sistema:** Task Master AI v0.40.1 + Ollama Local

---

## 📋 ÍNDICE DE COMANDOS

1. [Comandos de Informações](#-comandos-de-informações)
2. [Gerenciamento de Tarefas](#-gerenciamento-de-tarefas)
3. [Geração com IA](#-geração-com-ia)
4. [Análise e Relatórios](#-análise-e-relatórios)
5. [Configuração e Setup](#-configuração-e-setup)
6. [Comandos de Desenvolvimento](#-comandos-de-desenvolvimento)
7. [Ollama Direct](#-ollama-direct)
8. [Troubleshooting](#-troubleshooting)
9. [Scripts e Automação](#-scripts-e-automação)

---

## 📊 COMANDOS DE INFORMAÇÕES

### Verificar Versão do Sistema

```bash
# Versão do Task Master AI
task-master --version
# Resultado esperado: v0.40.1

# Versão do Ollama
ollama --version
# Resultado esperado: ollama version is 0.13.3

# Versão do Node.js (instalação global)
node --version
# Resultado esperado: v24.12.0
```

### Listar Configuração Atual

```bash
# Ver modelos configurados
task-master models
# Mostra: main (ollama:llama3.2:3b), fallback, research

# Ver configuração detalhada
cat .taskmaster/config.json

# Ver variáveis de ambiente
cat .env
```

### Ajuda e Documentação

```bash
# Lista completa de comandos
task-master --help

# Ajuda específica de comando
task-master add-task --help
task-master expand --help
task-master analyze-complexity --help

# Ver ferramentas MCP disponíveis
npx -y task-master-ai --version
# Mostra: 14 tools registered
```

---

## 📝 GERENCIAMENTO DE TAREFAS

### Operações Básicas

```bash
# Ver próxima tarefa prioritária (USO DIÁRIO)
task-master next
# Resultado: Tarefa #1 com detalhes completos

# Listar todas as tarefas
task-master list
# Mostra: Dashboard com 1 tarefa + 3 subtasks

# Ver detalhes de tarefa específica
task-master get-task --id=1

# Ver estatísticas do projeto
task-master stats
```

### Criação de Tarefas

```bash
# Adicionar tarefa com IA (mais comum)
task-master add-task --prompt="Implementar sistema de autenticação JWT"
# Resultado: Tarefa criada via Ollama com título, descrição, detalhes

# Adicionar tarefa específica
task-master add-task --title="Debug API" --description="Corrigir bug na rota /users" --priority=high

# Adicionar tarefa com prazo
task-master add-task --prompt="Implementar testes E2E" --due-date="2026-01-10"

# Adicionar múltiplas tarefas
task-master add-tasks --file=tarefas.csv
```

### Edição de Tarefas

```bash
# Atualizar status da tarefa
task-master set-status --id=1 --status=in-progress
task-master set-status --id=1 --status=completed
task-master set-status --id=1 --status=blocked

# Atualizar prioridade
task-master set-priority --id=1 --priority=high

# Atualizar tarefa completa
task-master update-task 1 "Novos requisitos da tarefa"

# Atualizar data de vencimento
task-master set-due-date --id=1 --date="2026-01-15"
```

### Remoção de Tarefas

```bash
# Remover tarefa
task-master remove-task --id=1

# Remover tarefa com confirmação
task-master remove-task --id=1 --confirm

# Limpar todas as tarefas concluídas
task-master clean-completed

# Remover tarefa e subtasks
task-master remove-task --id=1 --recursive
```

---

## 🤖 GERAÇÃO COM IA

### Expansão de Tarefas

```bash
# Expandir tarefa em subtasks (comum)
task-master expand --id=1 --num=5
# Resultado: 5 subtasks geradas via IA

# Expandir com modelo específico
task-master expand --id=1 --model=ollama:qwen3:4b --num=3

# Expandir todas as tarefas pendentes
task-master expand --all
# Expande todas as tarefas com status "pending"

# Expandir com threshold de complexidade
task-master expand --threshold=5 --num=3
# Só expande tarefas com complexidade >= 5
```

### Pesquisa e Análise com IA

```bash
# Pesquisa contextual (muito útil)
task-master research "Como implementar rate limiting em Node.js?"
# Resultado: Resposta detalhada em português com contexto

# Pesquisa com modelo específico
task-master research "Best practices React hooks" --model=anthropic:claude-3-7-sonnet

# Pesquisa com múltiplas fontes
task-master research "Docker optimization" --sources=web,documentation

# Análise de código
task-master analyze-code --file=src/auth.js --model=ollama:qwen3:4b
```

### Geração de Conteúdo

```bash
# Gerar documentação
task-master generate-docs --type=README --output=README.md

# Gerar testes
task-master generate-tests --file=src/utils.js --framework=jest

# Gerar commit message
task-master git-commit-message --diff=HEAD~1

# Gerar changelog
task-master generate-changelog --from=v1.0.0 --to=current
```

---

## 📊 ANÁLISE E RELATÓRIOS

### Análise de Complexidade

```bash
# Análise completa (comum)
task-master analyze-complexity --threshold=3
# Resultado: 4 análises geradas, scores 6-9/10

# Análise detalhada
task-master analyze-complexity --detailed --output=complexity-analysis.json

# Análise por categoria
task-master analyze-complexity --category=backend --threshold=5

# Análise comparativa
task-master analyze-complexity --compare --baseline=last-week
```

### Relatórios

```bash
# Gerar relatório de complexidade
task-master complexity-report
# Salva: .taskmaster/reports/task-complexity-report.json

# Relatório de produtividade
task-master productivity-report --period=week

# Relatório de tempo
task-master time-report --from="2026-01-01" --to="2026-01-31"

# Exportar dados
task-master export --format=csv --output=task-report.csv
task-master export --format=json --output=task-report.json
```

### Sincronização

```bash
# Sincronizar com README
task-master sync-readme --with-subtasks
# Atualiza seção "Tasks" no README.md

# Sincronizar com Issues do GitHub
task-master sync-github --repo=username/repo

# Backup do estado
task-master backup --output=backup-$(date +%Y%m%d).json

# Importar tarefas
task-master import --file=tarefas-import.json
```

---

## ⚙️ CONFIGURAÇÃO E SETUP

### Inicialização

```bash
# Inicializar novo projeto (comum)
task-master init --name="Meu Projeto" --description="Descrição do projeto" --author="Seu Nome"
# Cria: .taskmaster/ com estrutura completa

# Inicializar projeto existente
task-master init --existing

# Inicializar com template
task-master init --template=javascript --name="API Node.js"
```

### Configuração de Modelos

```bash
# Ver configuração atual
task-master models

# Configurar modelo principal (Ollama)
task-master models --ollama --set-main llama3.2:3b

# Configurar modelo para código
task-master models --ollama --set-code qwen3:4b

# Configurar modelo de pesquisa
task-master models --perplexity --set-research sonar

# Configuração interativa completa
task-master models --setup
# Interface wizard para configurar todos os modelos
```

### Configuração Avançada

```bash
# Configurar idioma de resposta
task-master config --set responseLanguage="Português"

# Configurar número padrão de tarefas
task-master config --set defaultNumTasks=15

# Configurar modelos múltiplos
task-master config --add-model ollama:mistral:7b --role=coding

# Ver configuração completa
task-master config --list
```

---

## 🛠️ COMANDOS DE DESENVOLVIMENTO

### Servidor MCP

```bash
# Iniciar servidor MCP standalone (debug)
task-master-mcp
# Modo interativo para testes MCP

# Testar servidor MCP
npx -y task-master-ai --version
# Mostra: 14 tools registered successfully

# Servidor MCP com debug
DEBUG=* npx -y task-master-ai

# Testar ferramenta MCP específica
echo '{"method":"tools/call","params":{"name":"get_tasks"}}' | npx -y task-master-ai
```

### Parseamento de Documentos

```bash
# Parsear PRD (Product Requirements Document)
task-master parse-prd --input=PRD.md --num-tasks=10
# Gera tarefas baseado no PRD

# Parsear arquivo de requisitos
task-master parse-requirements --file=requirements.txt --format=text

# Parsear commit messages
task-master parse-commits --since="2026-01-01"

# Extrair tarefas de issue tracker
task-master parse-issues --provider=github --repo=username/repo
```

### Integração com Git

```bash
# Classificar commit
tools/git-commit-classify.sh "feat: implement user authentication"

# Gerar mensagem de commit baseada em diff
task-master git-commit-message --diff=HEAD~1

# Analisar impacto de mudanças
task-master analyze-impact --diff=HEAD~5

# Sugerir próximas tarefas baseado em código
task-master suggest-tasks --analyze-repo
```

### Testes e Validação

```bash
# Validar configuração
task-master validate-config

# Testar conectividade com Ollama
task-master test-ollama --model=llama3.2:3b

# Testar todas as ferramentas MCP
task-master test-mcp-tools

# Benchmark de performance
task-master benchmark --iterations=10
```

---

## 🤖 OLLAMA DIRECT

### Gerenciamento de Modelos

```bash
# Listar modelos instalados
ollama list
# Mostra: 7 modelos incluindo llama3.2:3b, qwen3:4b

# Baixar novo modelo
ollama pull codellama:7b
ollama pull mistral:7b
ollama pull deepseek-coder:6.7b

# Remover modelo
ollama rm gpt-oss:latest

# Informações do modelo
ollama show llama3.2:3b
```

### Execução Direta

```bash
# Executar modelo interativamente
ollama run llama3.2:3b
# Entrada: "Explique o que é React em português"
# Saída: Explicação detalhada

# Executar com prompt específico
ollama run llama3.2:3b "Write a Python function to calculate fibonacci"

# Executar com configurações
ollama run llama3.2:3b --verbose --debug

# Executar modelo de código
ollama run qwen3:4b "Review this React component for best practices"
```

### API Direct

```bash
# Testar API de listagem
curl -s http://localhost:11434/api/tags | jq '.models[].name'

# Testar geração de texto
curl -s http://localhost:11434/api/generate \
  -d '{
    "model": "llama3.2:3b",
    "prompt": "Explique Docker em português",
    "stream": false
  }' | jq '.response'

# Chat com modelo
curl -s http://localhost:11434/api/chat \
  -d '{
    "model": "llama3.2:3b",
    "messages": [
      {"role": "user", "content": "Hello"}
    ]
  }' | jq '.message.content'
```

---

## 🔧 TROUBLESHOOTING

### Diagnóstico de Saúde

```bash
# Health check completo
task-master health-check
# Verifica: Ollama, modelos, configuração, conectividade

# Verificar status dos serviços
systemctl status ollama
ps aux | grep task-master

# Testar conectividade Ollama
curl -s http://localhost:11434/api/tags > /dev/null && echo "✅ Ollama OK" || echo "❌ Ollama FAIL"

# Verificar modelos disponíveis
ollama list | grep llama3.2:3b && echo "✅ Modelo principal OK" || echo "❌ Modelo principal FAIL"
```

### Logs e Debug

```bash
# Ver logs do Task Master
tail -f ~/.taskmaster/logs/*.log

# Logs do Ollama
journalctl -u ollama -f

# Debug MCP no Cursor AI
# Logs aparecem no console do Cursor

# Verbose mode para comandos
DEBUG=* task-master next

# Logs estruturados
task-master --log-level=debug next
```

### Recuperação de Problemas

```bash
# Reiniciar Ollama
sudo systemctl restart ollama

# Reinstalar Task Master AI
npm install -g task-master-ai@latest --force

# Resetar configuração
task-master config --reset

# Limpar cache
task-master cache --clear

# Restaurar backup
task-master restore --file=backup-20260103.json
```

---

## 📜 SCRIPTS E AUTOMAÇÃO

### Script de Health Check

```bash
#!/bin/bash
# save as: scripts/health-check.sh

echo "=== AURORA PROJECT HEALTH CHECK ==="
echo "Data: $(date)"
echo ""

echo "1. Task Master AI:"
task-master --version && echo "   ✅ OK" || echo "   ❌ FAIL"

echo "2. Ollama Service:"
curl -s http://localhost:11434/api/tags > /dev/null && echo "   ✅ OK" || echo "   ❌ FAIL"

echo "3. Modelos Ollama:"
ollama list | grep llama3.2:3b > /dev/null && echo "   ✅ Principal OK" || echo "   ❌ Principal FAIL"

echo "4. Configuração MCP:"
[ -f .cursor/mcp.json ] && echo "   ✅ Cursor config OK" || echo "   ❌ Cursor config FAIL"
[ -f .vscode/mcp.json ] && echo "   ✅ VSCode config OK" || echo "   ❌ VSCode config FAIL"

echo "5. Estado do Projeto:"
[ -f .taskmaster/config.json ] && echo "   ✅ Task Master config OK" || echo "   ❌ Task Master config FAIL"

echo ""
echo "=== END HEALTH CHECK ==="
```

### Script de Backup Automatizado

```bash
#!/bin/bash
# save as: scripts/backup.sh

BACKUP_DIR="$HOME/.taskmaster-backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup-$DATE.tar.gz"

echo "Criando backup: $BACKUP_FILE"

# Criar diretório se não existir
mkdir -p $BACKUP_DIR

# Fazer backup dos arquivos importantes
tar -czf $BACKUP_FILE \
    .taskmaster/ \
    .env \
    .cursor/mcp.json \
    .vscode/mcp.json \
    --exclude='*.log' \
    --exclude='node_modules'

echo "Backup criado: $BACKUP_FILE"
echo "Tamanho: $(du -h $BACKUP_FILE | cut -f1)"
```

### Script de Atualização

```bash
#!/bin/bash
# save as: scripts/update.sh

echo "=== ATUALIZANDO AURORA PROJECT ==="

# Backup antes da atualização
echo "1. Criando backup..."
./scripts/backup.sh

# Atualizar Task Master AI
echo "2. Atualizando Task Master AI..."
npm update -g task-master-ai

# Atualizar Ollama
echo "3. Verificando Ollama..."
ollama --version

# Verificar integridade
echo "4. Verificando integridade..."
task-master health-check

echo "5. Teste final..."
task-master --version > /dev/null && echo "   ✅ Atualização bem-sucedida" || echo "   ❌ Falha na atualização"

echo "=== ATUALIZAÇÃO CONCLUÍDA ==="
```

### Aliases Úteis

```bash
# Adicionar ao ~/.bashrc ou ~/.zshrc

# Aliases para uso diário
alias tm-next='task-master next'
alias tm-list='task-master list'
alias tm-add='task-master add-task --prompt'
alias tm-expand='task-master expand --id'
alias tm-analyze='task-master analyze-complexity'
alias tm-research='task-master research'

# Aliases para desenvolvimento
alias tm-health='task-master health-check'
alias tm-mcp='npx -y task-master-ai'
alias ollama-list='ollama list'
alias ollama-test='ollama run llama3.2:3b'

# Aliases para troubleshooting
alias tm-logs='tail -f ~/.taskmaster/logs/*.log'
alias ollama-logs='journalctl -u ollama -f'
alias tm-debug='DEBUG=* task-master'
```

---

## 📈 MÉTRICAS E MONITORAMENTO

### Comandos de Métricas

```bash
# Estatísticas de uso
task-master usage-stats --period=week

# Performance dos modelos
task-master model-performance --model=ollama:llama3.2:3b

# Tokens consumidos
task-master tokens-usage --from="2026-01-01"

# Comandos mais usados
task-master top-commands --limit=10
```

### Monitoramento em Tempo Real

```bash
# Monitor de recursos
watch -n 5 'ps aux | grep -E "(ollama|task-master)" | grep -v grep'

# Monitor de rede local
watch -n 2 'netstat -tuln | grep 11434'

# Monitor de GPU (se disponível)
watch -n 5 'nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits'
```

---

## 🎯 CASOS DE USO AVANÇADOS

### Workflow Completo de Desenvolvimento

```bash
# 1. Iniciar dia - ver próxima tarefa
tm-next

# 2. Se tarefa muito complexa, expandir
tm-expand --id=$(task-master next --id-only) --num=5

# 3. Pesquisar contexto se necessário
tm-research "Como implementar [tecnologia específica]"

# 4. Implementar e marcar como concluído
task-master set-status --id=1 --status=completed

# 5. Analisar próxima tarefa
tm-next

# 6. No final do dia - relatório
task-master productivity-report --period=day
```

### Análise de Projeto

```bash
# 1. Análise inicial
task-master analyze-complexity --detailed

# 2. Relatório de complexidade
task-master complexity-report --output=project-analysis.json

# 3. Sincronizar com documentação
task-master sync-readme --with-subtasks

# 4. Backup do estado
task-master backup --output=project-state-$(date +%Y%m%d).json
```

---

## 📚 REFERÊNCIA RÁPIDA

### Top 10 Comandos Mais Usados

| Comando                          | Uso                     | Frequência |
| -------------------------------- | ----------------------- | ---------- |
| `task-master next`               | Ver próxima tarefa      | Diário     |
| `task-master list`               | Listar todas as tarefas | Diário     |
| `task-master add-task`           | Adicionar tarefa com IA | Frequente  |
| `task-master expand`             | Expandir tarefa         | Frequente  |
| `task-master research`           | Pesquisa contextual     | Ocasional  |
| `task-master set-status`         | Atualizar status        | Frequente  |
| `task-master analyze-complexity` | Análise de projeto      | Semanal    |
| `task-master models`             | Ver configuração        | Ocasional  |
| `ollama list`                    | Ver modelos             | Debug      |
| `task-master health-check`       | Verificar sistema       | Debug      |

### Shortcuts Recomendados

```bash
# No ~/.bashrc
export PATH="$PATH:$HOME/.local/bin"
alias tmn='task-master next'
alias tml='task-master list'
alias tma='task-master add-task --prompt'
alias tme='task-master expand --id'
alias tms='task-master set-status --id'
alias tmc='task-master analyze-complexity'
alias tmr='task-master research'
alias tmh='task-master health-check'
```

---

## 🏁 CONCLUSÃO

Este guia consolida todos os comandos disponíveis no sistema Task Master AI + Ollama, organizados por categoria e caso de uso. O sistema oferece:

### ✅ Funcionalidades Principais

- **20+ comandos CLI** principais
- **14 ferramentas MCP** disponíveis via IDE
- **Geração com IA** local via Ollama
- **Análise avançada** de projetos
- **Integração completa** com Cursor AI/VS Code

### 🎯 Para Uso Diário

Comece com os comandos básicos:

```bash
task-master next          # Ver próxima tarefa
task-master add-task      # Adicionar nova tarefa
task-master expand        # Expandir tarefa complexa
task-master research      # Pesquisar contexto
```

### 🚀 Para Desenvolvimento

Use os comandos avançados:

```bash
task-master analyze-complexity  # Análise de projeto
task-master complexity-report   # Relatórios
npx -y task-master-ai           # Debug MCP
ollama run llama3.2:3b          # Teste direto de modelo
```

**Sistema pronto para uso em produção!** 🎉

---

**Guia Completo de Comandos**  
**Versão:** 1.0  
**Data:** 03 de Janeiro de 2026  
**Total de Comandos:** 50+ documentados
