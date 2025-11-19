#!/usr/bin/env bash
set -e

echo "Installing Specstory wrapper..."

# --- 1. Locate real specstory binary ---
REAL_BIN="$(command -v specstory || true)"
if [[ -z "$REAL_BIN" ]]; then
  echo "Specstory not found in PATH. Install it first (brew install specstoryai/tap/specstory)."
  exit 1
fi

REAL_DIR="$(dirname "$REAL_BIN")"
REAL_WRAPPED="$REAL_DIR/specstory-real"

# --- 2. Rename real binary (if not already renamed) ---
if [[ ! -f "$REAL_WRAPPED" ]]; then
  echo "➡ Renaming $REAL_BIN → $REAL_WRAPPED"
  mv "$REAL_BIN" "$REAL_WRAPPED"
else
  echo "✔ Real binary already renamed."
fi

# --- 3. Install wrapper to ~/bin/specstory ---
mkdir -p "$HOME/bin"
WRAPPER_BIN="$HOME/bin/specstory"

echo "➡ Installing wrapper launcher → $WRAPPER_BIN"
cat > "$WRAPPER_BIN" <<'EOF'
#!/usr/bin/env bash
python3 "$HOME/.specstory_wrapper/specstory_wrapper.py" "$@"
EOF

chmod +x "$WRAPPER_BIN"

# --- 4. Install Python wrapper script ---
if [[ ! -f "specstory_wrapper.py" ]]; then
  echo "specstory_wrapper.py not found in the current directory."
  echo "Please place it next to this installer."
  exit 1
fi

echo "➡ Copying specstory_wrapper.py → ~/.specstory_wrapper/"
mkdir -p "$HOME/.specstory_wrapper"
cp specstory_wrapper.py "$HOME/.specstory_wrapper/specstory_wrapper.py"

# --- 5. Add ~/bin to PATH if missing  ---
PROFILE=""
if [[ -n "$ZSH_VERSION" ]]; then PROFILE="$HOME/.zshrc"; fi
if [[ -n "$BASH_VERSION" ]]; then PROFILE="$HOME/.bashrc"; fi

if ! echo "$PATH" | grep -q "$HOME/bin"; then
  echo "➡ Adding ~/bin to PATH in $PROFILE"
  echo 'export PATH="$HOME/bin:$PATH"' >> "$PROFILE"
fi

# --- 6. Conda per-environment activation hook (FIXED) ---
if command -v conda >/dev/null 2>&1; then

  echo
  echo "IMPORTANT:"
  echo "Enter the name of the conda environment where Specstory capture should be active."
  echo "(Example: base or your dev environment name)"
  read -p "Environment name: " ENV_NAME

  # Validate environment exists
  ENV_PATH="$(conda env list | grep -E "^${ENV_NAME} " | awk '{print $2}')"

  if [[ -z "$ENV_PATH" ]]; then
    echo "Conda environment '$ENV_NAME' not found."
    exit 1
  fi

  HOOK_DIR="$ENV_PATH/etc/conda/activate.d"
  mkdir -p "$HOOK_DIR"

  echo "➡ Adding activation hook ONLY for env '$ENV_NAME' → $HOOK_DIR/specstory.sh"

  cat > "$HOOK_DIR/specstory.sh" <<EOF
export PATH="\$HOME/bin:\$PATH"
alias claude="specstory run claude --no-cloud-sync"
EOF

  echo "✔ Hook installed for environment: $ENV_NAME"
  echo "➡ When you run:  conda activate $ENV_NAME"
  echo "   The alias 'claude' will route through specstory."
fi

echo
echo "Installation complete!"
echo "Your Specstory wrapper is ready."
echo "Restart your terminal or 'source ~/.zshrc' / 'source ~/.bashrc' if needed."
echo