<!-- markdownlint-disable MD013 -->
# TODO Phase 05 Parallels Provider

## Metadata

- **Status:** Verified for implementation handoff
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Deferred verification for Parallels Desktop command-line automation before implementing Phase 5.

## Confirmed Preflight Evidence

Owner-supplied sanitized preflight evidence from a macOS host confirms:

- Host baseline: Apple Silicon (`arm64`) running macOS 26.4.1 build 25E253.
- `prlctl` is installed at `/usr/local/bin/prlctl`.
- `prlsrvctl` is installed at `/usr/local/bin/prlsrvctl`.
- `prlctl --version` returns Parallels CLI version 26.3.2 build 57398.
- `prlsrvctl info` reports Parallels Desktop 26.3.2-57398, service started, default VM home under `~/Parallels`, and a valid license. Do not commit license strings from this output.
- `prlctl list -a` returned only the table header, confirming no registered Parallels VMs existed at capture time.
- `prlctl list --help` supports `--all`, `--full`, `--output`, `--list`, `--template`, `--json`, `--no-header`, `--stopped`, and `--name`.
- `prlctl snapshot-list --help` supports `--tree`, `--id`, `--json`, and `--no-header`.
- Later owner-supplied disposable VM evidence confirmed `prlctl list -a` can see a running `macOSLab-Disposable` VM.
- `prlctl list -i macOSLab-Disposable` reported `Type: APPLE_VZ_VM`, `OS: macosx`, Apple hypervisor usage, `BIOS type: efi-arm64`, Shared networking, 4 vCPU, 8192 MB RAM, and a 128 GB virtual disk.
- The disposable VM evidence also showed Parallels defaults are not clean enough for the lab isolation policy: multiple integration/sharing settings were still enabled, including camera/gamepad auto-sharing, Shared Applications, SmartMount-style host resource sharing, shared clipboard/cloud, and host location sharing.
- `prlctl snapshot-list --json` for the disposable VM produced an empty file before any snapshots existed. Treat empty snapshot output as an explicit parser case and re-test after a real named snapshot exists.
- Later sanitized evidence confirmed `prlctl snapshot macOSLab-Disposable --name MacLab-Validation-<run-id>` successfully creates a named snapshot.
- Later sanitized evidence confirmed `prlctl snapshot-list macOSLab-Disposable --json` returns a JSON object keyed by snapshot ID, with snapshot `name`, `date`, `state`, `current`, and `parent` fields.
- The captured validation snapshot was taken while the VM was running and reported `state: poweron`, so this proves Parallels snapshot creation/listing syntax but does not replace the clean-shutdown checkpoint validation required for the five-checkpoint model.
- `prlctl snapshot --help` confirms `--name` and `--description` options.
- `prlctl snapshot-switch --help` confirms restore syntax and a `--skip-resume` option for reverting to a snapshot without automatically starting a VM that was running when the snapshot was taken.
- `prlctl set --help` confirms hardening-related categories exist for `shared_folders`, `shared_profiles`, `shared_apps`, `smart_mounts`, `misc_sharing`, `coherence`, `usb`, `bluetooth`, `security`, and related settings. Category-specific help and post-hardening proof still need to be captured before implementing exact hardening commands.
- Round-three evidence showed `prlctl set macOSLab-Disposable <category> --help` returns `Unrecognized option: <category>` with exit code 255 for the tested categories. Because `prlctl set --help` shows category-help examples without a VM name, re-run category-specific help as `prlctl set <category> --help` before choosing exact hardening commands.
- Round-four evidence confirmed the corrected category-help form `prlctl set <category> --help` works for `shared_folders`, `shared_profiles`, `shared_apps`, `smart_mounts`, `misc_sharing`, `coherence`, `usb`, and `bluetooth`.
- Captured hardening switch candidates include `--shf-host`, `--shf-host-defined`, `--shf-host-automount`, `--shf-guest`, `--shf-guest-automount`, `--shared-profile`, `--sh-app-host-to-guest`, `--sh-app-guest-to-host`, `--smart-mount`, `--shared-clipboard`, `--shared-cloud`, `--auto-share-camera`, `--auto-share-smart-card`, `--auto-share-bluetooth`, and `--auto-share-gamepad`.
- Round-five evidence verified the already-downloaded IPSW at `~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw` with SHA-256 `8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32`. No new media download is needed for Parallels provider testing.
- Round-five evidence showed `prlctl stop macOSLab-Disposable` returned exit code 255 with "Operation canceled," but a later `prlctl list -i` showed `State: stopped`. The provider should verify final VM state after stop/start operations instead of trusting exit code alone.
- Round-five evidence confirmed most candidate hardening commands completed successfully against the disposable VM. The exception was `--auto-share-bluetooth off`, which returned "Unrecognized option" with exit code 255, while post-hardening VM info still reported `Automatic sharing bluetooth: off`.
- Post-hardening `prlctl list -i` proof showed cameras, Bluetooth, smart cards, gamepads, host shared folders, host-defined sharing, shared profile, SmartMount, shared clipboard, and shared cloud disabled. Shared Applications still appears as a header, but its host-to-guest, guest-to-host, Dock folder, notification, and Dock-bounce subsettings were all `off`.
- Round-five `prlctl set advanced --help` exposed the exact host-location switch: `--share-host-location <on|off>`. Post-hardening proof still showed `Share host location: on`, so this command must be applied and verified before the disposable VM is accepted as a clean isolated baseline.
- Round-five `prlctl set security --help` exposed `--isolate-vm <on|off>`. This command should be tested on the disposable VM and the resulting `prlctl list -i` output captured before Phase 5 implementation chooses the final isolation sequence.
- Round-six evidence confirmed `prlctl set macOSLab-Disposable --share-host-location off` succeeds with exit code 0, and post-command `prlctl list -i` reports `Share host location: off`.
- Round-six evidence confirmed `prlctl set macOSLab-Disposable --isolate-vm on` succeeds with exit code 0. However, the post-command `prlctl list -i` output does not expose a simple "isolation enabled" field, and it showed `Automatic sharing gamepads: on` even though that setting had been `off` immediately before this command sequence.
- The final Parallels hardening order must therefore be verified as an ordered sequence. Prefer running `--isolate-vm on` before the individual sharing-disable switches, then verify every required isolation field at the end. The implementation MUST NOT assume one successful `--isolate-vm on` command is enough to prove the VM is clean.
- Round-seven evidence confirmed that applying `prlctl set macOSLab-Disposable --auto-share-gamepad off` after `--isolate-vm on` succeeds with exit code 0 and restores the desired final state.
- Round-seven final hardening checks all passed for `State: stopped`, camera sharing off, Bluetooth sharing off, smart-card sharing off, gamepad sharing off, host shared folders off, host-defined sharing off, shared profile off, host-to-guest app sharing off, guest-to-host app sharing off, SmartMount off, shared clipboard off, shared cloud off, and host location off.
- Round-eight evidence confirmed `prlctl snapshot macOSLab-Disposable --name <name> --description <description>` succeeds with exit code 0 when the VM is stopped.
- Round-eight evidence confirmed `prlctl snapshot-list macOSLab-Disposable --json` lists the stopped snapshots with `state: poweroff`, `current`, and `parent` metadata.
- Round-eight evidence showed `prlctl snapshot-switch macOSLab-Disposable --id <snapshot-name> --skip-resume` fails with exit code 255 and "configuration file ... invalid." Therefore, `--id` requires the provider snapshot ID/GUID, not the friendly snapshot name. The provider must resolve checkpoint names to snapshot IDs from `snapshot-list --json` before restore.
- Round-eight final VM info still showed the VM stopped and the previously verified isolation settings intact after the failed name-based restore attempts.
- Round-nine evidence confirmed the correct restore workflow: parse the provider snapshot ID/GUID from `prlctl snapshot-list <vm> --json`, then call `prlctl snapshot-switch <vm> --id <snapshot-id> --skip-resume`.
- Round-nine evidence switched successfully to two stopped snapshots by provider ID with exit code 0. The post-switch JSON checks reported the expected current snapshot names for both restore targets, and final VM info showed the VM remained stopped with the previously verified isolation settings intact.
- Round-ten evidence confirmed the exact create syntax for the same-major macOS Tahoe path: `prlctl create <name> -o macos --restore-image <existing-ipsw-path>`.
- Round-ten evidence confirmed `prlctl create macOSLab-CreateProbe-<run-id> -o macos --restore-image /Users/franklesniak/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw` exits 0 and creates a stopped `APPLE_VZ_VM`.
- Round-ten evidence confirmed `prlctl create --help` documents `--restore-image` as "Designate a specific ipsw restore image (only on Apple Silicon Macs)."
- Round-ten evidence confirmed freshly created VMs still have multiple integration defaults enabled, including camera sharing, gamepad sharing, app sharing subsettings, SmartMount, shared clipboard, shared cloud, and host location sharing. Therefore, the verified hardening sequence remains required immediately after VM creation and before any `Clean-OS` checkpoint.
- Round-ten evidence captured Provider Version Matrix inputs: host macOS 26.4.1 build 25E253, same-major expected guest macOS 26.4.1 build 25E253 from the verified IPSW, host/guest classification `same-major-supported`, Parallels CLI 26.3.2 build 57398, Parallels Desktop 26.3.2-57398, and IPSW SHA-256 `8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32`.
- Round-ten `prlctl --version` and `prlsrvctl info` did not expose a clean parseable `Pro`, `Business`, or `Standard` edition string. They prove Desktop version and license presence after redaction, but not edition. Implementation should record this as unknown edition unless a later command surface exposes a specific edition; warn only when Standard edition is explicitly detected.
- Round-eleven evidence exposed a test-script bug: `prlctl list -a --name` still emitted tabular output with UUID, status, IP address, and name columns, so `grep -Fx <vm-name>` against that output falsely reported that the VM was absent.
- Round-eleven and round-eleven-b evidence did not execute the delete command. Both captures still showed `macOSLab-CreateProbe-20260505T161252Z` listed as a stopped VM. Provider existence checks MUST use a reliable names-only or structured listing, such as `prlctl list -a --output name --no-header`, before deciding a VM is absent.
- Round-eleven-b evidence confirmed `prlctl delete --help` documents the syntax as `prlctl delete <ID | NAME>` and describes it as completely removing the specified VM.
- Round-twelve evidence confirmed safe delete behavior against the stopped create-probe VM only. `prlctl list -a --output name --no-header` listed `macOSLab-CreateProbe-20260505T161252Z` before deletion, `printf 'y\n' | prlctl delete macOSLab-CreateProbe-20260505T161252Z` succeeded with exit code 0, and the names-only list after deletion contained only `macOSLab-Disposable`.
- Round-twelve evidence confirmed the delete command prompts interactively and accepts `y` on stdin. The provider implementation should use `ShouldProcess` and explicit confirmation rather than hiding this prompt from callers.

