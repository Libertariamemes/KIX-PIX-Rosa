# ⚡ KIX Deployment Suite: The Sovereign Shadow Layer

![Bitcoin](https://img.shields.io/badge/Bitcoin-Lightning-orange)
![Docker](https://img.shields.io/badge/Docker-Required-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Privacy](https://img.shields.io/badge/Focus-Sovereignty-black)

KIX é um **Framework de Soberania Comercial** projetado para permitir que comerciantes façam a transição de sistemas centralizados e monitorados para a rede Bitcoin Lightning. Ele foi projetado para imitar a experiência de uso do Pix no Brasil, funcionando efetivamente como um **“Pixel Paralelo”** que contorna vigilância financeira e bloqueios arbitrários de bancos.

🌐 Informações gerais e documentação:  
https://satoshicanvas.com/kix-eng/

---

# 🇧🇷 A Estratégia do "Pix": Engenharia Cognitiva

No Brasil, o Estado realizou o maior treinamento em massa da história: ensinou mais de 150 milhões de pessoas a usar QR codes para pagamentos instantâneos. O KIX captura essa doutrina.

* **Mimetismo:** O KIX não pede que o usuário aprenda “cripto”. Ele apenas pede que **escaneie o Pixel Rosa**.
* **Secessão Econômica:** Aproveitando o hábito do fluxo do Pix, o KIX substitui a supervisão do Banco Central por um motor de pagamentos peer-to-peer baseado em Lightning.
* **Alinhamento de Incentivos:** “Por que dar 8% para o banco e para o Estado quando você pode ficar com 5% e dar 3% ao cliente em pontos de dinheiro sólido?”

---

# 🏗️ Arquitetura do Sistema

                    ┌────────────────────────────┐
                    │        Merchant UI         │
                    │   (KIX Dashboard-homepage) │
                    └─────────┬──────────────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │      LNbits       │
                    │  Payment Engine   │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │  Lightning Node   │
                    │ Phoenixd / Alby   │
                    └─────────┬─────────┘
                              │
                ┌─────────────┴─────────────┐
                │                           │
                ▼                           ▼
        Tor Hidden Service          VPS Gateway
          (.onion access)           (Port 80)

O sistema utiliza encapsulamento com Docker para fornecer **escalabilidade horizontal em um único host**. Cada instância contém:

* **Dashboard:** Interface web centralizada (Homepage) para gerenciamento.
* **Engine (LNbits):** Um poderoso processador de pagamentos Lightning.
* **Vault (Phoenixd / Alby Hub):** Gerenciamento seguro de chaves e conexão com nó Lightning leve.
* **Tor Bridge:** Container baseado em Alpine que gera URLs Onion únicas em tempo real.

---

# 🚀 Primeiros Passos

## 1. Requisitos

* **Docker**
* **Docker Compose**
* **Privilégios sudo** (necessários para gerenciamento de volumes e leitura dos hostnames do Tor)
* **Gerador de entropia (opcional, mas recomendado para Tor)**

Se o Tor estiver demorando para gerar chaves:

```bash
sudo apt install haveged
```

O Docker deve estar instalado e em execução antes de executar qualquer script de deploy.

---

# 2. Métodos de Instalação e Deploy

| Método | Script | Descrição |
| :--- | :--- | :--- |
| 1. **Soberano** | kix_tor_sovereign.sh | 🌑 Máxima secessão, Tor (.onion). Executa LNbits com **Alby Hub**. Requer configurar a **chave Nostr do AlbyHub dentro do LNbits**. |
| 2. **Phoenixd** | kix_phoenixd.sh | 🔥 Nó Phoenix multi-instância ultra leve + LNbits + Tor. |
| 3. **VPS Dedicado** | kix_vps_dedicated.sh | 🌍 Deploy público em clearnet em um VPS dedicado (porta 80). |
| 4. **VPS Compartilhado + Bridge** | kix_vps_shared.sh + kix_vps_bridge.sh | 🌉 Arquitetura híbrida que expõe um nó doméstico através de um VPS usando um túnel seguro. |

---

# 2.1 Método Phoenixd Multi-Hunter (Recomendado)

Este método utiliza o orquestrador `kix_phoenixd.sh` para implantar nós Phoenix isolados. Ele inclui gerenciamento automático de volumes e backups de ambiente.

### Setup

```bash
sudo chmod +x kix_phoenixd.sh
```

### Implantar Instância (padrão v1)

```bash
./kix_phoenixd.sh v1
```

### Implantar Instância "v8"

```bash
./kix_phoenixd.sh v8
```

### Como funciona

**Isolamento**

Cria um diretório como:

```
~/PHOENIX_[ID]
```

Cada instância possui volumes Docker únicos, evitando colisões de dados.

### Configuração Automática do LNbits

O script `kix_phoenixd.sh` configura automaticamente o **LNbits** com o **endpoint da API do Phoenixd e a senha correta**.

Após o deploy:

* O LNbits já está conectado ao nó Phoenix
* A carteira já está pronta para **gerar invoices Lightning imediatamente**
* Nenhuma configuração manual de API é necessária

### Importante

O Phoenix abre automaticamente seu **primeiro canal Lightning** quando a carteira recebe fundos.

⚠️ Os **primeiros ~20.000 sats** são usados pela **ACINQ** para abrir o canal inicial.

Por isso é **fundamental guardar com segurança as palavras seed do Phoenix**.  
A seed é a única forma de recuperar a carteira e os fundos caso o servidor ou nó seja perdido.

**Credenciais**

O script gera:

* uma **senha de API de 16 caracteres hexadecimais**
* arquivo `.env`
* `env_backup.txt`

**Descoberta**

O script varre os volumes Docker para localizar:

```
seed.dat
```

e imprime o endereço **.onion do Tor** gerado.

---

# 2.2 Método Soberano (Tor + Alby Hub)

Esta é a configuração de **máxima soberania**.

Ela executa:

* LNbits
* Serviço oculto do Tor
* Backend de carteira **Alby Hub**

O LNbits deve ser conectado ao Alby Hub usando a **chave Nostr**.

### Configuração do AlbyHub

1. Abra o **Alby Hub**
2. Copie sua **chave privada Nostr**
3. Cole nas **configurações do LNbits**
4. Isso conecta o LNbits à carteira do Alby Hub

### Executar

```bash
sudo chmod +x kix_tor_sovereign.sh
```

```bash
./kix_tor_sovereign.sh 1
```

### Acesso

Use o **Tor Browser** e abra o endereço `.onion` exibido ao final do script.

Aguarde **1–2 minutos** para propagação do circuito Tor.

---

## 2.2.1 Método Multi-Instância com Bind Mount

Esta é a evolução do Método Soberano, projetada especificamente para alta disponibilidade e backups facilitados. Diferente dos volumes padrão do Docker, este método utiliza Bind Mounts, mapeando os dados dos containers diretamente para pastas visíveis no seu diretório home.

### Principais Vantagens:

- **Visibilidade de Dados:** Todos os bancos de dados Lightning e chaves Tor são armazenados em `~/KIX_PROTOTIPO[ID]/data`.
- **Backups Simples:** Você pode fazer o backup de todo o seu nó apenas copiando uma pasta local, sem comandos complexos de exportação de volume.
- **Robustez:** Evita a perda de dados durante atualizações do Docker ou migrações de containers.

### Implantação:

```bash
sudo chmod +x kix_multi_tor_bind_mount.sh
./kix_multi_tor_bind_mount.sh 9
```

### Estrutura de Pastas Criada:

O script organiza automaticamente sua soberania:

- `~/KIX_PROTOTIPO9/data/lnbits`: Bancos de dados SQLite e extensões.
- `~/KIX_PROTOTIPO9/data/alby`: Suas chaves e configurações do Alby Hub.
- `~/KIX_PROTOTIPO9/data/tor`: Endereços `.onion` permanentes (não mudam se o container reiniciar).

### Pós-Instalação:

Após o script exibir seus links `.onion`, lembre-se de:

- Acessar seu Alby Hub via link Tor.
- Conectá-lo ao LNbits usando o Nostr Wallet Connect (NWC) ou a chave interna da conta.

Seus dados agora são persistentes e estão fisicamente em `~/KIX_PROTOTIPO9`.

# 2.3 Método VPS Dedicado (Clearnet)

Use este método quando o VPS for **dedicado exclusivamente ao KIX** e você quiser **máximo desempenho na porta 80**.

### Executar

```bash
sudo chmod +x kix_vps_dedicated.sh
```

```bash
./kix_vps_dedicated.sh 1
```

---

# 2.4 Método VPS Compartilhado + Bridge (Híbrido)

Esta arquitetura permite rodar o **nó Lightning em casa** enquanto expõe os serviços através de um **VPS público**.

Os scripts devem ser executados **nesta ordem**:

| Passo | Script | Função |
|---|---|---|
| 1 | `kix_vps_shared.sh` | Implanta o gateway público no VPS |
| 2 | `kix_vps_bridge.sh` | Conecta o nó doméstico ao VPS |

Isso cria a seguinte topologia híbrida:

```
Home Node → Secure Tunnel → Public VPS Gateway
```

### Requisito WireGuard / Tailscale

Essa bridge foi projetada para operar sobre um **túnel baseado em WireGuard** (por exemplo **Tailscale**).

O **usuário deve configurar manualmente** a conexão WireGuard/Tailscale entre o VPS e a máquina doméstica antes de executar a bridge.

⚠️ Os scripts do KIX **não configuram automaticamente a rede WireGuard**.

Eles assumem que o túnel seguro já existe.

### Executar

```bash
sudo chmod +x kix_vps_shared.sh
```

```bash
./kix_vps_shared.sh
```

Depois iniciar a bridge:

```bash
sudo chmod +x kix_vps_bridge.sh
```

```bash
./kix_vps_bridge.sh
```

---

# 🧰 Gerenciamento e Monitoramento

## Verificar carga do sistema

Ver CPU, memória e uptime:

```bash
htop
```

---

## Monitorar recursos dos containers

Ver tráfego de rede e I/O de disco em tempo real:

```bash
sudo docker stats
```

---

## Limpar volumes Docker não utilizados

Remover volumes antigos de experimentos:

```bash
sudo docker volume prune -f
```

---

# 🔐 Aviso de Segurança

KIX é uma ferramenta de autonomia financeira.

Os usuários são responsáveis por:

* suas **chaves**
* a **segurança do nó**
* sua **conformidade legal**

**Not your keys, not your coins.  
Not your node, not your rules.**

---

# 📦 Metadados do Repositório

**Repositório:** `kix-protocol-suite`

**Tópicos**

```
bitcoin
lightning-network
lnbits
phoenixd
albyhub
pix-brazil
self-custody
privacy
sovereignty
```
