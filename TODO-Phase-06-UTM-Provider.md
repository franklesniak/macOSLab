<!-- markdownlint-disable MD013 -->
# TODO Phase 06 UTM Provider

## Metadata

- **Status:** Approved for implementation handoff
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Deferred verification for UTM automation and manual-step boundaries before implementing Phase 6.

## Confirmed Preflight Evidence

Owner-supplied sanitized preflight evidence from a macOS host confirms:

- Host baseline: Apple Silicon (`arm64`) running macOS 26.4.1 build 25E253.
- UTM is installed under `/Applications/UTM.app`.
- `defaults read /Applications/UTM.app/Contents/Info.plist CFBundleShortVersionString` reports UTM 4.7.5.
- Gatekeeper accepted the app, with Mac App Store signing reported.
- `utmctl` help is available at `/Applications/UTM.app/Contents/MacOS/utmctl`.
- A later sanitized evidence bundle confirmed `/Applications/UTM.app/Contents/MacOS/utmctl version` returns `4.7.5`.
- Top-level `utmctl` help lists `version`, `list`, `status`, `start`, `suspend`, `stop`, `attach`, `file`, `exec`, `ip-address`, `clone`, `delete`, and `usb`.
- Top-level `utmctl` help does not advertise create/import/snapshot primitives. Treat VM creation and snapshot management as manual-step candidates until proven otherwise.
- Top-level `utmctl` help describes `delete` as having no confirmation, so destructive delete tests MUST run only against disposable VMs.
- `utmctl list` returned only the table header, confirming no registered UTM VMs existed at capture time. It may launch or foreground UTM because it controls the installed app.
- The 2026-05-05 round-two sanitized evidence bundle confirmed `utmctl list` still returned only the table header and did not include a VM named `macOSLab-UTM-Disposable`; that disposable UTM VM still needs to be created before lifecycle testing.
- The same round-two evidence confirmed the pinned macOS Tahoe 26.4.1 IPSW is available at `~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw` with SHA-256 `8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32`, so UTM validation can now use that artifact.
- Round-three evidence confirmed a disposable UTM VM named `macOSLab-UTM-Disposable` was created and registered; `utmctl list` reported it as `started`.
- `utmctl status macOSLab-UTM-Disposable` reported `started`, then `paused` after `utmctl suspend`, and `stopped` after `utmctl stop`.
- `utmctl suspend macOSLab-UTM-Disposable` returned exit code 0 and changed the VM status to `paused`.
- `utmctl start macOSLab-UTM-Disposable` returned exit code 0 when resuming from `paused`.
- `utmctl stop macOSLab-UTM-Disposable` returned exit code 0 and changed the VM status to `stopped`.
- `utmctl start macOSLab-UTM-Disposable` while the VM was already `started` printed `Operation not available` but still returned exit code 0. Provider code MUST inspect command output and resulting status, not only the process exit code.
- `utmctl ip-address macOSLab-UTM-Disposable` printed `Operation not supported by the backend` but still returned exit code 0. Treat IP address discovery as unsupported for this UTM macOS Apple Virtualization path unless later evidence proves a supported configuration.
- Round-four evidence confirmed `utmctl start macOSLab-UTM-Disposable` works from a stopped state and changes status from `stopped` to `started`.
- Round-four evidence confirmed `utmctl stop macOSLab-UTM-Disposable` works after start-from-stopped and changes status back to `stopped`.
- `utmctl help exec` confirms guest command execution syntax is `utmctl exec <identifier> --cmd <cmd> ...`; it does not by itself prove guest execution works for this macOS VM.
- `utmctl help file` confirms guest-agent file operations exist only as `file pull` and `file push`; it does not by itself prove file transfer works for this macOS VM.
- `utmctl help clone` confirms clone syntax is `utmctl clone <identifier> --name <name>`.
- `utmctl help delete` confirms delete syntax is `utmctl delete <identifier>` and repeats that delete has no confirmation.

