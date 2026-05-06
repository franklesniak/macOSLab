<!-- markdownlint-disable MD013 -->
# Generated Slide Descriptions

## Metadata

- **Status:** Draft
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-06
- **Scope:** Slide-description artifact for the MMSMOA 2026 macOSLab session after the Gatekeeper/System Policy Control Demo 4 pivot.
- **Related:** [CFP Submission](macOS-imaging-01a-CFP-submission.md), [Bolstered Outline](macOS-imaging-03a-bolstered-outline.md), [Setup Runbook](macos-imaging-05c-recommended-software-step-by-step-revised.md), [Implementation Prompt](../prompts/codex-goal-full-implementation.md), [Repository Specification](../spec/macOSLab-repository-spec.md), [Demo Runbook](../Demo-Runbook.md)

## Deck Rules

- Keep the talk framed as Intune risk reduction, not a general Gatekeeper talk.
- Keep FileVault and Defender visible as required learning-objective content.
- Use Gatekeeper/System Policy Control as the live break-and-rollback path because it is deterministic and rollback-coherent.
- Do not depend on venue Wi-Fi, fresh Intune sync, or live cloud timing as the only success path.
- Do not show or commit secrets, recovery keys, tenant IDs, UPNs, device IDs, serial numbers, Team IDs, profile UUIDs, screenshots, recordings, app bundles, restore images, or tenant exports.
- Say plainly: snapshot rollback restores the VM. It does not restore Intune, Entra, Defender portal state, audit history, or assignments.

## CFP Coverage Map

| Accepted takeaway | Slide coverage after pivot |
| --- | --- |
| Analyze Apple-silicon virtualization constraints and choose Parallels vs. UTM. | Slides 5-13 cover constraints, licensing, AVF, provider matrix, Demo 2, and Demo 3. |
| Construct an automated reproducible macOS test lab using PowerShell 7.4+. | Slides 14-19 cover provider model, media pinning, snapshots, and Demos 1-3. |
| Execute end-to-end validation of high-risk policies, including FileVault and Defender. | Slides 20-24 show the validation loop; FileVault and Defender remain evidence-model and backup-proof slides while Gatekeeper is the live rollback example. |
| Implement the GitHub starter kit immediately. | Slides 25-27 cover repo tree, Start Here, Windows-admin cheat sheet, Monday plan, and evidence bundle. |

## Revised Demo Narrative

Demo 4 starts from `Post-Enroll-Baseline`, where Visual Studio Code is installed and launches. The presenter shows a lab-only Intune Settings Catalog profile for System Policy Control/Gatekeeper, then uses checkpointed evidence from `Broken-Policy-State` to show VS Code rejected by App-Store-only policy. The rollback restores `Post-Enroll-Baseline`, `spctl` accepts VS Code, and the app launches again. The presenter states that the cloud assignment still needs cleanup before production expansion.

Delicate transition line:

> The accepted session promise includes FileVault and Defender, and we will show what evidence looks like for both. The live break-and-rollback path is Gatekeeper because it is the cleanest way to show the pattern without pretending cloud timing is instant.

## Slide-By-Slide Description

| Slide | Title | Visual | Speaker notes | Time |
| --- | --- | --- | --- | --- |
| 1 | Don't Brick the CEO's Mac | Title, speaker names, repo URL placeholder. | Establish that this is a Microsoft endpoint admin session about safe Mac policy testing. | 0:00 |
| 2 | The CEO Mac Risk | One executive Mac and one failed-policy timeline. | Production is a terrible place to discover Mac policy assumptions. | 1:00 |
| 3 | Risk Map | Table: FileVault, PPPC/TCC, Defender, Compliance/CA, app execution control. | Add Gatekeeper as the app-execution risk without letting it consume the session. | 3:00 |
| 4 | Windows Translation | Windows-to-macOS table including AppLocker/WDAC/SmartScreen to Gatekeeper. | Windows lab instincts still apply; the instruments change. | 6:00 |
| 5 | Apple Silicon Constraints | Host/guest compatibility diagram. | Same-major host/guest is the safest default for current Apple Virtualization-backed macOS VMs. | 7:30 |
| 6 | Licensing Caution | Two-guest boundary and legal-review note. | This is practical planning guidance, not legal advice. | 9:00 |
| 7 | Pin The Build | Restore image/IPSW cache and checksum. | Reproducibility starts with the exact build. | 10:30 |
| 8 | AVF vs. QEMU | Simple provider backend comparison. | The backend affects fidelity and automation, not just performance. | 12:00 |
| 9 | Fidelity Traffic Light | Green/Yellow/Red table. | Gatekeeper policy receipt and app launch behavior are Green; fleet rollout impact is broader validation. | 13:30 |
| 10 | Provider Matrix | Parallels, UTM, Tart comparison. | Pick the tool that makes safe behavior easiest for the team. | 15:00 |
| 11 | Parallels Path | Command plus checkpoint tree. | Parallels is the polished primary demo path. | 18:00 |
| 12 | UTM Path | Template/config artifact and manual-step gap callout. | UTM is viable, but not full Parallels parity in v1. | 20:30 |
| 13 | Tart Path | CI/advanced path card. | Mention only as future growth, not a third equal live path. | 23:00 |
| 14 | PowerShell Provider Model | Public cmdlets and provider folders. | PowerShell is the stable operator interface. | 24:30 |
| 15 | Snapshot Taxonomy | Five checkpoint names. | Use the five names exactly; rollback is the safety mechanism. | 27:00 |
| 16 | Demo Rules | Cached downloads, fixture-backed evidence, cloud timing caveat. | The point is evidence and repeatability, not progress bars. | 30:00 |
| 17 | Demo 1 | Media command and verified IPSW. | Reuse the prepared artifact when checksum matches. | 31:00 |
| 18 | Demo 2 | Parallels VM create/checkpoint sequence. | Show provider hardening and checkpoint creation or the verified evidence. | 38:00 |
| 19 | Demo 3 | UTM provider swap. | Same validation loop, different provider capability surface. | 50:00 |
| 20 | Audit Finding | App execution control audit finding. | A reasonable admin over-tightens Gatekeeper to App Store only. | 57:00 |
| 21 | System Policy Control | Settings Catalog path and two settings. | Enable Assessment enabled; Allow Identified Developers disabled. | 58:30 |
| 22 | Demo 4 Evidence | Terminal summary: VS Code blocked, `spctl` rejects, rollback restores. | Use `Gatekeeper-AppStoreOnly.yml`, restore, then `Gatekeeper-Recovered.yml`. | During Demo 4 |
| 23 | FileVault and Defender | Evidence-model cards. | They remain required content and backup proof, not the live failure. | 68:00 |
| 24 | Dragons | Troubleshooting table with Gatekeeper and cloud state. | Name the risks before Q&A names them for you. | 70:00 |
| 25 | Repo Tree | `src`, `examples`, `docs`, `schemas`, `tests`. | Point to `Start-Here.md` and split Gatekeeper test plans. | 73:00 |
| 26 | Q&A Buckets | Provider, Intune, evidence, fidelity, roadmap. | Keep answers scoped and avoid live tenant debugging. | 75:00 |
| 27 | Monday Plan | One policy, one VM, one evidence bundle, one rollback. | End with the smallest safe next step. | 102:00 |

