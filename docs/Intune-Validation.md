<!-- markdownlint-disable MD013 -->
# Intune Validation

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Documents fixture-backed Intune compliance validation and cloud-state warnings for macOSLab.
- **Related:** [Evidence and CAB](Evidence-and-CAB.md), [Snapshot Strategy](Snapshot-Strategy.md), [Compliance smoke test](../examples/TestCases/Compliance-SmokeTest.yml)

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
