#!/usr/bin/env bash
set -euo pipefail

if [ -f package-lock.json ]; then
  npm ci
elif [ -f package.json ]; then
  npm install
fi

sudo npm install -g "@openai/codex@latest"

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
