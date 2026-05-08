<!-- markdownlint-disable MD013 -->
# Don't Brick the CEO's Mac: MMSMOA 2026 Session Plan and Speaker Runbook

## Metadata

- **Status:** Draft
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-07
- **Scope:** Talk-development working artifact for the MMSMOA 2026 session: "Don't Brick the CEO's Mac: MMSMOA 2026 Session Plan and Speaker Runbook". Captures interim concepting, prioritization, outline, or runbook content for that session; not a final published deliverable.
- **Related:** [macOSLab repository specification](../spec/macOSLab-repository-spec.md), [Architecture decision records](macOS-imaging-08e-ADRs.md), [Closed questions archive](macOS-imaging-08d-closed-questions-archive.md), [Repository Copilot Instructions](../../.github/copilot-instructions.md), [Documentation Writing Style](../../.github/instructions/docs.instructions.md)

## Document Conventions

- File-path references are written as plain inline code with backticks — for example, `Start-Here.md`. They refer to files inside the GitHub starter kit. If your editor auto-converts `.md` filenames into hyperlinks (some notetaking and writing tools do this silently), undo that conversion before sharing, printing, or pasting this runbook. The intended rendering is plain inline code, not a hyperlink.
- Code samples that include version-specific values use angle-bracket placeholders. Replace each placeholder with the actual pinned value during rehearsal, and keep them current as the event approaches:
  - `<macOS-version>` and `<macOS-build>` for guest builds.
  - `<host-macOS-version>` for the demo Mac's host OS.
  - `<parallels-version>` for the Parallels Desktop release in use.
  - `<utm-version>` for the UTM release in use.
  - `<powershell-version>` for the PowerShell 7.4-or-newer build.
  - `<defender-version>` for Microsoft Defender for Endpoint on macOS.
  - `<policy-set-version>` for the snapshot of demo-tenant policies in use.
- Times in the timeline are wall-clock minutes from the start of the session. Demo durations should be treated as keyboard-time targets, not guarantees.
- "Provider" means the VM provider unless explicitly qualified as a media source. Use terms like `-Source Mist` for media acquisition to avoid confusing the media source with the hypervisor provider.
- Evidence examples must be redacted before they appear in slides, recordings, screenshots, or the public repo. Prove that escrow, assignment, and health states exist; do not expose recovery keys, tenant secrets, bearer tokens, app IDs/secrets, private device IDs, tenant names, tenant domains, user principal names, or other user-identifying data.

## Final Repository Decisions Reflected Here

The session outline now aligns with the final `macOSLab` repository decisions:

- The companion repository is `franklesniak/macOSLab`, public, MIT-licensed, and initialized from `franklesniak/copilot-repo-template`.
- The automation floor is PowerShell 7.4 or newer. PowerShell 5.1 compatibility is not part of the talk or repository promise.
- The initial Pester version is 5.7.1. The inherited template's PowerShell CI should use `macos-latest`; Python CI can be removed if no Python sample content remains.
- The live demo target is macOS Tahoe 26.4.1 when the demo host is also on macOS 26.x. The repo should also support currently Apple-supported macOS compatibility targets, initially macOS Sequoia 15.7.5 and macOS Sonoma 14.8.5, but only after host/provider preflight confirms the requested host/guest pairing.
- The primary live provider remains Parallels Desktop Pro Edition. UTM remains the provider-swap path. Tart is optional and stubbed in v1 unless explicitly approved later.
- macOS guests on Apple Silicon must be framed as Apple Virtualization framework workloads. Same-major host/guest macOS is the only vendor-documented guaranteed path in current Parallels guidance; higher-than-host guests must be treated as unsupported by default or explicitly owner-approved after rehearsal evidence.
- Full coverage across every currently supported macOS major version may require more than one Apple-silicon host. If the same-major rule is applied strictly for macOS 14.8.5, macOS 15.7.5, and macOS 26.4.1, plan for up to three host Macs, one on each major version, and verify that each physical Mac model can actually run the required host macOS.
- Tart and Orchard are discussed as Fair Source/free-tier tools: Tart's free-tier documentation describes a 100 CPU-core limit, and Orchard's free-tier documentation describes a 4-worker limit. This is practical planning guidance, not legal advice.
- Apple licensing should be framed around Apple-branded host hardware, permitted purposes, and the commonly relevant boundary of up to two additional macOS virtual instances per Apple-branded host under Apple's current macOS terms. Do not present that as blanket enterprise legal advice.
- The public v1 repo should not ship checked-in example screenshots. Local rehearsal screenshots and deck screenshots are still allowed if fully redacted and kept out of the repo unless a later Phase 10 TODO explicitly approves visual artifacts.
- `Reset-IntuneMacLabDevice.ps1` is report-only in v1. It explains candidate Intune, Entra, and Defender cleanup work; it does not retire, soft-delete, or hard-delete cloud records.
- Deferred implementation work must be tracked in root per-phase TODO files, such as `TODO-Phase-04-Media-Acquisition.md`, `TODO-Phase-05-Parallels-Provider.md`, `TODO-Phase-06-UTM-Provider.md`, `TODO-Phase-08-Validation-Loop.md`, and `TODO-Phase-10-Deferred-Work.md`. Omit a file only when that phase has no deferred work.

## Session Identity

| Field | Value |
| --- | --- |
| Session title | Don't Brick the CEO's Mac: Building and Automating macOS Labs for Risk-Free Policy Testing |
| Primary speaker | Frank Lesniak |
| Co-speaker | Michael Niehaus |
| Event | Midwest Management Summit at the Mall of America 2026 |
| Total length | 90-105 minutes |
| Core content | 60-75 minutes; current deck target is 74:30 |
| Extended Q&A | 30 minutes |
| Q&A format | Raise-hand questions; mic runner if the room is large; no live polling |
| Primary technology | Intune |
| Session types | Automation; Provisioning & Deployment; Setup & Configuration |
| Primary audience | Microsoft endpoint admins, Intune admins, ConfigMgr admins, Windows-first automation people who now need to support Macs |
| Attendee promise | A reproducible Apple-silicon macOS VM lab, automated with PowerShell 7.4 or newer, that lets Microsoft admins test risky macOS Intune policies before production users discover the mistake |

## Accepted Session Contract

This is an **Intune risk-reduction session** that uses macOS virtualization as the lab substrate.

It is not a general Mac virtualization overview. It is not a Mac hobbyist session. It is not a complete macOS management boot camp. It is a practical, technical session for Microsoft endpoint people who already understand the value of Windows testing rings, checkpoints, automation, evidence, and rollback, and who need the same safety net for Macs.

The central story is:

1. Enterprises are buying and managing Macs.
2. Microsoft admins are being asked to manage them with Intune.
3. Untested macOS policies can break very visible users very quickly.
4. Apple-silicon virtualization has real constraints, but it is useful if you respect those constraints.
5. PowerShell 7.4 or newer can be the familiar automation layer.
6. A VM lab is a safe place to fail before a risky policy reaches real users.
7. Some validation still belongs on physical Mac hardware, and the session must say that clearly.

## Accepted Takeaways and Where They Are Delivered

| # | Accepted takeaway | What the session must prove | Where it is delivered |
| --- | --- | --- | --- |
| 1 | Analyze Apple-silicon virtualization constraints and select the appropriate hypervisor, Parallels vs. UTM, for budget and automation needs. | Attendees understand the practical constraints and can make a defensible tool choice. | Technical constraints, hypervisor decision matrix, Demo 2, Demo 3, Q&A buckets. |
| 2 | Construct a fully automated, reproducible macOS test lab using PowerShell 7.4 or newer to fetch restore images/install media and control VM states. | Attendees see a repeatable flow that pins a build, acquires media, creates/starts VMs, snapshots, restores, and emits evidence. | Architecture section, Demos 1-3, starter kit, Windows-admin translation cheat sheet. |
| 3 | Execute end-to-end validation of high-risk policies, including FileVault and Defender, by enrolling, breaking, and rolling back VMs via script. | Attendees see an Intune validation loop, understand what can be proven in a VM, and know what still requires physical Mac sign-off. | Demo 4, FileVault proof path, Defender proof path, fidelity traffic light, evidence model. |
| 4 | Implement the GitHub starter kit immediately to bridge Windows automation skills and macOS requirements. | Attendees know the repo path, first command, first test case, and Monday-morning plan. | Windows-admin translation segment, repo handoff, `Start-Here.md`, Windows-admin cheat sheet, Q&A framework, close-out. |

## Narrative Thesis

> Your Windows lab instincts are still right. We are going to translate them to macOS, automate them with PowerShell, and prove that risky Intune policies can fail safely before they fail publicly.

Use this phrase early and late:

> Production is a terrible place to discover your Mac policy assumptions. The lab is the safe place to fail.

The session should feel like a bridge, not a scolding. The audience should not leave thinking, "Macs are weird and I am behind." They should leave thinking, "I already know how to operate safely; now I have a pattern for doing that with Macs."

## Audience Model

### Primary Attendee

The primary attendee is a Windows-first Microsoft endpoint admin. They likely know some combination of:

- Intune.
- ConfigMgr.
- PowerShell.
- Windows deployment.
- Application packaging.
- Patch management.
- Compliance policies.
- Conditional Access.
- Change management.
- Endpoint security tooling.

They may now own Macs because:

- Executives use them.
- Developers use them.
- A business unit bought them.
- A security requirement brought them into Intune.
- Leadership expects "one endpoint management story."

They are probably thinking:

- "I already have a Windows lab. Why does Mac testing feel so much more fragile?"
- "I do not want to become a full-time Mac engineer just to avoid breaking the CEO's laptop."
- "I need evidence before change control approves this."
- "I need a workflow my Windows-heavy team can understand."

### Secondary Attendee

The secondary attendee already manages Macs and wants:

- A faster local regression loop.
- Better lab automation.
- A way to explain macOS testing to Windows-first colleagues.
- A repeatable starter kit they can adapt.

### Tone to Use

Use:

