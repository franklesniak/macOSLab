## Description

<!-- Describe what changed and why. -->

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update
- [ ] Dependencies update
- [ ] Configuration/tooling change

## Checklist

### General

- [ ] I have read the [contributing guidelines](https://github.com/franklesniak/macOSLab/blob/HEAD/CONTRIBUTING.md)
- [ ] My changes follow `.github/copilot-instructions.md` and the applicable `.github/instructions/*` files
- [ ] I did not modify protected instruction files without explicit owner authorization
- [ ] I reviewed the change for secrets, tenant identifiers, recovery keys, tokens, and personal data
- [ ] I added or updated tests where appropriate
- [ ] I updated documentation where behavior changed

### Pre-commit Verification

- [ ] I ran `pre-commit run --all-files` locally and all checks pass
- [ ] I reviewed and committed all auto-fixes made by pre-commit hooks

### PowerShell-Specific

- [ ] Pester `5.7.1` passes locally with `Invoke-Pester -Path tests/ -Output Detailed`
- [ ] PSScriptAnalyzer is clean with `.github/linting/PSScriptAnalyzerSettings.psd1`
- [ ] `Test-LabReadiness.ps1` runs without parameter errors when applicable

## Manual Actions Deferred to Owner

<!-- List GitHub-side or local-machine actions that this PR intentionally does not perform. -->

## Open Questions / Requested Authorization

<!-- List protected instruction-file changes or unresolved decisions that need owner approval. -->

## Related Issues

Closes #
