<!-- markdownlint-disable MD013 -->
# Log Analytics Integration

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Documents the optional Phase 10 Log Analytics posture for macOSLab evidence. The integration is disabled by default and does not ship a live ingestion pipeline in v1.
- **Related:** [Evidence and CAB](Evidence-and-CAB.md), [Evidence Redaction](Evidence-Redaction.md), [Phase 10 TODO](../TODO-Phase-10-Deferred-Work.md), [macOSLab Repository Specification](spec/macOSLab-repository-spec.md)

## V1 Posture

Log Analytics is an optional evidence destination, not part of the default demo path. V1 keeps Log Analytics ingestion disabled by default because evidence bundles may contain tenant, device, Defender, or policy identifiers before redaction has been verified.

The repository includes `scripts/Send-LabEventToLogAnalytics.ps1` as a disabled-by-default planning helper. It can produce a local redacted event envelope that shows what would be sent later, but it does not send data to Azure Monitor in v1.

## Environment Variables

If a future owner-approved Phase 10 change enables live ingestion, use environment variables rather than committed configuration files:

| Variable | Purpose | Commit value? |
| --- | --- | --- |
| `MACLAB_LOG_ANALYTICS_DCE_ENDPOINT` | Data Collection Endpoint URL. | No |
| `MACLAB_LOG_ANALYTICS_DCR_ID` | Data Collection Rule immutable ID. | No |
| `MACLAB_LOG_ANALYTICS_STREAM_NAME` | Target custom stream name. | No |
| `MACLAB_LOG_ANALYTICS_TENANT_ID` | Tenant identifier used for authentication. | No |
| `MACLAB_LOG_ANALYTICS_CLIENT_ID` | App registration client ID, if app auth is approved later. | No |

Secrets such as client secrets, certificates, refresh tokens, or bearer tokens MUST NOT be placed in repository files, example configs, screenshots, transcripts, or evidence fixtures.

## Redaction Boundary

Any future ingestion path MUST:

- run evidence through `Protect-MacLabEvidence` before network transmission;
- fail closed if redaction did not stamp `redactionApplied: true`;
- omit raw FileVault recovery keys, tokens, tenant IDs, device IDs, EDR machine IDs, serial numbers, UPNs, and email addresses;
- record the Provider Version Matrix and cloud-state warning with the event;
- keep local evidence export working even when cloud ingestion is unavailable.

## Future Acceptance

Live ingestion is not approved in v1. A later change must include tests for redaction, missing environment variables, network failure, retry behavior, and proof that no default test requires Azure credentials or network access.
