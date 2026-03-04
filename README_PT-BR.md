# ⚡ KIX Deployment Suite: A Camada Sombra Soberana

KIX é um **Framework de Soberania Comercial** projetado para migrar comerciantes de trilhos centralizados e monitorados para a Lightning Network do Bitcoin. Ele é desenvolvido para imitar a experiência de usuário do Pix brasileiro, atuando efetivamente como um "Pixel Paralelo" que contorna a vigilância financeira e bloqueios bancários arbitrários.

---

## 🇧🇷 A Estratégia "Pix": Hackeando a Cognição

No Brasil, o Estado realizou o maior treinamento em massa da história: ensinou 150 milhões de pessoas a usar QR codes para pagamentos instantâneos. O KIX captura essa doutrina.

* **Mimetismo:** O KIX não pede que os usuários aprendam "cripto". Ele pede que "Escaneiem o Pixel Rosa".
* **Secessão Econômica:** Ao aproveitar o hábito do fluxo do Pix, o KIX substitui a supervisão do Banco Central por um mecanismo peer-to-peer na Lightning.
* **Alinhamento de Incentivos:** "Por que dar 8% ao banco e ao Estado quando você pode ficar com 5% e dar 3% ao cliente em pontos de dinheiro sólido?"

---

## 🏗️ Arquitetura do Sistema

O sistema utiliza encapsulamento em Docker para fornecer escalabilidade horizontal em um único host. Cada instância contém:

* **Dashboard:** Uma interface web centralizada (Homepage) para gerenciamento.
* **Engine (LNbits):** Um poderoso processador de pagamentos na Lightning Network.
* **Cofre (Alby Hub):** Gerenciamento seguro de chaves e conectividade com o nó.
* **Ponte Tor:** Um contêiner baseado em Alpine que gera URLs Onion exclusivas em tempo real.

---

## 🚀 Primeiros Passos

### 1. Requisitos
* **Docker & Docker Compose** instalados e em execução.
* **Privilégios de sudo** (necessários para gerenciamento de volumes e leitura dos hostnames do Tor).
* **Entropia:** Se o Tor estiver lento para gerar chaves, execute:

sudo apt install haveged

### 2. Métodos de Instalação & Deploy

| Método | Script | Descrição |
| :--- | :--- | :--- |
| 1. **Soberano** | kix_tor_sovereign.sh | 🌑 Secessão Máxima, Tor (.onion). Contorna todos NATs/Firewalls. |
| 2. **Dedicado** | kix_vps_dedicated.sh | 🌍 Público, Alto Desempenho, Clearnet (Porta 80). VPS dedicada. |
| 3. **Compartilhado** | kix_vps_shared.sh | 🧱 Flexível, Servidores Compartilhados, Portas customizadas. Otimizado para Tailscale/VPN. |
| 4. **Ponte** | kix_vps_bridge.sh | 🌉 Híbrido, Local-para-Nuvem. Expõe o nó doméstico via VPS Pública. |

---

### 2.1 Método Soberano (Tor)

O script automatiza a limpeza, criação de diretórios, inicialização da Ponte Tor e injeção dinâmica de URLs no dashboard.

Execute:

sudo chmod +x kix_tor_sovereign.sh
./kix_tor_sovereign.sh 1

🌐 **Como Acessar:**  
Como essa infraestrutura é focada em privacidade, utilize o **Navegador Tor**. Cole as URLs `.onion` exibidas ao final do script. Aguarde 1–2 minutos para propagação.

---

### 2.2 Método VPS Dedicada (Clearnet)

Use quando a VPS for exclusivamente para o KIX e você desejar desempenho máximo na Porta 80.

Execute:

sudo chmod +x kix_vps_dedicated.sh
./kix_vps_dedicated.sh 1

---

### 2.3 Método Compartilhado/Ponte (Híbrido em Duas Etapas)

Hospede em hardware local (NATado/oculto), mas acesse via uma VPS Pública limpa como proxy através do Tailscale.

**Passo 1: No seu nó local (Casa/Oculto)**

./kix_vps_shared.sh 1  # Executa na Porta 8001

**Passo 2: Na sua VPS pública**

sudo chmod +x kix_vps_bridge.sh
./kix_vps_bridge.sh    # Mapeia VPS:80 -> Local:8001 (via Tailscale)

---

### 3. Provisionando uma Instância

Para implantar ou redefinir uma instância específica (por exemplo, instância número 7), execute o script desejado seguido pelo ID.

Exemplo:

./kix_tor_sovereign.sh 7

---

## 🧰 Stack Tecnológica
* **Dashboard:** Homepage
* **Engine Lightning:** LNbits
* **Gerenciamento de Chaves:** Alby Hub
* **Rede:** Tor / Nginx / Tailscale Mesh
* **Orquestração:** Docker Compose

---

## 🔐 Aviso de Segurança

O KIX é uma ferramenta de autonomia financeira. Os usuários são responsáveis por suas próprias chaves e conformidade legal.  

**Sem suas chaves, sem suas moedas. Sem seu nó, sem suas regras.**

---

## 📦 Metadados do Repositório
* **Nome do Repositório:** kix-protocol-suite
* **Tags:** bitcoin, lightning-network, soberania, pix-brasil, lnbits, privacidade, tecnologia-libertária, autocustódia
