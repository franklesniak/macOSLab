<!-- markdownlint-disable MD013 -->
# macOSLab Repository Specification

## Metadata

- **Status:** Draft for owner approval
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-05
- **Scope:** Human-readable implementation specification for creating the public `franklesniak/macOSLab` repository from the [`franklesniak/copilot-repo-template`](https://github.com/franklesniak/copilot-repo-template). It defines repository identity, authority hierarchy, safety rules, functional requirements, file layout, PowerShell module contracts, provider contracts, scripts, examples, documentation, tests, CI, phase gates, and definition of done.
- **Related:** [Original prompt](../planning/macOS-imaging-08-repo-spec.md), [Bolstered outline](../planning/macOS-imaging-03a-bolstered-outline.md), [Software runbook](../planning/macos-imaging-05c-recommended-software-step-by-step-revised.md), [Repository description](../planning/macos-imaging-06a-repo-description.md), [CFP submission](../planning/macOS-imaging-01a-CFP-submission.md), [Closed questions archive](../planning/macOS-imaging-08d-closed-questions-archive.md), [Architecture decision records](../planning/macOS-imaging-08e-ADRs.md), [Repository Copilot Instructions](../../.github/copilot-instructions.md), [Documentation Writing Style](../../.github/instructions/docs.instructions.md), [PowerShell Writing Style](../../.github/instructions/powershell.instructions.md)

## 1. Approval Summary

This document describes the repository that should be built later. It is not the repository itself.

The future repository is named `macOSLab` and will be hosted at `franklesniak/macOSLab`. It will be initialized from [`franklesniak/copilot-repo-template`](https://github.com/franklesniak/copilot-repo-template), then extended into a PowerShell 7.4-or-newer starter kit for building reproducible macOS VM labs on Apple-silicon Macs.

The repository has one central promise:

> Help Microsoft endpoint administrators safely test risky macOS Intune policies in a reproducible VM lab before those policies reach real users.

The repository MUST help a user:

1. Install and verify host prerequisites.
2. Pin and acquire macOS restore images or provider-appropriate install artifacts.
3. Create or register macOS VMs through a provider abstraction.
4. Capture and restore named checkpoints.
5. Enroll VMs into Intune for lab-only validation.
6. Validate FileVault, Defender, PPPC/TCC, and compliance signals within documented fidelity limits.
7. Export redacted evidence suitable for demos, change review, and audit-style review.
8. Explain clearly what the VM lab can prove and what still needs physical Mac sign-off.

The repository MUST NOT pretend that macOS VMs replace real hardware validation. It MUST NOT expose secrets, recovery keys, tenant identifiers, credentials, or personal data in logs, screenshots, examples, tests, or evidence bundles.

## 2. Design Posture

This repository is intended to be:

- A clear starter-kit repository, not a full enterprise product.
- PowerShell 7.4-or-newer automation for Apple-silicon macOS hosts.
- Parallels first, UTM second, and Tart optional/stubbed unless owner-approved later.
- Evidence-first and redaction-first.
- VM-first and hardware-last: VMs speed up iteration, but physical Macs remain required for Red-bucket and some Yellow-bucket outcomes.
- Phase-gated so the owner can approve each step before the agent continues.

## 3. Reader Guide

Use this document in three passes:

1. Read Sections 1 through 10 to decide whether this is the right repository to build.
2. Read Sections 11 through 20 to approve the functional surface and implementation contract.
3. Give the entire file to the future coding agent and require them to treat Sections 21 through 25 as the build plan, acceptance criteria, and sign-off mechanism.

If you only have 15 minutes:

1. Read Section 4, "Approval Checklist."
2. Confirm Section 5, "Repository Identity."
3. Read Section 9, "Security and Redaction Requirements."
4. Skim Section 14, "Repository File Map."
5. Read Section 21, "Implementation Phases."
6. Consult the [closed questions archive](../planning/macOS-imaging-08d-closed-questions-archive.md) only if you need historical rationale for a decision.

## 4. Approval Checklist

Before the future agent begins work, the owner SHOULD initial each box that matches expectation. If an item cannot be accepted, strike it through, add a note, or create a new explicit decision item before implementation starts.

### 4.1 Identity and Visibility

- [ ] The repository will be created at [`franklesniak/macOSLab`](https://github.com/franklesniak/macOSLab).
- [ ] The repository will be public.
- [ ] The license will be MIT.
- [ ] The default branch will be `main`.
- [ ] The initial CODEOWNERS value will be `* @franklesniak` unless the owner names additional code owners.

### 4.2 Source of Truth and Standards

- [ ] The new repository will be initialized from [`franklesniak/copilot-repo-template`](https://github.com/franklesniak/copilot-repo-template).
- [ ] The new repository's `.github/copilot-instructions.md` will be its canonical constitution.
- [ ] PowerShell coding standards will be inherited from the template and the referenced PowerShell style guide.
- [ ] The future agent is not authorized to modify protected instruction files unless that exact instruction-file change is explicitly authorized in the current task.

### 4.3 Scope and Posture

- [ ] The repository is a starter kit/scaffold, not a finished enterprise product.
- [ ] The repository is VM-first, hardware-last: it does not promise to validate ADE/ABM zero-touch enrollment, Platform SSO sign-in/unlock, Touch ID, Secure Enclave-dependent behavior, or final FileVault rollout.
- [ ] The supported host is Apple silicon running macOS. Intel Mac hosts are out of scope.
- [ ] The primary hypervisor is Parallels Desktop Pro Edition.
- [ ] The secondary hypervisor is UTM.
- [ ] Tart is optional and may ship as a documented stub provider in v1.
- [ ] The orchestration language is PowerShell 7.4 or newer. PowerShell 5.1 compatibility is not a goal.

### 4.4 Security and Redaction

- [ ] No real tenant identifiers, UPNs, device IDs, serial numbers, recovery keys, tokens, app secrets, or personally identifying data may appear in any committed artifact.
- [ ] All evidence output must pass through `Protect-MacLabEvidence` before being written to disk.
- [ ] No demo path may instruct the user to display a raw FileVault recovery key on a projector or commit one to the repository.
- [ ] No secret-management service, telemetry service, or external logging service may be added without explicit owner approval.

### 4.5 Module Surface

- [ ] The PowerShell module is named `MacLab`.
- [ ] The public cmdlets are exactly the ten cmdlets listed in Section 16.
- [ ] The redaction helper is `Protect-MacLabEvidence`; `Redact-MacLabEvidence` must not be introduced.
- [ ] Media acquisition uses `-Source Mist`; `-Provider` is reserved for hypervisors.
- [ ] The five-checkpoint vocabulary is `Clean-OS`, `Pre-Enroll`, `Post-Enroll-Baseline`, `Broken-Policy-State`, and `Recovered-Known-Good`.

### 4.6 Phasing and Gates

- [ ] The build is delivered in phases.
- [ ] Phase gates are implementation checkpoints. The agent should continue through locally implementable, non-destructive phases and pause at the owner-validation boundary described in Section 21 instead of stopping for owner approval after every phase.
- [ ] The owner accepts that v1 may ship without full Tart, ADE, Log Analytics, or ConfigMgr inventory adapters if those phases are deferred.
- [ ] The owner accepts that the agent will open `open-question` issues rather than guess when requirements are ambiguous.

## 5. Repository Identity

| Field | Value |
| --- | --- |
| Repository slug | `macOSLab` |
| Owner / GitHub user | `franklesniak` |
| Canonical URL | [`franklesniak/macOSLab`](https://github.com/franklesniak/macOSLab) |
| Visibility | Public |
| Default branch | `main` |
| License | MIT, with copyright line `Copyright (c) 2026 Frank Lesniak` |
| GitHub description | `Reproducible Apple-silicon macOS VM lab starter kit, automated with PowerShell 7.4+. Pin macOS media, build snapshots in Parallels or UTM, enroll into Intune, validate FileVault/Defender/PPPC, fail safely, roll back, and export redacted evidence.` |
| GitHub topics | `macos`, `apple-silicon`, `intune`, `powershell`, `pwsh`, `parallels-desktop`, `utm`, `vm-lab`, `policy-testing`, `filevault`, `defender-for-endpoint`, `pppc`, `tcc`, `mdm`, `microsoft-graph`, `pester`, `endpoint-management`, `change-management`, `rollback`, `evidence` |
| Initial release tag | `v0.1.0-mmsmoa-preview`, cut after Phase 9 with owner approval |

### 5.1 Companion Identifiers

| Field | Value |
| --- | --- |
| PowerShell module name | `MacLab` |
| Module manifest path | `src/Modules/MacLab/MacLab.psd1` |
| Module loader path | `src/Modules/MacLab/MacLab.psm1` |
| Module GUID | `4d6748ba-859d-4171-9785-889eaabdb048` |
| Initial module version | `0.1.0` |
| PowerShell floor | PowerShell `7.4` minimum; support newer PowerShell 7.x releases unless a concrete incompatibility is documented. |
| Pester dependency | Pester `5.7.1` pinned in CI for the initial implementation. |
| Microsoft Graph dependency | Individual submodules only: `Microsoft.Graph.Authentication`, `Microsoft.Graph.DeviceManagement`, and optionally `Microsoft.Graph.Beta.DeviceManagement` for FileVault escrow proof. Do not require the `Microsoft.Graph` meta-module by default. |

### 5.2 Reserved Names Not Introduced in v1

The following names are reserved or forbidden to prevent drift:

- `Redact-MacLabEvidence`: forbidden because `Redact` is not an approved PowerShell verb.
- `Get-MacLabMedia -Provider Mist`: forbidden because `-Provider` is for hypervisors.
- "Three required snapshots" or any synonym implying fewer than five canonical checkpoints.
- `MacLabPro`, `MacLabStarterKit`, or any other v1 repo-name variant.

## 6. Authority Hierarchy

The future coding agent MUST resolve conflicts in this order, top wins:

1. The new repository's `.github/copilot-instructions.md`.
2. The new repository's modular instruction files under `.github/instructions/`.
3. The new repository's root agent instruction files: `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md`.
4. This specification.
5. The bolstered outline and the software runbook.
6. External vendor documentation, when a current command, API, license, or behavior must be verified.

If the new repository's instructions differ from the planning repository's instructions, the new repository's instructions win for code that lives in the new repository.

### 6.1 Protected Files

The agent MUST NOT create, edit, delete, rename, or otherwise change these protected files in the new repository unless the owner explicitly authorizes that exact instruction-file change in the current task:

- `.github/copilot-instructions.md`
- Anything under `.github/instructions/`
- `AGENTS.md`
- `CLAUDE.md`
- `GEMINI.md`

Implied consent is insufficient. A general instruction such as "fix anything that fails CI" or "update docs as needed" MUST NOT be interpreted as authorization to modify protected files. If the agent identifies a warranted protected-file change, it MUST open an issue or add a new explicit decision item and wait.

## 7. Background Context

This specification is intended to be self-contained. The future coding agent MAY use these planning files as background context when a requirement needs more narrative detail:

| Source | What it contributes |
| --- | --- |
| `2026/MMSMOA/macOS-imaging-08-repo-spec.md` | Primary prompt, MVP feature list, validation guardrails, and selected repo name. |
| `2026/MMSMOA/macOS-imaging-03a-bolstered-outline.md` | Session contract, audience model, demo flow, fidelity boundaries, and stage runbook. |
| `2026/MMSMOA/macos-imaging-05c-recommended-software-step-by-step-revised.md` | Host setup sequence, software acquisition, Graph module guidance, and starter-kit verification expectations. |
| `2026/MMSMOA/macos-imaging-06a-repo-description.md` | Repository prose description and implementation posture. |
| `2026/MMSMOA/macOS-imaging-01a-CFP-submission.md` | Accepted abstract and attendee takeaways. |
| `2026/MMSMOA/macOS-imaging-08d-closed-questions-archive.md` | Historical archive of owner decisions and implementation uncertainties that have been closed. |

If background files disagree with this specification, this specification controls repository implementation details unless the owner approves a later replacement.

## 8. Product Boundaries

### 8.1 In Scope

- Apple-silicon host Macs.
- macOS guest VMs.
- PowerShell 7.4 or newer as the automation layer.
- Parallels Desktop Pro Edition as the primary provider.
- UTM as a secondary documented/manual provider-swap path with partial lifecycle automation, not full live Parallels parity in v1.
- Tart as an optional advanced CLI/CI path, stubbed in v1 unless explicitly approved.
- `mist-cli`-based media discovery and acquisition.
- Intune enrollment and validation workflows for lab-only devices and lab-only users.
- FileVault, Defender for Endpoint, PPPC/TCC, compliance, and Conditional Access timing guidance.
- Redacted evidence export.
- Pester tests and GitHub Actions validation.
- Human-readable documentation for Windows-first Microsoft endpoint administrators.

### 8.1.1 macOS Guest Version Support

The repository MUST use an Apple-supported-macOS policy rather than hardcoding support to one demo build.

For initial implementation and rehearsal, the support matrix is:

| Purpose | macOS major version | Initial version target | Notes |
| --- | --- | --- | --- |
| Live MMSMOA demo path | macOS Tahoe 26.x | `26.4.1` | Primary demo VM version when the host is also macOS 26.x. |
| Compatibility target | macOS Sequoia 15.x | `15.7.5` | Compatibility target for users whose host/provider preflight confirms this pairing. |
| Compatibility target | macOS Sonoma 14.x | `14.8.5` | Compatibility target for users whose host/provider preflight confirms this pairing. |

Future updates SHOULD track the macOS versions Apple currently supports with security updates. The implementation MUST record exact host macOS, guest macOS, and build numbers in the Provider Version Matrix rather than relying on marketing version names alone.

For the owner/demo path, the already-downloaded macOS Tahoe 26.4.1 IPSW MUST be reused from `~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw`. This is the expected v1 MMS conference demo path, so no move is required while the file remains there. Demo scripts and runbooks MUST verify SHA-256 `8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32` before use and MUST NOT start a new `mist download` operation unless the owner explicitly approves a new download in the current task. This requirement applies to the completed repository's demo scripts, including `scripts/Invoke-MMSDemo.ps1` and `examples/MMSMOA-2026/Demo1-Media.ps1`, not only to planning or validation commands. If the IPSW must be moved for a demo, the runbook MUST instruct the owner to copy or move the existing file and re-run checksum verification.

For macOS guests on Apple-silicon hosts, the implementation MUST treat host/guest compatibility as a provider preflight gate, not as a static version table. The default supported path is a macOS guest whose major version matches the host's macOS major version. Cross-major guests MAY be documented as compatibility targets only when provider documentation or owner-supplied preflight evidence confirms they work on the specific host/provider combination. A guest macOS major version greater than the host macOS major version MUST be rejected by default or require an explicit owner-approved override because current Parallels guidance warns that this may not run reliably.

### 8.2 Out of Scope

- Intel Mac host support.
- Windows-host support.
- Production Mac fleet management.
- A replacement for Intune, ConfigMgr, Jamf, Munki, AutoPkg, or any patch/app deployment platform.
- A complete macOS management curriculum.
- Legal advice about Apple licensing, vendor licensing, or enterprise procurement.
- A guarantee that every Apple hardware or security-model behavior can be tested in a VM.
- Full ADE/ABM zero-touch validation in a VM.
- Platform SSO sign-in/unlock validation.
- Touch ID and Secure Enclave-dependent validation.
- Code signing or notarization of the module.
- Publishing the module to PowerShell Gallery.
- Telemetry, anonymous usage reporting, automatic crash submission, or external logging by default.
- A GUI, Electron app, or web front end.
- Full ConfigMgr inventory bridge implementation.
- Full Log Analytics ingestion pipeline implementation.
- Live Conditional Access blocks as a demo dependency.
- macOS upgrade automation, Time Machine integration, or iCloud sign-in flows.
- Multi-user or multi-host lab orchestration.
- Storing or publishing real tenant data, device identifiers, recovery keys, tokens, secrets, or personal data.

## 9. Security and Redaction Requirements

This section is non-negotiable. If another section conflicts with this section, this section wins.

### 9.1 Hard Prohibitions

The following MUST NEVER appear in any committed artifact, including source code, docs, examples, screenshots, recordings, JSON fixtures, log captures, evidence bundles, tests, README content, or issue templates:

- A real or example FileVault personal recovery key value.
- A real or example Apple ID, Apple Push Certificates Portal credential, or APNs certificate value.
- A real or example Microsoft Entra tenant ID, tenant domain, application/client ID, client secret, certificate thumbprint, or refresh token.
- A real or example Microsoft Graph access token, Defender API token, or Intune API token.
- A real or example device identifier, including Intune device ID, Entra device ID, Defender machine ID, or hardware serial number.
- A real user UPN, email address, full name, employee number, or other identifier that points at a specific human.
- A production tenant name or production policy name.
- Any private key in any encoding.
- The contents of `.env`, `.envrc`, or similar credential-bearing files.

### 9.2 Allowed Placeholder Values

When code, docs, fixtures, or examples need placeholders, use these patterns:

| Concept | Allowed placeholder pattern | Example |
| --- | --- | --- |
| Tenant ID | `00000000-0000-0000-0000-000000000000` | `tenantId: 00000000-0000-0000-0000-000000000000` |
| Tenant domain | `<lab>.onmicrosoft.example` | `tenant: contoso-lab.onmicrosoft.example` |
| User UPN | `lab.user@<lab>.onmicrosoft.example` | `lab.user@contoso-lab.onmicrosoft.example` |
| Device name | `MMS-MACLAB-001` | `MMS-MACLAB-001` |
| Intune device ID | `00000000-0000-0000-0000-000000000001` | `00000000-0000-0000-0000-000000000001` |
| App/client ID | `00000000-0000-0000-0000-00000000ABCD` | `00000000-0000-0000-0000-00000000ABCD` |
| FileVault recovery key | `***REDACTED***` | `recoveryKey: ***REDACTED***` |
| Token/secret | `***REDACTED***` | `accessToken: ***REDACTED***` |
| Hardware serial | `LAB000000001` | `LAB000000001` |
| MAC address | `02:00:00:00:00:01` | `02:00:00:00:00:01` |
| macOS version | `<macOS-version>` until pinned for rehearsal | `<macOS-version>` |
| macOS build | `<macOS-build>` until pinned for rehearsal | `<macOS-build>` |

The repo MUST NOT ship any real value masked behind a redacted placeholder. If a real value was ever placed in a file, the file is not safe to commit because the value may exist in local history or tool caches.

### 9.3 Redaction Helper Contract

The redaction helper is `Protect-MacLabEvidence` and lives at `src/Modules/MacLab/Private/Protect-MacLabEvidence.ps1`.

Requirements:

- All evidence written by the module to disk MUST flow through `Protect-MacLabEvidence`.
- The helper accepts an in-memory evidence object plus optional additional sensitive field names.
- The helper MUST return a redacted clone and MUST NOT mutate the input object in place.
- The helper MUST walk nested objects recursively.
- The helper MUST replace sensitive values with the literal string `***REDACTED***`.
- The helper MUST stamp the clone with `redactionApplied: true` and `redactionVersion: <semver>`.

The sensitive field-name match list MUST include, at minimum:

- `recoveryKey`
- `personalRecoveryKey`
- `bitLockerRecoveryKey`
- `accessToken`
- `refreshToken`
- `idToken`
- `clientSecret`
- `apiKey`
- `password`
- `secret`
- `bearer`
- `authorization`
- `serial`
- `serialNumber`
- `tenantId`
- `deviceId`
- `objectId`
- `mail`
- `userPrincipalName`
- `accountName`
- `phoneNumber`
- `imei`
- `meid`
- `wifiPassword`

The helper MUST also redact:

- Recovery-key-shaped strings, even when the field name looks harmless.
- JWT-shaped strings beginning with `eyJ` and containing base64url segments separated by periods.
- Caller-specified additional sensitive fields.

For strings longer than 200 characters that appear high entropy, the helper SHOULD emit a `Write-Warning` advising review. That warning is a backstop, not the primary redaction mechanism.

### 9.4 Demo Safety Rules

Examples and docs MUST:

1. Never instruct the user to display a raw recovery key on a projector.
2. Show FileVault escrow as existence and retrieval-path proof, with the value redacted before persistence.
3. Avoid committed screenshots in v1.
4. Use realistic but synthetic output for `mdatp health`, `fdesetup status`, and `log show`.
5. Avoid transcripts unless a transcript is generated locally and reviewed for secrets before sharing.

### 9.5 Secret Scanning and Ignore Rules

- The agent MUST NOT disable GitHub secret scanning or push protection.
- The repository MUST NOT commit `.env`, `.envrc`, `*.pem`, `*.p12`, `*.pfx`, `*.key`, `id_rsa*`, `*.token`, `.app`, `.ipsw`, `.iso`, `.dmg`, binary `.utm` bundles, screenshots, or recordings.
- The template `.gitignore` SHOULD be preserved and extended only when needed for this project.

### 9.6 Root Phase TODO Files

The future repository MUST use root-level per-phase TODO files for deferred work, current-tool verification, and owner follow-up items that are easy to forget. This is intentional: the owner wants these TODOs in the repository root where they are visible before implementation or rehearsal.

Rules:

- File naming pattern: `TODO-Phase-<NN>-<Short-Name>.md`, for example `TODO-Phase-04-Media-Acquisition.md`.
- Create a TODO file only when that phase has unresolved or deferred work. Omit the file when there are no phase TODOs.
- Each TODO file MUST include enough context for a future reader who does not remember the planning conversation.
- Each TODO item MUST include owner, why it matters, phase gate affected, exact action, acceptance condition, source/link if applicable, and status.
- README MUST link to any root TODO files that exist.
- Phase completion summaries MUST state whether the matching root TODO file is empty, closed, or still has deferred items.

Known root TODO files required by this specification:

| File | Required initial content |
| --- | --- |
| `TODO-Phase-00-Branch-Protection.md` | Configure branch protection or a ruleset for `main` after the implementation is complete and the final required checks are known. |
| `TODO-Phase-04-Media-Acquisition.md` | Verify current `mist-cli` list/download syntax and record exact commands before implementing `Get-MacLabMedia`. |
| `TODO-Phase-05-Parallels-Provider.md` | Verify current `prlctl` syntax, version output, and edition detection on the owner/demo host. |
| `TODO-Phase-06-UTM-Provider.md` | Verify current UTM/`utmctl` automation surface and document any manual-step-required gaps. |
| `TODO-Phase-07-Evidence-Pipeline.md` | Replace the temporary worked-example schema with the real evidence-bundle schema and capture evidence-model implications from sanitized preflight data. |
| `TODO-Phase-08-Validation-Loop.md` | Verify current Defender `mdatp health` output shape and sanitize fixtures before evidence tests. |
| `TODO-Phase-10-Deferred-Work.md` | Explain every deferred Phase 10 item, why it was deferred, what would be needed to resume it, and how to validate it safely. Include any future screenshot/recording follow-up if the owner later authorizes checked-in visual artifacts. |

## 10. VM Fidelity Traffic Light

This is the honesty boundary for the talk and the repository.

### 10.0 Apple Virtualization and Licensing Boundary

The repository documentation MUST include current public Apple license links and MUST avoid giving legal advice.

For initial documentation, use the macOS Tahoe software license agreement as the primary Apple source: [macOS Tahoe SLA](https://www.apple.com/legal/sla/docs/macOSTahoe.pdf). The docs may summarize the practical lab boundary this way:

- The lab is designed for Apple-branded computers running macOS.
- The Apple license language allows limited additional macOS virtual instances on Apple-branded computers for specific uses such as software development, testing during software development, macOS Server, or personal non-commercial use.
- The repo's default posture is "two concurrent macOS guests per Apple-branded host unless the owner verifies a different license posture."
- The repo MUST NOT claim to provide legal advice or replace the user's vendor/procurement review.

This boundary belongs in `docs/Apple-Silicon-Constraints.md`, `docs/Hypervisor-Decision-Guide.md`, and `docs/CI-and-Tart.md`.

The repository documentation MUST also explain the Apple Virtualization framework compatibility boundary for macOS guests on Apple silicon:

- Current [Parallels CLI documentation](https://docs.parallels.com/landing/parallels-desktop-developers-guide/command-line-interface-utility/manage-virtual-machines-from-cli/general-virtual-machine-management/create-a-virtual-machine) states that, on Apple silicon, the only guaranteed macOS VM compatibility scenario is a guest with the same macOS major version as the host.
- Current [Parallels macOS Arm VM limitations](https://kb.parallels.com/en/128867) state that Parallels macOS Arm VMs are built on Apple's Virtualization framework and that running a macOS VM with a version higher than the host may not be possible.
- Current [UTM macOS guest documentation](https://docs.getutm.app/guest-support/macos/) describes macOS guests on Apple silicon as Apple Virtualization-backed and recommends the most compatible IPSW. Current [UTM Apple backend documentation](https://docs.getutm.app/settings-apple/settings-apple/) states that Apple Virtualization is the only way UTM runs virtualized macOS on Apple silicon.
- Current [Tart documentation](https://tart.run/) describes Tart as using Apple's native Virtualization.Framework.

This compatibility boundary applies to Parallels, UTM when running macOS guests on Apple Virtualization, and any later Tart macOS-guest implementation. It does not automatically apply to non-macOS guests or to UTM/QEMU emulation paths that are outside this repository's macOS VM scope.

| Color | Meaning | Examples |
| --- | --- | --- |
| Green | The VM lab is sufficient evidence on its own. | Script syntax, package install behavior, Intune assignment logic, profile receipt, basic PPPC payload behavior, Defender health checks, rollback routines, evidence export. |
| Yellow | VM is good for iteration, but physical hardware sign-off is still required. | FileVault rollout behavior, recovery-key process end to end, compliance experience under realistic timing, user prompts, UI flows, performance-sensitive Defender behavior. |
| Red | The VM cannot validate this; physical hardware or production-like enrollment is required. | ADE/ABM zero-touch enrollment, serial-number-dependent workflows, Platform SSO sign-in/unlock, Touch ID, Secure Enclave-dependent behavior, final executive pilot sign-off. |

### 10.1 Cmdlet Honesty Rules

- Evidence-producing cmdlets MUST stamp evidence with the fidelity color of the test.
- Yellow evidence MUST include `hardwareSignoffRequired: true` when physical hardware remains required.
- A test plan that asserts a Red-bucket outcome MUST be rejected at parse time by `Invoke-MacPolicyValidation`.
- Documentation MUST NOT claim the lab validates or proves Red-bucket outcomes.

### 10.2 Cloud-State Rollback Warning

This sentence, or a stable equivalent, MUST appear in every restore warning and evidence record:

> VM rollback does not rewind Intune, Entra, Defender portal state, audit logs, or reporting history.

Every cmdlet or script that restores a VM checkpoint MUST emit a runtime warning containing that statement. The docs MUST repeat it in the snapshot, Intune, and demo runbook sections.

## 11. Requirements

Each requirement is normative and testable. Later sections define the implementation contracts that satisfy these requirements.

### MLAB-REQ-001: Template Initialization

The repository MUST be initialized from [`franklesniak/copilot-repo-template`](https://github.com/franklesniak/copilot-repo-template).

**Rationale:** The template supplies coding-agent instructions, CI conventions, issue templates, pre-commit configuration, and baseline repo hygiene.

**Acceptance Criteria:**

- Template governance files remain intact unless this spec explicitly authorizes a narrow change.
- Protected instruction files are not weakened.
- Project-specific docs and source files are added without deleting template governance.

**Verification:** Review the initial commit diff and run the template's configured checks.

### MLAB-REQ-002: Repository and Module Names

The GitHub repository MUST be named `macOSLab`. The PowerShell module MUST be named `MacLab`.

**Acceptance Criteria:**

- Repo references use `franklesniak/macOSLab`.
- The module manifest is `src/Modules/MacLab/MacLab.psd1`.
- The module root file is `src/Modules/MacLab/MacLab.psm1`.
- Exported commands use the intended `MacLab` nouns.

**Verification:** Import the module locally and confirm exported commands with `Get-Command -Module MacLab`.

### MLAB-REQ-003: PowerShell 7.4 Baseline

The repository MUST target PowerShell 7.4 or newer on macOS as the primary runtime.

**Acceptance Criteria:**

- Scripts declare or document the supported PowerShell version.
- macOS-only scripts check that they are running on macOS.
- PowerShell follows the inherited style guide.
- No Windows PowerShell-only assumptions are introduced.

**Verification:** Run PSScriptAnalyzer and Pester in PowerShell 7.4 or newer.

### MLAB-REQ-004: Provider Abstraction

The `MacLab` module MUST expose one user-facing automation model over multiple VM providers.

**Acceptance Criteria:**

- Provider values are `Parallels`, `UTM`, and `Tart`.
- Parallels is implemented as the primary working path.
- UTM is implemented as a clearly documented/manual provider-swap path with partial lifecycle automation in v1.
- Tart is optional and explicitly marked advanced or stubbed.
- Unsupported provider capabilities return a clear warning or terminating error.

**Verification:** Provider tests cover capability discovery, supported calls, and unsupported calls.

### MLAB-REQ-005: Reproducible Media Acquisition

The repository MUST treat macOS media pinning as a first-class workflow.

**Acceptance Criteria:**

- Media acquisition uses `mist-cli` as the default source.
- The public surface uses `Get-MacLabMedia -Source Mist`.
- `-Provider` is reserved for hypervisor selection.
- Firmware/IPSW restore images are the default Apple-silicon VM media path; compatible installer rows are advisory metadata unless a provider workflow explicitly requires an installer artifact.
- Media metadata records version, build, artifact path, source, acquisition time, and checksum where practical.
- Owner/demo scripts support a prepared-media path and MUST reuse the verified existing IPSW when present instead of starting a new download.
- Docs use "restore image or provider-appropriate install artifact" instead of treating ISO as the Apple-silicon default.

**Verification:** Unit tests validate metadata shape and parameter behavior. A manual live validation confirms a pinned artifact can be discovered and cached.

### MLAB-REQ-006: Five-Checkpoint Snapshot Model

The repository MUST encode the five named checkpoints used by the talk.

**Acceptance Criteria:**

- Supported checkpoint names are `Clean-OS`, `Pre-Enroll`, `Post-Enroll-Baseline`, `Broken-Policy-State`, and `Recovered-Known-Good`.
- Docs explain when to use each checkpoint.
- Restore workflows warn when cloud state may no longer match the restored VM.
- A readiness workflow verifies required checkpoints before rehearsal.

**Verification:** Pester tests validate accepted checkpoint names and warning behavior.

### MLAB-REQ-007: Intune Lab Scope

The repository MUST assume lab-only Intune devices, users, and groups.

**Acceptance Criteria:**

- Documentation tells users to create lab-only users, groups, and assignments.
- Example config values use lab-only names.
- Any Graph helper that finds devices requires explicit scope filters or confirmation before acting on cloud objects.
- Cleanup workflows are documented before destructive cloud-side actions are implemented.

**Verification:** Tests verify filters or confirmations are required for cleanup routines. Docs review confirms no production assignment examples are present.

### MLAB-REQ-008: FileVault Validation

The repository MUST include a FileVault validation model that proves policy receipt and escrow evidence without exposing recovery keys.

**Acceptance Criteria:**

- Docs define the minimum FileVault proof path.
- Validation captures local `fdesetup status`.
- Validation captures escrow existence or retrieval-path evidence.
- Raw recovery key values are redacted before persistence.
- Docs clearly separate escrow preparation from encryption state.
- Docs say which FileVault results require physical Mac sign-off.

**Verification:** Pester tests prove the redaction helper masks recovery-key-shaped values and evidence export marks redaction as applied.

### MLAB-REQ-009: Defender Validation

The repository MUST validate Defender for Endpoint on macOS as more than an app install.

**Acceptance Criteria:**

- Docs and examples include package install, system extension approval, network extension approval when used, Full Disk Access/PPPC delivery, onboarding, and `mdatp health`.
- Defender docs include step-by-step Intune setup for macOS Defender deployment because the owner/demo tenant does not currently have that deployment configured.
- The default demo path deploys Defender through Intune after enrollment; a preinstalled-Defender fallback may exist only for rehearsal or live-cloud timing backup and must be labeled as a fallback.
- Evidence records Defender version and health output after redaction.
- Provider rollback result is included in the evidence model.

**Verification:** Tests validate expected evidence fields. Manual demo validation captures `mdatp health` in a redacted evidence bundle.

### MLAB-REQ-010: PPPC/TCC Validation

The repository MUST explain PPPC/TCC validation as a precision problem.

**Acceptance Criteria:**

- Docs explain bundle ID, code requirement, app path, profile receipt, app behavior, and log evidence.
- Examples do not rely only on System Settings screenshots.
- Evidence can include profile receipt and targeted behavior checks.

**Verification:** Docs review and example test-case review.

### MLAB-REQ-011: Evidence as a First-Class Output

Every meaningful validation run MUST produce structured evidence.

**Acceptance Criteria:**

- Evidence is JSON by default.
- The evidence schema uses normalized parsed facts as the durable contract and may include redacted or synthetic command-output attachments when those attachments help explain the run.
- Evidence includes run ID, provider, provider version, host macOS version, guest macOS version/build, snapshot, Intune device name or redacted ID, test results, cloud-state warning, fidelity, hardware sign-off flag, and redaction status.
- Evidence export creates a predictable folder structure.
- Evidence export fails closed when redaction cannot be applied to sensitive fields.

**Verification:** Pester tests validate evidence schema and redaction-required behavior.

### MLAB-REQ-012: Readiness Gate

The repository MUST include `scripts/Test-LabReadiness.ps1` as the canonical T-15 readiness gate.

**Acceptance Criteria:**

- The script checks host tools, provider tools, PowerShell modules, configured paths, detectable permissions, media cache, required checkpoints, and optional network/cloud reachability.
- Required checks fail the run.
- Optional checks are reported as warnings or skipped checks with reasons.
- Output is terminal-readable and exportable as evidence.

**Verification:** Pester tests cover pass, fail, warn, and skipped cases.

### MLAB-REQ-013: Documentation-First Handoff

The repository MUST be useful to an attendee who starts at `docs/Start-Here.md`.

**Acceptance Criteria:**

- `docs/Start-Here.md` gives the first command, first validation target, and first expected evidence artifact.
- README gives the same starting path at a higher level.
- Docs are written for Windows-first Microsoft endpoint administrators.
- Docs include examples, expected outputs, and failure/ambiguous-input behavior where appropriate.

**Verification:** Manual docs review from a fresh-reader perspective.

### MLAB-REQ-014: Tests and CI

The repository MUST include Pester tests and GitHub Actions validation.

**Acceptance Criteria:**

- Tests use Pester 5.x syntax; CI initially pins Pester `5.7.1`.
- Tests are located under `tests/`.
- GitHub Actions runs Pester and PowerShell linting.
- Markdown linting runs through the template's existing tooling.
- Default tests avoid requiring real Parallels, UTM, Graph, Defender, or a real macOS VM.

**Verification:** CI passes on a clean clone without secrets.

### MLAB-REQ-015: No Stage Reliance on Live Cloud Timing

The repository MUST support live, checkpoint, screenshot, and screen-recording fallback paths for cloud-dependent demos.

**Acceptance Criteria:**

- Demo docs include live path, checkpoint path, screenshot path, screen-recording path, and pivot sentence.
- Demo scripts can run against prepared state.
- Evidence examples can be generated from fixture data for documentation and rehearsal.

**Verification:** Demo runbook review and fixture-based evidence tests.

## 12. Initialization From the Template

The repository MUST be created from [`franklesniak/copilot-repo-template`](https://github.com/franklesniak/copilot-repo-template). The agent SHOULD use GitHub's template flow or an equivalent `gh repo create --template` flow, then clone the new templated repository locally.

Before Phase 0 begins, the owner will create or provide a template initialization implementation-steps guide. The future coding agent MUST use that guide as the concrete Phase 0 checklist, while still following this specification and the new repository's protected instruction files.

### 12.1 Keep From the Template

The agent MUST keep template governance files unless this spec explicitly says otherwise. At minimum, preserve:

- `.github/copilot-instructions.md`
- `.github/instructions/`
- `.github/linting/PSScriptAnalyzerSettings.psd1`
- `.github/workflows/auto-fix-precommit.yml`
- `.github/dependabot.yml`
- `.github/ISSUE_TEMPLATE/`
- `.github/pull_request_template.md`
- `.github/scripts/lint-nested-markdown.js`
- `.gitattributes`
- `.gitignore`
- `.markdownlint.jsonc`
- `.pre-commit-config.yaml`
- `AGENTS.md`
- `CLAUDE.md`
- `GEMINI.md`
- `CONTRIBUTING.md`
- `SECURITY.md`

If the template has additional governance files not listed here, preserve them unless the owner authorizes removal.

`SECURITY.md` remains unchanged by default. The implementation agent MUST NOT rewrite it or replace the template's responsible-disclosure process. During Phase 1, after the inherited template file is visible, the agent may propose only this exact project-specific paragraph if it is compatible with the inherited file:

> This repository ships no real tenant identifiers, no recovery keys, no tokens, and no production credentials. If you discover content that appears to be a real secret, recovery key, tenant identifier, or personal data, please report it privately through the repository's security advisory process rather than opening a public issue.

No other `SECURITY.md` customization is approved by this specification.

### 12.2 Phase 0 Customizations

During Phase 0, the agent MUST make only identity/bootstrap changes:

| Path | Required customization |
| --- | --- |
| `LICENSE` | Set the copyright line to `Copyright (c) 2026 Frank Lesniak`; leave MIT license body untouched. |
| `README.md` | Replace the template README with a minimal Phase 0 `macOSLab` README. Full content lands in Phase 1. |
| `.github/CODEOWNERS` | Confirm it contains `* @franklesniak`, unless the owner names additional launch code owners. |
| `package.json` | Set repository identity fields for `macOSLab`; keep markdownlint scripts from the template; keep `"private": true`. |
| `package-lock.json` | Regenerate after `package.json` edits. |

The agent MAY remove template sample artifacts for languages this repo does not use, such as Python sample source/tests, only if removal does not break validation. If unsure, record a new explicit decision item before removing them.

### 12.3 Phase 0 Acceptance

Phase 0 is complete only when:

1. The customizations in Section 12.2 are committed.
2. `pre-commit run --all-files` passes locally.
3. `npm run lint:md` passes.
4. `npm run lint:md:nested` passes if that script exists.
5. GitHub Actions is green for the most recent commit.
6. The repo is publicly visible at [`franklesniak/macOSLab`](https://github.com/franklesniak/macOSLab).
7. No protected instruction file was modified.
8. The agent has posted a Phase 0 summary and stopped for owner approval.

## 13. Coding Standards

The repository inherits coding standards from the template. The agent MUST NOT fork those standards into new custom style guides.

### 13.1 PowerShell

- All PowerShell is Modern style: PowerShell 7.4 or newer, `[CmdletBinding()]`, `[OutputType()]`, structured error handling, streaming output, and comment-based help.
- Public identifiers use PascalCase.
- Local variables use the inherited style guide's typed-prefix camelCase convention.
- Approved verbs only. PSScriptAnalyzer `PSUseApprovedVerbs` must report zero findings.
- No aliases in code.
- Use 4-space indentation, OTBS braces, UTF-8 without BOM, no trailing whitespace, and no vertical alignment.
- Use `try`/`catch`; empty `catch` blocks are forbidden.
- Use `$PSCmdlet.ThrowTerminatingError()` when wrapping errors.
- Never emit raw PII, credentials, tokens, or recovery keys to any output stream.
- Shared module state, where unavoidable, uses `$script:` scope. Do not mutate `$global:`.
- Path inputs MUST be resolved and constrained before use.

### 13.2 Markdown

- All non-trivial docs include the metadata block required by the inherited docs style.
- Markdown must pass `npm run lint:md` and `npm run lint:md:nested` where available.
- Docs use plain, technical language for Windows-first Microsoft endpoint administrators.
- Docs are honest about VM fidelity boundaries.
- Docs use placeholders from Section 9.2.

### 13.3 Pester

- Tests use Pester 5.x syntax; CI initially pins Pester `5.7.1`.
- Test files end in `.Tests.ps1`.
- Use `BeforeAll`, `Describe`, `Context`, and `It`.
- Follow Arrange-Act-Assert.
- Mock external commands and cloud calls by default.

### 13.4 CI and Pre-Commit

- Run `pre-commit run --all-files` before every commit.
- Commit auto-fixes with the related change.
- Do not skip hooks without explicit owner authorization.
- CI is a safety net, not a substitute for local checks.

## 14. Repository File Map

The project-owned v1 file tree SHOULD match this map. Template-owned files may exist in addition to this map when they are inherited from the template and are not harmful. New project-owned files outside this map require owner approval or a new explicit decision item.

```text
macOSLab/
├── .devcontainer/                              # inherited if present
├── .github/
│   ├── CODEOWNERS                              # customized in Phase 0
│   ├── ISSUE_TEMPLATE/                         # inherited
│   ├── copilot-instructions.md                 # inherited, protected
│   ├── dependabot.yml                          # inherited
│   ├── instructions/                           # inherited, protected
│   │   ├── docs.instructions.md
│   │   └── powershell.instructions.md
│   ├── linting/
│   │   └── PSScriptAnalyzerSettings.psd1
│   ├── pull_request_template.md
│   ├── scripts/
│   │   └── lint-nested-markdown.js
│   └── workflows/
│       ├── auto-fix-precommit.yml
│       └── pester.yml
├── .gitattributes
├── .gitignore
├── .markdownlint.jsonc
├── .pre-commit-config.yaml
├── .vscode/                                    # inherited if present
├── AGENTS.md                                   # inherited, protected
├── CLAUDE.md                                   # inherited, protected
├── CONTRIBUTING.md
├── GEMINI.md                                   # inherited, protected
├── LICENSE
├── README.md
├── SECURITY.md
├── TODO-Phase-00-Branch-Protection.md          # if Phase 0 branch-protection setup remains
├── TODO-Phase-04-Media-Acquisition.md          # if Phase 4 TODOs remain
├── TODO-Phase-05-Parallels-Provider.md         # if Phase 5 TODOs remain
├── TODO-Phase-06-UTM-Provider.md               # if Phase 6 TODOs remain
├── TODO-Phase-07-Evidence-Pipeline.md          # if Phase 7 schema/evidence TODOs remain
├── TODO-Phase-08-Validation-Loop.md            # if Phase 8 TODOs remain
├── TODO-Phase-10-Deferred-Work.md              # if Phase 10 work is deferred
├── docs/
│   ├── Apple-Silicon-Constraints.md
│   ├── CI-and-Tart.md
│   ├── ConfigMgr-Inventory-Bridge.md
│   ├── Defender-Validation.md
│   ├── Demo-Runbook.md
│   ├── Evidence-and-CAB.md
│   ├── Evidence-Redaction.md
│   ├── Fidelity-Boundaries.md
│   ├── FileVault-Validation.md
│   ├── Hypervisor-Decision-Guide.md
│   ├── Intune-Tenant-Setup.md
│   ├── Log-Analytics-Integration.md
│   ├── PPPC-Validation.md
│   ├── Prereqs.md
│   ├── Provider-Version-Matrix.md
│   ├── Snapshot-Strategy.md
│   ├── Start-Here.md
│   ├── Troubleshooting.md
│   └── Windows-Admin-Cheat-Sheet.md
├── examples/
│   ├── MMSMOA-2026/
│   │   ├── demo-config.yml
│   │   ├── Demo1-Media.ps1
│   │   ├── Demo2-Parallels.ps1
│   │   ├── Demo3-UTM.ps1
│   │   └── Demo4-IntuneValidation.ps1
│   ├── TestCases/
│   │   ├── Compliance-SmokeTest.yml
│   │   ├── Defender-Validation.yml
│   │   ├── FileVault-Validation.yml
│   │   └── PPPC-Validation.yml
│   └── utm/
│       └── macos-lab-template.utm.json
├── package-lock.json
├── package.json
├── scripts/
│   ├── Checkpoint-MacVm.ps1
│   ├── Get-MacOSRestoreImage.ps1
│   ├── Install-Prereqs.ps1
│   ├── Invoke-MMSDemo.ps1
│   ├── New-MacInstallArtifact.ps1
│   ├── New-MacVm.ps1
│   ├── Remove-MacVm.ps1
│   ├── Reset-IntuneMacLabDevice.ps1
│   ├── Restore-MacVmCheckpoint.ps1
│   ├── Send-LabEventToLogAnalytics.ps1
│   └── Test-LabReadiness.ps1
├── src/
│   └── Modules/
│       └── MacLab/
│           ├── MacLab.psd1
│           ├── MacLab.psm1
│           ├── Private/
│           │   ├── Invoke-LoggedCommand.ps1
│           │   ├── Protect-MacLabEvidence.ps1
│           │   ├── Resolve-MacLabConfig.ps1
│           │   └── Write-EvidenceRecord.ps1
│           ├── Providers/
│           │   ├── Parallels.ps1
│           │   ├── Tart.ps1
│           │   └── UTM.ps1
│           └── Public/
│               ├── Checkpoint-MacLabVm.ps1
│               ├── Export-MacLabEvidence.ps1
│               ├── Get-MacLabMedia.ps1
│               ├── Get-MacLabVm.ps1
│               ├── Invoke-MacPolicyValidation.ps1
│               ├── New-MacLabVm.ps1
│               ├── Remove-MacLabVm.ps1
│               ├── Restore-MacLabVmCheckpoint.ps1
│               ├── Start-MacLabVm.ps1
│               └── Stop-MacLabVm.ps1
└── tests/
    ├── MacLab.Tests.ps1
    ├── Providers.Parallels.Tests.ps1
    ├── Providers.UTM.Tests.ps1
    ├── Validation.Defender.Tests.ps1
    └── Validation.FileVault.Tests.ps1
```

### 14.1 UTM Template Format

The repository ships `examples/utm/macos-lab-template.utm.json`, not a real `.utm` bundle. A `.utm` bundle is a directory/package that can include binary disk content and MUST NOT be committed. The JSON descriptor records the intended CPU, memory, disk, network, virtualization mode, display, and sharing settings. Docs explain how to reconstruct the actual UTM VM locally.

### 14.2 What Does Not Ship

The repo MUST NOT ship:

- `.app` bundles
- `.ipsw` files
- `.iso` files
- `.dmg` files
- Binary `.utm` bundles
- Screenshots
- Recordings
- Production policy exports
- Graph payloads with real tenant data
- Credential-bearing files
- Vendor SDK redistributables

## 15. Naming Conventions

### 15.1 Module and File Names

- Module name: `MacLab`
- Repo name: `macOSLab`
- Manifest: `src/Modules/MacLab/MacLab.psd1`
- Loader: `src/Modules/MacLab/MacLab.psm1`
- Public cmdlet files: one cmdlet per file under `Public/`.
- Private helper files: one helper per file under `Private/`.
- Provider files: `Parallels.ps1`, `UTM.ps1`, and `Tart.ps1`.

### 15.2 Parameter Names

- `-Provider` is only for hypervisors: `Parallels`, `UTM`, and `Tart`.
- `-Source` is only for media sources. V1 valid value: `Mist`.
- `-OutputPath` is preferred over `-Path` for write destinations.
- Evidence-producing cmdlets include `-RedactSecrets`, defaulting to `$true`. In PowerShell this may be implemented as a switch with default `$true`, so callers can explicitly pass `-RedactSecrets:$false` only for non-public lab paths. Even then, raw recovery keys, tokens, and tenant secrets MUST NOT be written to disk.

### 15.3 Checkpoint Vocabulary

| Canonical name | Meaning |
| --- | --- |
| `Clean-OS` | Freshly installed guest, Setup Assistant complete, no demo software, never enrolled. |
| `Pre-Enroll` | `Clean-OS` plus Intune Company Portal at the sign-in screen; not enrolled. |
| `Post-Enroll-Baseline` | Fully enrolled, recently synced, deterministic healthy baseline. |
| `Broken-Policy-State` | Deterministic intentionally broken state for the engineered demo failure. |
| `Recovered-Known-Good` | Post-rollback healthy state, captured after cloud cleanup/reconciliation. |

Alternative names are not allowed in v1.

## 16. Module Specification

The agent MUST generate one `.ps1` file per public cmdlet under `src/Modules/MacLab/Public/`. Each file contains exactly one function whose name matches the file name. Each public function includes full comment-based help and follows the inherited PowerShell style guide.

### 16.1 Module Manifest

The manifest MUST include at minimum:

```powershell
@{
    RootModule        = 'MacLab.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = '4d6748ba-859d-4171-9785-889eaabdb048'
    Author            = 'Frank Lesniak'
    CompanyName       = 'Frank Lesniak'
    Copyright         = '(c) 2026 Frank Lesniak. MIT License.'
    Description       = 'Reproducible Apple-silicon macOS VM lab for risk-free Intune policy testing. Pin macOS media, build snapshots, enroll, validate FileVault/Defender/PPPC, fail safely, roll back, and export redacted evidence.'
    PowerShellVersion = '7.4'
    CompatiblePSEditions = @('Core')
    FunctionsToExport = @(
        'Get-MacLabMedia',
        'New-MacLabVm',
        'Get-MacLabVm',
        'Start-MacLabVm',
        'Stop-MacLabVm',
        'Checkpoint-MacLabVm',
        'Restore-MacLabVmCheckpoint',
        'Remove-MacLabVm',
        'Invoke-MacPolicyValidation',
        'Export-MacLabEvidence'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
```

Rules:

- The GUID must be generated once and must not remain a placeholder.
- `FunctionsToExport` lists exactly the ten public cmdlets.
- Private helpers and provider functions are never exported.
- `PowerShellVersion` is `7.4`. The repo supports PowerShell 7.4.x and newer PowerShell 7.x releases unless a concrete incompatibility is documented.

### 16.2 Module Loader

`MacLab.psm1` MUST:

1. Set `Set-StrictMode -Version Latest` as the first executable statement.
2. Resolve the module root directory once and store it in `$script:` scope.
3. Dot-source `Private/`, then `Providers/`, then `Public/`.
4. Export only functions listed in the manifest.
5. Avoid `$global:` mutations.
6. Avoid network calls at module-load time.
7. Avoid credential prompts at module-load time.
8. Fail loudly if any provider or function file cannot be loaded.

### 16.3 Public Cmdlet Contracts

All public cmdlets share these rules:

- Use `[CmdletBinding()]`.
- Use typed parameters.
- Declare `[OutputType()]`.
- Stream objects to the pipeline.
- Use `try`/`catch`.
- Avoid secrets in verbose/debug/warning/error output.
- Support `ShouldProcess` when writing to disk, mutating a VM, contacting cloud services, or performing destructive actions.

#### 16.3.1 `Get-MacLabMedia`

**Purpose:** Discover, acquire, cache, and record pinned macOS install artifacts through `mist-cli`.

**Parameters:**

| Name | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `Version` | `string` | Yes | None | macOS marketing version. |
| `Build` | `string` | No | `$null` | Build number. If supplied, build is the stronger match key. |
| `Architecture` | `arm64` validate set | No | `arm64` | V1 supports Apple silicon only. |
| `Source` | `Mist` validate set | No | `Mist` | Media source, not hypervisor. |
| `ArtifactType` | `Installer`, `Firmware`, `Both` | No | `Both` | `.app`, `.ipsw`, or both. |
| `CacheRoot` | `string` | No | `~/Demo/Installers` | Resolved before use. |
| `Force` | `switch` | No | `$false` | Re-download even if cached. |
| `RedactSecrets` | `switch` | No | `$true` | Consistent evidence/logging posture. |

**Output:** Object with `Version`, `Build`, `Architecture`, `Source`, `ArtifactType`, artifact paths, per-artifact SHA-256 values, sizes, `AcquiredAt`, and `MetadataJsonPath`.

**Behavior:**

1. Verify host is macOS.
2. Verify `mist` is available.
3. Resolve and create `CacheRoot`.
4. Use `mist-cli` to list and download the requested artifacts.
5. Verify current `mist-cli` syntax during implementation instead of relying blindly on stale examples.
6. Compute SHA-256 for acquired files.
7. Write a sidecar `metadata.json` under a deterministic cache folder.
8. Stream the metadata object.

#### 16.3.2 `New-MacLabVm`

**Purpose:** Create or register a VM under a selected provider using cached media.

**Parameters:** `Provider`, `Name`, `MediaId`, optional `CacheRoot`, `SizingProfile`, `VmRoot`, `RedactSecrets`.

**Output:** Object with provider, name, media ID, sizing profile, state, config path, creation time, and provider version.

**Behavior:**

1. Validate VM name with a cross-provider-safe regex.
2. Load media metadata from cache.
3. Dispatch to the chosen provider.
4. Create/register but do not start the VM.
5. Stream the provider result.

**ShouldProcess:** Yes, `ConfirmImpact = 'Medium'`.

#### 16.3.3 `Get-MacLabVm`

**Purpose:** List or describe lab VMs.

**Parameters:** Optional `Provider`, optional `Name`.

**Output:** One object per VM with provider, name, state, media ID, sizing profile, CPU, memory, disk, MAC address, last seen time, snapshots, capabilities, and provider version where available.

**Behavior:** If no provider is supplied, query installed providers and skip missing providers without error.

#### 16.3.4 `Start-MacLabVm`

**Purpose:** Start a lab VM.

**Parameters:** `Provider`, `Name`, optional `WaitForReady`.

**Output:** VM state object.

**Behavior:** Dispatch to provider. Warn if network/cloud readiness has not been run recently when the next workflow depends on APNs, Intune, Graph, or Defender.

**ShouldProcess:** Yes, `ConfirmImpact = 'Low'`.

#### 16.3.5 `Stop-MacLabVm`

**Purpose:** Stop a lab VM.

**Parameters:** `Provider`, `Name`, optional `Force`.

**Output:** VM state object.

**Behavior:** Clean shutdown by default. Force powers off. Warn that snapshotting a running or paused VM increases MDM identity-drift risk.

**ShouldProcess:** Yes, `ConfirmImpact = 'Medium'`.

#### 16.3.6 `Checkpoint-MacLabVm`

**Purpose:** Capture a named checkpoint.

**Parameters:** `Provider`, `Name`, `CheckpointName`, optional `AllowNonCanonicalCheckpoint`, `Description`, and `RequireCleanShutdown`.

**Output:** Checkpoint object with provider, VM name, checkpoint name, parent checkpoint if known, created-at timestamp, description, and canonical-name flag.

**Behavior:**

1. Require one of the five canonical checkpoint names unless `AllowNonCanonicalCheckpoint` is supplied.
2. Refuse to snapshot a running or paused VM when `RequireCleanShutdown` is true.
3. Auto-include macOS version, build, and provider version in checkpoint metadata where available.
4. Dispatch to provider.

**ShouldProcess:** Yes, `ConfirmImpact = 'Medium'`.

#### 16.3.7 `Restore-MacLabVmCheckpoint`

**Purpose:** Restore a VM to a named checkpoint.

**Parameters:** `Provider`, `Name`, `CheckpointName`, optional `AcknowledgeCloudStateWarning`.

**Output:** VM state object plus `RestoredFromCheckpoint` and `RestoredAt`.

**Behavior:**

1. Require explicit acknowledgement in non-interactive or unattended paths.
2. Emit the cloud-state warning before restore.
3. Dispatch to provider.
4. Emit the cloud-state warning after restore.
5. Record an evidence entry for the restore event.

**ShouldProcess:** Yes, `ConfirmImpact = 'High'`.

#### 16.3.8 `Remove-MacLabVm`

**Purpose:** Remove a lab VM and optionally remove local disk files.

**Parameters:** `Provider`, `Name`, optional `RemoveDiskFiles`, optional `Force`.

**Output:** Removal result object.

**Behavior:** Dispatch to provider. Warn that local removal does not delete Intune, Entra, or Defender records.

**ShouldProcess:** Yes, `ConfirmImpact = 'High'`.

#### 16.3.9 `Invoke-MacPolicyValidation`

**Purpose:** Run a YAML test plan against an enrolled lab VM and emit structured evidence.

**Parameters:** `Provider`, `Name`, `TestPlan`, optional `OutputPath`, `RedactSecrets`, `Fidelity`, and `GraphScope`.

**Output:** Evidence object matching Appendix B.

**Behavior:**

1. Load and validate the YAML test plan.
2. Reject Red-bucket assertions.
3. Verify the VM and checkpoint state expected by the plan.
4. Dispatch each step to the relevant proof helper.
5. Capture local and cloud state where the plan requires both.
6. Run the evidence through `Protect-MacLabEvidence`.
7. Persist evidence with `Write-EvidenceRecord`.
8. Stream the redacted evidence object.

Test assertion failures are recorded as evidence `Fail` results and are not terminating errors. Schema violations, missing VM state, missing required scopes, and redaction failures are terminating errors.

**ShouldProcess:** Yes, `ConfirmImpact = 'Medium'`.

#### 16.3.10 `Export-MacLabEvidence`

**Purpose:** Export an evidence run to a portable directory or zip bundle.

**Parameters:** Optional `Name`, optional `RunId`, optional `EvidenceRoot`, required `OutputPath`, optional `Format`, optional `RedactSecrets`.

**Output:** Object with `BundlePath`, `RunId`, `RedactionApplied`, and `BundleSha256`.

**Behavior:**

1. Locate the requested run.
2. Re-run redaction on every JSON artifact before bundling.
3. Include `evidence.json`, `evidence.summary.txt`, the YAML test plan, Provider Version Matrix snapshot, and `MANIFEST.json`.
4. Compute SHA-256 over the bundle.

**ShouldProcess:** Yes, `ConfirmImpact = 'Low'`.

## 17. Private Helpers and Providers

### 17.1 Private Helpers

Private helpers live under `src/Modules/MacLab/Private/`, are not exported, and each file contains exactly one function.

| Helper | Required purpose |
| --- | --- |
| `Invoke-LoggedCommand` | Run external commands, capture stdout/stderr/exit code/timing, redact sensitive arguments in logs, and enforce timeouts. |
| `Write-EvidenceRecord` | Write redacted evidence to `evidence.json` and `evidence.summary.txt`, embed Provider Version Matrix, verify `redactionApplied`, use deterministic JSON formatting, and return file paths plus SHA-256. |
| `Resolve-MacLabConfig` | Merge embedded defaults, optional config file, and explicit overrides without creating config files as a side effect. |
| `Protect-MacLabEvidence` | Redact secrets from evidence as described in Section 9.3. |

### 17.2 Provider Primitive Contract

Each provider file MUST expose provider-specific primitives that the public cmdlets can call through a uniform dispatch layer:

| Primitive | Output expectation |
| --- | --- |
| `New-MacLabVm_<Provider>` | Created VM record. |
| `Get-MacLabVm_<Provider>` | VM records. |
| `Start-MacLabVm_<Provider>` | VM state record. |
| `Stop-MacLabVm_<Provider>` | VM state record. |
| `Checkpoint-MacLabVm_<Provider>` | Checkpoint record. |
| `Restore-MacLabVmCheckpoint_<Provider>` | VM state plus restored-from data. |
| `Remove-MacLabVm_<Provider>` | Removal result. |
| `Get-ProviderVersion_<Provider>` | Version string and diagnostic data. |
| `Test-ProviderInstalled_<Provider>` | Boolean or structured installed/missing state. |

### 17.3 Shared Provider Rules

- Providers declare capabilities such as `CanCreateVm`, `CanStartVm`, `CanStopVm`, `CanCheckpoint`, `CanRestoreCheckpoint`, `CanListSnapshots`, and `SupportsTemplateImport`.
- Providers return structured objects, not plain strings.
- Providers capture executable versions where available.
- Providers fail clearly when tools are missing.
- Providers do not delete VMs, snapshots, or media without confirmation/`ShouldProcess`.
- Providers use shared networking, not bridged networking, by default.
- Providers disable host-to-guest sharing features that blur identity boundaries unless a future owner-approved change explicitly permits them.
- Providers MUST compare host macOS major version, requested guest macOS major version, provider, and restore-image metadata before creating a macOS VM.
- Providers MUST report whether the requested host/guest pairing is same-major supported, documented cross-major best effort, or rejected.
- Providers MUST include the host/guest compatibility classification in the Provider Version Matrix when a VM is created or evidence is written.

### 17.4 Parallels Provider

Parallels is the primary provider.

Required behavior:

- Detect `prlctl`.
- Capture Parallels version and edition where possible.
- Warn if Standard edition is detected because the demo assumes Pro or Business automation.
- Enforce the Apple Virtualization host/guest compatibility gate in Section 8.1.1 before `prlctl create`.
- Create/register VMs from the chosen artifact path.
- Start and stop VMs.
- Create, list, and restore snapshots/checkpoints.
- Resolve friendly checkpoint names to provider snapshot IDs before restore because Parallels `snapshot-switch --id` expects the provider snapshot ID, not the friendly snapshot name.
- Use reliable names-only or structured output for VM existence checks; do not assume `prlctl list -a --name` emits only VM names.
- Return stable VM identity metadata.
- Use Shared networking.
- Disable Coherence, shared clipboard, shared folders, shared cameras, shared Bluetooth, shared applications, SmartMount-style host resource sharing, host location sharing, and similar host integrations when creating VMs.
- Use explicit Parallels isolation switches where the installed command surface supports them, including `--isolate-vm on`, `--share-host-location off`, and per-feature disable switches; if a switch is unavailable, surface a clear manual-step-required result and verify the final VM configuration.
- Verify the resulting VM configuration after creation because Parallels defaults may leave host integration settings enabled even when the lab requires isolation.
- Treat final parsed VM settings, not successful command completion, as the source of truth for isolation readiness.
- Verify final VM state after lifecycle commands rather than relying only on process exit code because provider commands may return a nonzero exit while the VM eventually reaches the requested state.

### 17.5 UTM Provider

UTM is the secondary provider and documented/manual provider-swap path. UTM is not full live Parallels parity in v1.

Required behavior:

- Detect UTM and `utmctl` where available.
- Enforce Apple Virtualization for macOS guests, not QEMU emulation.
- Enforce the Apple Virtualization host/guest compatibility gate in Section 8.1.1 before creating or importing a macOS guest.
- Use Shared Network, not bridged.
- Reference `examples/utm/macos-lab-template.utm.json`.
- Where `utmctl` cannot perform a primitive, throw a clear "manual step required" error and link to the documented procedure.
- Automate only the UTM lifecycle primitives proven by owner evidence: list, status, start from stopped, suspend, resume from paused by calling start, and stop.
- Treat VM creation, import/export, snapshots/checkpoints, guest file transfer, and guest command execution as manual-step-required or unsupported unless later owner-approved evidence proves a safe automation path.
- Treat `utmctl ip-address` as unsupported for the tested macOS Apple Virtualization path.
- Inspect command output and resulting VM status where practical because `utmctl` can print operational errors while returning process exit code 0.
- Warn that `utmctl delete` has no confirmation and MUST NOT run by default.
- Support the provider-swap demo path honestly, even if some steps are manual.

### 17.6 Tart Provider

Tart is optional in v1.

The v1 provider MAY be a stub that:

- Implements `Test-ProviderInstalled_Tart`.
- Implements `Get-ProviderVersion_Tart`.
- Documents the Apple Virtualization host/guest compatibility gate if a later owner-approved change adds macOS guest creation.
- Throws a clear "Tart provider is documented but not implemented in v1" error for all mutating primitives.
- Points to `docs/CI-and-Tart.md`.

The agent MUST NOT silently expand Tart beyond the stub unless the owner explicitly approves that work.

`docs/CI-and-Tart.md` MUST explain the initial Tart licensing posture in plain language:

- Tart and Orchard currently publish Fair Source license files in their public repositories.
- Tart's free-tier documentation describes a 100 CPU-core limit.
- Orchard's free-tier documentation describes a 4-worker limit; the Orchard license file defines the relevant user concept as a device running macOS.
- V1 does not depend on Tart for the talk path. The provider remains stubbed unless the owner later approves full implementation.
- This is implementation guidance, not legal advice. The owner/user remains responsible for verifying license suitability before using Tart or Orchard in their own organization.

### 17.7 Provider Version Matrix

Every evidence-producing cmdlet MUST capture a Provider Version Matrix with:

- Host macOS version and build.
- Guest macOS version and build where available.
- Hypervisor version.
- PowerShell version.
- Pester version, initially pinned to `5.7.1` in CI.
- Defender version when relevant.
- Intune policy-set identifier when supplied by the test plan.

## 18. Scripts Specification

Scripts under `scripts/` are stage-friendly wrappers and utilities. They are not the public module surface.

Every script MUST:

- Include full comment-based help.
- Use `[CmdletBinding()]`, `param()`, and `Set-StrictMode -Version Latest`.
- Honor `WhatIf`/`Confirm` where side effects exist.
- Import the local `MacLab` module, not a gallery module.
- Pass PSScriptAnalyzer.
- Avoid secret output.

| Script | Required purpose |
| --- | --- |
| `Install-Prereqs.ps1` | Idempotently check/install host prerequisites. Instruct rather than blindly running risky external installer commands. |
| `Test-LabReadiness.ps1` | Canonical T-15 readiness gate; returns green/red with per-check detail and optional JSON output. |
| `Get-MacOSRestoreImage.ps1` | Thin wrapper around `Get-MacLabMedia -ArtifactType Firmware`. |
| `New-MacInstallArtifact.ps1` | Thin wrapper around `Get-MacLabMedia -ArtifactType Installer`. |
| `New-MacVm.ps1` | Thin wrapper around `New-MacLabVm`. |
| `Checkpoint-MacVm.ps1` | Thin wrapper around `Checkpoint-MacLabVm`. |
| `Restore-MacVmCheckpoint.ps1` | Thin wrapper around `Restore-MacLabVmCheckpoint`; prints cloud-state warning before and after restore. |
| `Remove-MacVm.ps1` | Thin wrapper around `Remove-MacLabVm`; prompts about cloud cleanup planning. |
| `Reset-IntuneMacLabDevice.ps1` | Cloud cleanup/reconciliation routine. V1 is report-only. Report-only output identifies candidate Intune, Entra, and Defender records; explains why they may be stale; shows portal paths or Graph commands for manual cleanup; and writes redacted evidence. Soft-delete/retire or hard-delete is deferred and requires a later owner-approved Phase 10 item. |
| `Send-LabEventToLogAnalytics.ps1` | Optional Phase 10 helper; disabled/deferred by default. |
| `Invoke-MMSDemo.ps1` | Stage-friendly Demo 4 orchestrator with interactive gates and non-interactive rehearsal mode. For the MMS conference path, verify and reuse the prepared IPSW before any VM step and do not start a new media download when the prepared artifact exists and matches the expected checksum. |

## 19. Examples and Documentation

### 19.1 Examples

`examples/MMSMOA-2026/` MUST contain:

- `demo-config.yml`
- `Demo1-Media.ps1`
- `Demo2-Parallels.ps1`
- `Demo3-UTM.ps1`
- `Demo4-IntuneValidation.ps1`

`demo-config.yml` MUST use placeholders and include at minimum:

```yaml
name: mms-demo-macos
macOS:
  version: '<macOS-version>'
  build: '<macOS-build>'
  architecture: arm64
  artifactType: Both
  source: Mist
  preparedArtifactPath: '<existing-ipsw-path>'
  preparedArtifactSha256: '<existing-ipsw-sha256>'
providerDefaults:
  parallels:
    cpus: 4
    memoryGB: 8
    diskGB: 96
  utm:
    cpus: 4
    memoryGB: 8
    diskGB: 96
evidence:
  outputRoot: './_evidence'
  redactSecrets: true
network:
  shared: true
  bridged: false
intune:
  tenant: '<lab>.onmicrosoft.example'
  policySetId: '<policy-set-version>'
fidelity:
  defaultBucket: Yellow
```

For the owner/demo host, `preparedArtifactPath` is `~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw` and `preparedArtifactSha256` is `8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32`. Demo scripts MUST verify that prepared artifact before any VM creation or registration step. They MUST NOT start another `mist download` when the prepared artifact exists and matches the expected checksum. `Demo1-Media.ps1` MUST treat a verified prepared artifact as a completed media step for the MMS conference demo path, not as a reason to re-download.

No move is required for the owner's current path. If a future demo path changes the expected IPSW location, `docs/Demo-Runbook.md` MUST include exact copy or move commands like this, followed by checksum verification:

```bash
mkdir -p "$HOME/Demo/Installers"
mv "<current-ipsw-path>" "$HOME/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw"
shasum -a 256 "$HOME/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw"
```

The expected checksum remains `8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32`.

`examples/TestCases/` MUST contain:

- `FileVault-Validation.yml`
- `Defender-Validation.yml`
- `PPPC-Validation.yml`
- `Compliance-SmokeTest.yml`

Each test plan declares `name`, `version`, `description`, `fidelity`, supported providers, required checkpoint, steps, and expectations.

`examples/utm/macos-lab-template.utm.json` MUST be a text descriptor, not a binary `.utm` bundle.

### 19.2 Documentation Files

Every non-trivial doc MUST include the inherited metadata block. Required docs:

| File | Required content |
| --- | --- |
| `README.md` | What the repo is/is not, fastest safe starting path, badges, five-line usage snippet, talk metadata, license, acknowledgements. |
| `docs/Start-Here.md` | Canonical entry point: what kit is, who it is for, five-minute Monday plan, what to read next, where to ask questions. |
| `docs/Prereqs.md` | Apple-silicon host requirements, software, provider prerequisites, Graph module guidance, tenant prerequisites. |
| `docs/Hypervisor-Decision-Guide.md` | Parallels vs. UTM vs. Tart decision matrix and UTM descriptor reconstruction path. |
| `docs/Apple-Silicon-Constraints.md` | Virtualization framework, host/guest constraints, Apple SLA link and two-guest default posture, APNs/network caveats, physical hardware boundaries. |
| `docs/Provider-Version-Matrix.md` | Definition and sample matrix; "works on my Mac" is not evidence. |
| `docs/Fidelity-Boundaries.md` | Traffic Light table, cmdlet honesty rules, cloud-state warning, Yellow-result wording for change tickets. |
| `docs/Snapshot-Strategy.md` | Five-checkpoint model, cloud cleanup, restore testing, identity-drift warnings. |
| `docs/Intune-Tenant-Setup.md` | Lab tenant/user/group setup, Apple MDM Push Certificate, policies, assignments, filters, CA scope cautions. |
| `docs/FileVault-Validation.md` | Policy assignment, `fdesetup status`, escrow evidence, redacted proof, hardware sign-off boundary. |
| `docs/Defender-Validation.md` | Package, Intune deployment setup, system extension, network extension, PPPC/FDA, onboarding, `mdatp health`, evidence. |
| `docs/PPPC-Validation.md` | Bundle ID, code requirement, app path, profile receipt, behavior tests, pitfalls. |
| `docs/Evidence-and-CAB.md` | Evidence design, schema, summary format, CAB usage, redaction levels. |
| `docs/Evidence-Redaction.md` | Redaction helper behavior, field list, shape matching, verification tests. |
| `docs/Windows-Admin-Cheat-Sheet.md` | Translation table from Windows lab instincts to macOS VM lab patterns. |
| `docs/Log-Analytics-Integration.md` | Optional Phase 10 doc; disabled by default, env-var based, redaction-first. |
| `docs/ConfigMgr-Inventory-Bridge.md` | Optional Phase 10 doc; inventory adjacency only, no secret export. |
| `docs/CI-and-Tart.md` | Optional Tart/CI guidance, Tart/Orchard Fair Source free-tier links and limits, and license verification warning. |
| `docs/Troubleshooting.md` | Symptom, likely cause, diagnostic step, safe remediation table. |
| `docs/Demo-Runbook.md` | T-15 readiness gate, pre-stage checklist, per-demo recovery paths, recording fallback rules, secret-leak response. |

The README usage snippet MUST be:

```powershell
Import-Module ./src/Modules/MacLab/MacLab.psd1
Get-MacLabMedia -Version '<macOS-version>' -Build '<macOS-build>'
New-MacLabVm -Provider Parallels -Name 'demo-01' -MediaId '<macOS-version>-<macOS-build>'
Checkpoint-MacLabVm -Provider Parallels -Name 'demo-01' -CheckpointName 'Pre-Enroll'
Invoke-MacPolicyValidation -Provider Parallels -Name 'demo-01' -TestPlan ./examples/TestCases/Compliance-SmokeTest.yml
```

## 20. Tests and CI

### 20.1 Test Files

| File | Required coverage |
| --- | --- |
| `tests/MacLab.Tests.ps1` | Manifest validity, exact exports, comment-based help, output types, media mocks, invalid VM names, missing media metadata, checkpoint validation, restore warning, Red-bucket rejection, redaction defaults, `WhatIf`. |
| `tests/Providers.Parallels.Tests.ps1` | `prlctl` detection, version parsing, Shared networking, sharing disabled, checkpoint state enforcement, restore warning, synthetic `prlctl list` parsing. |
| `tests/Providers.UTM.Tests.ps1` | UTM/`utmctl` detection, version parsing, Apple Virtualization enforcement, manual-step-required errors for unsupported primitives. |
| `tests/Validation.FileVault.Tests.ps1` | Synthetic recovery-key redaction by name and shape, JWT redaction, refusal to write unredacted evidence, FileVault plan parse, Yellow fidelity, cloud warning. |
| `tests/Validation.Defender.Tests.ps1` | Defender plan parse, synthetic `mdatp health` parsing, missing system extension as evidence `Fail`, Graph token redaction. |

Default tests MUST NOT require real Parallels, UTM, Tart, Apple ID, Microsoft 365 tenant, Microsoft Graph endpoint, Defender installation, or a real macOS VM.

### 20.2 CI Workflow

The new repository has:

1. Inherited `auto-fix-precommit.yml`, unchanged.
2. New `.github/workflows/pester.yml`.

The `pester.yml` workflow MUST:

- Run on push to `main` and pull requests targeting `main`.
- Use `macos-latest` for macOS CI unless the template or GitHub Actions availability changes before implementation. The inherited template may also include Ubuntu and Windows matrix entries; Python-specific workflow jobs may be removed if Python sample content is trimmed from the repo.
- Checkout code using the template/Dependabot-managed checkout action version.
- Install PowerShell 7.4 or newer if needed.
- Install Pester `5.7.1`.
- Install PSScriptAnalyzer.
- Run PSScriptAnalyzer against `src/`, `scripts/`, and `examples/MMSMOA-2026/`.
- Run Pester against `tests/`.
- Upload test results as an artifact.
- Require no secrets and no authenticated network calls.

Action versions in `uses:` lines MUST remain directly visible for Dependabot. Tool versions may be centralized in workflow `env` if needed.

### 20.3 Validation Commands

Before every commit, run:

```bash
pre-commit run --all-files
npm run lint:md
npm run lint:md:nested
```

For PowerShell validation, run the repo's configured Pester and PSScriptAnalyzer commands as implemented in CI.

## 21. Implementation Phases

The build is delivered in phases, but phase gates are implementation checkpoints rather than mandatory owner-intervention points. The agent MUST still work phase by phase, keep each phase's changes reviewable, summarize deliverables and validation for each completed phase, and keep root TODO status current. The agent SHOULD continue into the next phase when the next phase can be implemented from this specification, the ADRs, the root TODO files, committed fixtures, and local mocked validation.

The current autonomous implementation span is Phase 2 through Phase 9 local implementation and validation. The supplied specification, ADRs, and TODO files contain enough detail for the coding agent to build the module skeleton, readiness gate, media workflow, Parallels provider, UTM/manual provider path, Tart stub, evidence pipeline, validation loop, and demo orchestrator without asking the owner at every intermediate phase.

The agent MUST pause at the owner-validation boundary after Phase 9 local validation, before any of these actions:

- Owner live dry run of apply, break, rollback, and evidence export.
- Pushing branches or opening release PRs when not already authorized in the current task.
- Creating the `v0.1.0-mmsmoa-preview` release tag.
- Enabling branch protection or rulesets.
- Starting a new macOS media download for the MMS demo path.
- Running destructive provider actions against non-disposable VMs.
- Mutating Intune, Entra, Defender, or other cloud records.
- Expanding optional Phase 10 work beyond already-approved v1 stubs and documentation.

The agent MUST pause earlier only when a requirement is ambiguous, required evidence is missing, validation cannot be fixed locally, or continuing would require a real provider, a real cloud tenant, a real macOS VM, a secret-bearing artifact, or any action that explicitly requires owner approval. Acceptance criteria that require owner live validation remain valid, but they are carried forward to the owner-validation boundary instead of blocking the next local implementation phase.

### 21.1 Phase 0: Bootstrap

**Goal:** Initialize from template and customize identity-only fields.

**Deliverables:**

- New public repo at [`franklesniak/macOSLab`](https://github.com/franklesniak/macOSLab).
- `LICENSE` copyright line set.
- Phase 0 README skeleton.
- CODEOWNERS validated.
- `package.json` customized and lockfile regenerated.
- Irrelevant template sample artifacts removed only if safe.

**Acceptance:** Section 12.3.

**Gate:** Record the phase summary and continue if the current task authorizes multi-phase implementation; otherwise pause for owner review.

### 21.2 Phase 1: Foundation Documentation

**Goal:** Ship read-this-first documents.

**Deliverables:**

- `docs/Start-Here.md`
- `docs/Prereqs.md`
- `docs/Hypervisor-Decision-Guide.md`
- `docs/Apple-Silicon-Constraints.md`
- `docs/Provider-Version-Matrix.md`
- `docs/Fidelity-Boundaries.md`
- `docs/Snapshot-Strategy.md`
- `docs/Windows-Admin-Cheat-Sheet.md`
- Any required root phase TODO files from Section 9.6.
- Full `README.md`
- No `SECURITY.md` rewrite. If the inherited file supports a narrow project-specific addition, propose only the exact paragraph from Section 12.1 for owner review.

**Acceptance:** Markdown lint green, metadata blocks present, no real secrets or identifiers.

**Gate:** Record the phase summary and continue if the next phase can be implemented locally without owner-only input.

### 21.3 Phase 2: Module Skeleton and CI

**Goal:** Stand up the module surface with compliant stubs and CI.

**Deliverables:**

- `MacLab.psd1` with owner-approved GUID.
- `MacLab.psm1`.
- Public cmdlet stubs.
- Private helper stubs.
- Provider stubs.
- `tests/MacLab.Tests.ps1`.
- `.github/workflows/pester.yml`.

**Acceptance:** Manifest imports, PSScriptAnalyzer is clean, Pester is green, stubs fail clearly.

**Gate:** Record the phase summary and continue if local validation passes and no owner-only input is required.

### 21.4 Phase 3: Lab Readiness Gate

**Goal:** Deliver readiness and prerequisite scripts.

**Deliverables:**

- `scripts/Install-Prereqs.ps1`
- `scripts/Test-LabReadiness.ps1`
- Tests for readiness logic.

**Acceptance:** Owner can run on an Apple-silicon Mac; readiness reports green/red with clear detail.

**Gate:** Record the phase summary and continue. Owner live readiness validation is carried forward to the owner-validation boundary unless the current task explicitly asks for an earlier pause.

### 21.5 Phase 4: Media Acquisition

**Goal:** Implement pinned media acquisition.

**Deliverables:**

- `Get-MacLabMedia`
- `scripts/Get-MacOSRestoreImage.ps1`
- `scripts/New-MacInstallArtifact.ps1`
- `TODO-Phase-04-Media-Acquisition.md` with the current `mist-cli` verification task, unless that task is completed and closed in the same phase.
- Pester tests.

**Acceptance:** Live owner run fetches a pinned macOS build and produces metadata sidecar; tests pass.

**Gate:** Record the phase summary and continue. Owner live media validation is carried forward to the owner-validation boundary unless the current task explicitly asks for an earlier pause.

### 21.6 Phase 5: Parallels Provider

**Goal:** Implement primary provider path.

**Deliverables:**

- `Providers/Parallels.ps1`
- VM lifecycle cmdlets for `-Provider Parallels`
- `tests/Providers.Parallels.Tests.ps1`
- `examples/MMSMOA-2026/Demo2-Parallels.ps1`
- `TODO-Phase-05-Parallels-Provider.md` with the `prlctl` verification task, unless that task is completed and closed in the same phase.

**Acceptance:** Owner live demo creates, checkpoints, restores, and removes a Parallels VM; tests pass.

**Gate:** Record the phase summary and continue. Owner live Parallels validation is carried forward to the owner-validation boundary unless the current task explicitly asks for an earlier pause.

### 21.7 Phase 6: UTM Provider and Tart Stub

**Goal:** Implement UTM documented/manual provider-swap path with partial lifecycle automation and Tart v1 stub.

**Deliverables:**

- `Providers/UTM.ps1`
- `Providers/Tart.ps1`
- `tests/Providers.UTM.Tests.ps1`
- `examples/MMSMOA-2026/Demo3-UTM.ps1`
- `examples/utm/macos-lab-template.utm.json`
- `TODO-Phase-06-UTM-Provider.md` with UTM/`utmctl` verification tasks, unless those tasks are completed and closed in the same phase.

**Acceptance:** Owner confirms UTM path and manual-step gaps are clear; UTM is not represented as full live Parallels parity; tests pass.

**Gate:** Record the phase summary and continue. Owner confirmation of UTM manual-step gaps is carried forward to the owner-validation boundary unless the current task explicitly asks for an earlier pause.

### 21.8 Phase 7: Evidence Pipeline

**Goal:** Implement redaction, evidence writing, and bundling.

**Deliverables:**

- `Protect-MacLabEvidence`
- `Write-EvidenceRecord`
- `Export-MacLabEvidence`
- Tests for recovery-key, JWT, nested redaction, and idempotency.
- `docs/Evidence-and-CAB.md`
- `docs/Evidence-Redaction.md`

**Acceptance:** Redaction tests pass; evidence bundle remains redacted; schema is valid.

**Gate:** Record the phase summary and continue if redaction and schema validation pass locally.

### 21.9 Phase 8: Validation Loop

**Goal:** Implement policy validation and canonical test plans.

**Deliverables:**

- `Invoke-MacPolicyValidation`
- Four YAML test plans.
- FileVault, Defender, PPPC, and Intune docs.
- Validation tests.
- `TODO-Phase-08-Validation-Loop.md` with Defender `mdatp health` output-shape verification, unless that task is completed and closed in the same phase.

**Acceptance:** Test plans parse and produce valid fixture evidence; Red-bucket assertions are rejected; redaction defaults on.

**Gate:** Record the phase summary and continue if test-plan parsing, fixture evidence, Red-bucket rejection, and redaction-default validation pass locally.

### 21.10 Phase 9: Demo Orchestrator and MMSMOA Examples

**Goal:** Make the kit sufficient for the talk.

**Deliverables:**

- `scripts/Invoke-MMSDemo.ps1`
- `Demo1-Media.ps1`
- `Demo4-IntuneValidation.ps1`
- `demo-config.yml`
- `docs/Demo-Runbook.md`
- `docs/Troubleshooting.md`

**Acceptance:** Owner completes a dry run of apply, break, rollback, evidence export. Demo media steps verify and reuse the prepared IPSW without starting a new download.

**Gate:** Pause at the owner-validation boundary. Do not tag `v0.1.0-mmsmoa-preview` until the owner approves the live dry run and release action.

### 21.11 Phase 10: Optional Bridges and Polish

**Goal:** Add optional items only when individually approved.

Possible deliverables:

- `scripts/Reset-IntuneMacLabDevice.ps1`
- `scripts/Send-LabEventToLogAnalytics.ps1`
- `docs/Log-Analytics-Integration.md`
- `docs/ConfigMgr-Inventory-Bridge.md`
- `docs/CI-and-Tart.md`
- Fuller Tart provider.
- `TODO-Phase-10-Deferred-Work.md`, required when any Phase 10 item remains deferred. It MUST explain what is deferred, why, what context the owner needs to resume it, and how to validate it safely.

**Acceptance:** Per deliverable.

**Gate:** Owner approval per item.

## 22. Definition of Done

The v1 build is complete when all of these are true on `main`:

- Repo exists publicly at [`franklesniak/macOSLab`](https://github.com/franklesniak/macOSLab).
- `LICENSE` shows `Copyright (c) 2026 Frank Lesniak`.
- README renders correctly and points to `docs/Start-Here.md`.
- CODEOWNERS lists the approved owner(s).
- Protected instruction files were not modified without explicit authorization.
- Project-owned files in Section 14 exist with specified names.
- No binary media, screenshots, recordings, or credential-bearing files are committed.
- `Test-ModuleManifest src/Modules/MacLab/MacLab.psd1` succeeds.
- `Import-Module src/Modules/MacLab/MacLab.psd1` succeeds.
- `Get-Command -Module MacLab` lists exactly the ten public cmdlets.
- Every public and private function has required comment-based help.
- Every rollback path emits the cloud-state warning.
- PSScriptAnalyzer reports zero findings.
- `pre-commit run --all-files` passes.
- `npm run lint:md` passes.
- `npm run lint:md:nested` passes if present.
- Pester tests pass.
- CI is green.
- Default tests require no real provider tools or cloud credentials.
- Every required doc exists with metadata.
- No docs or examples contain real secrets, users, tenants, or device identifiers.
- Evidence export works from fixture data.
- Redaction is applied before sensitive evidence is written.
- FileVault docs never instruct the user to display a raw recovery key.
- Defender docs validate profiles and health, not only installation.
- VM Fidelity Traffic Light is present and clear.
- Cloud rollback boundary is repeated in snapshot, Intune, and demo docs.
- Owner has performed or explicitly waived the live Apple-silicon end-to-end run.
- Release tag `v0.1.0-mmsmoa-preview` is created only after owner approval.

## 23. Cmdlet Quick Reference

| Cmdlet | Purpose | Abbreviated signature |
| --- | --- | --- |
| `Get-MacLabMedia` | Pin and cache macOS media. | `-Version <s> [-Build <s>] [-Architecture arm64] [-Source Mist] [-ArtifactType Installer/Firmware/Both] [-CacheRoot <s>] [-Force] [-RedactSecrets]` |
| `New-MacLabVm` | Create a VM under a provider. | `-Provider Parallels/UTM/Tart -Name <s> -MediaId <s> [-CacheRoot <s>] [-SizingProfile Baseline/Performance] [-VmRoot <s>] [-RedactSecrets]` |
| `Get-MacLabVm` | List or describe lab VMs. | `[-Provider <s>] [-Name <s>]` |
| `Start-MacLabVm` | Start a VM. | `-Provider <s> -Name <s> [-WaitForReady]` |
| `Stop-MacLabVm` | Stop a VM. | `-Provider <s> -Name <s> [-Force]` |
| `Checkpoint-MacLabVm` | Capture a checkpoint. | `-Provider <s> -Name <s> -CheckpointName <s> [-AllowNonCanonicalCheckpoint] [-Description <s>] [-RequireCleanShutdown]` |
| `Restore-MacLabVmCheckpoint` | Restore a VM checkpoint. | `-Provider <s> -Name <s> -CheckpointName <s> [-AcknowledgeCloudStateWarning]` |
| `Remove-MacLabVm` | Delete a lab VM. | `-Provider <s> -Name <s> [-RemoveDiskFiles] [-Force]` |
| `Invoke-MacPolicyValidation` | Run a YAML test plan and emit evidence. | `-Provider <s> -Name <s> -TestPlan <s> [-OutputPath <s>] [-RedactSecrets] [-Fidelity Green/Yellow/Red] [-GraphScope <s[]>]` |
| `Export-MacLabEvidence` | Bundle an evidence run. | `[-Name <s>] [-RunId <s>] [-EvidenceRoot <s>] -OutputPath <s> [-Format Directory/Zip] [-RedactSecrets]` |

## 24. Owner Decisions Archive

Closed owner decisions and implementation uncertainties are archived in [macOS-imaging-08d-closed-questions-archive.md](../planning/macOS-imaging-08d-closed-questions-archive.md). Durable decisions are recorded in [macOS-imaging-08e-ADRs.md](../planning/macOS-imaging-08e-ADRs.md).

The future coding agent MUST use this specification and the ADR file as the active contract. The archive is historical context, not a pending work list.

## 25. Evidence Bundle Schema

Every evidence record produced by `Invoke-MacPolicyValidation` and bundled by `Export-MacLabEvidence` MUST conform to this shape or a backwards-compatible extension approved by the owner.

```json
{
  "$schemaVersion": "1.0.0",
  "runId": "2026-05-mms-demo4-001",
  "createdAt": "2026-05-04T00:00:00Z",
  "vmName": "mms-parallels-01",
  "provider": "Parallels",
  "providerVersion": "<parallels-version>",
  "snapshot": "Post-Enroll-Baseline",
  "fidelity": "Yellow",
  "hardwareSignoffRequired": true,
  "providerVersionMatrix": {
    "hostMacOS": "<host-macOS-version>",
    "hostMacOSBuild": "<host-macOS-build>",
    "guestMacOS": "<macOS-version>",
    "guestBuild": "<macOS-build>",
    "parallelsVersion": "<parallels-version>",
    "utmVersion": null,
    "tartVersion": null,
    "powerShellVersion": "7.4.0",
    "pesterVersion": "5.7.1",
    "defenderVersion": "<defender-version>",
    "intunePolicySetId": "<policy-set-version>"
  },
  "intuneDeviceName": "MMS-MACLAB-001",
  "intuneDeviceIdRedacted": "***REDACTED***",
  "tenantSuffixOnly": ".onmicrosoft.example",
  "redactionApplied": true,
  "redactionVersion": "1.0.0",
  "cloudStateWarning": "VM rollback does not rewind Intune, Entra, Defender portal state, audit logs, or reporting history.",
  "tests": [
    {
      "name": "MDM enrollment profile present",
      "kind": "MdmEnrollment",
      "result": "Pass",
      "expectedFailure": false,
      "evidenceRefs": []
    },
    {
      "name": "FileVault status captured",
      "kind": "FileVaultStatus",
      "result": "Pass",
      "expectedFailure": false,
      "evidenceRefs": ["fdesetup-status.txt"]
    },
    {
      "name": "FileVault escrow evidence captured",
      "kind": "FileVaultEscrow",
      "result": "Pass",
      "expectedFailure": false,
      "evidenceRefs": ["graph-escrow-summary.json"]
    },
    {
      "name": "FileVault recovery key value redacted",
      "kind": "RedactionVerification",
      "result": "Pass",
      "expectedFailure": false,
      "evidenceRefs": []
    },
    {
      "name": "Defender health captured",
      "kind": "DefenderHealth",
      "result": "Pass",
      "expectedFailure": false,
      "evidenceRefs": ["mdatp-health.json"]
    },
    {
      "name": "Compliance smoke test",
      "kind": "ComplianceState",
      "result": "Fail",
      "expectedFailure": true,
      "evidenceRefs": ["graph-compliance-snapshot.json"]
    },
    {
      "name": "Rollback restored known-good VM checkpoint",
      "kind": "RollbackVerification",
      "result": "Pass",
      "expectedFailure": false,
      "evidenceRefs": []
    },
    {
      "name": "Cloud cleanup routine documented",
      "kind": "CloudCleanupNotice",
      "result": "Warn",
      "expectedFailure": false,
      "evidenceRefs": ["docs/Snapshot-Strategy.md"]
    }
  ]
}
```

Schema notes:

- Field names are lowerCamelCase except `$schemaVersion`.
- `result` is one of `Pass`, `Fail`, or `Warn`.
- `expectedFailure: true` means a `Fail` result is the intended engineered demo failure.
- `evidenceRefs` are relative paths inside the evidence run directory.
- Raw recovery keys, tokens, client secrets, and tenant secrets never appear in this object.

## 26. Glossary

| Term | Meaning in this repository |
| --- | --- |
| APNs | Apple Push Notification service. macOS MDM depends on it. |
| ADE/ABM | Apple Automated Device Enrollment / Apple Business Manager. Red-bucket VM fidelity. |
| CAB | Change Advisory Board. One target audience for the evidence bundle. |
| Cloud-state warning | The statement that VM rollback does not rewind Intune, Entra, Defender portal state, audit logs, or reporting history. |
| Demo 4 | The apply, break, rollback, evidence loop. |
| Evidence bundle | Portable redacted output from a validation run. |
| FileVault personal recovery key | A secret that must never appear in committed artifacts. |
| Fidelity Traffic Light | Green, Yellow, Red model for what VMs can validate. |
| Five-checkpoint model | `Clean-OS`, `Pre-Enroll`, `Post-Enroll-Baseline`, `Broken-Policy-State`, `Recovered-Known-Good`. |
| Intune | Microsoft Intune, the first-class management plane for the repo. |
| MDM identity drift | Mismatch between rolled-back local VM state and cloud-side records that kept moving forward. |
| mist-cli | macOS CLI used to acquire pinned install artifacts. |
| Parallels | Primary hypervisor provider. |
| PPPC/TCC | macOS privacy preferences and Transparency, Consent, and Control framework. |
| Provider Version Matrix | Host, guest, hypervisor, PowerShell, Pester, Defender, and policy versions captured in evidence. |
| `Protect-MacLabEvidence` | Redaction helper. Never named `Redact-MacLabEvidence`. |
| Tart | Optional CLI-first Apple-silicon VM tool; v1 may stub it. |
| `Test-LabReadiness.ps1` | Canonical T-15 readiness gate. |
| UTM | Secondary hypervisor provider using Apple Virtualization for macOS guests. |
| VM-first, hardware-last | Iterate and gather evidence in VMs; sign off on physical hardware where required. |

## 27. Final Approval Line

> **Owner approval:** I, Frank Lesniak, have read this specification end to end. I have initialed or struck through every box in the Approval Checklist. I have reviewed the closed questions archive and ADR file. Any future unresolved item must be recorded as a new explicit decision before implementation proceeds. The agent is authorized to begin Phase 0 as described in Section 21.1.
>
> Signature: ______________________
>
> Date: __________________________
>
> Pinned macOS version: __________________________
>
> Pinned macOS build: __________________________
>
> MacLab module GUID: `4d6748ba-859d-4171-9785-889eaabdb048`

Reading-time estimate: full first pass, 60-75 minutes. Approval checklist plus ADR file, 10-15 minutes.
