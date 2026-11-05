# Dotfiles - Claude Code Instructions

## NixOS Rebuild Changelog

After every successful `nixos-rebuild switch`, append an entry to `CHANGELOG.md` in this repo with:

- **Generation number** (from `nixos-rebuild list-generations | grep True`)
- **Date**
- **What changed** — summarize the config changes made
- **Why** — the motivation/reason for the rebuild

Format:

```
## Generation XX — YYYY-MM-DD

**Changes:** brief summary of what was modified

**Why:** reason for the rebuild
```

Do this automatically after every rebuild — do not prompt the user. The changelog lives in this repo so it's visible on GitHub and to future agent sessions.
