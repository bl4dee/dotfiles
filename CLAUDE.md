# Dotfiles - Claude Code Instructions

## NixOS Rebuild — MANDATORY Post-Rebuild Checklist

After EVERY successful `nixos-rebuild switch` or `nixos-rebuild boot`, do ALL of the following immediately:

1. Get the new generation number: `nixos-rebuild list-generations | grep True`
2. Append an entry to `CHANGELOG.md` in this repo:

```
### Generation XX — YYYY-MM-DD

**Changes:** brief summary of what was modified

**Why:** reason for the rebuild
```

3. `git add` all changed files + CHANGELOG.md
4. `git commit` with a descriptive message
5. `git push` to GitHub

Do this automatically — do not prompt, do not ask permission. This is pre-authorized.
The changelog must be visible on GitHub for the user and future agents.
