<!-- markdownlint-disable MD013 -->
# TODO Phase 06 UTM Provider

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Deferred verification for UTM automation and manual-step boundaries before implementing Phase 6.

## Checklist

- [ ] Owner: Repository owner; Status: Open; Phase gate affected: Phase 6 UTM provider; Why it matters: UTM automation may not mirror Parallels CLI parity, manual gaps must be explicit, and macOS guests on Apple silicon must respect Apple Virtualization host/guest compatibility constraints; Action: verify current UTM and `utmctl` automation surface, including VM creation, launch, stop, snapshot, import/export, Apple Virtualization enforcement, host/guest macOS compatibility behavior, and any manual-step requirements; Acceptance condition: UTM capability matrix, manual-step gaps, host macOS version/build, guest macOS version/build, UTM version, and host/guest compatibility classification are documented before provider implementation; Source: ADR-0005, ADR-0011, and spec Sections 8.1.1, 9.6, and 17.5.
