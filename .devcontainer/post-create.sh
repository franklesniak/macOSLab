#!/usr/bin/env bash
set -euo pipefail

if [ -f package-lock.json ]; then
  npm ci
elif [ -f package.json ]; then
  npm install
fi

# `sudo` resets PATH via secure_path, which drops the Node feature's bin
# directory and causes `sudo npm` to fail with "command not found". Resolve
# npm in the calling shell and invoke it through `sudo` while preserving PATH.
NPM_BIN="$(command -v npm)"
sudo env "PATH=$PATH" "$NPM_BIN" install -g npm@latest
sudo env "PATH=$PATH" "$NPM_BIN" install -g "@openai/codex@latest"

python -m venv .venv
. .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -e ".[dev]" pre-commit
pre-commit install

mkdir -p "${HOME}/.codex"
cat > "${HOME}/.codex/config.toml" <<'EOF'
approval_policy = "never"
sandbox_mode = "danger-full-access"

[features]
goals = true
EOF
