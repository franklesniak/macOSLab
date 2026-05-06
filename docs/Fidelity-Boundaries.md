<!-- markdownlint-disable MD013 -->
# Fidelity Boundaries

## Metadata

- **Status:** Active
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-06
- **Scope:** Defines the VM Fidelity Traffic Light, cmdlet honesty rules, cloud-state warning, and change-ticket wording for `macOSLab`.
- **Related:** [Apple Silicon Constraints](Apple-Silicon-Constraints.md), [Snapshot Strategy](Snapshot-Strategy.md), [Provider Version Matrix](Provider-Version-Matrix.md), [macOSLab repository specification](spec/macOSLab-repository-spec.md)

The lab is useful because it is honest. A macOS VM can prove many automation and policy behaviors quickly, but it cannot replace every physical Mac validation path.

## Traffic Light

| Color | Meaning | Examples |
| --- | --- | --- |
| Green | VM evidence is sufficient on its own. | Script syntax, package install behavior, Intune assignment logic, profile receipt, Gatekeeper/System Policy Control receipt, `spctl` assessment, app launch block/recovery in the guest, basic PPPC payload behavior, Defender health checks, rollback routines, evidence export. |
| Yellow | VM evidence is useful for iteration, but physical hardware sign-off remains required. | FileVault rollout behavior, recovery-key process end to end, compliance experience under realistic timing, user prompts, UI flows, fleet inventory, production rollout impact, performance-sensitive Defender behavior. |
| Red | The VM cannot validate the outcome. | ADE/ABM zero-touch enrollment, serial-number-dependent workflows, Platform SSO sign-in/unlock, Touch ID, Secure Enclave-dependent behavior, final executive pilot sign-off. |

## Cmdlet Honesty Rules

Evidence-producing cmdlets must:

- Stamp evidence with the fidelity color.
- Set `hardwareSignoffRequired: true` for Yellow evidence.
- Reject Red-bucket assertions at parse time.
- Preserve the cloud-state warning in restore and evidence records.
- Refuse to write evidence when redaction cannot be applied.

Documentation must not claim the lab proves Red-bucket outcomes.

## Cloud-State Warning

Every restore warning and evidence record must include this statement:

> VM rollback does not rewind Intune, Entra, Defender portal state, audit logs, or reporting history.

The warning is not decorative. It explains why a local VM restore can leave stale device records, compliance history, audit entries, Defender machine records, or assignment timing in cloud services.

## Yellow Change-Ticket Wording

Use wording like this when VM evidence supports but does not replace physical sign-off:

```text
macOSLab VM evidence shows the policy payload was received and produced the expected lab behavior on the recorded host/provider/guest matrix. This is Yellow evidence: physical Mac sign-off remains required before production rollout because VM rollback does not rewind Intune, Entra, Defender portal state, audit logs, or reporting history, and VM hardware fidelity does not cover Secure Enclave, Touch ID, ADE/ABM, or final user-pilot behavior.
```

## Red Assertion Example

This is not a valid VM test assertion:

```yaml
fidelity: Red
expectation: ADE zero-touch enrollment succeeds in production
```

The validation loop must reject this plan before execution. The correct action is to document a physical hardware validation step outside the VM evidence path.

## Evidence Review Checklist

Before using VM evidence in a review, confirm:

- The Provider Version Matrix is present.
- The fidelity color is present.
- Yellow evidence says hardware sign-off is required.
- No Red-bucket claim is presented as validated.
- Redaction is applied.
- The cloud-state warning is present.
