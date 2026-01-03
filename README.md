# Aurora - Gerenciador de Temas de Terminal

Aurora é um gerenciador de temas de terminal leve e poderoso, projetado para ajudar você a transformar seu espaço de trabalho com facilidade. Ele suporta múltiplos shells e emuladores de terminal, proporcionando uma experiência de estilização consistente.

## ✨ Funcionalidades

- **Galeria de Temas**: Explore uma coleção curada de belos temas de terminal.
- **Aplicação Rápida**: Aplique temas instantaneamente na sua sessão ativa do shell.
- **Auto-Persistência**: Salve sua escolha de tema para que ele seja carregado automaticamente em cada nova janela do terminal.
- **Suporte a Shell**: Funciona perfeitamente com Bash, Zsh e Fish.
- **Sistema de Plugins**: Adicione e gerencie temas personalizados da comunidade facilmente.

## 🚀 Início Rápido

### Instalação

```bash
# Clone o repositório
git clone https://github.com/helton-godoy/aurora.git
cd aurora

# Configure o gerenciador
./init-aurora-project.sh
```

### Uso

```bash
# Listar temas disponíveis
aurora list

# Visualizar um tema
aurora preview <nome-do-tema>

# Aplicar e salvar um tema
aurora apply <nome-do-tema>
```

## 📂 Estrutura do Projeto

- `src/`: Lógica principal e scripts para gerenciamento de temas.
- `themes/`: Repositório de arquivos de definição de temas (.json/.yaml).
- `docs/`: Documentação técnica e guias.
- `taskmaster_docs/`: Arquivos de planejamento e gerenciamento de projeto (auxiliar).

## 📄 Documentação

Para informações detalhadas, consulte o diretório [docs/](file:///home/helton/git/aurora/docs):

- [Arquitetura](file:///home/helton/git/aurora/docs/ARCHITECTURE.md)
- [Configuração](file:///home/helton/git/aurora/docs/CONFIGURATION.md)
- [Guia de Operações](file:///home/helton/git/aurora/docs/OPERATIONS.md)
- [FAQ](file:///home/helton/git/aurora/docs/FAQ.md)

## 🤝 Contribuição

Contribuições são bem-vindas! Se você deseja adicionar um novo tema ou melhorar a lógica principal, consulte nosso [Guia de Contribuição](file:///home/helton/git/aurora/docs/CONTRIBUTING.md).
