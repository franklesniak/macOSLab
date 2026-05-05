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

Do not commit the raw or sanitized preflight capture bundle. Convert it into durable commands, expected fields, fixtures, and redacted examples only.

## Remaining Open Items

- [ ] After the pinned IPSW download finishes, create one disposable same-major macOS Tahoe 26.4.1 Parallels VM and capture the exact `prlctl create <name> -o macos --restore-image <path>` behavior.
- [ ] Verify and document VM list/info/start/stop/delete behavior against the disposable VM.
- [ ] Verify and document named snapshot create/list/restore behavior against the disposable VM.
- [ ] Confirm whether this Parallels installation exposes edition as Pro through a parseable CLI field; current evidence proves Desktop 26.3.2-57398 and a valid license, but does not expose a clean "Pro" string.
- [ ] Record the Provider Version Matrix for the disposable VM: host macOS version/build, guest macOS version/build, host/guest classification, Parallels version, IPSW path, IPSW checksum, and date tested.
- [ ] Treat guest macOS versions higher than the host major version as rejected by default. The current macOS 26.4.1 host can verify same-major Tahoe behavior; older guest majors require explicit cross-major evidence only if they remain in scope for this host.

## Checklist

- [ ] Owner: Repository owner; Status: Partially verified; Phase gate affected: Phase 5 Parallels provider; Why it matters: provider automation must match the installed Parallels Desktop Pro command surface and must not assume unsupported host/guest macOS pairings; Action: use the confirmed CLI/version facts above, then verify same-major macOS VM creation behavior, snapshot behavior, and rejection/warning behavior on the owner/demo host once the pinned IPSW is available; Acceptance condition: exact commands, expected outputs, host macOS version/build, guest macOS version/build, Parallels version/edition evidence, and host/guest compatibility classification are documented so provider tests can be written without guessing; Source: ADR-0005, ADR-0011, and spec Sections 8.1.1, 9.6, and 17.4.
