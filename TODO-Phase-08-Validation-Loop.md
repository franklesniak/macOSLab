<!-- markdownlint-disable MD013 -->
# TODO Phase 08 Validation Loop

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Deferred verification for Defender health evidence before implementing Phase 8.

## Checklist

- [ ] Owner: Repository owner; Status: Open; Phase gate affected: Phase 8 validation loop; Why it matters: Defender `mdatp health` output can change and evidence fixtures must not leak real tenant or device data; Action: verify the current Defender `mdatp health` output shape and create sanitized fixtures for evidence tests; Acceptance condition: fixture fields needed by validation code are documented, sanitized, and covered by tests before Defender validation ships; Source: ADR-0005 and spec Section 9.6.
