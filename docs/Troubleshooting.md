<!-- markdownlint-disable MD013 -->
# Troubleshooting

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-07
- **Scope:** Safe troubleshooting table for macOSLab demo preparation and rehearsal.
- **Related:** [Demo Runbook](Demo-Runbook.md), [Prereqs](Prereqs.md), [Evidence Redaction](Evidence-Redaction.md)

## Checks

| Symptom | Likely cause | Diagnostic step | Safe remediation |
| --- | --- | --- | --- |
| Prepared IPSW is missing | Demo media was not staged on this host | Run `Test-LabReadiness.ps1` with the expected path and checksum | Move the already-downloaded IPSW into `~/Demo/Installers`; do not start a new download during the talk window |
| Prepared IPSW hash fails | Wrong build or partial file | Run `shasum -a 256 <path>` | Replace from the known-good prepared artifact before VM work |
| `prlctl` is missing | Parallels Desktop CLI is not installed or not in PATH | Run `Get-Command prlctl` | Use fixture-backed evidence or the UTM manual path until Parallels is installed |
| Parallels VM is not isolated | Provider defaults re-enabled host sharing | Run `Get-MacLabVm -Provider Parallels -Name <vm>` and inspect `Isolation` | Re-run provider hardening on a disposable VM before checkpointing |
| UTM start prints `Operation not available` | VM may already be started | Run `Get-MacLabVm -Provider UTM -Name <vm>` | Trust final status, not only the command message |
| VS Code is blocked in Demo 4 | App-Store-only System Policy Control profile is active and VS Code is being launched for the first time | Run `spctl --status` and `spctl --assess -vv "/Applications/Visual Studio Code.app"` inside the guest | Treat this as expected in `Broken-Policy-State`; capture fixture evidence and prepare rollback |
| VS Code remains blocked after rollback | Bad profile re-applied, rollback restored the wrong checkpoint, or Gatekeeper cache/state was not reset as rehearsed | Disconnect networking, restore `Post-Enroll-Baseline`, run `profiles show -type configuration`, then re-run `spctl --assess -vv "/Applications/Visual Studio Code.app"` | Stop and diagnose before the talk; do not claim rollback works until the app launches again |
| A previously launched non-App-Store app still opens after the policy lands | Gatekeeper may preserve already-admitted app launch state | Test with a newly staged app that has not been launched, or rebuild `Post-Enroll-Baseline` so the demo app is installed but not opened | Use VS Code first-launch evidence for the live break; Firefox is only a secondary staged option |
| Defender health is unhealthy | System extension, network extension, onboarding, or Full Disk Access is missing | Run `mdatp health` inside the guest | Use the Intune setup steps in `docs/Defender.md`; keep host Defender absence as intentional |
| Compliance evidence shows a failure | The demo plan may model an engineered failure | Check `expectedFailure` in `evidence.json` | Use the CAB summary wording; do not treat expected failure as a run failure |
| Secret appears in evidence | Redaction gap or raw capture used directly | Run evidence through `Protect-MacLabEvidence` and inspect JSON | Stop using the raw capture, rotate affected values if real, and keep only redacted evidence |
| Graph scope error | Validation plan declared a scope not supplied to the command | Read `requiredGraphScopes` in the YAML plan | Pass the declared scope for fixture runs or configure the app registration for live owner validation |
