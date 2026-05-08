<!-- markdownlint-disable MD013 -->
# macOSLab Architecture Decision Records

## Metadata

- **Status:** Draft for owner review
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-07
- **Scope:** Architecture and planning decisions for the future `macOSLab` repository specification. This file records accepted decisions and conditional follow-up decisions that affect implementation, phase gates, or repository policy.
- **Related:** [macOSLab repository specification](../spec/macOSLab-repository-spec.md), [Closed questions archive](macOS-imaging-08d-closed-questions-archive.md), [Original prompt](macOS-imaging-08-repo-spec.md), [Repository Copilot Instructions](../../.github/copilot-instructions.md), [Documentation Writing Style](../../.github/instructions/docs.instructions.md)

## ADR-0001: PowerShell Runtime Floor

- **Status:** Accepted
- **Date:** 2026-05-04

### Context

The previous draft defaulted to PowerShell 7.2. The owner has decided that the repository should support only PowerShell 7.4.x and newer.

### Decision

The `MacLab` module manifest MUST set `PowerShellVersion = '7.4'`. Documentation and CI MUST treat PowerShell 7.4 as the minimum supported runtime. Newer PowerShell 7.x releases are supported unless a concrete incompatibility is documented.

### Consequences

- Implementation can use modern PowerShell 7.4 behavior without spending time on older runtime compatibility.
- Attendees on older PowerShell 7 releases must upgrade before using the kit.
- The prerequisite script and readiness gate must check for PowerShell 7.4 or newer.

### Alternatives Considered

- Keep PowerShell 7.2 as the floor. Rejected because the owner explicitly wants 7.4.x and newer only.
- Leave runtime unspecified. Rejected because the module should fail early and clearly on unsupported PowerShell versions.

## ADR-0002: macOS Support Policy and Demo Version

- **Status:** Accepted
- **Date:** 2026-05-04

### Context

The owner will demo VMs running macOS 26.x and identified `26.4.1` as the current demo target. The repo should also be compatible with supported 14.x and 15.x macOS versions, specifically initial targets `14.8.5` and `15.7.5`.

### Decision

The repository MUST use an Apple-supported-macOS policy. Initial targets are:

- Demo path: macOS Tahoe 26.4.1.
- Compatibility target: macOS Sequoia 15.7.5.
- Compatibility target: macOS Sonoma 14.8.5.

The Provider Version Matrix MUST record exact host and guest version/build values for every run.

### Consequences

- The demo remains current while the starter kit remains useful for admins still validating supported older macOS releases.
- Tests and docs must avoid assuming that every user is on the live demo version.
- Media acquisition and provider code must handle version/build as data, not as hardcoded constants.

### Alternatives Considered

- Support only 26.x. Rejected because the owner wants practical compatibility with supported 14.x and 15.x.
- Track "latest" continuously. Rejected because reproducibility matters more than novelty.
- Support beta/preview macOS versions. Rejected for the v1 public path.

## ADR-0003: Root Per-Phase TODO Files

- **Status:** Accepted
- **Date:** 2026-05-04

### Context

Several items can safely be verified later, but the owner is concerned they will be forgotten if they live only in planning notes. The owner requested root-level, per-phase TODO files in the implementation repository.

### Decision

The future repository MUST create root-level per-phase TODO files when a phase has unresolved or deferred work. File names follow `TODO-Phase-<NN>-<Short-Name>.md`. Known required TODO files are:

- `TODO-Phase-00-Branch-Protection.md`
- `TODO-Phase-04-Media-Acquisition.md`
- `TODO-Phase-05-Parallels-Provider.md`
- `TODO-Phase-06-UTM-Provider.md`
- `TODO-Phase-07-Evidence-Pipeline.md`
- `TODO-Phase-08-Validation-Loop.md`
- `TODO-Phase-10-Deferred-Work.md`

The file is omitted when the phase has no outstanding TODOs.

### Consequences

- Deferred work is visible from the repo root.
- README and phase summaries must link to active TODO files.
- Phase 0 branch-protection and Phase 7 evidence-schema replacement work remain visible even though they were identified during bootstrap rather than in the original required TODO list.
- Phase 10 deferral is acceptable only when the deferred items are explained in `TODO-Phase-10-Deferred-Work.md`.

