<!-- markdownlint-disable MD013 -->
# Apple Silicon Constraints

## Metadata

- **Status:** Active
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-05
- **Scope:** Apple-silicon virtualization constraints, licensing posture, host/guest compatibility, APNs/network caveats, and physical hardware boundaries for `macOSLab`.
- **Related:** [Hypervisor Decision Guide](Hypervisor-Decision-Guide.md), [Fidelity Boundaries](Fidelity-Boundaries.md), [Provider Version Matrix](Provider-Version-Matrix.md), [macOS Tahoe SLA](https://www.apple.com/legal/sla/docs/macOSTahoe.pdf), [Parallels macOS VM limitations](https://kb.parallels.com/en/128867), [UTM Apple settings documentation](https://docs.getutm.app/settings-apple/settings-apple/)

`macOSLab` targets Apple-branded Apple-silicon Macs. The lab is built around Apple's Virtualization framework because Parallels, UTM macOS guests on Apple silicon, and Tart all depend on that platform boundary for macOS guests.

## Licensing Posture

The repository links to the [macOS Tahoe software license agreement](https://www.apple.com/legal/sla/docs/macOSTahoe.pdf) as the primary Apple license source for the initial documentation set.

The practical default posture is:

- Use Apple-branded hardware.
- Assume no more than two concurrent macOS guest instances per Apple-branded host unless the owner or user verifies a different license posture.
- Use the lab for testing, development, and validation scenarios that fit the user's own license review.
- Do not treat this repository as legal advice.

Users are responsible for confirming their own Apple, hypervisor, and organizational licensing requirements.

## Host And Guest Compatibility

For macOS guests on Apple-silicon hosts, compatibility is a preflight gate, not a static version table.

The default supported path is same-major host and guest macOS. For example, a macOS 26 host running a macOS 26 guest is the preferred demo path. Cross-major targets may remain useful, but automation must not assume they work everywhere. A guest macOS major version higher than the host macOS major version must be rejected by default or require explicit owner-approved override.

Provider documentation reinforces this conservative posture:

- Parallels documents `prlctl create <name> -o macos --restore-image <path>` for macOS VM creation from IPSW and states that the only guaranteed Apple-silicon macOS VM compatibility scenario is the same macOS major version on host and guest.
- Parallels also documents that macOS Arm VMs are built using Apple's Virtualization framework and that running a guest higher than the host may not be possible.
- UTM documents the Apple Virtualization backend as the way to run virtualized macOS on Apple silicon.
- Tart describes itself as using Apple's native Virtualization framework.

## Version Matrix Requirement

Every meaningful run must record:

- Host macOS version and build.
- Host architecture.
- Guest macOS version and build, when known.
- Provider and provider version.
- Restore image path, size, and SHA-256 where practical.
- Host/guest compatibility classification.
- Manual-step gaps.

The Provider Version Matrix turns "works on my Mac" into reviewable evidence.

## APNs And Network Caveats

The default lab network posture is Shared networking, not bridged networking. Shared networking is suitable for most Intune, APNs, Graph, and Defender validation paths, but it is still a VM network. If a test depends on network identity, source IP, captive portals, proxy behavior, multicast discovery, or hardware-adjacent network controls, mark the result Yellow or Red as appropriate.

APNs, Intune, Graph, Defender, and Apple software update reachability are required for live policy validation. When those services are not reachable, readiness checks should fail or warn with specific detail instead of treating cloud timing as a policy failure.

## Physical Hardware Boundaries

The VM lab is not enough for Red-bucket outcomes:

- ADE/ABM zero-touch enrollment.
- Platform SSO sign-in/unlock.
- Touch ID.
- Secure Enclave-dependent behavior.
- Serial-number-dependent production workflows.
- Final executive pilot sign-off.

Yellow outcomes can be iterated in the VM but still need physical Mac sign-off. FileVault rollout behavior, user prompts, compliance timing, and performance-sensitive Defender behavior often fall into this category.

## Operational Rule

Do not create a macOS VM until the host/guest compatibility check, provider version capture, and media checksum verification are complete. A fast failed preflight is better than a VM that looks valid but cannot be trusted as evidence.
