# Guia de Operações do Aurora

Este guia cobre operações comuns para gerenciar temas com o Aurora.

## Instalação

Execute o script de inicialização para configurar a estrutura de diretórios necessária e os hooks do shell.

```bash
./init-aurora-project.sh
```

## Adicionando Novos Temas

Para adicionar um novo tema, coloque um arquivo YAML ou JSON válido no diretório `themes/`.

```bash
cp tema-personalizado.yaml themes/
aurora list
```

## Solução de Problemas

### Tema Não Aplicando

Certifique-se de que seu emulador de terminal suporta true color (24 bits). Você pode testar isso executando:

```bash
curl -s https://gist.githubusercontent.com/lifepillar/0227a696376511202863B/raw/colors.sh | bash
```

### Problemas de Persistência

Verifique se `~/.config/aurora/theme.json` tem permissão de escrita para o usuário atual.

## Atualizando o Aurora

Obtenha as alterações mais recentes do repositório e execute novamente o script de inicialização, se necessário.

```bash
git pull origin main
./init-aurora-project.sh
```
