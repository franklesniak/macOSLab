<!-- markdownlint-disable MD013 -->
# Slide Contents — MMSMOA 2026: Don't Brick the CEO's Mac

## Metadata

- **Status:** Draft
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-06
- **Scope:** Slide-content artifact for the MMSMOA 2026 macOSLab session. Defines every slide in the deck, in stage order, with visual concepts, talking points, memorable lines, speaker handoffs, and transitions. A reader should be able to build the full deck from this document alone.
- **Related:** [CFP Submission](macOS-imaging-01a-CFP-submission.md), [Bolstered Outline](macOS-imaging-03a-bolstered-outline.md), [Repository Specification](../spec/macOSLab-repository-spec.md), [Demo Runbook](../Demo-Runbook.md)

## How This Document Is Organized

This document defines every slide in the deck, in stage order. Each slide entry includes:

- **Time on stage** is a wall-clock target measured from session start.
- **Driver / narrator** identifies who is at the keyboard and who is the conversational partner. Default is Frank as driver and Michael as narrator unless noted.
- **Visual concept** describes what the slide looks like at enough detail to brief a designer or to execute it directly in PowerPoint or Keynote.
- **Talking points** are ideas to deliver, written as substance rather than scripts.
- **Memorable line** is the single sentence that should make it into attendees' notes.
- **Transition cue** is the bridge to the next slide, often a planned handoff line.

After the slide-by-slide section, the appendices include:

- A **summary slide index** for fast lookup.
- An **appendix slides** catalog for questions and answers (Q&A) and recovery paths.
- A **memorable lines anthology** that lists every callout in stage order, so the speakers can rehearse cadence as a separate exercise.
- A **speaker handoff script** that names the planned handoff line for every transition.

## Deck Rules

The deck obeys the following rules. They are restated here so this document stands on its own:

- The session is framed as Intune risk reduction. Virtualization is the substrate, not the topic.
- The core talk targets **74:30** and may be compressed to 60 minutes by trimming optional wrap-up beats and using appendix slides during questions and answers (Q&A). The extended Q&A gets a dedicated 30-minute block, followed by a 30-second thank-you.
- FileVault, Defender, Privacy Preferences Policy Control / Transparency, Consent, and Control (PPPC/TCC), Compliance / Conditional Access (CA), and app execution control are the five risk categories the deck visibly addresses.
- No live demo depends on venue Wi-Fi, fresh Intune sync, or live cloud timing as the only success path. Every cloud-dependent moment has a checkpoint, screenshot, and recording fallback.
- No slide, recording, or screenshot ever shows a real recovery key, tenant ID, user principal name (UPN), device ID, serial number, Team ID, profile universally unique identifier (UUID), app secret, token, or production identifier. Pre-redacted screenshots and synthetic fixture data only.
- Every rollback slide and every FileVault slide repeats the cloud-state warning either visually or verbally: snapshot rollback restores the virtual machine (VM), not Intune, Entra, Defender portal state, audit logs, or assignments.
- Section dividers exist on purpose. They give the audience a moment to breathe, the speakers a moment to hand off, and the deck a sense of pace.
- All slides use a consistent layout grid: title bar, content, and a footer strip showing the section name, time mark, and slide number.
- A small recurring visual motif — the **REDACTED stripe** — appears anywhere a value is masked. It also appears, smaller and in the corner, on every rollback-related slide as a quiet reminder that cloud state does not roll back with the disk.

## CFP Coverage Map

| Accepted takeaway | Slides that deliver it |
| --- | --- |
| Analyze Apple-silicon virtualization constraints and select the appropriate hypervisor (Parallels vs. UTM) that aligns with your budget and automation needs. | 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 |
| Construct a fully automated, reproducible macOS test lab using PowerShell 7 to fetch restore images / install media and control virtual machine (VM) states. | 11, 18, 19, 20, 21, 22, 23, 24, 25 |
| Execute end-to-end validation of high-risk policies (FileVault, Defender) by enrolling, breaking, and rolling back virtual machines (VMs) via script. | 26, 27, 28, 29, 30, 31, 32 |
| Implement the provided GitHub starter kit immediately to bridge the gap between Windows automation skills and macOS requirements. | 6, 7, 36, 37, 38 |

## Visual Language and Iconography

To keep the deck visually coherent, the following icon set should be used consistently across slides. None of these are copyrighted characters, real product logos, or licensed media.

| Concept | Icon / visual treatment |
| --- | --- |
| Risk / break | Caution-triangle outline; orange or red accent. |
| Safety / lab | Shield outline with a small wrench inside. |
| Snapshot / checkpoint | Camera shutter, or a layered-disk stack. |
| Rollback | Curved arrow looping backward. |
| Reproducibility | Two interlocking circular arrows, identical, paired with a small fingerprint dot to signal "the same, every time." |
| Evidence / receipt | Folder or document stack with a clear "REDACTED" stripe across one example. |
| Cloud state | Cloud outline with a small clock, signaling eventually consistent. |
| Provider abstraction | Three plain blocks stacked under one shared cap. |
| Bridge (Windows to macOS) | Two pillars labeled "Windows" and "Mac" with a beam between them; on the beam sits a small "PowerShell 7.4+" badge. |
| Anti-pattern (haunted device) | Plain cartoon-ghost outline. |
| Anti-pattern (time travel) | Calendar pages flying backward. |
| Honesty / boundary | Solid horizontal line with "Virtual Machine (VM)" above and "Hardware" below. |
| Traffic light (fidelity) | Three stacked dots, green, yellow, red, with crisp labels. |
| First victim (persona) | Tiny stick-figure-style avatar in a colored badge: a tie for the executive, a headset for the helpdesk, a magnifying glass for the security analyst, a code chevron for the developer, a shopping-cart-style icon for the revenue user. |
| Cloud rollback warning | A small "cloud + arrow + redacted-bar" composite that appears in the corner of every rollback-related slide. |

Color palette: a neutral dark background, a single accent color (suggested: a desaturated teal), green/yellow/red used only for the fidelity traffic light, and a dedicated "REDACTED" black bar treatment that appears anywhere a value is masked.

The **REDACTED stripe** doubles as the deck's structural motif. It appears on the FileVault and Defender evidence slides, on the redaction-in-action slide, and as a small corner mark on every slide that depicts a rollback. This makes the cloud-state warning visible to anyone scanning the deck as well as anyone listening.

---

## Slide-By-Slide Content

### Slide 1 — Title and Speaker Identity

- **Time on stage:** 0:00 to 0:45
- **Driver / narrator:** Both speakers on stage; Frank opens.
- **Visual concept:** Small expansion line above the title: *CEO = chief executive officer.* Title left-aligned, very large: **Don't Brick the CEO's Mac.** Subtitle below: *Building and Automating macOS Labs for Risk-Free Policy Testing.* Bottom-right: small headshots, names, roles, and the company affiliations as they appear on Sched. Bottom-left: the session room, day, and time. A faint **Midwest Management Summit at the Mall of America (MMSMOA) 2026** wordmark sits at the bottom edge. No logos that are not ours.
- **Talking points:**
  - Two-sentence introductions only. Full bios live in Sched.
  - Frank: lab automation and PowerShell ownership today.
  - Michael: Intune, enrollment, and policy behavior ownership today.
  - "We picked two speakers because no single answer fully resolves a Mac question. Interrupt each other on purpose."
- **Memorable line:** *"Two speakers, one safety net."*
- **Transition cue:** "Before we go anywhere technical, here is why anyone in this room should care about the next 75 minutes plus questions and answers."

### Slide 2 — The Executive Mac Hook

- **Time on stage:** 0:45 to 3:00
- **Driver / narrator:** Frank narrates; Michael adds the enterprise reality beat.
- **Visual concept:** A split frame. **Left two-thirds:** a closed laptop on an executive desk with a faintly visible FileVault-style unlock screen mocked up. No real recovery key value; a generic prompt and a black redaction bar where the key would appear. **Right one-third:** a stylized phone screen, vertical, showing a stack of notifications climbing in urgency: a missed call from "chief financial officer," a calendar reminder reading "Board call in 30 min," and a text bubble in italics: *"My laptop will not let me in."* No photo of a real person. No real names.
- **Talking points:**
  - You would not ship a BitLocker policy to the chief executive officer's (CEO's) Windows laptop without testing recovery.
  - Many organizations are still shipping FileVault, Privacy Preferences Policy Control (PPPC), and Defender to Macs with a fraction of that confidence.
  - This is not a Mac problem. It is a process gap.
  - Production is the worst possible place to discover that gap.
  - The cost is not just the laptop. It is the calendar event the laptop owns: the board call, the keynote, the customer demo, the close-of-quarter approval.
- **Memorable line:** *"Production is a terrible place to discover your Mac policy assumptions."*
- **Transition cue:** "Here is what we want you to walk out of this room with."

### Slide 3 — Session Takeaways