- Calm technical confidence.
- Specific failure modes.
- Practical tradeoffs.
- Occasional humor.
- Respect for both Windows and Mac admin work.

Avoid:

- "Macs are weird" as the main joke.
- Pretending VMs replace real hardware.
- Tool religious wars.
- Live-service heroics.
- Progress-bar theater.

## Scope

### Core Scope

These are the center of gravity:

- Apple-silicon macOS VM lab design.
- Parallels Desktop and UTM as the two primary local hypervisor paths.
- PowerShell 7.4 or newer as the automation and abstraction layer.
- Intune enrollment, policy delivery, validation, evidence, and rollback.
- High-risk macOS management areas:
  - FileVault.
  - Microsoft Defender for Endpoint.
  - PPPC/TCC.
  - Compliance and Conditional Access timing.
- GitHub starter kit that attendees can clone after the session.

### Secondary Scope

These are useful but should not steal time from the accepted abstract:

- Tart as an advanced CLI/CI path.
- Full CI/CD pipeline design.
- Deep Microsoft Graph automation.
- ConfigMgr inventory bridge.
- Azure Log Analytics evidence ingestion.
- ADE/ABM test strategy.
- Platform SSO.
- Secure Enclave-dependent behavior.
- Physical hardware final sign-off.

Mention these where relevant, but keep most of the detail in the repo and Q&A.

### Out-of-Scope Boundaries

Say these clearly enough that attendees trust the rest of the session:

- A VM is not a perfect substitute for final sign-off on physical corporate Mac hardware.
- The session will not teach every part of macOS management.
- The session will not compare every virtualization product.
- The session will not depend on venue Wi-Fi, live cloud timing, or live policy changes as the only success path.
- The session will not promise that all Apple hardware/security-model behavior can be validated in a VM.
- The session will not provide legal advice on Apple licensing, vendor licensing, or enterprise procurement terms.

## Design Decisions

### Opening and Risk Framing

**Decision:** Keep the opening short: hook, one risk slide, and then into constraints/tools/demos.

**Why:** MMS audiences are deeply technical. A long intro will feel padded and will create demo time pressure.

The canonical risk map for this session — referenced throughout the rest of this document:

| Risk | What breaks | Why leadership notices |
| --- | --- | --- |
| FileVault | Unlock, recovery, escrow, user prompts. | Executive lockout, urgent helpdesk escalation, security visibility. |
| PPPC/TCC | Required tools cannot access protected data. | Broken screen sharing, recording, accessibility, backup, EDR, or remote support workflows. |
| Defender | System extension, network extension, Full Disk Access, onboarding. | Security gap, false-positive noise, SOC escalation, unhealthy endpoint posture. |
| App execution control | Gatekeeper/System Policy Control blocks legitimate signed/notarized apps when over-tightened. | Users cannot launch newly introduced required tools such as Visual Studio Code. |
| Compliance/CA | Device marked noncompliant or access blocked. | Users lose access to Outlook, SharePoint, Teams, approval apps, or business workflows. |

Optional 10-second calibration:

> Who here manages Macs in Intune today?

Use this once. Do not turn the session into polling.

### Hypervisor Scope

**Decision:** Make **Parallels Desktop** and **UTM** the on-stage core. Mention **Tart** as the advanced CLI/CI path.

**Why:** The accepted abstract names Parallels and UTM. Keeping them central preserves abstract fidelity and reduces time risk.

| Tool | Core positioning | Best fit | Stage treatment |
| --- | --- | --- | --- |
| Parallels Desktop Pro/Business | Polished commercial workflow with `prlctl` automation and strong desktop admin UX. | Enterprise admins who want a supported-feeling local workflow and reliable stage demos. | Primary live build/snapshot demo. |
| UTM | Cost-free experimentation path with Apple Virtualization and QEMU options; automation exists but does not mirror Parallels one-for-one. | Budget-sensitive labs, learning, and teams comfortable with templates/configuration artifacts. | Provider-swap demo. |
| Tart | CLI-first Apple Silicon VM tooling built for automation, CI, and image distribution. | Teams building repeatable macOS runners or pipeline-based test loops. | Repo/Q&A/appendix path, not a third equal branch in the core. |

VMware Fusion supports Apple-silicon hosts for Arm guest operating systems, including Arm Windows and Arm Linux. It is not a core provider for this session because current Broadcom documentation says Arm variants of macOS are not supported as Fusion guests on Apple silicon. Fusion may come up in Q&A as a Windows/Linux Arm option, but it is not a macOS guest lab path for this talk.

Do not frame the section as "which product is best." Frame it as:

> Which tool makes the safe behavior easiest for your team?

### Media Acquisition Language

**Decision:** Use "restore image or install artifact" as the main language, not "ISO" as the default Apple-silicon Mac path.

**Why:** For Apple-silicon macOS VM workflows, especially Parallels macOS Arm VMs, the practical and documented path is restore-image/IPSW-oriented. ISO creation can still exist in repo docs where appropriate, but it should not be the stage headline.

Recommended wording:

> We pin a macOS build, acquire the correct restore image or provider-appropriate install artifact, cache it, and record the metadata. The important thing is not the file extension. The important thing is reproducibility.

### No Parallels Coherence Demo for macOS Arm VMs

**Decision:** Do not use Coherence as the stage wow for the macOS VM.

**Why:** It is not a reliable or accurate promise for macOS Arm VMs. It also distracts from the accepted session promise. The memorable moment should be rollback and evidence, not desktop visual integration.

The actual wow:

1. The validation run is red.
2. Snapshot rollback runs.
3. The validation run is green again.
4. Evidence is exported.

That is more meaningful to this audience.

### Intune Depth

**Decision:** Demo 4 is workflow-first, with one or two deep proof points.

The core workflow is:

```text
enroll -> apply policy -> validate -> intentionally fail -> collect evidence -> roll back -> prove known-good
```

The live break-and-rollback proof point is Gatekeeper/System Policy Control:

- Known-good VM has Visual Studio Code installed but not launched.
- Lab-only Intune Settings Catalog policy enables Gatekeeper assessment and disables identified developers.
- VS Code is rejected on first launch in `Broken-Policy-State`.
- Rollback to `Post-Enroll-Baseline` restores `spctl` acceptance and app launch.

Supporting proof points remain:

- FileVault: policy assignment, local `fdesetup status`, escrow/recovery-key evidence, redacted proof, and hardware sign-off boundary.
- Defender: system extension, network extension, Full Disk Access/PPPC, onboarding, `mdatp health`, and evidence export.

Avoid trying to show every Graph query, every profile payload, and every Intune page. Put deeper Graph/payload detail in the repo.

### Snapshot Strategy

**Decision:** Teach multiple snapshot types with clear guardrails. There is no universal best snapshot.

| Snapshot | Use when | Benefits | Risks |
| --- | --- | --- | --- |
| `Clean-OS` | You need a freshly installed guest before identity, enrollment, or user state. | Maximum cleanliness and repeatability. | Slowest path back to policy testing. |
| `Pre-Enroll` | You want a clean device identity path for each enrollment test. | Best default for enrollment and MDM identity fidelity. | Slower because enrollment and sync rerun. |
| `Post-Enroll-Baseline` | You need a fast repeated policy regression loop. | Fastest and most stage-reliable. | Intune/Entra cloud state keeps moving while the VM rolls backward. |
| `Broken-Policy-State` | You need a deterministic demo failure. | Excellent for stage reliability. | Must be explained honestly as a checkpointed failure. |
| `Recovered-Known-Good` | You need proof that rollback returns the VM to a useful baseline. | Makes recovery visible. | Can hide cloud reconciliation problems if the report-only cleanup review is skipped. |

Recommended operational rule:

- Use `Pre-Enroll` as the gold-standard identity baseline.
- Use `Post-Enroll-Baseline` for speed and demo reliability.
- Pair post-enroll rollback with a documented cloud cleanup review. In v1, that review is report-only: it identifies candidate cloud records and manual cleanup steps, but it does not mutate Intune, Entra, or Defender records.
- Teach "snapshot time travel" as a real anti-pattern.

Important stage warning:

> Rollback restores the VM. It does not rewind Intune, Entra, Defender portal state, audit logs, compliance history, or cloud reporting. The report-only cleanup routine is part of the lab, not an optional afterthought.

### Failure Style

**Decision:** Use a deterministic, scripted failure and narrate it calmly.

Good stage language:

> This policy state is intentionally wrong. We want the test to fail here, because failure in the lab is the point.

Avoid:

> Let's see what happens.

The audience should believe that even the failure was engineered.

### Repo Timing

**Decision:** Publish the repo before the session, but reveal the QR code and `https://github.com/franklesniak/macOSLab` URL near the end of the core.

Recommended stage pattern:

1. Show the command you would run.
2. Open a pre-cloned local copy.
3. Show the exact demo paths.
4. Reveal the QR target, `https://github.com/franklesniak/macOSLab`, near the end of the core talk.
5. Keep attention on the stage until the core content is done.

Do not depend on a live `git clone` over conference Wi-Fi.

### Demo Timing

Treat demo durations as **keyboard-time targets**, not guaranteed wall-clock time.

Every demo needs:

- A live path.
- A checkpoint path.
- A local, fully redacted screenshot path for the deck/rehearsal assets. Do not commit example screenshots to the public v1 repo.
- A screen-recording path for cloud-dependent parts.
- A practiced pivot sentence.

Pivot sentence:

> Watching a progress bar is not educational. The artifact is pinned, cached, and recorded, so I am going to jump to the completed checkpoint and show you what matters.

## Technical Correctness Guardrails

### Apple Software License and Concurrency

Do not give legal advice from the stage.

Safe framing:

- macOS virtualization is tied to Apple-branded hardware and Apple's software license terms.
- For this talk and repo, use Apple's current macOS Tahoe software license agreement as the plain-language source to summarize. A commonly relevant boundary is up to two additional macOS virtual instances per Apple-branded host, subject to Apple's terms and permitted purposes.
- Do not paraphrase this as "every enterprise automatically gets two free macOS test VMs for any purpose."
- Enterprises should have legal/procurement confirm their own use case.