## Demo Run-Of-Show

1. Verify prepared media with Demo 1.
2. Show Parallels path and checkpoint model with Demo 2.
3. Show UTM provider-swap path with Demo 3.
4. For Demo 4, show the Settings Catalog slide and say the stage-reliability line.
5. Run `Demo4-GatekeeperRollback.ps1` or `Invoke-MacPolicyValidation` against `Gatekeeper-AppStoreOnly.yml`.
6. Show the expected VS Code failure and fixture evidence.
7. Disconnect VM networking.
8. Restore `Post-Enroll-Baseline`.
9. Run `Gatekeeper-Recovered.yml`.
10. Show VS Code accepted and launched.
11. State the cloud assignment cleanup caveat.

## Demo 4 Fixture Script

```powershell
Invoke-MacPolicyValidation `
  -Name 'mms-parallels-01' `
  -TestPlan './examples/TestCases/Gatekeeper-AppStoreOnly.yml' `
  -OutputPath './_evidence/runs/mms-demo4-gatekeeper-before' `
  -RedactSecrets:$true

Restore-MacLabVmCheckpoint `
  -Provider Parallels `
  -Name 'mms-parallels-01' `
  -CheckpointName 'Post-Enroll-Baseline'

Invoke-MacPolicyValidation `
  -Name 'mms-parallels-01' `
  -TestPlan './examples/TestCases/Gatekeeper-Recovered.yml' `
  -OutputPath './_evidence/runs/mms-demo4-gatekeeper-after' `
  -RedactSecrets:$true
```

## Backup Slides

- FileVault escrow proof path and recovery-key redaction.
- Defender deployment profile checklist and `mdatp health` fixture shape.
- Why local `.mobileconfig` installation is a fallback, not the canonical story.
- Provider Version Matrix example.
- Report-only cloud cleanup boundaries.
- Redaction checklist for evidence, screenshots, and recordings.

## Q&A Buckets

- Provider choice: Parallels vs. UTM vs. Tart.
- Fidelity: what VM evidence can and cannot prove.
- Intune timing: APNs, sync, and assignment delays.
- FileVault and Defender: required validation content beyond the live Gatekeeper failure.
- Evidence: schema, redaction, CAB usage, and fixture-backed plans.
- Roadmap: live Intune delivery, visual artifacts, Log Analytics, ConfigMgr adjacency, and fuller Tart support.

## Final Rehearsal Checklist

- `Post-Enroll-Baseline` contains VS Code installed and launched.
- `Broken-Policy-State` blocks VS Code through Gatekeeper/System Policy Control.
- `Gatekeeper-AppStoreOnly.yml` and `Gatekeeper-Recovered.yml` produce expected evidence.
- VM networking is disconnected before the rollback proof.
- `spctl --assess -vv "/Applications/Visual Studio Code.app"` rejects before rollback and accepts after rollback.
- Fixture files are sanitized and contain no Team IDs, tenant values, device IDs, UPNs, local home paths, or secrets.
- Visual dialog capture exists locally and is not committed.
- FileVault and Defender evidence-model slides still satisfy the accepted CFP.
- Markdown lint, nested Markdown lint, pre-commit, PSScriptAnalyzer, and Pester pass before handoff.

## Repo Artifact Checklist

- `examples/MMSMOA-2026/Demo4-GatekeeperRollback.ps1`
- `examples/TestCases/Gatekeeper-AppStoreOnly.yml`
- `examples/TestCases/Gatekeeper-Recovered.yml`
- Gatekeeper fixture text files under `examples/TestCases/fixtures/`
- Gatekeeper valid schema example under `schemas/examples/evidence-bundle/valid/`
- Redaction tests for Team IDs and profile identifiers
- Updated Demo Runbook, Intune Validation, Evidence, Fidelity, Troubleshooting, README, spec, ADR, and setup runbook
