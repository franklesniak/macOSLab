<!-- markdownlint-disable MD013 -->
# PPPC TCC

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-06
- **Scope:** Documents PPPC/TCC validation evidence boundaries for macOSLab.
- **Related:** [Evidence and CAB](Evidence-and-CAB.md), [PPPC validation plan](../examples/TestCases/PPPC-Validation.yml)

## Validation Model

PPPC/TCC validation is a precision problem. Evidence MUST identify the target app or service by bundle ID, code requirement, and path when relevant. A screenshot of System Settings alone is not sufficient evidence.

Do not confuse PPPC/TCC with Gatekeeper/System Policy Control. PPPC/TCC governs privacy permissions such as Full Disk Access, Accessibility, camera, microphone, and screen recording. Gatekeeper/System Policy Control governs whether macOS accepts or rejects app execution.

The minimum fixture-backed evidence path is:

- profile receipt summary;
- app or service behavior check;
- log or command evidence that the expected TCC decision was applied;
- redaction of any local usernames or host paths.

## Boundaries

VM validation is useful for repeatable PPPC delivery checks. Hardware sign-off remains required for policies that depend on physical-device capabilities or user-consent timing that cannot be represented faithfully in a VM.
