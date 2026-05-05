<!-- markdownlint-disable MD013 -->
# macOSLab

## Metadata

- **Status:** Phase 0 bootstrap
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-05
- **Scope:** Minimal bootstrap README for `franklesniak/macOSLab`. Full user-facing setup and operating documentation is planned for Phase 1.
- **Related:** [Phase 0 bootstrap instructions](docs/phase-0-bootstrap-codex-instructions.md), [macOSLab repository specification](docs/planning/macOS-imaging-08c-repo-spec-final.md), [macOSLab ADRs](docs/planning/macOS-imaging-08e-ADRs.md)

`macOSLab` is a PowerShell 7.4+ starter kit for building reproducible Apple-silicon macOS VM labs for Intune policy testing. The repository is initialized from [`franklesniak/copilot-repo-template`](https://github.com/franklesniak/copilot-repo-template) and is being tailored for the `MacLab` PowerShell module.

The project goal is to help Microsoft endpoint administrators test risky macOS policies before they reach production users. The supported local virtualization paths are Parallels Desktop Pro and UTM. Tart remains an advanced stub path until later owner approval.

## Current Bootstrap State

Phase 0 establishes repository identity, trims irrelevant template sample content, keeps governance and validation tooling intact, and records deferred verification work. The full module implementation, user docs, and evidence schema are not part of Phase 0.

The repository languages are PowerShell and Markdown. Python may still appear as a tool runtime for pre-commit hooks such as `check-jsonschema`, but Python sample/source code is not part of this project.

## Validation

Use these commands before opening or updating a pull request:

```bash
npm run lint:md
npm run lint:md:nested
pre-commit run --all-files
```

PowerShell validation is handled through PSScriptAnalyzer and Pester 5.7.1:

```powershell
Invoke-ScriptAnalyzer -Path . -Settings .github/linting/PSScriptAnalyzerSettings.psd1
Invoke-Pester -Path tests/ -Output Detailed
```

## Deferred Work

Root TODO files track deferred verification and owner actions:

- [TODO-Phase-00-Branch-Protection.md](TODO-Phase-00-Branch-Protection.md)
- [TODO-Phase-04-Media-Acquisition.md](TODO-Phase-04-Media-Acquisition.md)
- [TODO-Phase-05-Parallels-Provider.md](TODO-Phase-05-Parallels-Provider.md)
- [TODO-Phase-06-UTM-Provider.md](TODO-Phase-06-UTM-Provider.md)
- [TODO-Phase-07-Evidence-Pipeline.md](TODO-Phase-07-Evidence-Pipeline.md)
- [TODO-Phase-08-Validation-Loop.md](TODO-Phase-08-Validation-Loop.md)
- [TODO-Phase-10-Deferred-Work.md](TODO-Phase-10-Deferred-Work.md)

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