Do not commit the raw or sanitized preflight capture bundle. Convert it into durable commands, expected fields, fixtures, and redacted examples only.

## Approved Decision

The owner approved the v1 UTM posture on 2026-05-05 after reviewing the round-three and round-four validation evidence.

UTM is a documented/manual provider-swap path in v1 with partial lifecycle automation. It is not full live parity with Parallels in v1. The evidence supports basic lifecycle automation, but it does not support full parity because VM creation is GUI/manual, top-level `utmctl` does not advertise create/import/snapshot primitives, IP discovery is unsupported for this macOS backend, and `utmctl` can return exit code 0 while printing an operational error.

No additional owner-side UTM validation is required before initial coding-agent handoff. Unproven capabilities remain intentionally unimplemented, unsupported, or manual-step-required in v1 unless later owner-approved evidence proves a safe automation path.

## Validation Procedure

Use a disposable same-major macOS Tahoe 26.4.1 UTM VM for these checks. Do not run destructive actions against a VM you care about.

### 1. Record Host And Tool Baseline

Run these commands on the Apple-silicon macOS host:

```bash
sw_vers
uname -m
defaults read /Applications/UTM.app/Contents/Info.plist CFBundleShortVersionString
spctl --assess --verbose /Applications/UTM.app
```

Then run:

```bash
UTMCTL='/Applications/UTM.app/Contents/MacOS/utmctl'
"$UTMCTL" version
"$UTMCTL" --help
"$UTMCTL" list
```

Record:

- Host macOS version and build.
- Host architecture.
- UTM app version.
- `utmctl version` output.
- Whether `utmctl list` launches or foregrounds UTM.
- Whether macOS prompts for Terminal, shell, or automation permissions.

### 2. Create Disposable UTM VM

Using the confirmed pinned IPSW, create one disposable UTM VM named `macOSLab-UTM-Disposable`.

Record:

- Exact IPSW path.
- IPSW file size.
- IPSW SHA-256 checksum.
- Every GUI step required to create the VM.
- Whether the VM is explicitly Apple Virtualization-backed.
- CPU, memory, disk, display, network, and sharing settings.
- Any default sharing or host integration settings that need to be disabled.

### 3. Verify Lifecycle Commands

Set the VM name once:

```bash
UTMCTL='/Applications/UTM.app/Contents/MacOS/utmctl'
VM_NAME='macOSLab-UTM-Disposable'
```

Run and record the output from:

```bash
"$UTMCTL" list
"$UTMCTL" status "$VM_NAME"
"$UTMCTL" start "$VM_NAME"
"$UTMCTL" status "$VM_NAME"
"$UTMCTL" ip-address "$VM_NAME"
"$UTMCTL" suspend "$VM_NAME"
"$UTMCTL" status "$VM_NAME"
"$UTMCTL" stop "$VM_NAME"
"$UTMCTL" status "$VM_NAME"
```

If a command fails, record:

- The exact command.
- Exit code if visible.
- Full sanitized output.
- Whether UTM or macOS showed a GUI prompt.
- Whether the failure means "unsupported," "permission required," "VM state wrong," or "unknown."

### 4. Verify Guest Interaction Commands

Only run guest interaction commands after the disposable VM is running and you understand whether credentials are required.

Run or document why you cannot safely run:

```bash
"$UTMCTL" exec "$VM_NAME" sw_vers
"$UTMCTL" file "$VM_NAME"
```

Record:

- Whether `exec` requires guest tools, credentials, SSH, or another setup step.
- Whether `file` can copy files without exposing host paths or secrets.
- Whether either command is suitable for v1 automation.

### 5. Verify Clone And Delete Behavior

Only run these against disposable VMs.

First, decide on a disposable clone name:

```bash
UTMCTL='/Applications/UTM.app/Contents/MacOS/utmctl'
VM_NAME='macOSLab-UTM-Disposable'
CLONE_NAME='macOSLab-UTM-Disposable-Clone'
```

Then run:

```bash
"$UTMCTL" clone "$VM_NAME" "$CLONE_NAME"
"$UTMCTL" list
"$UTMCTL" delete "$CLONE_NAME"
"$UTMCTL" list
```

Record:

- Whether clone works for macOS Apple Virtualization VMs.
- Whether delete prompts for confirmation.
- Whether delete removes only the disposable clone.
- Whether delete removes disk files or only unregisters the VM.

### 6. Verify Creation, Import, Export, And Snapshot Gaps

Search UTM UI and `utmctl` help for create, import, export, and snapshot support.

Record:

- Whether VM creation can be automated without GUI steps.
- Whether UTM VM import/export can be automated.
- Whether checkpoint/snapshot creation can be automated.
- Whether checkpoint/snapshot restore can be automated.
- If manual steps are required, write each step in order.

### 7. Capture Provider Version Matrix

Record a Provider Version Matrix for the disposable UTM VM with:

- Host macOS version and build.
- Guest macOS version and build.
- Host/guest compatibility classification.
- UTM app version.
- `utmctl` version output.
- IPSW path, size, and SHA-256 checksum.
- Apple Virtualization confirmation.
- Networking mode.
- Sharing/isolation state.
- Manual-step gaps.
- Date tested.

## Remaining Open Items

- [x] Capture `/Applications/UTM.app/Contents/MacOS/utmctl version`; the first preflight captured the app bundle version via `defaults`, not the `utmctl` subcommand.
- [x] Create one disposable same-major macOS Tahoe 26.4.1 UTM VM using the GUI path and confirmed IPSW.
- [x] Verify and document which lifecycle primitives work through `utmctl` against the disposable VM. Basic lifecycle is verified for list, status, start from stopped, suspend, resume from paused, and stop. IP address is unsupported for the tested macOS Apple Virtualization backend. File, exec, clone, and delete are not proven safe for v1 automation and must remain unsupported or manual-step-required unless later owner-approved evidence proves otherwise.
- [x] Verify and document which VM creation, import/export, and snapshot actions require manual UI steps. Top-level `utmctl` help does not advertise create/import/export/snapshot primitives, so v1 must treat these as manual-step-required unless later owner-approved evidence proves otherwise.
- [x] Record whether macOS prompts for Terminal or shell automation permissions when `utmctl` controls UTM. No blocking permission prompt was reported in the sanitized evidence, but docs should still tell users to approve macOS prompts if displayed.
- [x] Record the Provider Version Matrix inputs for the disposable VM: host macOS version/build, same-major expected guest macOS version/build from the verified IPSW, host/guest classification, UTM version, IPSW path, IPSW checksum, manual-step gaps, and date tested. Any later in-guest `sw_vers` capture can refine the matrix during Phase 6 or Phase 9, but it is not a pre-handoff blocker.
- [x] Owner decision on 2026-05-05: UTM v1 is a documented/manual provider-swap path with partial lifecycle automation, not full live Parallels parity.

## Checklist

- [x] Owner: Repository owner; Status: v1 posture approved with partial lifecycle evidence; Phase gate affected: Phase 6 UTM provider; Why it matters: UTM automation does not mirror Parallels CLI parity, manual gaps must be explicit, and macOS guests on Apple silicon must respect Apple Virtualization host/guest compatibility constraints; Action: implement UTM as documented/manual provider-swap with partial lifecycle automation and clear manual-step-required results for unproven create/import/export/snapshot/guest-interaction behaviors; Acceptance condition: UTM capability matrix, manual-step gaps, host macOS version/build, guest macOS version/build, UTM version, and host/guest compatibility classification are documented before provider implementation; Source: ADR-0005, ADR-0011, ADR-0014, and spec Sections 8.1.1, 9.6, and 17.5.
