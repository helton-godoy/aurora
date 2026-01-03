# Perguntas Frequentes (FAQ) do Aurora

## Perguntas Gerais

### O que é o Aurora?

O Aurora é um gerenciador de temas de terminal que simplifica o processo de descoberta e aplicação de esquemas de cores ao ambiente do seu terminal.

### Quais shells são suportados?

Atualmente, o Aurora suporta Bash, Zsh e Fish.

### Funciona no Windows?

O Aurora é projetado principalmente para sistemas do tipo Unix (Linux e macOS). Pode funcionar no WSL (Windows Subsystem for Linux).

## Personalização

### Posso criar meu próprio tema?

Sim! Basta criar um arquivo YAML no diretório `themes/` seguindo o esquema definido no [Guia de Configuração](file:///home/helton/git/aurora/docs/CONFIGURATION.md).

### Como compartilho meus temas?

Você pode contribuir para o projeto abrindo um Pull Request com seu arquivo de tema no diretório `themes/`.

## Aspectos Técnicos

### O Aurora deixa a inicialização do terminal lenta?

Não. O Aurora utiliza hooks leves que apenas carregam o estado atual do tema, adicionando um atraso insignificante à inicialização do seu shell.
