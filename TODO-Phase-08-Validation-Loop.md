<!-- markdownlint-disable MD013 -->
# TODO Phase 08 Validation Loop

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Deferred verification for Defender health evidence before implementing Phase 8.

## Confirmed Preflight Evidence

The owner does not want Microsoft Defender for Endpoint installed on the daily-driver host Mac. Host-side `mdatp` output is therefore intentionally unavailable and should not be treated as missing evidence.

Defender validation evidence should be collected inside a disposable macOS guest VM after the pinned VM build exists. This keeps the host clean and better matches the lab's purpose: validating Defender, PPPC/FDA, onboarding, and health from inside the managed guest.

## Remaining Open Items

- [ ] After a disposable VM exists, install or deploy Defender for Endpoint inside the guest using the intended demo path.
- [ ] Capture `mdatp health` output before and after onboarding, after required system extension and Full Disk Access approvals, and after any intentionally broken policy state used in the demo.
- [ ] Sanitize tenant, device, machine, user, and cloud identifiers before using the output as fixtures.
- [ ] Decide whether Defender should be present in the `Pre-Enroll` snapshot or deployed live by Intune; do not accidentally hide the behavior the demo is meant to show.

## Checklist

- [ ] Owner: Repository owner; Status: Open, guest-only by design; Phase gate affected: Phase 8 validation loop; Why it matters: Defender `mdatp health` output can change and evidence fixtures must not leak real tenant or device data; Action: verify the current Defender `mdatp health` output shape inside a disposable macOS guest and create sanitized fixtures for evidence tests; Acceptance condition: fixture fields needed by validation code are documented, sanitized, and covered by tests before Defender validation ships; Source: ADR-0005 and spec Section 9.6.
