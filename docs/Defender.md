<!-- markdownlint-disable MD013 -->
# Defender

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Documents guest-scoped Microsoft Defender for Endpoint validation and Intune setup for the macOSLab demo path.
- **Related:** [Evidence Redaction](Evidence-Redaction.md), [Evidence and CAB](Evidence-and-CAB.md), [Phase 8 TODO](../TODO-Phase-08-Validation-Loop.md), [Defender validation plan](../examples/TestCases/Defender-Validation.yml)

## Scope

Defender validation is guest-scoped. The daily-driver host Mac is intentionally not required to have Defender installed. `mdatp health` evidence MUST be collected inside the disposable enrolled macOS guest.

The default demo path is Intune-based Defender deployment after enrollment. A preinstalled-Defender guest MAY be kept only as a rehearsal or live-cloud timing fallback and MUST be labeled as a fallback.

## Intune Setup

1. Download the current Microsoft Defender for Endpoint macOS package and onboarding package from the Microsoft Defender portal.
2. In Intune admin center, add the Defender package as a macOS line-of-business app or the current recommended Microsoft app type for Defender.
3. Assign the app to the macOS lab device group used by the demo guest.
4. Create or import the Defender system extension profile for macOS.
5. Create the Network Extension profile if the selected Defender configuration uses network filtering.
6. Create the PPPC profile that grants Full Disk Access to Defender components.
7. Deploy the onboarding configuration profile to the same lab device group.
8. Confirm app, system extension, network extension, PPPC, and onboarding profiles all target the enrolled guest.
9. Sync the guest from Company Portal or Intune, then allow enough time for app installation and profile delivery.
10. Verify inside the guest with `mdatp version` and `mdatp health`.

## Evidence

The repository parser treats `mdatp health` as key/value text because owner evidence showed the `.raw.json` capture contained text, not parseable JSON. Fields such as organization ID, machine GUID, EDR machine ID, EDR tags, tenant IDs, user IDs, and device IDs MUST be redacted before evidence is written.

The fixture [examples/TestCases/fixtures/mdatp-health-unhealthy.txt](../examples/TestCases/fixtures/mdatp-health-unhealthy.txt) represents the pre-approval unhealthy state where event providers or Full Disk Access are missing. A healthy post-PPPC/onboarded guest capture remains an owner-validation boundary item.
