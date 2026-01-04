# 🍫 Aurora - Gerenciador de Temas de Terminal v3.0

Aurora é um gerenciador de temas de terminal leve e poderoso, projetado para ajudar você a transformar seu espaço de trabalho com facilidade. Ele suporta múltiplos shells e emuladores de terminal, proporcionando uma experiência de estilização consistente.

## ✨ Funcionalidades

- **🎨 Galeria de Temas**: Explore uma coleção curada de belos temas (incluindo a paleta Ganache exclusiva)
- **⚡ Aplicação Rápida**: Aplique temas instantaneamente na sua sessão ativa do shell
- **💾 Auto-Persistência**: Salve sua escolha de tema para carregamento automático
- **🐚 Suporte Multi-Shell**: Bash, Zsh e Fish
- **🌐 Sistema de Plugins**: Adicione e gerencie temas remotos
- **🖥 Suporte Kmscon**: Terminais headless em servidores
- **📦 Empacotamento Simples**: Pacote tar.gz pronto para distribuição

## 🚀 Início Rápido

### Instalação

#### Via Pacote Tarball
```bash
# Baixar e descompactar
wget https://github.com/helton-godoy/aurora/releases/latest/download/aurora-3.0.0.tar.gz
tar xzf aurora-3.0.0.tar.gz
cd aurora-3.0.0

# Instalar no sistema
sudo bash bin/aurora-install
```

#### Via Git Clone (Desenvolvimento)
```bash
git clone https://github.com/helton-godoy/aurora.git
cd aurora

# Criar wrapper local
bash scripts/setup.sh

# Agora você pode usar ./aurora
```

### Uso

```bash
# Listar temas disponíveis
aurora list

# Listar apenas temas remotos
aurora list --remote

# Visualizar um tema
aurora preview dracula

# Aplicar tema permanentemente
aurora apply ganache_noir

# Instalar tema remoto
aurora install <nome-do-tema>

# Instalar hooks nos shells
aurora install-hooks

# Ver status do sistema
aurora status

# Gerenciar backups
aurora backup list
aurora backup restore <arquivo>
```

## 📂 Estrutura do Projeto

```
aurora/                     # Código fonte
├── bin/
│   └── aurora-install     # Instalador do sistema
├── src/                    # Módulos Bash
│   ├── aurora.sh          # CLI principal
│   ├── config/            # Configurações e constantes
│   ├── core/              # Theme manager, plugins, kmscon
│   └── modules/           # ANSI, parser, hooks, utils
├── themes/                 # 14 temas padrão
├── scripts/                # Scripts auxiliares
│   ├── package.sh         # Empacotamento
│   └── setup.sh           # Desenvolvimento
├── tests/                  # Testes unitários e integração
├── docs/                   # Documentação
└── aurora                  # Wrapper de desenvolvimento
```

## 📂 Estrutura de Instalação (FHS + XDG)

```
/usr/local/bin/aurora              → Executável
/usr/local/share/aurora/           → Sistema (read-only)
├── src/                             # Módulos
└── themes/                          # 14 temas padrão

/etc/aurora/                       → Global (admin)
├── aurora.yml                      # Configurações globais
└── themes/                         # Temas do admin (opcional)

~/.config/aurora/                  → Configuração do usuário
├── aurora.yml                      # Preferências pessoais
└── state.yml                       # Estado atual

~/.local/share/aurora/             → Dados do usuário
├── themes/                         # Temas personalizados
└── backups/                        # Backups

~/.local/state/aurora/             # Estado da aplicação
```

### Precedência de Temas
1. `~/.local/share/aurora/themes/` → Temas do usuário (maior precedência)
2. `/etc/aurora/themes/` → Temas globais (admin)
3. `/usr/local/share/aurora/themes/` → Temas do sistema (padrão)

## 📄 Documentação

Para informações detalhadas, consulte o diretório [docs/](docs/):

- [Estrutura de Arquivos (FHS + XDG)](docs/FILESYSTEM_STRUCTURE.md)
- [Resumo da Reestruturação v3.0](docs/REFACTORING_SUMMARY.md)
- [Arquitetura](docs/ARCHITECTURE.md)
- [Configuração](docs/CONFIGURATION.md)
- [Guia de Operações](docs/OPERATIONS.md)
- [Guia do Usuário](docs/USER_GUIDE.md)
- [FAQ](docs/FAQ.md)

## 🧪 Testes

```bash
# Executar todos os testes
bash tests/run_all.sh all

# Testes unitários
bash tests/run_all.sh unit

# Testes de integração
bash tests/run_all.sh integration
```

## 📦 Empacotamento

```bash
# Criar pacote de distribuição
bash scripts/package.sh

# Resultado: dist/aurora-3.0.0.tar.gz (68K)
```

## 🤝 Contribuição

Contribuições são bem-vindas! Veja:
- [Guia do Desenvolvedor](docs/DEVELOPER_GUIDE.md)
- [Instruções para Agentes de IA](AGENTS.md)

## 📜 Licença

MIT License - Veja o arquivo [LICENSE](LICENSE) para detalhes

## 🍫 Sobre a Paleta Ganache

Aurora inclui a paleta de cores **Ganache** exclusiva, baseada em tons de chocolate e café:
- **Ganache Noir**: O mais escuro da paleta
- **Ganache Au Lait**: Chocolate ao leite equilibrado
- **Ganache Blanc**: Chocolate branco elegante
- **E mais 9 variações**: Caramel, Cocoa, Coffee, Cream, Espresso, etc.

## 🙏 Agradecimentos

Agradecimentos a todos os projetos de temas open source que inspiraram este projeto.
