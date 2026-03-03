# 🛡️ KIX Soberano: Multi-Instance SaaS over Tor

KIX Soberano is an automated orchestrator for deploying isolated instances of Bitcoin and Lightning Network infrastructure via the Tor network. With a single command, the script provisions a complete ecosystem (Dashboard, Wallet Engine, and Key Vault) accessible globally through .onion addresses.

## 🏗️ System Architecture
Each instance is encapsulated within its own directory and virtual network, enabling horizontal scalability (SaaS) on the same hardware:

* **Dashboard (Homepage):** A centralized entry point for the user.
* **Engine (LNbits):** A robust and extensible Lightning payment processor.
* **Vault (Alby Hub):** Sovereign key management and Lightning node connection.
* **Tor Bridge:** A dedicated Alpine container that routes traffic from each service to the Onion network, generating unique URLs in real-time.

## 🚀 How to Use

### 1. Requirements
* Docker and Docker Compose installed.
* `sudo` privileges for volume manipulation and reading Tor hostnames.

### 2. Installation
Clone this repository and grant execution permissions to the script:

```bash
chmod +x kix_saas_rebuild.sh


### 3. Provisioning an Instance
To create or rebuild instance v7, for example:

```bash
./kix_saas_rebuild.sh 7


### 🌐 Accessing Your Instance
Once the script completes, it will output unique `.onion` addresses for your Dashboard, Engine, and Vault.

1. **Save these addresses:** Store them in a safe place, as they are your only way to access the sovereign infrastructure.
2. **Use Tor Browser:** These URLs are only accessible via the **Tor Browser** or a browser configured to use the Tor proxy.
3. **Wait for Propagation:** It may take 1–2 minutes after the containers start for the Tor network to fully propagate the new hidden service addresses.
