<!-- markdownlint-disable MD013 -->
# Phase 0 Bootstrap PR Description Draft

## Metadata

- **Status:** Deprecated
- **Owner:** Repository Maintainers
- **Last Updated:** 2026-05-05
- **Scope:** Historical PR-description content for the Phase 0 bootstrap branch. This records applied steps, skipped steps, manual owner actions, validation, and protected-instruction cleanup; it is not the current pull request description.
- **Related:** [Phase 0 bootstrap instructions](phase-0-bootstrap-codex-instructions.md), [macOSLab repository specification](spec/macOSLab-repository-spec.md), [macOSLab ADRs](planning/macOS-imaging-08e-ADRs.md)

This document is deprecated and retained only as historical bootstrap context. Do not use it as the current pull request description or as task authorization for future work.

## Summary

This Phase 0 bootstrap customizes the template repository for `franklesniak/macOSLab`, a PowerShell 7.4+ and Markdown repository for reproducible Intune-managed macOS VM labs.

## Applied Changes

- Replaced repository identity placeholders with `franklesniak/macOSLab`, `@franklesniak`, `macOSLab`, and `Frank Lesniak` / `2026` where applicable.
- Updated contact guidance so conduct reports go to repository owners through GitHub profile contact links.
- Updated security reporting to GitHub private vulnerability reporting at `https://github.com/franklesniak/macOSLab/security/advisories/new`.
- Kept `SECURITY.md` changes narrow and did not add the deferred project-specific paragraph from ADR-0009.
- Customized README, CONTRIBUTING, issue templates, PR template, CODEOWNERS, package metadata, VS Code title, pre-commit, Dependabot, workflows, and `.gitignore`.
- Removed non-protected Python sample/source files and Python package metadata.
- Removed non-protected HCL sample files, HCL workflow/configuration, and HCL-specific docs.
- Removed unused Python and Terraform modular instruction files after explicit owner authorization.
- Updated protected instruction entry points to match the PowerShell/Markdown repository shape after explicit owner authorization.
- Kept Markdown linting, nested Markdown linting, data-file validation, pre-commit, PowerShell/Pester CI, PSScriptAnalyzer settings, issue templates, PR template, CODEOWNERS, and governance files.
- Kept the worked-example schema and `check-jsonschema` / `check-metaschema` hooks for Phase 0 validation.
- Added required root phase TODO files, including branch-protection and Phase 7 evidence-schema replacement tracking.

## GETTING_STARTED_NEW_REPO.md Checklist

- Repository creation: skipped because `franklesniak/macOSLab` already exists.
- Clone/local prerequisite setup: skipped because this work is already in the provided workspace.
- Dependency install: skipped as a manual local-machine prerequisite, except existing Node tooling is retained and lockfile is regenerated.
- Initial placeholder replacement: applied.
- Creating optional labels: skipped in GitHub because the owner is creating `triage`; issue templates assume it will exist and include `triage`.
- Pre-commit configuration: applied; `pre-commit install` skipped because hook installation is a local-machine action.
- Language-specific customization: applied for PowerShell/Markdown; non-protected Python and HCL template artifacts removed.
- Package metadata: applied.
- PR template customization: applied with unconditional pre-commit language and PowerShell-specific checks.
- README customization: applied as a minimal Phase 0 README.
- CONTRIBUTING customization: applied for PowerShell/Markdown and retained tooling.
- CODE_OF_CONDUCT customization: applied.
- Copilot/protected instruction updates: applied after explicit owner authorization on 2026-05-05.
- Validation/testing: run locally as noted in this PR after edits.
- Cleanup: applied for non-protected template artifacts that do not match macOSLab.

## OPTIONAL_CONFIGURATIONS.md Checklist

- Issue template configuration: applied; blank issues remain enabled, Discussions link enabled, and security link points to private vulnerability reporting.
- Support/FAQ link: skipped because no concrete support or FAQ page exists yet.
- Pull request template: applied.
- Dependabot configuration: applied; weekly cadence kept, npm, GitHub Actions, and pre-commit ecosystems kept, pip removed.
- Pre-commit configuration: applied; Black, Ruff, and HCL hooks removed, retained data-file and Markdown hooks kept.
- Schema validation configuration: applied; worked example retained and Phase 7 replacement TODO added.
- Markdown linting/workflow: kept.
- Copilot instruction configuration: applied after explicit owner authorization on 2026-05-05.
- CI workflow configuration: applied; Python and HCL CI removed, narrow aggregate pre-commit workflow added for retained tooling hooks.
- Auto-fix pre-commit workflow: kept and updated to match retained hook set.
- Placeholder check workflow: removed after repository initialization.
- PowerShell CI workflow: kept, PowerShell 7.4 floor check added, Pester pinned to `5.7.1`.
- Python template files: removed.
- Pester test template: kept.
- PSScriptAnalyzer configuration: kept.
- CODEOWNERS configuration: applied.
- Node.js package configuration: kept only for Markdown linting tooling.
- Gitignore configuration: applied for macOS, PowerShell/lab artifacts, Parallels, UTM, local evidence/cache, and sensitive file patterns.
- License customization: verified as `Copyright (c) 2026 Frank Lesniak`.
- VS Code PowerShell encoding: preserved while setting `window.title` to `macOSLab`.
- Ongoing maintenance: inherited template maintenance docs removed because they described the old template rather than this repository.

## Manual Actions Deferred to Owner

- Create/configure repository from template: already done before this branch.
- Local-machine prerequisites: Git, Node.js, Python for pre-commit tooling, `npm install`, and `pre-commit install`.
- Create the `triage` label before PR review or before issue templates are used.
- Configure branch protection or rulesets for `main`; see `TODO-Phase-00-Branch-Protection.md`.
- Set repository About description and topics.
- Verify GitHub Actions are green after the branch is pushed.

## Open Questions

- Owner decision requested: whether to add the exact ADR-0009 `SECURITY.md` paragraph in Phase 1.

## Validation

- `npm run lint:md` - passed.
- `npm run lint:md:nested` - passed.
- `pre-commit run --all-files` - passed.
- `Invoke-ScriptAnalyzer` against repository PowerShell files, excluding ignored dependency/tool caches - passed.
- `Invoke-Pester -Path tests/ -Output Detailed` with Pester `5.7.1` - passed, 2 tests.
