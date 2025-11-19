#!/usr/bin/env bash
set -e

echo "Uninstalling Specstory wrapper…"

# Remove wrapper binary
if [[ -f "$HOME/bin/specstory" ]]; then
  echo "➡ Removing ~/bin/specstory"
  rm "$HOME/bin/specstory"
fi

# Remove wrapper folder
if [[ -d "$HOME/.specstory_wrapper" ]]; then
  echo "➡ Removing ~/.specstory_wrapper"
  rm -rf "$HOME/.specstory_wrapper"
fi

# Restore original Homebrew binary
BREW_BIN="$(brew --prefix 2>/dev/null)/bin/specstory"
BREW_REAL="$(brew --prefix 2>/dev/null)/bin/specstory-real"

if [[ -f "$BREW_REAL" && ! -f "$BREW_BIN" ]]; then
  echo "➡ Restoring specstory-real → specstory"
  mv "$BREW_REAL" "$BREW_BIN"
fi

echo "Uninstall complete!"
