# System configuration

The flake constructs NixOS and Darwin systems from `hosts/<name>/default.nix`.
Each host selects shared profiles, optional features, and its own hardware settings.
All Nix module imports are explicit.

```text
hosts/                    Machine identity, hardware, and feature selections
profiles/nixos/           Shared Linux base, workstation, and server selections
profiles/darwin/          Shared Mac workstation selection
modules/common/           Portable system settings and optional shared tools
modules/nixos/            Linux features, desktop sessions, and services
modules/darwin/           macOS settings, packages, accounts, and Homebrew
home/                     Home Manager modules
home/profiles/            Selections of personal configuration
dots/                     Application configuration linked by Home Manager
```

## Where to make a change

- Change one machine's features in `hosts/<name>/default.nix`.
- Change both Linux workstations in `profiles/nixos/workstation.nix`.
- Change settings shared by all Linux hosts in `profiles/nixos/base.nix`.
- Change the Mac workstation selection in `profiles/darwin/workstation.nix`.
- Change portable defaults for every system in `modules/common/default.nix`.
- Change shared personal dotfiles and browser selections in
  `home/profiles/workstation.nix`.

`modules/common/default.nix` imports only universal defaults. Neovim and Home
Manager integration are optional common modules, selected by workstation profiles.
Neovim and its tools remain system packages on both platforms. The server retains
its minimal Vim setup and does not enable Home Manager.

## Selecting features

For example, a Linux host can select the workstation profile and add gaming:

```nix
{
  imports = [
    ./hardware.nix
    ../../profiles/nixos/workstation.nix
    ../../modules/nixos/gaming.nix
  ];
}
```

Desktop sessions are also selected in each host. Lovelace and Pascal currently
select Niri, Hyprland, i3, and DMS, preserving their existing setup. Niri and
Hyprland share the Wayland tools module. The DMS greeter imports DMS and Niri
because its configured greeter compositor is Niri; remove or replace the greeter
selection too if removing Niri.

The server selects Nextcloud and Tailscale explicitly. Its Nextcloud hostname
lives in `hosts/server/default.nix`, while its laptop and power settings live in
`hosts/server/power.nix`. NVIDIA configuration belongs to each desktop's
`graphics.nix`.

Adding a file to a module directory does not enable it. Import it from a profile
or host, and add new files to Git before using the Git-backed flake.

## Checking changes

Evaluate the Linux system derivations without building or activating them:

```sh
nix eval --no-write-lock-file --json .#nixosConfigurations \
  --apply 'configs: builtins.mapAttrs (_: c: c.config.system.build.toplevel.drvPath) configs'
```

Evaluate the Mac configuration:

```sh
nix eval --no-write-lock-file --raw .#darwinConfigurations.m5.system.drvPath
```

Keep each host's `system.stateVersion` and `home/default.nix`'s
`home.stateVersion` unchanged when reorganising modules.
