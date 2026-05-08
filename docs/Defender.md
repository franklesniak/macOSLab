<!-- markdownlint-disable MD013 -->
# Defender

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-07
- **Scope:** Documents guest-scoped Microsoft Defender for Endpoint validation and Intune setup for the macOSLab demo path.
- **Related:** [Evidence Redaction](Evidence-Redaction.md), [Evidence and CAB](Evidence-and-CAB.md), [Phase 8 TODO](../TODO-Phase-08-Validation-Loop.md), [Defender validation plan](../examples/TestCases/Defender-Validation.yml)

## Scope

Defender validation is guest-scoped. The daily-driver host Mac is intentionally not required to have Defender installed. `mdatp health` evidence MUST be collected inside the disposable enrolled macOS guest.

Defender remains a required validation model for the accepted session contract, but it is no longer the live Demo 4 break-and-rollback failure. Demo 4 uses Gatekeeper/System Policy Control to block VS Code on first launch because that rollback story is deterministic and does not depend on Defender portal timing. The default Defender path is Intune-based Defender deployment after enrollment. A preinstalled-Defender guest MAY be kept only as a rehearsal or live-cloud timing fallback and MUST be labeled as a fallback.

## Enrollment Demo Posture

Company Portal enrollment SHOULD be completed before the live demo. Treat live enrollment as an optional walkthrough, not the required path for Demo 4.

Use these checkpoints:

| Checkpoint | Enrollment state | Demo use |
| --- | --- | --- |
| `Pre-Enroll` | Company Portal is installed or ready to install; no lab user is signed in; the VM is not enrolled. | Optional live walkthrough only. |
| `Post-Enroll-Baseline` | The VM is enrolled, visible in Intune, recently synced, and targeted by the Defender app and profiles. | Default live demo starting point. |

Conference Wi-Fi is a known risk. Download and install Company Portal inside the guest before the event, then capture `Pre-Enroll` before signing in. Complete enrollment on reliable network before the event, wait for Defender policy delivery, and capture `Post-Enroll-Baseline`.

Keep a host-side copy of `CompanyPortal-Installer.pkg` under `~/Demo/Installers` for rebuilds, but do not commit it. The final demo should not depend on host-to-guest file sharing because the lab posture disables host integrations where possible.

## Intune Setup

If no Defender profiles exist for macOS yet, create them first. "Open the profile" means open one of the macOS configuration policies listed in this section after it has been created in Intune.

A Windows Defender policy does not replace these macOS profiles. The demo guest needs policies whose platform is `macOS`, plus the Microsoft Defender for Endpoint macOS app and the macOS onboarding package.

1. Download the current Microsoft Defender for Endpoint macOS package and onboarding package from the Microsoft Defender portal.
2. In Intune admin center, add the Defender package as a macOS line-of-business app or the current recommended Microsoft app type for Defender.
3. Assign the app to the macOS lab device group used by the demo guest.
4. Create or import the Defender system extension profile for macOS.
5. Create the Network Extension profile if the selected Defender configuration uses network filtering.
6. Create the PPPC profile that grants Full Disk Access to Defender components.
7. Deploy the onboarding configuration profile to the same lab device group.
8. Confirm app, system extension, network extension, PPPC, and onboarding profiles all target the enrolled guest.
9. Sync the guest from Company Portal or Intune, then allow enough time for app installation and profile delivery.
10. Verify inside the guest with `mdatp version` and `mdatp health`.

## Required macOS Defender App

Create the Defender app separately from the configuration policies because it lives under **Apps**, not **Devices**.

| Purpose | Proposed object name | Intune location | App type | Required detail |
| --- | --- | --- | --- | --- |
| Defender app | `MacLab - MDE - App - macOS` | **Apps** > **macOS** > **Create** | Microsoft Defender for Endpoint for macOS app | Assign to the macOS lab device group. |

## Required macOS Defender Configuration Policies

For the demo tenant, create these as macOS configuration policies. Use names that make them easy to recognize in Intune, for example `MacLab - MDE - System Extensions - macOS`.

