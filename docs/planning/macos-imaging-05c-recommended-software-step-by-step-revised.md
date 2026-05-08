<!-- markdownlint-disable MD013 -->
# Step-by-Step Acquisition & Installation Instructions

## Metadata

- **Status:** Draft
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-07
- **Scope:** Talk-development working artifact for the MMSMOA 2026 session: "Step-by-Step Acquisition & Installation Instructions". Captures interim concepting, prioritization, outline, or runbook content for that session; not a final published deliverable.
- **Related:** [macOSLab repository specification](../spec/macOSLab-repository-spec.md), [Architecture decision records](macOS-imaging-08e-ADRs.md), [Closed questions archive](macOS-imaging-08d-closed-questions-archive.md), [Repository Copilot Instructions](../../.github/copilot-instructions.md), [Documentation Writing Style](../../.github/instructions/docs.instructions.md)

Follow these steps **in order**. This document separates **software/services you acquire**, **host Mac prerequisites**, **host software installation**, **host verification**, **service configuration prerequisites**, **VM-baked software**, and **final verification**.

---

## Final Decisions Incorporated

Use these fixed decisions while following the runbook:

- The companion repo is `franklesniak/macOSLab`, initialized from `franklesniak/copilot-repo-template`, with Phase 0 bootstrap complete.
- This runbook verifies the evolving starter kit; it does not replace the repository specification, ADRs, or implementation-phase instructions.
- Use PowerShell 7.4 or newer only. PowerShell 5.1 compatibility is not a goal.
- Pin Pester to 5.7.1 for the initial repo and rehearsal validation.
- The primary demo guest is macOS Tahoe 26.4.1 when the host is also on macOS 26.x. Keep compatibility with currently Apple-supported macOS versions, initially macOS Sequoia 15.7.5 and macOS Sonoma 14.8.5, but only after host/provider preflight confirms the requested host/guest pairing.
- Use Parallels Desktop Pro Edition as the primary provider. Use UTM only if Demo 3 is live. Tart is optional and remains a v1 stub unless explicitly approved later.
- macOS guests on Apple Silicon must be treated as Apple Virtualization framework workloads. Same-major host/guest macOS is the safest vendor-documented path; a guest newer than the host may fail, and any cross-major pairing needs explicit rehearsal evidence before it appears in a live demo or compatibility claim.
- Full coverage across macOS 14.8.5, 15.7.5, and 26.4.1 may require up to three Apple-silicon host Macs, one per host macOS major version. Newer Mac hardware may not boot older host macOS releases, so it may not be suitable for same-major testing of older macOS guests.
- Tart and Orchard publish Fair Source/free-tier terms. Treat Tart's 100 CPU-core free-tier limit and Orchard's 4-worker free-tier limit as planning constraints, not as legal advice.
- Plan around Apple's current macOS license posture: Apple-branded host hardware, permitted purposes, and the commonly relevant boundary of up to two additional macOS virtual instances per Apple-branded host. Have legal/procurement confirm organizational use.
- Keep `SECURITY.md` unchanged by default in the generated repo. Do not rewrite it.
- `Reset-IntuneMacLabDevice.ps1` is report-only in v1. It identifies candidate stale cloud records and manual cleanup steps; it does not retire, soft-delete, or hard-delete Intune, Entra, or Defender records.
- Do not commit example screenshots to the public v1 repo. Keep rehearsal/deck screenshots local unless later Phase 10 work explicitly approves checked-in visual artifacts.
- Demo 4 is Gatekeeper/System Policy Control blocking Visual Studio Code on first launch, then rollback. Defender remains required validation content and backup proof, but do not pivot the live failure back to Defender-unhealthy.
- Do not commit a sample Gatekeeper `.mobileconfig`. Use Intune Settings Catalog as the canonical policy authoring surface; keep any local profile payload only as an uncommitted fallback after verifying the exact target-VM `profiles` command.
- If deferred work remains, create root per-phase TODO files such as `TODO-Phase-00-Branch-Protection.md`, `TODO-Phase-04-Media-Acquisition.md`, `TODO-Phase-05-Parallels-Provider.md`, `TODO-Phase-06-UTM-Provider.md`, `TODO-Phase-07-Evidence-Pipeline.md`, `TODO-Phase-08-Validation-Loop.md`, and `TODO-Phase-10-Deferred-Work.md`. Omit a phase TODO file only when that phase has no deferred work.

## Phase 1 — Acquire Licenses, Accounts, and Services

These are the things you need to **buy, provision, or obtain access to** before installation work begins. Many have lead times, so start them first.

### Step 1: Buy Parallels Desktop Pro Edition

1. Go to <https://www.parallels.com/products/desktop/>.
2. Click **Buy Now**.
3. Select **Parallels Desktop Pro Edition**.
4. Complete checkout.
5. Save the license key and account details in your password manager.
6. Do **not** buy **Parallels Standard** for this use case.
7. Do **not** buy **Parallels Business** unless you specifically need centralized deployment/management across multiple Macs.

### Step 2: Acquire a Microsoft 365 tenant

1. First, optionally check the **Microsoft 365 Developer Program** at <https://developer.microsoft.com/microsoft-365/dev-program>.
2. Treat the Developer Program as a possible option, not a guarantee.
3. If it is not available or not sufficient, procure a paid tenant.
4. Preferred option: **Microsoft 365 E5** — <https://www.microsoft.com/microsoft-365/enterprise/e5>
5. Lower-cost fallback: **Microsoft 365 Business Premium** — <https://www.microsoft.com/microsoft-365/business/microsoft-365-business-premium>
6. Complete the tenant setup.
7. Store the tenant admin credentials in your password manager.
8. Confirm the tenant includes the capabilities you need for Intune, Entra, and any security demos.
9. Treat the demo tenant or demo scope as **isolated**:
   - Use lab-only groups.
   - Use lab-only filters if filters are part of the demo.
   - Avoid broad production assignments.
   - Avoid using the presenter's real corporate identity.
   - Avoid using real business users for Demo 4.

   > Treat the demo tenant as an isolated lab. A policy mistake during the talk should only affect lab-only devices and lab-only users.

### Step 3: Create the lab test user

Do this immediately after the demo tenant is provisioned, so every subsequent demo step has a safe identity to target.

1. Create the lab test user directly in the demo tenant. The lab user must be:
   - cloud-only
   - in the demo tenant
   - **not** a real employee identity
   - **not** the speaker's real corporate identity
   - licensed only for what the demo requires
   - **not** assigned a real mailbox unless the demo explicitly requires one
   - **not** a member of groups outside the lab scope
2. Record the lab user's UPN and the password in your password manager. Do **not** reuse credentials from any production tenant.
3. Purpose:
   - Even a worst-case Conditional Access or compliance misfire during Demo 4 cannot harm a real user.

### Step 4: Acquire Presentify

1. Open the Mac App Store.
2. Locate **Presentify**: <https://apps.apple.com/app/presentify-screen-annotation/id1507246666>
3. Purchase or download it, as applicable to the current App Store listing.
4. The App Store will place **Presentify.app** into `/Applications` automatically.
5. Leave launch and permissions configuration for the host software phase below.

### Step 5 *(optional)*: Acquire access to Apple Business

1. Only do this if you plan to include **Automated Device Enrollment (ADE)** in the talk.
2. Go to <https://business.apple.com>.
3. Start the enrollment/verification process **early** — verification can take days.
4. Record the organization account details you used.
5. **VM Fidelity Traffic Light — Red.** ADE / ABM zero-touch flows are **Red** on the VM Fidelity Traffic Light. A VM cannot fully validate:
   - ADE / ABM zero-touch enrollment
   - serial-number-dependent workflows
   - Platform SSO sign-in/unlock behavior
   - Touch ID
   - Secure Enclave-dependent behavior

   Frame Apple Business acquisition accordingly:

   - It is required only if the talk will narrate, partially demonstrate, or prepare ADE-related material.
   - Acquiring it is **not** a sign that ADE can be fully validated in the VM lab.

   > Use the VM lab to prepare and validate adjacent workflows, but do not claim that it fully proves ADE or hardware/security-model-dependent behavior. Those require physical Mac sign-off.

---

## Phase 2 — Host Mac Prerequisites

Install these first because later tools depend on them.

### Step 6: Install Xcode Command Line Tools

1. Open **Terminal**.
2. Run:

   ```bash
   xcode-select --install
   ```

3. **Important:** This command does **not** install anything by itself. It only triggers a **GUI dialog** that asks whether to install the command line developer tools. The actual download and install happen only after you interact with that dialog.
4. Find the **"The `xcode-select` command requires the command line developer tools"** dialog. It may appear behind other windows or on a different Space/display. If you cannot find it (for example, you accidentally clicked **Not Now**), simply run `xcode-select --install` again.
5. In the dialog, click **Install**, then **Agree** to the license.
6. Wait for the **Software Update** progress window to finish and report that the software was installed. This typically takes several minutes and depends on network speed.
7. Do **not** run `xcode-select -p` until after the GUI install has completed. If you run it too early, it will (correctly) report `Unable to get active developer directory`, because the tools are not installed yet. If that happens, **ignore** the message's suggestion to run `sudo xcode-select --switch path/to/Xcode.app` — that is not the fix here. The fix is to let the GUI installer finish.
8. After the install completes, verify:

   ```bash
   xcode-select -p
   ```

   Expected output is a path such as `/Library/Developer/CommandLineTools`.
9. Also verify Git is now available, since the Xcode Command Line Tools include a working **Git**:

   ```bash
   git --version
   ```

### Step 7: Install Homebrew

1. In Terminal, run:

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Do not skip the post-install instructions printed by the installer.** On Apple Silicon, the installer ends with a "Next steps" block that tells you to add Homebrew's `shellenv` to your shell profile. Without this, later steps will appear to install correctly but the Apple-shipped versions in `/usr/bin` will keep winning over the Homebrew versions in `/opt/homebrew/bin`.
3. On Apple Silicon with the default `zsh` shell, run exactly:

   ```bash
   echo >> ~/.zprofile
   echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
   eval "$(/opt/homebrew/bin/brew shellenv)"
   ```

   On Intel Macs, the path is `/usr/local/bin/brew` instead of `/opt/homebrew/bin/brew`. Use whatever the installer's "Next steps" output told you to use — it is authoritative.
4. The `eval "$(...brew shellenv)"` command in step 3 already updated `PATH` in the **current** Terminal window, and the line appended to `~/.zprofile` ensures **future** Terminal windows (login shells) pick it up automatically. You can optionally close and reopen Terminal to verify the new window inherits the same `PATH` from `~/.zprofile`.
5. Verify:

   ```bash
   brew --version
   echo $PATH
   ```

   In `echo $PATH`, confirm that `/opt/homebrew/bin` (Apple Silicon) or `/usr/local/bin` (Intel) appears **before** `/usr/bin`. If it does not, Homebrew-installed tools like `git` and `pwsh` will be shadowed by the older versions in `/usr/bin`.

