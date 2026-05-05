<!-- markdownlint-disable MD013 -->
# TODO Phase 04 Media Acquisition

## Metadata

- **Status:** Verified for implementation handoff
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Deferred verification for media discovery and download tooling before implementing Phase 4.

## Confirmed Preflight Evidence

Owner-supplied sanitized preflight evidence from a macOS host confirms:

- Host baseline: Apple Silicon (`arm64`) running macOS 26.4.1 build 25E253.
- `mist` is installed at `/opt/homebrew/bin/mist`.
- A later sanitized evidence bundle confirmed `mist --version` returns `2.2 (latest: 2.2)`.
- `mist --help`, `mist help list`, and `mist help download` work.
- `mist version` is not valid for the installed command surface; use `mist --version` for version capture.
- `mist list firmware --export <path>` produced JSON with 134 firmware rows.
- For macOS Tahoe 26.4.1 build 25E253, `mist` reported compatible firmware rows, including a signed row.
- `mist list installer --compatible --export <path>` produced 11 compatible installer rows on this host: Tahoe 26.1 through 26.4.1 and Sequoia 15.7.2 through 15.7.5. It did not return Sonoma installer rows on this macOS 26.4.1 host.
- `mist help download firmware` confirms `mist download firmware [<options>] <search-string>` and supports `--output-directory`, `--temporary-directory`, `--firmware-name`, `--export`, `--metadata-cache`, `--compatible`, `--force`, `--no-ansi`, `--retries`, and `--retry-delay`.
- The 2026-05-05 sanitized evidence bundle did not include a downloaded IPSW path because `IPSW_PATH` was left at the placeholder value.
- Later sanitized evidence from 2026-05-05 confirmed `mist download firmware "26.4.1" --compatible --output-directory "$HOME/Demo/Installers" --firmware-name "UniversalMac_26.4.1_25E253_Restore.ipsw" --export <path> --no-ansi` completed successfully.
- The downloaded firmware path was `~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw`, so the artifact landed under the requested cache path rather than the default `/Users/Shared/Mist` path.
- The downloaded firmware size was about 18 GB; the Mist export metadata reported `19734779897` bytes.
- The downloaded firmware SHA-256 was `8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32`.
- Owner decision on 2026-05-05: demo and rehearsal paths must reuse the already-downloaded IPSW at `~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw`; do not start another `mist download` unless the owner explicitly approves a new download in the current task.
- Owner clarification on 2026-05-05: this no-new-download rule applies to the post-construction MMS conference demo scripts in the future repository, not only to temporary validation commands. `scripts/Invoke-MMSDemo.ps1`, `examples/MMSMOA-2026/Demo1-Media.ps1`, and any demo runbook path MUST verify and reuse the prepared artifact when it exists at the expected path.
- The expected owner/demo path is `~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw`. No move is required while the file remains there. If a future script changes the expected path, the script or runbook must provide exact copy or move commands for placing the already-downloaded file at the new expected path, then re-run SHA-256 verification before continuing. It must still not start a new download automatically.

Do not commit the raw or sanitized preflight capture bundle. Convert it into durable commands, expected fields, fixtures, and redacted examples only.

## Remaining Open Items

- [x] Re-run and capture `mist --version`; the first preflight captured `mist version`, which usefully proved the wrong syntax but did not capture the installed version string.
- [x] Capture `mist help download firmware` and verify the exact options for output directory control in the installed `mist-cli` version.
- [x] Let the in-progress macOS Tahoe 26.4.1 firmware download finish, then record the actual IPSW path, file size, and SHA-256 checksum.
- [x] Record whether the download lands under the requested cache path or the default `/Users/Shared/Mist` path.
- [x] Owner decision on 2026-05-05: Phase 4 treats compatible installer rows as advisory metadata. Firmware/IPSW restore images are the default Apple-silicon VM media path.
- [x] Owner decision on 2026-05-05: post-construction MMS demo scripts and runbooks must verify and reuse the existing IPSW instead of starting a new download.

## Checklist

- [x] Owner: Repository owner; Status: Verified for same-major macOS Tahoe 26.4.1 firmware download; Phase gate affected: Phase 4 media acquisition and Phase 9 demo rehearsal; Why it matters: `mist-cli` syntax and output can change across releases, and demos must not accidentally trigger another 18 GB download; Action: use the confirmed preflight facts above as the implementation contract for discovering and downloading pinned macOS restore images or provider-appropriate install artifacts, but make the owner/demo path verify and reuse the existing IPSW at `~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw`; Acceptance condition: the verified commands, version output, expected metadata fields, actual downloaded artifact path, checksum, and no-new-download demo rule are documented before `Get-MacLabMedia` and demo script implementation; Source: ADR-0005, ADR-0015, and spec Section 9.6.
