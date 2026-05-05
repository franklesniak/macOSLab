<!-- markdownlint-disable MD013 -->
# Contributing to macOSLab

## Metadata

- **Status:** Phase 0 bootstrap
- **Owner:** Repository Maintainers
- **Last Updated:** 2026-05-05
- **Scope:** Contributor workflow for the `franklesniak/macOSLab` repository during and after Phase 0 bootstrap.
- **Related:** [Repository instructions](.github/copilot-instructions.md), [PowerShell style guide](.github/instructions/powershell.instructions.md), [Documentation style guide](.github/instructions/docs.instructions.md), [Schemas README](schemas/README.md)

Thank you for contributing to `macOSLab`. This repository is a PowerShell 7.4+ and Markdown project for reproducible Apple-silicon macOS VM labs used in Intune policy testing.

## Development Setup

Clone the repository and install the Node.js tooling used for Markdown linting:

```bash
git clone https://github.com/franklesniak/macOSLab.git
cd macOSLab
npm install
```

Install `pre-commit` globally with your preferred tool. Python may be required by some pre-commit hook environments, but Python is development tooling here, not project source code.

```bash
pre-commit install
```

## Required Checks

Run the repository checks before opening a pull request:

```bash
npm run lint:md
npm run lint:md:nested
pre-commit run --all-files
```

For PowerShell changes, also run:

```powershell
Invoke-ScriptAnalyzer -Path . -Settings .github/linting/PSScriptAnalyzerSettings.psd1
Invoke-Pester -Path tests/ -Output Detailed
```

Pre-commit auto-fixes must be committed with the related change. Do not land a standalone formatting-only or lint-only commit.

## Project Standards

- PowerShell code targets PowerShell 7.4 or newer.
- Pester tests use Pester 5.7.1 syntax and conventions.
- Markdown follows the repository documentation style guide.
- JSON and YAML files must pass the data-file hooks configured in `.pre-commit-config.yaml`.
- Do not commit secrets, tenant identifiers, recovery keys, tokens, production policy names, screenshots, recordings, local VM bundles, or raw evidence output.
- Do not modify protected instruction files unless the repository owner explicitly authorizes that exact protected-file change in the current task.

## Security Reports

Do not open public issues for security vulnerabilities. Use [GitHub private vulnerability reporting](https://github.com/franklesniak/macOSLab/security/advisories/new).

## Pull Requests

Use the pull request template and include:

- What changed and why.
- The validation commands you ran.
- Any skipped manual GitHub-side actions.
- Any requested owner authorization for protected instruction files or repository settings.
