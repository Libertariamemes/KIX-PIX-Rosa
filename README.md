# 🛡️ KIX Soberano
### Multi-Instance SaaS Orchestrator over Tor

**KIX Soberano** is an automated tool for deploying isolated, sovereign instances of Bitcoin and Lightning Network infrastructure. By leveraging the Tor network, it ensures that every deployment is "shielded" and accessible globally via private `.onion` addresses.

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
* **Entropy:** If Tor is slow to generate keys, run `sudo apt install haveged`.

### 2. Installation
Clone the repository and prepare the orchestrator:
```bash
chmod +x kix_saas_rebuild.sh
```
### 3. Provisioning an Instance
To deploy or reset a specific instance (e.g., instance number 7), run:

```bash
./kix_saas_rebuild.sh 7
```

O Gemini disse
Markdown

### 3. Provisioning an Instance
To deploy or reset a specific instance (e.g., instance number 7), run:

```bash
./kix_saas_rebuild.sh 7
```
The script automates the following:

    Cleans up any legacy data or containers for that ID.

    Builds the isolated directory tree.

    Initializes the Tor Bridge and waits for cryptographic key generation.

    Dynamic Address Injection: Automatically captures the new .onion URLs and updates the Dashboard configuration.

🌐 How to Access

Because this infrastructure is focused on privacy, it is not accessible via standard browsers.

    Capture the Output: The script will display your unique addresses upon completion.

    Use Tor Browser: Paste the .onion URLs into the Tor Browser.

    Propagation: Allow 1–2 minutes for the Tor network to recognize the new hidden services.