- **Time on stage:** 3:00 to 4:15
- **Driver / narrator:** Both speakers alternate the reads. Frank reads 1 and 3. Michael reads 2 and 4.
- **Visual concept:** Header at the top: **Session Takeaways.** Below, four numbered cards in a single vertical stack, each showing the takeaway verbatim from the call for presentations (CFP) submission. Each card has a left-edge color stripe in the deck's accent color. The fourth card's left-edge stripe is half-transparent to signal the "optional" framing in the CFP. A footer line in small caps reads: *Midwest Management Summit at the Mall of America (MMSMOA) 2026 accepted abstract.*
  1. **Analyze the virtualization constraints of Apple Silicon and select the appropriate hypervisor (Parallels vs. UTM) that aligns with your budget and automation needs.**
  2. **Construct a fully automated, reproducible macOS test lab using PowerShell 7 to fetch restore images / install media and control virtual machine (VM) states.**
  3. **Execute end-to-end validation of high-risk policies (FileVault, Defender) by enrolling, breaking, and rolling back virtual machines (VMs) via script — keeping production safe.**
  4. **Implement the provided GitHub starter kit immediately to bridge the gap between your Windows automation skills and macOS requirements.**
- **Talking points:**
  - "These four sentences came directly from the abstract you saw in Sched. We are going to deliver against each one."
  - For takeaway 1: this is the constraints and tool-choice work in the next 15 minutes.
  - For takeaway 2: this is the PowerShell module and the first three demos. Pay close attention to the word *reproducible*. We will name what that means in concrete terms.
  - For takeaway 3: this is the live break-and-rollback demo plus the FileVault and Defender evidence walkthroughs.
  - For takeaway 4: the repository is public, the repo link is at the end of the deck, and you will leave with a starter kit.
- **Memorable line:** *"Four objectives. We will check them off in front of you."*
- **Transition cue:** "Here is the route we will take to get there."

### Slide 4 — Agenda

- **Time on stage:** 4:15 to 4:45
- **Driver / narrator:** Frank.
- **Visual concept:** A single vertical timeline on the left edge of the slide, with eight labeled stops. Each stop has the section name only, with no minute ranges shown. The timeline has a small "you are here" marker pointing at item 1. The right two-thirds of the slide are intentionally empty so the eye stays on the timeline.
  1. **Why this matters: risk map and Windows translation**
  2. **Constraints that drive lab design**
  3. **Choosing a hypervisor: Parallels and UTM**
  4. **The PowerShell automation layer**
  5. **Live demos: pin, build, swap, break, roll back, prove**
  6. **Wrap-up: dragons, the kit, the Monday plan, recap**
  7. **Extended questions and answers (Q&A)**
  8. **Thank-you and close**
- **Talking points:**
  - "Most of the core talk goes to the demos. The first 30 minutes set you up to read those demos correctly."
  - "We are going to keep moving. If you have a question and we are not on it, hold it for the questions-and-answers buckets at the end."
- **Memorable line:** None.
- **Transition cue:** "Risk map first. What can actually go wrong on a managed Mac?"

### Slide 5 — The Risk Map

- **Time on stage:** 4:45 to 6:30
- **Driver / narrator:** Frank drives; Michael adds the "leadership notices" beat for each row.
- **Visual concept:** Five-row table with column headers: **Risk**, **What breaks**, **First person who notices**, **Why leadership notices**. Each row carries two icons in its leftmost cells: a category icon (key for FileVault, privacy lock for Privacy Preferences Policy Control / Transparency, Consent, and Control (PPPC/TCC), shield for Defender, "no entry" for App Execution Control, checkbox-with-clock for Compliance / Conditional Access (CA)) and a small persona icon naming the first human victim (the chief executive officer (CEO), the helpdesk, the security analyst, the developer, the revenue user). The first column is bolded.
- **Talking points (one beat per row, do not read the table):**
  - **FileVault:** unlock, recovery, escrow, prompts. The chief executive officer (CEO) lockout is the canonical failure. The first call goes to the helpdesk; the third call goes to your director.
  - **Privacy Preferences Policy Control / Transparency, Consent, and Control (PPPC/TCC):** required tools cannot access protected data. Screen recording, accessibility, endpoint detection and response (EDR), backup, and remote support are the usual victims. The user notices first, often in front of customers.
  - **Defender:** system extension, network extension, Full Disk Access, onboarding. Looks installed; is not healthy. The security operations center (SOC) notices first, from missing data.
  - **App Execution Control (Gatekeeper / System Policy Control):** an over-tightened policy blocks legitimate signed and notarized apps. This is the one we will break live today. Developers notice first; their managers notice second.
  - **Compliance / Conditional Access (CA):** users lose Outlook, SharePoint, Teams, approvals. Whoever was about to send an invoice notices first.
- **Memorable line:** *"Every one of these has a calendar event attached. Our job is to make sure the calendar event is a test run, not a Monday morning incident."*
- **Optional 10-second calibration:** "Quick hand raise. Who manages Macs in Intune today?" Use once. Do not poll the room repeatedly.
- **Transition cue:** "If you are sitting here thinking 'I already test risky Windows policies. Why is the Mac side fragile?' — good. That is the bridge we are about to build."

### Slide 6 — Where Your Windows Instincts Already Apply

- **Time on stage:** 6:30 to 7:15
- **Driver / narrator:** Frank.
- **Visual concept:** A "bridge" illustration spanning the slide. Left pillar labeled **Windows lab habits**, right pillar labeled **macOS lab habits**. A small **PowerShell 7.4+** badge sits on the beam between the pillars. Five pairs of words stack vertically across the bridge in matching positions: *Hyper-V checkpoint ↔ Parallels/UTM snapshot*, *Restore-VMCheckpoint ↔ Restore-MacLabVmCheckpoint*, *Group Policy + gpupdate ↔ Intune sync + compliance re-evaluation*, *AppLocker / Windows Defender Application Control (WDAC) / SmartScreen ↔ Gatekeeper and `spctl`*, *Pester tests ↔ Pester tests (same idiom)*.
- **Talking points:**
  - Your Windows lab instincts are still right. The grammar is the same: checkpoint, apply, observe, roll back, document.
  - The conductor stays the same: PowerShell 7.4 or newer.
  - Only the instruments change.
  - Mac testing is the same discipline with different application programming interfaces (APIs), not a different discipline.
- **Memorable line:** *"PowerShell is the conductor. The instruments change."*
- **Transition cue:** "The next slide adds the rows that do not have a clean Windows analogue."

### Slide 7 — Translation Cheat Sheet

- **Time on stage:** 7:15 to 8:00
- **Driver / narrator:** Frank; Michael chimes in on BitLocker → FileVault and Defender Windows → Defender macOS.
- **Visual concept:** Three-column table with header **What Windows admins know / macOS lab equivalent / Point to make**. Show six high-signal rows only: BitLocker → FileVault, Hyper-V checkpoints → Parallels/UTM snapshots, Group Policy / `gpupdate` → Intune sync and compliance re-evaluation, AppLocker / Windows Defender Application Control (WDAC) / SmartScreen → Gatekeeper and `spctl`, Defender health → `mdatp health`, and Pester tests → Pester tests. Footer note in small type: *"The full cheat sheet is `docs/Windows-Admin-Cheat-Sheet.md` in the repo. Do not copy it. Clone the kit."*
- **Talking points:**
  - Walk only three rows out loud. The slide signals the translation pattern; the repo carries the full table.
  - Highlight: BitLocker recovery to FileVault recovery. Event Viewer to `log show` plus profile output. AppLocker / Windows Defender Application Control (WDAC) to Gatekeeper.
  - Promise: this table reappears in the repo so you do not have to remember it.
- **Memorable line:** *"You do not need new instincts. You need a translator."*
- **Transition cue:** "The bridge is real. It is not free. Apple-silicon labs come with constraints that decide what is actually buildable. Michael, take it."

### Slide 8 — Section Divider: Constraints That Drive Lab Design

- **Time on stage:** 8:00 to 8:15
- **Driver / narrator:** Michael.
- **Visual concept:** Full-bleed dark slide. Centered text in large type: **Part 1 — Constraints That Drive Lab Design.** Below in small caps: *"What is true on Apple Silicon, and what that means for your lab."* Tiny progress bar across the bottom showing 1 of 4. In the upper right corner, in small type: *"Things we are not promising: Automated Device Enrollment / Apple Business Manager (ADE/ABM) zero-touch, Platform single sign-on (SSO) unlock, Touch ID, Secure Enclave-dependent behavior, executive pilot sign-off. Those still need real hardware."* This is a quiet boundary statement, not a centerpiece.
- **Talking points:**
  - "Two sentences before we get into the architecture. There are things a virtual machine (VM) lab can prove and things it cannot. The corner of this slide names what we are not promising you. We will name it again on the fidelity slide."
- **Memorable line:** None.
- **Transition cue:** Pause two beats. Click forward.

### Slide 9 — Apple Silicon Is Not Hyper-V