---

## Phase 3 — Install Host Mac Software

These are the applications and tools to install on the **host Mac**.

### Step 8: Verify Git, then optionally install a Homebrew-managed version

1. Check whether Git is already available (it should be, courtesy of Xcode CLT):

   ```bash
   git --version
   ```

   The Apple-shipped Git typically reports something like `git version 2.50.1 (Apple Git-155)` and lags well behind upstream.
2. If Git is missing, or if you want a Homebrew-managed version for consistency and easier updates, run:

   ```bash
   brew install git
   ```

3. Verify again:

   ```bash
   git --version
   ```

4. **If `git --version` still shows the Apple-shipped version** (for example, you installed Homebrew Git successfully but `git --version` still reports `(Apple Git-...)`):
   1. **First, try the cheap fix:** close the current Terminal window and open a **brand new** one. If you ran `brew install git` in a Terminal window that was opened *before* you wired up Homebrew's `shellenv` (Step 7), that window's `PATH` is stale and will keep resolving `/usr/bin/git` first. A fresh window almost always resolves this on its own.
   2. **If a new Terminal window does not fix it**, your `PATH` ordering is wrong. Diagnose with:

      ```bash
      which -a git
      echo $PATH
      ```

      You want `/opt/homebrew/bin/git` listed first by `which -a git`, and `/opt/homebrew/bin` to appear before `/usr/bin` in `$PATH`. If it does not, re-do Step 7 to ensure Homebrew's `shellenv` is in your shell profile (`~/.zprofile` for the default `zsh`), then open another new Terminal window.
   3. Do **not** "fix" this by deleting `/usr/bin/git` or by editing system files — that path is owned by macOS / the Xcode Command Line Tools and will be restored or break other tools.
5. Re-run:

   ```bash
   which git
   git --version
   ```

   You should see `/opt/homebrew/bin/git` (Apple Silicon) or `/usr/local/bin/git` (Intel), and the Homebrew version number.

### Step 9: Install PowerShell 7.4 or newer

1. PowerShell on macOS is now distributed as a Homebrew **formula**, not a cask. The previous cask name (`powershell`) has been retired, and the only remaining cask (`powershell@preview`) is deprecated. Run:

   ```bash
   brew install powershell
   ```

2. Do **not** run `brew install --cask powershell`. As of this writing, that command fails with `Cask 'powershell' is unavailable: No Cask with this name exists.` and Homebrew will only suggest the deprecated `powershell@preview` cask, which you should **not** use for this demo environment.
3. If `brew install powershell` is unavailable in your tap for any reason, fall back to the official Microsoft `.pkg` installer from the PowerShell GitHub releases page: <https://github.com/PowerShell/PowerShell/releases/latest>. Pick the `powershell-<version>-osx-arm64.pkg` on Apple Silicon, or `powershell-<version>-osx-x64.pkg` on Intel.
4. Verify:

   ```bash
   pwsh --version
   ```

   The result must be PowerShell 7.4.x or newer. If it reports `7.3` or older, upgrade before continuing; the `macOSLab` repo does not support Windows PowerShell 5.1 or older PowerShell 7 releases.

### Step 10: Install Visual Studio Code

1. Run:

   ```bash
   brew install --cask visual-studio-code
   ```

2. Launch Visual Studio Code once.
3. Verify the CLI:

   ```bash
   code --version
   ```

4. If `code` is not found, open VS Code and use the Command Palette to run:
   **Shell Command: Install 'code' command in PATH**

### Step 11: Install the PowerShell extension for Visual Studio Code

1. Open Visual Studio Code.
2. Go to **Extensions**.
3. Search for **PowerShell**.
4. Install the **PowerShell** extension published by Microsoft.
5. Open a `.ps1` file to confirm the extension activates correctly.

### Step 12: Install mist-cli

1. Run:

   ```bash
   brew install mist-cli
   ```

2. Verify with:

   ```bash
   mist --help
   ```

3. If your installed version supports it, you may also verify with:

   ```bash
   mist --version
   ```

### Step 13: Install UTM

1. Choose one acquisition path:
   - Mac App Store (auto-updates): <https://apps.apple.com/app/utm-virtual-machines/id1538878817>
   - Direct download (functionally identical): <https://mac.getutm.app/>
2. If using the direct download, move **UTM.app** into `/Applications`.
3. Launch UTM once.
4. Approve any macOS security prompts.
5. Confirm it opens successfully.

### Step 14: Install Parallels Desktop Pro Edition

1. Download the installer from:
   <https://www.parallels.com/products/desktop/download/>
2. Open the downloaded `.dmg`.
3. Run the Parallels installer.
4. Sign in with your Parallels account when prompted.
5. Activate using your **Parallels Desktop Pro Edition** license.
6. Verify the app launches successfully.
7. Verify the CLI:

   ```bash
   prlctl --version
   ```

8. If `prlctl` is not found:
   - Parallels installs `prlctl` at `/usr/local/bin/prlctl`, which should already be on `PATH`.
   - Open a **new** Terminal window so any updated `PATH` is picked up.
   - If it still fails, confirm Parallels installed cleanly and re-run its installer.

### Step 15: Install the Pester PowerShell module

1. Launch PowerShell:

   ```bash
   pwsh
   ```

