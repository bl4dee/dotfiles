# NixOS Generation Changelog

## Retroactive History (pre-changelog)

### Generations 27-35 — 2026-04-05

**Changes:** Migration day. Switched to AMD CPU / systemd-boot, migrated desktop to 1TB NVMe with btrfs subvolumes, moved imperative nix profile packages into flake, added openrazer, removed old laptop config, added performance tracking with package diff between generations. Gen 30 tested an older nixpkgs snapshot (kernel 6.18.2), gen 34 tested unstable nixpkgs (kernel 6.19.10).

**Why:** Full system migration to new hardware/disk layout and flake restructure.

### Generations 36-38 — 2026-04-05 to 2026-04-06

**Changes:** Added imsprog to flake.

**Why:** Needed imsprog tool.

### Generations 39-41 — 2026-04-07

**Changes:** Minor rebuilds, stable config. Gen 40 (Apr 17) was another unstable nixpkgs test (kernel 6.19.11).

**Why:** Testing and stabilization after migration.

### Generation 42 — 2026-05-24

**Changes:** Unknown — no matching GitHub commits. Likely a local-only change or flake update.

**Why:** Unknown.

### Generations 43-45 — 2026-07-11 to 2026-07-13

**Changes:** Added HP Omen Max 16 laptop host, fixed Hyprland GPU list crash on laptop, disabled panel self refresh, forced performance profile on AC, set NVIDIA GPU rendering on laptop, removed rustdesk, updated determinate to 3.21.2, fixed openrazer src fetch.

**Why:** Setting up new laptop and cleaning up packages.

### Generation 46 — 2026-08-04

**Changes:** Unknown — no matching GitHub commits. Likely nvidia.nix or common.nix tweaks during GPU testing sessions.

**Why:** GPU testing period.

### Generation 47 — 2026-08-05 (LAST STABLE)

**Changes:** Created amd-gpu.nix module (not imported). Tested RX 480 (worked) and GeForce 210 (black screen — nvidia 580.x doesn't support it). AMD module import was rolled back in the same session.

**Why:** Attempting multi-GPU-vendor support for GPU testing workflow.

### Generation 48 — 2026-08-06 (BROKEN — REMOVED)

**Changes:** Modified nvidia.nix: enabled modesetting, added `boot.blacklistedKernelModules = lib.mkForce ["nvidiafb"]` to un-blacklist nouveau as fallback for old GPUs.

**Why:** Tried to make old unsupported NVIDIA GPUs (Kepler, GeForce 210) auto-fall-back to nouveau.

**Failure:** Display dies after login. The mkForce overrode NixOS's default nouveau blacklist, causing nouveau + proprietary nvidia to both load and conflict.

### Generation 49 — 2026-08-11 (BROKEN — REMOVED)

**Changes:** Added GameMode config and gamescope for CS2 optimization. Built on top of gen 48's broken nvidia.nix.

**Why:** CS2 performance tuning, but inherited the display-breaking nvidia.nix from gen 48.

**Failure:** Same display death as gen 48 — nouveau/nvidia conflict.

---

## Active Changelog

_Entries below are logged automatically by Claude Code after each rebuild._

### Generation 48 — 2026-11-05

**Changes:**
- Reverted broken nvidia.nix: removed `boot.blacklistedKernelModules = lib.mkForce ["nvidiafb"]` (the nouveau fallback hack that killed display in old gens 48-49)
- Refactored desktop config: split `desktopConfiguration` into `desktopBase` (shared) + `desktopConfiguration` (base + nvidia) + `desktopNouveau` (base + nouveau)
- Created `modules/features/nouveau.nix`: uses modesetting driver, blacklists all proprietary nvidia modules, lets nouveau auto-load for old GPUs (Kepler, Fermi, etc.)
- Added `nixosConfigurations.nouveau` flake output for a separate boot profile
- Added CLAUDE.md and CHANGELOG.md to repo

**Why:** Enable hassle-free testing of old legacy GPUs (GTX 510, 770, etc.) alongside modern cards. Instead of the failed nouveau+nvidia dual-load approach, this uses separate boot profiles — pick "nvidia" or "nouveau" from systemd-boot menu. Nouveau profile built with: `sudo nixos-rebuild boot -p nouveau --flake ~/dotfiles#nouveau`