Do not commit the raw or sanitized preflight capture bundle. Convert it into durable commands, expected fields, fixtures, and redacted examples only.

## Remaining Open Items

- [x] If not already captured elsewhere, record the exact `prlctl create <name> -o macos --restore-image <path>` command and output used to create the disposable same-major macOS Tahoe 26.4.1 VM.
- [x] Verify and document VM start/stop/delete behavior against the disposable VM. Stop behavior is partially verified, but the provider must account for the observed nonzero stop exit followed by eventual stopped state. Delete behavior is verified against the stopped create-probe VM using `prlctl delete <name>` with explicit `y` confirmation. Do not run destructive delete except against a disposable VM.
- [x] Identify and verify the exact Parallels CLI or manual steps needed to disable host integration/sharing settings after VM creation, then prove the resulting `prlctl list -i` output is clean before `Clean-OS` snapshot capture. The verified ordered sequence must run `--isolate-vm on`, then re-apply per-feature sharing-disable switches as needed, and treat final parsed settings as the source of truth.
- [x] Verify and document named snapshot create/list behavior against the disposable VM.
- [x] Verify and document named snapshot restore behavior against the disposable VM. The provider must parse the provider snapshot ID/GUID from `snapshot-list --json` and pass that ID to `snapshot-switch --id`; do not pass the friendly snapshot name as the ID.
- [x] Capture category-specific `prlctl set <category> --help` output for the hardening categories before choosing exact hardening commands.
- [x] Apply the final ordered Parallels hardening sequence to a disposable VM and capture post-hardening `prlctl list -i` proof. Specifically verify `--isolate-vm on`, `--share-host-location off`, and `--auto-share-gamepad off` in the final state. Do not apply to a VM that is not disposable.
- [x] Confirm whether this Parallels installation exposes edition as Pro through a parseable CLI field; current evidence proves Desktop 26.3.2-57398 and a valid license, but does not expose a clean "Pro" string through `prlctl --version` or `prlsrvctl info`.
- [x] Record the Provider Version Matrix for the disposable VM: host macOS version/build, guest macOS version/build, host/guest classification, Parallels version, IPSW path, IPSW checksum, and date tested.
- [x] Treat guest macOS versions higher than the host major version as rejected by default. This is an ADR-0011 implementation policy and unit-test requirement; no additional live owner test is required before handoff. The current macOS 26.4.1 host verified same-major Tahoe behavior. Older guest majors require explicit cross-major evidence only if they remain in scope for this host.

## Checklist

- [x] Owner: Repository owner; Status: Live provider command surface verified for same-major Parallels path; Phase gate affected: Phase 5 Parallels provider; Why it matters: provider automation must match the installed Parallels Desktop Pro command surface and must not assume unsupported host/guest macOS pairings or clean isolation defaults; Action: use the confirmed CLI/version/VM-info/snapshot/isolation/create/provider-matrix/delete facts above and keep higher-than-host guest rejection as an implementation unit-test/default-policy item; Acceptance condition: exact commands, expected outputs, host macOS version/build, guest macOS version/build, Parallels version/edition evidence, host/guest compatibility classification, clean post-create isolation settings, and safe cleanup behavior are documented so provider tests can be written without guessing; Source: ADR-0005, ADR-0011, and spec Sections 8.1.1, 9.6, and 17.4.
