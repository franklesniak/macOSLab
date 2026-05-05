<!-- markdownlint-disable MD013 -->
# Provider Version Matrix

## Metadata

- **Status:** Active
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-05
- **Scope:** Defines the Provider Version Matrix that each evidence-producing workflow records for host, guest, provider, media, and validation context.
- **Related:** [Apple Silicon Constraints](Apple-Silicon-Constraints.md), [Hypervisor Decision Guide](Hypervisor-Decision-Guide.md), [Fidelity Boundaries](Fidelity-Boundaries.md), [macOSLab repository specification](spec/macOSLab-repository-spec.md)

"Works on my Mac" is not evidence. A result is reviewable only when it records the exact host, guest, provider, media, and validation context that produced the result.

## Required Fields

Every evidence-producing workflow should record these fields when they are available:

| Field | Meaning |
| --- | --- |
| `hostMacOS` | Host macOS marketing version. |
| `hostMacOSBuild` | Host macOS build number. |
| `hostArchitecture` | Expected value is `arm64` for v1. |
| `guestMacOS` | Guest macOS marketing version. |
| `guestBuild` | Guest macOS build number. |
| `hostGuestCompatibility` | `same-major-supported`, `documented-cross-major-best-effort`, `owner-validated-cross-major`, or `rejected`. |
| `provider` | `Parallels`, `UTM`, or `Tart`. |
| `providerVersion` | Provider CLI/app version output. |
| `providerEdition` | Edition when detectable; otherwise `unknown`. |
| `mediaPath` | Local path to the restore image or provider-appropriate install artifact. |
| `mediaSha256` | SHA-256 checksum where practical. |
| `mediaSizeBytes` | Artifact size where practical. |
| `networkMode` | Expected default is Shared networking. |
| `isolationState` | Parsed provider sharing/isolation facts. |
| `manualStepGaps` | Provider actions that were manual-step-required or unsupported. |
| `powerShellVersion` | PowerShell version used for the run. |
| `pesterVersion` | Pester version for test evidence. |
| `defenderVersion` | Defender version when Defender validation is in scope. |
| `intunePolicySetId` | Synthetic or lab-only policy-set identifier from the test plan. |
| `testedAt` | UTC timestamp for the run. |

## Sample Matrix

```json
{
  "hostMacOS": "26.4.1",
  "hostMacOSBuild": "25E253",
  "hostArchitecture": "arm64",
  "guestMacOS": "26.4.1",
  "guestBuild": "25E253",
  "hostGuestCompatibility": "same-major-supported",
  "provider": "Parallels",
  "providerVersion": "26.3.2-57398",
  "providerEdition": "unknown",
  "mediaPath": "~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw",
  "mediaSha256": "8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32",
  "mediaSizeBytes": 19734779897,
  "networkMode": "Shared",
  "isolationState": {
    "sharedClipboard": "off",
    "sharedFolders": "off",
    "sharedApplications": "off",
    "hostLocation": "off"
  },
  "manualStepGaps": [],
  "powerShellVersion": "7.4.0",
  "pesterVersion": "5.7.1",
  "defenderVersion": null,
  "intunePolicySetId": "<policy-set-version>",
  "testedAt": "2026-05-05T00:00:00Z"
}
```

## Compatibility Classification

Use these values consistently:

- `same-major-supported`: Host and guest share the same macOS major version, and provider preflight permits the run.
- `documented-cross-major-best-effort`: Current provider documentation supports the pairing, but it is not the default same-major path.
- `owner-validated-cross-major`: Owner-supplied evidence proves the specific host/provider/guest pairing.
- `rejected`: The guest is higher than the host, provider documentation does not support the pairing, or the host/provider facts are insufficient.

## Isolation State

Provider evidence must distinguish "VM exists" from "VM is ready as an isolated lab baseline." Record whether these are disabled or manual-step-required:

- Host shared folders.
- Host-defined sharing.
- Shared profile.
- Shared applications.
- SmartMount or similar host resource sharing.
- Shared clipboard.
- Shared cloud.
- Camera sharing.
- Bluetooth sharing.
- Smart-card sharing.
- Gamepad sharing.
- Host location sharing.

If a provider cannot expose a field, record `unknown` or `manual-step-required`; do not infer that it is safe.

## Review Rule

A change ticket or demo summary should include the Provider Version Matrix alongside the test result. Without the matrix, the result is a local observation, not durable evidence.
