<!-- markdownlint-disable MD013 -->
# Intune Validation

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-07
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
- Settings picker category: System Policy Control.
- Subcategory: System Policy Control.
- Select `Allow Identified Developers` and `Enable Assessment`.
- Leave `Enable XProtect Malware Upload` unselected for the default demo path.
- Configure `Enable Assessment` as `True`.
- Configure `Allow Identified Developers` as `False`.
- Optional subcategory: System Policy Managed.
- Optional setting: configure `Disable Override` as `True` when the tenant UI exposes it.

The repository does not commit a sample `.mobileconfig`. A local profile install may be useful only as a verified fallback or payload-mechanics probe on the actual demo VM.

Use split validation plans:

- [Gatekeeper-AppStoreOnly.yml](../examples/TestCases/Gatekeeper-AppStoreOnly.yml) represents `Broken-Policy-State`; it expects the profile to be present and VS Code first launch to be rejected as an expected failure.
- [Gatekeeper-Recovered.yml](../examples/TestCases/Gatekeeper-Recovered.yml) represents rollback to `Post-Enroll-Baseline`; it expects `spctl` to accept VS Code and launch evidence to show recovery.

The live demo MUST NOT use an app that was already launched and admitted before the App-Store-only policy arrived. A previously launched app can continue opening and make the policy look ineffective. The preferred path is to install or stage Visual Studio Code before `Post-Enroll-Baseline`, verify baseline acceptance with `spctl --assess -vv "/Applications/Visual Studio Code.app"`, and reserve the first GUI launch for `Broken-Policy-State`. Firefox MAY be used as a secondary staged app only when it follows the same not-launched-before-policy rule.

This pattern is for high-risk policies, repeated validation loops, demo scenarios, and evidence that must be reproducible. It is not a requirement to create a YAML plan for every low-risk Intune setting change.