Stage phrase:

> The licensing story is friendlier than Windows licensing in some ways, but the engineering constraints are where the real design work starts.

### Host and Guest Version Caution

Avoid an oversimplified rule like "host must always be same or newer." Current Parallels guidance is stricter for the guaranteed path: same-major host and guest macOS. Higher-than-host guests may fail, and lower-than-host guests are still provider/version-dependent rather than a blanket promise.

Better wording:

> On Apple Silicon, guest support is constrained by the host macOS version, restore image, Virtualization framework, and provider. Treat the lab host like a build server: do not auto-upgrade it right before a regression cycle.

Practical rule:

- Keep the host on a known-good build for the life of a demo or regression cycle.
- Prefer a host whose macOS major version matches the demo guest's macOS major version.
- Treat every cross-major host/guest pairing as a rehearsal item that needs explicit provider evidence before it appears in a live demo, script default, or published compatibility claim.
- Treat full major-version coverage as a host-fleet problem, not only a disk-space problem. Supporting macOS 14.x, 15.x, and 26.x with same-major host/guest pairings may require up to three Mac systems.
- Remember that Mac hardware has a minimum supported macOS version. Newer hardware may not boot older host macOS releases, which means it also cannot provide the same-major host for older macOS guest testing.
- Record host macOS version, hypervisor version, guest macOS version, and guest build in every evidence bundle.
- Re-run the lab readiness tests after host updates, hypervisor updates, and major Intune/Defender policy changes.

Initial guest-version policy:

| Purpose | macOS target | Stage meaning |
| --- | --- | --- |
| Live MMSMOA demo | macOS Tahoe 26.4.1 | Primary version for the demo VMs when the host is also macOS 26.x. |
| Compatibility target | macOS Sequoia 15.7.5 | Keep the repo usable for supported 15.x environments after host/provider preflight confirms the pairing. |
| Compatibility target | macOS Sonoma 14.8.5 | Keep the repo usable for supported 14.x environments after host/provider preflight confirms the pairing. |

The rule is not "support only these three patch versions forever." The rule is "support the macOS versions Apple currently supports, verify host/provider compatibility before creation, and record the exact host/guest/build values used for each evidence run."

Host hardware planning examples:

| Desired guest coverage | Preferred same-major host | Hardware planning implication |
| --- | --- | --- |
| macOS Sonoma 14.8.5 | macOS 14.x host | Requires Apple-silicon hardware that can boot macOS 14. Newer Mac models that shipped after macOS 14 may not be usable for this host role. |
| macOS Sequoia 15.7.5 | macOS 15.x host | A Mac mini M4-class host is a reasonable planning example for macOS 15 and can also be upgraded later, but upgrading it to macOS 26 changes its same-major VM coverage. |
| macOS Tahoe 26.4.1 | macOS 26.x host | Newer M5-era hosts may be pinned to macOS 26 as their minimum host OS, making them good macOS 26 lab hosts but poor choices for same-major macOS 14 or 15 VM coverage. |

The stage-friendly simplification is: one known-good host can carry the demo. The enterprise-lab truth is: if you must continuously validate every supported macOS major version, budget for a small host matrix and check each Mac model's minimum and maximum supported macOS before buying or repurposing hardware.

### Apple Virtualization Framework and QEMU

Keep this to one practical slide.

- Apple's Virtualization framework is the first-party foundation for supported macOS guest virtualization on Apple Silicon.
- Parallels macOS Arm guests use Apple's Virtualization framework.
- UTM can use Apple Virtualization and QEMU depending on the guest and configuration, but virtualized macOS guests on Apple Silicon use Apple Virtualization rather than QEMU.
- Tart uses Apple's Virtualization framework and is designed for automation-heavy workflows.
- The same-major host/guest caution applies to macOS guests across Parallels, UTM with Apple Virtualization, and any future Tart macOS-guest path. It does not describe non-macOS guests or UTM/QEMU emulation paths outside this repo's macOS VM scope.
- The practical impact is that provider automation surfaces differ.

Do not make attendees feel they must become Virtualization framework developers.

### Provider Version Guardrails

Add a small support matrix to the repo and keep it current for the event.

Example:

| Component | Version tested | Why it matters |
| --- | --- | --- |
| Host macOS | `<host-macOS-version>` | Determines restore-image compatibility and Virtualization framework behavior. |
| Host/guest pairing | `same-major` / `cross-major-tested` / `rejected` | Shows whether the macOS guest pairing is guaranteed, rehearsed as best effort, or blocked. |
| Parallels Desktop | `<parallels-version>` | macOS Arm snapshot and CLI behavior can vary by version. |
| UTM | `<utm-version>` | Automation and template behavior can vary by version. |
| PowerShell | `<powershell-version>`; must be 7.4 or newer | Cross-platform module behavior and remoting behavior. |
| Pester | 5.7.1 initially | Test behavior and CI output must be reproducible. |
| Defender for Endpoint | `<defender-version>` | `mdatp health` fields and extension behavior can change. |
| Intune policy set | `<policy-set-version>` | Assignment and reporting behavior may change over time. |

Stage point:

> "Works on my Mac" is not evidence. "Works on this host build, this hypervisor version, this guest build, and this policy set" is evidence.

### VM Fidelity Traffic Light

Use this as a memorable credibility slide.

| Color | Meaning | Examples |
| --- | --- | --- |
| Green | Good VM tests. | Script syntax, package install behavior, Intune assignment logic, profile receipt, Gatekeeper/System Policy Control receipt, `spctl` assessment, app launch block/recovery in the guest, basic PPPC payload behavior, Defender health checks, rollback routines, evidence export. |
| Yellow | Good VM iteration, then physical hardware sign-off. | FileVault rollout behavior, recovery-key process, compliance experience, user prompts, fleet rollout impact, performance-sensitive Defender behavior. |
| Red | Physical hardware or production-like enrollment required. | ADE/ABM zero-touch flows, serial-number-dependent workflows, Platform SSO sign-in/unlock experience, Touch ID, Secure Enclave-dependent behavior, physical Wi-Fi behavior, final executive pilot sign-off. |

The point:

> A lab that cannot explain its fidelity boundary is not a lab. It is a superstition with screenshots.

### APNs and Network Reality

macOS management depends on APNs and cloud service timing. Conference networks may block, proxy, throttle, or shape the traffic you care about. Corporate networks can also break things in non-obvious ways: many enterprises run TLS/SSL inspection appliances that intercept Microsoft and Apple management traffic. APNs traffic should bypass TLS decryption/inspection, and Intune/Defender check-in traffic should be validated on the same network you plan to use for the demo.

Stage phrase:

> If APNs is not happy, Intune is not instant. That is why we cache, checkpoint, and prove state instead of trusting a spinner.

Pre-session checks must include:

- APNs connectivity.
- Intune portal access.
- Graph access if used.
- Defender cloud connectivity if used.
- Hotspot fallback if permitted.
- Local-only fallback.
- Confirmation that proxy or SSL inspection behavior is not breaking Apple or Microsoft management traffic.

Credibility moment to land verbally:

> If you have ever had Intune check-in fail only on certain networks, look at proxy and TLS inspection before you blame Apple. APNs traffic needs to pass cleanly, and your lab should prove the network path before showtime.

### FileVault Validation Model

FileVault must be explicit because it is in the title and accepted takeaway.

Minimum proof path:

1. Show the policy assignment or lab configuration.
2. Show local state with `fdesetup status`.
3. Show Intune encryption or recovery-key evidence.
4. Redact or mask any recovery-key value.
5. Explain escrow timing.
6. Explain what VM testing can prove.
7. Explain what still requires physical hardware sign-off.

Evidence to collect:

- macOS version and build.
- VM provider and snapshot.
- Intune device name and ID, redacted if needed.
- FileVault policy name and assignment scope.
- `fdesetup status`.
- Recovery-key escrow status or report path.
- Redacted recovery-key existence proof, not the recovery key itself.
- Known limitations.
- Rollback result.

Important nuance:

> Escrow preparation and encryption state are related, but they are not the same thing. Test both.

Stage safety rule:

> Never display a full FileVault recovery key on the projector. Show that the key exists, show where it is retrieved, show that access is audited, and redact the value.

Practical consequence: this rules out any live demo of the Intune portal page that retrieves a recovery key, because that page genuinely shows the value once the right role clicks "Show recovery key." Use pre-redacted screenshots of the retrieval flow instead, narrate them as if they are live, and confirm during rehearsal that no demo path leads to a portal page where the key would be exposed.

### Defender Validation Model

Defender should be more than "the app installed."

Minimum proof path:

1. Package installed.
2. System extension approved.
3. Network extension approved if network protection is used.
4. Full Disk Access/PPPC delivered.
5. Onboarding completed.
6. `mdatp health` captured.
7. Optional portal visibility or test signal.
8. Evidence exported.

Evidence to collect:

- Defender version.
- System extension state.
- Network extension state.
- Full Disk Access/PPPC profile receipt.
- `mdatp health`.
- Policy assignment scope.
- Local logs or health output.
- Rollback result.

Stage point:

> Defender on macOS is not just "install the app." The profiles are the deployment.

### PPPC/TCC Validation Model

PPPC is a precision problem.

Teach:

- Bundle ID matters.
- Code requirement matters.
- App path can matter.
- User-visible privacy UI may not tell the whole story.
- Evidence should come from profiles, logs, app behavior, and targeted scripts.

Do not rely on "I looked in System Settings and it seemed right."

### Compliance and Conditional Access Timing

Compliance and Conditional Access should be framed as eventually consistent.

Recommended stage language:

> The portal is not a real-time debugger. It is a management system with check-in, evaluation, reporting, and access-decision timing. Our job is to collect enough evidence to know what stage we are actually waiting on.

For the live demo, prefer a deterministic compliance smoke test or pre-created state over a live Conditional Access block.

