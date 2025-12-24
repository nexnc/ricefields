# Ricefields

<div align="center">

![NixOS](https://img.shields.io/badge/NixOS-25.11-5277C3.svg?style=for-the-badge&logo=nixos&logoColor=white)
![Flakes](https://img.shields.io/badge/Nix-Flakes-7EB5D6.svg?style=for-the-badge&logo=nixos&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)
![Security](https://img.shields.io/badge/Security-Hardened-red.svg?style=for-the-badge&logo=security&logoColor=white)

**NixOS 25.11 (Xantusia) Infrastructure**  
A modular, security-hardened, and declarative environment managed via Nix Flakes.

[![SOPS](https://img.shields.io/badge/Secrets-SOPS--nix-orange?style=flat-square&logo=1password&logoColor=white)](https://github.com/Mic92/sops-nix)
[![Age](https://img.shields.io/badge/Encryption-Age-blue?style=flat-square&logo=gnuprivacyguard&logoColor=white)](https://age-encryption.org/)
[![Zen Kernel](https://img.shields.io/badge/Kernel-Zen-purple?style=flat-square&logo=linux&logoColor=white)](https://github.com/zen-kernel/zen-kernel)
[![Fish Shell](https://img.shields.io/badge/Shell-Fish-green?style=flat-square&logo=fishshell&logoColor=white)](https://fishshell.com/)

### 📦 Repository Mirrors

[![GitLab](https://img.shields.io/badge/GitLab-Source%20of%20Truth-FC6D26?style=flat-square&logo=gitlab&logoColor=white)](https://gitlab.com/nexnc/ricefields)
[![GitHub](https://img.shields.io/badge/GitHub-Mirror-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/gitnexnc/ricefields)
[![Codeberg](https://img.shields.io/badge/Codeberg-Mirror-2185D0?style=flat-square&logo=codeberg&logoColor=white)](https://codeberg.org/nexnc/ricefields)

> **Note**: The **GitLab repository** is the source of truth. GitHub and Codeberg are read-only mirrors updated via one-way synchronization. Please submit all issues and merge requests to GitLab.

</div>

---

## 🏗️ Architecture Overview

Ricefields is a professional-grade NixOS configuration designed for high-integrity systems. It utilizes a modular flake architecture to separate system logic from user-space configuration, ensuring a reproducible and atomic state across different hardware targets.

## 🎯 Design Principles

- **🔐 Cryptographic Sovereignty**: Zero-trust secret management using SOPS-nix and Age. No sensitive data (passwords, tokens, or private keys) is stored in plaintext within the repository.
- **⚛️ Atomic Immutability**: The system utilizes `users.mutableUsers = false`. All user accounts and password hashes are defined strictly within the Nix configuration, preventing unauthorized runtime modifications.
- **⚡ Performance Optimization**: Built on the Zen Kernel for improved desktop responsiveness and optimized for high-speed NVMe throughput.
- **🦀 Modern Tooling**: Replaces legacy GNU utilities with high-performance Rust-based alternatives (e.g., `eza`, `bat`, `ripgrep`).

## 🔒 Security Model

The security of this infrastructure relies on asymmetric encryption and strictly defined access controls.

- **Secret Management**: Sensitive strings are encrypted in `.yaml` files using AES-256-GCM via SOPS. These are only decrypted during the system activation phase by a local Age private key.
- **Passphrase Entropy**: Core backups and master archives utilize 200+ bit entropy passphrases, rendering brute-force attacks mathematically infeasible.
- **Integrity Enforcement**: Manual changes to `/etc/` or system-level binaries are discarded upon reboot or rebuild, maintaining a consistent "Source of Truth" from the Git repository.
- **SSH Hardening**: Key-only authentication is enforced; password authentication and root login are disabled globally.

## ⚙️ System Management & Workflow

The environment is managed through a comprehensive set of Fish shell abbreviations designed for rapid infrastructure updates and maintenance.

### NixOS Management

| Command | Action |
|---------|--------|
| `systemupdate` | Rebuild system using the desktop flake output |
| `flakeupdate` | Update all flake inputs for the desktop target |
| `nixconfig` | Edit the primary system configuration |
| `homeconfig` | Edit the Home Manager user configuration |
| `fishconfig` | Edit the shell configuration and abbreviations |

### Modern CLI Alternatives

| Legacy | Modern Replacement | Description |
|--------|-------------------|-------------|
| `ls` | `eza` | Enhanced file listing with icons and Git integration |
| `cat` | `bat` | Syntax highlighting and Git integration |
| `grep` | `rg` (ripgrep) | Extremely fast recursive search |
| `find` | `fd` | User-friendly alternative to find |
| `top` | `btop` | Advanced TUI system monitor |
| `df` | `duf` | Modern disk usage utility |
| `du` | `dust` | Visual directory usage analyzer |

## 🚀 Deployment and Disaster Recovery

Deploying this configuration to a new machine requires manual injection of the Age private key to permit the decryption of system secrets.

### 1. Key Restoration

The private key must be placed in the standard SOPS location before the first build.

```bash
# Initialize the configuration directory
mkdir -p ~/.config/sops/age/

# Securely copy your Age private key (keys.txt) to the target path
# Ensure the file contains your X25519 identity
nano ~/.config/sops/age/keys.txt

# Enforce strict file permissions
chmod 600 ~/.config/sops/age/keys.txt
```

### 2. Infrastructure Initialization

```bash
# Clone the repository
git clone https://gitlab.com/nexnc/ricefields.git ~/ricefields
cd ~/ricefields

# Apply the desktop profile
sudo nixos-rebuild switch --flake .#desktop
```

## 🗺️ Roadmap

- **Phase 1**: Transition to LUKS2 full-disk encryption on Gen5 NVMe hardware to protect data at rest.
- **Phase 2**: Implement BTRFS as the primary filesystem, utilizing subvolumes for atomic snapshots and `snapper` integration.
- **Phase 3**: Full Impermanence implementation, mounting the root directory on `tmpfs` to ensure a "pristine" state on every boot.

---

<div align="center">

**Author**: [NEXNC](https://gitlab.com/nexnc)  
**Target**: NixOS 25.11 (Xantusia)  
**License**: MIT

[![Made with NixOS](https://img.shields.io/badge/Made%20with-NixOS-5277C3.svg?style=flat-square&logo=nixos&logoColor=white)](https://nixos.org)
[![Powered by Rust](https://img.shields.io/badge/Powered%20by-Rust-orange.svg?style=flat-square&logo=rust&logoColor=white)](https://www.rust-lang.org/)

</div>
