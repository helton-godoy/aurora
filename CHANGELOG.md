# Changelog

Todos as mudanças notáveis deste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Adicionado

- Sistema modular completo de gerenciamento de temas
- Suporte multi-shell (Bash, Zsh, Fish)
- Sistema de plugins remotos
- Suporte específico para kmscon (terminais headless)
- Sistema de backup automático
- Valid WCAG de contraste de cores
- Interface CLI moderna com gum
- Preview temporário de temas (10 segundos)
- Persistência de estado do tema
- Formato YAML para temas
- Suíte completa de testes (unitários e de integração)

### Mudado

- Reestruturado completamente para arquitetura modular
- Migrado de sistema monolítico para modular
- Removidas dependências Node.js desnecessárias
- Removido Taskmaster genérico
- Temas migrados para formato YAML

### Removido

- Implementação monolítica anterior (src/aurora.sh)
- Wrapper duplicado (aurora na raiz)
- Dependências Node.js (package.json, node_modules/)
- Documentação desatualizada (PRDs, análises antigas)
- Arquivos temporários de desenvolvimento

### Corrigido

- Correção de parsing em loader.sh
- Validação melhorada de temas YAML
- Tratamento de erros robusto em todas as operações
- Detecção automática de ambiente kmscon

## [3.0.0] - 2025-01-04

### Adicionado

- Repositório Aurora criado
- Paleta de cores Ganache (tons de chocolate)
- Suporte básico para Bash e kmscon
- 12 temas iniciais (Ganache, Dracula, Nord, etc.)
- Instalador automático de dependências

### Documentação

- README inicial
- Guia de usuário básico
- Documentação de arquitetura

---

## Legenda

- **Adicionado**: Novas funcionalidades
- **Mudado**: Mudanças em funcionalidades existentes
- **Removido**: Funcionalidades ou arquivos removidos
- **Corrigido**: Correções de bugs ou problemas
- **Segurança**: Correções de segurança
- **Documentação**: Mudanças na documentação