## Speaker Choreography

### Ownership Model

Use the two-speaker format intentionally. MMS wants conversation, not two disconnected monologues.

| Segment | Driver / lead | Narrator / color |
| --- | --- | --- |
| Hook and risk map | Frank | Michael adds enterprise reality. |
| Windows-admin translation | Frank | Michael affirms with a one-line "this is how my team would think about it." |
| Apple Silicon constraints | Michael | Frank asks Windows-admin translation questions. |
| Hypervisor decision | Frank | Michael challenges tradeoffs and keeps it Intune-relevant. |
| PowerShell architecture | Frank | Michael asks "how would an endpoint team maintain this?" |
| Demo 1: media pinning | Frank | Michael explains why build pinning matters in enterprise change control. |
| Demo 2: Parallels | Frank | Michael explains why snapshot discipline matters. |
| Demo 3: UTM provider swap | Frank | Michael compares the operating model without dunking on the tool. |
| Demo 4: Intune validation | Michael | Frank narrates lab scaffold, rollback, and evidence. |
| Dragons and wrap | Both | Alternate lines. |
| Extended Q&A | Both | Route questions by domain. |

Why this matters:

- Frank owns the lab automation and PowerShell narrative.
- Michael owns the Intune/enrollment/policy behavior narrative.
- Demo 4 should feel like a real Intune session, not just a virtualization session.

### Driver/Narrator Pattern

For every demo:

| Role | Responsibility |
| --- | --- |
| Driver | Runs keyboard and mouse, keeps windows readable, executes pivots. |
| Narrator | Explains what is happening, fills latency, watches time, names gotchas. |

The narrator has permission to interrupt with:

- "Pause there for a second."
- "This is the part Windows admins should notice."
- "This is where I would not trust the VM alone."
- "Let's checkpoint that before we make it messy."

### Planned Handoff Lines

Script these in speaker notes:

- "Frank showed why this matters. Michael, let's make the Apple Silicon constraints concrete."
- "That is the constraint side. Now let's turn it into a tool choice instead of a religious debate."
- "We have two providers, but we do not want two automation models. Frank, show the PowerShell contract."
- "This is the part where the VM stops being cute and starts being useful."
- "Now we are going to break the lab on purpose, because production should never be the first place this mistake appears."
- "Before we go to Q&A, here is the Monday-morning path in the repo."

## Pre-Session Stage-Readiness Runbook

### Hardware

Use one primary Apple-silicon Mac for the full demo chain. Bring a second Mac if available, but do not design the live session around needing a multi-host matrix.

For real lab planning, do not let the one-host stage plan hide the compatibility constraint. If the organization needs reliable same-major coverage for macOS 14.x, 15.x, and 26.x, it may need up to three Apple-silicon Macs, each capable of running the matching host macOS major version. Newest hardware is not automatically the best lab hardware for older guest coverage because it may not support older host macOS releases.

Minimum practical recommendation:

- Apple-silicon Mac with enough CPU and RAM for:
  - host OS.
  - macOS guest.
  - browser.
  - PowerShell terminal.
  - VS Code.
  - PowerPoint.
  - screen recording.
- 150-250 GB free SSD before rehearsal snapshots.
- Stable power.
- Known-good A/V adapter.
- Spare A/V adapter.
- Offline copy of the deck.
- Offline copy of the repo.
- Offline copy of critical screenshots and recording.

### Display Readability

- Terminal font around 24 pt, adjusted after projector testing.
- VS Code font around 22-24 pt.
- Browser zoom at 125-150 percent for Intune portal demos.
- Use a consistent window layout.
- Disable notifications.
- Disable sleep.
- Disable screen saver.
- Disable auto-updates.
- Use light theme if the room is bright and projector contrast is poor.

### Host macOS Permissions

Grant privacy permissions to the **exact app** used for automation.

Check:

- Automation.
- Full Disk Access.
- Files and folders access.
- Screen recording if recording or presenting.
- Accessibility if window automation requires it.

Important:

> TCC is app-specific. A permission granted to Terminal does not automatically apply to iTerm2 or VS Code.

Avoid switching terminal apps mid-demo.

### Local Assets

Have these locally:

- Restore images or provider-appropriate install artifacts.
- Pre-created VMs.
- All demo scripts.
- Redacted evidence examples.
- Screenshots of Intune portal states with secrets and user-identifying details masked.
- 60-90 second screen recording of Demo 4.
- Full offline copy of the GitHub starter kit.

### Required VM Checkpoints

Prepare:

- `Clean-OS`
- `Pre-Enroll`
- `Post-Enroll-Baseline`
- `Broken-Policy-State`
- `Recovered-Known-Good`

Document what each contains. Do not rely on memory.

### Tenant and Intune Setup

Use a dedicated demo tenant or an isolated lab scope.

Minimum setup:

- Lab test user. Use a cloud-only account in the demo tenant with no real mailbox, no real licenses beyond what the demo requires, and no group memberships outside the lab scope. The point is that a Conditional Access misfire during the demo cannot lock a real person out of real systems.
- Lab device naming convention.
- Lab-only groups.
- Lab-only filters if filters are used.
- FileVault policy.
- Defender policy set.
- Compliance policy for visible pass/fail.
- Optional Conditional Access policy only if isolated and safe.
- Graph permissions if using a Graph proof point.
- Screenshots of all portal states in case network/cloud timing misbehaves.
- A redaction pass for all screenshots, JSON outputs, logs, and evidence bundles that might be shown publicly.

Avoid using broad production assignments.

### Network Contingency

Before the session:

- Validate APNs connectivity.
- Validate Intune portal access.
- Validate Graph access if used.
- Validate Defender cloud connectivity if used.
- Validate hotspot fallback if permitted.
- Pre-trust fallback SSID if allowed.
- Prepare a local-only fallback path.
- Confirm proxy or SSL inspection on every network you might use is not breaking management traffic.

### Break-Glass Recording

Record a polished 60-90 second clip of Demo 4:

```text
baseline -> apply/reveal failure -> collect evidence -> roll back -> known good
```

Use it only if there is a real service, APNs, network, or lab failure.

Practiced line:

> Rather than fight a service issue live, here is the exact run from rehearsal. Then we will jump back to the live machine for the rollback and repo path.

Rehearse the narration over the recording at least once before the event so the audio that comes out of your mouth matches what is happening on screen. The recording is only useful if the words land in time with the visuals.

### T-15 Minute Smoke Test

Run this before going on stage:

1. `Test-LabReadiness.ps1` returns green.
2. Parallels opens and required VMs are visible.
3. UTM opens or `utmctl` responds if used.
4. `prlctl list --all` returns expected output.
5. Demo VM boots from `Post-Enroll-Baseline`.
6. Intune admin center loads.
7. Demo tenant device exists.
8. Evidence script can write to `_evidence`.
9. Screen recording file opens.
10. QR code resolves.
11. Browser zoom and terminal font are readable.
12. Notifications and auto-updates are disabled.
13. Evidence screenshots are redacted.
14. No recovery key, app secret, token, tenant secret, or personal user data is visible in the demo path.

## Core Timeline: 75 Minutes

### 0:00-1:00: Title and Micro-Credibility

Goal: establish who you are and what happens.

Say:

- We manage and automate Microsoft endpoint environments.
- We know this audience already has Windows lab instincts.
- Today we translate those instincts to macOS Intune policy testing.

Two presenters, brief introductions only. No bios. Save personal background for the speaker bio link in Sched.

### 1:00-3:00: CEO Lockout Hook

Goal: create urgency without fearmongering.

Visual: a Mac at a FileVault unlock/recovery moment or a clean mockup of an executive support escalation.

Line:

> You would not ship a BitLocker policy to the CEO's laptop without testing recovery. But many organizations are still shipping macOS FileVault, PPPC, and Defender policies with far less lab confidence. Today we build the safety net.

Promise:

> By the end, you will see a Mac policy fail safely in a lab, roll back, and produce evidence you could attach to a change ticket.

### 3:00-6:00: Risk Map

Goal: show why this matters.

Use the canonical four-bucket risk slide from the Design Decisions section. Walk through each row in two or three sentences. Tie each row to the user persona it would hurt — executive lockout for FileVault, "the recording we needed for the board" for PPPC, security visibility for Defender, "I cannot get into Outlook" for Compliance/CA.

Optional hand raise:

> Who here manages Macs in Intune today?

### 6:00-7:30: Windows-Admin Translation

Goal: make Takeaway 4's bridge promise explicit before the constraints content lands.

Show the Windows-admin translation cheat sheet as a single slide. Walk through three or four lines, not all of them. The point is signaling, not exhaustive coverage.

Stage line:

> Your Windows lab instincts are still right. The language stays the same — PowerShell 7.4+ is the conductor. Only the instruments change.

This segment is also where the audience starts to relax. Constraints land better when the audience already feels invited rather than scolded. Keep it tight; the full cheat sheet is in the deck and the repo for later reference.

### 7:30-15:00: Constraints That Drive Lab Design

Goal: earn credibility and prevent overpromising.

Cover:

- Why Hyper-V/ESXi mental models do not directly apply.
- Apple software license and concurrency caution.
- Restore images and build pinning.
- Host/guest/provider compatibility.
- Apple Virtualization framework vs. QEMU.
- Provider feature differences.
- APNs and Intune timing.
- Corporate proxy and SSL inspection breaking APNs or Microsoft management traffic in non-obvious ways.
- VM fidelity boundaries.
- Host upgrade danger.
- Provider version guardrails.

400-level anchor:

> A lab that cannot tell you what it cannot prove is not a safe lab.

Credibility moment to land verbally:

> If you have ever had Intune check-in fail on Mondays only, look at your TLS-inspecting proxy before you blame Apple. APNs does not tolerate man-in-the-middle, and many corporate networks accidentally are one.

### 15:00-24:30: Hypervisor Decision Matrix

Goal: help attendees choose Parallels or UTM without a product fight.

Slide: "Choose based on operating model."

