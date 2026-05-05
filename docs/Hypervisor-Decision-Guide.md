<!-- markdownlint-disable MD013 -->
# Hypervisor Decision Guide

## Metadata

- **Status:** Active
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-05
- **Scope:** Decision guide for choosing Parallels, UTM, or Tart in the `macOSLab` v1 lab.
- **Related:** [Prerequisites](Prereqs.md), [Apple Silicon Constraints](Apple-Silicon-Constraints.md), [Provider Version Matrix](Provider-Version-Matrix.md), [UTM macOS guest documentation](https://docs.getutm.app/guest-support/macos/), [Parallels macOS VM CLI documentation](https://docs.parallels.com/landing/parallels-desktop-developers-guide/command-line-interface-utility/manage-virtual-machines-from-cli/general-virtual-machine-management/create-a-virtual-machine)

Use Parallels first when you need the shortest path to the live demo. Use UTM when cost, openness, or provider-swap comparison matters more than full automation. Treat Tart as an advanced stub in v1.

## Decision Matrix

| Provider | V1 posture | Best fit | Automation level | Main caution |
| --- | --- | --- | --- | --- |
| Parallels | Primary provider | Main demo path and repeatable local lab | VM creation, lifecycle, checkpoints, and restore are the intended working path | Defaults can leave host integration enabled; provider code must harden and verify final isolation state. |
| UTM | Documented/manual provider-swap path | Secondary path, budget-sensitive labs, and provider comparison | Partial lifecycle automation where `utmctl` behavior is proven; creation and checkpoint paths are manual-step-required in v1 | Do not present UTM as full live Parallels parity. |
| Tart | Stubbed advanced path | Later CI/runner conversation | Mutating primitives fail clearly in v1 | Full Tart parity requires later explicit owner approval. |

## Parallels Default Path

Choose Parallels when you need:

- Automated macOS VM creation from an IPSW restore image.
- Named checkpoint creation and restore.
- A live stage path with the fewest manual steps.
- Provider evidence that can include CLI version, VM settings, snapshot state, and isolation state.

The Parallels provider must use the Apple Virtualization host/guest compatibility gate before creating macOS VMs. It must verify final VM state and final sharing/isolation settings instead of trusting exit codes or defaults.

## UTM Provider-Swap Path

Choose UTM when you need:

- A lower-cost or more transparent provider path.
- A documented contrast with Parallels.
- Manual VM creation with partial lifecycle automation.

In v1, UTM must be honest about gaps. The provider may automate list, status, start, suspend, resume from paused by calling start, and stop when those operations are proven on the disposable VM. Create, import/export, checkpoint/snapshot, guest command execution, guest file transfer, IP discovery, and delete remain unsupported or manual-step-required unless later owner-approved evidence proves a safe path.

## UTM Descriptor Reconstruction Path

Phase 6 will ship `examples/utm/macos-lab-template.utm.json` as a text descriptor, not as a `.utm` bundle. Use that descriptor as a reconstruction checklist:

1. Create a new macOS VM in UTM using Apple Virtualization.
2. Select the pinned IPSW restore image.
3. Apply the CPU, memory, disk, display, network, and sharing settings recorded in the descriptor.
4. Confirm Shared Network is used.
5. Disable host sharing features where UTM exposes them.
6. Record the resulting provider facts in the Provider Version Matrix.

Do not commit the resulting `.utm` bundle or virtual disk.

## Tart Stub Path

Tart remains useful for CI and runner discussions because it uses Apple's native Virtualization framework and can integrate with automation systems. In v1, it is not part of the default lab path. Mutating Tart provider functions must fail clearly with a documented "not implemented in v1" result unless a later owner-approved phase expands the provider.

## Provider Selection Rule

The provider choice is not just "which tool is installed." A valid selection must include:

- Host macOS version and build.
- Requested guest macOS version and build.
- Provider and provider version.
- Host/guest compatibility classification.
- Isolation and sharing state.
- Manual-step gaps.

Capture those facts in the [Provider Version Matrix](Provider-Version-Matrix.md).
