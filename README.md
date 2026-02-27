# Ricefields

<div align="center">

![NixOS](https://img.shields.io/badge/NixOS-25.11-5277C3.svg?style=for-the-badge&logo=nixos&logoColor=white)
![Flakes](https://img.shields.io/badge/Nix-Flakes-7EB5D6.svg?style=for-the-badge&logo=nixos&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)
![Security](https://img.shields.io/badge/Security-Hardened-red.svg?style=for-the-badge)

A modular, security-hardened, declarative NixOS environment managed via Nix Flakes.

**Mirrors:** [GitLab](https://gitlab.com/nexnc/ricefields) (source of truth) · [GitHub](https://github.com/nexnc/ricefields)· [CodeBerg](https://codeberg.org/nexnc/ricefields)

</div>

---

## Architecture

Ricefields uses a modular flake structure that separates system-level configuration from user-space, ensuring reproducible and atomic state across hardware targets.

```
.
├── flake.nix
├── flake.lock
├── home/
│   ├── home.nix
│   └── modules/
│       ├── desktop/          # Niri, Waybar, Hyprlock, SwayNC, etc.
│       │   ├── default.nix
│       │   ├── hyprlock.nix
│       │   ├── niri.nix
│       │   ├── swaync.nix
│       │   ├── swww.nix
│       │   ├── theme.nix
│       │   ├── waybar.nix
│       │   ├── wlogout.nix
│       │   └── wofi.nix
│       ├── programs/         # CLI & GUI applications
│       │   ├── default.nix
│       │   ├── direnv.nix
│       │   ├── fish.nix
│       │   ├── foot.nix
│       │   ├── fzf.nix
│       │   ├── git.nix
│       │   ├── gitui.nix
│       │   ├── gpg.nix
│       │   ├── lazygit.nix
│       │   ├── ncmpcpp.nix
│       │   ├── neovim.nix
│       │   ├── ssh.nix
│       │   ├── starship.nix
│       │   ├── tmux.nix
│       │   ├── yazi.nix
│       │   └── zoxide.nix
│       └── services/         # User services (MPD, etc.)
│           ├── default.nix
│           └── mpd.nix
├── hosts/
│   ├── desktop/
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── containers/       # Podman/Docker services
│   │       ├── cloudflared.nix
│   │       ├── default.nix
│   │       └── portainer.nix
│   └── vm/
│       └── configuration.nix
├── secrets/                  # SOPS-nix encrypted secrets
│   ├── cloudflared.yaml
│   ├── key.age
│   └── user-password.yaml
└── templates/                # DevShell templates
    ├── blank/
    ├── cpp/
    ├── python/
    └── rust/
```

---

## Design Principles

**Scrollable tiling** via Niri; a fluid, modern Wayland compositor workflow.

**Cryptographic secret management** via SOPS-nix and Age. No sensitive data is stored in plaintext; secrets are decrypted only at system activation time using a local Age key.

**Atomic immutability** enforced by `users.mutableUsers = false`. All user accounts and password hashes are declared within the Nix configuration and cannot drift.

**Performance tuning** via the Zen kernel with AMD-specific optimizations (RADV, ROCm) and ZRAM enabled.

---

## Security

- SSH is configured for key-only authentication; password login and root login are disabled.
- Manual changes to system-level binaries are discarded on reboot the Git repository is the authoritative source of truth.
- Secrets are scoped to system activation and never written to the Nix store in plaintext.

---

## System Management

Fish abbreviations for common maintenance tasks:

| Abbreviation   | Command                                                        |
|----------------|----------------------------------------------------------------|
| `systemupdate` | `sudo nixos-rebuild switch --flake /etc/nixos#desktop`        |
| `flakeupdate`  | `sudo nix flake update --flake /etc/nixos#desktop`            |
| `nixconfig`    | `sudo nvim /etc/nixos/hosts/desktop/configuration.nix`        |
| `homeconfig`   | `sudo nvim /etc/nixos/home/home.nix`                          |
| `fishconfig`   | `sudo nvim /etc/nixos/home/modules/programs/fish.nix`         |

Modern CLI replacements:

| Legacy  | Replacement     | Notes                     |
|---------|-----------------|---------------------------|
| `ls`    | `eza --icons`   | Enhanced file listing     |
| `cd`    | `z` (zoxide)    | Fast directory jumping    |
| `cat`   | `bat`           | Syntax-highlighted pager  |
| `grep`  | `rg` (ripgrep)  | Fast recursive search     |
| `top`   | `btop`          | Advanced system monitor   |
| `df`    | `duf`           | Modern disk usage         |

---

## Deployment

1. Place your Age private key at the SOPS-nix default location (e.g. `/var/lib/sops-nix/key.txt`).

2. Clone and build:

```bash
git clone https://gitlab.com/nexnc/ricefields.git ~/ricefields
cd ~/ricefields
sudo nixos-rebuild switch --flake .#desktop
```

---

<div align="center">
Author: NEXNC &nbsp;·&nbsp; Target: NixOS 25.11 (Xantusia) &nbsp;·&nbsp; License: MIT
</div>
<div align="center">
Disclaimer: Currently in experimental stage, so things may break (sorry!)
</div>