- **Time on stage:** 8:15 to 10:00
- **Driver / narrator:** Michael drives; Frank asks the Windows-admin translation questions.
- **Visual concept:** Side-by-side comparison panels. Left panel labeled **Windows lab mental model** with a small stack: hardware → Hyper-V/VMware → guest, and bullet annotations *"Any guest. Bridged everywhere. Snapshot anything."* Right panel labeled **Apple Silicon reality** with: hardware → host macOS → Apple Virtualization framework → macOS guest, and annotations *"macOS guests on Apple Silicon use Apple's Virtualization framework. Same-major host/guest is the safest default. Some host integrations do not apply."* A small footnote ribbon underneath both panels reads: *"Not a 'Macs are weird' slide. An architecture slide."*
- **Talking points:**
  - On Apple Silicon, virtualized macOS guests run on Apple's Virtualization framework. Parallels, UTM for macOS guests, and Tart all sit on top of it.
  - The host macOS version constrains which guest macOS versions are practically supported. Same-major host and guest is the path with the strongest vendor guidance today.
  - This is not a "Macs are weird" slide. It is an architecture slide. Apple intentionally designed virtualization this way.
- **Memorable line:** *"Treat your lab Mac like a build server. Do not auto-upgrade it the day before a regression cycle."*
- **Transition cue:** "The architecture has a licensing wrinkle that Windows admins are not used to."

### Slide 10 — Licensing: The Two-Guest Boundary

- **Time on stage:** 10:00 to 11:00
- **Driver / narrator:** Michael; Frank reinforces the "not legal advice" line.
- **Visual concept:** A single Apple-branded host illustration (generic Mac silhouette, not a branded image) with two small "macOS virtual machine (VM)" boxes hovering above it. A faint third VM box is shown crossed out, with a small "+ legal review" annotation pointing at it. Footer: *"Not legal advice. Verify your organization's interpretation."*
- **Talking points:**
  - Apple's macOS software license permits limited additional virtual instances of macOS on Apple-branded hardware for permitted purposes.
  - For this deck and starter kit, design around no more than two concurrent macOS guests per Apple-branded host unless your organization verifies a different license posture.
  - "Permitted purposes" matters. Software development, testing during development, macOS Server, and personal non-commercial use are typical examples in the software license agreement (SLA).
  - This is friendlier than Windows licensing in some respects. It does not mean every enterprise automatically gets unlimited macOS test virtual machines (VMs) for any purpose.
  - If you need wider coverage, the answer is more hosts, not bigger hosts.
- **Memorable line:** *"The licensing story is friendlier than Windows licensing in some ways. The engineering constraints are where the real design work starts."*
- **Transition cue:** "Now the version pinning that turns 'works on my Mac' into evidence."

### Slide 11 — Pin the Build, Cache the Artifact

- **Time on stage:** 11:00 to 12:30
- **Driver / narrator:** Frank.
- **Visual concept:** A flow with three labeled boxes: **Pinned version + build** → **Restore image / install artifact (cached)** → **Reproducible virtual machine (VM)**. Underneath the cached box, a small file-listing snippet (synthetic, no real path):
  - `_evidence/media/<macOS-version>-<macOS-build>/`
  - `metadata.json`
  - `acquisition.log`
  - `checksum.txt`

  In the lower right, the **reproducibility icon** (two interlocking circular arrows with a fingerprint dot) sits beside a one-line callout: *"Reproducibility = same inputs, same outputs, every run."*
- **Talking points:**
  - Reproducibility is the word in Takeaway 2. This slide is what it means concretely. A pinned version, a pinned build, a cached artifact, a recorded checksum, and a metadata sidecar.
  - For Apple-silicon Mac virtual machines (VMs), the practical artifact is a restore image (`.ipsw` file), not a bootable installer disk image. Docs that default to the installer-disk path confuse the Apple-silicon workflow.
  - Cache the artifact, record the checksum, and reuse across runs. Conference Wi-Fi is not the place to download macOS.
  - Treat the metadata sidecar as evidence, not a convenience.
  - The practical payoff: every change-board ticket can answer the question "which build did you test on?" without anyone checking Slack history.
- **Memorable line:** *"If you cannot say which macOS build you tested, you cannot say what your test means."*
- **Transition cue:** "Once you have pinned a build, the fidelity question becomes: what can a virtual machine actually prove?"

### Slide 12 — The Fidelity Traffic Light

- **Time on stage:** 12:30 to 14:30
- **Driver / narrator:** Michael; Frank reinforces the Red bucket.
- **Visual concept:** The slide is a literal traffic light on the left third. Three large circles, top red, middle yellow, bottom green, with the active circle at any given moment subtly glowing. To the right, three labeled blocks aligned to the lights:
  - **Green (virtual machine (VM) is sufficient on its own):** profile receipt; Gatekeeper and `spctl` assessment; Defender health checks; rollback routines; evidence export.
  - **Yellow (VM iteration, then physical sign-off):** FileVault rollout behavior; recovery-key process end to end; user prompts; performance-sensitive Defender behavior.
  - **Red (physical hardware required):** Automated Device Enrollment / Apple Business Manager (ADE/ABM) zero-touch; Platform single sign-on (SSO) sign-in and unlock; Touch ID; Secure Enclave-dependent behavior; final executive pilot sign-off.

  Beneath the traffic light, three small "where it lives" tags: *"Demo 4 (Gatekeeper) is Green. FileVault rollout is Yellow. Executive pilot sign-off is Red."* These tags anchor the abstract model to specific demos the audience is about to see.
- **Talking points:**
  - This is the credibility slide. If your lab cannot tell you what it cannot prove, it is not a lab. It is a superstition with screenshots.
  - Read the row labels, not every example.
  - The Red row is the honesty contract with your change board: we will tell them what is still required on real hardware.
  - Hold the colors in your head. Every demo this afternoon will land in one of these three buckets, and we will say which one.
- **Memorable line:** *"A lab that cannot tell you what it cannot prove is not a safe lab."*
- **Transition cue:** "Hold that traffic light in your head. We are going to come back to it every time we make a tool decision."

### Slide 13 — The Hardware Math

- **Time on stage:** 14:30 to 15:30
- **Driver / narrator:** Frank.
- **Visual concept:** A simple matrix with three rows (one per supported macOS major version: 14.x, 15.x, 26.x) and two columns: **Same-major host needed** and **Hardware planning note**. The cells are short:
  - macOS 14.x guest, 14.x host: "Older Apple-silicon Mac that can boot 14."
  - macOS 15.x guest, 15.x host: "Mac mini M4-class is reasonable."
  - macOS 26.x guest, 26.x host: "M5-era hardware works; older Macs may not."

  Below the table, a one-line callout in slightly larger type: *"Newer hardware is not always better lab hardware. New Macs may not boot old host macOS."* In the lower right, a small "shopping cart with a question mark" icon points to the hardware planning note.
- **Talking points:**
  - The stage-friendly simplification: one good host can carry a single demo.
  - The enterprise-lab truth: if you must validate every supported macOS major version simultaneously, you may need a small host fleet.
  - Newer hardware is not automatically a better lab host. It might not boot the older host macOS you need for older guest coverage.
  - This is also the slide where lab-procurement requests originate. Use it.
- **Memorable line:** *"Same-major coverage is a host-fleet problem, not a disk-space problem."*
- **Transition cue:** "Constraints understood. Time to choose a tool."

### Slide 14 — Section Divider: Choose Your Hypervisor

- **Time on stage:** 15:30 to 15:45
- **Driver / narrator:** Frank.
- **Visual concept:** Full-bleed dark slide. **Part 2 — Choose Your Hypervisor.** Subtitle: *"Choose by operating model. Not by vibes."* Progress bar 2 of 4.
- **Talking points:** None on stage.
- **Memorable line:** None.
- **Transition cue:** Click.

### Slide 15 — The Hypervisor Decision (Headline View)

- **Time on stage:** 15:45 to 18:00
- **Driver / narrator:** Frank drives; Michael challenges tradeoffs.
- **Visual concept:** Three columns side-by-side, equal width, each topped with the tool name and a one-line positioning statement: **Parallels Desktop Pro/Business: polished commercial workflow.** **UTM: free experimentation path.** **Tart: command-line interface (CLI)-first automation, future continuous integration (CI).** Below each tool, a "best fit" sentence in italics. A small decision-tree arrow at the bottom routes from three plain questions — *"Have a tool budget?"*, *"Want command-line image distribution?"*, *"Need a free experimentation path?"* — to the correct column. The decision tree is small enough to ignore for someone reading from the back, and useful enough to photograph from the front.
- **Talking points:**
  - "We are not picking the best product. We are picking the operating model that makes safe behavior easiest for your team."
  - Parallels is the polished primary path because the demo gear has to be reliable on stage.
  - UTM is a serious option, especially when there is no tool budget. It is not a toy.
  - Tart is the future continuous-integration (CI) conversation, not today's primary path.
  - VMware Fusion is not in the core comparison because current Broadcom documentation does not support Arm macOS as a Fusion guest on Apple silicon. It can still matter for Windows or Linux Arm virtual machines (VMs); it is not the macOS guest lab path for this talk.
