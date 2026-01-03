# 📋 REFERÊNCIA COMPLETA DE CONFIGURAÇÕES - TASK MASTER AI + OLLAMA

**Manual de Referência de Configurações**  
**Data:** 03 de Janeiro de 2026  
**Sistema:** Task Master AI v0.40.1 + Ollama v0.13.3

---

## 📋 ÍNDICE DE CONFIGURAÇÕES

1. [Estrutura de Arquivos](#-estrutura-de-arquivos)
2. [Variáveis de Ambiente (.env)](#-variáveis-de-ambiente-env)
3. [Configuração MCP Cursor (.cursor/mcp.json)](#-configuração-mcp-cursor-cursormcpjson)
4. [Configuração MCP VS Code (.vscode/mcp.json)](#-configuração-mcp-vs-code-vscodemcpjson)
5. [Configuração Task Master (.taskmaster/config.json)](#-configuração-task-master-taskmasterconfigjson)
6. [Configuração de Modelos](#-configuração-de-modelos)
7. [Configurações do Sistema](#-configurações-do-sistema)
8. [Templates de Configuração](#-templates-de-configuração)
9. [Validação de Configurações](#-validação-de-configurações)
10. [Migração e Backup](#-migração-e-backup)

---

## 📁 ESTRUTURA DE ARQUIVOS

### Hierarquia Completa

```
/home/helton/git/aurora/
├── .env                                    # Variáveis de ambiente globais
├── .taskmaster/                            # Configuração principal Task Master
│   ├── config.json                         # Configuração de modelos e global
│   ├── state.json                          # Estado atual do projeto
│   ├── tasks/                              # Gerenciamento de tarefas
│   │   └── tasks.json                      # Tarefas em formato JSON
│   ├── docs/                               # Documentação do projeto
│   ├── reports/                            # Relatórios gerados
│   │   └── task-complexity-report.json     # Relatório de complexidade
│   └── templates/                          # Templates de documentos
├── .cursor/                                # Configuração específica Cursor AI
│   ├── mcp.json                            # Configuração MCP principal
│   ├── commands/                           # Comandos personalizados (20+)
│   └── rules/                              # Regras de comportamento
├── .vscode/                                # Configuração para VS Code
│   └── mcp.json                            # Configuração MCP espelhada
├── scripts/                                # Scripts de automação
│   ├── health-check.sh                     # Health check automatizado
│   ├── backup.sh                           # Backup automatizado
│   ├── update.sh                           # Script de atualização
│   ├── auto-recovery.sh                    # Recovery automático
│   ├── performance-monitor.sh              # Monitor de performance
│   └── generate-support-report.sh          # Relatório para suporte
└── tools/                                  # Ferramentas auxiliares
    └── git-commit-classify.sh              # Classificador de commits Git
```

### Propósitos dos Arquivos

| Arquivo/Diretório              | Propósito               | Frequência de Edição |
| ------------------------------ | ----------------------- | -------------------- |
| `.env`                         | Variáveis de ambiente   | Rara                 |
| `.taskmaster/config.json`      | Configuração de modelos | Ocasional            |
| `.cursor/mcp.json`             | Integração Cursor AI    | Rara                 |
| `.vscode/mcp.json`             | Integração VS Code      | Rara                 |
| `.taskmaster/tasks/tasks.json` | Dados das tarefas       | Frequente            |
| `scripts/`                     | Automação               | Ocasional            |

---

## 🔧 VARIÁVEIS DE AMBIENTE (.env)

### Arquivo Completo

```bash
# =====================================================
# CONFIGURAÇÃO COMPLETA DE VARIÁVEIS DE AMBIENTE
# TASK MASTER AI + OLLAMA LOCAL
# =====================================================

# ====================
# OLLAMA CONFIGURATION
# ====================
OLLAMA_API_KEY=""
OLLAMA_BASE_URL="http://localhost:11434/api"

# ====================
# TASK MASTER TOOLS
# ====================
TASK_MASTER_TOOLS="standard"

# ====================
# AI PROVIDERS API KEYS
# ====================
ANTHROPIC_API_KEY=""
PERPLEXITY_API_KEY=""
OPENAI_API_KEY=""
GOOGLE_API_KEY=""
MISTRAL_API_KEY=""
XAI_API_KEY=""
GROQ_API_KEY=""
OPENROUTER_API_KEY=""
AZURE_OPENAI_API_KEY=""
GITHUB_API_KEY=""

# ====================
# DEBUGGING & LOGGING
# ====================
DEBUG="false"
LOG_LEVEL="info"
ANONYMOUS_TELEMETRY="true"

# ====================
# TASK MASTER SETTINGS
# ====================
PROJECT_NAME="Aurora Project"
RESPONSE_LANGUAGE="Português"
ENABLE_CODEBASE_ANALYSIS="true"
ENABLE_PROXY="false"
DEFAULT_NUM_TASKS="10"
DEFAULT_SUBTASKS="5"
DEFAULT_PRIORITY="medium"
```

### Descrição Detalhada das Variáveis

#### Configuração Ollama

```bash
# URL base da API Ollama
OLLAMA_BASE_URL="http://localhost:11434/api"

# Chave de API (vazia para uso local)
OLLAMA_API_KEY=""
```

**Configurações Alternativas:**

```bash
# Para Ollama remoto
OLLAMA_BASE_URL="https://ollama.exemplo.com/api"

# Para Ollama com autenticação
OLLAMA_BASE_URL="http://localhost:11434/api"
OLLAMA_API_KEY="sua_chave_api_aqui"
```

#### Configuração de Ferramentas

```bash
# Modo de ferramentas Task Master
TASK_MASTER_TOOLS="standard"  # ou "advanced" ou "minimal"
```

**Opções Disponíveis:**

- `standard`: 14 ferramentas (padrão)
- `advanced`: Todas as ferramentas + experimentais
- `minimal`: Apenas ferramentas essenciais

#### APIs de Provedores de IA

```bash
# Anthropic (Claude)
ANTHROPIC_API_KEY=""

# Perplexity (Pesquisa)
PERPLEXITY_API_KEY=""

# OpenAI (GPT-4, etc.)
OPENAI_API_KEY=""

# Google (Gemini)
GOOGLE_API_KEY=""

# Outros provedores
MISTRAL_API_KEY=""
XAI_API_KEY=""
GROQ_API_KEY=""
OPENROUTER_API_KEY=""
AZURE_OPENAI_API_KEY=""
```

**Configuração para Produção:**

```bash
# Adicionar chaves reais (NUNCA no Git!)
ANTHROPIC_API_KEY="sk-ant-..."
PERPLEXITY_API_KEY="pplx-..."
OPENAI_API_KEY="sk-..."
```

#### Configurações de Debug

```bash
# Modo debug (produção: false)
DEBUG="false"

# Nível de log (error, warn, info, debug)
LOG_LEVEL="info"

# Telemetria anônima
ANONYMOUS_TELEMETRY="true"
```

**Configurações para Desenvolvimento:**

```bash
DEBUG="true"
LOG_LEVEL="debug"
ANONYMOUS_TELEMETRY="false"
```

#### Configurações do Projeto

```bash
# Nome do projeto
PROJECT_NAME="Aurora Project"

# Idioma de resposta
RESPONSE_LANGUAGE="Português"  # ou "English", "Español", etc.

# Análise de codebase
ENABLE_CODEBASE_ANALYSIS="true"

# Proxy (se necessário)
ENABLE_PROXY="false"

# Padrões para criação de tarefas
DEFAULT_NUM_TASKS="10"
DEFAULT_SUBTASKS="5"
DEFAULT_PRIORITY="medium"  # low, medium, high, critical
```

---

## 🔗 CONFIGURAÇÃO MCP CURSOR (.cursor/mcp.json)

### Configuração Completa

```json
{
  "mcpServers": {
    "task-master-ai": {
      "command": "npx",
      "args": ["-y", "task-master-ai"],
      "env": {
        "TASK_MASTER_TOOLS": "standard",
        "OLLAMA_BASE_URL": "http://localhost:11434/api",
        "OLLAMA_API_KEY": "",
        "ANTHROPIC_API_KEY": "",
        "PERPLEXITY_API_KEY": "",
        "OPENAI_API_KEY": "",
        "GOOGLE_API_KEY": "",
        "XAI_API_KEY": "",
        "OPENROUTER_API_KEY": "",
        "MISTRAL_API_KEY": "",
        "AZURE_OPENAI_API_KEY": "",
        "GROQ_API_KEY": "",
        "GITHUB_API_KEY": "",
        "LOG_LEVEL": "info",
        "DEBUG": "false"
      },
      "disabled": false,
      "timeout": 30000,
      "retryLimit": 3
    }
  },
  "global": {
    "enableAnalytics": true,
    "enableErrorReporting": false,
    "logLevel": "info"
  }
}
```

### Parâmetros Detalhados

#### Configuração do Servidor

```json
{
  "command": "npx",
  "args": ["-y", "task-master-ai"],
  "env": { ... },
  "disabled": false,
  "timeout": 30000,
  "retryLimit": 3
}
```

**Parâmetros Explicados:**

- `command`: Comando para executar o servidor
- `args`: Argumentos passados para o comando
- `env`: Variáveis de ambiente específicas para MCP
- `disabled`: Se o servidor está desabilitado
- `timeout`: Timeout em millisegundos (30s = 30000ms)
- `retryLimit`: Número de tentativas em caso de falha

#### Configurações Alternativas

**Para Debug:**

```json
{
  "timeout": 60000,
  "retryLimit": 5,
  "env": {
    "DEBUG": "true",
    "LOG_LEVEL": "debug"
  }
}
```

**Para Produção:**

```json
{
  "timeout": 15000,
  "retryLimit": 2,
  "env": {
    "DEBUG": "false",
    "LOG_LEVEL": "warn"
  }
}
```

**Para Múltiplos Servidores:**

```json
{
  "mcpServers": {
    "task-master-ai": {
      "command": "npx",
      "args": ["-y", "task-master-ai"],
      "env": { ... }
    },
    "outro-servidor": {
      "command": "outro-comando",
      "args": ["--param"],
      "env": { ... }
    }
  }
}
```

---

## 💻 CONFIGURAÇÃO MCP VS CODE (.vscode/mcp.json)

### Configuração Completa

```json
{
  "mcpServers": {
    "task-master-ai": {
      "command": "npx",
      "args": ["-y", "task-master-ai"],
      "env": {
        "TASK_MASTER_TOOLS": "standard",
        "OLLAMA_BASE_URL": "http://localhost:11434/api",
        "OLLAMA_API_KEY": "",
        "ANTHROPIC_API_KEY": "",
        "PERPLEXITY_API_KEY": "",
        "OPENAI_API_KEY": "",
        "GOOGLE_API_KEY": "",
        "XAI_API_KEY": "",
        "OPENROUTER_API_KEY": "",
        "MISTRAL_API_KEY": "",
        "AZURE_OPENAI_API_KEY": "",
        "GROQ_API_KEY": "",
        "GITHUB_API_KEY": "",
        "LOG_LEVEL": "info",
        "DEBUG": "false"
      },
      "disabled": false,
      "timeout": 30000,
      "retryLimit": 3
    }
  }
}
```

### Diferenças do Cursor AI

```json
{
  "global": {
    // VS Code não usa global na configuração MCP
  }
}
```

**Nota:** A configuração do VS Code é essentially idêntica ao Cursor, exceto pela seção `global` que não é suportada.

---

## 🛠️ CONFIGURAÇÃO TASK MASTER (.taskmaster/config.json)

### Configuração Completa

```json
{
  "models": {
    "main": {
      "provider": "ollama",
      "modelId": "llama3.2:3b",
      "maxTokens": 64000,
      "temperature": 0.2,
      "top_p": 0.9,
      "repeat_penalty": 1.1,
      "baseURL": "http://localhost:11434/api"
    },
    "code": {
      "provider": "ollama",
      "modelId": "qwen3:4b",
      "maxTokens": 32000,
      "temperature": 0.1,
      "top_p": 0.8,
      "repeat_penalty": 1.05,
      "baseURL": "http://localhost:11434/api"
    },
    "research": {
      "provider": "perplexity",
      "modelId": "sonar",
      "maxTokens": 8700,
      "temperature": 0.1,
      "top_p": 0.9
    },
    "fallback": {
      "provider": "anthropic",
      "modelId": "claude-3-7-sonnet-20250219",
      "maxTokens": 120000,
      "temperature": 0.2,
      "top_p": 0.9
    }
  },
  "global": {
    "logLevel": "info",
    "debug": false,
    "defaultNumTasks": 10,
    "defaultSubtasks": 5,
    "defaultPriority": "medium",
    "projectName": "Aurora Project",
    "ollamaBaseURL": "http://localhost:11434/api",
    "responseLanguage": "Português",
    "enableCodebaseAnalysis": true,
    "enableProxy": false,
    "anonymousTelemetry": true,
    "mcpIntegration": true,
    "cursorIntegration": true,
    "vscodeIntegration": true,
    "maxConcurrentRequests": 3,
    "enableCache": true,
    "cacheTimeout": 3600
  },
  "mcp": {
    "enabled": true,
    "serverName": "task-master-ai",
    "toolsMode": "standard",
    "timeout": 30000,
    "retryLimit": 3,
    "healthCheckInterval": 300,
    "enableMetrics": true
  },
  "advanced": {
    "customTemplates": {
      "task": "templates/custom-task.md",
      "report": "templates/custom-report.md"
    },
    "integrations": {
      "github": {
        "enabled": false,
        "token": "",
        "owner": "",
        "repo": ""
      },
      "jira": {
        "enabled": false,
        "url": "",
        "username": "",
        "token": ""
      }
    },
    "customCommands": {
      "enabled": true,
      "path": ".cursor/commands"
    }
  }
}
```

### Seção Models (Modelos de IA)

#### Modelo Principal

```json
"main": {
  "provider": "ollama",
  "modelId": "llama3.2:3b",
  "maxTokens": 64000,
  "temperature": 0.2,
  "top_p": 0.9,
  "repeat_penalty": 1.1,
  "baseURL": "http://localhost:11434/api"
}
```

**Parâmetros Explicados:**

- `provider`: Provedor do modelo (ollama, anthropic, openai, etc.)
- `modelId`: Identificador do modelo
- `maxTokens`: Máximo de tokens para resposta
- `temperature`: Criatividade (0.0 = determinístico, 1.0 = criativo)
- `top_p`: Nucleus sampling (0.9 = 90% dos tokens mais prováveis)
- `repeat_penalty`: Penalidade para repetição (1.0 = sem penalidade)
- `baseURL`: URL base para APIs HTTP

#### Configurações Alternativas de Modelos

**Para Modelos OpenAI:**

```json
"main": {
  "provider": "openai",
  "modelId": "gpt-4-turbo-preview",
  "maxTokens": 4000,
  "temperature": 0.3,
  "top_p": 0.9,
  "baseURL": "https://api.openai.com/v1"
}
```

**Para Modelos Anthropic:**

```json
"fallback": {
  "provider": "anthropic",
  "modelId": "claude-3-5-sonnet-20241022",
  "maxTokens": 8000,
  "temperature": 0.2,
  "top_p": 0.9,
  "baseURL": "https://api.anthropic.com"
}
```

### Seção Global

```json
"global": {
  "logLevel": "info",
  "debug": false,
  "defaultNumTasks": 10,
  "defaultSubtasks": 5,
  "defaultPriority": "medium",
  "projectName": "Aurora Project",
  "ollamaBaseURL": "http://localhost:11434/api",
  "responseLanguage": "Português",
  "enableCodebaseAnalysis": true,
  "enableProxy": false,
  "anonymousTelemetry": true,
  "mcpIntegration": true,
  "cursorIntegration": true,
  "vscodeIntegration": true,
  "maxConcurrentRequests": 3,
  "enableCache": true,
  "cacheTimeout": 3600
}
```

**Configurações para Produção:**

```json
"global": {
  "logLevel": "warn",
  "debug": false,
  "anonymousTelemetry": false,
  "maxConcurrentRequests": 5,
  "enableCache": true,
  "cacheTimeout": 7200
}
```

**Configurações para Desenvolvimento:**

```json
"global": {
  "logLevel": "debug",
  "debug": true,
  "anonymousTelemetry": false,
  "maxConcurrentRequests": 1,
  "enableCache": false
}
```

---

## 🤖 CONFIGURAÇÃO DE MODELOS

### Lista de Modelos Suportados

#### Modelos Ollama (Locais)

| Modelo                | Tamanho | Parâmetros | Uso Recomendado              |
| --------------------- | ------- | ---------- | ---------------------------- |
| `llama3.2:3b`         | 2.0GB   | 3.2B       | Tarefas gerais, expansão     |
| `llama3.2:1b`         | 1.0GB   | 1.0B       | Tarefas simples, performance |
| `qwen3:4b`            | 2.5GB   | 4.0B       | Programação, código          |
| `qwen3:1.5b`          | 1.0GB   | 1.5B       | Programação leve             |
| `codellama:7b`        | 3.8GB   | 7.0B       | Desenvolvimento avançado     |
| `mistral:7b`          | 4.1GB   | 7.0B       | Tarefas gerais avançadas     |
| `deepseek-coder:6.7b` | 3.9GB   | 6.7B       | Programação especializada    |

#### Modelos de APIs Externas

| Provedor       | Modelos Principais                   | Custo Aproximado     |
| -------------- | ------------------------------------ | -------------------- |
| **Anthropic**  | claude-3-7-sonnet, claude-3-5-sonnet | $3-15/1M tokens      |
| **OpenAI**     | gpt-4-turbo, gpt-4, gpt-3.5-turbo    | $0.01-0.03/1K tokens |
| **Google**     | gemini-pro, gemini-pro-vision        | $0.0005/1K tokens    |
| **Perplexity** | sonar, sonar-small                   | $5/1M tokens         |

### Configuração de Performance

#### Para GTX 1650 4GB (Configuração Atual)

```json
{
  "main": {
    "provider": "ollama",
    "modelId": "llama3.2:3b",
    "maxTokens": 32000,
    "temperature": 0.2
  },
  "code": {
    "provider": "ollama",
    "modelId": "qwen3:4b",
    "maxTokens": 16000,
    "temperature": 0.1
  }
}
```

#### Para GPUs Mais Poderosas

```json
{
  "main": {
    "provider": "ollama",
    "modelId": "mistral:7b",
    "maxTokens": 64000,
    "temperature": 0.2
  },
  "code": {
    "provider": "ollama",
    "modelId": "codellama:7b",
    "maxTokens": 32000,
    "temperature": 0.1
  }
}
```

#### Para CPUs (Sem GPU)

```json
{
  "main": {
    "provider": "ollama",
    "modelId": "llama3.2:1b",
    "maxTokens": 16000,
    "temperature": 0.2,
    "cpuOnly": true
  },
  "fallback": {
    "provider": "anthropic",
    "modelId": "claude-3-haiku-20240307",
    "maxTokens": 4000,
    "temperature": 0.2
  }
}
```

---

## ⚙️ CONFIGURAÇÕES DO SISTEMA

### Configuração do Ollama

#### SystemD Service

```ini
# /etc/systemd/system/ollama.service
[Unit]
Description=Ollama Service
After=network.target

[Service]
Type=notify
ExecStart=/usr/local/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3
Environment="OLLAMA_HOST=0.0.0.0:11434"
Environment="OLLAMA_ORIGINS=*"
Environment="OLLAMA_MAX_LOADED_MODELS=2"
Environment="OLLAMA_MAX_QUEUE=5"

[Install]
WantedBy=multi-user.target
```

#### Variáveis de Ambiente do Ollama

```bash
# /etc/environment ou ~/.bashrc
export OLLAMA_HOST="0.0.0.0:11434"
export OLLAMA_ORIGINS="*"
export OLLAMA_MAX_LOADED_MODELS="2"
export OLLAMA_MAX_QUEUE="5"
export OLLAMA_FLASH_ATTENTION="1"
```

### Configuração do Node.js

#### NVM Configuration

```bash
# ~/.nvm/nvmrc
20.12.0
```

#### NPM Global Config

```bash
# ~/.npmrc
prefix=/home/helton/.config/nvm/versions/node/v24.12.0
cache=/home/helton/.npm
```

---

## 📄 TEMPLATES DE CONFIGURAÇÃO

### Template Básico (.env)

```bash
# Template básico para novo projeto
OLLAMA_BASE_URL="http://localhost:11434/api"
OLLAMA_API_KEY=""
TASK_MASTER_TOOLS="standard"
LOG_LEVEL="info"
DEBUG="false"
PROJECT_NAME="Nome do Projeto"
RESPONSE_LANGUAGE="Português"
ENABLE_CODEBASE_ANALYSIS="true"
DEFAULT_NUM_TASKS="10"
DEFAULT_SUBTASKS="5"
DEFAULT_PRIORITY="medium"
```

### Template de Desenvolvimento

```json
{
  "mcpServers": {
    "task-master-ai": {
      "command": "npx",
      "args": ["-y", "task-master-ai"],
      "env": {
        "TASK_MASTER_TOOLS": "advanced",
        "DEBUG": "true",
        "LOG_LEVEL": "debug"
      },
      "timeout": 60000,
      "retryLimit": 5
    }
  },
  "global": {
    "debug": true,
    "logLevel": "debug",
    "anonymousTelemetry": false
  }
}
```

### Template de Produção

```json
{
  "mcpServers": {
    "task-master-ai": {
      "command": "npx",
      "args": ["-y", "task-master-ai"],
      "env": {
        "TASK_MASTER_TOOLS": "standard",
        "DEBUG": "false",
        "LOG_LEVEL": "warn"
      },
      "timeout": 15000,
      "retryLimit": 2
    }
  },
  "global": {
    "debug": false,
    "logLevel": "warn",
    "anonymousTelemetry": true,
    "enableCache": true,
    "cacheTimeout": 7200
  }
}
```

---

## ✅ VALIDAÇÃO DE CONFIGURAÇÕES

### Script de Validação

```bash
#!/bin/bash
# save as: scripts/validate-config.sh

echo "🔍 VALIDANDO CONFIGURAÇÕES..."

ERRORS=0

# 1. Validar .env
echo "1. Validando .env..."
if [ -f ".env" ]; then
    # Verificar variáveis obrigatórias
    if ! grep -q "OLLAMA_BASE_URL" .env; then
        echo "   ❌ OLLAMA_BASE_URL não encontrado"
        ERRORS=$((ERRORS + 1))
    fi

    if ! grep -q "TASK_MASTER_TOOLS" .env; then
        echo "   ❌ TASK_MASTER_TOOLS não encontrado"
        ERRORS=$((ERRORS + 1))
    fi

    echo "   ✅ .env válido"
else
    echo "   ⚠️  .env não encontrado"
fi

# 2. Validar .cursor/mcp.json
echo "2. Validando .cursor/mcp.json..."
if [ -f ".cursor/mcp.json" ]; then
    if cat .cursor/mcp.json | jq . > /dev/null 2>&1; then
        # Verificar estrutura MCP
        if cat .cursor/mcp.json | jq -e '.mcpServers."task-master-ai"' > /dev/null 2>&1; then
            echo "   ✅ .cursor/mcp.json válido"
        else
            echo "   ❌ Estrutura MCP inválida"
            ERRORS=$((ERRORS + 1))
        fi
    else
        echo "   ❌ JSON inválido"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "   ❌ .cursor/mcp.json não encontrado"
    ERRORS=$((ERRORS + 1))
fi

# 3. Validar .taskmaster/config.json
echo "3. Validando .taskmaster/config.json..."
if [ -f ".taskmaster/config.json" ]; then
    if cat .taskmaster/config.json | jq . > /dev/null 2>&1; then
        # Verificar seção models
        if cat .taskmaster/config.json | jq -e '.models.main' > /dev/null 2>&1; then
            echo "   ✅ .taskmaster/config.json válido"
        else
            echo "   ❌ Seção models não encontrada"
            ERRORS=$((ERRORS + 1))
        fi
    else
        echo "   ❌ JSON inválido"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "   ⚠️  .taskmaster/config.json não encontrado"
fi

# 4. Validar conectividade Ollama
echo "4. Validando conectividade Ollama..."
if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    MODEL_COUNT=$(curl -s http://localhost:11434/api/tags | jq '.models | length' 2>/dev/null || echo "0")
    if [ "$MODEL_COUNT" -gt 0 ]; then
        echo "   ✅ Ollama OK ($MODEL_COUNT modelos)"
    else
        echo "   ⚠️  Ollama responde mas sem modelos"
    fi
else
    echo "   ❌ Ollama não responde"
    ERRORS=$((ERRORS + 1))
fi

# 5. Validar Task Master AI
echo "5. Validando Task Master AI..."
if command -v task-master &> /dev/null; then
    if task-master --version > /dev/null 2>&1; then
        echo "   ✅ Task Master AI OK"
    else
        echo "   ❌ Task Master AI não responde"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "   ❌ Task Master AI não encontrado"
    ERRORS=$((ERRORS + 1))
fi

# Resultado final
echo ""
if [ $ERRORS -eq 0 ]; then
    echo "✅ TODAS AS CONFIGURAÇÕES VÁLIDAS"
else
    echo "❌ $ERRORS ERRO(S) ENCONTRADO(S)"
    echo "Execute o troubleshooting guide para resolver os problemas"
fi
```

### Testes de Conectividade

```bash
# Teste rápido de todas as configurações
#!/bin/bash
# save as: scripts/connectivity-test.sh

echo "🧪 TESTE DE CONECTIVIDADE COMPLETO"

# Teste 1: Ollama API
echo "1. Testando Ollama API..."
RESPONSE=$(curl -s -w "%{http_code}" http://localhost:11434/api/tags)
HTTP_CODE="${RESPONSE: -3}"
if [ "$HTTP_CODE" = "200" ]; then
    MODELS=$(echo "$RESPONSE" | jq '.models | length' 2>/dev/null || echo "?")
    echo "   ✅ API responde - $MODELS modelos"
else
    echo "   ❌ API fail (HTTP: $HTTP_CODE)"
fi

# Teste 2: Modelo específico
echo "2. Testando modelo llama3.2:3b..."
if curl -s http://localhost:11434/api/tags | jq -e '.models[] | select(.name == "llama3.2:3b")' > /dev/null; then
    echo "   ✅ Modelo principal OK"
else
    echo "   ❌ Modelo principal não encontrado"
fi

# Teste 3: Task Master CLI
echo "3. Testando Task Master CLI..."
if task-master models > /dev/null 2>&1; then
    echo "   ✅ CLI responde"
else
    echo "   ❌ CLI não responde"
fi

# Teste 4: Servidor MCP
echo "4. Testando servidor MCP..."
if npx -y task-master-ai --version > /dev/null 2>&1; then
    echo "   ✅ Servidor MCP OK"
else
    echo "   ❌ Servidor MCP fail"
fi

# Teste 5: Configuração MCP
echo "5. Testando configuração MCP..."
if echo '{"method":"tools/list"}' | npx -y task-master-ai > /dev/null 2>&1; then
    echo "   ✅ Ferramentas MCP OK"
else
    echo "   ❌ Ferramentas MCP fail"
fi

echo "🏁 Teste de conectividade concluído"
```

---

## 💾 MIGRAÇÃO E BACKUP

### Script de Backup Completo

```bash
#!/bin/bash
# save as: scripts/backup.sh

BACKUP_DIR="$HOME/.aurora-backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/aurora-backup-$DATE.tar.gz"

echo "💾 CRIANDO BACKUP COMPLETO..."

# Criar diretório se não existir
mkdir -p "$BACKUP_DIR"

# Lista de arquivos para backup
BACKUP_FILES=(
    ".env"
    ".taskmaster/"
    ".cursor/mcp.json"
    ".vscode/mcp.json"
    "scripts/"
    "tools/"
)

# Verificar se arquivos existem
EXISTING_FILES=()
for file in "${BACKUP_FILES[@]}"; do
    if [ -e "$file" ]; then
        EXISTING_FILES+=("$file")
    fi
done

if [ ${#EXISTING_FILES[@]} -eq 0 ]; then
    echo "❌ Nenhum arquivo para backup encontrado"
    exit 1
fi

# Criar backup
echo "Arquivos a serem incluídos:"
printf "   %s\n" "${EXISTING_FILES[@]}"

tar -czf "$BACKUP_FILE" "${EXISTING_FILES[@]}" \
    --exclude='*.log' \
    --exclude='node_modules' \
    --exclude='.git'

if [ $? -eq 0 ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "✅ Backup criado: $BACKUP_FILE ($BACKUP_SIZE)"

    # Manter apenas os 5 backups mais recentes
    cd "$BACKUP_DIR"
    ls -t aurora-backup-*.tar.gz | tail -n +6 | xargs -r rm --
    echo "🧹 Backups antigos removidos (mantidos 5 mais recentes)"
else
    echo "❌ Falha ao criar backup"
    exit 1
fi
```

### Script de Restore

```bash
#!/bin/bash
# save as: scripts/restore.sh

if [ $# -ne 1 ]; then
    echo "Uso: $0 <arquivo_backup.tar.gz>"
    echo "Backups disponíveis:"
    ls -la ~/.aurora-backups/aurora-backup-*.tar.gz 2>/dev/null || echo "Nenhum backup encontrado"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Arquivo de backup não encontrado: $BACKUP_FILE"
    exit 1
fi

echo "⚠️  RESTAURANDO BACKUP..."
echo "Arquivo: $BACKUP_FILE"
echo "Este processo irá Sobrescrever arquivos existentes!"
read -p "Continuar? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Restore cancelado"
    exit 1
fi

# Criar backup do estado atual antes de restaurar
echo "Criando backup do estado atual..."
./scripts/backup.sh

# Extrair backup
echo "Extraindo backup..."
tar -xzf "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Backup restaurado com sucesso"

    # Validar configuração após restore
    echo "Validando configuração..."
    ./scripts/validate-config.sh

    echo "🔄 Reinicie o terminal ou execute 'source .env' para carregar as novas configurações"
else
    echo "❌ Falha ao restaurar backup"
    exit 1
fi
```

### Migração Entre Ambientes

```bash
#!/bin/bash
# save as: scripts/migrate.sh

# Migração de desenvolvimento para produção
MIGRATE_ENV="$1"

if [ -z "$MIGRATE_ENV" ]; then
    echo "Uso: $0 <development|production|staging>"
    exit 1
fi

echo "🔄 MIGRANDO PARA $MIGRATE_ENV..."

case "$MIGRATE_ENV" in
    "development")
        echo "Configurando para desenvolvimento..."
        # Aplicar configurações de desenvolvimento
        jq '.global.debug = true | .global.logLevel = "debug" | .mcp.timeout = 60000' \
            .taskmaster/config.json > .taskmaster/config.json.tmp
        mv .taskmaster/config.json.tmp .taskmaster/config.json

        # Variáveis de ambiente para dev
        sed -i 's/DEBUG="false"/DEBUG="true"/' .env
        sed -i 's/LOG_LEVEL="info"/LOG_LEVEL="debug"/' .env
        ;;

    "production")
        echo "Configurando para produção..."
        # Aplicar configurações de produção
        jq '.global.debug = false | .global.logLevel = "warn" | .mcp.timeout = 15000' \
            .taskmaster/config.json > .taskmaster/config.json.tmp
        mv .taskmaster/config.json.tmp .taskmaster/config.json

        # Variáveis de ambiente para produção
        sed -i 's/DEBUG="true"/DEBUG="false"/' .env
        sed -i 's/LOG_LEVEL="debug"/LOG_LEVEL="warn"/' .env
        ;;

    "staging")
        echo "Configurando para staging..."
        # Configurações intermediárias
        jq '.global.debug = false | .global.logLevel = "info" | .mcp.timeout = 30000' \
            .taskmaster/config.json > .taskmaster/config.json.tmp
        mv .taskmaster/config.json.tmp .taskmaster/config.json
        ;;

    *)
        echo "❌ Ambiente inválido: $MIGRATE_ENV"
        echo "Use: development, production, ou staging"
        exit 1
        ;;
esac

echo "✅ Migração concluída para $MIGRATE_ENV"
echo "🔄 Reinicie os serviços para aplicar as mudanças"
```

---

## 📊 MONITORAMENTO DE CONFIGURAÇÃO

### Dashboard de Status

```bash
#!/bin/bash
# save as: scripts/config-dashboard.sh

echo "📊 DASHBOARD DE CONFIGURAÇÃO - $(date)"
echo "======================================"

# Status dos arquivos de configuração
echo "📁 ARQUIVOS DE CONFIGURAÇÃO:"
echo "   .env: $([ -f .env ] && echo '✅ OK' || echo '❌ MISSING')"
echo "   .cursor/mcp.json: $([ -f .cursor/mcp.json ] && echo '✅ OK' || echo '❌ MISSING')"
echo "   .vscode/mcp.json: $([ -f .vscode/mcp.json ] && echo '✅ OK' || echo '❌ MISSING')"
echo "   .taskmaster/config.json: $([ -f .taskmaster/config.json ] && echo '✅ OK' || echo '❌ MISSING')"

# Status dos serviços
echo ""
echo "🔧 SERVIÇOS:"
echo "   Task Master AI: $(command -v task-master > /dev/null && echo '✅ OK' || echo '❌ MISSING')"
echo "   Ollama API: $(curl -s http://localhost:11434/api/tags > /dev/null && echo '✅ OK' || echo '❌ FAIL')"

# Modelos configurados
echo ""
echo "🤖 MODELOS CONFIGURADOS:"
if [ -f .taskmaster/config.json ]; then
    MAIN_MODEL=$(jq -r '.models.main.modelId // "N/A"' .taskmaster/config.json 2>/dev/null || echo "N/A")
    echo "   Principal: $MAIN_MODEL"

    CODE_MODEL=$(jq -r '.models.code.modelId // "N/A"' .taskmaster/config.json 2>/dev/null || echo "N/A")
    echo "   Código: $CODE_MODEL"
fi

# Modelos Ollama disponíveis
echo ""
echo "📦 MODELOS OLLAMA DISPONÍVEIS:"
if command -v ollama > /dev/null; then
    MODEL_COUNT=$(ollama list 2>/dev/null | tail -n +2 | wc -l || echo "0")
    echo "   Total: $MODEL_COUNT modelos"

    # Mostrar principais
    ollama list 2>/dev/null | head -5 | tail -n +2 | while read line; do
        NAME=$(echo "$line" | awk '{print $1}')
        SIZE=$(echo "$line" | awk '{print $3}')
        echo "   • $NAME ($SIZE)"
    done
fi

# Uso de recursos
echo ""
echo "💻 RECURSOS DO SISTEMA:"
echo "   RAM: $(free -h | awk 'NR==2{printf "%.1f%%", $3/$2*100}')"
echo "   Disco: $(df -h / | awk 'NR==2{print $5}')"

if command -v nvidia-smi > /dev/null 2>&1; then
    GPU_USAGE=$(nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null | head -1)
    echo "   GPU: $GPU_USAGE"
fi

echo "======================================"
```

---

## 🏁 CONCLUSÃO

Este guia de referência consolida **todas as configurações** do sistema Task Master AI + Ollama:

### ✅ Configurações Documentadas

- **4 arquivos principais** de configuração (.env, mcp.json, config.json)
- **15+ variáveis de ambiente** com explicações
- **Templates para 3 ambientes** (dev, staging, prod)
- **Scripts de validação** e migração
- **20+ modelos suportados** com recomendações

### 🎯 Para Cada Situação

- **Desenvolvimento:** Debug habilitado, logs detalhados
- **Produção:** Performance otimizada, logs mínimos
- **Troubleshooting:** Validação automática, health checks
- **Migração:** Backup/restore automatizado

### 🔧 Manutenção

- **Validação contínua** com scripts automatizados
- **Monitoramento de recursos** em tempo real
- **Backup automático** com rotação
- **Recovery procedures** testadas

**Sistema totalmente configurável e documentado!** 📚

---

**Referência Completa de Configurações**  
**Versão:** 1.0  
**Data:** 03 de Janeiro de 2026  
**Total de Parâmetros:** 50+ documentados
