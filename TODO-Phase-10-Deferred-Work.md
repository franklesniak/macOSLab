<!-- markdownlint-disable MD013 -->
# TODO Phase 10 Deferred Work

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Deferred optional or owner-approval-dependent work that is outside Phase 0 and not required for the first working local lab path.

## Checklist

- [ ] Owner: Repository owner; Status: Deferred outside v1; Phase gate affected: Phase 10 optional providers and CI; Why it matters: Tart is useful for advanced CLI and CI paths but is not a v1 parity provider, and any future macOS guest creation path must respect Apple Virtualization host/guest compatibility constraints; Action: keep Tart as a documented/stubbed provider in v1, and revisit full provider parity only after a later explicit owner approval; Acceptance condition: v1 mutating Tart primitives fail clearly as unsupported, the docs explain the license posture, and any later full implementation re-verifies scope, licensing, compatibility, and provider tests; Source: ADR-0006, ADR-0011, and owner decision on 2026-05-05.
- [ ] Owner: Repository owner; Status: Deferred outside v1; Phase gate affected: Phase 10 cloud cleanup; Why it matters: local VM rollback does not rewind Intune, Entra, Defender portal state, audit logs, or reporting history, and unsafe matching could mutate the wrong cloud record; Action: keep `Reset-IntuneMacLabDevice.ps1` report-only in v1, and revisit soft-delete/retire or hard-delete only after a later explicit owner approval; Acceptance condition: v1 reports candidate records without mutating cloud state, and any later mutation mode has tests for scoping, confirmation, redaction, soft-delete/retire behavior, and failure paths; Source: ADR-0010 and owner decision on 2026-05-05.
- [x] Owner: Repository owner; Status: Closed on 2026-05-05; Phase gate affected: Phase 1 or later security documentation; Why it matters: ADR-0009 approves only a narrow optional project-specific paragraph for `SECURITY.md`; Action: add the ADR-0009 paragraph after owner approval; Acceptance condition: owner explicitly approves the exact paragraph and the inherited responsible-disclosure process remains intact; Source: ADR-0009 and owner approval on 2026-05-05.
