<!-- markdownlint-disable MD013 -->
# Prerequisites

## Metadata

- **Status:** Active
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-06
- **Scope:** Host, provider, tooling, and tenant prerequisites for building and validating a `macOSLab` environment.
- **Related:** [Start Here](Start-Here.md), [Hypervisor Decision Guide](Hypervisor-Decision-Guide.md), [Apple Silicon Constraints](Apple-Silicon-Constraints.md), [Provider Version Matrix](Provider-Version-Matrix.md), [macOSLab repository specification](spec/macOSLab-repository-spec.md)

The supported host is an Apple-silicon Mac running macOS. Intel Mac hosts, Windows hosts, and Linux hosts are outside the v1 lab scope.

## Host Requirements

Required:

- Apple-branded Apple-silicon Mac.
- macOS version supported by Apple and compatible with the guest macOS version you plan to run.
- PowerShell 7.4 or newer.
- Git.
- Node.js 20 or newer for repository Markdown tooling.
- Enough disk space for macOS restore images and VM disks. The owner/demo Tahoe IPSW is about 18 GB before VM disk growth.

Recommended:

- Separate local folder for installers, such as `~/Demo/Installers`.
- Separate local folder for VM storage, outside the repository.
- Network path that allows APNs, Intune, Microsoft Graph, Defender, and Apple software update endpoints when running live validation.
- Visual Studio Code installed inside the enrolled demo guest before capturing `Post-Enroll-Baseline` when rehearsing Demo 4.
- Sanitized Gatekeeper fixture text under `examples/TestCases/fixtures/` for stage-safe validation without live cloud timing.

Do not place `.ipsw`, `.dmg`, `.iso`, `.app`, screenshots, recordings, VM bundles, private keys, or credential files inside the repository.

## Repository Tooling

Use these commands for documentation and pre-commit validation:

```bash
npm install
npm run lint:md
npm run lint:md:nested
pre-commit run --all-files
```

PowerShell validation uses Pester 5.7.1 and PSScriptAnalyzer:

```powershell
Invoke-ScriptAnalyzer -Path . -Settings .github/linting/PSScriptAnalyzerSettings.psd1
Invoke-Pester -Path tests/ -Output Detailed
```

The default test suite must not require provider tools, Microsoft Graph, Defender, Apple ID, or a real VM.

## Media Tooling

The default media source is `mist-cli`, invoked as `mist`. Phase 4 implements the module media workflow, but the implementation contract is already fixed:

- Use `Get-MacLabMedia -Source Mist`.
- Treat firmware/IPSW restore images as the default Apple-silicon VM media path.
- Treat compatible installer rows as advisory metadata unless a provider-specific workflow requires an installer artifact.
- Record version, build, artifact path, source, acquisition time, size, and checksum where practical.

For the owner/demo path, reuse `~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw` when it exists and matches SHA-256 `8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32`. Do not start a new `mist download` for that path without explicit owner approval in the current task.

## Provider Prerequisites

Parallels is the primary provider. Before Phase 5 live validation, the host should have:

- Parallels Desktop installed.
- `prlctl` available.
- `prlsrvctl` available.
- A license suitable for the intended automation path.

UTM is the secondary documented/manual provider-swap path. Before Phase 6 validation, the host should have:

- UTM installed under `/Applications/UTM.app`.
- `utmctl` available at `/Applications/UTM.app/Contents/MacOS/utmctl`.
- A manually created disposable macOS VM when testing lifecycle commands.

Tart remains a v1 stub unless later owner approval expands it. Do not treat Tart as required for the default lab path.

## Microsoft 365 And Intune Prerequisites

Use lab-only cloud objects:

- Lab tenant or lab-only scope in a tenant.
- Lab-only users.
- Lab-only device groups.
- Lab-only policy assignments.
- Explicit assignment filters or naming conventions that cannot match production Macs.
- Microsoft Graph PowerShell submodules only as needed: `Microsoft.Graph.Authentication`, `Microsoft.Graph.DeviceManagement`, and optionally `Microsoft.Graph.Beta.DeviceManagement` for FileVault escrow proof.

Do not require the full `Microsoft.Graph` meta-module by default.

The host readiness path must not require Defender for Endpoint on the host Mac. Defender validation is guest-scoped and belongs inside an enrolled disposable macOS VM.

For the Gatekeeper demo, create the System Policy Control profile through Intune Settings Catalog in a lab-only assignment. A local `.mobileconfig` payload may be used only outside the repository as a verified fallback; do not commit it.

## Tenant Safety Rules

Never use production-wide assignments in examples or demos. A valid lab path requires:

- A lab-only enrollment target.
- A lab-only policy set.
- A rollback plan for local VM checkpoints.
- A manual cleanup plan for Intune, Entra, and Defender records because VM rollback does not rewind cloud state.

The report-only cloud cleanup script is a later optional path. V1 must not delete or retire cloud records automatically without explicit owner-approved expansion.
