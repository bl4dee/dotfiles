_: {
  flake.homeModules.development = {
    pkgs,
    lib,
    ...
  }: {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    home.packages = with pkgs; [
      # version control
      gitui

      # python
      python314
      ty
      ruff

      # rust
      rust-analyzer
      rustfmt

      # go
      gopls
      (lib.lowPrio gotools)
      delve

      # zig
      # zls  # broken in nixpkgs
      zig

      # typescript/javascript
      bun
      typescript-language-server
      prettierd

      # docker
      docker
      dockerfile-language-server
      virtiofsd
      cloudflared

      # database
      mongodb-compass

      # shell
      bash-language-server
      shfmt

      # nix
      nil
      statix
      alejandra
      manix

      # typst
      typst
      tinymist

      # hardware tools
      imsprog

      # security and pentesting
      nmap
      wireshark
      strace
      feroxbuster
      burpsuite
      ghidra
      gdb
      gef
      imhex
      exploitdb
      wordlists
      crunch
      # john broken
      pwntools
      binwalk
      glances
      xxd
      expect

      # ai
      claude-code
      opencode

      # editors and ides
      vscode
      code-cursor
      jetbrains.pycharm
    ];
  };
}
