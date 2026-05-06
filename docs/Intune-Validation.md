<!-- markdownlint-disable MD013 -->
# Intune Validation

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-06
- **Scope:** Documents fixture-backed Intune compliance and Gatekeeper/System Policy Control validation, plus cloud-state warnings for macOSLab.
- **Related:** [Evidence and CAB](Evidence-and-CAB.md), [Snapshot Strategy](Snapshot-Strategy.md), [Gatekeeper App Store only test](../examples/TestCases/Gatekeeper-AppStoreOnly.yml), [Gatekeeper recovered test](../examples/TestCases/Gatekeeper-Recovered.yml), [Compliance smoke test](../examples/TestCases/Compliance-SmokeTest.yml)

## Validation Model

Intune validation must distinguish local VM rollback from cloud state. A restored VM checkpoint does not rewind Intune, Entra, Defender portal state, audit logs, or reporting history.

The minimum evidence path is:

- expected checkpoint or rollback state;
- compliance snapshot or policy result summary;
- whether a failing compliance result is an engineered demo failure;
- cloud-state warning in the evidence bundle;
- manual cleanup planning for stale Intune, Entra, and Defender records.

## Graph Scope

Plans that require Graph data MUST declare required scopes. `Invoke-MacPolicyValidation` fails closed when a plan declares scopes that the caller did not provide through `-GraphScope`.

The default fixture plan declares `DeviceManagementManagedDevices.Read.All` and does not call Microsoft Graph during local tests.

## Gatekeeper and System Policy Control

The Demo 4 risky-policy sample uses Intune Settings Catalog as the preferred rehearsal delivery path:

- Devices > Configuration > Create > New policy.
- Platform: macOS.
- Profile type: Settings catalog.
- Category: System Policy Control/Gatekeeper.
- Enable Assessment: enabled.
- Allow Identified Developers: disabled.

The repository does not commit a sample `.mobileconfig`. A local profile install may be useful only as a verified fallback or payload-mechanics probe on the actual demo VM.

Use split validation plans:

- [Gatekeeper-AppStoreOnly.yml](../examples/TestCases/Gatekeeper-AppStoreOnly.yml) represents `Broken-Policy-State`; it expects the profile to be present and VS Code to be rejected as an expected failure.
- [Gatekeeper-Recovered.yml](../examples/TestCases/Gatekeeper-Recovered.yml) represents rollback to `Post-Enroll-Baseline`; it expects `spctl` to accept VS Code and launch evidence to show recovery.

This pattern is for high-risk policies, repeated validation loops, demo scenarios, and evidence that must be reproducible. It is not a requirement to create a YAML plan for every low-risk Intune setting change.
