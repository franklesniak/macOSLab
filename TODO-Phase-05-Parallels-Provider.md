<!-- markdownlint-disable MD013 -->
# TODO Phase 05 Parallels Provider

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Deferred verification for Parallels Desktop command-line automation before implementing Phase 5.

## Checklist

- [ ] Owner: Repository owner; Status: Open; Phase gate affected: Phase 5 Parallels provider; Why it matters: provider automation must match the installed Parallels Desktop Pro command surface and must not assume unsupported host/guest macOS pairings; Action: verify current `prlctl` syntax, version output, edition detection, same-major macOS VM creation behavior, snapshot behavior, and higher-than-host guest rejection or warning behavior on the owner/demo host; Acceptance condition: exact commands, expected outputs, host macOS version/build, guest macOS version/build, Parallels version/edition, and host/guest compatibility classification are documented so provider tests can be written without guessing; Source: ADR-0005, ADR-0011, and spec Sections 8.1.1, 9.6, and 17.4.