- **Memorable line:** *"Choose the tool that makes the safe behavior easiest for your team."*
- **Transition cue:** "Now the specifics."

### Slide 16 — The Decision Matrix

- **Time on stage:** 18:00 to 21:00
- **Driver / narrator:** Frank drives; Michael keeps it Intune-relevant.
- **Visual concept:** Compact three-column matrix with row labels in the leftmost column. Rows: **Cost / Admin user experience (UX) / Automation surface / Snapshots and clones / Provider guardrails / Stage reliability / Procurement story / continuous integration (CI) path.** Each cell is 4 to 8 words. Use checkmark, dash, and asterisk symbols sparingly to denote "strong / partial / future." Bottom-right: a small icon legend.
- **Talking points (drive 3 to 4 rows max out loud):**
  - Cost: Parallels is paid; UTM is free; Tart is Fair Source with published free-tier limits. Orchard adds its own worker limit.
  - Automation surface: `prlctl` is strong for many lifecycle ops; `utmctl` exists but is partial; Tart is automation-first.
  - Provider guardrails: same-major host/guest compatibility and isolation verification are part of the tool decision, not fine print.
  - Stage reliability: Parallels is the safest live demo bet today.
  - Procurement story: Parallels is an easier line item; UTM lives in the "no budget" world; Tart is a roadmap conversation.
- **Memorable line:** *"Parallels for polish. UTM when budget is the constraint. Tart when automation is the goal."*
- **Transition cue:** "Now I will show you why we built one PowerShell automation model on top of all three."

### Slide 17 — Section Divider: The Automation Layer

- **Time on stage:** 21:00 to 21:15
- **Driver / narrator:** Frank.
- **Visual concept:** Full-bleed dark slide. **Part 3 — The Automation Layer.** Subtitle: *"PowerShell is the operator interface. Providers are engines."* Progress bar 3 of 4.
- **Memorable line:** None.
- **Transition cue:** Click.

### Slide 18 — One Operator Interface, Three Engines

- **Time on stage:** 21:15 to 23:00
- **Driver / narrator:** Frank.
- **Visual concept:** A layered diagram. Top layer: a single block labeled **`MacLab` PowerShell module** with the ten public cmdlet names as tags. Middle layer: three smaller blocks labeled **Parallels provider**, **UTM provider**, **Tart provider (stub)**. Bottom layer: three engine icons labeled **`prlctl`**, **`utmctl` and templates**, **`tart`**. A thin horizontal arrow on the right edge of the diagram is labeled *"swap engines, keep the operator interface"* — it visually anchors the abstraction promise.
- **Talking points:**
  - One operator interface — the public cmdlets — sits above three provider implementations.
  - The abstraction does not pretend providers are identical. It surfaces capability gaps with explicit "manual step required" errors when needed.
  - This is the key reason a Windows-admin audience can adopt this kit. The cmdlet names look like the Windows verbs they already use.
- **Memorable line:** *"The boundary is not 'hide the provider.' It is 'make the safe workflow consistent and surface the differences clearly.'"*
- **Transition cue:** "Here is the lifecycle the cmdlets implement."

### Slide 19 — The Lifecycle Flow

- **Time on stage:** 23:00 to 24:30
- **Driver / narrator:** Frank.
- **Visual concept:** A horizontal pipeline with twelve numbered steps in two rows of six. The steps: 1. Pin build → 2. Acquire artifact → 3. Create or register virtual machine (VM) → 4. Apply sizing → 5. Start → 6. Snapshot → 7. Enroll → 8. Apply policy → 9. Validate (or fail) → 10. Collect evidence → 11. Roll back → 12. Clean local state and reconcile cloud records. Each step has a tiny icon. The 11 → 12 link is highlighted in yellow with a small annotation: *"Cloud state does not roll back."* In the lower right, a small loop arrow labeled *"iterate"* connects step 12 back to step 7, reinforcing that this is a cycle, not a one-shot.
- **Talking points:**
  - The whole demo is this loop. We will show steps 2 and 3 in Demo 1, steps 3 through 6 in Demo 2, the same loop on a different provider in Demo 3, and steps 7 through 12 in Demo 4.
  - Step 12 is the part most labs skip. It is where haunted device objects come from.
  - The loop arrow is the entire point of a lab. You run this 50 times. You only push to production once.
- **Memorable line:** *"Step 12 is the difference between a lab and a graveyard."*
- **Transition cue:** "Before we touch a keyboard, two more concepts."

### Slide 20 — Snapshot Taxonomy: Five Names, Five Purposes

- **Time on stage:** 24:30 to 27:00
- **Driver / narrator:** Frank.
- **Visual concept:** Five horizontal "checkpoint cards" stacked vertically, each with the canonical name on the left, a one-line purpose, and a small "use when" and "watch out for" pair. The cards: **Clean operating system (Clean-OS) / Pre-Enroll / Post-Enroll-Baseline / Broken-Policy-State / Recovered-Known-Good**. A thin timeline runs across the slide top showing how they connect. The arrow between Post-Enroll-Baseline and Broken-Policy-State has a small "engineered failure" tag. Tiny "demo path" pins sit above three of the cards: **Pre-Enroll** is pinned with "Identity baseline," **Post-Enroll-Baseline** with "Demo 4 starts here," and **Broken-Policy-State** with "Demo 4 hits this in 30 seconds."
- **Talking points:**
  - Five names, five jobs. We use the same vocabulary in the runbook, the cmdlets, and the docs.
  - Pre-Enroll is the gold-standard identity baseline. Post-Enroll-Baseline is the speed baseline.
  - Broken-Policy-State is engineered, not improvised. Stage failures should look planned because they are.
  - Recovered-Known-Good is captured after rollback plus the report-only cloud cleanup review or manual reconciliation notes, not just after the local restore.
- **Memorable line:** *"Snapshot time travel is real. The cloud does not time-travel with it."*
- **Transition cue:** "Which brings us to demo rules."

### Slide 21 — Demo Rules and the Cloud-State Warning

- **Time on stage:** 27:00 to 28:30
- **Driver / narrator:** Both speakers alternate the four rules.
- **Visual concept:** Four numbered rules, large type, one per quadrant.
  1. **Downloads are cached.** No live `mist download`.
  2. **Cloud sync is not instant.** Checkpoints exist for a reason.
  3. **Failures are scripted.** They should look planned because they were.
  4. **Rollback restores the virtual machine (VM), not Intune.** This sentence is the centerpiece, set in slightly larger type with a thin border. The cloud-rollback warning composite icon sits next to it.

  At the very bottom of the slide, in tiny type, the full warning sentence is printed once, verbatim, so it can be photographed: *"Snapshot rollback restores the virtual machine (VM). It does not rewind Intune, Entra, Defender portal state, audit logs, or assignments."*
- **Talking points:**
  - "Watching a progress bar is not educational. The artifact is pinned, cached, and recorded. We will skip ahead when the educational part is over."
  - The fourth rule is the cloud-state warning we will repeat throughout. Memorize it. Photograph it. The bottom of this slide has it in print so you can.
- **Memorable line:** *"Snapshot rollback restores the virtual machine (VM). It does not rewind Intune, Entra, Defender portal state, audit logs, or assignments."*
- **Transition cue:** "Hands on the keyboard."

### Slide 22 — Section Divider: The Demos

- **Time on stage:** 28:30 to 28:45
- **Driver / narrator:** Frank.
- **Visual concept:** Full-bleed dark slide. **Part 4 — The Demos.** Subtitle: *"Pin. Build. Swap. Break. Roll back. Prove it."* Progress bar 4 of 4.
- **Memorable line:** None.
- **Transition cue:** Click.

### Slide 23 — Demo 1: Pin and Acquire Media

- **Time on stage:** 28:45 to 35:00
- **Driver / narrator:** Frank drives; Michael narrates why build pinning matters in change control.
- **Visual concept:** Title row: **Demo 1 — Pin and Acquire Media.** Below it, two boxes side-by-side. Left box: **What we are doing** with three short bullets: pin a build, acquire a restore image, record metadata. Right box: **What success looks like** with three short bullets: cached artifact reused, checksum verified, sidecar metadata produced. At the bottom of the slide, a small terminal-style block (synthetic, no real values):

  ```text
  Get-MacLabMedia -Version <macOS-version> -Build <macOS-build> -Source Mist
  CACHE  prepared restore image found
  PASS   checksum verified
  SKIP   live download
  ```

  The reproducibility icon sits in the lower right corner.
- **Talking points:**
  - For this demo, we reuse a pre-cached restore image (`.ipsw` file). We do not redownload on stage. The script verifies the checksum and short-circuits.
  - The educational part is the metadata sidecar, not the download. We will show what that looks like.
  - In production, this is what you commit to your lab change record: "we tested macOS X.Y.Z, build B, acquired from this source, with this checksum, on this date."
