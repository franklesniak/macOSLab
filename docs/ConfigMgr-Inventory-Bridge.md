<!-- markdownlint-disable MD013 -->
# ConfigMgr Inventory Bridge

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Documents the optional Phase 10 ConfigMgr adjacency for macOSLab evidence and inventory. It does not define a v1 ConfigMgr integration or a production inventory pipeline.
- **Related:** [Windows Admin Cheat Sheet](Windows-Admin-Cheat-Sheet.md), [Evidence and CAB](Evidence-and-CAB.md), [Phase 10 TODO](../TODO-Phase-10-Deferred-Work.md), [macOSLab Repository Specification](spec/macOSLab-repository-spec.md)

## V1 Posture

ConfigMgr is an inventory adjacency for this repository, not the control plane. The control plane for the lab is Intune, and the portable proof artifact is the redacted macOSLab evidence bundle.

V1 does not:

- install a ConfigMgr client on the macOS guest;
- write directly to a ConfigMgr database;
- create hardware inventory classes;
- upload tenant, user, device, or Defender identifiers to ConfigMgr;
- replace Intune assignment, compliance, or cleanup workflows.

## Safe Bridge Shape

If ConfigMgr adjacency is useful later, start with a redacted export that a ConfigMgr administrator can review before importing anywhere:

| Evidence field | Inventory use | Redaction expectation |
| --- | --- | --- |
| `runId` | Correlate the lab run with a change ticket. | Safe synthetic value only. |
| `vmName` | Identify the disposable lab VM. | Lab-only name such as `MMS-MACLAB-001`. |
| `provider` | Record Parallels, UTM, or Tart. | Not sensitive. |
| `providerVersionMatrix` | Record host, guest, provider, PowerShell, Pester, and Defender versions. | No serials, tenant IDs, or device IDs. |
| `tests` | Summarize policy validation results. | No raw command output unless already redacted. |
| `cloudStateWarning` | Preserve rollback boundary. | Required. |

## Future Acceptance

A later owner-approved bridge must include schema documentation, redaction tests, import instructions that do not require production ConfigMgr access, and a clear statement that Intune remains the source for policy assignment and compliance state.
