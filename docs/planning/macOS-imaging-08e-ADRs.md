<!-- markdownlint-disable MD013 -->
# macOSLab Architecture Decision Records

## Metadata

- **Status:** Draft for owner review
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-05
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

- `TODO-Phase-04-Media-Acquisition.md`
- `TODO-Phase-05-Parallels-Provider.md`
- `TODO-Phase-06-UTM-Provider.md`
- `TODO-Phase-08-Validation-Loop.md`
- `TODO-Phase-10-Deferred-Work.md`

The file is omitted when the phase has no outstanding TODOs.

### Consequences

- Deferred work is visible from the repo root.
- README and phase summaries must link to active TODO files.
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

Leave `SECURITY.md` unchanged by default and do not rewrite it. During Phase 1, after the inherited template file is visible, the implementation agent may propose only this exact short project-specific paragraph if it fits the existing responsible-disclosure process:

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