- **Memorable line:** *"Reproducibility starts the moment you pin the build."*
- **Transition cue:** "Pinned and cached. Now build the virtual machine."

### Slide 24 — Demo 2: Parallels Virtual Machine and Snapshot

- **Time on stage:** 35:00 to 47:00
- **Driver / narrator:** Frank drives; Michael explains why snapshot discipline matters.
- **Visual concept:** Same two-box layout as Demo 1. Left: **What we are doing** with three bullets: create or register the virtual machine (VM) from cached media; apply sizing profile; create `Pre-Enroll` checkpoint. Right: **What success looks like** with three bullets: VM registered with isolation enforced; checkpoint visible in `prlctl`; provider version recorded in evidence. Small footer line: *"Provider hardening verified after creation, not assumed from exit code."* The cloud-rollback warning composite sits in the lower right corner because the next minute will reference rollback discipline.
- **Talking points:**
  - We disable host integration features intentionally: clipboard, shared folders, shared applications, host location, and device sharing where the provider exposes controls. They blur identity boundaries.
  - We verify the final virtual machine (VM) configuration. Provider commands can succeed and still leave host integrations enabled.
  - The snapshot is the safety net. Everything downstream depends on it.
- **Memorable line:** *"Provider commands return 0. That is not the same as being safe."*
- **Transition cue:** "Same workflow. Different engine."

### Slide 25 — Demo 3: Provider Swap to UTM

- **Time on stage:** 47:00 to 53:00
- **Driver / narrator:** Frank drives; Michael compares operating models.
- **Visual concept:** Title row: **Demo 3 — Provider Swap to UTM.** Below: a small "before / after" diagram showing the same `Invoke-MacPolicyValidation` call running against `-Provider Parallels` and then `-Provider UTM`. The two invocations are visually identical except for the provider name, with a thin highlight on the differing parameter to show the audience exactly what changed. Footer: *"UTM is partial automation in v1. We tell you which steps are manual."*
- **Talking points:**
  - The point is not "UTM is as good as Parallels." The point is that the workflow survives a provider change.
  - UTM can carry useful lifecycle automation, but v1 treats creation, checkpointing, internet protocol (IP) discovery, and destructive cleanup as unsupported or manual-step-required unless later evidence proves a safe path.
  - This is the slide where Tart gets a one-liner cameo: *"If you want this in continuous integration (CI), Tart is the conversation. We have stubbed it in v1."*
- **Memorable line:** *"The provider abstraction prevents tool differences from changing the entire workflow."*
- **Transition cue:** "Now we get to break a Mac on purpose."

### Slide 26 — Demo 4 Setup: An Audit Finding

- **Time on stage:** 53:00 to 55:00
- **Driver / narrator:** Michael drives this segment of Demo 4; Frank narrates lab scaffold.
- **Visual concept:** A mock-up of an "audit finding" memo, single column, with a redaction stripe across the org name. Headline: **Finding: User-installed apps from non-App-Store sources.** Below: a paragraph (synthetic) recommending Gatekeeper hardening to App Store sources only. Footer in red: *"What could go wrong?"* Beneath the memo, a small two-step pictogram: a pen ticking a box, followed by an emoji-free distress-icon-style "yikes" mark.
- **Talking points:**
  - "A reasonable security recommendation lands. A reasonable admin tightens Gatekeeper to App Store only. The chief executive officer (CEO) opens Visual Studio Code (VS Code). The CEO calls."
  - This is how good intentions become CEO calls.
  - The lab is where this scenario is supposed to surface, not the executive's laptop.
  - "We chose Gatekeeper for the live break because it shows the loop without recovery-key handling on a projector. The same loop applies to FileVault and Defender. We will walk through their evidence models right after the demo."
- **Memorable line:** *"Reasonable security recommendation. Reasonable admin response. Unreasonable Monday morning."*
- **Transition cue:** "Here is the policy."

### Slide 27 — System Policy Control: Two Settings, Big Impact

- **Time on stage:** 55:00 to 56:30
- **Driver / narrator:** Michael.
- **Visual concept:** A simulated Intune Settings Catalog panel (mocked, not a screenshot; clean rectangles, no real tenant chrome) showing two rows:
  - **Enable Assessment** with a toggle on, marked "✓ enabled."
  - **Allow Identified Developers** with a toggle off, marked "✗ disabled."
  - Below: a one-line paragraph: *"Result: only App-Store-source apps will pass `spctl` assessment. Visual Studio Code is identified-developer signed, not App Store distributed."*
- **Talking points:**
  - Two settings. Big behavioral impact.
  - The category is "System Policy Control" but most of the audience knows it as Gatekeeper.
  - Notarization is not enough. The policy explicitly excludes identified developers.
  - Live Intune delivery can be started in the background, but the stage success path is checkpointed and fixture-backed.
- **Memorable line:** *"Two switches in Settings Catalog can lock the chief executive officer out of Visual Studio Code."*
- **Transition cue:** "Here it goes."

### Slide 28 — Demo 4 Live Run

- **Time on stage:** 56:30 to 67:00
- **Driver / narrator:** Both speakers. Michael narrates the Intune side. Frank narrates the lab scaffold and rollback.
- **Visual concept:** This slide is a layout placeholder for the live demo window. Use it as a "screen on screen" frame.

  In the **upper-right corner**, a compact **state-machine diagram** shows four labeled boxes connected by arrows: **Baseline → Broken → Rolling Back → Recovered.** A small dot moves from box to box as the demo progresses, advanced by speaker remote. This protects the narrative if the live window has any timing wobble — the audience always knows which state of the world the demo is in.

  Along the **right edge**, a dim table of expected outcomes (9 rows) fills in green or red as the demo progresses:

  - PASS  mobile device management (MDM) enrollment profile present
  - PASS  Gatekeeper assessment enabled
  - PASS  System Policy Control profile detected
  - FAIL  Visual Studio Code (VS Code) blocked by App-Store-only policy *(expected)*
  - PASS  Blocking dialog captured
  - PASS  Evidence redaction applied
  - PASS  Rollback restored Post-Enroll-Baseline
  - PASS  VS Code accepted after rollback
  - WARN  Intune cloud assignment still requires report-only cleanup review

  The cloud-rollback warning composite sits in the lower-right corner.
- **Talking points (live demo cadence):**
  - Show baseline state. Visual Studio Code (VS Code) launches. All green. Move the state-machine dot to **Baseline**.
  - Restore `Broken-Policy-State`. VS Code is rejected by `spctl`. The expected FAIL appears. Move the dot to **Broken**.
  - If live Intune timing is slow, say so and use the checkpointed broken state captured during rehearsal.
  - Disconnect virtual machine (VM) networking. This is the stage control. Explain why out loud. Move the dot to **Rolling Back**.
  - Restore `Post-Enroll-Baseline`. VS Code launches again. The PASS row appears. Move the dot to **Recovered**.
  - End on the WARN. Report-only cleanup review and manual reconciliation are real steps, not an asterisk.
- **Memorable line:** *"This is the first place that policy was allowed to fail. It is also the only place it should have failed."*
- **Transition cue:** "Here is what you would attach to a change ticket."

### Slide 29 — Anatomy of an Evidence Bundle

- **Time on stage:** 67:00 to 68:30
- **Driver / narrator:** Frank.
- **Visual concept:** A single mock-up of an `evidence.json` summary, formatted as a clean JavaScript Object Notation (JSON) code block. Six visible fields: `runId`, `provider`, `providerVersion`, `snapshot`, `hostMacOS`, `redactionApplied: true`. To the right of the JSON block, a thin column listing four bundled files: `evidence.json`, `evidence.summary.txt`, the test plan reference, `MANIFEST.json`. A bold black bar redacts a couple of values in the JSON block to teach the eye what redaction looks like.

  Below the JSON block, a small framed callout reads: *"This is what your Change Advisory Board (CAB) actually wants. Not 'the portal says assigned.'"*
- **Talking points:**
  - Every validation run produces structured evidence.
  - The bundle includes the test plan, the provider version matrix, the run summary, and a manifest with checksums.
  - It is portable. It is redacted by default. It is what your change board actually wants.
  - Think of it as a receipt. The receipt is the artifact. The lab is the kitchen that produces it.
- **Memorable line:** *"Evidence beats vibes."*
- **Transition cue:** "And the redaction is not optional."

### Slide 30 — Redaction in Action

- **Time on stage:** 68:30 to 69:30
- **Driver / narrator:** Frank.
- **Visual concept:** Two side-by-side panels labeled **Before redaction** and **After redaction**. Both show the same synthetic JavaScript Object Notation (JSON) snippet. The left has placeholder values shaped like real ones (for example, `recoveryKey: <example-shape>`). The right has those same values masked with `***REDACTED***`. Bottom annotation: *"Field-name match plus shape match. Fail closed when redaction cannot be applied."*
- **Talking points:**
  - The helper redacts by field name and by shape: recovery-key-shaped strings, JSON Web Token (JWT)-shaped strings, and so on.
  - Evidence export refuses to write a bundle if redaction fails.
  - Never display a raw recovery key on a projector. Show that escrow exists. Show retrieval flow. Redact the value.
