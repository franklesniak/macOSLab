<!-- markdownlint-disable MD013 -->
# Start Here

## Metadata

- **Status:** Active
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-07
- **Scope:** Canonical first-read guide for Windows-first Microsoft endpoint administrators starting with `macOSLab`.
- **Related:** [README](../README.md), [Prerequisites](Prereqs.md), [Fidelity Boundaries](Fidelity-Boundaries.md), [Snapshot Strategy](Snapshot-Strategy.md), [macOSLab repository specification](spec/macOSLab-repository-spec.md)

`macOSLab` helps you build a disposable macOS VM lab on an Apple-silicon Mac so risky Intune policy changes can be tested before they reach real users. The lab is evidence-first: each meaningful validation run should produce structured, redacted output that explains what was tested, what passed, what failed, and what still needs physical Mac sign-off.

## Who This Is For

Use this kit if you manage Microsoft Intune, Defender for Endpoint, FileVault, PPPC/TCC, Gatekeeper/System Policy Control, or compliance policy for Macs and want a repeatable local validation path.

This kit assumes you are comfortable with PowerShell, GitHub, and Microsoft endpoint concepts. It does not assume deep macOS automation experience.

## What This Kit Is Not

`macOSLab` is not a replacement for:

- Production change management.
- Physical Mac pilot rings.
- ADE/ABM zero-touch validation.
- Platform SSO sign-in/unlock validation.
- Touch ID or Secure Enclave-dependent testing.
- Legal review of Apple or hypervisor license terms.

Use the VM lab for faster iteration, then use physical hardware where the fidelity boundary says hardware sign-off is required.

## Five-Minute Monday Plan

1. Read [Prereqs.md](Prereqs.md) and confirm you have an Apple-silicon Mac, PowerShell 7.4 or newer, Git, Node.js, and the provider tools you plan to use.
2. Read [Apple-Silicon-Constraints.md](Apple-Silicon-Constraints.md) before assuming a guest macOS version works on your host.
3. Pick a provider using [Hypervisor-Decision-Guide.md](Hypervisor-Decision-Guide.md). Default to Parallels for the first working path.
4. Read [Snapshot-Strategy.md](Snapshot-Strategy.md) so checkpoint names and cloud-state warnings are clear before you enroll a VM.
5. Read [Fidelity-Boundaries.md](Fidelity-Boundaries.md) before turning VM evidence into a change ticket.

The first risky-policy sample is a lab-only Gatekeeper/System Policy Control validation against a disposable VM. The broken-state plan proves an App-Store-only policy blocks Visual Studio Code on first launch, and the recovered plan proves rollback restores the known-good app-launch state. The first expected evidence artifact is a redacted JSON record under the evidence output root configured by the test plan.

## First Command

Start by importing the module from the repository root:

```powershell
Import-Module ./src/Modules/MacLab/MacLab.psd1
```

Then run fixture-backed validation before attempting live provider or cloud work:

```powershell
Invoke-MacPolicyValidation -Provider Parallels -Name 'demo-01' -TestPlan ./examples/TestCases/Gatekeeper-AppStoreOnly.yml
```

## What To Read Next

- Need to prepare the Mac: [Prereqs.md](Prereqs.md).
- Need to pick a hypervisor: [Hypervisor-Decision-Guide.md](Hypervisor-Decision-Guide.md).
- Need to explain VM limits to a CAB or leadership audience: [Fidelity-Boundaries.md](Fidelity-Boundaries.md).
- Need to decide when to snapshot: [Snapshot-Strategy.md](Snapshot-Strategy.md).
- Need to translate Windows lab instincts into macOS terms: [Windows-Admin-Cheat-Sheet.md](Windows-Admin-Cheat-Sheet.md).

## Where To Ask Questions

Use GitHub Issues for reproducible bugs and documentation gaps. Use GitHub Discussions for design questions, provider observations, and safe implementation notes. Do not paste tenant IDs, device IDs, recovery keys, UPNs, screenshots, recordings, or raw evidence into public GitHub surfaces.
