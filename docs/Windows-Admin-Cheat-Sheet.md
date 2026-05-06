<!-- markdownlint-disable MD013 -->
# Windows Admin Cheat Sheet

## Metadata

- **Status:** Active
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-06
- **Scope:** Translation guide for Windows-first Microsoft endpoint administrators working in a macOS VM lab.
- **Related:** [Start Here](Start-Here.md), [Prerequisites](Prereqs.md), [Fidelity Boundaries](Fidelity-Boundaries.md), [Snapshot Strategy](Snapshot-Strategy.md), [macOSLab repository specification](spec/macOSLab-repository-spec.md)

This document maps familiar Windows endpoint-management instincts to the macOS VM lab model used by `macOSLab`.

## Translation Table

| Windows instinct | macOS lab equivalent | Caution |
| --- | --- | --- |
| Use Hyper-V checkpoints for fast rollback. | Use provider checkpoints named `Clean-OS`, `Pre-Enroll`, `Post-Enroll-Baseline`, `Broken-Policy-State`, and `Recovered-Known-Good`. | Local rollback does not rewind Intune, Entra, Defender portal state, audit logs, or reporting history. |
| Treat the VM as representative hardware. | Treat the VM as fast iteration evidence with fidelity labels. | Secure Enclave, Touch ID, ADE/ABM, Platform SSO, and final pilot behavior need physical Mac validation. |
| Use ISO media. | Use IPSW restore images or provider-appropriate install artifacts for Apple-silicon macOS guests. | Do not assume ISO workflows apply to macOS VMs on Apple silicon. |
| Use Device Manager or Windows event logs. | Use macOS commands, MDM profile receipt, targeted app behavior, and sanitized logs. | Avoid screenshots as primary evidence; prefer structured facts. |
| Validate BitLocker escrow end to end. | Validate FileVault status and escrow existence or retrieval path with recovery key values redacted. | Never display or persist raw recovery keys. |
| Use AppLocker, WDAC, or SmartScreen to control app execution. | Use Gatekeeper/System Policy Control settings and `spctl` evidence for macOS app execution policy. | App Store only can block legitimate signed/notarized apps such as Visual Studio Code; test in a lab-only scope first. |
| Confirm Defender is installed. | Confirm Defender package, system extension, network extension when used, Full Disk Access/PPPC, onboarding, and `mdatp health`. | Host Defender is not required; validation is guest-scoped. |
| Use broad Azure AD or Intune queries. | Use lab-only users, groups, naming, and scope filters. | Do not run cleanup or mutation against production-matching objects. |
| Assume agent exit code equals success. | Inspect provider output and final VM state. | Some provider CLIs can return surprising exit codes or print operational errors with exit code 0. |
| Use bridged networking for realism. | Default to Shared networking. | Network identity tests may need Yellow or Red classification. |
| Attach logs to a ticket. | Attach redacted evidence JSON and summary files. | Raw logs can contain tenant, user, device, or recovery data. |

## PowerShell Mindset

The public module surface uses PowerShell 7.4 or newer. Expect:

- Approved Verb-Noun function names.
- `ShouldProcess` for VM mutation, disk writes, cloud contact, and destructive actions.
- Structured objects, not display strings.
- Redaction by default.
- Tests that mock providers and cloud calls by default.

## macOS Terms To Recognize

| Term | Meaning in this lab |
| --- | --- |
| APNs | Apple Push Notification service path required for MDM signaling. |
| PPPC | Privacy Preferences Policy Control payloads that grant app permissions such as Full Disk Access. |
| TCC | macOS Transparency, Consent, and Control subsystem enforcing app privacy permissions. |
| FileVault | macOS full-disk encryption feature. |
| Gatekeeper | macOS app assessment and launch-protection behavior that can be tightened through System Policy Control. |
| System Policy Control | MDM payload area that can enable Gatekeeper assessment and restrict identified-developer app launches. |
| `spctl` | macOS command used to inspect Gatekeeper status and assess whether an app is accepted or rejected. |
| IPSW | Apple restore image used for Apple-silicon macOS VM creation paths. |
| Apple Virtualization | Apple's framework used by macOS guests on Apple silicon. |
| Provider Version Matrix | Evidence record of host, guest, media, provider, and validation context. |

## Default Safe Habit

When in doubt, classify the result as Yellow, preserve the Provider Version Matrix, redact the evidence, and write down what physical Mac sign-off still needs to prove.