2. Install the pinned **Pester 5.7.1** release. Use the same version in local rehearsal and CI so failures are not caused by test-runner drift:

   ```powershell
   Install-Module -Name Pester -RequiredVersion 5.7.1 -Scope CurrentUser -Force -SkipPublisherCheck
   ```

   `-SkipPublisherCheck` is required here because PowerShell ships a Microsoft-signed copy of Pester (often Pester 3.4.0) that has a different publisher certificate than the PSGallery-signed Pester 5.x build; without the flag, the installer refuses to overlay the new version. This is a long-standing, documented Pester upgrade requirement (see <https://learn.microsoft.com/en-us/powershell/module/powershellget/install-module#-skippublishercheck> and the Pester install docs at <https://pester.dev/docs/introduction/installation>). Installing from PSGallery (the default repository) and pinning a specific version is the recommended supply-chain mitigation for the lab; the `CurrentUser` scope further limits blast radius. Production deployments that need stricter signature handling can pre-stage the matching publisher cert into the trusted publisher store and drop the flag.

3. Verify:

   ```powershell
   Get-Module -ListAvailable Pester
   ```

4. Test import explicitly with the pinned version:

   ```powershell
   Import-Module Pester -RequiredVersion 5.7.1
   ```

### Step 16: Install the Microsoft Graph PowerShell SDK modules required for the Intune demo

The Intune validation loop in Demo 4 (apply → break → rollback → evidence) is the only place this talk uses Microsoft Graph. Pick **one** of the two installation paths below — do **not** mix them. Mixing the all-in-one `Microsoft.Graph` meta-module with individual submodules commonly produces version-conflict errors at import time.

#### Option A (recommended): Install only the submodules required for this talk

1. In PowerShell, install the submodules the demos actually call:

   ```powershell
   # Required for every Graph call (auth/connect)
   Install-Module Microsoft.Graph.Authentication -Scope CurrentUser -Force

   # Required: enumerate managed Macs, query compliance state,
   # read configuration profile assignments and per-device status.
   # This is the v1.0 module and covers the Demo 4 reliable path.
   Install-Module Microsoft.Graph.DeviceManagement -Scope CurrentUser -Force
   ```

2. Install these only if your demo path needs them:

   ```powershell
   # Optional: include only if Demo 4 shows a Conditional Access impact
   # (e.g., noncompliant Mac blocked from a CA-protected resource).
   Install-Module Microsoft.Graph.Identity.SignIns -Scope CurrentUser -Force

   # Optional: include only if you display the Mac's device object
   # in Entra ID (registered/joined state, device ID correlation).
   Install-Module Microsoft.Graph.Identity.DirectoryManagement -Scope CurrentUser -Force

   # Optional: include only if you do the 60-second "advanced proof point"
   # that retrieves a FileVault personal recovery key. The
   # managedDevices/{id}/getFileVaultKey action is exposed on the BETA
   # endpoint, so the v1.0 DeviceManagement module above will not surface
   # it cleanly. Install this beta submodule and use its cmdlets so the
   # demo stays consistent with the strongly-typed module pattern used
   # everywhere else in this talk.
   Install-Module Microsoft.Graph.Beta.DeviceManagement -Scope CurrentUser -Force
   ```

3. Do **not** install other `Microsoft.Graph.*` submodules "just in case." Each extra submodule increases import time and the chance of an assembly-version conflict on stage.

4. Verify:

   ```powershell
   Get-Module -ListAvailable Microsoft.Graph*
   ```

   Confirm the meta-module `Microsoft.Graph` is **not** in the list. If it is, you are on the wrong path — uninstall it before continuing:

   ```powershell
   Uninstall-Module Microsoft.Graph -AllVersions -Force
   ```

5. Test importing the exact modules you intend to use on stage. Import them in the same order your demo scripts will, so any load-order issues surface now and not during the talk:

   ```powershell
   Import-Module Microsoft.Graph.Authentication
   Import-Module Microsoft.Graph.DeviceManagement
   # Plus any optional modules from step 2 that you actually installed.
   ```

#### Option B (alternative): Install the `Microsoft.Graph` meta-module

Use this path only if you want the simplicity of one install and are willing to accept a much larger footprint and a slower first import. **Do not combine this with Option A.**

1. Make sure no individual `Microsoft.Graph.*` submodules are already installed from Option A. If they are, remove them first so they do not conflict with the meta-module:

   ```powershell
   Get-Module -ListAvailable Microsoft.Graph.* |
       Select-Object -ExpandProperty Name -Unique |
       ForEach-Object { Uninstall-Module $_ -AllVersions -Force }
   ```

2. Install the meta-module:

   ```powershell
   Install-Module Microsoft.Graph -Scope CurrentUser -Force
   ```

3. Verify:

   ```powershell
   Get-Module -ListAvailable Microsoft.Graph
   ```

4. Test import. Expect this to take noticeably longer than importing the individual submodules from Option A:

   ```powershell
   Import-Module Microsoft.Graph
   ```

5. If you also need the FileVault recovery-key proof point under this option, additionally install the beta meta-module:

   ```powershell
   Install-Module Microsoft.Graph.Beta -Scope CurrentUser -Force
   ```

   The same "do not mix beta meta-module with beta submodules" rule applies.

#### FileVault recovery-key safety (applies to both options)

Whenever Demo 4 retrieves a FileVault personal recovery key, the following discipline is **required** regardless of which Graph install path you chose:

> **About `Protect-MacLabEvidence`:** This is the redaction helper that lives in the forthcoming `MacLab` PowerShell module starter kit (see the *Recommended Repo Structure* in `macOS-imaging-03a-bolstered-outline.md`, where it is listed under `/src/Modules/MacLab/Private/`). It is **not** authored as part of this document; the rules below become operationally verifiable once that starter kit exists. Until then, treat this subsection as a **binding design constraint**: do **not** perform any raw-recovery-key demo that would bypass these safeguards, even informally during rehearsal.

- Use `Microsoft.Graph.Beta.DeviceManagement` (Option A) or `Microsoft.Graph.Beta` (Option B) to call the beta cmdlet that exposes `managedDevices/{id}/getFileVaultKey`. This keeps the FileVault demo on the same strongly-typed module pattern as the rest of the talk and avoids ad-hoc raw REST calls on stage.
- Raw recovery-key values **must** be passed through `Protect-MacLabEvidence` before they touch any artifact.
- **Never** display the raw recovery key on the projector.
- **Never** include raw recovery keys in screenshots, logs, recordings, evidence bundles, or the public repo.

Stage-safe proof should show:

- escrow exists
- RBAC allows the right role to retrieve it
- access is auditable
- the value is redacted

> The demo should prove that escrow works, not reveal the secret.

### Step 17 *(optional)*: Install Tart

1. Only do this if you want the advanced CLI/pipeline cameo.
2. Run:

   ```bash
   brew install cirruslabs/cli/tart
   ```

3. Verify:

   ```bash
   tart --version
   ```

4. Treat Tart as an optional advanced path, not part of the core live demo. The v1 `macOSLab` repo keeps Tart stubbed unless later work explicitly approves a fuller provider.
5. Record the current free-tier/license posture in your notes before using Tart publicly:
   - Tart and Orchard publish Fair Source/free-tier terms.
   - Tart's free-tier documentation describes a 100 CPU-core limit.
   - Orchard's free-tier documentation describes a 4-worker limit.
   - This runbook is not legal advice. If Tart or Orchard becomes part of an organizational workflow, legal/procurement should confirm suitability.

### Step 18: Launch and configure Presentify

1. Open **Presentify** from `/Applications` (it was placed there by the App Store in Step 4).
2. Grant any permissions it requests.
3. In **System Settings → Privacy & Security**, confirm Presentify has the required permissions:
   - **Screen Recording**
   - **Accessibility**
4. Test cursor highlighting, annotation, and spotlight behavior on your actual presentation display.
5. Do **not** plan around **ZoomIt for macOS**.

### Step 19: TCC permissions — pick one terminal app and stay on it

macOS TCC (Transparency, Consent, and Control) permissions are **per-application**, not per-user and not per-PATH. A permission granted to **Terminal.app** does **not** automatically apply to **iTerm2** or to **Visual Studio Code**, even though all three can run the same script.

1. **Pick a single host application** for the demo flow and commit to it:
   - Terminal, **or**
   - iTerm2, **or**
   - the integrated terminal in Visual Studio Code.
2. Grant TCC permissions to **that exact app**. Do **not** grant the same permissions to a sibling app "just in case" — the goal is to reduce surface area, not expand it.
3. **Do not switch terminal apps mid-demo.** If you tested and rehearsed from one app, run the same app on stage.
4. Depending on the actual demo path, check the following permissions for the chosen app under **System Settings → Privacy & Security**:
   - **Automation** (controlling other apps via AppleScript / `osascript`)
   - **Full Disk Access**
   - **Files and Folders** (Desktop, Documents, Downloads, removable volumes, etc.)
   - **Screen Recording**
   - **Accessibility**
5. After granting any new permission, fully **quit and relaunch** the app. macOS does not re-read TCC grants for an already-running process.
6. Re-run the demo automation end-to-end from the chosen app to confirm no new TCC prompt appears.

> If you tested the automation from Terminal, run it from Terminal on stage. If you tested from VS Code, run it from VS Code on stage. Do not discover a new TCC prompt in front of the room.

---

## Phase 4 — Host Software Verification Checkpoint

Do this **before** you spend time building or snapshotting VMs. Catching a broken tool now is cheap; catching it after you've baked VMs is expensive.

### Step 20: Verify host software is working

1. Confirm these commands run successfully on the host Mac:

   ```bash
   brew --version
   git --version
   pwsh --version
   code --version
   mist --help
   mist --version
   mist help list
   mist help download
   prlctl --version
   prlctl list --help
   prlctl snapshot-list --help
   prlsrvctl info
   ```

2. If installed, also verify:

   ```bash
   /Applications/UTM.app/Contents/MacOS/utmctl list
   tart --version
   ```

   `utmctl` may launch or foreground UTM because it controls the installed app. Treat that as normal unless the command hangs, fails to return output, or prompts for an automation permission that you cannot approve.

3. Launch and confirm the following open correctly:
   - Visual Studio Code
   - UTM
   - Parallels Desktop
   - Presentify
4. In PowerShell, verify module availability:

   ```powershell
   Get-Module -ListAvailable Pester
   Get-Module -ListAvailable Microsoft.Graph*
   ```

   Confirm the result is consistent with whichever path you chose in Step 16:
   - **Option A:** only the required submodules appear; the bare `Microsoft.Graph` meta-module is **not** present.
   - **Option B:** the `Microsoft.Graph` meta-module is present, and no individual `Microsoft.Graph.*` submodules from Option A are installed alongside it.

5. Resolve any permissions, `PATH`, sign-in, or first-launch issues now.

### Step 21: Check out the GitHub starter kit locally

The session ships a companion GitHub starter kit at `franklesniak/macOSLab` (`MacLab` PowerShell module, `Test-LabReadiness.ps1`, `Protect-MacLabEvidence.ps1`, Pester tests, and the PowerShell GitHub Actions workflow). The repository is initialized from `franklesniak/copilot-repo-template`; a separate implementation guide will define the exact initialization steps. This document **only verifies** that starter kit; it does **not** author it.

> **Note:** If the starter kit has not yet been generated at the time you are working through this document, **skip the offline-check items below for now** but treat them as **mandatory future verification gates** the moment the starter kit exists. The starter kit must be checked out and validated offline **before rehearsal day**.

Once the starter kit exists:

1. Clone or download the starter kit to the host Mac **before rehearsal**, while you still have reliable internet:

   ```bash
   mkdir -p ~/Demo
   cd ~/Demo
   git clone https://github.com/franklesniak/macOSLab.git macOSLab
   ```

   If you use SSH instead of HTTPS, use the equivalent `git@github.com:franklesniak/macOSLab.git` URL.

2. Verify the working copy is available **offline** — close the laptop's network or toggle Wi-Fi off, reopen the folder, and confirm you can still browse, open, and run files from it. Do **not** rely on a live `git clone` over conference Wi-Fi on the day of the talk.
3. Open `docs/Start-Here.md`, **if present**, and skim it end-to-end so you know where the starter kit expects you to begin.
4. Verify the following paths exist within the checked-out starter kit, **if present**:
   - `examples/MMSMOA-2026/`
   - `tests/`
   - any demo scripts and example artifacts referenced from `docs/Start-Here.md`
   - root phase TODO files for any deferred work:
     - `TODO-Phase-00-Branch-Protection.md`
     - `TODO-Phase-04-Media-Acquisition.md`
     - `TODO-Phase-05-Parallels-Provider.md`
     - `TODO-Phase-06-UTM-Provider.md`
     - `TODO-Phase-07-Evidence-Pipeline.md`
     - `TODO-Phase-08-Validation-Loop.md`
     - `TODO-Phase-10-Deferred-Work.md`
5. Stage the starter kit somewhere stable on disk (for example, `~/Demo/macOSLab`) and avoid moving or renaming it after this point — later steps and helper scripts assume a fixed local path.

### Step 22: Verify the `MacLab` module, `Test-LabReadiness.ps1`, and Pester layout

> **Authoring boundary:** The `MacLab` module, `Test-LabReadiness.ps1`, and the Pester tests/workflow listed below are **not authored** in this document. This document **verifies** that the checked-out or generated starter kit contains them. If the starter kit has not yet been generated, every check in this step becomes a **required future verification gate** once it exists, rather than a host-software failure today.

Once the starter kit is checked out (Step 21) or otherwise generated:

1. Verify the local `MacLab` PowerShell module:

   ```powershell
   # Adjust the path to match where you cloned the starter kit.
   $strModulePath = '~/Demo/macOSLab/src/Modules/MacLab/MacLab.psd1'
   Test-Path -Path $strModulePath
   Import-Module -Name $strModulePath -Force
   Get-Module -Name MacLab
   ```

   Confirm:
   - the local `MacLab` module **exists** at the expected path
   - the local `MacLab` module **imports successfully** with no errors
2. Verify `Test-LabReadiness.ps1` is the canonical readiness gate:
   - `Test-LabReadiness.ps1` **exists** in the starter kit at its documented location
   - `Test-LabReadiness.ps1` **runs successfully** end-to-end on the host Mac
   - `Test-LabReadiness.ps1` **returns green** (no failures, no skipped-but-required checks)

   Treat a non-green run as a **stop-the-line** condition: do not proceed to Phase 5 service configuration or Phase 6 VM work until `Test-LabReadiness.ps1` returns green.
3. Verify the expected Pester layout exists once the repo/starter kit has been generated:
   - `tests/MacLab.Tests.ps1`
   - `tests/Providers.Parallels.Tests.ps1`
   - `tests/Providers.UTM.Tests.ps1`
   - `tests/Validation.FileVault.Tests.ps1`
   - `tests/Validation.Defender.Tests.ps1`
   - `.github/workflows/powershell-ci.yml`

   These tests and the PowerShell GitHub Actions workflow are also **verified, not authored**, by this document. The workflow should use the inherited template's `macos-latest` runner pattern. The Phase 0 bootstrap trims Python and Terraform sample/source content from this repository shape; Python may still appear only as a local tooling runtime for pre-commit hooks such as `check-jsonschema`.

### Step 23: Verify the `Protect-MacLabEvidence.ps1` evidence-protection helper

> **Authoring boundary:** `Protect-MacLabEvidence.ps1` is **not authored** in this document. This document **verifies** that the checked-out or generated starter kit contains it and that it conforms to PowerShell verb conventions. If the starter kit has not yet been generated, the checks below become **mandatory future verification gates** once it exists.

Once the starter kit is checked out (Step 21) or otherwise generated:

1. Confirm the helper file is present and correctly placed:
   - `Protect-MacLabEvidence.ps1` **exists** under the `MacLab` module's `Private/` folder
   - it is reachable through the module's internal workflow as expected (i.e., callable from the module's public surface where the documentation says it should be, even though it is not itself an exported cmdlet)