Create one Intune policy per row in the table under **Devices** > **Manage devices** > **Configuration** > **Policies** > **Create** > **New policy**. Do not put all Defender payloads into one policy because they use different Intune profile types and different `.mobileconfig` files.

The system extensions row is one Settings Catalog policy that contains both Defender system extension bundle IDs. Each custom `.mobileconfig` payload is its own separate macOS Custom configuration policy.

| Purpose | Proposed policy name | Intune location | Policy type | Required detail |
| --- | --- | --- | --- | --- |
| System extensions | `MacLab - MDE - System Extensions - macOS` | **Devices** > **Configuration** > **Create** > **New policy** | Platform `macOS`, profile type `Settings catalog` | Add `Allowed System Extensions` with both Defender bundle IDs and team ID `UBF8T346G9`. |
| Network filter | `MacLab - MDE - Network Filter - macOS` | **Devices** > **Configuration** > **Create** > **New policy** | Platform `macOS`, profile type `Templates`, template `Custom` | Upload Microsoft's `netfilter.mobileconfig` for the default demo path. |
| Full Disk Access | `MacLab - MDE - Full Disk Access - macOS` | **Devices** > **Configuration** > **Create** > **New policy** | Platform `macOS`, profile type `Templates`, template `Custom` | Upload Microsoft's `fulldisk.mobileconfig`. |
| Background services | `MacLab - MDE - Background Services - macOS` | **Devices** > **Configuration** > **Create** > **New policy** | Platform `macOS`, profile type `Templates`, template `Custom` | Upload Microsoft's `background_services.mobileconfig`, especially for macOS Ventura or newer. |
| Notifications | `MacLab - MDE - Notifications - macOS` | **Devices** > **Configuration** > **Create** > **New policy** | Platform `macOS`, profile type `Templates`, template `Custom` | Upload Microsoft's `notif.mobileconfig` if Defender notifications should be pre-approved. |
| Defender preferences | `MacLab - MDE - Preferences - macOS` | **Devices** > **Configuration** > **Create** > **New policy** | Platform `macOS`, profile type `Templates`, template `Custom` | Upload a `com.microsoft.wdav.xml` preferences profile when the demo needs explicit Defender settings. |
| Onboarding | `MacLab - MDE - Onboarding - macOS` | **Devices** > **Configuration** > **Create** > **New policy** | Platform `macOS`, profile type `Templates`, template `Custom` | Upload `WindowsDefenderATPOnboarding.xml` from the Defender portal macOS onboarding package. |

Microsoft's current [Intune deployment guide for Defender on macOS](https://learn.microsoft.com/defender-endpoint/mac-install-with-intune) configures only **Allowed System Extensions** for the system extension approval step. A separate Microsoft profile-approval page also shows **Allowed System Extension Types**, but keep the default demo policy aligned to the deployment guide unless Microsoft support or later validation says otherwise. Do not add the same Team ID under **Allowed Team Identifiers**.

Microsoft's current Intune deployment guide lists additional optional macOS profiles such as Accessibility, Bluetooth, Microsoft AutoUpdate, Device Control, and Data Loss Prevention. Add those only when the demo scenario needs them.

After creating each policy, assign it to the macOS lab device group. Then enroll the guest, sync Company Portal, and check each policy's **Device and user check-in status** from **Devices** > **Configuration**.

### System Extensions Settings Catalog Walkthrough

Use these steps when you are sitting in the Settings picker for `MacLab - MDE - System Extensions - macOS`.

1. In the Settings picker search box, enter `allowed system`.
2. Select **Search**.
3. Under **Browse by category**, select **System Configuration** > **System Extensions**.
4. Check **Allowed System Extensions**.
5. Leave **Allowed System Extension Types** unselected for the default demo path.
6. Leave **Allowed Team Identifiers** unselected.
7. Close the Settings picker if it is blocking the main configuration page.
8. Under **Allowed System Extensions**, select **Edit instance**.
9. In **Allowed System Extensions**, add `com.microsoft.wdav.epsext` and `com.microsoft.wdav.netext`, one value per box.
10. In **Team identifier**, enter `UBF8T346G9`.

