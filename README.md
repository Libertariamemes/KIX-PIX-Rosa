# ⚡ KIX Deployment Suite: The Sovereign Shadow Layer

KIX is a **Commercial Sovereignty Framework** designed to transition merchants from centralized, monitored rails to the Bitcoin Lightning Network. It is engineered to mimic the user experience of Brazil's Pix, effectively acting as a "Parallel Pixel" that bypasses financial surveillance and arbitrary banking freezes.

---

## 🇧🇷 The "Pix" Strategy: Cognitive Hacking

In Brazil, the state performed the largest mass training in history: teaching 150 million people to use QR codes for instant payments. KIX captures this doctrine.

* **Mimetismo (Mimicry):** KIX doesn't ask users to learn "crypto." It asks them to "Scan the Pink Pixel."
* **Economic Secession:** By leveraging the habit of the Pix flow, KIX replaces the Central Bank's oversight with a peer-to-peer Lightning engine.
* **Incentive Alignment:** "Why give 8% to the bank and state when you can keep 5% and give the customer 3% in sound-money points?"

---

## 🏗️ System Architecture

The system utilizes Docker encapsulation to provide horizontal scalability on a single host. Each instance contains:

* **Dashboard:** A centralized web interface (Homepage) for management.
* **Engine (LNbits):** A powerful Lightning Network payment processor.
* **Vault (Alby Hub):** Secure key management and node connectivity.
* **Tor Bridge:** An Alpine-based routing container that generates unique Onion URLs in real-time.

---

## 🚀 Getting Started

### 1. Requirements
* **Docker & Docker Compose** installed and running.
* **Sudo privileges** (required for volume management and reading Tor hostnames).
* **Entropy:** If Tor is slow to generate keys, run:

```bash
sudo apt install haveged
```

### 2. Installation & Deployment Methods

| Method | Script | Description |
| :--- | :--- | :--- |
| 1. **Sovereign** | kix_tor_sovereign.sh | 🌑 Maximum Secession, Tor (.onion). Bypasses all NAT/Firewalls. |
| 2. **Dedicated** | kix_vps_dedicated.sh | 🌍 Public, High Performance, Clearnet (Port 80). VPS is dedicated. |
| 3. **Shared** | kix_vps_shared.sh | 🧱 Flexible, Shared Servers, Custom ports. Optimized for Tailscale/VPN. |
| 4. **Bridge** | kix_vps_bridge.sh | 🌉 Hybrid, Local-to-Cloud. Exposes home node via Public VPS. |

---

### 2.1 The Sovereign Method (Tor)

The script automates cleanup, directory building, Tor Bridge initialization, and dynamic URL injection into the dashboard.

Run:

```bash
sudo chmod +x kix_tor_sovereign.sh
./kix_tor_sovereign.sh 1
```

🌐 **How to Access:**  
Because this infrastructure is focused on privacy, use the **Tor Browser**. Paste the `.onion` URLs displayed at the end of the script. Allow 1–2 minutes for propagation.

---

### 2.2 The Dedicated VPS Method (Clearnet)

Use this when the VPS is exclusively for KIX and you want maximum performance on Port 80.

Run:

```bash
sudo chmod +x kix_vps_dedicated.sh
./kix_vps_dedicated.sh 1
```

---

### 2.3 The Shared/Bridge Method (Two-Step Hybrid)

Host on local hardware (NATed/hidden) but access via a clean Public VPS proxy via Tailscale.

**Step 1: On your local node (Home/Hidden)**

```bash
./kix_vps_shared.sh 1  # Runs on Port 8001
```

**Step 2: On your public VPS**

```bash
sudo chmod +x kix_vps_bridge.sh
./kix_vps_bridge.sh    # Maps VPS:80 -> Local:8001 (via Tailscale)
```

---

### 3. Provisioning an Instance

To deploy or reset a specific instance (e.g., instance number 7), run the desired script followed by the ID.

Example:

```bash
./kix_tor_sovereign.sh 7
```

---

## 🧰 Tech Stack
* **Dashboard:** Homepage
* **Lightning Engine:** LNbits
* **Key Management:** Alby Hub
* **Network:** Tor / Nginx / Tailscale Mesh
* **Orchestration:** Docker Compose

---

## 🔐 Security Disclaimer

KIX is a tool for financial autonomy. Users are responsible for their own keys and compliance.  

**Not your keys, not your coins. Not your node, not your rules.**

---

## 📦 Repository Metadata
* **Repository Name:** kix-protocol-suite
* **Topic Tags:** bitcoin, lightning-network, sovereignty, pix-brazil, lnbits, privacy, libertarian-tech, self-custody
