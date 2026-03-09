# ⚡ KIX Deployment Suite: The Sovereign Shadow Layer

![Bitcoin](https://img.shields.io/badge/Bitcoin-Lightning-orange)
![Docker](https://img.shields.io/badge/Docker-Required-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Privacy](https://img.shields.io/badge/Focus-Sovereignty-black)

KIX is a **Commercial Sovereignty Framework** designed to transition merchants from centralized, monitored rails to the Bitcoin Lightning Network. It is engineered to mimic the user experience of Brazil's Pix, effectively acting as a "Parallel Pixel" that bypasses financial surveillance and arbitrary banking freezes.

🌐 General information and documentation:  
https://satoshicanvas.com/kix-eng/

---

# 🇧🇷 The "Pix" Strategy: Cognitive Hacking

In Brazil, the state performed the largest mass training in history: teaching 150 million people to use QR codes for instant payments. KIX captures this doctrine.

* **Mimetismo (Mimicry):** KIX doesn't ask users to learn "crypto." It asks them to "Scan the Pink Pixel."
* **Economic Secession:** By leveraging the habit of the Pix flow, KIX replaces the Central Bank's oversight with a peer-to-peer Lightning engine.
* **Incentive Alignment:** "Why give 8% to the bank and state when you can keep 5% and give the customer 3% in sound-money points?"

---

# 🏗️ System Architecture

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


The system utilizes Docker encapsulation to provide horizontal scalability on a single host. Each instance contains:

* **Dashboard:** A centralized web interface (Homepage) for management.
* **Engine (LNbits):** A powerful Lightning Network payment processor.
* **Vault (Phoenixd / Alby Hub):** Secure key management and lightweight node connectivity.
* **Tor Bridge:** An Alpine-based routing container that generates unique Onion URLs in real-time.

---

# 🚀 Getting Started

## 1. Requirements

* **Docker**
* **Docker Compose**
* **Sudo privileges** (required for volume management and reading Tor hostnames)
* **Entropy helper (optional but recommended for Tor)**

If Tor is slow generating keys:

```bash
sudo apt install haveged
```

Docker must be installed and running before executing any deployment scripts.

---

# 2. Installation & Deployment Methods

| Method | Script | Description |
| :--- | :--- | :--- |
| 1. **Sovereign** | kix_tor_sovereign.sh | 🌑 Maximum Secession, Tor (.onion). Runs LNbits with **Alby Hub**. Requires configuring the **Nostr key from AlbyHub inside LNbits**. |
| 2. **Phoenixd** | kix_phoenixd.sh | 🔥 Ultra-lightweight multi-instance Phoenix node + LNbits + Tor. |
| 3. **Dedicated VPS** | kix_vps_dedicated.sh | 🌍 Public clearnet deployment on a dedicated VPS (Port 80). |
| 4. **Shared VPS + Bridge** | kix_vps_shared.sh + kix_vps_bridge.sh | 🌉 Hybrid architecture exposing a home node through a VPS using a secure tunnel. |

---

# 2.1 The Phoenixd Multi-Hunter Method (Recommended)

This method uses the `kix_phoenixd.sh` orchestrator to deploy isolated Phoenix nodes. It includes automatic volume management and environment backups.

### Setup

```bash
sudo chmod +x kix_phoenixd.sh
```

### Deploy Instance (Default is v1)

```bash
./kix_phoenixd.sh v1
```

### Deploy Instance "v8"

```bash
./kix_phoenixd.sh v8
```

### How it works

**Isolation**

Creates a directory like:

```
~/PHOENIX_[ID]
```

Each instance has unique Docker volumes preventing collisions.

### Automatic LNbits Configuration

The `kix_phoenixd.sh` script automatically configures **LNbits** with the correct **Phoenixd API endpoint and password**.

After deployment:

* LNbits is already connected to the Phoenix node
* The wallet is ready to **generate Lightning invoices immediately**
* No manual API configuration is required

### Important

Phoenix automatically opens its **first Lightning channel** when the wallet receives funds.

⚠️ The **first ~20,000 sats** are used by **ACINQ** to open the initial channel.

For this reason it is **critical to safely store the Phoenix seed words**.  
The seed is the only way to recover the wallet and its funds if the node or server is lost.

**Credentials**

The script generates:

* a **16-hex API password**
* `.env` file
* `env_backup.txt`

**Discovery**

The script scans Docker volumes to locate:

```
seed.dat
```

and prints the generated **Tor .onion address**.

---

# 2.2 The Sovereign Method (Tor + Alby Hub)

This is the **maximum sovereignty configuration**.

It runs:

* LNbits
* Tor hidden service
* **Alby Hub wallet backend**

LNbits must be connected to Alby Hub using the **Nostr key**.

### AlbyHub Configuration

1. Open **Alby Hub**
2. Copy your **Nostr private key**
3. Paste it inside **LNbits settings**
4. This links LNbits to the Alby Hub wallet.

### Run

```bash
sudo chmod +x kix_tor_sovereign.sh
```

```bash
./kix_tor_sovereign.sh 1
```

### Access

Use **Tor Browser** and open the `.onion` URL printed at the end of the script.

Allow **1–2 minutes** for Tor circuit propagation.

---

# 2.3 Dedicated VPS Method (Clearnet)

Use this when the VPS is **dedicated exclusively to KIX** and you want maximum performance on **Port 80**.

### Run

```bash
sudo chmod +x kix_vps_dedicated.sh
```

```bash
./kix_vps_dedicated.sh 1
```

---

# 2.4 Shared VPS + Bridge Method (Hybrid)

This architecture allows you to run the **Lightning node at home** while exposing services through a **public VPS gateway**.

The scripts must be executed **in this order**:

| Step | Script | Purpose |
|---|---|---|
| 1 | `kix_vps_shared.sh` | Deploys the public gateway on the VPS |
| 2 | `kix_vps_bridge.sh` | Connects the home node to the VPS |

This creates a hybrid topology:

```
Home Node → Secure Tunnel → Public VPS Gateway
```

### WireGuard / Tailscale Requirement

This bridge is designed to operate over a **WireGuard-based tunnel** (for example **Tailscale**).

The **user must configure the WireGuard/Tailscale connection manually** between the VPS and the home machine before running the bridge.

⚠️ The KIX scripts **do not configure the WireGuard network automatically**.

They assume the secure tunnel already exists.

### Run

```bash
sudo chmod +x kix_vps_shared.sh
```

```bash
./kix_vps_shared.sh
```

Then start the bridge:

```bash
sudo chmod +x kix_vps_bridge.sh
```

```bash
./kix_vps_bridge.sh
```

---

# 🧰 Management & Monitoring

## Check System Load

View CPU cores, memory usage, and uptime:

```bash
htop
```

---

## Monitor Container Resources

View real-time network and disk I/O:

```bash
sudo docker stats
```

---

## Cleanup Dangling Docker Data

Remove unused Docker volumes from old experiments:

```bash
sudo docker volume prune -f
```

---

# 🔐 Security Disclaimer

KIX is a tool for financial autonomy.

Users are responsible for:

* Their **keys**
* Their **node security**
* Their **legal compliance**

**Not your keys, not your coins.  
Not your node, not your rules.**

---

# 📦 Repository Metadata

**Repository:** `kix-protocol-suite`

**Topics**

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
