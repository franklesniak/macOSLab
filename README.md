<!-- markdownlint-disable MD013 -->
# macOSLab

## Metadata

- **Status:** Active
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-05
- **Scope:** User-facing overview for `franklesniak/macOSLab`, including the fastest safe starting path, project boundaries, current phase status, validation commands, deferred work, and license information.
- **Related:** [Start Here](docs/Start-Here.md), [Prerequisites](docs/Prereqs.md), [macOSLab repository specification](docs/spec/macOSLab-repository-spec.md), [macOSLab ADRs](docs/planning/macOS-imaging-08e-ADRs.md)

[![Pre-commit CI](https://github.com/franklesniak/macOSLab/actions/workflows/precommit-ci.yml/badge.svg)](https://github.com/franklesniak/macOSLab/actions/workflows/precommit-ci.yml)
[![PowerShell CI](https://github.com/franklesniak/macOSLab/actions/workflows/powershell-ci.yml/badge.svg)](https://github.com/franklesniak/macOSLab/actions/workflows/powershell-ci.yml)
[![Markdown lint](https://github.com/franklesniak/macOSLab/actions/workflows/markdownlint.yml/badge.svg)](https://github.com/franklesniak/macOSLab/actions/workflows/markdownlint.yml)
[![Data CI](https://github.com/franklesniak/macOSLab/actions/workflows/data-ci.yml/badge.svg)](https://github.com/franklesniak/macOSLab/actions/workflows/data-ci.yml)

`macOSLab` is a PowerShell 7.4+ starter kit for building reproducible Apple-silicon macOS VM labs for Microsoft Intune policy testing. It helps endpoint administrators pin macOS media, build lab VMs, create rollback checkpoints, validate FileVault/Defender/PPPC outcomes, and export redacted evidence before risky policy changes reach production users.

This repository is not a production Mac management platform, not legal advice, not a replacement for physical Mac sign-off, and not a place to store tenant data or recovery keys. VM evidence accelerates iteration; it does not prove Red-bucket outcomes such as ADE/ABM zero-touch enrollment, Platform SSO sign-in/unlock, Touch ID, Secure Enclave-dependent behavior, or executive pilot readiness.

## Fastest Safe Start

Start at [docs/Start-Here.md](docs/Start-Here.md), then read [docs/Prereqs.md](docs/Prereqs.md) before running any provider or cloud workflow. The implementation is delivered in phase gates; Phase 1 provides the foundation documentation, while module implementation begins in Phase 2.

The intended v1 command path is:

```powershell
Import-Module ./src/Modules/MacLab/MacLab.psd1
Get-MacLabMedia -Version '<macOS-version>' -Build '<macOS-build>'
New-MacLabVm -Provider Parallels -Name 'demo-01' -MediaId '<macOS-version>-<macOS-build>'
Checkpoint-MacLabVm -Provider Parallels -Name 'demo-01' -CheckpointName 'Pre-Enroll'
Invoke-MacPolicyValidation -Provider Parallels -Name 'demo-01' -TestPlan ./examples/TestCases/Compliance-SmokeTest.yml
```

Until later phases add the module and scripts, treat that snippet as the stable target interface rather than a promise that the commands are already implemented.

## What Ships First

The first working path is deliberately narrow:

- Apple-silicon macOS host.
- PowerShell 7.4 or newer.
- Parallels Desktop as the primary provider.
- UTM as a documented/manual provider-swap path with partial lifecycle automation.
- Tart as a stubbed advanced path unless later owner approval expands it.
- `mist-cli` for macOS restore image or provider-appropriate install artifact discovery.
- Redacted JSON evidence as the durable output.

The owner/demo path reuses the already-downloaded macOS Tahoe 26.4.1 IPSW at `~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw` when it exists and matches SHA-256 `8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32`. Demo scripts and runbooks must not start another download when that verified file is present.

## Documentation Map

- [docs/Start-Here.md](docs/Start-Here.md) - first read for new users.
- [docs/Prereqs.md](docs/Prereqs.md) - host, provider, tooling, and tenant prerequisites.
- [docs/Hypervisor-Decision-Guide.md](docs/Hypervisor-Decision-Guide.md) - Parallels vs. UTM vs. Tart.
- [docs/Apple-Silicon-Constraints.md](docs/Apple-Silicon-Constraints.md) - Apple Virtualization, licensing posture, and physical hardware boundaries.
- [docs/Provider-Version-Matrix.md](docs/Provider-Version-Matrix.md) - how evidence records host/provider/guest facts.
- [docs/Fidelity-Boundaries.md](docs/Fidelity-Boundaries.md) - Green/Yellow/Red validation contract.
- [docs/Snapshot-Strategy.md](docs/Snapshot-Strategy.md) - five checkpoints and cloud-state rollback warning.
- [docs/Windows-Admin-Cheat-Sheet.md](docs/Windows-Admin-Cheat-Sheet.md) - Windows-admin translation table.

## Talk Metadata

- Session title: "Don't Brick the CEO's Mac: Building and Automating macOS Labs for Risk-Free Policy Testing"
- Event context: MMSMOA 2026
- Primary speaker: Frank Lesniak
- Co-speaker: Michael Niehaus
- Primary technology: Microsoft Intune
- Session focus: automation, provisioning and deployment, setup and configuration

## Validation

Before committing changes, run:

```bash
npm run lint:md
npm run lint:md:nested
pre-commit run --all-files
```

When PowerShell code changes, also run the repository PowerShell checks:

```powershell
Invoke-ScriptAnalyzer -Path . -Settings .github/linting/PSScriptAnalyzerSettings.psd1
Invoke-Pester -Path tests/ -Output Detailed
```

Default tests must not require real Parallels, UTM, Tart, Microsoft Graph, Defender, Apple ID, or a real macOS VM.

## Deferred Work

Root TODO files track owner actions, verified implementation-time evidence, and deferred work:

- [TODO-Phase-00-Branch-Protection.md](TODO-Phase-00-Branch-Protection.md)
- [TODO-Phase-04-Media-Acquisition.md](TODO-Phase-04-Media-Acquisition.md)
- [TODO-Phase-05-Parallels-Provider.md](TODO-Phase-05-Parallels-Provider.md)
- [TODO-Phase-06-UTM-Provider.md](TODO-Phase-06-UTM-Provider.md)
- [TODO-Phase-07-Evidence-Pipeline.md](TODO-Phase-07-Evidence-Pipeline.md)
- [TODO-Phase-08-Validation-Loop.md](TODO-Phase-08-Validation-Loop.md)
- [TODO-Phase-10-Deferred-Work.md](TODO-Phase-10-Deferred-Work.md)

Phase completion summaries must state whether the matching TODO file is closed, empty, or still carrying deferred work.

## Security

Do not commit real tenant IDs, device IDs, recovery keys, UPNs, policy exports, tokens, private keys, screenshots, recordings, `.ipsw`, `.dmg`, `.iso`, `.app`, or binary `.utm` bundles. If content appears to contain a real secret, report it privately through the GitHub security advisory process described in [SECURITY.md](SECURITY.md).

## Acknowledgements

This repository is initialized from [`franklesniak/copilot-repo-template`](https://github.com/franklesniak/copilot-repo-template). The lab posture is shaped by the MMSMOA macOS policy-testing session, owner-supplied provider validation evidence, and public vendor documentation linked from the foundation docs.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
