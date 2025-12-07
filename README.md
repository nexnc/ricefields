# 🌾 Ricefields

> **NixOS 25.11 (Xantusia) Configuration**
> *Reproducible, Atomic, and Beautiful.*

![NixOS](https://img.shields.io/badge/NixOS-25.11-5277C3?style=for-the-badge&logo=nixos&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-Wayland-00A495?style=for-the-badge&logo=wayland&logoColor=white)

## 🖼️ Overview
My personal NixOS dotfiles, managed via **Flakes** and **Home Manager**.
Designed for a minimalist, keyboard-centric workflow using **Hyprland**.

* **WM:** Hyprland
* **Shell:** Fish
* **Terminal:** Foot
* **Editor:** Neovim
* **Bar:** Waybar

## 📂 Structure
* `flake.nix`: Entry point and dependencies.
* `configuration.nix`: System-wide settings (Boot, Networking, Hardware).
* `home/`: User configuration (packages, dotfiles, styling).
* `modules/`: Modularized configurations for cleaner management.

## 🛠️ Usage

### clone
```bash
git clone [https://gitlab.com/nexnc/ricefields.git](https://gitlab.com/nexnc/ricefields.git) ~/ricefields
cd ~/ricefields
