<!-- markdownlint-disable MD013 -->
# Demo Runbook

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-06
- **Scope:** MMSMOA demo runbook for media verification, provider paths, validation evidence, recovery pivots, and owner dry-run boundaries.
- **Related:** [Start Here](Start-Here.md), [Troubleshooting](Troubleshooting.md), [Evidence and CAB](Evidence-and-CAB.md), [Snapshot Strategy](Snapshot-Strategy.md)

## T-15 Gate

Run the readiness gate before the talk:

```powershell
./scripts/Test-LabReadiness.ps1 -PreparedArtifactPath ~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw -PreparedArtifactSha256 8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32
```

Any failed required check is a stop condition for live VM work. Use fixture-backed evidence or recordings instead.

## Media

The owner demo path uses the existing IPSW at `~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw` with SHA-256 `8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32`. `Demo1-Media.ps1` verifies and reuses that file; it must not start another download when the checksum matches.

If a future demo path changes the IPSW location, move it into place and verify:

```bash
mkdir -p "$HOME/Demo/Installers"
mv "<current-ipsw-path>" "$HOME/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw"
shasum -a 256 "$HOME/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw"
```

## Conference Pre-Stage

Enrollment is a pre-stage task for the dependable demo path. Do not make live Company Portal enrollment a required stage dependency because conference network and cloud policy timing are outside the VM rollback boundary.

Before traveling or presenting:

1. Download the Company Portal installer while the network is reliable:

   ```bash
   mkdir -p "$HOME/Demo/Installers"
   curl -L -o "$HOME/Demo/Installers/CompanyPortal-Installer.pkg" "https://go.microsoft.com/fwlink/?linkid=853070"
   ls -lh "$HOME/Demo/Installers/CompanyPortal-Installer.pkg"
   ```

2. Keep the cached `.pkg` outside the repository. Do not commit the installer.
3. Boot the disposable guest VM on reliable network.
4. Install Company Portal inside the guest from [Enroll My Mac](https://go.microsoft.com/fwlink/?linkid=853070) or from the cached installer during pre-stage.
5. Do not sign in to Company Portal yet.
6. Shut down the guest.
7. Capture the `Pre-Enroll` checkpoint.
8. Start from `Pre-Enroll` on reliable network, complete Company Portal enrollment, install and launch Visual Studio Code, wait for Intune sync and baseline policy delivery, then capture `Post-Enroll-Baseline`.
9. Use `Post-Enroll-Baseline` as the default live demo starting point.

Use live enrollment during the talk only as an optional walkthrough. If the network is slow, say: "Enrollment is cloud-timed, so the stage path starts from a prepared enrolled checkpoint and the evidence records what changed."

## Demo Flow

1. Demo 1: run `examples/MMSMOA-2026/Demo1-Media.ps1`.
2. Demo 2: run `examples/MMSMOA-2026/Demo2-Parallels.ps1` during owner live dry run only.
3. Demo 4 start: run `examples/MMSMOA-2026/Demo4-GatekeeperRollback.ps1 -Stage StartCloudSync` as the stage checklist, then start the live Intune policy sync.
4. Demo 3: use `examples/MMSMOA-2026/Demo3-UTM.ps1` after manually creating the documented UTM VM while the policy sync bakes.
5. Demo 4 resume: return once, use the live broken state only if the policy landed cleanly, and otherwise use `Broken-Policy-State`.

## Demo 4 Start: Live Intune Stage Thread

Use this as an audience-visible bonus path, not as the only success path. The stage payoff MUST still use checkpointed and fixture-backed evidence if cloud timing does not cooperate.

Run the checklist helper:

```powershell
./examples/MMSMOA-2026/Demo4-GatekeeperRollback.ps1 `
  -Stage StartCloudSync `
  -Name 'mms-parallels-01'
```

1. Start from the prepared enrolled Demo 4 VM at `Post-Enroll-Baseline`.
2. Confirm Visual Studio Code launches before the break policy lands.
3. Assign or sync the lab-only Gatekeeper policy.
4. In Company Portal, run **Check Status**.
5. Leave the VM alone while Demo 3 runs.

## Demo 3 While Intune Bakes

Run the UTM provider-swap check:

```powershell
./examples/MMSMOA-2026/Demo3-UTM.ps1
```

This segment gives the live policy path its bake window without asking the audience to watch Company Portal sync.

## Demo 4 Resume: Broken or Fallback

Return once after the 10-15 minute bake window. If the profile landed cleanly, use the live broken state. If it did not land, say the recovery-pivot line and restore or use `Broken-Policy-State`.

## Demo 4 Gatekeeper Path

Demo 4 is a Gatekeeper rollback story, not a Defender-unhealthy story. The preferred rehearsal path is an Intune Settings Catalog profile scoped to the lab-only device group:

- Platform: macOS.
- Profile type: Settings catalog.
- Category: System Policy Control/Gatekeeper.
- Enable Assessment: enabled.
- Allow Identified Developers: disabled.

Validate the broken state:

```powershell
./examples/MMSMOA-2026/Demo4-GatekeeperRollback.ps1 `
  -Stage Broken `
  -Name 'mms-parallels-01' `
  -OutputPath './_evidence/runs/mms-demo4-gatekeeper-before'
```

Before the rollback proof, disconnect VM networking so the bad Intune assignment cannot immediately reapply while the audience watches the local recovery. Do not capture `Post-Enroll-Baseline` with networking disconnected; only disconnect as a stage control immediately before restore.

Restore the known-good checkpoint:

```powershell
Restore-MacLabVmCheckpoint `
  -Provider Parallels `
  -Name 'mms-parallels-01' `
  -CheckpointName 'Post-Enroll-Baseline' `
  -AcknowledgeCloudStateWarning
```

Validate the recovered state:

```powershell
./examples/MMSMOA-2026/Demo4-GatekeeperRollback.ps1 `
  -Stage Recovered `
  -Name 'mms-parallels-01' `
  -OutputPath './_evidence/runs/mms-demo4-gatekeeper-after'
```

Audience-visible summary:

```text
PASS  MDM enrollment profile present
PASS  Gatekeeper assessment enabled
PASS  System Policy Control profile detected
FAIL  VS Code blocked by App-Store-only policy (expected failure)
PASS  Blocking dialog captured
PASS  Evidence redaction applied
PASS  Rollback restored Post-Enroll-Baseline
PASS  VS Code accepted after rollback
WARN  Intune cloud assignment would still need report-only cleanup review before production expansion
```

## Recovery Pivots

If live cloud timing is slow, switch to the fixture-backed Gatekeeper validation plan and say: "This is exactly why the lab uses checkpoints. Intune timing is part of the system, not a personal failing, so I am going to use the checkpointed broken state captured from this VM during rehearsal and show the evidence."

If the VM provider is not ready, use the prepared screenshots or recording and keep the command prompt visible only for redacted evidence commands.

If a secret appears on screen, stop sharing immediately, rotate or invalidate the affected value, and do not commit the capture.

## Final Boundary

The repository is ready for owner live dry run after Phase 9 local validation. Do not push, tag `v0.1.0-mmsmoa-preview`, enable branch protection, or run destructive provider/cloud actions until the owner approves.
