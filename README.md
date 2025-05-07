# **Semaphore CI/CD Automated Installer**

**One-Click Automated Semaphore CI/CD Setup for Ubuntu Server**

## **🚀 Project Description**

This project provides a **fully automated shell script** to install and configure **Semaphore CI/CD** on an **Ubuntu Server (22.04/24.04)** with minimal manual intervention.

### **🔹 Key Features**

✔ **Single-command installation** (`./install.sh`)  
✔ **Non-interactive setup** (via `.env` configuration)  
✔ **Automatic dependency handling** (Kubernetes, Helm, Ambassador/Emissary-ingress, Certbot)  
✔ **SSL/TLS setup** (Auto-request certificates via Certbot)  
✔ **Resource-optimized configurations** (Supports 2GB RAM → 8GB+ servers)  
✔ **Detailed logging & error handling**  
✔ **Idempotent & re-runnable** (Safe for updates)

### **🔹 Supported Stack**

- **Ubuntu Server** (22.04 LTS / 24.04 LTS)
- **Kubernetes** (k3s for lightweight setups)
- **Helm** (For Semaphore deployment)
- **Ambassador/Emissary-ingress** (API Gateway)
- **Certbot** (Let’s Encrypt SSL certificates)

---

## **🛠️ Build & Run Instructions**

### **📥 Prerequisites**

1. **Fresh Ubuntu Server** (22.04/24.04 recommended)
2. **Minimum 2GB RAM, 2 vCPUs, 20GB Disk**
3. **Root or sudo access**
4. **A domain name (for SSL setup)**

### **⚙️ Installation Steps**

#### **1️⃣ Clone the Repository**

```bash
git clone https://github.com/cybergir/Semaphore-CICD-Automated-Installer.git
cd semaphore-cicd-automated-installer
```

#### **2️⃣ Configure `.env` File**

Copy the example config and modify it:

```bash
cp configs/.env.example configs/.env
nano configs/.env  # Edit with your settings
```

**Example `.env` Configuration:**

```ini
# Domain & SSL
DOMAIN=yourdomain.com
EMAIL=admin@yourdomain.com

# Kubernetes
KUBERNETES_VERSION=v1.28
INSTALL_K3S=true

# Semaphore
SEMAPHORE_ADMIN_EMAIL=admin@yourdomain.com
SEMAPHORE_ADMIN_PASSWORD=ChangeMe123
```

#### **3️⃣ Run the Installer**

```bash
chmod +x scripts/install.sh
sudo ./scripts/install.sh
```

**Optional Flags:**

- `--logs` → Save logs to `./logs/install.log`
- `--skip-deps` → Skip dependency checks (if already installed)
- `--dry-run` → Test without making changes

#### **4️⃣ Verify Installation**

After completion, check:

```bash
kubectl get pods -n semaphore
curl -I https://$DOMAIN  # Should return HTTP 200
```

---

## **📜 Post-Installation**

✅ **Access Semaphore Dashboard:**

- URL: `https://thegarnetiagroup.com`
- Login using the credentials from `.env`

✅ **Uninstall (if needed):**

```bash
sudo ./scripts/install.sh --uninstall
```

---

## **📂 Repository Structure**

```
📁 semaphore-cicd-automated-installer/
├── 📁 configs/           # Configuration files
├── 📁 scripts/           # Main installer & helper scripts
├── 📁 docs/              # Documentation
├── 📁 tests/             # Verification scripts
└── README.md            # This guide
```

---

## **📌 Notes**

- **For small servers (2GB RAM),** the script automatically applies optimized Helm values.
- **SSL setup requires a valid domain & open ports (80/443).**
- **Check `/logs/install.log` for troubleshooting.**