- **Memorable line:** *"Show that the secret exists. Do not show the secret."*
- **Transition cue:** "Which is exactly why FileVault and Defender, the two policies in our title, get evidence-model treatment instead of keys-on-screen treatment."

### Slide 31 — FileVault Evidence Model

- **Time on stage:** 69:30 to 70:45
- **Driver / narrator:** Michael.
- **Visual concept:** A vertical evidence-checklist card with seven rows:
  1. Policy assignment captured.
  2. `fdesetup status` captured locally.
  3. Encryption / escrow report from Intune.
  4. Recovery-key existence proven (value redacted).
  5. Escrow timing explained.
  6. Hardware sign-off boundary documented.
  7. Rollback result captured.

  Right edge: a fidelity tag showing **Yellow** for FileVault rollout behavior. A small REDACTED stripe sits beside row 4.
- **Talking points:**
  - FileVault evidence is layered: policy, local state, escrow state, redacted proof, hardware boundary.
  - Escrow preparation and encryption state are not the same thing. Test both.
  - The Yellow tag means virtual machine (VM) testing is good for iteration; physical hardware is required for final rollout sign-off.
  - The break-and-rollback workflow you just saw on Gatekeeper is the same workflow you would run for a FileVault policy. Same checkpoints. Same evidence shape. Same cloud-state caveat.
- **Memorable line:** *"Test that escrow exists. Then test it again on real hardware."*
- **Transition cue:** "Defender is the same shape with different evidence."

### Slide 32 — Defender Evidence Model

- **Time on stage:** 70:45 to 71:30
- **Driver / narrator:** Michael.
- **Visual concept:** Same vertical evidence-checklist treatment as Slide 31, with seven Defender-specific rows:
  1. Package installed.
  2. System extension approved.
  3. Network extension approved (when used).
  4. Full Disk Access / Privacy Preferences Policy Control (PPPC) delivered.
  5. Onboarding completed.
  6. `mdatp health` captured as sanitized key/value output.
  7. Rollback result captured.

  Right edge: fidelity tag **Green** for the health checks themselves; **Yellow** for performance-sensitive behavior.
- **Talking points:**
  - Defender on macOS is not just "install the app." The profiles are the deployment.
  - `mdatp health` is the closest thing to a health receipt. Capture it.
  - Do not assume JavaScript Object Notation (JSON) output unless the installed Defender version has been verified to emit valid JSON.
  - "Looks installed but is not healthy" is the most common Defender macOS failure mode.
  - Same break-and-rollback loop applies. A misconfigured Privacy Preferences Policy Control (PPPC) payload is exactly the kind of thing the lab catches before production.
- **Memorable line:** *"Defender on macOS is not an app install. It is a profile contract."*
- **Transition cue:** "All three policies — FileVault, Defender, Gatekeeper — share a small repeating set of failure modes."

### Slide 33 — Section Divider: Wrap-Up

- **Time on stage:** 71:30 to 71:35
- **Driver / narrator:** Frank.
- **Visual concept:** Full-bleed dark slide. **Wrap-Up: Dragons, the Repo, and Monday Morning.** No subtitle. No progress bar.
- **Memorable line:** None.
- **Transition cue:** Click.

### Slide 34 — Dragons Checklist

- **Time on stage:** 71:35 to 72:05
- **Driver / narrator:** Both speakers, alternating two highlights each. Do not read the whole table.
- **Visual concept:** Compact three-column triage table, dense type. Columns: **Symptom / Likely cause / First check.** Twelve rows from the runbook. Each row has a tiny one-icon left edge: caution-triangle for virtual machine (VM)/lifecycle issues, cloud-clock for cloud timing, ghost for stale identity, lock for credentials and recovery. Footer line: *"Full table in `docs/Troubleshooting.md`."*
- **Talking points:**
  - Name two dragons only: "virtual machine (VM) enrolls but policy never arrives" is usually Apple Push Notification service (APNs), sync, or assignment scope; "Visual Studio Code (VS Code) stays blocked after rollback" is the wrong checkpoint or a bad policy reapplied.
  - The repo carries the rest, and questions and answers (Q&A) is where the dragons get names.
- **Memorable line:** *"Most macOS Intune mysteries are Apple Push Notification service (APNs), sync, scope, or a haunted device object."*
- **Transition cue:** "Speaking of haunted device objects."

### Slide 35 — The Memorable Anti-Patterns

- **Time on stage:** 72:05 to 72:25
- **Driver / narrator:** Frank.
- **Visual concept:** A 2×3 grid of six small "card" tiles, each with an icon and a name:
  - **Portal Faith** with a checkbox icon. *"Trusting 'assigned' without device-side evidence."*
  - **Snapshot Time Travel** with calendar pages flying backward. *"Rolling back the virtual machine (VM) and forgetting the cloud moved forward."*
  - **Progress-Bar Theater** with a spinner icon. *"Spending stage time watching downloads or sync."*
  - **Executive Pilot Roulette** with a die icon. *"Using the chief executive officer's (CEO's) Mac as the first real test."*
  - **Haunted Device Object** with a ghost outline. *"A stale Intune/Entra record that no longer matches the VM."*
  - **Screenshot Leak** with a camera and a redaction bar. *"Showing a recovery key, token, or real user detail because evidence was not redacted."*

  A footer line in small caps: *"Naming the failure mode is half the fix."*
- **Talking points:**
  - Read only the names. The audience can photograph the definitions.
  - If behind on time, skip this slide and use it as a questions and answers (Q&A) appendix slide.
- **Memorable line:** *"Name the anti-pattern, and you have half-fixed it."*
- **Transition cue:** "OK. The kit."

### Slide 36 — The Repo, on Monday Morning

- **Time on stage:** 72:25 to 73:15
- **Driver / narrator:** Frank.
- **Visual concept:** **Right half of the slide:** a very large Quick Response (QR) code, sized so that an attendee in the back row can scan it from a phone camera. The QR target and displayed repo link are **`https://github.com/franklesniak/macOSLab`**. Below the repo link, show the tagline: *"Public repo, permissive license, Apple-silicon Macs."* **Left half:** a clean repo-tree drawing showing the top-level folders (`src/`, `scripts/`, `examples/`, `docs/`, `tests/`) with `docs/Start-Here.md` highlighted. Below the tree, a one-line "your first command" snippet:

  ```text
  Import-Module ./src/Modules/MacLab/MacLab.psd1
  ```

  The Quick Response (QR) code is the dominant visual on the slide on purpose. This is the artifact attendees must take home.
- **Talking points:**
  - Five top-level folders. Start at `docs/Start-Here.md`.
  - The first command imports the module. The second runs the readiness gate. The third pins your media.
  - This is a starter kit, not a finished product. Open issues. Send pull requests.
- **Memorable line:** *"You do not need to remember anything. You need to remember the repo link."*
- **Transition cue:** "Here is what we want you to do with it."

### Slide 37 — The Monday Morning Plan

- **Time on stage:** 73:15 to 73:45
- **Driver / narrator:** Frank.
- **Visual concept:** Eight numbered cards in two rows of four, each with a single sentence and a small icon. The cards are deliberately styled to look like a printable checklist that attendees can screenshot and follow.
  1. **Clone the repo.** (download icon)
  2. **Build one virtual machine (VM).** (layered-disk icon)
  3. **Take a `Pre-Enroll` snapshot.** (camera-shutter icon)
  4. **Enroll into a lab scope.** (cloud icon)
  5. **Test one risky policy.** (caution-triangle icon)
  6. **Export redacted evidence.** (REDACTED-stripe receipt icon)
  7. **Roll back.** (curved arrow icon)
  8. **Review the cloud cleanup report.** (cloud-clock icon)

  Below the grid, in slightly larger type: *"Your first Monday is one virtual machine (VM), one policy, one evidence bundle, one rollback, and one cleanup review."*
- **Talking points:**
  - Do not try to build your whole Mac program by Friday.
  - Pick one risky policy. Run the loop once. The second loop is much easier.
  - Screenshot this slide. It is the entire onboarding plan.
- **Memorable line:** *"The win is not that you have a Mac virtual machine (VM). The win is that your next scary Mac policy has somewhere safe to fail."*
- **Transition cue:** "Quick recap before we open it up."

### Slide 38 — Recap

