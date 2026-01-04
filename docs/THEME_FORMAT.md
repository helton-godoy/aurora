# Aurora - Formato de Tema

Este documento descreve o formato YAML usado para definir temas no Aurora.

## 📋 Estrutura Básica

```yaml
name: "Nome do Tema"
description: "Descrição curta do tema"

colors:
  background: "#RRGGBB" # OBRIGATÓRIO
  foreground: "#RRGGBB" # OBRIGATÓRIO
  accent: "#RRGGBB" # OBRIGATÓRIO
  warning: "#RRGGBB" # OPCIONAL

  palette: # OBRIGATÓRIO (exatamente 16 cores)
    - "#000000"
    - "#FF0000"
    - "#00FF00"
    - "#FFFF00"
    - "#0000FF"
    - "#FF00FF"
    - "#00FFFF"
    - "#FFFFFF"
    - "#808080"
    - "#FF8080"
    - "#80FF80"
    - "#FFFF80"
    - "#8080FF"
    - "#FF80FF"
    - "#80FFFF"
    - "#FFFFFF"
```

## 📝 Campos Detalhados

### name

**Tipo:** String  
**Obrigatório:** Sim  
**Descrição:** Nome de exibição do tema

```yaml
name: "Ganache Lait"
```

### description

**Tipo:** String  
**Obrigatório:** Sim  
**Descrição:** Breve descrição do tema (1-2 frases)

```yaml
description: "Equilíbrio clássico - Chocolate ao Leite"
```

### colors.background

**Tipo:** String (cor hexadecimal)  
**Obrigatório:** Sim  
**Descrição:** Cor de fundo do terminal  
**Formato:** `#RRGGBB` (exatamente 6 caracteres hexadecimais)

```yaml
colors:
  background: "#2a1d10"
```

### colors.foreground

**Tipo:** String (cor hexadecimal)  
**Obrigatório:** Sim  
**Descrição:** Cor do texto principal  
**Formato:** `#RRGGBB`

```yaml
colors:
  foreground: "#ded6d1"
```

### colors.accent

**Tipo:** String (cor hexadecimal)  
**Obrigatório:** Sim  
**Descrição:** Cor de destaque (para UI, prompts, etc.)  
**Formato:** `#RRGGBB`

```yaml
colors:
  accent: "#ae998b"
```

### colors.warning

**Tipo:** String (cor hexadecimal)  
**Obrigatório:** Não  
**Descrição:** Cor para mensagens de aviso  
**Padrão:** Usa a cor `accent` se não especificado

```yaml
colors:
  warning: "#bf9000"
```

### colors.palette

**Tipo:** Array de strings (cores hexadecimais)  
**Obrigatório:** Sim  
**Descrição:** Paleta de 16 cores para terminais 8-bit  
**Requisitos:**

- Exatamente 16 cores
- Cores em formato `#RRGGBB`
- Ordem: 8 cores escuras seguidas de 8 cores claras (recomendado)

```yaml
colors:
  palette:
    - "#20160c" # Preto
    - "#a43636" # Vermelho
    - "#6a4928" # Verde
    - "#beada2" # Amarelo
    - "#553a20" # Azul
    - "#6a4928" # Magenta
    - "#ae998b" # Ciano
    - "#0b0704" # Cinza claro
    - "#a43636" # Vermelho claro
    - "#ae998b" # Verde claro
    - "#cec2b9" # Amarelo claro
    - "#beada2" # Azul claro
    - "#cec2b9" # Magenta claro
    - "#efebe8" # Ciano claro
    - "#efebe8" # Branco
```

## 🔍 Validação

Aurora valida automaticamente os temas ao:

### 1. Validade YAML

Arquivo deve ser um YAML válido. Se houver erros de sintaxe, o tema não será carregado.

### 2. Campos Obrigatórios

Todos os campos obrigatórios devem estar presentes:

- `name`
- `description`
- `colors.background`
- `colors.foreground`
- `colors.accent`
- `colors.palette` (com 16 cores)

### 3. Formato de Cores

Todas as cores devem seguir o formato `#RRGGBB`:

- Prefixo `#`
- 6 caracteres hexadecimais (0-9, A-F, a-f)
- Não diferencia maiúsculas/minúsculas

Exemplos válidos:

- `#FF0000` ✅
- `#2a1d10` ✅
- `#abcdef` ✅

Exemplos inválidos:

- `FF0000` ❌ (sem #)
- `#ff000` ❌ (5 caracteres)
- `#GGGGGG` ❌ (G inválido)

### 4. Tamanho da Paleta

A paleta deve ter exatamente 16 cores.

## ✅ Acessibilidade

### Contraste WCAG AA

Aurora valida o contraste entre `background` e `foreground` usando o padrão WCAG AA:

**Requisito:** Contraste mínimo de 4.5:1

Exemplo de bom contraste:

```yaml
colors:
  background: "#20160c" # Fundo escuro
  foreground: "#ded6d1" # Texto claro
  # Contraste: ~10:1 ✅
```

Exemplo de contraste insuficiente:

```yaml
colors:
  background: "#555555" # Fundo médio
  foreground: "#777777" # Texto médio-claro
  # Contraste: ~2:1 ❌
```

### Recomendações

1. **Fundos escuros** use texto claro
2. **Fundos claros** use texto escuro
3. **Evite** cores muito parecidas para BG e FG
4. **Teste** seu tema com `aurora preview` antes de aplicar

## 📚 Exemplos Completos

### Tema Escuro (Dark Mode)

```yaml
name: "Ganache Noir"
description: "Modo escuro intenso - Deep Dark com Roasted Almond"

colors:
  background: "#0b0704"
  foreground: "#beada2"
  accent: "#6a4928"
  warning: "#bf9000"

  palette:
    - "#0b0704"
    - "#402c18"
    - "#553a20"
    - "#6a4928"
    - "#ae998b"
    - "#beada2"
    - "#cec2b9"
    - "#ded6d1"
    - "#efebe8"
    - "#a43636"
    - "#beada2"
    - "#cec2b9"
    - "#ded6d1"
    - "#efebe8"
    - "#ffffff"
```

### Tema Claro (Light Mode)

```yaml
name: "Ganache Blanc"
description: "Modo claro elegante - White Chocolate com Coffee Bean"

colors:
  background: "#efebe8"
  foreground: "#352514"
  accent: "#5f4224"
  warning: "#bf9000"

  palette:
    - "#0b0704"
    - "#352514"
    - "#402c18"
    - "#553a20"
    - "#5f4224"
    - "#6a4928"
    - "#ae998b"
    - "#beada2"
    - "#cec2b9"
    - "#ded6d1"
    - "#efebe8"
    - "#a43636"
    - "#c03030"
    - "#beada2"
    - "#cec2b9"
    - "#ded6d1"
    - "#efebe8"
```

## 🧪 Testando Seu Tema

### Criar Arquivo de Teste

1. Crie um novo arquivo em `themes/`:

   ```bash
   nano themes/meu_tema.yml
   ```

2. Use a estrutura completa acima

3. Salve o arquivo

### Validar Tema

```bash
# Verificar se é válido YAML
yq . themes/meu_tema.yml

# Verificar se Aurora pode carregar
aurora preview meu_tema
```

### Aplicar Tema

```bash
# Aplicar permanentemente
aurora apply meu_tema
```

## 🚀 Publicando Seu Tema

### 1. Preparação

1. Garanta que o tema segue todas as validações acima
2. Teste o tema com `aurora preview`
3. Verifique contraste WCAG
4. Documente o tema claramente

### 2. Adicionar ao Repositório

Aurora tem um repositório oficial de temas:

```
https://github.com/helton-godoy/aurora/tree/master/themes
```

Para adicionar seu tema:

1. Fork do repositório
2. Adicionar seu arquivo `.yml` ao diretório `themes/`
3. Commit: `git commit -m "Add: My Custom Theme"`
4. Push: `git push origin main`
5. Abrir Pull Request

### 3. Repositório Personalizado

Você pode usar seu próprio repositório:

```bash
export AURORA_PLUGIN_REPO="https://raw.githubusercontent.com/usuario/repo/master/themes"
aurora install meu_tema
```

## 📋 Checklist

Antes de publicar seu tema:

- [ ] Nome descritivo e curto
- [ ] Descrição clara (1-2 frases)
- [ ] Cores em formato hexadecimal válido (#RRGGBB)
- [ ] Todos os campos obrigatórios presentes
- [ ] Paleta com exatamente 16 cores
- [ ] Contraste WCAG AA passando (≥ 4.5:1)
- [ ] Tema testado com `aurora preview`
- [ ] Documentação completa no arquivo
- [ ] Arquivo seguindo convenção de nomenclatura (snake_case)

## 🔧 Ferramentas Úteis

### Gerar Cores

Use ferramentas online para criar paletas:

- [Coolors](https://coolors.co/)
- [Adobe Color](https://color.adobe.com/pt/create)
- [Material Design Colors](https://material.io/resources/color/)

### Validar Cores

- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [WCAG Contrast Checker](https://contrast-ratio.com/)

### Editar YAML

Use editores com suporte YAML:

- VS Code (extensão YAML)
- Vim (indentação automática)
- Nano (básico, mas funcional)

## 💡 Dicas Avançadas

### Nomenclatura

Use `snake_case` para nomes de arquivos:

- ✅ `ganache_noir.yml`
- ✅ `cyberpunk_neon.yml`
- ❌ `GanacheNoir.yml`
- ❌ `cyberpunk-neon.yml`

### Comentários

Aurora ignora comentários no YAML, então você pode adicionar:

```yaml
# Tema inspirado nas cores do café à noite
# Criado por: Seu Nome <email@exemplo.com>
name: "Coffee Night"
# ...
```

### Metadados Opcionais

Você pode adicionar campos personalizados (Aurora ignora, mas permite):

```yaml
name: "Meu Tema"
description: "Descrição"

# Metadados pessoais
metadata:
  author: "Seu Nome"
  version: "1.0"
  repository: "https://github.com/usuario/meu-tema"
  license: "MIT"

colors:
  # ...
```

## 🐛 Solução de Problemas

### Erro: "Campo obrigatório ausente"

Verifique se todos os campos obrigatórios estão presentes:

- `name`
- `description`
- `colors.background`
- `colors.foreground`
- `colors.accent`
- `colors.palette` (16 cores)

### Erro: "Cor inválida"

Verifique o formato:

- Deve começar com `#`
- Seguido de 6 caracteres hexadecimais (0-9, A-F, a-f)
- Exemplo: `#FF0000`, não `FF0000` nem `#ff0000`

### Erro: "Paleta incompleta"

Verifique se `colors.palette` tem exatamente 16 cores.

### Erro: "Contraste insuficiente"

O contraste entre `background` e `foreground` é menor que 4.5:1.
Soluções:

- Use cores com mais contraste
- Troque background e foreground
- Use ferramentas de validação de contraste

## 📚 Recursos

- [Documentação Aurora](USER_GUIDE.md)
- [Arquitetura Aurora](ARCHITECTURE.md)
- [Repositório GitHub](https://github.com/helton-godoy/aurora)
