<!-- markdownlint-disable MD013 -->
# macOSLab Demo Pivot Plan

## Metadata

- **Status:** Draft
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-06
- **Scope:** Handoff plan for pivoting the MMSMOA 2026 `macOSLab` demo and supporting repository from a Defender-unhealthy failure scenario to a Gatekeeper/System Policy Control scenario that blocks a legitimate non-App-Store app, captures evidence, and rolls back to a known-good VM snapshot.
- **Related:** [Accepted CFP submission](macOS-imaging-01a-CFP-submission.md), [Bolstered outline](macOS-imaging-03a-bolstered-outline.md), [Recommended software setup runbook](macos-imaging-05c-recommended-software-step-by-step-revised.md), [Implementation prompt](../prompts/codex-goal-full-implementation.md), [Repository specification](../spec/macOSLab-repository-spec.md), [Architecture decision records](macOS-imaging-08e-ADRs.md), [Example slide description artifact](EXAMPLE-slides-from-another-talk.md), [Demo runbook](../Demo-Runbook.md), [Repository Copilot Instructions](../../.github/copilot-instructions.md), [Documentation Writing Style](../../.github/instructions/docs.instructions.md)

## Executive Decision

Pivot Demo 4 from "Defender becomes unhealthy because supporting profiles are missing or wrong" to "a new Gatekeeper hardening policy requires App-Store-only app execution and blocks Microsoft Visual Studio Code." Keep FileVault and Defender as required learning-objective content, supporting proof paths, and backup discussion because the accepted CFP cannot change. The live failure and rollback payoff should be Gatekeeper/System Policy Control because the timeline is coherent: known-good snapshot, apply new policy, app breaks, evidence proves why, rollback restores app launch.

The central demo sentence becomes:

> A Windows-first admin responds to an application allowlisting audit finding, pushes an over-tight Gatekeeper policy, blocks a legitimate Microsoft app, catches it in the lab, captures evidence, and rolls back before production users discover it.

## Non-Negotiables

- Do not pivot back to the Defender-unhealthy story. The rollback timeline problem is the reason for this plan.
- Do not edit the accepted CFP submission. Use the revised outline, slide description, and repo docs to prove the accepted takeaways are still met.
- Keep the five checkpoint names: `Clean-OS`, `Pre-Enroll`, `Post-Enroll-Baseline`, `Broken-Policy-State`, and `Recovered-Known-Good`.
- Keep the talk framed as an Intune risk-reduction session, not a general Gatekeeper talk.
- Keep FileVault and Defender visible enough to satisfy the accepted session contract. Gatekeeper is the live break-and-rollback scenario, not the only high-risk policy discussed.
- Do not depend on live Intune timing, venue Wi-Fi, or a fresh cloud sync for the stage payoff.
- Do not commit screenshots, recordings, app bundles, restore images, tenant exports, recovery keys, UPNs, tenant IDs, device IDs, serial numbers, codesigning Team IDs, or profile identifiers copied from a real tenant.
- Do not commit a sample `.mobileconfig`. It is not central to the repository purpose or the talk narrative; Intune Settings Catalog is the canonical policy authoring surface for this demo.
- Keep fixture evidence sanitized and text-friendly.
- Leave protected instruction files untouched unless the maintainer explicitly authorizes a protected-file update in the same task.
- Treat Intune Settings Catalog delivery as the preferred and most compelling profile delivery path. Treat direct/local profile installation only as a fallback for payload-mechanics testing, and validate any local install method on the actual demo guest before relying on it.

## Repo Evaluation Summary