2. Confirm the helper conforms to PowerShell verb conventions:
   - the helper uses the **approved** PowerShell verb `Protect`
   - there is **no** `Redact-MacLabEvidence.ps1` helper present (PowerShell does not approve `Redact-` as a cmdlet verb)
3. Confirm a clean static-analysis pass on the module.

   First, ensure the `PSScriptAnalyzer` module is available on the host (install it for the current user if it is not):

   ```powershell
   if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
       Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
   }
   ```

   Then run the analyzer against the module source tree:

   ```powershell
   Invoke-ScriptAnalyzer -Path ~/Demo/macOSLab/src/Modules/MacLab -Recurse `
       -IncludeRule PSUseApprovedVerbs
   ```

   PSScriptAnalyzer must report **no `PSUseApprovedVerbs` findings** in the `MacLab` module code.

---

## Phase 5 — Service Configuration Prerequisites

These are **not software installs**, but they are essential setup items for the demo environment.

### Step 24: Configure the Apple MDM Push Certificate (APNs)

1. Sign in to the Intune admin center:
   <https://intune.microsoft.com>
2. Go to **Devices → Enroll devices → Apple enrollment → Apple MDM Push certificate**.
3. Download the CSR from Intune.
4. Go to:
   <https://identity.apple.com/pushcert/>
5. Sign in with an **organization-controlled Apple ID**.
   - ⚠️ Do **not** use a personal Apple ID, and do **not** use an Apple ID tied to a single employee's account. The certificate is **non-transferable** — losing access to the Apple ID means re-enrolling every managed device. Use an Apple ID that will outlive any individual.
6. Upload the CSR.
7. Download the generated `.pem` certificate.
8. Return to Intune and upload the `.pem`.
9. Confirm the Apple MDM Push certificate shows as active.
10. Record:
    - the Apple ID used
    - the expiration date (the certificate is valid for **one year** and must be renewed annually using the **same Apple ID**)
    - any renewal notes

### Step 25 *(optional)*: Configure Apple Business / ADE integration

1. Only do this if you want to demo **Automated Device Enrollment**.
2. In Intune, go to **Devices → Apple enrollment → Enrollment program tokens**.
3. Link Apple Business / Apple Business Manager according to Microsoft's setup flow.
4. Confirm the token appears active.
5. Verify the ADE-related setup is ready before rehearsal.

### Step 26: Validate APNs and conference-network reality

> **Validate the actual path the guest VM will use, not just the host browser. The VM's shared/NAT network still depends on the host and venue network behaving correctly.**

Do this **after** the Apple MDM Push Certificate (Step 24) is active, and after any optional Apple Business / ADE setup (Step 25). It is also worth re-running the host-side portion at the venue itself before any live demo segment.

Validate the network path from **both** vantage points:

- the **host Mac** (the machine running Parallels Desktop / UTM)
- the **enrolled or soon-to-be-enrolled macOS guest VM**, reached over the host's shared/NAT network

From each vantage point, confirm:

1. **APNs connectivity** — the host and the guest VM can both reach Apple's APNs endpoints. APNs commonly requires outbound **TCP 5223** (and Apple has historically also used 443/2197 as fallbacks), but **re-check Apple's current enterprise network requirements close to the event** because the canonical list can change.
2. **Intune admin center access** — <https://intune.microsoft.com> loads, signs in, and renders without proxy/SSL inspection errors.
3. **Intune device-list visibility** — your demo tenant's device list loads and you can see the test devices you expect to see for the rehearsal/demo.
4. **Company Portal sign-in and sync path** — Company Portal can sign in **and** complete a sync from the macOS guest VM through shared/NAT networking, not just from the host browser.
5. **Microsoft Graph access**, if the demo uses Graph — `Connect-MgGraph` from the host PowerShell session succeeds with the scopes the demo requires.
6. **Microsoft Defender for Endpoint cloud connectivity**, if the demo uses Defender — the VM can reach Defender cloud endpoints from inside the guest after onboarding.
7. **Mobile hotspot fallback**, where venue and employer policies permit — a phone or LTE/5G hotspot can be substituted for the conference Wi-Fi as a known-good fallback path.
8. **Pre-trusted fallback SSID**, where permitted — at least one alternate Wi-Fi network the host Mac is already trusted on (for example, a hotel-room SSID or a known partner-org SSID), so you are not depending solely on the venue network.
9. **Local-only fallback path** — a clearly identified portion of the demo that can run **without** any cloud dependency at all (for example, snapshot-restore-only segments), so a total network failure does not zero out the session.

#### ⚠️ Things that quietly break APNs and Intune at conferences

- **Conference Wi-Fi can block, throttle, captive-portal, or shape APNs and Microsoft management traffic** in ways that look fine in a browser but break push-driven flows.
- **Corporate networks can break APNs through proxying or SSL/TLS inspection.** APNs is one of the parts of the Apple ecosystem most likely to be silently broken by an "enterprise security" middlebox.
- **APNs commonly requires TCP 5223**, but the reader should re-check current Apple enterprise network requirements close to the event — Apple's published port and host list is the authoritative reference.
- **APNs does not tolerate man-in-the-middle TLS inspection.** Any network that re-signs TLS to the Apple push servers will break enrollment, sync, and policy delivery.
- **If APNs is not happy, Intune is not instant.** Policy and Company Portal actions that normally feel real-time during rehearsal at home can stall for many minutes — or appear to "work" silently while not actually delivering — when APNs is degraded.

Treat any failure on the **guest VM** path as a hard blocker for live demos, even if the host browser path looks healthy. The host's browser does not exercise APNs from the VM's network position.

---

## Phase 6 — Build the macOS VM and Bake the Required Snapshots and Demo Checkpoints

The session plan calls for **five** demo states per hypervisor, not one combined "baseline." The first three are foundational snapshots; the last two are stage/demo reliability checkpoints.

**Foundational snapshots:**

- `Clean-OS` — fresh macOS install, Setup Assistant complete, **no demo software** installed yet, **never enrolled**.
- `Pre-Enroll` — `Clean-OS` plus Intune Company Portal (and optionally Defender, if you want it pre-baked) but the device has **not** yet enrolled into Intune.
- `Post-Enroll-Baseline` — fully enrolled into Intune **and** recently synced. The deterministic healthy baseline used for fast regression and as the checkpoint the Demo 4 apply → break → rollback loop returns **to**.

**Stage/demo checkpoints:**

- `Broken-Policy-State` — deterministic, intentionally broken state for Demo 4. The validation script should report the **expected** failure when restored from this checkpoint.
- `Recovered-Known-Good` — captured after rollback and cleanup/reconciliation. Used to prove the demo can return to a useful known-good state, and to provide a fast resume point if the live rollback path needs a safety net on stage.

> **Rollback restores the VM. It does not rewind Intune, Entra, Defender portal state, audit logs, compliance history, or cloud reporting.** Plan accordingly: anything you want truly reset on the cloud side has to be reconciled there, separately from the snapshot restore.

Phase 6 walks you from "no VM yet" through the three foundational snapshots (`Clean-OS`, `Pre-Enroll`, `Post-Enroll-Baseline`) per hypervisor and then on to the two stage/demo checkpoints (`Broken-Policy-State`, `Recovered-Known-Good`), the cloud cleanup/reconciliation routine they depend on, and the five-state test-restore. The Phase 7 readiness checklist surfaces all five checkpoints in the final pre-rehearsal verification. **Do all of Phase 6 once per hypervisor you plan to demo.** Per design decision B in the outline, that means **Parallels Desktop Pro Edition** at minimum, and **UTM** as well if you intend to do Demo 3 live.

### Step 27: Decide your hypervisor matrix and write down the snapshot names you will use

1. Confirm your hypervisor matrix:
   - **Parallels Desktop Pro Edition** — primary. Required.
   - **UTM** — required if you do Demo 3 ("UTM provider swap") live. Skip if you will only narrate UTM and show prebuilt artifacts from the repo.
2. Pick a **single, consistent naming convention** for snapshots and write it down before you create any VMs. Mixing conventions across hypervisors is the most common cause of "I restored the wrong checkpoint on stage" failures. Recommended pattern:

   ```text
   <hypervisor>-<macOS-version>-<checkpoint>
   ```

   Concrete examples for the macOS 26.x demo guest:

   Foundational snapshots:

   - `parallels-mac26-Clean-OS`
   - `parallels-mac26-Pre-Enroll`
   - `parallels-mac26-Post-Enroll-Baseline`
   - `utm-mac26-Clean-OS`
   - `utm-mac26-Pre-Enroll`
   - `utm-mac26-Post-Enroll-Baseline`

   Stage/demo checkpoints:

   - `parallels-mac26-Broken-Policy-State`
   - `parallels-mac26-Recovered-Known-Good`
   - `utm-mac26-Broken-Policy-State`
   - `utm-mac26-Recovered-Known-Good`

3. Decide your **sizing profile** before creating the VM and write that down too. Two profiles, both from the outline:
   - **`Baseline` profile** (default for most demos): 4 vCPU, 8 GB RAM, 100 GB disk (sparse), single network adapter on **shared/NAT**.
   - **`Performance` profile** (only if a specific demo demands it): 6–8 vCPU, 16 GB RAM, 150 GB disk (sparse), single network adapter on **shared/NAT**.

   Disk size matters more than people expect: every snapshot you keep can grow to tens of GB. Undersizing the virtual disk is the most common reason a snapshot capture fails midway through Phase 6.

4. Confirm host headroom **before** you start building anything:
   - At least **2× your largest VM disk** of free space on the host SSD (one copy for the live VM, one copy's worth of headroom for snapshot deltas and clones).
   - At least **(VM RAM + 4 GB)** of free physical RAM during demos (the host still needs RAM to run VS Code, PowerShell, the browser, screen recording, etc.).
5. Plan around Apple's concurrency posture on Apple silicon: treat **two concurrent macOS guests per Apple-branded host** as the relevant design boundary to plan around, subject to Apple's current license terms and your organization's legal/procurement interpretation. Design the live talk around **one running VM at a time** — that is plenty for the planned demos, and it sidesteps the boundary entirely.
6. Plan host hardware around **host/guest macOS major-version coverage**, not only CPU, RAM, and storage. Same-major host/guest macOS is the safest default for Apple-silicon macOS guests:
   - If the organization needs reliable coverage for macOS 14.x, 15.x, and 26.x at the same time, plan for up to **three** Apple-silicon host Macs, one on each matching host macOS major version.
   - Verify that each physical Mac model can boot the required host macOS before buying or repurposing it. Newer hardware may not boot older macOS releases, so it cannot provide the same-major host needed for older guest testing.
   - A Mac mini M4-class host is a reasonable planning example for macOS 15.x and can later move to macOS 26.x, but upgrading it changes its same-major VM coverage.
   - Newer M5-era hosts may be pinned to macOS 26.x as their minimum host OS, making them useful macOS 26 lab hosts but poor choices for same-major macOS 14.x or 15.x VM coverage.
   - Do not try to solve older guest coverage by simply buying the newest Mac with the most RAM. Compatibility may require the right generation of Mac, not just a bigger Mac.

   Host matrix planning example:

   | Desired guest coverage | Preferred same-major host | Hardware planning implication |
   | --- | --- | --- |
   | macOS Sonoma 14.8.5 | macOS 14.x host | Requires Apple-silicon hardware that can boot macOS 14. Newer Mac models that shipped after macOS 14 may not be usable for this host role. |
   | macOS Sequoia 15.7.5 | macOS 15.x host | Useful on hardware that supports macOS 15; upgrading that host to macOS 26 changes its same-major coverage. |
   | macOS Tahoe 26.4.1 | macOS 26.x host | Useful for the live Tahoe demo path and newer hardware whose minimum host OS is macOS 26. |

### Step 28: Acquire and stage the pinned macOS restore image or provider-appropriate install artifact with `mist-cli`

You already installed `mist-cli` in Step 12. Use it now to fetch the **exact** macOS build you intend to demo, rather than letting each hypervisor's "download macOS" UI pick whatever the App Store currently serves.

For the MMSMOA demo, the initial target is macOS Tahoe 26.4.1 when the host is also macOS 26.x. Keep the repo compatible with currently Apple-supported macOS versions, initially including macOS Sequoia 15.7.5 and macOS Sonoma 14.8.5, but do not demo a different version accidentally and do not assume every host can run every guest. Record the exact marketing version, build number, host macOS version/build, physical Mac model, provider, and host/guest compatibility classification every time.

The goal of this step is **not** to produce a specific file extension. The goal is a **pinned, cached, recorded** macOS build that every hypervisor in your matrix consumes consistently. On Apple silicon, the appropriate artifact is a **restore image or provider-appropriate install artifact** (typically an `.ipsw` for UTM and the recovery/restore-image path for current Parallels) — not an ISO. The `.app` installer bundle that older Parallels workflows consumed is no longer the default Apple-silicon path; treat it as one possible artifact, not as *the* artifact.

Whatever artifact your tested provider version actually consumes, the discipline is the same:

- Pin the macOS version/build. For the live demo, use macOS Tahoe 26.4.1 unless you deliberately change the Provider Version Matrix before rehearsal.
- Confirm the host macOS major version is compatible with the guest. Prefer same-major host/guest macOS; treat cross-major pairings as rehearsal-only until proven on the exact host/provider/version combination.
- Acquire the correct restore image or provider-appropriate install artifact for that pinned build.
- Cache it locally in a known path that your demo scripts and hypervisors can find.
- Record metadata for it (version string, build number, source URL, date acquired, file size).
- Record a checksum or other integrity proof where practical.
- Reuse the **same pinned artifact** across providers wherever the provider supports it.

> The important thing is not the file extension. The important thing is that the macOS build is pinned, cached, recorded, and used consistently across every hypervisor in your matrix.

The concrete commands below use the **firmware / IPSW** path because current Parallels CLI documentation shows Apple-silicon macOS VM creation from a restore image, and UTM macOS guests also consume IPSW restore images. The `.app` installer path may still be useful as a fallback or for adjacent workflows, but do not make it the default Apple-silicon VM artifact.

1. In Terminal on the host Mac, create a durable media cache and capture the installed `mist` command surface:

   ```bash
   mkdir -p ~/Demo/Installers
   mist --version > ~/Demo/Installers/mist-version.txt 2>&1 || true
   mist --help > ~/Demo/Installers/mist-help.txt 2>&1 || true
   mist help list > ~/Demo/Installers/mist-help-list.txt 2>&1 || true
   mist help download > ~/Demo/Installers/mist-help-download.txt 2>&1 || true
   ```

2. List available firmware and compatible installer metadata. Firmware is the primary VM media path; installer metadata is retained as useful cross-check context and a fallback if a provider-specific workflow still needs it:

   ```bash
   mist list firmware --export ~/Demo/Installers/mist-firmware.json
   mist list installer --compatible --export ~/Demo/Installers/mist-installers-compatible.json
   ```

   Owner preflight evidence from a macOS 26.4.1 Apple-silicon host showed `mist list installer --compatible` returning Tahoe 26.1 through 26.4.1 and Sequoia 15.7.2 through 15.7.5, but no Sonoma installer rows. Treat that as host-specific discovery evidence, not as a global support matrix. Older macOS targets still need their own same-major or otherwise documented host/provider preflight.

3. In `mist-firmware.json`, choose the firmware row for the pinned build. Prefer a row that is:
   - the exact macOS version and build you intend to demo
   - compatible with the host according to `mist`
   - signed, when both signed and unsigned rows appear for the same build

4. Download the pinned firmware. Leave `%NAME%`, `%VERSION%`, and `%BUILD%` as literal `mist` filename tokens:

   ```bash
   mist download firmware "26.4.1" \
     --firmware-name "Install %NAME% %VERSION%-%BUILD%.ipsw" \
     --output-directory ~/Demo/Installers
   ```

   If your installed `mist` version ignores or lacks `--output-directory`, it may place firmware under `/Users/Shared/Mist`. That is acceptable as long as you record the actual path and use that same path in the Provider Version Matrix and demo scripts.

5. Verify the artifact landed where you expect:

   ```bash
   ls -la ~/Demo/Installers
   ls -la /Users/Shared/Mist 2>/dev/null || true
   ```

   At this point you should see an `.ipsw` for the pinned macOS build in either `~/Demo/Installers` or `/Users/Shared/Mist`.

6. Record metadata for the cached artifact: macOS version string, build number, host macOS version/build, physical Mac model, host/guest pairing classification, the exact `mist` command line you used, the source URL `mist` resolved to, the date acquired, the file size, and a SHA-256 checksum.

   ```bash
   shasum -a 256 "/path/to/pinned.ipsw"
   ```

   The Provider Version Matrix (see Step 31) is the right place to keep this.
7. **Do not** also rely on each hypervisor's built-in macOS download flow. Doing both creates two slightly different builds in your lab and makes the demos non-reproducible.

### Step 29: Create the macOS VM in Parallels Desktop Pro Edition

Do this even if you also plan to use UTM. Parallels is the primary path.

Use the **current Parallels-supported Apple-silicon macOS VM creation path** for the Parallels version you have actually tested. The Parallels UI for creating an Apple-silicon macOS guest changes between major releases (recovery-partition install, restore-image flow, IPSW import, etc.), so:

- **Re-check the Parallels CLI docs and KB close to the event** for any CLI, UI, or workflow changes between when you wrote your runbook and the day of the talk.
- **Use the provider-supported restore-image / IPSW / recovery workflow** appropriate for the tested Parallels version. Current Parallels CLI documentation shows `prlctl create <vm_name> -o macos --restore-image <path-to-ipsw>` for Apple-silicon macOS VM creation.
- **Confirm the host/guest pairing before creation.** Same-major host/guest macOS is the safest documented path. If the requested guest is newer than the host, stop unless you have an explicit owner-approved rehearsal exception.
- Drive Parallels with the **same pinned macOS build** you cached in Step 28, using whichever artifact that Parallels version actually accepts.
- **Record the Parallels version in the Provider Version Matrix** (see Step 31). The pair "tested Parallels version + macOS build" is part of evidence, not optional metadata.
- **Confirm during rehearsal** that the tested Parallels version supports the macOS Arm VM snapshot behavior the demo depends on (named snapshot, restore from named snapshot, snapshot taken from a cleanly shut-down VM).
- **Do not depend on Coherence Mode** or any other desktop visual integration as the stage "wow." Coherence is an attractive Parallels feature, but it is not what makes this talk land.

The meaningful stage "wow" is the demo loop itself:

1. validation is red,
2. rollback runs,
3. validation is green again,
4. evidence is exported.

Anything Parallels-specific that doesn't serve those four beats is decoration.

1. Prefer the CLI path if it is supported by the tested Parallels version:

   ```bash
   prlctl create "parallels-mac26-base" -o macos \
     --restore-image "/path/to/pinned.ipsw"
   ```

   Replace the VM name and IPSW path with your actual naming convention and the artifact path recorded in Step 28.
2. If you use the GUI instead, open **Parallels Desktop**, choose **File → New…**, and select the macOS-creation entry that matches your tested Parallels version's current Apple-silicon path, typically **Install macOS from the restore image** or **Install macOS using the recovery partition**. Point Parallels at the **matching restore image / IPSW for the pinned macOS build you selected in Step 28**. Do not let Parallels download a different macOS build behind your back.
3. If the CLI created a VM shell without the sizing profile you need, open the VM's configuration before first boot and apply the sizing profile from Step 27.
4. For the GUI path, when prompted for the VM **name and location**, use a name that matches your snapshot convention from Step 27, e.g. `parallels-mac26-base`. Save it under your default Parallels VM location (do not move it manually afterward — Parallels tracks paths internally).
5. Before first boot, or before clicking **Create** in the GUI path, apply your sizing profile from Step 27:
   - **Hardware → CPU & Memory:** set the vCPU and RAM values for your chosen profile.
   - **Hardware → Hard Disk:** set the size for your chosen profile. Leave the disk type at the Parallels default (expanding/sparse).
   - **Hardware → Network:** set **Source** to **Shared Network**. Do **not** use Bridged for the demo VM. Bridged works on a home network but routinely fails on conference Wi-Fi (no DHCP from the conference network to a "second MAC", captive portals, etc.).
   - **Options → Sharing:** turn **off** all host-to-guest sharing (clipboard, drag-and-drop, shared folders, shared profile, shared cameras, shared Bluetooth). You want a clean, isolated guest. Sharing can also confuse Intune compliance signals.
   - **Options → Travel Mode:** off.
   - **Options → More Options → Time machine:** off.
6. Start the installation. macOS installer reboots the VM several times. This is normal. Do **not** click anything during the reboots.
7. After creation and configuration, capture `prlctl list -i "<vm-name>"` and verify the VM is an Apple Virtualization macOS VM with Shared networking and no unwanted host integration. Owner preflight evidence showed a disposable Parallels macOS VM defaulting to several enabled integration settings, including shared applications, shared clipboard/cloud, host resource sharing, camera/gamepad sharing, and host location sharing. Treat the VM as not ready for a `Clean-OS` snapshot until those settings are disabled or explicitly accepted in the Provider Version Matrix.
8. Plan to **shut the VM down cleanly** before any snapshot capture (Steps 32, 35, 37). Snapshotting a running or paused VM is the most common cause of MDM identity drift on restore.

### Step 30: Create the macOS VM in UTM (only if you will demo UTM live)

Skip this step entirely if Demo 3 will be narration-only.

UTM is in the matrix because it is a useful provider-swap demonstration, **not** because it has feature parity with Parallels. Treat that gap as a feature of Demo 3, not a defect to paper over:

- Use **Virtualize**, not **Emulate**, for Apple-silicon macOS guests. On Apple silicon hosts, macOS guests **must** use Apple Virtualization; QEMU emulation cannot run macOS guests meaningfully on Apple silicon and will waste your time.
- Use the **matching IPSW / restore image for the same pinned macOS build** from Step 28. Do not let UTM pick a different build or perform its own automatic macOS download for the live demo path.
- Confirm the host/guest pairing before creation. Same-major host/guest macOS is the safest documented path; any cross-major UTM macOS guest needs explicit rehearsal evidence on the exact host/UTM/version combination.
- **Record the UTM version** in the Provider Version Matrix (see Step 31).
- **Record the UTM template / config artifact** if you used one (exported `.utm` bundle definition, JSON config, etc.), so the same VM shape is reproducible.
- **Do not imply UTM automation has full feature parity with Parallels automation.** The provider wrapper (`MacLab` provider abstraction) should make UTM's automation gaps **explicit** — for example, a UTM provider command that cannot be scripted should fail loudly with a clear "manual step required" message, rather than silently no-op-ing.

1. Open **UTM**.
2. Click **Create a New Virtual Machine**.
3. Choose **Virtualize** (not **Emulate**).
4. Choose **macOS 12+**.
5. When asked for an IPSW, point UTM at the exact IPSW path recorded in Step 28.
6. Apply your sizing profile from Step 27 (CPU, RAM, disk size).
7. For **Network**, leave UTM's default **Shared Network**. Do **not** select Bridged.
8. For **Display** and **Input**, accept the defaults. Do **not** enable any host directory sharing for this VM.
9. Name the VM to match your snapshot convention from Step 27, e.g. `utm-mac26-base`.
10. Save and start the VM. As with Parallels, macOS installer reboots are normal.
11. If you exported a reusable UTM template/config for the demo VM, store it in your demo repo and record its location and version alongside the UTM version in the Provider Version Matrix.

### Step 31: First boot — configure macOS Setup Assistant for reproducibility

Setup Assistant is where most "my snapshot doesn't behave the same way every time" problems are introduced. Treat the answers below as **non-negotiable** for the demo VM. Apply this step inside **every** VM you build (Parallels, UTM, etc.).

1. **Region / language:** pick the same region/language for every VM you build. Most demos assume English / United States; if you change it, change it everywhere.
2. **Wi-Fi / network:** on a virtualized macOS guest using Shared Network, the VM gets its connection from the host. There is nothing to configure. Click **Continue**.
3. **Migration Assistant:** choose **Not now**.
4. **Sign In with Your Apple ID:** click **Set Up Later** and confirm **Skip**. This is critical — signing in with an Apple ID inside the demo VM creates iCloud state that:
   - bleeds into snapshots in unpredictable ways,
   - introduces 2FA prompts mid-demo,
   - and (if you reuse the same Apple ID across many cloned VMs) produces "this device is already associated" friction that has nothing to do with Intune.
5. **Terms and Conditions:** **Agree**.
6. **Create a Computer Account:**
   - Use the **same** local account name on every VM you build, e.g. `Lab User` / `labuser`.
   - Use a strong password you can type live without errors. Write it down in your password manager.
   - Do **not** check "Allow my Apple ID to reset this password."
7. **Enable Location Services:** off. Location prompts during a demo are noise.
8. **Analytics / Share Mac Analytics:** off.
9. **Screen Time:** **Set Up Later**.
10. **Siri:** off. (Even if you like Siri, the setup prompts and microphone permission dialogs are demo-time noise.)
11. **Touch ID / FileVault setup screens** (if shown by your macOS version): for the **`Clean-OS`** snapshot, **skip FileVault**. You will let Intune turn FileVault on as part of the Demo 4 policy flow; pre-enabling it inside the VM hides the very behavior you are trying to demonstrate.
12. **Choose Your Look:** pick a high-contrast appearance (Light is generally most readable on stage). Be consistent across all VMs.
13. After landing on the desktop:
    - Open **System Settings → General → Software Update** and **turn off "Automatic Updates"** for the duration of demo prep. An overnight macOS update inside your VM right before the talk is a known stage-killer.
    - Open **System Settings → Lock Screen** and disable screen lock and screen saver password prompts (set "Require password" to **Never**, set "Start Screen Saver when inactive" to **Never**, set "Turn display off on battery / on power adapter" to **Never** or a long value). These prompts will eat seconds you do not have during demos.
    - Open **System Settings → Notifications** and disable banners for everything you can. Notification toasts mid-demo are unprofessional and distracting.
14. **Disable auto-updates everywhere on the demo path** for the duration of the demo cycle. Disabling guest macOS Software Update inside the VM is necessary but **not sufficient**. Disable or freeze auto-update for **all** of the following, and re-verify each one during your final rehearsal:

    - **Host macOS** (Software Update on the host Mac).
    - **Guest macOS** (Software Update inside every VM you build).
    - **Parallels Desktop** (preferences → check for updates → set to **Never** / manual).
    - **UTM** (preferences → automatic updates off, if applicable).
    - **Demo-critical PowerShell modules** — pin specific versions in your runbook and avoid running `Update-Module` against them between final rehearsal and the talk.
    - **Microsoft Defender for Endpoint**, if a specific Defender version is part of the demo's expected behavior. Defender auto-updating mid-rehearsal can change the behavior the validation script is asserting against.

    An update that lands between rehearsal and stage is the most common reason a demo that worked yesterday fails today.
15. **Record the Provider Version Matrix.** This is **part of evidence, not optional metadata** — the matrix is what lets you (and anyone reviewing the demo afterward) reproduce the exact stack the demo ran on. Keep it next to the demo repo and update it when any component changes. Record at minimum:

    - **Host macOS** version and build.
    - **Host Mac model** and the host's minimum supported macOS major version, where known.
    - **Guest macOS** version and build (the pinned build from Step 28).
    - **Host/guest pairing classification**: `same-major`, `cross-major-tested`, or `rejected`.
    - **Hypervisor version** (Parallels Desktop Pro version; UTM version if you built a UTM VM; both if you built both).
    - **PowerShell version** (`$PSVersionTable.PSVersion` from the host); must be 7.4 or newer.
    - **Pester version**; use 5.7.1 for the initial demo/repo validation.
    - **Defender version** (host and/or guest, whichever is demo-relevant).
    - **Intune policy-set version or change identifier** — a stable identifier for the exact set of policies / assignments your demo expects (a Git tag on the policy export, a configuration-set name with a version suffix, or an explicit "policy revision N" identifier).
    - The pinned macOS-build artifact metadata captured in Step 28 (version string, build number, source, date acquired, size, checksum).
    - Any UTM template / config artifact captured in Step 30.

### Step 32: Capture the `Clean-OS` snapshot

1. Confirm the VM is at the desktop, has **no** demo software installed, and has **never** been enrolled into Intune.
2. **Shut the VM down cleanly** from the Apple menu (**Apple → Shut Down…**). Do **not** snapshot a running or paused VM — restoring from a running snapshot replays a live MAC address and live MDM session state, which is exactly the "MDM identity drift" failure mode the outline warns about.
3. Capture the snapshot using the name you chose in Step 27:
   - **Parallels:** **Actions → Manage Snapshots… → New…**, name it `parallels-mac26-Clean-OS` (or your equivalent), and add a one-line description that includes the macOS build number.
   - **UTM:** select the VM in the sidebar, click **Edit (pencil) → Snapshots → +**, name it `utm-mac26-Clean-OS`.
4. Verify the snapshot exists in the snapshot manager UI before moving on.

### Step 33: Boot the VM, install Intune Company Portal, and prepare for `Pre-Enroll`

1. Start the VM from the `Clean-OS` snapshot you just captured. (Do **not** "continue from where you left off." Always restore from the named snapshot so subsequent steps are reproducible.)
2. Inside the VM, open **Safari**.
3. Go to <https://go.microsoft.com/fwlink/?linkid=853070> to download the **Intune Company Portal** installer.
4. Run the installer and accept the prompts.
5. Launch **Company Portal** once so its first-run state is initialized.
6. **Do not** click **Sign In** yet. Leaving Company Portal at the sign-in screen is exactly the `Pre-Enroll` state you want.
7. (Optional) If your demo design requires Defender to be baked into the `Pre-Enroll` snapshot, do Step 34 now **before** snapshotting. Otherwise, skip to Step 35.

### Step 34 *(optional)*: Install Microsoft Defender for macOS in the VM

Do this **only** if your Demo 4 design assumes Defender is already present at the start of the demo. If your demo deploys Defender live via Intune, **skip this step** — installing Defender ahead of time will hide the very behavior you want to show.

1. Inside the VM, install Defender using one of:
   - Microsoft's documented manual install: <https://learn.microsoft.com/defender-endpoint/mac-install-manually>, or
   - an Intune-driven install captured **before** you take the snapshot. (Note: this requires enrolling the VM, which means this approach belongs in `Post-Enroll-Baseline`, not `Pre-Enroll`. Choose deliberately.)
2. Launch Defender once.
3. Approve any first-run permission prompts that you can approve without enrolling. Leave anything that requires MDM-pushed PPPC payloads alone — those are part of the demo.
4. Capture `mdatp version` and `mdatp health` output after install. Do not assume a file named `.json` is parseable JSON; owner evidence showed `mdatp health` output as key/value text even when saved to a `.json` filename. Record whether the installed `mdatp` build supports a true JSON output mode, and sanitize organization, machine, EDR, tenant, device, user, and cloud identifiers before using the output as evidence fixtures.
5. For the current working baseline, the repo carries a sanitized healthy fixture at `examples/TestCases/fixtures/mdatp-health-healthy.txt`. Use that fixture shape as the expected evidence model, but re-capture live guest health before the final dry run.

### Step 35: Capture the `Pre-Enroll` snapshot

1. Confirm the VM contains:
   - Intune Company Portal (sitting at the sign-in screen, not signed in).
   - Optionally, Defender (only if you completed Step 34 deliberately).
   - **No** Intune enrollment, **no** corporate Apple ID, **no** organizational sign-in inside Company Portal.
2. **Shut the VM down cleanly** (**Apple → Shut Down…**). Do not snapshot while running or paused.
3. Capture the snapshot using the name you chose in Step 27:
   - **Parallels:** `parallels-mac26-Pre-Enroll`.
   - **UTM:** `utm-mac26-Pre-Enroll`.
4. Verify the snapshot exists.

### Step 36: Enroll the VM into Intune and let it fully sync

1. Restore the VM from the **`Pre-Enroll`** snapshot you just captured. Do not work forward from your live VM state.
2. Boot the VM and let it reach the desktop.
3. Open **Company Portal** and sign in with the **organizational test account** that belongs to your demo tenant from Step 2. Do **not** use your real corporate identity here.
4. Follow the Intune enrollment flow to completion (download/install management profile, allow the prompts macOS shows for MDM enrollment).
5. Wait for **at least one full sync cycle** to complete. Verify each of these is true before snapshotting:
   - **System Settings → Privacy & Security → Profiles** (or **General → Device Management** on older macOS) shows the Intune management profile installed.
   - **Company Portal → Devices** lists this device.
   - **Intune admin center → Devices → All devices** lists this device with a recent **Last check-in** time.
   - The device shows as **Compliant** (or as the deterministic compliance state your demo expects to start from).
6. Trigger one manual sync from Company Portal (**Devices → \[this device\] → Check Status**) and confirm it completes successfully.
7. Install Visual Studio Code inside the guest and capture a baseline acceptance check with `spctl --assess -vv "/Applications/Visual Studio Code.app"`.
8. **Do not** launch Visual Studio Code and **do not** apply the risky Gatekeeper/System Policy Control demo policy yet. FileVault, PPPC, and Defender policies may be present only to the extent required for their supporting evidence paths. The `Post-Enroll-Baseline` snapshot is supposed to be the clean enrolled state you roll back **to**. Firefox MAY be staged as a secondary app only if it follows the same not-launched-before-policy rule.

### Step 37: Capture the `Post-Enroll-Baseline` snapshot

1. Confirm the VM is enrolled, compliant (or at the deterministic baseline state your demo expects), and has been recently synced (within the last few minutes).
2. **Shut the VM down cleanly**. As with the previous snapshots, snapshotting while running or paused will cause MDM identity drift on restore.
3. Capture the snapshot using the name from Step 27:
   - **Parallels:** `parallels-mac26-Post-Enroll-Baseline`.
   - **UTM:** `utm-mac26-Post-Enroll-Baseline`.
4. Verify the snapshot exists.

### Step 37a: Capture the `Broken-Policy-State` snapshot

This step bakes the deterministic failure that Demo 4's apply → break → rollback loop reveals on stage. The point is that the failure is **engineered and predictable**, not improvised live.

Starting from `Post-Enroll-Baseline`:

1. Restore the VM from `Post-Enroll-Baseline`.
2. Apply the lab-only Intune Settings Catalog System Policy Control policy, or restore to the rehearsed profile-applied state:
   - Enable Assessment: enabled.
   - Allow Identified Developers: disabled.
3. Run `spctl --status` and `spctl --assess -vv "/Applications/Visual Studio Code.app"` and confirm VS Code is rejected.
4. Run `Invoke-MacPolicyValidation` with `examples/TestCases/Gatekeeper-AppStoreOnly.yml` and confirm the VS Code failure is marked `expectedFailure: true`.
5. Capture failure evidence (validation output, profile receipt text, and local screenshot/recording of the block dialog) so you can prove on stage that the failure is the one you designed. Keep screenshots and recordings out of the repository.
6. Document exactly what is broken, in plain language, alongside the captured evidence. Future-you will thank present-you.
7. **Shut the VM down cleanly.**
8. Capture the snapshot/checkpoint using the name from Step 27:
   - **Parallels:** `parallels-mac26-Broken-Policy-State`.
   - **UTM:** `utm-mac26-Broken-Policy-State`.
9. Verify the snapshot exists.

> **Stage-honesty warning.** Explain this honestly on stage as a checkpointed deterministic failure. Do not pretend the failure is accidental or live service magic. The audience's trust you build by being transparent about how the demo was wired is worth more than the surprise you would get by pretending otherwise.

### Step 37b: Capture the `Recovered-Known-Good` snapshot

This step bakes the post-rollback known-good state. It exists so that the demo can return to a useful healthy baseline after the apply → break → rollback loop, and so that you have a fast resume point if the live rollback path needs a safety net on stage.

Starting from `Broken-Policy-State`:

1. Restore the VM from `Broken-Policy-State`.
2. Disconnect VM networking immediately before the rollback proof so Intune cannot reapply the bad Gatekeeper profile during the local recovery check.
3. Restore `Post-Enroll-Baseline`, run `spctl --assess -vv "/Applications/Visual Studio Code.app"`, and launch Visual Studio Code.
4. Run `Invoke-MacPolicyValidation` with `examples/TestCases/Gatekeeper-Recovered.yml`.
5. Run the documented report-only cloud cleanup/reconciliation routine (Step 37c) so you know whether Intune, Entra, and Defender portal state still contains stale records or expected retained history.
6. Confirm validation reports green, with any expected cloud-state warning (audit history, compliance history, retained Defender alerts, or retained Gatekeeper assignment) explicitly documented as expected, not failures.
7. **Shut the VM down cleanly.**
8. Capture the snapshot/checkpoint using the name from Step 27:
   - **Parallels:** `parallels-mac26-Recovered-Known-Good`.
   - **UTM:** `utm-mac26-Recovered-Known-Good`.
9. Verify the snapshot exists.

> **Careful cloud wording.** The v1 cleanup routine is report-only. It explains cloud drift and manual cleanup steps; it does not erase cloud-side history or mutate Intune, Entra, or Defender records. Intune, Entra, Defender portal state, audit logs, compliance history, and reporting may still show evidence of the broken state. That is normal and expected; just do not claim on stage that the cloud is "back to brand new."

### Step 37c: Run the cloud cleanup / reconciliation routine

Restoring `Post-Enroll-Baseline` (or any later snapshot) can create **MDM identity drift**: the VM rolls back to an earlier identity, but Intune, Entra, and Defender keep moving forward. Without a cleanup pass, the same VM can show up as multiple stale device records, get caught by the wrong assignment filters, or report compliance against a policy version that no longer matches the snapshot. Run this routine whenever you re-capture, regenerate, or test-restore a post-enroll snapshot.

In v1, the routine may report any of the following, as appropriate for your lab:

- candidate stale Intune device records and the portal path or Graph command a human can use to inspect them
- candidate stale Entra device records and the portal path or Graph command a human can use to inspect them
- candidate Defender portal records if you use Defender in the demo
- whether lab group membership still targets only the intended demo device
- whether assignment filters still target only lab devices
- possible device-name collisions between the restored VM and any prior records
- possible identity collisions, such as duplicate Entra ID device IDs, duplicate Intune device IDs, or duplicate Defender machine entries
- expected audit/history behavior so you are not surprised on stage by retained log entries
- whether you should re-capture `Post-Enroll-Baseline`, `Broken-Policy-State`, and `Recovered-Known-Good` because cloud state has drifted too far from the snapshot set

The v1 routine must not retire, remove, wipe, soft-delete, or hard-delete cloud records. Any mutation belongs in a later owner-approved Phase 10 change and must include tests for matching, scoping, confirmation prompts, and redacted evidence.

> **Snapshot rollback restores the VM. It does not rewind Intune, Entra, Defender portal state, audit logs, compliance history, or cloud reporting.**

Treat the report-only cleanup routine as part of the demo, not as an afterthought: rehearse it the same way you rehearse the apply → break → rollback loop, and keep the manual follow-up steps in writing next to your runbook.

### Step 38: Test-restore every snapshot before rehearsal day

This is the single highest-leverage thing in Phase 6. Most "my demo broke on stage" stories trace back to a snapshot the speaker never actually restored from before the talk.

1. For each hypervisor, restore each of the **five** snapshots/checkpoints in order and verify the expected state:

   - **`Clean-OS`**
     - boots to desktop
     - no Company Portal
     - no management profile
   - **`Pre-Enroll`**
     - boots to desktop
     - Company Portal present at sign-in screen
     - no management profile
   - **`Post-Enroll-Baseline`**
     - boots to desktop
     - management profile installed
     - device recently synced (allow time for the network/APNs round-trip after restore)
     - deterministic baseline compliance state
   - **`Broken-Policy-State`**
     - boots to desktop
     - validation script reports the engineered deterministic failure
     - failure is documented and expected (matches the evidence captured in Step 37a)
   - **`Recovered-Known-Good`**
     - boots to desktop
     - validation script reports green
     - cloud cleanup/reconciliation warning is documented if applicable (expected audit/history entries are noted as expected, not as failures)

2. After restoring `Post-Enroll-Baseline`, watch out for **MDM identity drift**: if Intune's cloud-side state has moved forward since you captured the snapshot (for example, you reassigned policies), the restored VM may show as noncompliant for reasons unrelated to your demo. If you see this, run the Step 37c cleanup/reconciliation routine and, if needed, re-capture `Post-Enroll-Baseline` close to your final rehearsal so cloud state and snapshot state are aligned.
3. If you ever **clone** a VM (rather than snapshotting), expect macOS to regenerate the VM's MAC address on first boot. This is normal and is the reason Intune may treat the clone as a "new" device. Stick to snapshots for demo checkpoints; reserve clones for spinning up additional throwaway test VMs.
4. Resolve any restore failures **now**, not the night before the talk.

> **Cloud-drift re-capture warning.** If too much time has passed since `Post-Enroll-Baseline` was captured, Intune, Entra, and Defender cloud-side state may have moved too far forward for report-only cleanup guidance to make the checkpoint trustworthy. In that case, manually reconcile the stale records as needed, then re-capture `Post-Enroll-Baseline` and regenerate `Broken-Policy-State` and `Recovered-Known-Good` close to the talk. These three checkpoints are a set: regenerating only `Post-Enroll-Baseline` and leaving the other two stale will reintroduce the drift you just cleaned up.

---

## Phase 7 — Final Verification Before Rehearsals

### Step 39: Perform a full readiness check

#### Host software

- [ ] Parallels Desktop Pro Edition is installed, activated, and `prlctl --version` works
- [ ] Homebrew is installed and working
- [ ] Git is available and working
- [ ] PowerShell 7.4 or newer launches successfully
- [ ] Visual Studio Code launches successfully
- [ ] The VS Code PowerShell extension is installed and active
- [ ] `code --version` works from Terminal
- [ ] `mist --help` works
- [ ] UTM launches successfully, if used
- [ ] Pester 5.7.1 is installed and imports successfully in PowerShell
- [ ] Microsoft Graph PowerShell is installed via **exactly one** of the Step 16 paths (Option A submodules **or** Option B meta-module — never both)
- [ ] The chosen Graph modules import successfully in PowerShell
- [ ] Tart is installed and working, if you chose to include it
- [ ] Presentify is installed, permitted, and tested on your presentation display
- [ ] The Apple MDM Push certificate is active in Intune, and the Apple ID used is organization-owned
- [ ] Apple Business / ADE integration is active, if applicable
- [ ] The cached macOS restore image / IPSW or provider-appropriate install artifact is present at the path your demo scripts expect

#### Five-checkpoint snapshot/checkpoint set

For **each** hypervisor in your matrix (Parallels, and UTM if used), all five checkpoints exist and restore cleanly:

- [ ] `Clean-OS`
  - desktop reached
  - no Company Portal
  - no management profile
- [ ] `Pre-Enroll`
  - Company Portal present at sign-in screen
  - no management profile
- [ ] `Post-Enroll-Baseline`
  - enrolled
  - recently synced
  - deterministic baseline compliance state
  - Visual Studio Code installed, not launched, and accepted by `spctl`
- [ ] `Broken-Policy-State`
  - Gatekeeper/System Policy Control profile blocks VS Code first launch
  - validation script reports the engineered deterministic failure as expected
- [ ] `Recovered-Known-Good`
  - `spctl` accepts VS Code after rollback
  - VS Code launches after rollback
  - validation script reports green
  - cloud cleanup/reconciliation warning is documented if applicable (expected audit/history entries are noted as expected, not as failures)

Additional snapshot/demo design verification:

- [ ] Defender state inside `Pre-Enroll` matches your demo design (preinstalled **or** intentionally absent — chosen, not accidental)
- [ ] You have re-captured `Post-Enroll-Baseline` close enough to the talk that Intune cloud state has not drifted away from snapshot state
- [ ] Any VM intended for live Defender deployment starts without Defender preinstalled
- [ ] The stage rollback path disconnects VM networking before restoring `Post-Enroll-Baseline`

#### Readiness script

- [ ] `Test-LabReadiness.ps1` returns green on the demo Mac.

`Test-LabReadiness.ps1` is the canonical T-15 readiness gate. It **must** return green during rehearsal and again before the session begins.

#### Break-glass recording

The break-glass flow for Demo 4 follows this sequence:

```text
baseline -> reveal failure -> collect evidence -> roll back -> known good
```

- [ ] The 60–90 second break-glass screen recording of Demo 4 exists locally.
- [ ] The recording shows:
  - baseline
  - reveal failure
  - collect evidence
  - roll back
  - known good
- [ ] The recording plays correctly offline.
- [ ] The speaker has rehearsed narration over the recording at least once.

#### Offline evidence and screenshots

- [ ] Pre-redacted screenshots of Intune portal state exist locally for every page the demo would otherwise load live.
- [ ] Offline screenshots and evidence examples are available for Graph and Defender proof points if used.
- [ ] The VS Code first-launch block dialog visual asset exists locally for the deck or stage and is not committed to the repository.
- [ ] No example screenshots are committed to the public v1 repo unless later Phase 10 work explicitly approves checked-in visual artifacts.

#### Redaction and secret safety

- [ ] No FileVault recovery key is visible in the demo path, deck, screenshots, recordings, evidence bundles, or public repo.
- [ ] No app secret is visible.
- [ ] No token is visible.
- [ ] No tenant secret is visible.
- [ ] No personal user data is visible.
- [ ] Evidence bundles exported during rehearsal have been spot-checked for redaction.
- [ ] Gatekeeper fixtures contain no Team IDs, profile UUIDs, local home paths, tenant identifiers, UPNs, device IDs, or secrets.
- [ ] `Protect-MacLabEvidence.ps1` exists and is used by the evidence workflow.
- [ ] The Intune admin center "Show recovery key" action is not invoked live on the projector.
- [ ] Recovery-key proof uses redacted screenshots, sanitized JSON, or protected evidence output.

The evidence-protection helper is named `Protect-MacLabEvidence.ps1`. Do **not** introduce `Redact-MacLabEvidence.ps1` as a public cmdlet name; `Redact-` is not an approved PowerShell verb.

#### Provider Version Matrix

- [ ] Provider Version Matrix is recorded for the event:
  - host macOS version and build
  - host Mac model and host macOS compatibility role
  - guest macOS version and build
  - host/guest pairing classification: `same-major`, `cross-major-tested`, or `rejected`
  - Parallels Desktop version
  - UTM version, if used
  - PowerShell 7.4+ version
  - Pester 5.7.1
  - Defender for Endpoint version, if used
  - Defender health output format and redaction status, if used
  - Intune policy-set version or change identifier
  - date tested

#### Host/demo state

- [ ] Notifications are disabled.
- [ ] Focus / Do Not Disturb is enabled.
- [ ] Screen lock and screen saver are disabled for the demo.
- [ ] Host auto-updates are disabled.
- [ ] Guest auto-updates are disabled.
- [ ] Hypervisor auto-updates are disabled during the demo cycle.

#### Physical contingency

- [ ] Spare A/V adapter is physically on hand.
- [ ] Stable charger and cable are physically on hand.
- [ ] Mobile hotspot or pre-trusted fallback SSID is available where permitted.
- [ ] Offline copy of the deck is available.
- [ ] Offline copy of the repo/starter kit is available.
- [ ] Offline screenshots are available.
- [ ] Break-glass recording is available offline.

#### TCC discipline

- [ ] One terminal application has been chosen for the demo flow.
- [ ] Required TCC permissions are granted to that exact app:
  - Automation
  - Full Disk Access
  - Files and Folders
  - Screen Recording
  - Accessibility
- [ ] The presenter will not switch terminal apps mid-demo.

#### Network readiness

- [ ] APNs path has been validated from the host and guest/shared-NAT path.
- [ ] Intune admin center loads.
- [ ] Demo tenant device list is visible.
- [ ] Graph access works if used.
- [ ] Defender cloud connectivity works if used.
- [ ] Hotspot or fallback SSID has been tested if permitted.
- [ ] Local-only fallback path is ready.

#### End-to-end rehearsal discipline

- [ ] You have tested the complete host + VM flow at least once before rehearsals.
- [ ] You have avoided last-minute upgrades to host apps, PowerShell modules, and VM software after your final successful rehearsal.

## Notes

- **Parallels Desktop Pro Edition** is the recommended edition because of its advanced feature set and CLI/API access such as `prlctl`.
- **Microsoft 365 E5** is the preferred tenant choice for the highest-fidelity demos; **Microsoft 365 Business Premium** is the acceptable lower-cost fallback.
- Install only the **specific Microsoft Graph PowerShell SDK submodules** you actually need, and avoid the `Microsoft.Graph` meta-module.
- Use **Pester 5.7.1** for initial rehearsal and CI validation.
- **Presentify** is the recommended macOS presentation tool. **ZoomIt for macOS** should not be part of the plan.
- **Apple MDM Push Certificate (APNs)** is a hard prerequisite for Intune macOS management. Use an **organization-owned Apple ID**, since the cert is non-transferable and renews annually.
- **Apple Business** is optional and only needed if you want to include ADE in the talk.
- After your environment is stable and rehearsed, avoid unnecessary updates until after the presentation.
- **Five-checkpoint model.** The required demo states per hypervisor are `Clean-OS`, `Pre-Enroll`, `Post-Enroll-Baseline`, `Broken-Policy-State`, and `Recovered-Known-Good`. Use this five-checkpoint vocabulary throughout the talk, the deck, and any companion artifacts; do **not** fall back to "the three required snapshots."
- **Evidence protection helper.** The evidence-protection helper is `Protect-MacLabEvidence.ps1`, which uses the approved PowerShell verb `Protect`. Do **not** introduce `Redact-MacLabEvidence.ps1` as a public cmdlet name (`Redact-` is not an approved verb).
- **Readiness gate.** `Test-LabReadiness.ps1` is the canonical T-15 readiness gate. It **must** return green before the session.
- **Media terminology.** Refer to the Apple-silicon macOS install media as a "restore image or provider-appropriate install artifact." For the current primary VM creation path, treat the IPSW/firmware restore image as the canonical artifact unless a tested provider version requires another documented artifact. When showing the wrapper helper, use `Get-MacLabMedia -Source Mist`. Do **not** use `Get-MacLabMedia -Provider Mist`; reserve `-Provider` for hypervisors such as Parallels, UTM, and Tart.
- **PowerShell floor.** Use PowerShell 7.4 or newer only.
- **Tart license and scope.** Tart is optional and stubbed in v1 unless later work explicitly approves a fuller provider. Treat Tart's Fair Source/free-tier 100 CPU-core limit and Orchard's 4-worker limit as planning constraints, not legal advice.
- **Host/guest macOS coverage.** Same-major host/guest macOS is the safest default for Apple-silicon macOS guests. If you need reliable coverage for macOS 14.x, 15.x, and 26.x at the same time, plan for up to three Apple-silicon host Macs and verify each model can boot the required host macOS. Newest hardware is not automatically best for older guest coverage because it may not support older host macOS releases.
- **Parallels isolation verification.** Do not trust the Parallels macOS VM defaults to match this lab's isolation policy. Verify the created VM's provider info and disable host integration before the first durable snapshot.
- **VM fidelity boundary.** The VM lab is for safe iteration, regression, and evidence automation. It does **not** replace physical Mac sign-off for hardware/security-model-dependent flows such as ADE / ABM zero-touch, Platform SSO, Touch ID, Secure Enclave-dependent behavior, and final FileVault rollout validation. **VM first, hardware last.**
- **Cloud rollback boundary.** Snapshot rollback restores the VM. It does **not** rewind Intune, Entra, Defender portal state, audit logs, compliance history, or cloud reporting. In v1, `Reset-IntuneMacLabDevice.ps1` is report-only and documents manual cleanup steps; it does not mutate cloud records.

## Public Source Notes to Re-check

Re-check these before implementation or final deck freeze because Apple, Parallels, UTM, Tart, and Microsoft behavior can change:

- [Apple Support: How to download and install macOS](https://support.apple.com/en-us/102662), especially the compatibility and installer-download notes that macOS versions must be compatible with the Mac and no earlier than the version that came with it.
- [Parallels CLI: Create a Virtual Machine](https://docs.parallels.com/landing/parallels-desktop-developers-guide/command-line-interface-utility/manage-virtual-machines-from-cli/general-virtual-machine-management/create-a-virtual-machine), especially the restore-image command and same-major host/guest note for Apple Silicon macOS VMs.
- [Parallels KB 128867: Known limitations of macOS virtual machines on Mac computers with Apple silicon](https://kb.parallels.com/en/128867), especially Apple Virtualization framework limits, snapshots, USB, networking, and higher-than-host guest warnings.
- [UTM macOS guest support](https://docs.getutm.app/guest-support/macos/), especially Apple Virtualization requirements and IPSW guidance.
- [UTM Apple backend settings](https://docs.getutm.app/settings-apple/settings-apple/), especially the note that Apple Virtualization is the only UTM path for virtualized macOS on Apple Silicon.
- [Tart documentation](https://tart.run/), especially its Apple Virtualization framework positioning and CI/runner use case.