| Decision factor | Parallels Desktop Pro/Business | UTM |
| --- | --- | --- |
| Cost | Commercial subscription. | Free direct download; optional paid App Store convenience. |
| Admin UX | Highest polish for local desktop workflows. | Good experimentation UX. |
| Automation surface | `prlctl` is strong for many lifecycle operations in Pro/Business workflows. | `utmctl`, AppleScript, Shortcuts, and templates; automation coverage differs by feature. |
| macOS guest compatibility | Same-major host/guest macOS is the safest default; cross-major pairings require rehearsal evidence. | Same Apple Virtualization host/guest caution for macOS guests; UTM/QEMU differences matter for non-macOS guests, not this macOS VM path. |
| Snapshots/clones | Useful in current versions; confirm Parallels Desktop 20+ for macOS Arm VM snapshots. | Useful, but workflow differs and may require template/config discipline. |
| Stage reliability | Strong local demo choice when version-checked. | Good provider-swap proof if prepared. |
| Procurement story | Easier for many enterprises. | Easier where no tool budget exists. |
| CI path | Possible but not the main story. | Possible with effort; Tart is usually the cleaner advanced CI discussion. |

Say:

> If I need the most polished local admin workflow and I can buy a tool, I start with Parallels. If I need no-cost experimentation and I can accept more template/config work, I start with UTM. If I want pipeline-native image distribution, Tart becomes a phase-two conversation.

### 24:30-30:00: PowerShell 7.4+ Provider-Model Architecture

Goal: prove this is automation-first.

Flow diagram:

1. Pin build.
2. Acquire restore image or provider-appropriate install artifact.
3. Create or register VM.
4. Apply sizing profile.
5. Start VM.
6. Create snapshot.
7. Enroll in Intune.
8. Apply policy.
9. Validate or intentionally fail.
10. Collect evidence.
11. Roll back.
12. Clean up local and cloud state.

Stable interface example:

```powershell
# Replace <macOS-version> and <macOS-build> with your pinned values during rehearsal.
Get-MacLabMedia `
  -Version '<macOS-version>' `
  -Build '<macOS-build>' `
  -Architecture arm64 `
  -Source Mist

New-MacLabVm `
  -Provider Parallels `
  -Name 'mms-fv-01' `
  -SizingProfile Baseline

Checkpoint-MacLabVm `
  -Name 'mms-fv-01' `
  -CheckpointName 'Pre-Enroll'

Invoke-MacPolicyValidation `
  -Name 'mms-fv-01' `
  -TestPlan './examples/TestCases/Gatekeeper-AppStoreOnly.yml'

Restore-MacLabVmCheckpoint `
  -Name 'mms-fv-01' `
  -CheckpointName 'Post-Enroll-Baseline'

Export-MacLabEvidence `
  -Name 'mms-fv-01' `
  -OutputPath './_evidence/mms-fv-01'
```

400-level anchor:

> The abstraction boundary is not "hide all provider details." The boundary is "make the safe workflow consistent and surface provider-specific failure modes clearly."

### 30:00-31:00: Demo Rules and Gotchas

Goal: set expectations.

Say:

- Downloads are cached.
- Cloud sync is not instant.
- Checkpoints are intentional.
- Rollback restores the VM, not the cloud.
- The point is evidence and repeatability, not watching progress bars.

## Demo Block: 31:00-70:00

### Demo 1: Pin and Acquire Media, 31:00-38:00

Goal: show reproducible acquisition of a specific macOS build.

Live path:

- Show a build-pinning config file.
- Run or display the media acquisition command.
- Show cached artifact metadata.
- Show that the VM build process consumes the pinned artifact.

Example config:

```yaml
# Replace <macOS-version> and <macOS-build> with your pinned values during rehearsal.
# Choose a build that exists in Apple's restore catalog and cache it locally before the session.
name: mms-demo-macos
macOS:
  version: '<macOS-version>'
  build: '<macOS-build>'
  architecture: arm64
  artifactType: restoreImage
  source: mist-cli
providerDefaults:
  parallels:
    cpus: 4
    memoryGB: 8
    diskGB: 96
  utm:
    cpus: 4
    memoryGB: 8
    diskGB: 96
```

Evidence shown:

```text
_evidence/media/<macOS-version>-<macOS-build>/
  metadata.json
  acquisition.log
  checksum.txt
```

Narration cue:

> This is where repeatability starts. If you cannot say which macOS build you tested, you cannot say what your test means.

Recovery path:

- Leave the command visible.
- Open cached output.
- Explain that downloading is not the educational part.

### Demo 2: Parallels VM Build and Snapshot, 38:00-50:00

Goal: show the polished commercial path and PowerShell driving provider-specific automation.

Live path:

- Confirm Parallels version supports the macOS Arm VM features used in the demo.
- Confirm the host macOS major version matches the demo guest, or show the recorded rehearsal evidence for any cross-major pairing.
- Create or register the VM from a prepared restore image.
- Apply sizing profile.
- Start the VM or jump to a created VM.
- Create or show checkpoint named `Pre-Enroll`.
- Show provider logs and evidence output.

Example commands:

```powershell
# Replace <macOS-version> and <macOS-build> with your pinned values during rehearsal.
New-MacLabVm `
  -Provider Parallels `
  -Name 'mms-parallels-01' `
  -MediaId '<macOS-version>-<macOS-build>' `
  -SizingProfile Baseline

Checkpoint-MacLabVm `
  -Provider Parallels `
  -Name 'mms-parallels-01' `
  -CheckpointName 'Pre-Enroll'
```

Narration points:

- `prlctl` is the provider-specific engine.
- PowerShell is the stable operator interface.
- The snapshot is not decoration. It is the safety mechanism.
- The evidence bundle records what happened.
- The Parallels version is part of the evidence, because macOS Arm VM features are version-sensitive.

Do not:

- Promise macOS Apple-silicon Coherence Mode.
- Spend time on visual polish instead of risk reduction.
- Show an `.app` installer path as the primary Parallels Apple-silicon macOS VM path.
- Assume snapshots exist unless the Parallels version has been confirmed during rehearsal.

Recovery path:

- Pivot to prebuilt VM at `Pre-Enroll` or `Post-Enroll-Baseline`.
- Show logs from the successful creation.

### Demo 3: UTM Provider Swap, 50:00-57:00

Goal: prove that the automation pattern survives a provider change.

Live path:

- Switch provider parameter from Parallels to UTM.
- Show UTM template/config artifact.
- Confirm the UTM path uses Apple Virtualization for the macOS guest and the same host/guest compatibility classification used by the Parallels path.
- Start or inspect the UTM VM.
- Show that the same higher-level validation flow still applies.

Example commands:

```powershell
# Replace <macOS-version> and <macOS-build> with your pinned values during rehearsal.
New-MacLabVm `
  -Provider UTM `
  -Name 'mms-utm-01' `
  -MediaId '<macOS-version>-<macOS-build>' `
  -TemplatePath './examples/utm/macos-lab-template.utm'

Start-MacLabVm -Provider UTM -Name 'mms-utm-01'
Get-MacLabVm -Provider UTM -Name 'mms-utm-01'
```

Narration points:

- UTM is a serious lab option, not a toy.
- UTM automation is different from Parallels automation.
- The provider abstraction prevents tool differences from changing the entire workflow.
- Not every UTM feature has the same automation parity, so the provider wrapper should make gaps explicit.

Optional Tart cameo, one slide only:

```bash
# Replace <macOS-version> with the tag your team publishes for the pinned build.
tart clone ghcr.io/example/macos-runner:<macOS-version> mms-tart-01
tart run mms-tart-01
```

Say:

> Tart is where this pattern can grow when you want a CI runner conversation. It is not the core promise of this accepted session, so the v1 repo keeps Tart stubbed unless we explicitly approve more. Tart and Orchard publish Fair Source/free-tier terms; treat the free-tier CPU-core and worker limits as planning constraints and re-check your company's use case before treating Tart as an enterprise standard.

Recovery path:

- Show the UTM template artifact.
- Show a pre-created UTM VM.
- Move on rather than debugging UTM live.

### Demo 4: Gatekeeper Rollback Loop, 57:00-70:00

Goal: prove risk-free policy testing with a coherent app-break and rollback story.

Start state:

- VM at `Post-Enroll-Baseline`.
- Device already enrolled in the demo tenant.
- Visual Studio Code installed, not launched, and accepted by `spctl`.
- Recent sync completed.
- Evidence script ready.
- Evidence output redaction already tested.

Stage setup:

> In production, this is an Intune Settings Catalog profile. For stage reliability, the evidence you are about to see was captured from the VM during rehearsal so we are not waiting on live Intune timing.

The policy model is System Policy Control/Gatekeeper:

- Enable Assessment: enabled.
- Allow Identified Developers: disabled.

Primary live flow:

1. Show enrollment and baseline app-launch state.
2. Show the lab-only Intune Settings Catalog policy or the slide equivalent.
3. Restore or reveal `Broken-Policy-State`.
4. Run the Gatekeeper App-Store-only validation plan.
5. Show VS Code rejected by `spctl` on first launch and the captured block-dialog reference.
6. Disconnect VM networking as the stage control.
7. Restore `Post-Enroll-Baseline`.
8. Run the recovered validation plan.
9. Show `spctl` accepts VS Code and the app launches.
10. State clearly that the Intune assignment still needs report-only cleanup review before production expansion.

Example commands:

```powershell
Invoke-MacPolicyValidation `
  -Name 'mms-parallels-01' `
  -TestPlan './examples/TestCases/Gatekeeper-AppStoreOnly.yml' `
  -OutputPath './_evidence/runs/mms-demo4-gatekeeper-before' `
  -RedactSecrets:$true

Restore-MacLabVmCheckpoint `
  -Provider Parallels `
  -Name 'mms-parallels-01' `
  -CheckpointName 'Post-Enroll-Baseline'

