# Crypto-recovery / forensics toolchain.
#
# All the host-side tools needed by the "one in a million" project to scan
# drives directly on the host (no VM). Includes:
#   - Filesystem mounting tools (NTFS via in-kernel ntfs3, exFAT, HFS+, APFS)
#   - SMART / drive info tools (smartctl, hdparm)
#   - Forensic carvers (bulk_extractor, sleuthkit, photorec via testdisk,
#     ddrescue, foremost, scalpel)
#   - OCR (tesseract for CPU pool — GPU EasyOCR is added in a follow-up
#     module after we've confirmed the host-side scan works)
#   - QR code reader (zbar)
#   - Document text extraction (pdftotext via poppler)
#   - Registry hive reader (chntpw)
#   - YARA for future rule-based scanning
#   - Python 3 with Pillow, pyudev, rich, etc.

_: {
  flake.nixosModules.cryptoRecovery = { config, pkgs, lib, ... }: {
    environment.systemPackages = with pkgs; [
      # ----------- core forensics carvers -----------
      bulk_extractor      # high-speed parallel pattern carver (deep mode engine)
      sleuthkit           # fls / icat / mmls / fsstat / etc
      foremost            # signature-based file carver
      scalpel             # parallel header/footer carver
      testdisk            # ships photorec for deleted-file carving
      gddrescue           # ddrescue for damaged drives

      # ----------- filesystem support -----------
      ntfs3g              # NTFS userspace driver fallback (kernel ntfs3 is built-in)
      exfat               # exFAT FUSE driver
      exfatprogs          # exFAT mkfs/fsck
      hfsprogs            # HFS+ tools
      apfs-fuse           # APFS userspace reader (nixpkgs patches the upstream compile errors)
      apfsprogs           # APFS analysis tools

      # ----------- drive info / SMART -----------
      smartmontools       # smartctl
      hdparm              # serial / firmware lookup
      parted              # GPT partition tool
      util-linux          # lsblk / blkid / mount / umount

      # ----------- OCR + QR -----------
      tesseract           # CPU OCR — English data is bundled by default
      zbar                # QR code reader (zbarimg)

      # ----------- document text extraction -----------
      poppler-utils       # pdftotext for PDF text layer
      antiword            # ancient .doc text

      # ----------- Windows hive reading -----------
      chntpw              # offline NTUSER.DAT reader

      # ----------- pattern engines -----------
      yara                # for future YARA-rule-based wallet detection
      ripgrep             # blazing fast grep used in post-processing

      # ----------- archive / compressed file handling -----------
      _7zz                # 7-Zip for the carvers' decompression
      unrar               # for RAR archive scanning
      file                # magic-number file type detection

      # ----------- support utilities -----------
      jq                  # JSON tooling for the registry
      sqlite              # SQLite CLI
      libfaketime         # used for some timestamp normalization

      # ----------- python with the recovery deps -----------
      # NOTE: easyocr (GPU OCR) is added in a follow-up step. For now we only
      # need pillow / pyudev / rich / etc. for the existing scanner code.
      (python3.withPackages (ps: with ps; [
        pillow              # PIL for image content filter
        pyudev              # block device events
        rich                # nicer TUI
        tabulate            # tabular output
        python-magic        # libmagic bindings
      ]))
    ];

    # ntfs3 is in-kernel (Linux 5.15+); load on demand via modprobe
    boot.kernelModules = [ "ntfs3" ];

    # APFS read/write kernel module (linux-apfs-rw via DKMS).
    # Provides `mount -t apfs ...` natively.
    boot.extraModulePackages = [ config.boot.kernelPackages.apfs ];
  };
}
