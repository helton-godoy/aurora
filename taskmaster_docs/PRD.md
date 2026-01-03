# PRD – Projeto Aurora

## Visão Geral

O **Projeto Aurora** tem como objetivo principal fornecer uma solução de gerenciamento de _themes_ (temas) para o terminal, permitindo que usuários selecionem, apliquem e persistam temas de forma simples e consistente em diferentes shells (bash, zsh, fish) e ambientes (Linux, macOS).

## Objetivos

- **Seleção de temas**: catálogo de temas com visualização prévia.
- **Aplicação automática**: aplicar tema ao shell atual e persistir nas configurações do usuário.
- **Persistência**: salvar a escolha em um arquivo de configuração (`~/.config/aurora/theme.json`).
- **Compatibilidade**: suportar os principais shells e terminais (iTerm2, Alacritty, Kitty, etc.).
- **Extensibilidade**: permitir que a comunidade adicione novos temas via plugins.

## Escopo Funcional

| ID  | Funcionalidade    | Descrição                                                                                                       |
| --- | ----------------- | --------------------------------------------------------------------------------------------------------------- |
| F1  | Catálogo de temas | Lista de temas disponíveis com preview de cores.                                                                |
| F2  | Aplicar tema      | Comando `aurora apply <theme>` que altera as variáveis de cor do terminal e atualiza o arquivo de configuração. |
| F3  | Persistir tema    | Ao iniciar o shell, o script de inicialização carrega o tema salvo.                                             |
| F4  | Gerenciar plugins | Interface `aurora plugin add <repo>` para instalar novos temas.                                                 |
| F5  | UI mínima         | Interface de linha de comando interativa (menu TUI) para escolher temas.                                        |

## Requisitos Não‑Funcionais

- **Performance**: aplicação de tema em < 200 ms.
- **Portabilidade**: funciona em Linux (distros populares) e macOS.
- **Segurança**: validação de arquivos de tema para evitar execução de código arbitrário.
- **Usabilidade**: documentação clara e comandos intuitivos.

## Entregáveis e Marcos

| Marco | Data prevista | Entregável                                            |
| ----- | ------------- | ----------------------------------------------------- |
| M1    | 2 semanas     | Estrutura de diretórios e scaffolding do projeto.     |
| M2    | 4 semanas     | Implementação do catálogo de temas e comando `apply`. |
| M3    | 6 semanas     | Persistência e carregamento automático no shell.      |
| M4    | 8 semanas     | Sistema de plugins e UI TUI.                          |
| M5    | 10 semanas    | Testes de integração e documentação completa.         |

## Riscos

- Incompatibilidade com terminais proprietários.
- Falhas ao sobrescrever arquivos de configuração do usuário.
- Dependência de bibliotecas externas para renderização de cores.

## Aprovação

Este documento será revisado pelos stakeholders antes da geração do plano de tarefas via **Task‑Master**.