Invoke-MacPolicyValidation `
  -Name 'mms-parallels-01' `
  -TestPlan './examples/TestCases/Gatekeeper-Recovered.yml' `
  -OutputPath './_evidence/runs/mms-demo4-gatekeeper-after' `
  -RedactSecrets:$true
```

Minimum evidence to show:

```text
PASS  MDM enrollment profile present
PASS  Gatekeeper assessment enabled
PASS  System Policy Control profile detected
FAIL  VS Code first launch blocked by App-Store-only policy (expected failure)
PASS  Blocking dialog captured
PASS  Evidence redaction applied
PASS  Rollback restored Post-Enroll-Baseline
PASS  VS Code accepted after rollback
WARN  Intune cloud assignment would still need report-only cleanup review before production expansion
```

Controlled failure options:

| Option | Reliability | Notes |
| --- | --- | --- |
| Pre-created `Broken-Policy-State` Gatekeeper checkpoint | Highest | Best stage path. Explain exactly what is broken. |
| Live lab-only Settings Catalog assignment | Medium | Compelling if started as a background thread and not used as the success dependency. |
| Lab-only compliance policy with deterministic failure | Backup | Keep only as supporting proof if Gatekeeper rehearsal fails. |
| Defender unhealthy fixture | Backup | Keep for accepted-takeaway support, not the live failure. |

Transition line:

> The accepted session promise includes FileVault and Defender, and we will show what evidence looks like for both. The live break-and-rollback path is Gatekeeper because it is the cleanest way to show the pattern without pretending cloud timing is instant.

Recovery playbook:

- If live Intune timing is slow, say the checkpoint pivot line and use `Broken-Policy-State`.
- If an already-launched app does not block after rehearsal, use the VS Code first-launch path and say the policy blocks the next newly introduced legitimate app.
- If rollback fails, stop and diagnose before the session; do not claim the rollback restores app launch until `spctl` accepts VS Code.
- If a secret appears on screen, stop, switch to redacted screenshots, and continue calmly.

## Wrap-Up: 71:30-74:30

### Dragons Checklist and Anti-Patterns, 71:30-72:25

Show a prebuilt triage table.

| Symptom | Likely cause | First check |
| --- | --- | --- |
| VM enrolls but policy never arrives. | APNs, network, assignment, or sync delay. | APNs connectivity, Company Portal sync, Intune check-in, group/filter membership. |
| FileVault evidence is confusing. | Escrow and encryption stages are not the same. | Intune encryption report plus `fdesetup status`. |
| Recovery key not visible. | Escrow not complete, device not corporate, role permissions, or wrong report path. | Encryption report, device ownership, RBAC, policy timing. |
| Recovery key appears on screen. | Evidence redaction failed. | Stop showing live output; switch to redacted screenshot or sanitized JSON. |
| Defender installed but unhealthy. | System extension, network extension, Full Disk Access, or onboarding missing. | `mdatp health`, system extension list, PPPC profile. |
| VS Code is blocked. | Gatekeeper/System Policy Control App-Store-only policy is active and VS Code is launching for the first time. | `spctl --status`, `spctl --assess -vv`, profile receipt. |
| VS Code stays blocked after rollback. | Bad policy reapplied or the wrong checkpoint was restored. | Disconnect networking, restore `Post-Enroll-Baseline`, re-run `spctl --assess`. |
| Rollback causes duplicate/stale devices. | VM identity rolled back while cloud state moved forward. | Report-only cloud cleanup routine, then manual reconciliation. |
| Clones behave strangely. | MAC address, name, or identity collision. | Naming convention, clone settings, DHCP, device record. |
| Old guest no longer runs after host upgrade. | Host/provider compatibility changed. | Host version, provider release notes, restore image support. |
| UI prompts appear despite policy. | PPPC/TCC nuance or missing payload detail. | Bundle ID, code requirement, profile receipt, app logs. |
| Disk fills unexpectedly. | Snapshots and cached media sprawl. | Cleanup script and storage report. |

Explicit dragons to name:

- Apple ID and Setup Assistant friction.
- Host TCC permissions are app-specific.
- NAT vs. bridged networking.
- MAC address changes on clone.
- Host upgrade danger.
- Snapshot timing and MDM identity drift.
- FileVault escrow verification.
- Evidence redaction and recovery-key handling.
- PPPC/TCC prompt interpretation.
- Defender system extension and network extension approvals.
- Gatekeeper/System Policy Control app-execution controls.
- Disk and snapshot sprawl.

### Repo Handoff, Monday Plan, and Recap, 72:25-74:30

Show:

- QR code.
- URL: `https://github.com/franklesniak/macOSLab`.
- Repo tree.
- `docs/Start-Here.md` highlighted.
- `examples/MMSMOA-2026` highlighted.

Say:

> Your first Monday-morning target is not your entire Mac program. It is one risky policy, one VM, one evidence bundle, and one rollback.

Q&A rules:

- Raise your hand.
- Mic runner if needed.
- One question per person first.
- Follow-ups if time permits.
- Include hypervisor and enrollment method if relevant.

Keep the CFP recap slide in the core talk. It repeats the four accepted takeaways with green checkmarks and one-line delivery notes.

## Extended Q&A: 74:30-104:30

### Mechanics, 74:30-77:30

Leave the Q&A bucket slide up.

No live polling. No Q&A app. Raise hands only.

Say:

> We will answer with the pattern, the gotcha, what to automate, and where it lives in the repo.

### Q&A Buckets

Six buckets. Few enough that the slide is a real menu rather than a wall of text, broad enough that almost any reasonable question lands in one.

| Bucket | Example questions |
| --- | --- |
| Lab construction and lifecycle | How much RAM? Parallels or UTM? Do I need one host per macOS major version? How do I keep old builds across host upgrades? How do I size for two concurrent VMs? |
| Enrollment, tenant strategy, and cleanup | Demo tenant or production? How do I avoid stale Intune/Entra records after a rollback? What is the right teardown ritual? |
| Risky-policy validation | What can I prove for FileVault in a VM? How do I really test Defender? What is the PPPC nuance I keep missing? |
| Compliance and Conditional Access timing | Why does Intune say one thing and Entra another? How do I avoid waiting on CA during a live demo? |
| Evidence and change-board outputs | What do I attach to a change ticket? What does Log Analytics ingestion look like? How do I redact recovery-key proof safely? |
| CI, Tart, and inventory adjacencies | When do I move beyond desktop labs? Should I bridge any of this into ConfigMgr inventory? |

### Structured Answer Framework, 77:30-104:30

Use this pattern:

1. Restate the scenario.
2. Recommend an approach.
3. Name the gotcha.
4. Say what to automate.
5. Point to the repo path.

Example answer:

> If you are using a post-enroll snapshot, the fast loop is great for policy regression. The gotcha is that Intune and Entra do not roll back with the disk. In v1, use the report-only cleanup routine to identify stale records and manual cleanup steps. Retire, delete, wipe, or other cloud mutation behavior belongs in a later owner-approved Phase 10 change. The repo path is `docs/Snapshot-Strategy.md` plus `scripts/Reset-IntuneMacLabDevice.ps1`.

### Seed Questions if the Room Is Quiet

Use these if needed:

- "What is the scariest macOS policy in your environment right now?"
- "Who has a Mac policy that only one person on the team understands?"
- "Who has had compliance take longer than expected to show up?"
- "Who has a change board that wants more than 'the portal says assigned'?"
- "Who is trying to decide whether Tart belongs in a CI path?"

### Final Thank-You, 104:30-105:00

End with the QR code, speaker names, and one sentence of thanks.

Final line:

> The win is not that you have a Mac VM. The win is that your next scary Mac policy has somewhere safe to fail.

## Recommended Slide Skeleton

| Slide | Purpose | Time |
| --- | --- | --- |
| 1 | Title and speaker credibility. | 0:00 |
| 2 | CEO Mac scenario. | 1:00 |
| 3 | Risk map. | 3:00 |
| 4 | Windows-admin translation table. | 6:00 |
| 5 | Apple Silicon lab constraints. | 7:30 |
| 6 | Licensing and concurrency caution. | 9:00 |
| 7 | Restore images, compatibility, build pinning. | 10:30 |
| 8 | AVF vs. QEMU practical explanation. | 12:00 |
| 9 | Fidelity traffic light. | 13:30 |
| 10 | Hypervisor decision matrix. | 15:00 |
| 11 | Parallels path. | 18:00 |
| 12 | UTM path. | 20:30 |
| 13 | Tart as advanced path. | 23:00 |
| 14 | PowerShell provider model. | 24:30 |
| 15 | Snapshot taxonomy. | 27:00 |
| 16 | Demo rules and checkpoint philosophy. | 30:00 |
| 17 | Demo 1 title card. | 31:00 |
| 18 | Demo 2 title card. | 38:00 |
| 19 | Demo 3 title card. | 50:00 |
| 20 | Demo 4 setup: audit finding leads to Gatekeeper hardening. | 57:00 |
| 21 | System Policy Control model: App Store only vs. identified developers. | 58:30 |
| 22 | Demo 4 evidence: VS Code first launch blocked, `spctl` rejects, rollback restores. | During Demo 4 |
| 23 | FileVault and Defender proof boundaries: still required, not the live failure. | 68:00 |
| 24 | Dragons checklist updated for Gatekeeper and cloud state. | 70:00 |
| 25 | Repo tree and Start Here. | 72:25 |
| 26 | Monday plan and CFP recap. | 73:15 |
| 27 | Q&A buckets. | 74:30 |
| 28 | Final thank-you. | 104:30 |

## Windows-Admin Translation Cheat Sheet

Put this on one slide and ship it as `docs/Windows-Admin-Cheat-Sheet.md`.

