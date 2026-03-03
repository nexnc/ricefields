# Ricefields

<div align="center">

![NixOS](https://img.shields.io/badge/NixOS-25.11-5277C3.svg?style=for-the-badge&logo=nixos&logoColor=white)
![Flakes](https://img.shields.io/badge/Nix-Flakes-7EB5D6.svg?style=for-the-badge&logo=nixos&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)
![Security](https://img.shields.io/badge/Security-Hardened-red.svg?style=for-the-badge)

A modular, security-hardened, declarative NixOS environment managed via Nix Flakes.

**Mirrors:** [GitLab](https://gitlab.com/nexnc/ricefields) (source of truth) · [GitHub](https://github.com/nexnc/ricefields) · [Codeberg](https://codeberg.org/nexnc/ricefields)

</div>

---

## Architecture

Ricefields uses a modular flake structure that cleanly separates system-level NixOS configuration from user-space Home Manager modules, ensuring reproducible and atomic state across hardware targets.

```
.
├── flake.nix                        # Flake entry point, defines hosts
├── flake.lock
├── hosts/
│   ├── kerr/                        # Workstation (AMD GPU, Zen kernel)
│   │   ├── default.nix              # Host entry point, imports modules
│   │   ├── hardware.nix             # AMD GPU, disk mounts, hardware specifics
│   │   ├── hardware-configuration.nix
│   │   └── containers/              # Podman services (workstation only)
│   │       ├── default.nix
│   │       ├── cloudflared.nix
│   │       └── portainer.nix
│   └── vm/
│       └── default.nix
├── modules/
│   ├── home/                        # Home Manager (user-level)
│   │   ├── home.nix                 # HM entry point
│   │   ├── desktop/                 # Niri, Waybar, Hyprlock, SwayNC, etc.
│   │   │   ├── default.nix
│   │   │   ├── hyprlock.nix
│   │   │   ├── niri.nix
│   │   │   ├── swaync.nix
│   │   │   ├── swww.nix
│   │   │   ├── theme.nix
│   │   │   ├── waybar.nix
│   │   │   ├── wlogout.nix
│   │   │   └── wofi.nix
│   │   ├── programs/                # CLI & GUI applications
│   │   │   ├── default.nix
│   │   │   ├── direnv.nix
│   │   │   ├── fish.nix
│   │   │   ├── foot.nix
│   │   │   ├── fzf.nix
│   │   │   ├── git.nix
│   │   │   ├── gitui.nix
│   │   │   ├── gpg.nix
│   │   │   ├── lazygit.nix
│   │   │   ├── neovim.nix
│   │   │   ├── rmpc.nix
│   │   │   ├── ssh.nix
│   │   │   ├── starship.nix
│   │   │   ├── yazi.nix
│   │   │   ├── zellij.nix
│   │   │   └── zoxide.nix
│   │   └── services/
│   │       ├── default.nix
│   │       └── mpd.nix
│   └── system/                      # NixOS system-level (shared by all hosts)
│       ├── default.nix              # Imports all system modules
│       ├── boot.nix                 # Zen kernel, systemd-boot, v4l2loopback
│       ├── desktop.nix              # Greetd, portals, fonts, keyring
│       ├── hardware-utils.nix       # Pipewire, Bluetooth, Zram
│       ├── networking.nix           # Firewall, NetworkManager, ports
│       ├── nix-settings.nix         # GC, substituters, experimental features
│       ├── sops.nix                 # Sops-nix secret paths and config
│       ├── users.nix                # User accounts, passwords, Home Manager
│       └── virtualization.nix       # Podman, Libvirt, Virt-manager
├── secrets/                         # All secrets encrypted at rest
│   ├── cloudflared.yaml             # Sops-encrypted Cloudflare tunnel token
│   ├── user-password.yaml           # Sops-encrypted user password hashes
│   ├── key.age                      # Age private key (encrypted with passphrase)
│   ├── gpg-master-key.asc.age       # Age-encrypted GPG master key backup
│   ├── gpg-subkeys.asc.age          # Age-encrypted GPG subkeys backup
│   └── gpg-public-key.asc.age       # Age-encrypted GPG public key backup
└── templates/                       # Nix flake dev environment templates
    ├── blank/
    ├── cpp/
    ├── python/
    └── rust/
```

---

## Security Stack

```
SLIP39 shards (4-of-7)
  ├── 2x laser-etched titanium strips (separate physical locations)
  ├── 2x Filen.io (encrypted cloud)
  ├── 2x Proton Drive (encrypted cloud, separate jurisdiction)
  └── 1x additional location
        │
        ▼
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

### Security Properties

- **No plaintext secrets anywhere** — all secrets encrypted at rest, decrypted only at system activation
- **No SSH private key files** — SSH identities derived from GPG auth subkeys via gpg-agent
- **No password authentication** — SSH key-only, root login disabled
- **Atomic user state** — `users.mutableUsers = false`, all accounts declared in config
- **Git is safe to be public** — every sensitive file is encrypted before commit
- **230-bit passphrase entropy** — computationally infeasible to brute force under any realistic attack model
- **4-of-7 SLIP39 threshold** — requires simultaneous compromise of 4 separate physical/cloud locations

---

## Design Principles

**Scrollable tiling** via Niri — a fluid, modern Wayland compositor with scroll-based tiling workflow.

**Single source of truth** — the git repository is the complete and authoritative description of the system. Manual changes are discarded on rebuild.

**Cryptographic secret management** via SOPS-nix and Age. Secrets are decrypted only at system activation time and never written to the Nix store in plaintext.

**Atomic immutability** enforced by `users.mutableUsers = false`. All user accounts and password hashes are declared within the Nix configuration and cannot drift.

**Performance tuning** via the Zen kernel with AMD-specific optimizations (RADV, ROCm) and ZRAM enabled.

**GPG as SSH root of trust** — a single GPG keyring manages both commit signing and SSH authentication. Restoring the GPG master key is sufficient to recover all SSH identities.

---

## System Management

Fish abbreviations — all paths and hostnames are resolved dynamically from `networking.hostName`:

| Abbreviation    | Expands To                                              |
|-----------------|---------------------------------------------------------|
| `systemupdate`  | `sudo nixos-rebuild switch --flake <flake>#<host>`     |
| `flakeupdate`   | `sudo nix flake update --flake <flake>`                |
| `nixconfig`     | `sudo nvim <flake>/hosts/<host>/default.nix`           |
| `homeconfig`    | `sudo nvim <flake>/modules/home/home.nix`              |
| `fishconfig`    | `sudo nvim <flake>/modules/home/programs/fish.nix`     |
| `niriconfig`    | `sudo nvim <flake>/modules/home/desktop/niri.nix`      |

Modern CLI replacements:

| Legacy  | Replacement    | Notes                        |
|---------|----------------|------------------------------|
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

### Step 2 — Mount and install

```bash
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

nixos-generate-config --root /mnt
```

### Step 3 — Place Age key

```bash
mkdir -p /mnt/var/lib/sops-nix
# Decrypt key.age using your age passphrase (reconstructed from SLIP39 shards)
age --decrypt secrets/key.age > /mnt/var/lib/sops-nix/key.txt
chmod 600 /mnt/var/lib/sops-nix/key.txt
```

### Step 4 — Clone and build

```bash
git clone https://gitlab.com/nexnc/ricefields.git /mnt/etc/nixos
cd /mnt/etc/nixos

# Copy generated hardware config
cp /mnt/etc/nixos/hardware-configuration.nix hosts/kerr/hardware-configuration.nix

nixos-install --flake .#kerr
reboot
```

---

## Disaster Recovery

This section documents the complete reconstruction procedure from absolute worst case — total hardware loss with nothing except the SLIP39 shards.

### What survives total hardware loss

```
Git repository (public, all secrets encrypted)   ✓ survives
SLIP39 shards (4-of-7, titanium + cloud)         ✓ survives
secrets/key.age (in git, encrypted)              ✓ survives
secrets/gpg-*.asc.age (in git, encrypted)        ✓ survives
SSH public keys (deployed to GitHub/servers)     ✓ survives
```

### Full reconstruction — step by step

#### Phase 1: Reconstruct Age passphrase from SLIP39 shards

Gather any 4 of your 7 SLIP39 shards. Use a SLIP39-compatible tool to reconstruct the passphrase:

```bash
# install slip39 tool if needed
nix-shell -p python3Packages.slip39

# reconstruct passphrase from shards
python3 -m slip39 recover
# enter shards one by one when prompted
# outputs your age passphrase
```

#### Phase 2: Decrypt Age private key

```bash
# clone the repo first
git clone https://gitlab.com/nexnc/ricefields.git ~/ricefields
cd ~/ricefields

# decrypt age key using reconstructed passphrase
age --decrypt secrets/key.age > /tmp/age-key.txt
# enter passphrase when prompted
```

#### Phase 3: Install NixOS

Follow the Fresh Installation steps above (partition, format, mount).

#### Phase 4: Place Age key before first build

```bash
mkdir -p /mnt/var/lib/sops-nix
cp /tmp/age-key.txt /mnt/var/lib/sops-nix/key.txt
chmod 600 /mnt/var/lib/sops-nix/key.txt

# shred plaintext key
shred -u /tmp/age-key.txt
```

#### Phase 5: Build and boot

```bash
cp -r ~/ricefields /mnt/etc/nixos
nixos-install --flake /mnt/etc/nixos#kerr
reboot
```

Sops-nix will automatically decrypt `user-password.yaml` and `cloudflared.yaml` on first activation using the age key.

#### Phase 6: Restore GPG keyring

After booting into the new system:

```bash
# decrypt GPG master key backup
age --decrypt /etc/nixos/secrets/gpg-master-key.asc.age > /tmp/gpg-master-key.asc
age --decrypt /etc/nixos/secrets/gpg-subkeys.asc.age > /tmp/gpg-subkeys.asc

# import into GPG keyring
gpg --import /tmp/gpg-master-key.asc
gpg --import /tmp/gpg-subkeys.asc

# set ultimate trust
gpg --edit-key 0xCDC7E9A2F52F0356
gpg> trust
# select 5 (ultimate)
gpg> save

# shred plaintext exports
shred -u /tmp/gpg-master-key.asc /tmp/gpg-subkeys.asc
```

#### Phase 7: Restore SSH access

```bash
# restart gpg-agent with SSH support
systemctl --user stop gpg-agent.service gpg-agent.socket
systemctl --user start gpg-agent-ssh.socket gpg-agent.socket

# set TTY for pinentry
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye

# verify SSH keys are available
ssh-add -L
# should show two ed25519 keys
```

#### Phase 8: Verify everything works

```bash
# SSH to git hosts
ssh -T git@github.com
ssh -T git@gitlab.com
ssh -T git@codeberg.org

# SSH to personal server
ssh root@<server-ip>

# test signed commit
cd /tmp && git init test && cd test
git commit --allow-empty -m "test"
git log --show-signature
# should show: Good signature from "NEXNC <git@nexnc.com>"

# cleanup
rm -rf /tmp/test
```

#### Phase 9: Re-encrypt and verify key.age

```bash
# re-encrypt age key from current key.txt
age -p -o /etc/nixos/secrets/key.age /var/lib/sops-nix/key.txt
# enter your age passphrase

# verify decryption works
age --decrypt /etc/nixos/secrets/key.age
# should output AGE-SECRET-KEY-...
```

### Recovery time estimate

| Phase | Time |
|-------|------|
| SLIP39 reconstruction | ~5 minutes |
| NixOS installation | ~15 minutes |
| First rebuild (download) | ~30 minutes |
| GPG restore | ~5 minutes |
| Verification | ~5 minutes |
| **Total** | **~60 minutes** |

---

## Adding a New Host

1. Create `hosts/<hostname>/default.nix` importing `../../modules/system` and host-specific hardware
2. Create `hosts/<hostname>/hardware.nix` with hardware-specific config
3. Copy `hardware-configuration.nix` from `nixos-generate-config`
4. Add the host to `flake.nix` under `nixosConfigurations`
5. Build: `sudo nixos-rebuild switch --flake /etc/nixos#<hostname>`

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

<div align="center">
Author: NEXNC &nbsp;·&nbsp; Host: kerr.nexnc.com &nbsp;·&nbsp; Target: NixOS 25.11 (Xantusia) &nbsp;·&nbsp; License: MIT
</div>
