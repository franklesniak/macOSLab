<!-- markdownlint-disable MD013 -->
# Snapshot Strategy

## Metadata

- **Status:** Active
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-05
- **Scope:** Defines the five-checkpoint model, restore warnings, cloud cleanup posture, and checkpoint readiness expectations for `macOSLab`.
- **Related:** [Fidelity Boundaries](Fidelity-Boundaries.md), [Provider Version Matrix](Provider-Version-Matrix.md), [Prerequisites](Prereqs.md), [macOSLab repository specification](spec/macOSLab-repository-spec.md)

Snapshots are the reason the lab is fast, but they are also where local state and cloud state can drift. Use the five canonical checkpoint names exactly.

## Canonical Checkpoints

| Checkpoint | Purpose |
| --- | --- |
| `Clean-OS` | Freshly installed guest, Setup Assistant complete, no demo software, never enrolled. |
| `Pre-Enroll` | `Clean-OS` plus Intune Company Portal at the sign-in screen; not enrolled. |
| `Post-Enroll-Baseline` | Fully enrolled, recently synced, deterministic healthy baseline. |
| `Broken-Policy-State` | Deterministic intentionally broken state for the engineered demo failure. |
| `Recovered-Known-Good` | Post-rollback healthy state, captured after cloud cleanup or reconciliation. |

Alternative checkpoint names are not allowed in v1 unless a caller explicitly opts into non-canonical names for local experimentation.

## When To Capture

Capture `Clean-OS` only after provider isolation has been verified. A VM with host sharing enabled is not a trustworthy lab baseline.

Capture `Pre-Enroll` before enrollment starts. This checkpoint lets the operator retry enrollment without reinstalling macOS.

Capture `Post-Enroll-Baseline` after enrollment, policy receipt, and enough sync time for the baseline to be deterministic.

Capture `Broken-Policy-State` only when the failure is intentional and documented in the test plan.

Capture `Recovered-Known-Good` after rollback and any required cloud cleanup or reconciliation notes are complete.

## Restore Rule

Every restore path must warn before and after the operation:

> VM rollback does not rewind Intune, Entra, Defender portal state, audit logs, or reporting history.

Restore commands must require explicit acknowledgement for non-interactive or unattended use. A restore can put the local guest back in time while cloud services still remember newer enrollment, compliance, Defender, or audit state.

## Clean Shutdown Rule

Checkpoint capture should prefer a stopped guest. Snapshotting a running or paused VM can preserve transient identity, network, or MDM timing state that makes later evidence harder to explain. Providers must enforce or clearly document clean-shutdown requirements.

## Cloud Cleanup Posture

V1 local rollback does not delete or retire cloud records. Cloud cleanup remains report-only unless a later owner-approved Phase 10 change adds mutation. A valid report-only cleanup result may identify candidate Intune, Entra, and Defender records, explain why they may be stale, and show portal paths or Graph commands for manual cleanup.

## Readiness Checks

Before rehearsal, the readiness gate should verify:

- Required provider tools are present.
- Required media exists and matches the expected checksum.
- The VM exists under the selected provider.
- Required checkpoints exist.
- The Provider Version Matrix can be produced.
- Known manual-step gaps are acknowledged.
- Optional network/cloud checks are green or intentionally skipped with reasons.

## Failure Example

If `Broken-Policy-State` exists but `Post-Enroll-Baseline` is missing, the lab is not ready for a controlled rollback demo. The operator should return to the enrollment baseline step and capture the missing checkpoint before creating or using the broken state.
