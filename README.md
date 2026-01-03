# 🍫 AURORA TTY Engine

> **Remasterização Visual para Servidores Debian 13 (Trixie)**

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Bash](https://img.shields.io/badge/language-Bash-green.svg)
![Platform](https://img.shields.io/badge/platform-Debian%2013-red.svg)
![Render](https://img.shields.io/badge/render-Kmscon%20%2B%20Starship-orange.svg)

O **Aurora** é um sistema avançado de gerenciamento de temas projetado especificamente para ambientes **TTY (Headless)**. Ao contrário dos gerenciadores de terminal comuns que rodam sobre X11 ou Wayland, o Aurora opera diretamente no Framebuffer do Linux usando `kmscon`.

O objetivo é simples: **Eliminar a resistência ao uso do terminal puro**, transformando a tela preta padrão em uma interface rica, moderna e visualmente hierarquizada.

---

## ✨ Funcionalidades Principais

- **🎨 Renderização TrueColor:** Abandone a paleta VGA de 16 cores. O Aurora habilita suporte total a cores 24-bit no TTY.
- **🚀 Integração Nativa com Starship:** O prompt se adapta automaticamente. Ao trocar o tema do terminal, o arquivo `starship.toml` é regenerado para garantir contraste perfeito.
- **👁️ Preview em Tempo Real:** Teste temas instantaneamente no seu console atual sem precisar reiniciar serviços ou fazer logout.
- **📦 Arquitetura "Monólito Modular":** Um único executável, fácil de distribuir e manter, mas internamente organizado em módulos lógicos.
- **🅰️ Tipografia Moderna:** Instalação e configuração automática de **Nerd Fonts** (ícones e ligaduras) no console do sistema.

---

## 🍫 A Coleção "Ganache"

O Aurora vem pré-carregado com a coleção de assinatura **Ganache**, uma paleta monocromática sofisticada inspirada em tons de chocolate e café, desenhada para reduzir a fadiga visual em longas sessões de administração.

| Tema                   | Descrição                                                                                                 | Visual              |
| :--------------------- | :-------------------------------------------------------------------------------------------------------- | :------------------ |
| **Ganache Noir** 🌑    | **Chocolate Amargo.** Fundo profundo (#0b0704). Baixo brilho, alto foco. Ideal para ambientes escuros.    | _Dark Mode Premium_ |
| **Ganache Au Lait** ☕ | **Ao Leite.** Fundo café (#2a1d10) com texto creme. O equilíbrio clássico e aconchegante.                 | _Standard Mode_     |
| **Ganache Blanc** 🥛   | **Chocolate Branco.** Fundo creme suave (#efebe8) com texto café escuro. Elegância e legibilidade máxima. | _Light Mode_        |

---

## 🛠️ Instalação

### Pré-requisitos

- **OS:** Debian 13 (Trixie) ou superior.
- **Acesso:** Root (sudo).
- **Conexão:** Internet (para baixar fontes e o binário do Starship na primeira execução).

### Instalação Rápida

Execute o script de inicialização para preparar o ambiente e instalar o binário `aurora`:

```bash
# Clone o repositório
git clone [https://github.com/seu-usuario/aurora-engine.git](https://github.com/seu-usuario/aurora-engine.git)
cd aurora-engine

# Execute o instalador (Bootstrapper)
sudo ./init-aurora-project.sh
```

Isto irá:

1. Criar a estrutura em `/etc/aurora/themes`.
2. Gerar os arquivos de tema da coleção Ganache.
3. Instalar o executável em `/usr/local/bin/aurora`.

---

## 🚀 Como Usar

O comando `aurora` é o seu ponto central de controle.

### 1. Configuração Inicial (Setup)

Na primeira vez que rodar em um servidor limpo, execute o setup para baixar dependências (kmscon, fontes, starship):

```bash
sudo aurora setup

```

### 2. Listar Temas Disponíveis

Veja quais "sabores" estão instalados no sistema:

```bash
aurora list
# Saída:
# - ganache_noir
# - ganache_lait
# - ganache_blanc

```

### 3. Pré-visualizar (Sem compromisso)

Não tem certeza se quer mudar? Use o preview. Ele muda as cores do terminal atual por 5 segundos e depois reverte.

```bash
aurora preview ganache_lait

```

### 4. Aplicar Tema Definitivo

Para mudar a configuração do servidor (persistente após reboot):

```bash
sudo aurora apply ganache_noir

```

> **Nota:** Isso reiniciará o serviço `kmscon`. Sua tela piscará brevemente.

---

## ⚙️ Arquitetura Técnica

O projeto segue a estrutura de arquivos Linux Standard Base (LSB):

```text
/usr/local/bin/aurora       # O cérebro (Script Bash Principal)
/etc/aurora/themes/         # Onde vivem os arquivos .theme
/etc/kmscon/kmscon.conf     # Gerenciado automaticamente pelo Aurora
~/.config/starship.toml     # Gerado dinamicamente pelo Aurora

```

### Criando seus próprios temas

Basta criar um arquivo `.theme` em `/etc/aurora/themes/`. Exemplo:

```bash
THEME_NAME="Meu Tema Custom"
BG_COLOR="#1a1a1a"
FG_COLOR="#ffffff"
ACCENT="#ff0000"
# Paleta ANSI completa (0-15)...
PALETTE="..."

```

---

## 🤝 Contribuindo

Pull requests são bem-vindos! Se você criar uma nova paleta de cores interessante (além da Ganache), envie-a para a pasta `themes/`.

1. Faça um Fork do projeto.
2. Crie sua Feature Branch (`git checkout -b feature/AmazingTheme`).
3. Commit suas mudanças (`git commit -m 'Add AmazingTheme'`).
4. Push para a Branch (`git push origin feature/AmazingTheme`).
5. Abra um Pull Request.

---

## 📄 Licença

Distribuído sob a licença MIT. Veja `LICENSE` para mais informações.

---

<p align="center">
Desenvolvido com 🍫 e Bash puro.
</p>
