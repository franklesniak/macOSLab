<!-- markdownlint-disable MD013 -->
# TODO Phase 05 Parallels Provider

## Metadata

- **Status:** Active
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

Do not commit the raw or sanitized preflight capture bundle. Convert it into durable commands, expected fields, fixtures, and redacted examples only.

## Remaining Open Items

- [ ] If not already captured elsewhere, record the exact `prlctl create <name> -o macos --restore-image <path>` command and output used to create the disposable same-major macOS Tahoe 26.4.1 VM.
- [ ] Verify and document VM start/stop/delete behavior against the disposable VM. Do not run destructive delete except against a disposable VM.
- [ ] Identify and verify the exact Parallels CLI or manual steps needed to disable host integration/sharing settings after VM creation, then prove the resulting `prlctl list -i` output is clean before `Clean-OS` snapshot capture.
- [ ] Verify and document named snapshot create/list/restore behavior against the disposable VM.
- [ ] Confirm whether this Parallels installation exposes edition as Pro through a parseable CLI field; current evidence proves Desktop 26.3.2-57398 and a valid license, but does not expose a clean "Pro" string.
- [ ] Record the Provider Version Matrix for the disposable VM: host macOS version/build, guest macOS version/build, host/guest classification, Parallels version, IPSW path, IPSW checksum, and date tested.
- [ ] Treat guest macOS versions higher than the host major version as rejected by default. The current macOS 26.4.1 host can verify same-major Tahoe behavior; older guest majors require explicit cross-major evidence only if they remain in scope for this host.

## Checklist

- [ ] Owner: Repository owner; Status: Partially verified; Phase gate affected: Phase 5 Parallels provider; Why it matters: provider automation must match the installed Parallels Desktop Pro command surface and must not assume unsupported host/guest macOS pairings or clean isolation defaults; Action: use the confirmed CLI/version/VM-info facts above, then verify same-major macOS VM creation, isolation hardening, snapshot behavior, and rejection/warning behavior on the owner/demo host; Acceptance condition: exact commands, expected outputs, host macOS version/build, guest macOS version/build, Parallels version/edition evidence, host/guest compatibility classification, and clean post-create isolation settings are documented so provider tests can be written without guessing; Source: ADR-0005, ADR-0011, and spec Sections 8.1.1, 9.6, and 17.4.