I evaluated the tracked repository surface before writing this plan. The working tree was clean before the plan file was added. The source inventory contained 109 tracked files from `git ls-files`; the file-by-file disposition appears in [Tracked File Evaluation](#tracked-file-evaluation). `git ls-files --others --exclude-standard` returned no untracked source files. Ignored local dependency/cache directories such as `node_modules/` and `.ruff_cache/` are not source-of-truth and should not drive the pivot.

The current repo state is close enough to pivot quickly:

- The existing validation framework already supports fixture-backed evidence and arbitrary test kinds in the evidence schema.
- The current Demo 4 script points at `examples/TestCases/Compliance-SmokeTest.yml`, while the talk outline and spec still describe a FileVault/Defender-centered Demo 4.
- Defender fixtures and docs are already present and should be retained as learning-objective coverage and backup material.
- Evidence redaction exists, but it should be extended for codesigning Team IDs and profile-related identifiers before Gatekeeper fixtures are shown publicly.
- The schema is flexible enough for Gatekeeper test kinds; prefer adding a valid Gatekeeper schema example over expanding the schema unless implementation reveals a real need.
- The planning docs, implementation prompt, repo spec, demo runbook, and slide skeleton all need to stop pointing the stage failure at Defender or compliance.

## Research Update: Intune-First Delivery Decision

After checking current Microsoft and Apple documentation, the canonical demo setup should use Intune as the real delivery mechanism and fixture-backed evidence as the stage reliability mechanism.

Use this decision:

- **Preferred rehearsal path:** deliver the System Policy Control policy from Intune Settings Catalog to a lab-only device group.
- **Preferred stage path:** show the Intune policy and replay captured/checkpointed evidence rather than waiting for live policy arrival.
- **Fallback path:** use manual/local profile installation only to prove payload mechanics or to recover if Intune delivery cannot be rehearsed in time.

Rationale:

- Microsoft documents Gatekeeper/System Policy Control as a macOS Settings Catalog area in Intune, including `Enable Assessment` and `Allow Identified Developer` settings.
- Microsoft also documents Gatekeeper as a built-in macOS endpoint security area that can be configured, checked for compliance, and deployed through Intune.
- Apple documents the System Policy Control payload with `EnableAssessment` and `AllowIdentifiedDevelopers`, and the Apple YAML metadata says the payload is device-channel macOS, user-channel unavailable, and allows manual install.
- Apple user-facing macOS documentation describes manual profile installation through System Settings > General > Device Management. Modern macOS behavior should not be assumed to support unattended CLI configuration-profile installation.
- Apple Gatekeeper documentation supports the story: by default, macOS allows App Store or identified-developer/notarized software, but users and organizations can choose App-Store-only behavior, and device management can restrict overrides.

Stage wording:

> This profile was delivered by Intune during rehearsal. I am using the checkpointed state and sanitized evidence so we can show the failure and rollback without waiting on cloud timing.

## Critical Verification Risk

The original handoff brief proposed installing the System Policy Control profile directly on the VM with:

```bash
sudo profiles install -path <file>
```

Do not treat that command as a guaranteed modern macOS path. It may be unsupported on the target OS build, may require interactive System Settings approval, or may install in the wrong profile domain. The implementation agent should not build the stage narrative around direct CLI installation unless the exact command is proven on the actual demo VM.

Recommended verification sequence on the actual VM:

```bash
profiles help
man profiles
sudo profiles install -type configuration -path "<local-only-path>/Gatekeeper-AppStoreOnly.mobileconfig"
profiles show -type configuration
spctl --status
spctl --assess -vv "/Applications/Visual Studio Code.app"
open -a "Visual Studio Code"
```

If direct local profile installation does not work reliably, that is not a blocker. Keep the demo story and use the preferred Intune path:

- Deliver the profile through Intune to a lab-only group during rehearsal.
- Use a prebuilt `Broken-Policy-State` checkpoint captured after successful Intune profile delivery.
- Use fixture-backed sanitized evidence instead of live profile installation.
- Show the Intune Settings Catalog policy on a slide or in a preloaded portal tab.
- Do not wait for live Intune check-in on stage.

The plan should not claim direct profile installation as a guaranteed method until the owner has a successful rehearsal transcript from the actual target VM.

## Target End State

### Demo Narrative

The new Demo 4 should tell this story:

1. The lab VM starts at `Post-Enroll-Baseline`.
2. Visual Studio Code is installed at `/Applications/Visual Studio Code.app`.
3. VS Code has launched successfully under the baseline Gatekeeper policy.
4. Firefox is not part of the required stage or repo path. It can remain a private emergency fallback if VS Code proves unreliable during rehearsal.
5. A new System Policy Control profile is applied with `EnableAssessment = true` and `AllowIdentifiedDevelopers = false`.
6. Gatekeeper now permits only Mac App Store sourced apps.
7. VS Code is signed and notarized by Microsoft, but it is not a Mac App Store app, so it is blocked.
8. `spctl --assess -vv "/Applications/Visual Studio Code.app"` rejects the app.
9. The macOS "[App] cannot be opened" dialog is captured.
10. The evidence bundle includes `spctl`, profile, screenshot/recording reference, test report, and rollback warning.
11. The VM is restored to `Post-Enroll-Baseline`.
12. `spctl --assess` accepts VS Code again and VS Code launches.
13. `Recovered-Known-Good` can be captured after verification if replay readiness is useful.

### Checkpoint Mapping

| Checkpoint | Required state after pivot |
| --- | --- |
| `Clean-OS` | Clean guest OS before enrollment and app-specific demo state. Keep as the slowest but cleanest reset point. |
| `Pre-Enroll` | Guest ready for enrollment, before lab identity and policy assignment. Keep for identity-fidelity rehearsals. |
| `Post-Enroll-Baseline` | Enrolled lab VM, no App-Store-only System Policy Control payload, VS Code installed and launched successfully, baseline `spctl` assessment accepted, evidence script ready. This is the main rollback target. |
| `Broken-Policy-State` | System Policy Control profile present, `EnableAssessment = true`, `AllowIdentifiedDevelopers = false`, VS Code blocked, `spctl` rejection captured, macOS block dialog captured, sanitized evidence exported. |
| `Recovered-Known-Good` | Optional verification checkpoint after rollback proves the profile is gone or inactive, VS Code is accepted, and VS Code opens again. |

### Policy Payload

Use the Apple System Policy Control payload, surfaced in Intune Settings Catalog under System Policy Control/Gatekeeper. The conceptual settings are:

- `EnableAssessment = true`
- `AllowIdentifiedDevelopers = false`

For stage explanation:

> In production this is an Intune Settings Catalog profile. For stage reliability, the lab evidence is fixture-backed and the payload state is captured from rehearsal rather than waiting on live Intune timing.

### Primary and Fallback Apps

| Role | App | Why |
| --- | --- | --- |
| Primary | Microsoft Visual Studio Code | Free, well-known, Microsoft-authored, signed/notarized, not Mac App Store sourced. The irony lands with a Microsoft endpoint audience. |

Use the app name in public artifacts. Redact codesigning Team IDs and any profile identifiers copied from a real environment. Keep Firefox only as a private emergency fallback if rehearsal proves VS Code is unreliable; do not make Firefox a required fixture, stage beat, or acceptance criterion.

## Pre-Demo Setup Plan

### Host and Repo Setup

1. Keep the existing host, provider, media, and VM readiness checks from the current runbook.
2. Do not re-download macOS media for this pivot unless the actual demo VM must be rebuilt.
3. Freeze the host macOS version, Parallels version, UTM version, and demo VM build before fixture capture.
4. Keep the local repo, deck assets, screenshots, and recording available offline.
5. Run the existing readiness test after the Gatekeeper assets are in place.

### Guest Application Setup

On the demo guest:

1. Install Visual Studio Code from the official VS Code download.
2. Move or confirm the app bundle at `/Applications/Visual Studio Code.app`.
3. Launch VS Code once under baseline Gatekeeper and quit it.
4. Optional private fallback: install Firefox only if rehearsal shows VS Code is unreliable. Do not make Firefox part of the required repo or stage path.
5. Run and save baseline assessments:

   ```bash
   spctl --status
   spctl --assess -vv "/Applications/Visual Studio Code.app"
   ```

6. Capture `Post-Enroll-Baseline` only after VS Code launches successfully.

### Intune Gatekeeper Policy Setup

Use this as the primary rehearsal setup:

1. Create a lab-only Entra group, for example `MACLAB-Gatekeeper-Break`.
2. Confirm the group contains only the demo VM/device record.
3. Create a macOS Settings Catalog profile in Intune:
   - Platform: macOS.
   - Profile type: Settings catalog.
   - Category: System Policy Control.
   - `Enable Assessment`: `True`.
   - `Allow Identified Developer`: `False`.
4. If the desired demo behavior includes preventing Finder override, also configure System Policy Managed:
   - `Disable Override`: `True`.
5. Assign the profile only to the lab break group.
6. From Intune, run device `Sync`.
7. From the VM, run Company Portal `Check Status`.
8. On the VM, verify receipt and behavior:

   ```bash
   profiles show -type configuration
   spctl --status
   spctl --assess -vv --type execute "/Applications/Visual Studio Code.app"
   open -a "Visual Studio Code"
   ```

9. Capture the Intune policy status, local profile receipt, `spctl` output, and app block dialog. Do not hardcode the exact dialog wording in repo docs or slides; screenshots or recordings can show the real wording during the talk.
10. Capture `Broken-Policy-State` after the Intune-delivered policy is active and the failure is proven.
11. Before the live talk, prepare a stage-safe rollback path:
    - Start the VM at `Broken-Policy-State` with networking available only long enough to show the broken state if needed.
    - Disconnect VM networking before restoring `Post-Enroll-Baseline`.
    - Restore `Post-Enroll-Baseline` while networking is disconnected.
    - Prove `spctl` accepts VS Code and VS Code opens locally.
    - Reconnect networking only after the rollback proof or after the bad Intune assignment has been removed and the removal has synced.

Do not take `Post-Enroll-Baseline` with networking disconnected. The baseline snapshot should represent a normal enrolled, network-capable lab VM. The stage-safe move is to disconnect networking immediately before restoring that snapshot so Intune cannot reapply the bad policy during the rollback proof.

### Local Profile Fallback Setup

Use this only if Intune delivery cannot be rehearsed in time, or if the team needs to prove payload mechanics without cloud timing. Keep any local `.mobileconfig` outside the repo.

1. Create a synthetic local System Policy Control `.mobileconfig` for rehearsal and direct-install testing.
2. Use payload identifiers that are clearly synthetic, for example `org.example.macOSLab.gatekeeper.appstoreonly`.
3. Do not copy a production payload UUID, tenant identifier, device group name, or real organization-specific identifier into the repo.
4. Verify the exact installation command on the target guest.
5. After the profile is active, run:

   ```bash
   spctl --status
   spctl --assess -vv "/Applications/Visual Studio Code.app"
   profiles show -type configuration
   open -a "Visual Studio Code"
   ```

6. Capture the dialog screenshot or recording on the exact macOS guest version, but do not assert exact dialog wording in repo docs or slides.
7. Capture `Broken-Policy-State`.

If local profile installation requires System Settings interaction, record that as the fallback mechanism. Do not pretend it is unattended automation.

### Fixture Capture

Capture sanitized text fixtures from the actual VM and store them in `examples/TestCases/fixtures/`. Proposed fixture names:

| Fixture | Purpose |
| --- | --- |
| `gatekeeper-status-baseline.txt` | Baseline `spctl --status` output before hardening. |
| `gatekeeper-status-appstore-only.txt` | Hardened `spctl --status` output after the profile applies. |
| `gatekeeper-vscode-accepted.txt` | Baseline `spctl --assess -vv` output for VS Code. |
| `gatekeeper-vscode-rejected.txt` | Hardened `spctl --assess -vv` output for VS Code. |
| `profiles-system-policy-control-redacted.txt` | Sanitized `profiles show -type configuration` excerpt for the System Policy Control payload. |
| `app-launch-vscode-blocked-dialog.txt` | Text description or transcript of the captured VS Code block dialog. |
| `app-launch-vscode-recovered.txt` | Post-rollback proof that VS Code launched again. |

Do not commit the actual screenshot or recording. Reference external/local stage assets in the evidence bundle with sanitized names only.

Plain-language explanation: a fixture is just a saved, sanitized copy of command output from rehearsal. The repo uses fixtures so the validation tests and evidence examples can run without needing a live VM, live Intune tenant, or conference network. The implementation agent should not invent these files from scratch when real output is available. Capture the real output during rehearsal, remove sensitive or environment-specific values, then commit the sanitized text.

Example workflow:

1. Run a command on the VM during rehearsal, such as:

   ```bash
   spctl --assess -vv "/Applications/Visual Studio Code.app"
   ```

2. Save the output to a text file.
3. Replace any Team ID, local user path, device name, tenant detail, or profile identifier with a placeholder.
4. Commit the sanitized text file under `examples/TestCases/fixtures/`.
5. Reference that fixture from `Gatekeeper-AppStoreOnly.yml` or `Gatekeeper-Recovered.yml`.

The committed fixture text does not need to preserve exact macOS dialog wording. Use dialog screenshots or recordings as local stage assets, and keep only a generic text reference in the repo such as "VS Code block dialog captured during rehearsal."

### Redaction Requirements

Before any fixture is committed or shown:

- Replace real codesigning Team IDs with `<redacted-team-id>`.
- Replace payload UUIDs with `<redacted-payload-uuid>` unless they were synthetic from the start.
- Replace profile identifiers copied from a real tenant with synthetic identifiers.
- Replace local user home paths with `<redacted-home>`.
- Replace device names if they reveal a real person or environment.
- Confirm no tenant ID, UPN, device ID, recovery key, token, serial number, or secret appears.

Add tests for the redaction behavior rather than trusting a manual scan.

### Rollback Verification

Run this rehearsal end-to-end on the actual VM:

1. Start from `Post-Enroll-Baseline`.
2. Confirm VS Code launches.
3. Apply the System Policy Control profile or restore to the prebuilt `Broken-Policy-State`.
4. Confirm VS Code is blocked.
5. Capture evidence.
6. Restore `Post-Enroll-Baseline`.
7. Re-run `spctl --assess -vv "/Applications/Visual Studio Code.app"`.
8. Launch VS Code.
9. Capture or refresh `Recovered-Known-Good`.

If VS Code stays blocked after snapshot restore, stop and diagnose before the talk. That would mean the profile state or related cache is not being captured by the checkpoint in the way the demo requires.

## Revised Demo Flow

### Stage Setup

Show the Intune Settings Catalog equivalent on a slide, not as a live portal dependency:

- Devices
- Configuration
- Create
- New policy
- Platform: macOS
- Profile type: Settings catalog
- Category: System Policy Control/Gatekeeper
- Enable Assessment: enabled
- Allow Identified Developers: disabled

Use a stage line like:

> In production, this is an Intune Settings Catalog profile. For stage reliability, the evidence you are about to see was captured from the VM during rehearsal so we are not waiting on live Intune timing.

### Live or Fixture-Backed Commands

The stage command sequence should look like this:

```powershell
Invoke-MacPolicyValidation `
  -Name 'mms-parallels-01' `
  -TestPlan './examples/TestCases/Gatekeeper-AppStoreOnly.yml' `
  -OutputPath './_evidence/runs/mms-demo4-gatekeeper-before' `
  -RedactSecrets

Restore-MacLabVmCheckpoint `
  -Provider Parallels `
  -Name 'mms-parallels-01' `
  -CheckpointName 'Post-Enroll-Baseline'

Invoke-MacPolicyValidation `
  -Name 'mms-parallels-01' `
  -TestPlan './examples/TestCases/Gatekeeper-Recovered.yml' `
  -OutputPath './_evidence/runs/mms-demo4-gatekeeper-after' `
  -RedactSecrets
```

Prefer two test plans:

- `Gatekeeper-AppStoreOnly.yml` for the broken state after the Intune policy applies.
- `Gatekeeper-Recovered.yml` for the post-rollback known-good state.

This keeps each validation run honest: one plan proves the failure and one plan proves recovery. If time is tight, one combined plan is acceptable, but the output is less clean because it mixes broken and recovered state in one artifact.

The `.yml` files are not Intune policies. They are small validation recipes consumed by `Invoke-MacPolicyValidation`. Each file says, in repo-readable form, "for this demo state, these checks should pass or fail, these fixtures prove it, and these evidence references should be exported." Existing examples include `Defender-Validation.yml`, `FileVault-Validation.yml`, and `Compliance-SmokeTest.yml`.

For this pivot:

- `Gatekeeper-AppStoreOnly.yml` represents the broken state. It should expect the System Policy Control profile to be present and VS Code to be rejected or blocked. The VS Code block is an expected failure, because the lab is intentionally proving the bad policy would break a legitimate app.
- `Gatekeeper-Recovered.yml` represents the post-rollback state. It should expect the bad profile to be absent or inactive, `spctl` to accept VS Code, and VS Code to launch again.

The repo is not proposing that every Intune change must have a `.yml` test plan. The intended pattern is narrower: write test plans for high-risk policies, repeated validation loops, demo scenarios, and changes where evidence needs to be reproducible for a change board or team handoff. The shipped `.yml` files are examples and reusable starting points, not a universal governance requirement.

Use a `.yml` test plan when:

- The policy can break user access, security posture, app launch, encryption, EDR health, privacy permissions, or compliance.
- The validation will be repeated across snapshots, macOS versions, providers, or rehearsals.
- The evidence needs to be exported consistently.
- The result should be understandable by someone who did not run the test.

Do not create a `.yml` test plan for every routine Intune setting change. For low-risk one-off changes, normal documentation, screenshots, or portal/device checks may be enough.

### Optional Live Intune Deployment Variant

It is reasonable, and more compelling, to initiate the Intune deployment live. Do this only as a parallel stage thread, not as the success dependency for the talk.

Recommended live variant:

1. Before the demo block, show the lab-only Intune Settings Catalog policy.
2. Assign it to a lab-only static group or add the demo device to the already-assigned lab-only break group.
3. Run Intune device `Sync`.
4. Run Company Portal `Check Status` on the VM.
5. Move on to other content while the policy cooks.
6. Return to Demo 4 after 10-15 minutes.
7. If the policy landed, use the live broken state.
8. If the policy did not land, say the practiced pivot line and use `Broken-Policy-State` plus sanitized evidence.

Practiced pivot line:

> This is exactly why the lab uses checkpoints. Intune timing is part of the system, not a personal failing, so I am going to use the checkpointed broken state captured from this VM during rehearsal and show the evidence.

Before the rollback money shot, prevent the policy from immediately reapplying:

- Preferred stage-safe option: disconnect the VM network before restoring `Post-Enroll-Baseline`, then prove `spctl` accepts and VS Code opens locally.
- Also safe if timing allows: remove the device from the lab break group, sync, and confirm the policy has been removed before the rollback proof.
- Always say the caveat that the Intune assignment still exists until cleaned up.

Do not capture `Post-Enroll-Baseline` with networking disconnected. Capture the baseline in the normal enrolled/network-capable state. Disconnect networking only as a stage control immediately before rollback.

Do not improvise group or assignment changes against production-scoped objects. Use only the dedicated lab group and lab device.

### Demo 4 Evidence Output

The audience-visible summary should be short:

```text
PASS  MDM enrollment profile present
PASS  Gatekeeper assessment enabled
PASS  System Policy Control profile detected
FAIL  VS Code blocked by App-Store-only policy (expected failure)
PASS  Blocking dialog captured
PASS  Evidence redaction applied
PASS  Rollback restored Post-Enroll-Baseline
PASS  VS Code accepted after rollback
WARN  Intune cloud assignment would still need cleanup before production expansion
```

The key live payoff is:

1. VS Code is blocked in the broken state.
2. The VM rolls back.
3. `spctl --assess` accepts VS Code.
4. VS Code opens again.

### Honest Caveat

Say this out loud and put it on a slide:

> Snapshot rollback restores the VM. It does not restore Intune, Entra, the Defender portal, audit history, or assignments. In production the bad Gatekeeper profile is still assigned in Intune and would re-apply on the next check-in. The lab's job is to catch this before the assignment expands beyond the lab device.

## Repository Implementation Plan

### Phase 1: Add Gatekeeper Test Assets

Create:

- `examples/TestCases/Gatekeeper-AppStoreOnly.yml`
- `examples/TestCases/Gatekeeper-Recovered.yml`
- `examples/TestCases/fixtures/gatekeeper-status-baseline.txt`
- `examples/TestCases/fixtures/gatekeeper-status-appstore-only.txt`
- `examples/TestCases/fixtures/gatekeeper-vscode-accepted.txt`
- `examples/TestCases/fixtures/gatekeeper-vscode-rejected.txt`
- `examples/TestCases/fixtures/profiles-system-policy-control-redacted.txt`
- `examples/TestCases/fixtures/app-launch-vscode-blocked-dialog.txt`
- `examples/TestCases/fixtures/app-launch-vscode-recovered.txt`

Do not create or commit `examples/MMSMOA-2026/Gatekeeper-AppStoreOnly.mobileconfig`. The repository narrative should point admins to Intune Settings Catalog, not raw profile authoring. If a local `.mobileconfig` is needed for emergency payload testing, keep it outside the repo and out of the stage narrative.

Do not add binary app packages or visual artifacts.

### Phase 2: Update Validation Code

Update `src/Modules/MacLab/Public/Invoke-MacPolicyValidation.ps1` so it can represent Gatekeeper evidence cleanly.

Minimum viable implementation:

- Preserve existing Defender fixture behavior.
- For any test with a `fixture` value, add that fixture path to `evidenceRefs`.
- Allow declarative `result`, `expectedFailure`, and `message` values from the YAML plan.
- Emit test kinds such as `GatekeeperStatus`, `GatekeeperAssessment`, `SystemPolicyControlProfile`, `AppLaunchBlocked`, and `AppLaunchRecovered`.

Preferred implementation:

- Parse `spctl --status` fixtures enough to identify assessment enabled/disabled.
- Parse `spctl --assess -vv` fixtures enough to identify accept/reject.
- Preserve the raw sanitized fixture path in `evidenceRefs`.
- Emit a useful message such as "VS Code rejected by App-Store-only System Policy Control policy."

Do not introduce live remote command execution into the module for this pivot. Fixture-backed validation is acceptable for the stage plan.

### Phase 3: Strengthen Evidence Redaction

Update `src/Modules/MacLab/Private/Protect-MacLabEvidence.ps1` and `tests/Evidence.Tests.ps1` to cover Gatekeeper-specific leakage risks:

- Codesigning Team IDs in output such as `Developer ID Application: Vendor Name (TEAMID1234)`.
- Profile UUIDs.
- Payload identifiers from real tenants.
- Local user home paths.

Prefer context-aware redaction for Team IDs so unrelated parenthesized text is not destroyed. If context-aware parsing is too slow before the talk, require committed fixtures to contain `<redacted-team-id>` and add tests that fail when a Team ID-shaped value appears in fixture content.

### Phase 4: Update Demo Scripts and Config

Update:

- `examples/MMSMOA-2026/Demo4-GatekeeperRollback.ps1`
- `examples/MMSMOA-2026/demo-config.yml`
- `scripts/Invoke-MMSDemo.ps1` if it needs an explicit Demo 4 test plan override

Rename `examples/MMSMOA-2026/Demo4-IntuneValidation.ps1` to `examples/MMSMOA-2026/Demo4-GatekeeperRollback.ps1`. This is now an owner decision. Update references in docs, tests, demo config, and `scripts/Invoke-MMSDemo.ps1` in the same implementation pass so stale names do not survive.

The config should include:

- Primary app name: `Visual Studio Code`
- Primary app path: `/Applications/Visual Studio Code.app`
- Gatekeeper policy name or Intune profile display name, sanitized if copied from the demo tenant
- Fixture root
- Expected broken checkpoint
- Expected rollback checkpoint
- External screenshot/recording asset names, not committed paths containing personal data

### Phase 5: Update Tests

Update or add:

- `tests/Validation.Tests.ps1` for Gatekeeper test plan parsing and expected-failure behavior.
- `tests/Demo.Tests.ps1` so Demo 4 defaults to Gatekeeper evidence instead of compliance/Defender failure.
- `tests/Evidence.Tests.ps1` for Team ID/profile redaction.
- `tests/MacLab.Tests.ps1` only if exported command help examples change.
- `schemas/examples/evidence-bundle/valid/gatekeeper-appstore-only.json` as a schema-valid evidence example.

Keep existing Defender, FileVault, PPPC, and Compliance tests unless they are genuinely wrong. They are still useful proof that the accepted session contract is broader than the Gatekeeper demo.

### Phase 6: Update Documentation and Planning Artifacts

Update the docs listed in [Tracked File Evaluation](#tracked-file-evaluation). The highest-priority docs are:

- `docs/planning/macOS-imaging-03a-bolstered-outline.md`
- `docs/planning/macos-imaging-05c-recommended-software-step-by-step-revised.md`
- `docs/prompts/codex-goal-full-implementation.md`
- `docs/spec/macOSLab-repository-spec.md`
- `docs/planning/macOS-imaging-08e-ADRs.md`
- `docs/Demo-Runbook.md`
- `docs/Start-Here.md`
- `docs/Intune-Validation.md`
- `docs/Evidence-and-CAB.md`
- `docs/Evidence-Redaction.md`
- `docs/Fidelity-Boundaries.md`
- `docs/Windows-Admin-Cheat-Sheet.md`
- `docs/Troubleshooting.md`
- `README.md`

### Phase 7: Validate

Run at minimum:

```powershell
npm run lint:md
npm run lint:md:nested
python -m pre_commit run --all-files
Invoke-ScriptAnalyzer -Path . -Settings .\.github\linting\PSScriptAnalyzerSettings.psd1
Invoke-Pester -Path tests/ -Output Detailed
```

If time is short before the talk, do not skip the targeted Pester tests for validation and evidence redaction:

```powershell
Invoke-Pester -Path tests/Validation.Tests.ps1,tests/Evidence.Tests.ps1,tests/Demo.Tests.ps1 -Output Detailed
```

## Spec and Supporting Documentation Changes

### `docs/spec/macOSLab-repository-spec.md`

Update the spec so it describes the actual repository promise after the pivot:

- Add Gatekeeper/System Policy Control as a first-class validation scenario.
- Keep FileVault and Defender as required high-risk validation content.
- Modify any requirement that implies the default demo failure must be Defender.
- Update Phase 8 validation-loop requirements to include `Gatekeeper-AppStoreOnly.yml`.
- Update Phase 9/demo requirements so Demo 4 is the Gatekeeper rollback demo.
- Keep `Reset-IntuneMacLabDevice.ps1` report-only.
- Update evidence examples to include Gatekeeper assessment, System Policy Control profile receipt, app launch block, and rollback recovery.
- Add or update glossary language for Gatekeeper, System Policy Control, `spctl`, signed/notarized, Mac App Store sourced, and identified developers.

### `docs/planning/macOS-imaging-03a-bolstered-outline.md`

This is the main talk outline and should be updated carefully:

- Replace the Demo 4 Defender-health failure with the Gatekeeper/App-Store-only story.
- Keep FileVault and Defender in the risk map, evidence model, fidelity boundaries, Q&A, and backup proof sections.
- Add app execution control/Gatekeeper to the risk framing without letting the talk become a Gatekeeper-only session.
- Update the demo timeline from 57:00-70:00 to show System Policy Control, VS Code block, fixture-backed evidence, rollback, and app relaunch.
- Update "Minimum evidence to show" with the Gatekeeper summary.
- Update controlled failure options so the recommended failure is the pre-created `Broken-Policy-State` Gatekeeper state.
- Update final self-check placeholders and redaction checks to include codesigning Team IDs and dialog screenshots.

### `docs/planning/macos-imaging-05c-recommended-software-step-by-step-revised.md`

Update the pre-demo setup runbook:

- Add guest installation of VS Code.
- Add baseline launch and `spctl` capture steps.
- Add Intune System Policy Control policy setup, assignment, sync, and evidence capture steps.
- Remove any requirement to create or commit a sample `.mobileconfig`.
- Add fixture capture steps.
- Add rollback test steps.
- Demote live Graph/Defender dependencies from the core Demo 4 path to supporting or backup validation.
- Keep Defender setup where needed for CFP coverage and optional backup material.
- Add a "do this now, not on stage" warning for diagnosing any post-rollback Gatekeeper caching problem.

### `docs/prompts/codex-goal-full-implementation.md`

Update the future implementation prompt:

- State that the active Demo 4 pivot is Gatekeeper/System Policy Control blocking VS Code.
- State that Defender remains a required validation doc/test area but is no longer the live failure path.
- Ask future agents to add Gatekeeper fixtures, validation tests, docs, and slide-description artifact.
- Preserve all protected-file rules.
- Include the exact "do not pivot back to Defender" instruction.

### `docs/planning/macOS-imaging-08e-ADRs.md`

Add a new ADR:

- Title: `Use Gatekeeper/System Policy Control as the live Demo 4 failure`.
- Status: Accepted.
- Context: Defender failure had rollback-narrative incoherence; Gatekeeper policy addition is a more realistic admin mistake.
- Decision: Use fixture-backed System Policy Control evidence and VS Code app block as the stage failure.
- Consequences: FileVault/Defender stay as required content; direct profile install must be verified; screenshots/recordings remain out of repo; Team IDs are redacted.

Do not rewrite older ADRs unless they directly contradict the new decision. Add a supersession note where needed, especially near Defender-stage-demo language.

### `docs/planning/macOS-imaging-01a-CFP-submission.md`

Do not edit this file. It is the accepted contract. Use it as the slide and docs validation source.

### General Docs

Update docs so a reader can understand why the live failure is Gatekeeper while FileVault and Defender still matter:

- `docs/Start-Here.md`: make the Monday path mention one risky policy and call out Gatekeeper as the demo sample.
- `docs/Demo-Runbook.md`: rewrite Demo 4 procedure and fallback lines.
- `docs/Intune-Validation.md`: add System Policy Control/Gatekeeper validation model and explain the direct-install/fixture stage path.
- `docs/Evidence-and-CAB.md`: add a Gatekeeper evidence bundle example.
- `docs/Evidence-Redaction.md`: add Team ID and profile redaction.
- `docs/Fidelity-Boundaries.md`: place Gatekeeper policy receipt/app block in Green for VM iteration, with fleet inventory and rollout analysis as Yellow.
- `docs/Windows-Admin-Cheat-Sheet.md`: add AppLocker/WDAC/SmartScreen to Gatekeeper/System Policy Control mapping.
- `docs/Troubleshooting.md`: add Gatekeeper blocked-app symptoms and first checks.
- `docs/Prereqs.md`: add VS Code and fixture requirements.
- `docs/Provider-Version-Matrix.md`: no major structural change, but add "Gatekeeper fixture captured on this guest build" if the matrix includes policy-set version notes.
- `docs/Defender.md` and `docs/FileVault.md`: keep as high-risk validation guides; remove any implication that Defender is the only stage failure.
- `docs/PPPC-TCC.md`: cross-link app execution policy only if it helps avoid confusing PPPC with Gatekeeper.
- `README.md`: update the quick description and demo notes to mention Gatekeeper live pivot while preserving FileVault/Defender scope.

## Slide Description Artifact Plan

Create a new planning artifact modeled on `docs/planning/EXAMPLE-slides-from-another-talk.md`.

Recommended path:

```text
docs/planning/macOS-imaging-09a-generated-slides.md
```

### Inputs to Synthesize

Use these as source material:

- `docs/planning/macOS-imaging-01a-CFP-submission.md`
- `docs/planning/macOS-imaging-03a-bolstered-outline.md`
- `docs/planning/macos-imaging-05c-recommended-software-step-by-step-revised.md`
- `docs/prompts/codex-goal-full-implementation.md`
- `docs/spec/macOSLab-repository-spec.md`
- `docs/Demo-Runbook.md`
- `docs/Start-Here.md`
- `docs/Apple-Silicon-Constraints.md`
- `docs/Hypervisor-Decision-Guide.md`
- `docs/Snapshot-Strategy.md`
- `docs/Fidelity-Boundaries.md`
- `docs/Intune-Validation.md`
- `docs/Evidence-and-CAB.md`
- `docs/Evidence-Redaction.md`
- `docs/FileVault.md`
- `docs/Defender.md`
- `docs/PPPC-TCC.md`
- `docs/Windows-Admin-Cheat-Sheet.md`
- `docs/Troubleshooting.md`

### Slide Artifact Requirements

The slide-description artifact should include:

- Deck-wide rules.
- Non-negotiable correctness and safety notes.
- Accepted CFP takeaways mapped to slides.
- Revised demo narrative and timing.
- Slide-by-slide description with title, visual, speaker notes, and timing.
- Backup slides.
- Demo run-of-show.
- Demo 4 fixture and rollback script.
- Q&A buckets.
- Final rehearsal checklist.
- Repo artifact checklist.

### Required Learning-Objective Coverage

The slide description must preserve the CFP contract:

| Accepted takeaway | Slide coverage after pivot |
| --- | --- |
| Analyze Apple-silicon virtualization constraints and choose Parallels vs. UTM. | Constraints, licensing, AVF, hypervisor matrix, Demos 2 and 3. |
| Construct an automated reproducible macOS test lab using PowerShell 7.4+. | Provider model, media pinning, Demo 1, Demo 2, Demo 3, repo handoff. |
| Execute end-to-end validation of high-risk policies, including FileVault and Defender. | FileVault and Defender evidence-model slides, supporting docs, backup demo material, and Q&A. Gatekeeper becomes the live coherent break/rollback example. |
| Implement the GitHub starter kit immediately. | Repo tree, Start Here, Windows-admin cheat sheet, Monday plan, evidence bundle. |

### Proposed Revised Slide Skeleton

| Slide | Purpose | Time |
| --- | --- | --- |
| 1 | Title and speaker credibility. | 0:00 |
| 2 | CEO Mac risk scenario. | 1:00 |
| 3 | Risk map: FileVault, PPPC/TCC, Defender, Compliance/CA, and app execution control. | 3:00 |
| 4 | Windows-admin translation table, including AppLocker/WDAC/SmartScreen to Gatekeeper. | 6:00 |
| 5 | Apple Silicon lab constraints. | 7:30 |
| 6 | Licensing and concurrency caution. | 9:00 |
| 7 | Restore images, compatibility, and build pinning. | 10:30 |
| 8 | Apple Virtualization framework vs. QEMU, practical explanation. | 12:00 |
| 9 | VM fidelity traffic light. | 13:30 |
| 10 | Hypervisor decision matrix. | 15:00 |
| 11 | Parallels path. | 18:00 |
| 12 | UTM path. | 20:30 |
| 13 | Tart as advanced path. | 23:00 |
| 14 | PowerShell provider model. | 24:30 |
| 15 | Snapshot taxonomy. | 27:00 |
| 16 | Demo rules and fixture-backed evidence philosophy. | 30:00 |
| 17 | Demo 1 title card: pin and acquire media. | 31:00 |
| 18 | Demo 2 title card: Parallels VM and snapshot. | 38:00 |
| 19 | Demo 3 title card: UTM provider swap. | 50:00 |
| 20 | Demo 4 setup: audit finding leads to Gatekeeper hardening. | 57:00 |
| 21 | System Policy Control model: App Store only vs. identified developers. | 58:30 |
| 22 | Demo 4 evidence: VS Code blocked, `spctl` rejects, rollback restores. | During Demo 4 |
| 23 | FileVault and Defender proof boundaries: still required, not the live failure. | 68:00 |
| 24 | Dragons checklist updated for Gatekeeper and cloud state. | 70:00 |
| 25 | Repo tree and `Start-Here.md`. | 73:00 |
| 26 | Q&A buckets. | 75:00 |
| 27 | Monday plan and final reminder. | 102:00 |

The artifact should include speaker lines for the delicate transition:

> The accepted session promise includes FileVault and Defender, and we will show what evidence looks like for both. The live break-and-rollback path is Gatekeeper because it is the cleanest way to show the pattern without pretending cloud timing is instant.

## Tracked File Evaluation

This section records the pivot disposition for every file tracked before this plan was added.

### Governance, Configuration, and Tooling

| File | Pivot action |
| --- | --- |
| `.devcontainer/devcontainer-lock.json` | No change expected; devcontainer lock only. |
| `.devcontainer/devcontainer.json` | No change expected unless future validation needs extra tooling, which is unlikely for this pivot. |
| `.devcontainer/post-create.sh` | No change expected. |
| `.gitattributes` | No change expected. |
| `.github/CODEOWNERS` | No change expected. |
| `.github/ISSUE_TEMPLATE/bug_report.yml` | No change expected. |
| `.github/ISSUE_TEMPLATE/config.yml` | No change expected. |
| `.github/ISSUE_TEMPLATE/documentation_issue.yml` | No change expected. |
| `.github/ISSUE_TEMPLATE/feature_request.yml` | No change expected. |
| `.github/TEMPLATE_DESIGN_DECISIONS.md` | No change expected; use ADR file instead of changing template. |
| `.github/copilot-instructions.md` | Protected instruction file; evaluated and do not edit. |
| `.github/dependabot.yml` | No change expected. |
| `.github/instructions/docs.instructions.md` | Protected instruction file; evaluated and do not edit. |
| `.github/instructions/gitattributes.instructions.md` | Protected instruction file; evaluated and do not edit. |
| `.github/instructions/json.instructions.md` | Protected instruction file; evaluated and do not edit. |
| `.github/instructions/powershell.instructions.md` | Protected instruction file; evaluated and do not edit. |
| `.github/instructions/yaml.instructions.md` | Protected instruction file; evaluated and do not edit. |
| `.github/linting/PSScriptAnalyzerSettings.psd1` | No change expected. |
| `.github/pull_request_template.md` | No change expected. |
| `.github/scripts/lint-nested-markdown.js` | No change expected. |
| `.github/workflows/auto-fix-precommit.yml` | No change expected. |
| `.github/workflows/data-ci.yml` | No change expected unless schema examples require no workflow change, which they should not. |
| `.github/workflows/markdownlint.yml` | No change expected. |
| `.github/workflows/pester.yml` | No change expected. |
| `.github/workflows/powershell-ci.yml` | No change expected. |
| `.github/workflows/precommit-ci.yml` | No change expected. |
| `.gitignore` | No change expected unless local demo asset directories are not already ignored. If adding a local fixture-output path, prefer `_evidence/` or another already ignored location. |
| `.markdownlint.jsonc` | No change expected. |
| `.pre-commit-config.yaml` | No change expected. |
| `.vscode/settings.json` | No change expected. |
| `.yamllint.yml` | No change expected. |
| `package-lock.json` | No change expected. |
| `package.json` | No change expected. Existing markdown lint scripts are enough. |
| `templates/markdown/.markdownlint-cli2.jsonc` | No change expected. |
| `templates/powershell/Example.Tests.ps1` | No change expected. |

### Root Documents and TODOs

| File | Pivot action |
| --- | --- |
| `AGENTS.md` | Protected root instruction file; evaluated and do not edit. |
| `CLAUDE.md` | Protected root instruction file; evaluated and do not edit. |
| `CODE_OF_CONDUCT.md` | No change expected. |
| `CONTRIBUTING.md` | No change expected. |
| `GEMINI.md` | Protected root instruction file; evaluated and do not edit. |
| `LICENSE` | No change expected. |
| `README.md` | Update summary, demo flow, and validation references to mention Gatekeeper as the live Demo 4 failure while retaining FileVault/Defender scope. |
| `SECURITY.md` | No change expected unless owner explicitly approves a narrow secret-handling clarification. |
| `TODO-Phase-00-Branch-Protection.md` | No change expected. |
| `TODO-Phase-04-Media-Acquisition.md` | No change expected. |
| `TODO-Phase-05-Parallels-Provider.md` | No change expected beyond optional note that checkpoints must be refreshed after the Gatekeeper fixture is captured. |
| `TODO-Phase-06-UTM-Provider.md` | No change expected. |
| `TODO-Phase-07-Evidence-Pipeline.md` | Update if Gatekeeper fixture attachment/redaction work remains deferred. |
| `TODO-Phase-08-Validation-Loop.md` | Update from Defender-broken-state work to Gatekeeper/System Policy Control fixture and rollback work. Mark Defender-broken live failure as superseded if present. |
| `TODO-Phase-10-Deferred-Work.md` | Add future live Intune System Policy Control delivery and optional visual artifact publication as deferred work if not implemented now. |

### Core Documentation

| File | Pivot action |
| --- | --- |
| `docs/Apple-Silicon-Constraints.md` | No major change expected; optionally cross-link fidelity boundary for Gatekeeper. |
| `docs/CI-and-Tart.md` | No change expected. |
| `docs/ConfigMgr-Inventory-Bridge.md` | No change expected. |
| `docs/Defender.md` | Keep and lightly update to clarify Defender remains a required validation model and backup proof, not the live break/rollback scenario. |
| `docs/Demo-Runbook.md` | Update Demo 4 procedure, evidence, fallback lines, and pre-stage checks for Gatekeeper. |
| `docs/Evidence-Redaction.md` | Update for codesigning Team IDs, profile UUIDs, local user paths, and Gatekeeper screenshots/recordings. |
| `docs/Evidence-and-CAB.md` | Add Gatekeeper evidence bundle example and change-ticket wording. |
| `docs/Fidelity-Boundaries.md` | Add Gatekeeper/System Policy Control: VM green for policy receipt, `spctl`, and app launch block; fleet inventory and rollout impact remain broader validation. |
| `docs/FileVault.md` | Keep and lightly update only if it currently implies FileVault is the Demo 4 live path. |
| `docs/Hypervisor-Decision-Guide.md` | No major change expected. |
| `docs/Intune-Validation.md` | Add System Policy Control/Gatekeeper validation model and explain fixture-backed stage reliability. |
| `docs/Log-Analytics-Integration.md` | No change expected unless adding Gatekeeper evidence fields to examples. |
| `docs/PPPC-TCC.md` | No major change expected; optionally distinguish PPPC/TCC from Gatekeeper/System Policy Control. |
| `docs/PR_REVIEW_PROMPTS.md` | No change expected. |
| `docs/Prereqs.md` | Update guest app prerequisites, profile fixture prerequisites, and exact-command verification. |
| `docs/Provider-Version-Matrix.md` | Add Gatekeeper fixture capture/policy-set version note if useful. |
| `docs/Snapshot-Strategy.md` | Add Gatekeeper checkpoint mapping and reinforce that rollback restores VM state, not Intune assignment. |
| `docs/Start-Here.md` | Update the first demo path to point at Gatekeeper as the sample risky policy. |
| `docs/Troubleshooting.md` | Add Gatekeeper app block symptoms and first checks. |
| `docs/Windows-Admin-Cheat-Sheet.md` | Add AppLocker/WDAC/SmartScreen to Gatekeeper/System Policy Control mapping. |
| `docs/phase-0-bootstrap-codex-instructions.md` | No change expected. |
| `docs/phase-0-bootstrap-pr-description.md` | No change expected. |

### Planning, Prompts, and Spec

| File | Pivot action |
| --- | --- |
| `docs/planning/EXAMPLE-slides-from-another-talk.md` | Do not edit; use as the model for the new slide-description artifact. |
| `docs/planning/macOS-imaging-01a-CFP-submission.md` | Do not edit; accepted contract. Use it as learning-objective validation input. |
| `docs/planning/macOS-imaging-03a-bolstered-outline.md` | Update heavily for the Gatekeeper Demo 4 pivot, revised timeline, revised evidence, and slide skeleton. |
| `docs/planning/macOS-imaging-08e-ADRs.md` | Add ADR accepting the Gatekeeper/System Policy Control live Demo 4 failure and noting Defender stage failure is superseded. |
| `docs/planning/macos-imaging-05c-recommended-software-step-by-step-revised.md` | Update setup runbook for VS Code, Intune System Policy Control policy delivery, fixtures, rollback verification, and reduced live cloud dependency. |
| `docs/prompts/codex-goal-full-implementation.md` | Update future-agent instructions so implementation follows this pivot and does not rebuild the Defender failure story. |
| `docs/spec/macOSLab-repository-spec.md` | Update requirements, phases, evidence examples, and demo definition for Gatekeeper while preserving FileVault/Defender accepted scope. |

### Examples and Test Cases

| File | Pivot action |
| --- | --- |
| `examples/MMSMOA-2026/Demo1-Media.ps1` | No change expected. |
| `examples/MMSMOA-2026/Demo2-Parallels.ps1` | No change expected. |
| `examples/MMSMOA-2026/Demo3-UTM.ps1` | No change expected. |
| `examples/MMSMOA-2026/Demo4-IntuneValidation.ps1` | Rename to `examples/MMSMOA-2026/Demo4-GatekeeperRollback.ps1`, then update default test plan and narration for Gatekeeper/System Policy Control evidence. |
| `examples/MMSMOA-2026/demo-config.yml` | Add Gatekeeper demo settings, app paths, fixture root, checkpoint names, and sanitized Intune policy/profile display names. |
| `examples/TestCases/Compliance-SmokeTest.yml` | Keep as supporting deterministic validation; stop using it as the central Demo 4 failure unless needed as backup. |
| `examples/TestCases/Defender-Validation.yml` | Keep for accepted-takeaway coverage and backup proof. |
| `examples/TestCases/FileVault-Validation.yml` | Keep for accepted-takeaway coverage. |
| `examples/TestCases/PPPC-Validation.yml` | Keep; optionally cross-link from docs as a separate privacy validation pattern. |
| `examples/TestCases/fixtures/mdatp-health-healthy.txt` | Keep. |
| `examples/TestCases/fixtures/mdatp-health-unhealthy.txt` | Keep as backup/legacy fixture unless future docs remove all unhealthy Defender references. |
| `examples/utm/macos-lab-template.utm.json` | No change expected. |

### Schemas and Schema Examples

| File | Pivot action |
| --- | --- |
| `schemas/README.md` | Update only if adding a Gatekeeper schema example changes documented examples. |
| `schemas/evidence-bundle.schema.json` | No change expected; current generic test kinds should support Gatekeeper. Modify only if implementation needs structured Gatekeeper fields. |
| `schemas/examples/evidence-bundle/invalid/missing-redaction.json` | No change expected. |
| `schemas/examples/evidence-bundle/invalid/unredacted-device-id.json` | No change expected unless adding a Team ID invalid example. |
| `schemas/examples/evidence-bundle/valid/defender-host-guest-scope.json` | Keep. |
| `schemas/examples/evidence-bundle/valid/full.json` | Optionally add a Gatekeeper test entry, but avoid destabilizing broad examples if adding a separate Gatekeeper example is cleaner. |
| `schemas/examples/evidence-bundle/valid/minimal.json` | No change expected. |
| `schemas/examples/evidence-bundle/valid/provider-no-vms.json` | No change expected. |

### Scripts

| File | Pivot action |
| --- | --- |
| `scripts/Checkpoint-MacVm.ps1` | No change expected. |
| `scripts/Get-MacOSRestoreImage.ps1` | No change expected. |
| `scripts/Install-Prereqs.ps1` | No change expected unless adding optional host tooling checks for fixture generation. |
| `scripts/Invoke-MMSDemo.ps1` | Update only if Demo 4 needs explicit Gatekeeper test plan/config parameters. |
| `scripts/New-MacInstallArtifact.ps1` | No change expected. |
| `scripts/New-MacVm.ps1` | No change expected. |
| `scripts/Remove-MacVm.ps1` | No change expected. |
| `scripts/Reset-IntuneMacLabDevice.ps1` | No change expected; keep report-only and use cloud-state caveat in docs. |
| `scripts/Restore-MacVmCheckpoint.ps1` | No change expected. |
| `scripts/Send-LabEventToLogAnalytics.ps1` | No change expected unless adding sample Gatekeeper evidence ingestion fields. |
| `scripts/Test-LabReadiness.ps1` | Optional enhancement: add a non-default check for required demo fixture files and the VS Code app path. Do not block generic readiness on VS Code unless the user opts into demo-specific checks. |

### PowerShell Module

| File | Pivot action |
| --- | --- |
| `src/Modules/MacLab/MacLab.psd1` | No change expected unless adding exported functions, which this pivot should not require. |
| `src/Modules/MacLab/MacLab.psm1` | No change expected. |
| `src/Modules/MacLab/Private/Invoke-LoggedCommand.ps1` | No change expected. |
| `src/Modules/MacLab/Private/Protect-MacLabEvidence.ps1` | Update for Gatekeeper redaction risks. |
| `src/Modules/MacLab/Private/Resolve-MacLabConfig.ps1` | No change expected unless demo config schema-like parsing needs app/profile fields. Prefer avoiding changes. |
| `src/Modules/MacLab/Private/Write-EvidenceRecord.ps1` | No change expected for MVP. Update only if copying fixture attachments into evidence bundles becomes required. |
| `src/Modules/MacLab/Providers/Parallels.ps1` | No change expected. |
| `src/Modules/MacLab/Providers/Tart.ps1` | No change expected. |
| `src/Modules/MacLab/Providers/UTM.ps1` | No change expected. |
| `src/Modules/MacLab/Public/Checkpoint-MacLabVm.ps1` | No change expected. |
| `src/Modules/MacLab/Public/Export-MacLabEvidence.ps1` | No change expected unless adding attachment copy/export behavior. |
| `src/Modules/MacLab/Public/Get-MacLabMedia.ps1` | No change expected. |
| `src/Modules/MacLab/Public/Get-MacLabVm.ps1` | No change expected. |
| `src/Modules/MacLab/Public/Invoke-MacPolicyValidation.ps1` | Update for Gatekeeper fixture handling and generic fixture evidence references. |
| `src/Modules/MacLab/Public/New-MacLabVm.ps1` | No change expected. |
| `src/Modules/MacLab/Public/Remove-MacLabVm.ps1` | No change expected. |
| `src/Modules/MacLab/Public/Restore-MacLabVmCheckpoint.ps1` | No change expected. |
| `src/Modules/MacLab/Public/Start-MacLabVm.ps1` | No change expected. |
| `src/Modules/MacLab/Public/Stop-MacLabVm.ps1` | No change expected. |

### Tests

| File | Pivot action |
| --- | --- |
| `tests/Demo.Tests.ps1` | Update expected Demo 4 default output to Gatekeeper. |
| `tests/Evidence.Tests.ps1` | Add Team ID/profile redaction tests. |
| `tests/MacLab.Tests.ps1` | Update only if command examples/help references change. |
| `tests/Media.Tests.ps1` | No change expected. |
| `tests/Phase10.Tests.ps1` | No change expected unless deferred-work TODO wording changes. |
| `tests/Providers.Parallels.Tests.ps1` | No change expected. |
| `tests/Providers.UTM.Tests.ps1` | No change expected. |
| `tests/Readiness.Tests.ps1` | Update only if adding demo-specific fixture/app readiness checks. |
| `tests/Validation.Tests.ps1` | Add Gatekeeper test plan and fixture behavior tests. |

## Acceptance Criteria

The pivot is complete when all of these are true:

- Demo 4 defaults to Gatekeeper/System Policy Control blocking VS Code.
- Intune Settings Catalog is documented as the preferred rehearsal delivery path for the Gatekeeper profile.
- Direct/local profile installation is documented only as fallback/proof, not as the primary story.
- No sample `.mobileconfig` is created or committed.
- The repo still documents FileVault and Defender validation strongly enough to meet the accepted CFP.
- `Post-Enroll-Baseline` contains VS Code installed and successfully launched.
- `Broken-Policy-State` blocks VS Code through the Gatekeeper policy.
- Rollback to `Post-Enroll-Baseline` restores VS Code launch.
- The stage rollback path disconnects VM networking before restoring `Post-Enroll-Baseline`, and `Post-Enroll-Baseline` itself remains a normal network-capable snapshot.
- Gatekeeper fixtures are sanitized and committed.
- Repo docs and slides do not assert exact macOS dialog wording.
- No screenshot, recording, app binary, restore image, tenant export, Team ID, UPN, device ID, recovery key, or secret is committed.
- Evidence redaction tests cover Team IDs or fixture scans fail on Team ID-shaped leakage.
- The demo runbook contains a fixture-backed line for stage reliability.
- The spec, outline, setup runbook, implementation prompt, ADRs, and README agree on the new Demo 4 story.
- A new slide-description artifact exists and maps each accepted takeaway to visible slides.
- Markdown lint, nested markdown lint, pre-commit, PSScriptAnalyzer, and Pester pass or any temporary failure is documented before handoff.

## Post-Implementation Sign-Off Follow-Ups

These are required after the repo changes are implemented and before conference/session sign-off:

| Follow-up | Why it matters | Pass condition |
| --- | --- | --- |
| Verify whether Gatekeeper blocks VS Code after VS Code has already launched once. | The ideal story is "previously-working legitimate app broke after new policy." If macOS only blocks newly downloaded or updated apps, the story needs a small wording adjustment. | Rehearsal proves the already-launched VS Code path blocks, or docs/slides say the policy blocks the next newly installed or updated legitimate app. |
| Verify live Intune delivery timing with forced Company Portal sync. | The live stage variant depends on assignment/sync landing while other content runs. | The profile lands in the target 10-15 minute window during rehearsal, or the presenter commits to using `Broken-Policy-State` as the hard fallback. |
| Verify stage-safe rollback with networking disconnected before restore. | Prevents Intune from reapplying the bad policy immediately after rollback. | With networking disconnected before restore, `Post-Enroll-Baseline` restores, `spctl` accepts VS Code, and VS Code opens locally. |
| Capture dialog visual asset without committing wording dependency. | The audience benefits from seeing the real dialog, but docs should not depend on exact OS wording. | Screenshot or recording exists locally for the deck/stage, and repo docs refer generically to the captured block dialog. |
| Capture and sanitize Gatekeeper fixtures from rehearsal output. | The repo needs stable evidence examples without live VM or tenant dependencies. | Fixture files are committed as sanitized text and contain no Team IDs, tenant values, device IDs, UPNs, local home paths, or secrets. |

## Open Decisions for the Owner

| Decision | Recommendation |
| --- | --- |
| Which delivery mechanism is canonical for the demo? | Resolved: Intune Settings Catalog delivery during rehearsal, with checkpointed/fixture-backed evidence on stage. |
| Is local CLI profile installation required? | No. It is useful only as a fallback or payload-mechanics probe, and only if verified on the target VM. |
| Should a live Intune deployment be initiated on stage? | Yes, if treated as a background thread with a hard checkpoint fallback. Start the assignment/sync, let it cook, then use live state only if it lands in time. |
| Should `Demo4-IntuneValidation.ps1` be renamed? | Resolved: yes. Rename it to `Demo4-GatekeeperRollback.ps1` and update all references in the same implementation pass. |
| Should a sample `.mobileconfig` be committed? | Resolved: no. It is not central to the repository purpose or talk narrative. Use Intune Settings Catalog as the canonical policy authoring surface. |
| Should the live path install or wait for the profile during the session? | Do not make live arrival the critical path. Initiate the Intune deployment as a background stage thread, then use checkpointed state and sanitized evidence for the payoff if timing does not cooperate. |
| Should Firefox be shown live? | Resolved: no. Do not make Firefox part of the required stage path, repo fixtures, or acceptance criteria. Keep it only as a private emergency fallback if VS Code proves unreliable in rehearsal. |
| Should Defender unhealthy fixtures be removed? | Resolved: no before the talk. Keep them as backup and accepted-takeaway support, but clearly mark them as supporting fixtures rather than the live Demo 4 path. |
| Should Gatekeeper use one test plan or split broken/recovered plans? | Resolved: split plans. Use one plan for the broken App-Store-only state and one for recovered known-good state. |
| What is the slide-description artifact path? | Resolved: `docs/planning/macOS-imaging-09a-generated-slides.md`. |

### Demo 4 Rename Decision

Rename `examples/MMSMOA-2026/Demo4-IntuneValidation.ps1` to `examples/MMSMOA-2026/Demo4-GatekeeperRollback.ps1`. The new name is specific, stage-readable, and matches the pivoted Demo 4 purpose: Gatekeeper breaks a legitimate app, and rollback restores the known-good state.

## Source Recheck List

Re-check these close to the event and cite them in final public docs or slide notes as needed:

- [Microsoft Learn: Apple settings in the Intune Settings Catalog](https://learn.microsoft.com/intune/device-configuration/settings-catalog/ref-apple-settings)
- [Microsoft Learn: End-to-end guide to get started with macOS endpoints](https://learn.microsoft.com/intune/solutions/end-to-end-guides/macos-endpoints-get-started)
- [Apple Platform Security: Gatekeeper and runtime protection](https://support.apple.com/guide/security/sec5599b66df/web)
- [Apple Device Management payload: System Policy Control](https://github.com/apple/device-management/blob/release/mdm/profiles/com.apple.systempolicy.control.yaml)
- [Apple Developer Documentation: SystemPolicyControl](https://developer.apple.com/documentation/devicemanagement/systempolicycontrol)
