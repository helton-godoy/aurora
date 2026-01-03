# PRD - Aurora Gerenciador de Temas de Terminal

## Propósito

O propósito do projeto Aurora é criar um gerenciador de temas robusto, leve e extensível baseado em CLI para usuários de terminal em diferentes shells (Bash, Zsh, Fish). Ele visa resolver a fragmentação na estilização de terminais, fornecendo uma maneira unificada de descobrir e aplicar esquemas de cores.

## Funcionalidades Principais

1. **Alternador Dinâmico de Temas**: Aplicação instantânea de esquemas de cores ao terminal ativo.
2. **Mecanismo de Persistência**: Uma abordagem sem daemon para garantir que o tema selecionado seja carregado em cada nova instância de terminal.
3. **Repositório de Temas**: Um diretório local padrão (`themes/`) para definições de temas usando YAML.
4. **Sistema de Hooking de Shell**: Scripts automatizados para injetar o estado do tema no `.bashrc`, `.zshrc`, etc.
5. **Modo de Visualização**: Capacidade de ver como um tema fica antes de aplicá-lo permanentemente.

## Arquitetura Técnica

- **Linguagem**: Bash/Shell (por portabilidade) ou Node.js (para experiência CLI).
- **Formato**: YAML/JSON para definições de temas.
- **Hooks**: Hooks nativos do shell para minimizar a latência.

## Tarefas para Geração (via Taskmaster)

1. Inicializar a estrutura de diretórios principal e o tratamento de configuração.
2. Implementar a lógica de análise de temas para arquivos YAML.
3. Criar o módulo de geração de códigos de cor ANSI.
4. Desenvolver hooks específicos do shell para Bash, Zsh e Fish.
5. Construir a interface CLI para `aurora list` e `aurora apply`.
6. Implementar a lógica de persistência de temas.
7. Criar um conjunto base de temas de terminal padrão.
8. Adicionar uma funcionalidade de visualização de tema usando uma grade de cores de exemplo.
9. Implementar um sistema de plugins para obter temas de repositórios remotos.
10. Finalizar o `init-aurora-project.sh` para facilitar a integração.