11. Select **Save**.
12. Select **Next**.
13. On **Assignments**, assign the policy to the macOS lab device group.
14. Review and create the policy.

### System Extensions Waiting For User Triage

If `systemextensionsctl list` shows `[activated waiting for user]` for `com.microsoft.wdav.netext` or `com.microsoft.wdav.epsext`, Defender is installed, but macOS has not accepted the system extension approval yet. In the Intune demo path, do not depend on finding a manual **Allow** button in System Settings. Treat this as a profile-delivery or profile-content problem until the MDM approval profile is confirmed on the Mac.

Microsoft documents this state in its [Defender for Endpoint macOS system extension troubleshooting guide](https://learn.microsoft.com/defender-endpoint/mac-support-sys-ext).

Use this checklist:

1. In the Intune admin center, go to **Devices** > **Configuration**.
2. Open `MacLab - MDE - System Extensions - macOS`.
3. Confirm the policy is assigned to the macOS lab device group.
4. Confirm the enrolled VM is a member of that lab device group.
5. Open the policy settings and confirm **Allowed System Extensions** contains both bundle IDs:

   ```text
   com.microsoft.wdav.epsext
   com.microsoft.wdav.netext
   ```

6. Confirm the **Allowed System Extensions** team identifier is:

   ```text
   UBF8T346G9
   ```

7. Confirm **Allowed Team Identifiers** is not also configured with `UBF8T346G9`.
8. Confirm **Allowed System Extension Types** is not configured in the default demo policy unless you are intentionally following Microsoft's separate profile-approval walkthrough.
9. Force a policy sync from Company Portal or from the Intune admin center.
10. Wait several minutes. App install, profile delivery, and Defender health do not always settle on the same check-in.
11. In the guest, run:

    ```bash
    mdatp health --details system_extensions
    systemextensionsctl list
    profiles status -type enrollment
    ls -l "/Library/Managed Preferences/com.apple.system-extension-policy.plist"
    ```

12. If `com.apple.system-extension-policy.plist` is missing, the system extension approval policy has not reached the Mac. Recheck assignment, group membership, and **Device and user check-in status** for the policy.
13. If the file exists but the extensions still show `[activated waiting for user]`, restart the guest and check again.
14. If the restart does not clear it, leave the VM in this state for evidence, then fix the Intune policy before capturing `Post-Enroll-Baseline`.

### Network Filter Custom Profile Walkthrough

Use these steps to create `MacLab - MDE - Network Filter - macOS`. This is a separate macOS Custom configuration policy.

1. Download Microsoft's `netfilter.mobileconfig` file to your admin workstation:

   ```bash
   mkdir -p "$HOME/Demo/IntuneProfiles/MDE"
   curl -L -o "$HOME/Demo/IntuneProfiles/MDE/netfilter.mobileconfig" "https://raw.githubusercontent.com/microsoft/mdatp-xplat/master/macos/mobileconfig/profiles/netfilter.mobileconfig"
   ls -lh "$HOME/Demo/IntuneProfiles/MDE/netfilter.mobileconfig"
   ```

   PowerShell equivalent:

   ```powershell
   $profileRoot = Join-Path -Path $HOME -ChildPath 'Demo/IntuneProfiles/MDE'
   New-Item -Path $profileRoot -ItemType Directory -Force | Out-Null

   $profilePath = Join-Path -Path $profileRoot -ChildPath 'netfilter.mobileconfig'
   Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/microsoft/mdatp-xplat/master/macos/mobileconfig/profiles/netfilter.mobileconfig' -OutFile $profilePath
   Get-Item -Path $profilePath | Select-Object -Property FullName, Length, LastWriteTime
   ```

2. In the Intune admin center, go to **Devices**.
3. Go to **Manage devices** > **Configuration**.
4. On **Policies**, select **Create** > **New policy**.
5. Set **Platform** to **macOS**.
6. Set **Profile type** to **Templates**.
7. Set **Template name** to **Custom**.
8. Select **Create**.
9. On **Basics**, set **Name** to `MacLab - MDE - Network Filter - macOS`.
10. Add a description such as `Approves the Microsoft Defender network extension for macOS lab VMs.`
11. Select **Next**.
12. On **Configuration settings**, set **Custom configuration profile name** to `MacLab - MDE - Network Filter - macOS`.
13. Set **Deployment channel** to the device channel option available in your tenant.
14. For **Configuration profile file**, select the downloaded `netfilter.mobileconfig` file.
15. Select **Next**.
16. On **Scope tags**, keep the default scope tag unless the tenant requires a different tag.
17. Select **Next**.
18. On **Assignments**, assign the policy to the macOS lab device group.
19. Select **Next**.
20. Review the policy and select **Create**.

Only one network filter profile should target the same macOS guest. If another network filter profile already applies to the lab VM, stop and decide which one owns the network extension before assigning this policy.

### Full Disk Access Custom Profile Walkthrough

Use these steps to create `MacLab - MDE - Full Disk Access - macOS`. This is a separate macOS Custom configuration policy.

1. Download Microsoft's `fulldisk.mobileconfig` file to your admin workstation:

   ```bash
   mkdir -p "$HOME/Demo/IntuneProfiles/MDE"
   curl -L -o "$HOME/Demo/IntuneProfiles/MDE/fulldisk.mobileconfig" "https://raw.githubusercontent.com/microsoft/mdatp-xplat/master/macos/mobileconfig/profiles/fulldisk.mobileconfig"
   ls -lh "$HOME/Demo/IntuneProfiles/MDE/fulldisk.mobileconfig"
   ```

   PowerShell equivalent:

   ```powershell
   $profileRoot = Join-Path -Path $HOME -ChildPath 'Demo/IntuneProfiles/MDE'
   New-Item -Path $profileRoot -ItemType Directory -Force | Out-Null

   $profilePath = Join-Path -Path $profileRoot -ChildPath 'fulldisk.mobileconfig'
   Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/microsoft/mdatp-xplat/master/macos/mobileconfig/profiles/fulldisk.mobileconfig' -OutFile $profilePath
   Get-Item -Path $profilePath | Select-Object -Property FullName, Length, LastWriteTime
   ```

2. In the Intune admin center, go to **Devices**.
3. Go to **Manage devices** > **Configuration**.
4. On **Policies**, select **Create** > **New policy**.
5. Set **Platform** to **macOS**.
6. Set **Profile type** to **Templates**.
7. Set **Template name** to **Custom**.
8. Select **Create**.
9. On **Basics**, set **Name** to `MacLab - MDE - Full Disk Access - macOS`.
10. Add a description such as `Grants Full Disk Access to Microsoft Defender for macOS lab VMs.`
11. Select **Next**.
12. On **Configuration settings**, set **Custom configuration profile name** to `MacLab - MDE - Full Disk Access - macOS`.
13. Set **Deployment channel** to the device channel option available in your tenant.
14. For **Configuration profile file**, select the downloaded `fulldisk.mobileconfig` file.
15. Select **Next**.
16. On **Scope tags**, keep the default scope tag unless the tenant requires a different tag.
17. Select **Next**.
18. On **Assignments**, assign the policy to the macOS lab device group.
19. Select **Next**.
20. Review the policy and select **Create**.

Full Disk Access granted by an MDM configuration profile might not appear in **System Settings** > **Privacy & Security** > **Full Disk Access**. Use policy receipt and `mdatp health` evidence instead of relying only on that UI.

### Background Services Custom Profile Walkthrough

Use these steps to create `MacLab - MDE - Background Services - macOS`. This is a separate macOS Custom configuration policy.

1. Download Microsoft's `background_services.mobileconfig` file to your admin workstation:

   ```bash
   mkdir -p "$HOME/Demo/IntuneProfiles/MDE"
   curl -L -o "$HOME/Demo/IntuneProfiles/MDE/background_services.mobileconfig" "https://raw.githubusercontent.com/microsoft/mdatp-xplat/master/macos/mobileconfig/profiles/background_services.mobileconfig"
   ls -lh "$HOME/Demo/IntuneProfiles/MDE/background_services.mobileconfig"
   ```

   PowerShell equivalent:

   ```powershell
   $profileRoot = Join-Path -Path $HOME -ChildPath 'Demo/IntuneProfiles/MDE'
   New-Item -Path $profileRoot -ItemType Directory -Force | Out-Null

   $profilePath = Join-Path -Path $profileRoot -ChildPath 'background_services.mobileconfig'
   Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/microsoft/mdatp-xplat/master/macos/mobileconfig/profiles/background_services.mobileconfig' -OutFile $profilePath
   Get-Item -Path $profilePath | Select-Object -Property FullName, Length, LastWriteTime
   ```

2. In the Intune admin center, go to **Devices**.
3. Go to **Manage devices** > **Configuration**.
4. On **Policies**, select **Create** > **New policy**.
5. Set **Platform** to **macOS**.
6. Set **Profile type** to **Templates**.
7. Set **Template name** to **Custom**.
8. Select **Create**.
9. On **Basics**, set **Name** to `MacLab - MDE - Background Services - macOS`.
10. Add a description such as `Allows Microsoft Defender background services for macOS lab VMs.`
11. Select **Next**.
12. On **Configuration settings**, set **Custom configuration profile name** to `MacLab - MDE - Background Services - macOS`.
13. Set **Deployment channel** to the device channel option available in your tenant.
14. For **Configuration profile file**, select the downloaded `background_services.mobileconfig` file.
15. Select **Next**.
16. On **Scope tags**, keep the default scope tag unless the tenant requires a different tag.
17. Select **Next**.
18. On **Assignments**, assign the policy to the macOS lab device group.
19. Select **Next**.
20. Review the policy and select **Create**.

This profile is especially important for macOS Ventura or newer because macOS requires explicit approval before apps can run background services without user prompts.

### Notifications Custom Profile Walkthrough

Use these steps to create `MacLab - MDE - Notifications - macOS`. This is a separate macOS Custom configuration policy.

1. Download Microsoft's `notif.mobileconfig` file to your admin workstation:

   ```bash
   mkdir -p "$HOME/Demo/IntuneProfiles/MDE"
   curl -L -o "$HOME/Demo/IntuneProfiles/MDE/notif.mobileconfig" "https://raw.githubusercontent.com/microsoft/mdatp-xplat/master/macos/mobileconfig/profiles/notif.mobileconfig"
   ls -lh "$HOME/Demo/IntuneProfiles/MDE/notif.mobileconfig"
   ```

   PowerShell equivalent:

   ```powershell
   $profileRoot = Join-Path -Path $HOME -ChildPath 'Demo/IntuneProfiles/MDE'
   New-Item -Path $profileRoot -ItemType Directory -Force | Out-Null

   $profilePath = Join-Path -Path $profileRoot -ChildPath 'notif.mobileconfig'
   Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/microsoft/mdatp-xplat/master/macos/mobileconfig/profiles/notif.mobileconfig' -OutFile $profilePath
   Get-Item -Path $profilePath | Select-Object -Property FullName, Length, LastWriteTime
   ```

2. In the Intune admin center, go to **Devices**.
3. Go to **Manage devices** > **Configuration**.
4. On **Policies**, select **Create** > **New policy**.
5. Set **Platform** to **macOS**.
6. Set **Profile type** to **Templates**.
7. Set **Template name** to **Custom**.
8. Select **Create**.
9. On **Basics**, set **Name** to `MacLab - MDE - Notifications - macOS`.
10. Add a description such as `Pre-approves Microsoft Defender notifications for macOS lab VMs.`
11. Select **Next**.
12. On **Configuration settings**, set **Custom configuration profile name** to `MacLab - MDE - Notifications - macOS`.
13. Set **Deployment channel** to the device channel option available in your tenant.
14. For **Configuration profile file**, select the downloaded `notif.mobileconfig` file.
15. Select **Next**.
16. On **Scope tags**, keep the default scope tag unless the tenant requires a different tag.
17. Select **Next**.
18. On **Assignments**, assign the policy to the macOS lab device group.
19. Select **Next**.
20. Review the policy and select **Create**.

This profile is optional for core Defender health evidence, but it reduces user prompts and keeps the demo cleaner.

### Defender Preferences Custom Profile Walkthrough

Use these steps to create `MacLab - MDE - Preferences - macOS`. This is a separate macOS Custom configuration policy. It is optional for the default demo unless you want explicit managed Defender settings such as real-time protection, cloud-delivered protection, automatic definition updates, or tamper protection.

1. Open Microsoft's [Set preferences for Microsoft Defender for Endpoint on macOS](https://learn.microsoft.com/defender-endpoint/mac-preferences) documentation.
2. Find the **Intune recommended profile** section.
3. Copy the XML from that section into a local file named `com.microsoft.wdav.xml`.

   Bash setup:

   ```bash
   mkdir -p "$HOME/Demo/IntuneProfiles/MDE"
   nano "$HOME/Demo/IntuneProfiles/MDE/com.microsoft.wdav.xml"
   plutil -lint "$HOME/Demo/IntuneProfiles/MDE/com.microsoft.wdav.xml"
   ls -lh "$HOME/Demo/IntuneProfiles/MDE/com.microsoft.wdav.xml"
   ```

   PowerShell setup:

   ```powershell
   $profileRoot = Join-Path -Path $HOME -ChildPath 'Demo/IntuneProfiles/MDE'
   New-Item -Path $profileRoot -ItemType Directory -Force | Out-Null

   $profilePath = Join-Path -Path $profileRoot -ChildPath 'com.microsoft.wdav.xml'
   notepad $profilePath
   [xml]$profile = Get-Content -Path $profilePath -Raw
   Get-Item -Path $profilePath | Select-Object -Property FullName, Length, LastWriteTime
   ```

4. Confirm the file name is exactly `com.microsoft.wdav.xml`.
5. Confirm the file contains no tenant IDs, tokens, user names, or lab-only secrets.
6. In the Intune admin center, go to **Devices**.
7. Go to **Manage devices** > **Configuration**.
8. On **Policies**, select **Create** > **New policy**.
9. Set **Platform** to **macOS**.
10. Set **Profile type** to **Templates**.
11. Set **Template name** to **Custom**.
12. Select **Create**.
13. On **Basics**, set **Name** to `MacLab - MDE - Preferences - macOS`.
14. Add a description such as `Applies Microsoft Defender preferences for macOS lab VMs.`
15. Select **Next**.
16. On **Configuration settings**, set **Custom configuration profile name** to `com.microsoft.wdav`.
17. Set **Deployment channel** to the device channel option available in your tenant.
18. For **Configuration profile file**, select the local `com.microsoft.wdav.xml` file.
19. Select **Next**.
20. On **Scope tags**, keep the default scope tag unless the tenant requires a different tag.
21. Select **Next**.
22. On **Assignments**, assign the policy to the macOS lab device group.
23. Select **Next**.
24. Review the policy and select **Create**.

The **Custom configuration profile name** must be exactly `com.microsoft.wdav`; otherwise, Defender will not read the preferences.

### Onboarding Custom Profile Walkthrough

Use these steps to create `MacLab - MDE - Onboarding - macOS`. This is a separate macOS Custom configuration policy. The onboarding XML comes from your Microsoft Defender portal and is tenant-specific, so keep it outside the repository and do not commit it.

1. Open the [Microsoft Defender portal](https://security.microsoft.com).
2. Go to **Settings**.
3. Go to **Endpoints**.
4. Under **Device management**, select **Onboarding**.
5. For **Select operating system to start the onboarding process**, select **macOS**.
6. For **Deployment method**, select **Mobile Device Management / Microsoft Intune**.
7. Select **Download onboarding package**.
8. Save the downloaded ZIP as `GatewayWindowsDefenderATPOnboardingPackage.zip`.
9. Move or copy the ZIP into your local demo staging folder.

   Bash extraction:

   ```bash
   mkdir -p "$HOME/Demo/IntuneProfiles/MDE/Onboarding"
   cp "$HOME/Downloads/GatewayWindowsDefenderATPOnboardingPackage.zip" "$HOME/Demo/IntuneProfiles/MDE/Onboarding/"
   cd "$HOME/Demo/IntuneProfiles/MDE/Onboarding"
   unzip -o GatewayWindowsDefenderATPOnboardingPackage.zip
   ls -lh intune/WindowsDefenderATPOnboarding.xml
   ```

   PowerShell extraction:

   ```powershell
   $onboardingRoot = Join-Path -Path $HOME -ChildPath 'Demo/IntuneProfiles/MDE/Onboarding'
   New-Item -Path $onboardingRoot -ItemType Directory -Force | Out-Null

   $downloadedZip = Join-Path -Path $HOME -ChildPath 'Downloads/GatewayWindowsDefenderATPOnboardingPackage.zip'
   Copy-Item -Path $downloadedZip -Destination $onboardingRoot -Force

   $zipPath = Join-Path -Path $onboardingRoot -ChildPath 'GatewayWindowsDefenderATPOnboardingPackage.zip'
   Expand-Archive -Path $zipPath -DestinationPath $onboardingRoot -Force

   $intuneFolder = Join-Path -Path $onboardingRoot -ChildPath 'intune'
   $onboardingXml = Join-Path -Path $intuneFolder -ChildPath 'WindowsDefenderATPOnboarding.xml'
   Get-Item -Path $onboardingXml | Select-Object -Property FullName, Length, LastWriteTime
   ```

10. Confirm the extracted file path ends with `intune/WindowsDefenderATPOnboarding.xml`.
11. In the Intune admin center, go to **Devices**.
12. Go to **Manage devices** > **Configuration**.
13. On **Policies**, select **Create** > **New policy**.
14. Set **Platform** to **macOS**.
15. Set **Profile type** to **Templates**.
16. Set **Template name** to **Custom**.
17. Select **Create**.
18. On **Basics**, set **Name** to `MacLab - MDE - Onboarding - macOS`.
19. Add a description such as `Onboards macOS lab VMs to Microsoft Defender for Endpoint.`
20. Select **Next**.
21. On **Configuration settings**, set **Custom configuration profile name** to `MacLab - MDE - Onboarding - macOS`.
22. Set **Deployment channel** to the device channel option available in your tenant.
23. For **Configuration profile file**, select the extracted `WindowsDefenderATPOnboarding.xml` file from the `intune` folder.
24. Select **Next**.
25. On **Scope tags**, keep the default scope tag unless the tenant requires a different tag.
26. Select **Next**.
27. On **Assignments**, assign the policy to the macOS lab device group.
28. Select **Next**.
29. Review the policy and select **Create**.

After the guest receives this profile and the Defender app is installed, `mdatp health` should stop reporting a missing license or onboarding state. If it still reports onboarding or license problems, confirm that the VM is in the assigned macOS lab device group and has synced after the policy was created.

## Company Portal Enrollment Walkthrough

Use this walkthrough inside the disposable macOS guest. The official Microsoft user flow is [Enroll your macOS device using the Company Portal app](https://learn.microsoft.com/intune/user-help/enrollment/enroll-company-portal-macos).

### Pre-Download

Run this on the host Mac before the conference so the installer is available if the VM must be rebuilt:

```bash
mkdir -p "$HOME/Demo/Installers"
curl -L -o "$HOME/Demo/Installers/CompanyPortal-Installer.pkg" "https://go.microsoft.com/fwlink/?linkid=853070"
ls -lh "$HOME/Demo/Installers/CompanyPortal-Installer.pkg"
```

For the actual pre-staged VM, the preferred path is to download and install Company Portal from inside the guest while network is reliable. Do not depend on copying files into the guest during the live demo.

### Install Company Portal In The Guest

1. Start the disposable macOS guest.
2. Complete Setup Assistant if the VM is still at first boot.
3. Use a local admin account created only for the lab VM.
4. Confirm the guest has network access.
5. Open Safari inside the guest.
6. Go to [Enroll My Mac](https://go.microsoft.com/fwlink/?linkid=853070).
7. Wait for `CompanyPortal-Installer.pkg` to download.
8. Open the downloaded package.
9. Select **Continue** on the Introduction page.
10. Select **Continue** on the License page.
11. Select **Agree**.
12. Select **Install**.
13. Enter the local VM admin password when macOS asks.
14. Select **Install Software**.
15. Wait for installation to finish.
16. Open **Applications**.
17. Open **Company Portal**.
18. Stop here if preparing the `Pre-Enroll` checkpoint.
19. Shut down the VM.
20. Capture `Pre-Enroll`.

### Enroll The Guest

Start from `Pre-Enroll` when you are ready to enroll:

1. Start the VM.
2. Open **Company Portal**.
3. Sign in as the lab-only user, for example `lab.user@contoso-lab.onmicrosoft.example`.
4. Select **Begin**.
5. Continue through the privacy and management screens.
6. Select **Download profile** when Company Portal asks for the management profile.
7. System Settings opens to Profiles or Device Management.
8. Select the downloaded management profile.
9. Select **Install**.
10. Confirm the install prompt.
11. Enter the local VM admin password.
12. Wait for macOS to show the profile as installed.
13. Return to Company Portal.
14. Let Company Portal finish registration.
15. If a keychain prompt appears, enter the login keychain password and select **Always Allow**.
16. Confirm Company Portal shows the device as enrolled or compliant enough to continue.
17. In the Intune admin center, confirm the device appears under **Devices**.
18. Add the device to the macOS lab device group if the group is assigned membership.
19. Trigger a sync from Company Portal.
20. Wait for the Defender app, system extension profile, PPPC profile, onboarding profile, and optional network extension profile to arrive.
21. Verify inside the guest with `mdatp version` and `mdatp health`.
22. Shut down the guest.
23. Capture `Post-Enroll-Baseline`.

If enrollment stalls during a live walkthrough, stop the walkthrough and restore or open the prepared `Post-Enroll-Baseline` VM. Do not troubleshoot tenant timing on stage.

## Force A Policy Sync

Use a manual sync after assigning Defender apps or configuration policies to the macOS lab device group. The guest must be enrolled, online, and able to reach Intune.

### Sync From The Mac

Use this path when you are inside the enrolled guest VM:

1. Open **Company Portal**.
2. Select **Devices**.
3. If Company Portal lists more than one device, select the current lab Mac.
4. Select **Check Status**.
5. Wait for Company Portal to finish checking the device.
6. Leave the VM online for several minutes after the check finishes so profiles and apps can continue arriving.

In some Company Portal versions, the same action may appear under **Settings** > **Sync**. Use **Check Status** from **Devices** when that is the option shown.

### Sync From Intune Admin Center

Use this path when you are in the Intune portal:

1. Open the [Intune admin center](https://intune.microsoft.com).
2. Go to **Devices**.
3. Go to **All devices**.
4. Select the macOS lab VM.
5. Select **Sync** from the action row at the top of the device page.
6. Confirm with **Yes**.
7. Wait several minutes, then refresh the device page and the relevant policy status pages.

The Intune **Sync** action forces a check-in, but it does not guarantee every app install or Defender state change is complete the moment the button is clicked. For new macOS enrollments, Microsoft documents more frequent check-ins during the first hour, then a longer regular refresh interval. For the demo, use sync to speed up validation, then verify with profile receipt and `mdatp health`.

## Evidence

The repository parser treats `mdatp health` as key/value text because owner evidence showed the `.raw.json` capture contained text, not parseable JSON. Fields such as organization ID, machine GUID, EDR machine ID, EDR tags, tenant IDs, user IDs, and device IDs MUST be redacted before evidence is written.

The fixture [examples/TestCases/fixtures/mdatp-health-unhealthy.txt](../examples/TestCases/fixtures/mdatp-health-unhealthy.txt) represents the pre-approval unhealthy state where event providers or Full Disk Access are missing. The fixture [examples/TestCases/fixtures/mdatp-health-healthy.txt](../examples/TestCases/fixtures/mdatp-health-healthy.txt) represents the sanitized working guest state captured after Defender onboarding, system extension approval, network filter activation, and Full Disk Access delivery.
