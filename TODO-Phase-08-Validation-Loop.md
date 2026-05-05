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

Owner-supplied Defender evidence from a lab macOS environment also confirms:

- `mdatp` is available at `/usr/local/bin/mdatp`.
- `mdatp version` reported product version 101.26032.0016.
- The captured `mdatp health` output was key/value text, not JSON. A file named `mdatp-health.raw.json` contained the same text as `mdatp-health.raw.txt` and failed JSON parsing.
- The captured health state was `healthy: false` with health issues for missing active event provider, network event provider not running, and Full Disk Access not granted.
- The output can simultaneously show useful positive signals such as `licensed: true`, engine load success, `cloud_enabled: true`, real-time protection enabled, automatic definition updates enabled, definitions up to date, and tamper protection set to block.
- Fields requiring redaction include at least organization ID, machine GUID, EDR machine ID, EDR device tags, EDR configuration identifiers, and any future tenant/device/user identifiers.

## Remaining Open Items

- [ ] After a disposable VM exists, install or deploy Defender for Endpoint inside the guest using the intended demo path.
- [ ] Capture `mdatp health` output before and after onboarding, after required system extension and Full Disk Access approvals, and after any intentionally broken policy state used in the demo.
- [ ] Verify whether the installed `mdatp` has a true JSON output mode. If not, implement and test a parser for key/value text output rather than assuming JSON.
- [ ] Sanitize tenant, device, machine, organization, EDR, user, and cloud identifiers before using the output as fixtures.
- [ ] Decide whether Defender should be present in the `Pre-Enroll` snapshot or deployed live by Intune; do not accidentally hide the behavior the demo is meant to show.
- [ ] Capture a healthy post-PPPC/onboarded state so tests can distinguish expected pre-approval failure from real Defender malfunction.

## Checklist

- [ ] Owner: Repository owner; Status: Partially verified, guest-only by design; Phase gate affected: Phase 8 validation loop; Why it matters: Defender `mdatp health` output can change and evidence fixtures must not leak real tenant or device data; Action: use the confirmed key/value health-output fields above, verify true JSON availability or implement text parsing, then capture healthy and unhealthy disposable-guest fixtures; Acceptance condition: fixture fields needed by validation code are documented, sanitized, and covered by tests before Defender validation ships; Source: ADR-0005 and spec Section 9.6.
