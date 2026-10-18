# Ricefields

<div align="center">

![NixOS](https://img.shields.io/badge/NixOS-26.05-5277C3.svg?style=for-the-badge&logo=nixos&logoColor=white)
![Flakes](https://img.shields.io/badge/Nix-Flakes-7EB5D6.svg?style=for-the-badge&logo=nixos&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)
![Security](https://img.shields.io/badge/Security-Hardened-red.svg?style=for-the-badge)

**A modular, security-hardened, declarative NixOS environment managed via Nix Flakes.**

**Mirrors:** [GitHub](https://github.com/nexnc/ricefields) (source of truth) · [GitLab](https://gitlab.com/nexnc/ricefields) · [Codeberg](https://codeberg.org/nexnc/ricefields)

</div>

---

## Architecture

Ricefields uses a modular flake structure that cleanly separates system-level NixOS configuration from user-space Home Manager modules. Every host is assembled by a single builder (`modules/mkHost.nix`), so adding a machine means adding a small host file rather than copying a whole configuration.

```
.
├── flake.lock
├── flake.nix                        # Flake entry point, defines hosts
├── hosts                            # One directory per machine
│   ├── comet
│   │   ├── comet.nix
│   │   └── hardware-configuration.nix
│   ├── gamma
│   │   ├── gamma.nix
│   │   └── hardware-configuration.nix
│   ├── kerr
│   │   ├── hardware-configuration.nix
│   │   └── kerr.nix
│   └── raven                        # Workstation (AMD GPU, containers, local AI)
│       ├── containers               # Podman services (Cloudflared, Portainer)
│       │   ├── cloudflared.nix
│       │   ├── default.nix
│       │   └── portainer.nix
│       ├── hardware-configuration.nix
│       ├── hardware.nix             # AMD GPU, disk mounts, hardware specifics
│       ├── LocalAI                  # Ollama + Open WebUI
│       │   ├── default.nix
│       │   └── ollama.nix
│       └── raven.nix                # Host entry point
├── LICENSE
├── modules
│   ├── desktop                      # NixOS-level desktop stack
│   │   ├── default.nix
│   │   ├── fonts.nix
│   │   ├── niri.nix
│   │   ├── packages.nix
│   │   ├── security.nix
│   │   ├── services.nix
│   │   ├── steam.nix
│   │   └── stylix.nix
│   ├── environments                 # Development toolchains
│   │   ├── cpp.nix
│   │   ├── python.nix
│   │   └── rust.nix
│   ├── home                         # Home Manager (user-level)
│   │   ├── desktop                  # Niri, Waybar, Hyprlock, SwayNC, etc.
│   │   │   ├── default.nix
│   │   │   ├── hyprlock.nix
│   │   │   ├── ironbar.nix
│   │   │   ├── niri.nix
│   │   │   ├── swaync.nix
│   │   │   ├── swww.nix
│   │   │   ├── theme.nix
│   │   │   ├── waybar.nix
│   │   │   ├── wlogout.nix
│   │   │   └── wofi.nix
│   │   ├── home-cli.nix
│   │   ├── home-core.nix
│   │   ├── home.nix                 # HM entry point
│   │   ├── programs                 # CLI & GUI applications
│   │   │   ├── default.nix
│   │   │   ├── direnv.nix
│   │   │   ├── fish.nix
│   │   │   ├── foot.nix
│   │   │   ├── fzf.nix
│   │   │   ├── git.nix
│   │   │   ├── gitui.nix
│   │   │   ├── gpg.nix
│   │   │   ├── jujutsu.nix
│   │   │   ├── lazygit.nix
│   │   │   ├── mpv.nix
│   │   │   ├── neovim.nix
│   │   │   ├── rmpc.nix
│   │   │   ├── sequoia.nix
│   │   │   ├── ssh.nix
│   │   │   ├── starship.nix
│   │   │   ├── yazi.nix
│   │   │   ├── zellij.nix
│   │   │   └── zoxide.nix
│   │   ├── scripts
│   │   │   ├── default.nix
│   │   │   └── wall-cycle.nix
│   │   └── services
│   │       ├── default.nix
│   │       ├── gnome-keyring.nix
│   │       └── mpd.nix
│   ├── mkHost.nix                   # Host builder used by flake.nix
│   └── system                       # NixOS system-level (shared by hosts)
│       ├── boot.nix                 # Bootloader, kernel, ZRAM
│       ├── default.nix              # Imports all system modules
│       ├── fish.nix
│       ├── hardware-utils.nix       # PipeWire audio
│       ├── networking.nix           # Firewall, NetworkManager, ports
│       ├── nix-settings.nix         # GC, substituters, experimental features
│       ├── profile.nix
│       ├── sops.nix                 # Sops-nix secret paths and config
│       ├── users.nix                # User accounts, passwords, Home Manager
│       └── virtualization.nix       # Podman, Libvirt, Virt-manager
├── README.md
├── secrets                          # All secrets encrypted at rest
│   ├── cloudflared.yaml             # Sops-encrypted Cloudflare tunnel token
│   ├── gpg-master-key.asc.age       # Age-encrypted GPG master key backup
│   ├── gpg-public-key.asc.age       # Age-encrypted GPG public key backup
│   ├── gpg-subkeys.asc.age          # Age-encrypted GPG subkeys backup
│   ├── key.age                      # Age private key (encrypted with passphrase)
│   └── user-password.yaml           # Sops-encrypted user password hashes
└── wallpapers
    └── nix.jpg
```

---

## Hosts

| Host    | Entry point                | Notes                                              |
|---------|----------------------------|----------------------------------------------------|
| `raven` | `hosts/raven/raven.nix`    | Workstation: AMD GPU, Podman services, local AI    |
| `kerr`  | `hosts/kerr/kerr.nix`      |                                                    |
| `comet` | `hosts/comet/comet.nix`    |                                                    |
| `gamma` | `hosts/gamma/gamma.nix`    |                                                    |

Each host directory holds its own generated `hardware-configuration.nix`; everything shared lives in `modules/`.

---

## Security Stack

```
Age passphrase (230-bit entropy)
        │
        ▼
  secrets/key.age  ──────────────────────────────────────┐
        │                                                 │
        ▼                                                 │
  /var/lib/sops-nix/key.txt                              │
        │                                                 │
        ├──▶ secrets/user-password.yaml                  │
        ├──▶ secrets/cloudflared.yaml                    │
        ├──▶ secrets/gpg-master-key.asc.age  ◀───────────┘
        ├──▶ secrets/gpg-subkeys.asc.age
        └──▶ secrets/gpg-public-key.asc.age
                    │
                    ▼
            GPG Master Key [C]
              ├── [S] Sign subkey       ──▶ git commit signing
              ├── [E] Encrypt subkey    ──▶ file/sops encryption
              ├── [A] Auth subkey 1     ──▶ SSH: GitHub / GitLab / Codeberg
              └── [A] Auth subkey 2     ──▶ SSH: personal servers
```

**Security properties**

- No plaintext secrets anywhere — all secrets encrypted at rest, decrypted only at system activation
- No SSH private key files — SSH identities derived from GPG auth subkeys via gpg-agent
- No password authentication — SSH key-only, root login disabled
- Atomic user state — `users.mutableUsers = false`, all accounts declared in config
- Git is safe to be public — every sensitive file is encrypted before commit
- 230-bit passphrase entropy — computationally infeasible to brute force under any realistic attack model

---

## Design Principles

**Scrollable tiling** via Niri — a fluid, modern Wayland compositor with scroll-based tiling workflow.

**Single source of truth** — the git repository is the complete and authoritative description of the system. Manual changes are discarded on rebuild.

**One builder, many hosts** — `modules/mkHost.nix` assembles every machine from the same shared modules, so a new host is a small file plus its hardware config.

**Cryptographic secret management** via SOPS-nix and Age. Secrets are decrypted only at system activation time and never written to the Nix store in plaintext.

**Atomic immutability** enforced by `users.mutableUsers = false`. All user accounts and password hashes are declared within the Nix configuration and cannot drift.

**Performance tuning** — kernel and AMD GPU tweaks (RADV, Vulkan) with ZRAM swap.

**GPG as SSH root of trust** — a single GPG keyring manages both commit signing and SSH authentication. Restoring the GPG master key is sufficient to recover all SSH identities.

---

## System Management

Fish abbreviations — all paths and hostnames are resolved dynamically from `networking.hostName`:

| Abbreviation    | Expands To                                              |
|-----------------|---------------------------------------------------------|
| `systemupdate`  | `sudo nixos-rebuild switch --flake <flake>#<host>`     |
| `flakeupdate`   | `sudo nix flake update --flake <flake>`                |
| `nixconfig`     | `nvim <flake>/hosts/<host>/<host>.nix`                 |
| `homeconfig`    | `nvim <flake>/modules/home/home.nix`                   |
| `fishconfig`    | `nvim <flake>/modules/home/programs/fish.nix`          |
| `niriconfig`    | `nvim <flake>/modules/home/desktop/niri.nix`           |

Modern CLI replacements:

| Legacy  | Replacement    | Notes                        |
|---------|----------------|-------------------------------|
| `ls`    | `eza --icons`  | Enhanced file listing        |
| `cd`    | `z` (zoxide)   | Fast directory jumping       |
| `cat`   | `bat`          | Syntax-highlighted pager     |
| `grep`  | `rg` (ripgrep) | Fast recursive search        |
| `find`  | `fd`           | Fast, user-friendly find     |
| `top`   | `btop`         | Advanced system monitor      |
| `df`    | `duf`          | Modern disk usage            |
| `du`    | `dust`         | Intuitive disk usage         |
| `ps`    | `procs`        | Modern process viewer        |

---

## Fresh Installation

Replace `<host>` with one of `raven`, `kerr`, `comet` or `gamma`.

### Prerequisites

- NixOS minimal ISO booted
- Disk partitioned with EFI and root partitions
- Network connected

### Step 1 — Partition and format

```bash
# Example layout (adjust device names as needed)
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- mkpart primary 512MB 100%
parted /dev/sda -- set 1 esp on

mkfs.fat -F 32 -n boot /dev/sda1
mkfs.ext4 -L nixos /dev/sda2
```

### Step 2 — Mount and generate the hardware config

```bash
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

nixos-generate-config --root /mnt
```

### Step 3 — Clone the repository

`nixos-generate-config` creates `/mnt/etc/nixos`, so keep its hardware file, clear the directory, then clone into it:

```bash
nix-shell -p git age

cp /mnt/etc/nixos/hardware-configuration.nix /tmp/
rm -rf /mnt/etc/nixos

git clone https://github.com/nexnc/ricefields.git /mnt/etc/nixos
cd /mnt/etc/nixos

cp /tmp/hardware-configuration.nix hosts/<host>/hardware-configuration.nix
git add hosts/<host>/hardware-configuration.nix   # flakes only see tracked files
```

### Step 4 — Place the Age key

```bash
mkdir -p /mnt/var/lib/sops-nix
# Decrypt key.age using your age passphrase
age --decrypt secrets/key.age > /mnt/var/lib/sops-nix/key.txt
chmod 600 /mnt/var/lib/sops-nix/key.txt
```

### Step 5 — Install

```bash
# Passwords come from sops, so skip the interactive root password prompt
nixos-install --no-root-passwd --flake .#<host>
reboot
```

---

## Adding a New Host

1. Create `hosts/<hostname>/<hostname>.nix` as the host entry point
2. Copy `hardware-configuration.nix` from `nixos-generate-config` into the same directory
3. Add a `hardware.nix` next to it if the machine needs hardware-specific config
4. Register the host in `flake.nix` through `modules/mkHost.nix`
5. Track the new files (`git add hosts/<hostname>`), then build:
   `sudo nixos-rebuild switch --flake /etc/nixos#<hostname>`

---

## GPG Key Information

| Key | ID | Usage |
|-----|----|-------|
| Master | `0xCDC7E9A2F52F0356` | Certify only, never used daily |
| Sign | `0xDC9F9D4EAA4F9406` | Git commit and tag signing |
| Encrypt | `0xD46A2BDD5DF7C9A6` | File and sops encryption |
| Auth (git) | `0xBA51E1614C368250` | SSH: GitHub, GitLab, Codeberg |
| Auth (servers) | `0xBD99DFE3D861B558` | SSH: personal servers |

Subkeys expire every 5 years. To renew:

```bash
gpg --expert --edit-key 0xCDC7E9A2F52F0356
gpg> key <subkey-number>
gpg> expire
gpg> save
# re-export and re-encrypt to secrets/
```

---
**Note:** This README is AI-Generated (I get lazy when writing documentation)
---

<div align="center">
Author: NEXNC &nbsp;·&nbsp; Hosts: raven · kerr · comet · gamma &nbsp;·&nbsp; Target: NixOS 26.05 &nbsp;·&nbsp; License: MIT
</div>


