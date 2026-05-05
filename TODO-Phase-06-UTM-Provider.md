<!-- markdownlint-disable MD013 -->
# TODO Phase 06 UTM Provider

## Metadata

- **Status:** Active
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
- Top-level `utmctl` help lists `version`, `list`, `status`, `start`, `suspend`, `stop`, `attach`, `file`, `exec`, `ip-address`, `clone`, `delete`, and `usb`.
- Top-level `utmctl` help does not advertise create/import/snapshot primitives. Treat VM creation and snapshot management as manual-step candidates until proven otherwise.
- `utmctl list` returned only the table header, confirming no registered UTM VMs existed at capture time. It may launch or foreground UTM because it controls the installed app.

Do not commit the raw or sanitized preflight capture bundle. Convert it into durable commands, expected fields, fixtures, and redacted examples only.

## Remaining Open Items

- [ ] Capture `/Applications/UTM.app/Contents/MacOS/utmctl version`; the first preflight captured the app bundle version via `defaults`, not the `utmctl` subcommand.
- [ ] After the pinned IPSW download finishes, create one disposable same-major macOS Tahoe 26.4.1 UTM VM using the GUI path and exact IPSW.
- [ ] Verify and document which lifecycle primitives work through `utmctl` against the disposable VM: list, status, start, suspend, stop, IP address, file, exec, clone, and delete. Do not run destructive delete except against a disposable VM.
- [ ] Verify and document which VM creation, import/export, and snapshot actions require manual UI steps.
- [ ] Record whether macOS prompts for Terminal or shell automation permissions when `utmctl` controls UTM.
- [ ] Record the Provider Version Matrix for the disposable VM: host macOS version/build, guest macOS version/build, host/guest classification, UTM version, IPSW path, IPSW checksum, manual-step gaps, and date tested.

## Checklist

- [ ] Owner: Repository owner; Status: Partially verified; Phase gate affected: Phase 6 UTM provider; Why it matters: UTM automation may not mirror Parallels CLI parity, manual gaps must be explicit, and macOS guests on Apple silicon must respect Apple Virtualization host/guest compatibility constraints; Action: use the confirmed app/version/command-surface facts above, then verify current UTM and `utmctl` automation against a disposable same-major VM, including VM creation, launch, stop, snapshot, import/export, Apple Virtualization enforcement, host/guest macOS compatibility behavior, and any manual-step requirements; Acceptance condition: UTM capability matrix, manual-step gaps, host macOS version/build, guest macOS version/build, UTM version, and host/guest compatibility classification are documented before provider implementation; Source: ADR-0005, ADR-0011, and spec Sections 8.1.1, 9.6, and 17.5.
