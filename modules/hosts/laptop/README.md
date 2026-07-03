# laptop — HP OMEN MAX 16-ak0xxx

Added 2026-07-02 from a fresh NixOS 26.05 install (user `blink`, stateVersion `26.05` — overridden with `mkForce` because `common` pins the desktop's original `24.11`).

## hardware

| component | detail |
|---|---|
| CPU | AMD Ryzen AI 9 HX 375 (Strix Point, 12c/24t), `kvm-amd`, amd_pstate |
| RAM | 64 GB |
| dGPU | NVIDIA RTX 5080 Max-Q/Mobile, Blackwell GB203M (`10de:2c19`) at `0000:c2:00.0` → `PCI:194:0:0` |
| iGPU | AMD Radeon 890M (`1002:150e`) at `0000:c3:00.0` → `PCI:195:0:0` |
| panel | 16" 2560x1600 (eDP) |
| disk | WD PC SN5000S 1 TB NVMe: ext4 root `f984ee0a-6a04-4790-ae41-5ab20f3e4da1`, vfat ESP `0D91-C9C4`, no swap |
| ethernet | Realtek RTL8125 2.5GbE (`enp192s0`, `r8169`) |
| wifi | MediaTek MT7922 (`wlo1`, `mt7921e`) |
| firmware | BIOS F.07 at install time; fwupd enabled for LVFS updates |

(`linuxPackages_latest` is for Strix Point, which likes new kernels; the wifi is
fine on anything remotely recent.)

## display topology (MUX / Advanced Optimus)

The internal panel is wired to **both** GPUs; in hybrid mode (default) it shows up as
`eDP-2` on the AMD iGPU. If the MUX hands it to NVIDIA it becomes `eDP-1`. The **HDMI
port is hardwired to the dGPU**; USB-C DP-alt outputs sit on the iGPU. The hyprland
home module gates monitor rules on `osConfig.networking.hostName`, and on the laptop
pins the render device to the iGPU via `AQ_DRM_DEVICES` (stable `by-path` names, so
card enumeration order doesn't matter).

## nvidia

Blackwell is **only supported by the open kernel modules**, so this host sets
`hardware.nvidia.open = true` and keeps its own nvidia block instead of importing the
shared `nvidia` module (desktop uses `open = false`). PRIME render offload with
`enableOffloadCmd` gives `nvidia-offload <cmd>` for running things on the dGPU, and
`powerManagement.finegrained` lets it power off (RTD3) when idle/on battery.

## quirks and caveats

- **first rebuild on a fresh machine** (stock nix, hostname still `nixos`):
  `sudo env NIX_CONFIG="experimental-features = nix-command flakes" nixos-rebuild switch --flake ~/dotfiles#laptop`
  — afterwards the `rebuild` alias works as-is.
- **captive portals**: `networking` + `anonymity` pin DNS to local dnscrypt-proxy;
  hotel/café portals need a temporary escape hatch (e.g. `resolvectl dns wlo1 <portal dns>`).
- **noctalia bar** has no battery widget (settings are baked into the shared wrapper);
  battery state is visible via the control-center profile card / upower.
- **openrazer** is intentionally not imported — that fork exists for the desktop case's
  LED controller.
- crates.io rate-limits nixpkgs' cargo-vendor fetcher on bursty first builds; if a rust
  package's `-vendor-staging` FOD 403s, just retry once the network is quiet.