### Alternatives Considered

- Track TODOs only in GitHub Issues. Rejected because the owner wants root-visible context.
- Track all TODOs in one root file. Rejected because per-phase files reduce clutter and make phase gates easier to review.
- Track no TODO files. Rejected because deferred verification items are easy to miss.

## ADR-0004: Template Initialization Guide

- **Status:** Accepted
- **Date:** 2026-05-04

### Context

The future repository will be initialized from `franklesniak/copilot-repo-template`. The owner plans to work with a coding agent to create a separate instructions/template repository implementation steps guide after this specification is complete.

### Decision

The implementation agent MUST use the forthcoming template initialization steps guide during Phase 0. The agent must still inspect the template at implementation time, preserve governance files, and avoid modifying protected instruction files without explicit authorization.

### Consequences

- Phase 0 becomes safer and more repeatable.
- This spec does not need to duplicate every template initialization step.
- If the guide and this spec conflict, the new repo's canonical instruction files and this spec still govern protected-file behavior.

### Alternatives Considered

- Rely only on this spec. Rejected because the owner wants a more focused template initialization guide.
- Vendor-copy the template into the planning repo. Rejected because it would drift from the actual template.

## ADR-0005: Deferred Tool Verification TODOs

- **Status:** Accepted
- **Date:** 2026-05-04

### Context

The owner accepts later verification for `mist-cli`, `prlctl`, UTM/`utmctl`, and Defender `mdatp health`, but wants these items clearly visible in the implementation repo.

### Decision

The following verifications are deferred to the implementation phase but MUST be tracked in root TODO files until closed:

| Phase | TODO file | Verification |
| --- | --- | --- |
| Phase 4 | `TODO-Phase-04-Media-Acquisition.md` | Verify current `mist-cli` list/download syntax. |
| Phase 5 | `TODO-Phase-05-Parallels-Provider.md` | Verify current `prlctl` syntax, version output, and edition detection. |
| Phase 6 | `TODO-Phase-06-UTM-Provider.md` | Verify current UTM/`utmctl` automation surface and manual-step gaps. |
| Phase 8 | `TODO-Phase-08-Validation-Loop.md` | Verify current Defender `mdatp health` output shape and sanitize fixtures. |

### Consequences

- The spec can proceed without pretending current external tool behavior is frozen.
- The implementation repo remains explicit about what must be verified before each phase is accepted.
- Phase summaries must close or carry forward the relevant TODOs.

### Alternatives Considered

- Verify every tool in this planning repo. Rejected because implementation-time installed versions matter.
- Trust planning examples without verification. Rejected because CLI syntax and output can change.

## ADR-0006: Tart v1 Scope and License Posture

- **Status:** Accepted
- **Date:** 2026-05-04

### Context

Tart is useful for a CI/runner conversation but not required for the core talk path. The owner supplied Tart and Orchard free-tier license links.

### Decision

The v1 repository keeps Tart as a stub provider unless fuller implementation is later approved. `docs/CI-and-Tart.md` MUST link to:

- [Tart license](https://github.com/cirruslabs/tart/blob/main/LICENSE)
- [Orchard license](https://github.com/cirruslabs/orchard/blob/main/LICENSE)

The doc MUST summarize the current practical posture:

- Tart's license file uses Fair Source License 0.9 and defines a 100-user use limitation where user means CPU core used by the product.
- Orchard's license file uses Fair Source License 0.9 and defines a 4-user use limitation where user means a device running macOS.
- The owner-supplied Tart docs language describes the free tier as 100 CPU cores for Tart and 4 Orchard Workers for Orchard.
- This is not legal advice; users must verify license suitability for their own organization.

### Consequences

- Tart remains visible without becoming a v1 dependency.
- The repo provides useful context without turning the starter kit into a licensing authority.
- Full Tart provider parity is deferred until explicitly approved.

### Alternatives Considered

- Implement full Tart support in v1. Rejected because it is outside the core talk path.
- Remove Tart entirely. Rejected because it is valuable as an advanced/CI extension point.

## ADR-0007: Apple macOS Virtualization License Language

- **Status:** Accepted
- **Date:** 2026-05-04

### Context

The owner provided the [macOS Tahoe SLA](https://www.apple.com/legal/sla/docs/macOSTahoe.pdf) as the source for Apple/macOS virtualization and licensing language.

### Decision

The docs MUST link to the macOS Tahoe SLA and summarize the practical boundary without giving legal advice:

- The repo is designed for Apple-branded computers.
- The Tahoe SLA includes language allowing up to two additional macOS virtual instances on an Apple-branded computer already running macOS for specified purposes such as software development, testing during software development, macOS Server, or personal non-commercial use.
- The repo's default posture is "two concurrent macOS guests per Apple-branded host unless the owner/user verifies a different license posture."
- The docs must tell users to verify their own license/procurement posture.

### Consequences

- The docs can explain the lab boundary plainly.
- The repo avoids making unsupported licensing claims.
- The readiness and hypervisor docs should design around the two-guest assumption.

### Alternatives Considered

- Omit licensing language. Rejected because virtualization boundaries matter for a public macOS lab repo.
- Provide legal advice. Rejected because the repo is a technical starter kit, not legal counsel.

## ADR-0008: CI Runner and Pester Version

- **Status:** Accepted
- **Date:** 2026-05-04

### Context

The owner identified that the template already uses `macos-latest` in active PowerShell and Python workflow matrices. The owner also supplied current Pester version `5.7.1`.

### Decision

The v1 CI workflow uses `macos-latest` for macOS CI and pins Pester `5.7.1`. Python-specific workflow jobs may be removed if Python sample content is trimmed from the repo.

### Consequences

- CI aligns with the template's existing pattern.
- Tests remain deterministic through a pinned Pester version.
- The repo avoids retaining irrelevant Python CI when no Python code remains.

### Alternatives Considered

- Pick a version-pinned macOS runner label now. Rejected because the template uses `macos-latest` and default tests are mocked.
- Leave Pester unpinned. Rejected because deterministic CI is preferable.

## ADR-0009: `SECURITY.md` Redaction Paragraph

- **Status:** Accepted
- **Date:** 2026-05-04

### Context

The future repository inherits `SECURITY.md` from the template. That file is a governance/security file, so the implementation should avoid unnecessary drift. The repo still has a specific risk profile: examples and evidence must not contain real tenant identifiers, recovery keys, tokens, production credentials, or personal data.

### Decision

Leave `SECURITY.md` unchanged by default and do not rewrite it. The owner approved adding only this exact short project-specific paragraph on 2026-05-05 after the inherited responsible-disclosure process was visible:

> This repository ships no real tenant identifiers, no recovery keys, no tokens, and no production credentials. If you discover content that appears to be a real secret, recovery key, tenant identifier, or personal data, please report it privately through the repository's security advisory process rather than opening a public issue.

### Consequences

- Leaving the file unchanged preserves template governance and avoids accidental protected-file drift.
- Adding the paragraph improves reporter guidance for this repo's specific risk profile.
- No `SECURITY.md` rewrite is approved.

### Alternatives Considered

- Automatically add the paragraph before inspecting the inherited file. Rejected because it could conflict with the template's existing security policy.
- Rewrite `SECURITY.md`. Rejected because it creates unnecessary governance drift.

## ADR-0010: Cloud Cleanup Mutation Scope

- **Status:** Accepted
- **Date:** 2026-05-04

### Context

Local VM rollback does not rewind cloud state. A lab operator may therefore see stale Intune, Entra, or Defender records after restoring or deleting a VM. Cleanup guidance is useful, but automated cloud mutation can delete or retire the wrong object if matching, scoping, or confirmation behavior is wrong.

### Decision

Start `scripts/Reset-IntuneMacLabDevice.ps1` as report-only in v1. A report-only run should identify candidate Intune, Entra, and Defender records, explain why they may be stale, show portal paths or Graph commands for manual cleanup, and write redacted evidence. Add soft-delete/retire or hard-delete only after a later explicit owner-approved Phase 10 change and tests for scoping, confirmation, and evidence redaction.

### Consequences

- V1 helps the operator understand identity drift without risking wrong-object deletion.
- Mutation remains possible later after matching logic, Graph scopes, prompts, and evidence are reviewed.
- Phase 10 must carry any future cloud mutation work in `TODO-Phase-10-Deferred-Work.md`.

### Alternatives Considered

- Allow soft-delete/retire by default. Deferred because matching/scoping must be reviewed first.
- Allow hard-delete in v1. Rejected as too risky for the first release.

## ADR-0011: Apple Virtualization Host/Guest Compatibility Gate

- **Status:** Accepted
- **Date:** 2026-05-05

### Context

macOS guests on Apple-silicon Macs are constrained by Apple's Virtualization framework and by provider-specific support. Current Parallels CLI documentation states that the only guaranteed Apple-silicon macOS VM compatibility scenario is a guest running the same macOS major version as the host. The current Parallels macOS Arm VM limitations article also states that Parallels macOS Arm VMs are built using Apple's Virtualization framework and that running a guest with a macOS version higher than the host may not be possible.

UTM's macOS guest documentation describes macOS guests on Apple silicon as Apple Virtualization-backed, and UTM's Apple backend documentation states that Apple Virtualization is the only way UTM runs virtualized macOS on Apple silicon. Tart documentation describes Tart as using Apple's native Virtualization.Framework.

### Decision

The repository MUST treat host/guest macOS compatibility as a provider preflight gate for macOS guests on Apple silicon.

The default supported path is same-major host and guest macOS. Cross-major guest targets MAY remain in the support matrix as compatibility targets, but automation MUST NOT assume they work on every host/provider combination. A cross-major guest requires either current provider documentation that supports the pairing or owner-supplied preflight evidence for the specific host/provider/version combination. A guest macOS major version higher than the host macOS major version MUST be rejected by default or require an explicit owner-approved override.

This decision applies to Parallels, UTM when running macOS guests through Apple Virtualization, and any later owner-approved Tart macOS-guest implementation. It does not apply to non-macOS guests or to UTM/QEMU emulation paths outside the repository's macOS VM scope.

### Consequences

- The repo can still name macOS 26.x, 15.x, and 14.x targets, but those targets are not universal guarantees across all host versions.
- Provider code must compare host macOS, requested guest macOS, provider, provider version, and restore-image metadata before creating a VM.
- Evidence must record the host/guest compatibility classification so future readers can distinguish same-major supported evidence from cross-major best-effort evidence.
- Owner preflight captures for Parallels, UTM, and any future Tart path remain important because provider behavior changes with Apple and vendor releases.

### Alternatives Considered

- Treat the version matrix as a static list of supported guests. Rejected because vendor documentation makes support conditional on the host/provider combination.
- Support only the live demo macOS major version. Rejected because the owner wants useful compatibility targets for users who are not ready for the newest macOS release.
- Permit higher-than-host macOS guests by default. Rejected because vendor documentation warns that this may not run reliably.

## ADR-0012: Provider Isolation Verification

- **Status:** Accepted
- **Date:** 2026-05-05

### Context

Owner-supplied disposable Parallels VM evidence showed that a newly created macOS VM can satisfy basic provider requirements while still leaving host integration settings enabled. The captured VM was an Apple Virtualization macOS VM using Shared networking, but Parallels defaults still exposed integration features such as Shared Applications, shared clipboard/cloud, SmartMount-style host resource sharing, camera/gamepad auto-sharing, and host location sharing.

Later owner-supplied hardening evidence confirmed that most integration settings can be disabled through `prlctl` switches and verified with `prlctl list -i`. The same evidence exposed two additional important command surfaces: `--share-host-location <on|off>` and `--isolate-vm <on|off>`. A follow-up run confirmed both commands succeed, but also showed that `--isolate-vm on` is not sufficient proof by itself because final VM info still must be inspected for individual sharing settings. A later ordered-sequence run confirmed the final desired state after re-applying `--auto-share-gamepad off`: stopped VM, host location off, shared clipboard/cloud off, host shared folders off, shared profile off, SmartMount off, app sharing subsettings off, and camera/Bluetooth/smart-card/gamepad sharing off. The evidence also showed that provider code should verify final VM state and settings instead of trusting exit code alone, because one stop command returned a nonzero exit while the VM later reached `State: stopped`.

The repository's lab promise depends on keeping the VM identity boundary clean. A VM that accidentally inherits host sharing behavior is not safe as the durable `Clean-OS` baseline for policy validation evidence.

### Decision

Provider implementations MUST NOT trust hypervisor defaults for macOS VM isolation.

The Parallels provider MUST disable or require manual disablement for host integration features that blur the lab boundary, including shared clipboard, shared folders, shared applications, SmartMount-style host resource sharing, shared cameras, shared Bluetooth, host location sharing, host-to-guest convenience features, and similar integration features. Where supported by the installed Parallels command surface, the provider SHOULD use explicit switches such as `--isolate-vm on`, `--share-host-location off`, and per-feature disable switches. After creation or registration, the provider MUST verify the resulting VM configuration and record the isolation state before a `Clean-OS` checkpoint is considered ready. A successful hardening command is not enough; the final parsed settings are the control.

If a provider cannot disable or verify an integration feature through automation, the provider MUST surface a clear manual-step-required result. Any accepted exception MUST be explicit in the Provider Version Matrix and phase summary.

Evidence schema and provider tests MUST include provider isolation fields so tests can distinguish "VM exists" from "VM is ready as an isolated lab baseline."

### Consequences

- Provider implementation has one extra verification step after VM creation.
- Evidence and tests become more useful because they record boundary-sensitive VM settings.
- The owner may need to perform manual provider UI steps when a CLI cannot disable or verify a setting.
- A VM can be rejected for baseline use even when it starts and runs correctly.

### Alternatives Considered

- Trust provider defaults. Rejected because owner evidence showed defaults can leave sharing enabled.
- Document isolation as a user responsibility only. Rejected because the module and evidence pipeline should fail clearly when the baseline is not trustworthy.
- Disable every possible provider integration without verification. Rejected because provider defaults and CLI behavior can drift; verification is the durable control.

## ADR-0013: Defender Validation Scope and Health Output Shape

- **Status:** Accepted
- **Date:** 2026-05-05

### Context

The owner does not want Microsoft Defender for Endpoint installed on the daily-use host Mac. Host-side `mdatp` output is therefore intentionally unavailable and must not be interpreted as missing validation evidence.

Owner-supplied Defender evidence from a lab macOS environment showed `mdatp` at `/usr/local/bin/mdatp`, product version `101.26032.0016`, and `mdatp health` output as key/value text. A file named `mdatp-health.raw.json` contained the same key/value text and was not parseable JSON. The unhealthy sample included missing active event provider, network event provider not running, and Full Disk Access not granted, while still showing useful positive signals such as licensed state, engine load, cloud enabled, real-time protection, definition updates, and tamper protection.

Later owner-supplied working Defender evidence from the enrolled guest showed `healthy: true`, real-time protection available through the endpoint security extension, network event collection through the network filter extension, Full Disk Access enabled, MDM-managed Defender settings, and app version `101.26032.0016`. The raw capture included real organization, machine, EDR, and cloud configuration identifiers, so only sanitized facts and fixtures may be committed.

### Decision

Defender validation in v1 is guest-scoped. The host readiness path MUST NOT require Microsoft Defender for Endpoint on the owner's host Mac.

Phase 8 validation MUST collect Defender evidence from a disposable enrolled macOS guest VM. The validation implementation MUST support key/value text output from `mdatp health` and MAY use true JSON output only after the installed `mdatp` version is verified to support it.

Defender fixtures and evidence MUST redact organization IDs, machine GUIDs, EDR machine IDs, EDR device tags, EDR configuration identifiers, tenant identifiers, device identifiers, user identifiers, and cloud configuration IDs.

The default demo path deploys Defender through Intune after enrollment. A preinstalled-Defender fallback MAY be used for rehearsal or live-cloud timing backup, but it must be labeled as a fallback so the demo does not accidentally hide the Intune deployment behavior being validated.

Phase 8 documentation MUST keep step-by-step setup instructions for the Intune macOS Defender deployment path so the working guest state can be rebuilt and validated before rehearsal.

### Consequences

- The owner's host remains clean while the lab still validates Defender behavior where it matters: inside the managed guest.
- The parser and tests must handle key/value health output instead of assuming JSON.
- Fixture design includes both unhealthy pre-approval states and healthy post-approval/onboarded states.
- Demo planning must include enough tenant setup detail for the owner to configure the Intune-based deployment from scratch.

### Alternatives Considered

- Require Defender on the host as a readiness dependency. Rejected because it conflicts with the owner's host cleanliness requirement and does not prove guest policy behavior.
- Assume `mdatp health` JSON. Rejected because owner evidence showed a `.json` capture that was not valid JSON.
- Treat unhealthy Defender output as unusable. Rejected because missing approvals are expected and useful validation states during policy rollout.
- Preinstall Defender in the `Pre-Enroll` checkpoint as the only path. Rejected because it would make the demo more reproducible but would hide the Intune deployment behavior the repo is meant to validate.

## ADR-0014: UTM v1 Provider Posture

- **Status:** Accepted
- **Date:** 2026-05-05

### Context

Owner-supplied UTM evidence on the macOS 26.4.1 Apple-silicon demo host confirmed UTM 4.7.5 and `utmctl` 4.7.5. The evidence showed that a manually created disposable UTM VM named `macOSLab-UTM-Disposable` can be controlled through `utmctl` for basic lifecycle actions: `list`, `status`, `start` from stopped, `suspend`, resume from paused by calling `start`, and `stop`.

The same evidence showed important gaps and hazards:

- Top-level `utmctl` help does not advertise create, import, export, or snapshot primitives.
- The disposable macOS VM had to be created through the GUI path.
- `utmctl ip-address` returned `Operation not supported by the backend` for this macOS Apple Virtualization VM.
- `utmctl start` against an already-started VM printed `Operation not available` while still returning process exit code 0.
- `utmctl delete` help states that deletion has no confirmation.

### Decision

UTM is approved for v1 as an honest documented/manual provider-swap path with partial lifecycle automation. UTM is not full live parity with Parallels in v1.

The UTM provider MAY automate safe lifecycle primitives proven by owner evidence, including list, status, start from stopped, suspend, resume from paused, and stop. The provider MUST treat create/import/export/snapshot/checkpoint behavior as manual-step-required unless later owner-approved evidence proves a safe automation path. The provider MUST NOT infer success from exit code alone; it MUST inspect command output and final VM status where practical.

The implementation MUST document that `utmctl ip-address` is unsupported for the tested macOS Apple Virtualization path and that `utmctl delete` has no confirmation. Any destructive UTM delete behavior must remain outside the default demo path unless a later owner-approved test explicitly covers disposable clone cleanup.

### Consequences

- UTM remains useful for the provider-swap story without overpromising parity.
- Phase 6 implementation can focus on truthful capability reporting and manual-step guidance.
- Default demo reliability stays anchored on Parallels.
- Future UTM expansion remains possible, but it requires new owner-approved evidence.

### Alternatives Considered

- Treat UTM as full live parity with Parallels. Rejected because current evidence does not prove automated creation, snapshot/checkpoint, IP discovery, or safe delete behavior.
- Stub UTM entirely. Rejected because current evidence proves useful lifecycle automation and a viable documented provider-swap path.
- Run additional clone/delete/guest-exec testing before deciding. Rejected for v1 because the already-proven gaps are enough to rule out full parity, and delete has no confirmation.

## ADR-0015: Reuse Already-Downloaded Demo IPSW

- **Status:** Accepted
- **Date:** 2026-05-05

### Context

Owner-supplied media evidence confirmed that `mist` 2.2 successfully downloaded the pinned macOS Tahoe 26.4.1 firmware restore image for the demo host. The verified artifact is:

- Path: `~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw`
- Size: about 18 GB; Mist metadata reported `19734779897` bytes.
- SHA-256: `8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32`

Repeated downloads are slow, consume bandwidth, and increase rehearsal risk. The owner explicitly directed that no new download should be started for demo work.

### Decision

Owner/demo rehearsals MUST reuse the already-downloaded IPSW at `~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw`. Demo scripts and runbooks MUST verify that file exists and that its SHA-256 matches `8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32` before creating or registering demo VMs.

Demo scripts MUST NOT start a new `mist download` operation when the verified IPSW is present. This rule applies to the completed repository's MMS conference demo scripts, including `scripts/Invoke-MMSDemo.ps1` and `examples/MMSMOA-2026/Demo1-Media.ps1`, not only to temporary validation commands.

The expected v1 owner/demo path is `~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw`. No move is required while the file remains there. If a later demo path needs the IPSW at a different path, the runbook MUST instruct the owner to copy or move the already-downloaded file and re-run the SHA-256 verification. A new download requires explicit owner approval in the current task.

### Consequences

- Rehearsals avoid accidental 18 GB re-downloads.
- Demo scripts need a prepared-media mode that accepts an existing artifact path.
- The media acquisition cmdlet can still support download workflows for general users, but the owner/demo path defaults to verified cache reuse.

### Alternatives Considered

- Always call `mist download` during demos. Rejected because the artifact is already verified and the owner explicitly prohibited new downloads.
- Move the artifact immediately to a repository path. Rejected because `.ipsw` files must never be committed and the current cache path is already usable.
- Copy the artifact to a separate demo folder by default. Deferred because copying an 18 GB file adds time and storage use without a current need.

## ADR-0016: Use Gatekeeper/System Policy Control as the Live Demo 4 Failure

- **Status:** Accepted
- **Date:** 2026-05-06

### Context

The accepted session contract still requires FileVault and Defender validation content, but the previous live-failure story centered on Defender health or compliance drift. That made the rollback narrative less coherent because Defender portal timing, health-settling behavior, and cloud reporting can continue after a local VM restore.

Gatekeeper/System Policy Control gives the demo a cleaner operator story: a Windows-first admin responds to an app-execution audit finding, over-tightens the macOS policy to App-Store-only behavior, blocks a legitimate signed/notarized app such as Visual Studio Code on first launch, catches the issue in the lab, captures evidence, and rolls back before production users are affected. Rehearsal showed that an app already launched and admitted before the policy lands can keep opening, so the demo uses a staged-but-not-launched app for the block proof. Firefox remains acceptable as a secondary staged option when it follows the same rule.

### Decision

Demo 4 MUST use Gatekeeper/System Policy Control as the live break-and-rollback scenario. The preferred delivery path is an Intune Settings Catalog profile scoped to the lab-only device group with Gatekeeper assessment enabled and identified developers disabled. The stage path MAY initiate live Intune delivery as a background thread, but the success path MUST be checkpointed and fixture-backed.

The repository MUST keep FileVault and Defender as required validation guides, test plans, and backup proof paths. It MUST NOT pivot the live Demo 4 failure back to Defender-unhealthy.

### Consequences

- The Demo 4 script is named `Demo4-GatekeeperRollback.ps1`.
- Gatekeeper uses split validation plans: `Gatekeeper-AppStoreOnly.yml` for `Broken-Policy-State` and `Gatekeeper-Recovered.yml` for the post-rollback proof.
- No sample `.mobileconfig`, screenshot, recording, app bundle, Team ID, tenant ID, UPN, device ID, profile UUID, or recovery key is committed.
- Direct local profile installation remains a verified fallback only, not the canonical story.
- The demo must say that VM rollback restores the VM, not Intune, Entra, Defender portal state, audit logs, assignments, or cloud reporting.

### Alternatives Considered

- Keep Defender unhealthy as the live failure. Rejected because the timing and rollback story are weaker.
- Use a live compliance or Conditional Access failure. Rejected for the core path because cloud timing and access propagation are not dependable stage dependencies.
- Commit a sample System Policy Control `.mobileconfig`. Rejected because the talk should point admins to Intune Settings Catalog and the repo must not collect profile identifiers or payload material from a real tenant.