- **Time on stage:** 73:45 to 74:30
- **Driver / narrator:** Both speakers alternate. Frank reads 1 and 3. Michael reads 2 and 4.
- **Visual concept:** Header at the top: **Recap.** Below, the same four numbered takeaway cards from Slide 3, in the same vertical stack and order, with one change: each card has a green checkmark (✓) added to its left margin and a one-line attribution in smaller type beneath the takeaway citing where in the talk it was delivered. The fourth card's left-edge stripe is half-transparent, matching Slide 3.
  1. ✓ **Analyze the virtualization constraints of Apple Silicon and select the appropriate hypervisor (Parallels vs. UTM) that aligns with your budget and automation needs.**
     *Delivered in Part 1 (Constraints) and Part 2 (Hypervisor decision matrix).*
  2. ✓ **Construct a fully automated, reproducible macOS test lab using PowerShell 7 to fetch restore images / install media and control virtual machine (VM) states.**
     *Delivered in Part 3 (Automation layer) and Demos 1, 2, and 3.*
  3. ✓ **Execute end-to-end validation of high-risk policies (FileVault, Defender) by enrolling, breaking, and rolling back virtual machines (VMs) via script — keeping production safe.**
     *Delivered in Demo 4 (live break and rollback) and the FileVault and Defender evidence models.*
  4. ✓ **Implement the provided GitHub starter kit immediately to bridge the gap between your Windows automation skills and macOS requirements.**
     *Delivered in the Windows-admin translation, the repo handoff, and the Monday morning plan.*
- **Talking points:**
  - "Quick recap. Four objectives. Here is where each one landed in the talk."
  - Each speaker reads two takeaways with the corresponding location. Brief and direct.
  - "If we missed something, that is exactly what the next half hour is for."
- **Memorable line:** *"Pin. Build. Break. Roll back. Prove it."*
- **Transition cue:** "Hands up. We will route by domain."

### Slide 39 — Questions and Answers Buckets

- **Time on stage:** 74:30 to 104:30. Lives on screen for the entire extended questions and answers (Q&A).
- **Driver / narrator:** Both speakers, routing by domain.
- **Visual concept:** Six cards arranged 3×2, each with an icon and a short label:
  - **Lab construction and lifecycle** with a building-blocks icon.
  - **Enrollment, tenant, and cleanup** with a cloud-clock icon.
  - **Risky-policy validation** with a caution-triangle icon.
  - **Compliance and Conditional Access (CA) timing** with a clock icon.
  - **Evidence and change boards** with a document-stack icon.
  - **Continuous integration (CI), Tart, and inventory adjacencies** with a branching icon.

  Footer (left): *"Raise hands. One question per person first. Mic runner if needed."*

  Footer (right), in a small bordered callout, the **Structured Answer Framework**:

  1. Restate the scenario.
  2. Recommend an approach.
  3. Name the gotcha.
  4. Say what to automate.
  5. Point to the repo path.

  The framework lives on screen so both speakers can glance at it during answers, and so attendees see the shape they will get.
- **Talking points:**
  - "We will answer with the pattern, the gotcha, what to automate, and where it lives in the repo. The five steps in the corner are the contract."
  - If the room is quiet, use seed questions: scariest policy in your environment; who has a Mac policy that only one person on the team understands; who is debating Tart for continuous integration (CI).
- **Memorable line:** *"Every answer ends with a repo path."*
- **Transition cue:** None. This is the live questions-and-answers slide.

### Slide 40 — Final Thank-You

- **Time on stage:** 104:30 to 105:00
- **Driver / narrator:** Both speakers.
- **Visual concept:** Centered, large type: **Thank you.** Below: speaker names, the Quick Response (QR) code one more time, and the single line *"Pin. Build. Break. Roll back. Prove it."* No social handles unless explicitly approved.
- **Talking points:**
  - "Thanks for being here. Find us at lunch. We would love to hear what you would test first."
- **Memorable line:** *"Pin. Build. Break. Roll back. Prove it."*
- **Transition cue:** None. Session ends.

---

## Summary Slide Index

| # | Title | Time mark | Section |
| --- | --- | --- | --- |
| 1 | Title and Speaker Identity | 0:00 | Open |
| 2 | The Executive Mac Hook | 0:45 | Open |
| 3 | Session Takeaways | 3:00 | Open |
| 4 | Agenda | 4:15 | Open |
| 5 | The Risk Map | 4:45 | Open |
| 6 | Where Your Windows Instincts Already Apply | 6:30 | Open |
| 7 | Translation Cheat Sheet | 7:15 | Open |
| 8 | Section Divider — Constraints | 8:00 | Constraints |
| 9 | Apple Silicon Is Not Hyper-V | 8:15 | Constraints |
| 10 | Licensing — Two-Guest Boundary | 10:00 | Constraints |
| 11 | Pin the Build, Cache the Artifact | 11:00 | Constraints |
| 12 | The Fidelity Traffic Light | 12:30 | Constraints |
| 13 | The Hardware Math | 14:30 | Constraints |
| 14 | Section Divider — Choose Your Hypervisor | 15:30 | Hypervisor |
| 15 | The Hypervisor Decision (Headline) | 15:45 | Hypervisor |
| 16 | The Decision Matrix | 18:00 | Hypervisor |
| 17 | Section Divider — The Automation Layer | 21:00 | Automation |
| 18 | One Operator Interface, Three Engines | 21:15 | Automation |
| 19 | The Lifecycle Flow | 23:00 | Automation |
| 20 | Snapshot Taxonomy | 24:30 | Automation |
| 21 | Demo Rules and Cloud-State Warning | 27:00 | Automation |
| 22 | Section Divider — The Demos | 28:30 | Demos |
| 23 | Demo 1 — Pin and Acquire Media | 28:45 | Demos |
| 24 | Demo 2 — Parallels Virtual Machine and Snapshot | 35:00 | Demos |
| 25 | Demo 3 — Provider Swap to UTM | 47:00 | Demos |
| 26 | Demo 4 Setup — An Audit Finding | 53:00 | Demos |
| 27 | System Policy Control — Two Settings | 55:00 | Demos |
| 28 | Demo 4 Live Run | 56:30 | Demos |
| 29 | Anatomy of an Evidence Bundle | 67:00 | Demos |
| 30 | Redaction in Action | 68:30 | Demos |
| 31 | FileVault Evidence Model | 69:30 | Demos |
| 32 | Defender Evidence Model | 70:45 | Demos |
| 33 | Section Divider — Wrap-Up | 71:30 | Wrap |
| 34 | Dragons Checklist | 71:35 | Wrap |
| 35 | The Memorable Anti-Patterns | 72:05 | Wrap |
| 36 | The Repo, on Monday Morning | 72:25 | Wrap |
| 37 | The Monday Morning Plan | 73:15 | Wrap |
| 38 | Recap | 73:45 | Wrap |
| 39 | Questions and Answers Buckets | 74:30 | Questions |
| 40 | Final Thank-You | 104:30 | Close |

## Appendix Slides

These are designed to live behind the main deck and surface only during questions and answers (Q&A) or as a checkpoint fallback. Each is a single slide.

- **A1 — FileVault Escrow Retrieval Path (Redacted Screenshots).** Three pre-redacted mock-ups of the Intune retrieval flow showing the path without showing the value. Use if a questions-and-answers prompt asks "show me the recovery-key page."
- **A2 — `mdatp health` Sample Output.** Synthetic, sanitized key/value output. Use JavaScript Object Notation (JSON) only if the installed Defender version has been verified to emit valid JSON. Use if Defender questions and answers go deep.
- **A3 — UTM Template / Configuration Artifact.** A clean code listing of the JavaScript Object Notation (JSON) descriptor. Use if anyone asks "what does the UTM provider see?"
- **A4 — Provider Version Matrix Example.** A real-shaped sample matrix with placeholder versions. Use if anyone asks "what do you record per run?"
- **A5 — Report-Only Cloud Cleanup Walkthrough.** A bulleted list of the candidate Intune, Entra, and Defender records the script flags, with the explicit note "v1 is report-only."
- **A6 — Tart and Orchard Free-Tier Boundary.** One slide describing Fair Source posture, the 100 central processing unit (CPU)-core limit (Tart), and the 4-worker limit (Orchard) as planning constraints. Not legal advice.
- **A7 — Apple Software License Boundary.** One slide with the software license agreement (SLA) link, the two-guest boundary phrasing, and the "verify with your legal and procurement team" footer.
- **A8 — Live Recording Fallback Frame.** A single slide that is the mounting frame for the 60 to 90 second recording of Demo 4. Includes the practiced narration line at the bottom: *"Rather than fight a service issue live, here is the exact run from rehearsal. Then we will jump back to the live machine for the rollback and repo path."*
- **A9 — Code-of-Conduct and Speaker Etiquette Reminder.** Optional, only if needed at the door.
- **A10 — The Three Hardware Profiles.** Three named example lab Macs with sizing notes (cores, memory, storage, expected concurrent guests, expected coverage of macOS major versions). Use if hardware questions and answers go specific.
- **A11 — Apple Push Notification Service and Corporate Network Realities.** A single page on how Secure Sockets Layer / Transport Layer Security (SSL/TLS) inspection can break mobile device management (MDM), with the practical "look at your TLS-inspecting proxy before you blame Apple" line. Use if a network question lands.
- **A12 — Why Two Speakers.** One slide for any question about the conference two-speaker format. Briefly explains how Frank and Michael split ownership: lab automation and PowerShell on one side, Intune and policy behavior on the other. Useful if asked "why do you both present?"
- **A13 — Why Not VMware Fusion?** One slide with the concise distinction: Fusion supports Apple-silicon hosts for Arm Windows and Arm Linux guests, but current Broadcom documentation does not support Arm macOS as a Fusion guest on Apple silicon. Use if someone asks why Fusion is not a provider column.