| What Windows admins know | macOS lab equivalent | Point to make |
| --- | --- | --- |
| Hyper-V checkpoint | Parallels/UTM snapshot through `Checkpoint-MacLabVm` | Same safety habit, different provider. |
| Restore-VMCheckpoint | `Restore-MacLabVmCheckpoint` | Rollback is the emotional payoff. |
| Windows ISO / WIM | macOS restore image or provider-appropriate install artifact | Pin exact builds. |
| BitLocker recovery key escrow | FileVault recovery-key escrow | Verify escrow before broad rollout. |
| Group Policy / gpupdate | Intune sync and compliance re-evaluation | Timing is different; evidence matters. |
| ConfigMgr collection / Intune group | Intune assignment group/filter | Keep lab rings isolated. |
| Event Viewer / Get-WinEvent | `log show`, profile output, app logs | Use PowerShell to collect both worlds. |
| Defender health on Windows | `mdatp health` on macOS | Health evidence is more useful than "app exists." |
| AppLocker / WDAC / SmartScreen | Gatekeeper/System Policy Control and `spctl` | App execution policy can block legitimate signed/notarized apps when over-tightened. |
| Pester tests | Pester tests for Mac lab readiness and policy validation | Same testing idiom. |
| Change-ticket evidence | Redacted JSON/CSV/screenshots/log bundle | Make proof portable without leaking secrets. |

Verbal point:

> The language does not change. PowerShell 7.4+ is the conductor. The instruments change.

## GitHub Starter Kit

The repo should be real, runnable, and usable after the session.

### Recommended Repo Structure

```text
/src/Modules/MacLab
  MacLab.psd1
  MacLab.psm1
  Public/
    Get-MacLabMedia.ps1
    New-MacLabVm.ps1
    Get-MacLabVm.ps1
    Start-MacLabVm.ps1
    Stop-MacLabVm.ps1
    Checkpoint-MacLabVm.ps1
    Restore-MacLabVmCheckpoint.ps1
    Remove-MacLabVm.ps1
    Invoke-MacPolicyValidation.ps1
    Export-MacLabEvidence.ps1
  Private/
    Invoke-LoggedCommand.ps1
    Write-EvidenceRecord.ps1
    Resolve-MacLabConfig.ps1
    Protect-MacLabEvidence.ps1
  Providers/
    Parallels.ps1
    UTM.ps1
    Tart.ps1
/scripts
  Install-Prereqs.ps1
  Test-LabReadiness.ps1
  Get-MacOSRestoreImage.ps1
  New-MacInstallArtifact.ps1
  New-MacVm.ps1
  Checkpoint-MacVm.ps1
  Restore-MacVmCheckpoint.ps1
  Remove-MacVm.ps1
  Reset-IntuneMacLabDevice.ps1
  Send-LabEventToLogAnalytics.ps1
  Invoke-MMSDemo.ps1
/examples
  MMSMOA-2026/
    demo-config.yml
    Demo1-Media.ps1
    Demo2-Parallels.ps1
    Demo3-UTM.ps1
    Demo4-GatekeeperRollback.ps1
  TestCases/
    FileVault-Validation.yml
    Defender-Validation.yml
    Gatekeeper-AppStoreOnly.yml
    Gatekeeper-Recovered.yml
    Compliance-SmokeTest.yml
    PPPC-Validation.yml
  utm/
    macos-lab-template.utm
/docs
  Start-Here.md
  Prereqs.md
  Hypervisor-Decision-Guide.md
  Apple-Silicon-Constraints.md
  Provider-Version-Matrix.md
  Fidelity-Boundaries.md
  Snapshot-Strategy.md
  Intune-Tenant-Setup.md
  FileVault-Validation.md
  Defender-Validation.md
  PPPC-Validation.md
  Evidence-and-CAB.md
  Evidence-Redaction.md
  Windows-Admin-Cheat-Sheet.md
  Log-Analytics-Integration.md
  ConfigMgr-Inventory-Bridge.md
  CI-and-Tart.md
  Troubleshooting.md
  Demo-Runbook.md
/tests
  MacLab.Tests.ps1
  Providers.Parallels.Tests.ps1
  Providers.UTM.Tests.ps1
  Validation.FileVault.Tests.ps1
  Validation.Defender.Tests.ps1
/.github
  workflows/
    powershell-ci.yml
README.md
LICENSE
SECURITY.md
TODO-Phase-04-Media-Acquisition.md
TODO-Phase-05-Parallels-Provider.md
TODO-Phase-06-UTM-Provider.md
TODO-Phase-08-Validation-Loop.md
TODO-Phase-10-Deferred-Work.md
```

Naming note: the redaction helper is `Protect-MacLabEvidence.ps1` rather than `Redact-MacLabEvidence.ps1` because `Protect` is on the PowerShell approved-verbs list and `Redact` is not. PSScriptAnalyzer will flag unapproved verbs, and any attendee who imports the module would get a yellow warning at load time, which undermines the "real, runnable, professional" promise. The user-facing parameter on `Invoke-MacPolicyValidation` stays `-RedactSecrets` because parameter names are not bound by the approved-verbs rule.

Repository governance notes:

- The future repo is initialized from `franklesniak/copilot-repo-template`. Keep the inherited instruction, security, CI, issue-template, and linting files unless a later owner-approved implementation step says otherwise.
- `SECURITY.md` stays unchanged by default. A future implementation agent may propose only the narrow no-real-secrets/no-recovery-keys paragraph already approved in the spec, and only if it fits the inherited template file.
- Root per-phase TODO files are required only when that phase still has deferred work. Omit a TODO file if the phase has no remaining action items.
- `Reset-IntuneMacLabDevice.ps1` starts report-only in v1. It can identify stale cloud records and explain manual cleanup steps; it must not mutate cloud records unless a later Phase 10 change is explicitly approved.

### Minimum Viable Features

Ship these even if everything else is rough:

- `docs/Start-Here.md`
- Hypervisor decision guide.
- Provider version matrix.
- Snapshot strategy with cleanup warnings.
- One working Parallels path.
- One UTM example path or documented template path.
- FileVault validation notes.
- Defender validation notes.
- Evidence export example.
- Evidence redaction example.
- Pester 5.7.1 readiness test.
- PowerShell 7.4+ module manifest and CI path.
- GitHub Actions PowerShell CI using `macos-latest`; remove inherited Python CI only if no Python content remains.
- Troubleshooting table.
- Demo runbook.

### Test Cases Worth Calling Out

| Test case | What it proves |
| --- | --- |
| `FileVault-Validation.yml` | Policy receipt, local status capture, escrow evidence path, rollback note, and redacted recovery-key proof. |
| `Defender-Validation.yml` | System extension, network extension, Full Disk Access, onboarding, `mdatp health`. |
| `Gatekeeper-AppStoreOnly.yml` | System Policy Control profile receipt, `spctl` reject, VS Code first-launch block dialog reference, expected failure. |
| `Gatekeeper-Recovered.yml` | Rollback proof, `spctl` accept, VS Code launch recovery, cloud-assignment warning. |
| `PPPC-Validation.yml` | Bundle ID/code requirement/profile receipt/app behavior. |
| `Compliance-SmokeTest.yml` | Fast deterministic pass/fail loop before risky tests. |

### Evidence Output Example

```json
{
  "runId": "2026-05-mms-demo4-001",
  "vmName": "mms-parallels-01",
  "provider": "Parallels",
  "providerVersion": "<parallels-version>",
  "snapshot": "Post-Enroll-Baseline",
  "hostMacOS": "<host-macOS-version>",
  "guestMacOS": "<macOS-version>",
  "guestBuild": "<macOS-build>",
  "powerShellVersion": "<powershell-version>",
  "pesterVersion": "5.7.1",
  "intuneDeviceName": "MMS-MACLAB-001",
  "redactionApplied": true,
  "cloudStateWarning": "VM rollback does not rewind Intune, Entra, Defender portal state, audit logs, or reporting history.",
  "tests": [
    { "name": "MDM enrollment profile present", "result": "Pass" },
    { "name": "FileVault status captured", "result": "Pass" },
    { "name": "FileVault escrow evidence captured", "result": "Pass" },
    { "name": "FileVault recovery key value redacted", "result": "Pass" },
    { "name": "Defender health captured", "result": "Pass" },
    { "name": "VS Code first launch blocked by App-Store-only policy", "result": "Fail", "expectedFailure": true },
    { "name": "VS Code accepted after rollback", "result": "Pass" },
    { "name": "Rollback restored known-good VM checkpoint", "result": "Pass" },
    { "name": "Report-only cloud cleanup routine documented", "result": "Warn" }
  ]
}
```

## Risk-to-Dollars Speaker Notes

Do not overload the slide with numbers. Keep these in notes for conversational credibility.

### FileVault Failure on an Executive Mac

Possible impact:

- 2-6 hours of executive downtime.
- Tier-3 escalation.
- Security team involvement.
- Physical recovery if recovery-key escrow was not verified.
- IT credibility hit that lasts longer than the incident.

Speaker line:

> The reputational cost to IT is usually bigger than the technical fix.

### PPPC Misconfiguration

Possible impact:

- Remote support cannot control the screen.
- Recording fails during an important meeting.
- Accessibility-dependent tools stop working.
- EDR or backup agent loses needed access.

Speaker line:

> PPPC failures are quiet until the exact moment they become loud.

### Defender Misconfiguration

Possible impact:

- Endpoint appears protected but is unhealthy.
- SOC gets bad data.
- Network extension issues cause user pain.
- Full Disk Access gaps reduce visibility.
- False positives or missing signals create avoidable escalations.

Speaker line:

> Defender on macOS is not just "install the app." The profiles are the deployment.

### Compliance and Conditional Access

Possible impact:

- Outlook, Teams, SharePoint, or approval apps blocked.
- Helpdesk cannot explain why quickly.
- Change board loses trust.
- Business users see security as arbitrary.

Speaker line:

> Every one of these has a calendar event attached to it. Our job is to make sure the calendar event is a test run, not a Monday morning incident.

## Memorable Patterns and Anti-Patterns

### Patterns to Repeat

