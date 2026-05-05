<!-- markdownlint-disable MD013 -->
# TODO Phase 10 Deferred Work

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Deferred optional or owner-approval-dependent work that is outside Phase 0 and not required for the first working local lab path.

## Checklist

- [ ] Owner: Repository owner; Status: Open; Phase gate affected: Phase 10 optional providers and CI; Why it matters: Tart is useful for advanced CLI and CI paths but is not a v1 parity provider, and any future macOS guest creation path must respect Apple Virtualization host/guest compatibility constraints; Action: decide whether to implement full Tart provider parity beyond the documented/stubbed path; Acceptance condition: owner approves scope, license posture is re-verified, host/guest compatibility behavior is documented for any macOS guest creation support, and provider tests define supported and unsupported capabilities; Source: ADR-0006 and ADR-0011.
- [ ] Owner: Repository owner; Status: Open; Phase gate affected: Phase 10 cloud cleanup; Why it matters: local VM rollback does not rewind Intune, Entra, Defender portal state, audit logs, or reporting history, and unsafe matching could mutate the wrong cloud record; Action: decide whether `Reset-IntuneMacLabDevice.ps1` may move beyond report-only mode into cloud mutation; Acceptance condition: owner approves the change and tests cover scoping, confirmation, redaction, soft-delete/retire behavior, and failure paths; Source: ADR-0010.
- [ ] Owner: Repository owner; Status: Open; Phase gate affected: Phase 1 or later security documentation; Why it matters: ADR-0009 approves only a narrow optional project-specific paragraph for `SECURITY.md`; Action: decide whether to add the ADR-0009 paragraph after owner review; Acceptance condition: owner explicitly approves the exact paragraph and the inherited responsible-disclosure process remains intact; Source: ADR-0009.