## Visual / Production Notes

- **Use icons consistently.** The icon set in the "Visual Language and Iconography" table at the top of this document is the canonical set. Do not introduce new icons mid-deck.
- **Reserve the traffic-light colors for the traffic light.** Anywhere else uses the neutral palette plus the single accent color. This keeps green, yellow, and red meaningful when they appear on Slides 12, 31, and 32.
- **Reserve the redaction-stripe treatment for actual redaction or the cloud-rollback warning.** Do not decorate other slides with it. When attendees see the black bar, they should think "secret was here, now redacted" or "this slide depicts a rollback."
- **Section dividers exist on purpose.** They are the only slides without a body. Resist the urge to fill them. Slide 8 carries one small boundary footnote because the constraints section opens with an honesty contract; this is the only divider that does so.
- **Slide 28 is a frame, not a slide.** During rehearsal, time the right-edge PASS / FAIL / WARN reveals to the actual demo cadence so the slide feels like it is tracking the live run. Move the state-machine dot in the upper-right corner manually with the speaker remote; it is independent of the live window. If the recording fallback is used (A8), the slide can advance independently of the recording.
- **Slide 36's Quick Response (QR) code is the largest visual element on its slide.** It points to `https://github.com/franklesniak/macOSLab`. Do not let any decoration crowd it. The single most important attendee outcome is that the QR code scans cleanly from a phone in the back row.
- **Slide 38 (Recap) must mirror Slide 3 (Session Takeaways) exactly in layout.** Same vertical stack, same order, same numbering, same wording. The only differences are the green checkmarks and the one-line attribution beneath each takeaway. Visual consistency is what makes the checkmark moment land.
- **Slide 39 (Questions and Answers Buckets) lives on screen for thirty minutes.** Treat the Structured Answer Framework callout as part of the slide, not as a footnote, because attendees will read it more than once.
- **Icons referenced in this document (ghost, calendar pages, traffic light, and so on) must be original or open-license vector art.** Do not lift Apple, Microsoft, Parallels, UTM, Tart, or product logos as decoration. Logos may appear only on the explicit decision-matrix slides where the tool name is the content, and only as wordmark text, not branded assets.
- **Humor is sparing and on-target.** The deck has room for one or two visual gags (Slide 26's "yikes" mark, Slide 35's anti-pattern card icons). It does not have room for "Macs are weird" energy. The default tone is calm technical confidence.

## Memorable Lines Anthology

This is the cadence track. Speakers should rehearse these lines in order, separately from the deck content, until the rhythm feels natural. Lines are listed with the slide they live on.

| Slide | Line |
| --- | --- |
| 1 | "Two speakers, one safety net." |
| 2 | "Production is a terrible place to discover your Mac policy assumptions." |
| 3 | "Four objectives. We will check them off in front of you." |
| 5 | "Every one of these has a calendar event attached. Our job is to make sure the calendar event is a test run, not a Monday morning incident." |
| 6 | "PowerShell is the conductor. The instruments change." |
| 7 | "You do not need new instincts. You need a translator." |
| 9 | "Treat your lab Mac like a build server. Do not auto-upgrade it the day before a regression cycle." |
| 10 | "The licensing story is friendlier than Windows licensing in some ways. The engineering constraints are where the real design work starts." |
| 11 | "If you cannot say which macOS build you tested, you cannot say what your test means." |
| 12 | "A lab that cannot tell you what it cannot prove is not a safe lab." |
| 13 | "Same-major coverage is a host-fleet problem, not a disk-space problem." |
| 15 | "Choose the tool that makes the safe behavior easiest for your team." |
| 16 | "Parallels for polish. UTM when budget is the constraint. Tart when automation is the goal." |
| 18 | "The boundary is not 'hide the provider.' It is 'make the safe workflow consistent and surface the differences clearly.'" |
| 19 | "Step 12 is the difference between a lab and a graveyard." |
| 20 | "Snapshot time travel is real. The cloud does not time-travel with it." |
| 21 | "Snapshot rollback restores the virtual machine (VM). It does not rewind Intune, Entra, Defender portal state, audit logs, or assignments." |
| 23 | "Reproducibility starts the moment you pin the build." |
| 24 | "Provider commands return 0. That is not the same as being safe." |
| 25 | "The provider abstraction prevents tool differences from changing the entire workflow." |
| 26 | "Reasonable security recommendation. Reasonable admin response. Unreasonable Monday morning." |
| 27 | "Two switches in Settings Catalog can lock the chief executive officer out of Visual Studio Code." |
| 28 | "This is the first place that policy was allowed to fail. It is also the only place it should have failed." |
| 29 | "Evidence beats vibes." |
| 30 | "Show that the secret exists. Do not show the secret." |
| 31 | "Test that escrow exists. Then test it again on real hardware." |
| 32 | "Defender on macOS is not an app install. It is a profile contract." |
| 34 | "Most macOS Intune mysteries are Apple Push Notification service (APNs), sync, scope, or a haunted device object." |
| 35 | "Name the anti-pattern, and you have half-fixed it." |
| 36 | "You do not need to remember anything. You need to remember the repo link." |
| 37 | "The win is not that you have a Mac virtual machine (VM). The win is that your next scary Mac policy has somewhere safe to fail." |
| 38 | "Pin. Build. Break. Roll back. Prove it." |
| 39 | "Every answer ends with a repo path." |
| 40 | "Pin. Build. Break. Roll back. Prove it." |

## Speaker Handoff Script

Every transition has a planned line. The script below is the working set. It is not a hard rule; it is the safety rope when energy or memory wobbles.

| From → To | Planned handoff |
| --- | --- |
| 1 → 2 | "Before we go anywhere technical, here is why anyone in this room should care about the next 75 minutes plus questions and answers." |
| 2 → 3 | "Here is what we want you to walk out of this room with." |
| 3 → 4 | "Here is the route we will take to get there." |
| 4 → 5 | "Risk map first. What can actually go wrong on a managed Mac?" |
| 5 → 6 | "If you are sitting here thinking 'I already test risky Windows policies. Why is the Mac side fragile?' — good. That is the bridge we are about to build." |
| 6 → 7 | "The next slide adds the rows that do not have a clean Windows analogue." |
| 7 → 8 | "The bridge is real. It is not free. Apple-silicon labs come with constraints that decide what is actually buildable. Michael, take it." |
| 8 → 9 | (Pause two beats. Click forward.) |
| 9 → 10 | "The architecture has a licensing wrinkle that Windows admins are not used to." |
| 10 → 11 | "Now the version pinning that turns 'works on my Mac' into evidence." |
| 11 → 12 | "Once you have pinned a build, the fidelity question becomes: what can a virtual machine actually prove?" |
| 12 → 13 | "Hold that traffic light in your head. We are going to come back to it every time we make a tool decision." |
| 13 → 14 | "Constraints understood. Time to choose a tool." |
| 14 → 15 | (Click.) |
| 15 → 16 | "Now the specifics." |
| 16 → 17 | "Now I will show you why we built one PowerShell automation model on top of all three." |
| 17 → 18 | (Click.) |
| 18 → 19 | "Here is the lifecycle the cmdlets implement." |
| 19 → 20 | "Before we touch a keyboard, two more concepts." |
| 20 → 21 | "Which brings us to demo rules." |
| 21 → 22 | "Hands on the keyboard." |
| 22 → 23 | (Click.) |
| 23 → 24 | "Pinned and cached. Now build the virtual machine." |
| 24 → 25 | "Same workflow. Different engine." |
| 25 → 26 | "Now we get to break a Mac on purpose." |
| 26 → 27 | "Here is the policy." |
| 27 → 28 | "Here it goes." |
| 28 → 29 | "Here is what you would attach to a change ticket." |
| 29 → 30 | "And the redaction is not optional." |
| 30 → 31 | "Which is exactly why FileVault and Defender, the two policies in our title, get evidence-model treatment instead of keys-on-screen treatment." |
| 31 → 32 | "Defender is the same shape with different evidence." |
| 32 → 33 | "All three policies — FileVault, Defender, Gatekeeper — share a small repeating set of failure modes." |
| 33 → 34 | (Click.) |
| 34 → 35 | "Speaking of haunted device objects." |
| 35 → 36 | "OK. The kit." |
| 36 → 37 | "Here is what we want you to do with it." |
| 37 → 38 | "Quick recap before we open it up." |
| 38 → 39 | "Hands up. We will route by domain." |
