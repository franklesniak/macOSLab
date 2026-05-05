<!-- markdownlint-disable MD013 -->
# TODO Phase 04 Media Acquisition

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Deferred verification for media discovery and download tooling before implementing Phase 4.

## Confirmed Preflight Evidence

Owner-supplied sanitized preflight evidence from a macOS host confirms:

- Host baseline: Apple Silicon (`arm64`) running macOS 26.4.1 build 25E253.
- `mist` is installed at `/opt/homebrew/bin/mist`.
- `mist --help`, `mist help list`, and `mist help download` work.
- `mist version` is not valid for the installed command surface; use `mist --version` for version capture.
- `mist list firmware --export <path>` produced JSON with 134 firmware rows.
- For macOS Tahoe 26.4.1 build 25E253, `mist` reported compatible firmware rows, including a signed row.
- `mist list installer --compatible --export <path>` produced 11 compatible installer rows on this host: Tahoe 26.1 through 26.4.1 and Sequoia 15.7.2 through 15.7.5. It did not return Sonoma installer rows on this macOS 26.4.1 host.

Do not commit the raw or sanitized preflight capture bundle. Convert it into durable commands, expected fields, fixtures, and redacted examples only.

## Remaining Open Items

- [ ] Re-run and capture `mist --version`; the first preflight captured `mist version`, which usefully proved the wrong syntax but did not capture the installed version string.
- [ ] Capture `mist help download firmware` and verify the exact options for output directory control in the installed `mist-cli` version.
- [ ] Let the in-progress macOS Tahoe 26.4.1 firmware download finish, then record the actual IPSW path, file size, and SHA-256 checksum.
- [ ] Record whether the download lands under the requested cache path or the default `/Users/Shared/Mist` path.
- [ ] Decide whether Phase 4 should treat compatible installer rows as advisory metadata only, because the current Apple-silicon VM path should prefer firmware/IPSW restore images.

## Checklist

- [ ] Owner: Repository owner; Status: Partially verified; Phase gate affected: Phase 4 media acquisition; Why it matters: `mist-cli` syntax and output can change across releases; Action: use the confirmed preflight facts above, complete the remaining download/version captures, and record exact commands for discovering and downloading pinned macOS restore images or provider-appropriate install artifacts; Acceptance condition: the verified commands, version output, expected metadata fields, actual downloaded artifact path, and checksum are documented before `Get-MacLabMedia` implementation; Source: ADR-0005 and spec Section 9.6.