| Pattern | Meaning |
| --- | --- |
| Safe place to fail | The lab is where mistakes belong. |
| Pin, prove, rollback | The three-part demo rhythm. |
| Evidence beats vibes | Portal assignment is not proof by itself. |
| Windows instincts still work | Testing rings, checkpoints, and evidence still matter. |
| VM first, hardware last | Iterate in VM; sign off on real hardware where needed. |
| Redacted proof | Show that the state exists without leaking the secret. |

### Anti-Patterns to Name

| Anti-pattern | Meaning |
| --- | --- |
| Portal faith | Trusting "assigned" without device-side evidence. |
| Snapshot time travel | Rolling back the VM while forgetting cloud state moved forward. |
| Progress-bar theater | Spending stage time watching downloads or sync. |
| Executive pilot roulette | Using the CEO's Mac as the first real test. |
| Haunted device object | A stale Intune/Entra record that no longer matches the rolled-back VM. |
| Tool-vibe selection | Picking a hypervisor by feel instead of operating model. |
| Screenshot leak | Showing a recovery key, token, tenant secret, or real user detail because the evidence path was not redacted. |

Use these sparingly. They make the talk sticky.

## Presenter Notes for Hard Questions

### "Can this replace physical Mac testing?"

Answer:

> No. It reduces the number of mistakes that reach physical Mac testing. Use VMs for iteration, regression, payload validation, and evidence automation. Use physical hardware for final sign-off on hardware, enrollment, security, and user-experience paths.

### "Should I use Parallels or UTM?"

Answer:

> If you need the most polished local enterprise workflow and can buy a commercial tool, start with Parallels. If you need no-cost experimentation and can accept more template/configuration work, start with UTM. If you want CI image distribution and CLI-first runner workflows, look at Tart as a second phase.

### "Do I need three Macs to support every macOS version?"

Answer:

> Maybe. If you apply the same-major host/guest rule strictly and you need reliable coverage for macOS 14, 15, and 26 at the same time, plan for up to three Apple-silicon hosts, each running the matching host major version. New hardware may not boot older macOS releases, so an M5-era Mac may be a great macOS 26 host but a poor macOS 14 or 15 lab host. Conversely, a Mac mini M4-class host is useful for macOS 15 and can move to macOS 26, but it is not the answer for same-major macOS 14 coverage. Verify the specific Mac model against Apple's compatibility lists before buying lab hardware.

### "Why PowerShell instead of shell scripts?"

Answer:

> Use the language your Microsoft endpoint team already operationalizes. PowerShell is not the only way. It is the bridge that lets Windows-first Intune admins own the workflow without pretending they became Mac platform engineers overnight.

### "Can I test ADE in this lab?"

Answer:

> You can test pieces around enrollment and policy behavior, but zero-touch ADE behavior, serial-number-dependent flows, and production enrollment experiences need real hardware and ABM-connected test devices.

### "Can I trust FileVault results in a VM?"

Answer:

> Trust the VM for early iteration, policy receipt, evidence workflow, and regression. Use real hardware for final FileVault rollout sign-off, boot unlock experience, recovery process, and executive pilot readiness.

### "What about ConfigMgr?"

Answer:

> Treat ConfigMgr integration as reporting or inventory adjacency, not the primary control plane. The primary control plane for this session is Intune. If you want inventory, export lab metadata and decide whether it belongs in ConfigMgr, Log Analytics, or your CMDB.

### "Can I run more than two macOS VMs?"

Answer:

> Treat two concurrent macOS VMs per Apple-branded host as the relevant boundary to design around, and verify your organization's interpretation with legal/procurement. More hosts, not just bigger hosts, may be the scaling answer.

### "What if Intune takes too long during the demo?"

Answer:

> That is exactly why the lab uses checkpoints and evidence. Cloud timing is part of the system. We do not pretend it is instant; we design around it.

### "Does rollback make Intune forget the failure?"

Answer:

> No. Snapshot rollback restores the VM state. It does not erase Intune, Entra, Defender portal state, audit logs, or reporting history. The starter kit treats report-only cloud cleanup review as part of the lab lifecycle because otherwise you create stale cloud records that no longer match the restored VM.

### "Can you show the FileVault recovery key?"

Answer:

> Not on the projector. The proof we need is that escrow exists, the right role can retrieve it, access is audited, and the value is redacted in exported evidence.

## Final Rehearsal Checklist

### Two Weeks Before

- Freeze demo host macOS version.
- Freeze hypervisor versions.
- Freeze demo tenant policies.
- Update placeholder build values throughout the deck and demo configs to your actual pinned build.
- Publish repo privately or publicly enough to validate links.
- Run a full 75-minute core rehearsal plus a 30-minute Q&A drill.
- Record Demo 4 success path.
- Rehearse the break-glass narration over the recording at least once.
- Validate screenshots.
- Validate QR code and `https://github.com/franklesniak/macOSLab`.
- Confirm both speakers know handoffs.
- Confirm evidence redaction behavior.
- Confirm no full recovery key, token, secret, or private tenant detail appears in any public artifact.

### One Week Before

- Run the full deck at projected resolution.
- Validate font sizes.
- Confirm all checkpoints.
- Export evidence from a clean run.
- Test hotspot or fallback network.
- Confirm repo URL.
- Re-run `Test-LabReadiness.ps1`.
- Rehearse failure pivots.
- Re-check Parallels, UTM, Tart, Apple, and Microsoft documentation for any changed behavior or version notes.

### Day Before

- Disable auto-updates.
- Charge everything.
- Confirm local media cache.
- Confirm VMs start without prompts.
- Confirm Intune portal access.
- Confirm APNs/network path if possible.
- Close unrelated apps.
- Turn on Focus or Do Not Disturb.
- Confirm break-glass recording plays and the rehearsed narration still matches.
- Confirm evidence screenshots are redacted.

### In the Room

- Check projector scaling.
- Check terminal readability from the back if possible.
- Check mic handoff plan.
- Open all demo windows in order.
- Start from known snapshots.
- Keep Q&A bucket slide ready.
- Run T-15 smoke test.
- Do not improvise a new demo path.
- Do not show raw recovery-key, token, or secret output.

## Final Self-Check Before Locking the Deck

1. Every accepted takeaway maps to visible content.
2. FileVault is not just a scary intro story.
3. Defender validation is more than "app installed."
4. The Parallels demo does not depend on macOS Arm Coherence.
5. Media language says restore image or provider-appropriate artifact, not ISO as the default.
6. The media acquisition command uses `-Source Mist`, not `-Provider Mist`, to avoid overloaded terminology.
7. The media acquisition command or adjacent config explicitly states `arm64`.
8. The hypervisor matrix is a real operating-model comparison.
9. The fidelity traffic light is present.
10. Snapshot cleanup is documented.
11. Demo 4 says rollback restores the VM, not Intune/Entra/Defender cloud state or the Intune assignment.
12. The Windows-admin translation cheat sheet exists in the deck and the repo, and has its own minute on stage.
13. The repo URL resolves.
14. `Test-LabReadiness.ps1` returns green.
15. The break-glass recording exists, plays, and has been narrated against at least once.
16. Both speakers know who drives each segment.
17. At least three handoff lines have been rehearsed.
18. There is at least one seed question ready for Q&A.
19. The final line is memorized.
20. Gatekeeper fixtures and local visual assets have been checked for Team IDs, profile UUIDs, tenant identifiers, UPNs, device IDs, screenshots, recordings, and app bundles.
21. All angle-bracket placeholders in the deck and demo configs have been replaced with the pinned values for the event. The full set is `<macOS-version>`, `<macOS-build>`, `<host-macOS-version>`, `<parallels-version>`, `<utm-version>`, `<powershell-version>`, `<defender-version>`, and `<policy-set-version>`.
22. All screenshots, recordings, logs, and evidence examples have been redacted.
23. Tenant names, tenant domains, UPNs, device IDs, serial numbers, recovery keys, tokens, and secrets are masked anywhere they appear.
24. All `.md` filename references in the runbook and any derivative artifacts render as plain inline code, not as auto-converted hyperlinks.
25. The redaction helper in the module is named `Protect-MacLabEvidence.ps1` (approved verb), and PowerShell tooling reports no verb warnings on module import or analysis.

## Source Notes to Re-Check Before the Event

Re-check these close to the event because Apple, Parallels, UTM, Tart, and Microsoft Intune change quickly.

- Apple Software License Agreements.
- Apple Developer Virtualization framework documentation.
- [Apple Support: How to download and install macOS](https://support.apple.com/en-us/102662), especially the compatibility and installer-download notes that macOS versions must be compatible with the Mac and no earlier than the version that came with it.
- Apple Support APNs and enterprise network requirements.
- Apple Platform Deployment PPPC payload documentation.
- Apple Platform Security notes for FileVault and Secure Enclave behavior.
- [Parallels CLI: Create a Virtual Machine](https://docs.parallels.com/landing/parallels-desktop-developers-guide/command-line-interface-utility/manage-virtual-machines-from-cli/general-virtual-machine-management/create-a-virtual-machine), especially the same-major host/guest note for Apple Silicon macOS VMs.
- [Parallels KB 128867: Known limitations of macOS virtual machines on Mac computers with Apple silicon](https://kb.parallels.com/en/128867), especially Apple Virtualization framework limits, snapshots, USB, networking, and higher-than-host guest warnings.
- [UTM macOS guest support](https://docs.getutm.app/guest-support/macos/), especially Apple Virtualization requirements and IPSW guidance.
- [UTM Apple backend settings](https://docs.getutm.app/settings-apple/settings-apple/), especially the note that Apple Virtualization is the only UTM path for virtualized macOS on Apple Silicon.
- [Tart documentation](https://tart.run/) and license.
- mist-cli documentation.
- Microsoft Learn: macOS management in Intune.
- Microsoft Learn: FileVault with Intune.
- Microsoft Learn: Defender for Endpoint on macOS with Intune.
- Microsoft Learn: Defender macOS system extension and network extension troubleshooting.
- Microsoft Learn: Defender `mdatp health` output and troubleshooting.
- PowerShell approved verbs reference (verify any cmdlet rename against the current list).
