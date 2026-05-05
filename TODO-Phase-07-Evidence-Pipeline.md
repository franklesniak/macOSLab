<!-- markdownlint-disable MD013 -->
# TODO Phase 07 Evidence Pipeline

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Deferred replacement of the temporary worked-example schema with the real macOSLab evidence-bundle schema.

## Confirmed Preflight Evidence

Owner-supplied sanitized host preflight evidence confirms the future evidence model needs to represent at least:

- Host OS version/build and architecture.
- Tool paths and version output for `mist`, `prlctl`, `prlsrvctl`, and UTM/`utmctl`.
- Provider command-surface captures, such as help output and list output.
- Media discovery JSON from `mist`.
- Provider inventory states where no VMs are registered yet.
- Sanitization status for hostnames, user paths, UUIDs, MAC addresses, email addresses, license material, and other local identifiers.
- A distinction between raw local captures, sanitized review bundles, and durable evidence summaries that are safe to commit.

Do not commit the raw or sanitized preflight capture bundle. The committed evidence schema should store redacted summaries and deterministic fixture data, not private host captures.

## Remaining Open Items

- [ ] Decide whether the real evidence schema stores raw command-output attachments, normalized parsed facts, or both.
- [ ] Add fields for host/guest macOS compatibility classification and provider manual-step gaps.
- [ ] Add redaction assertions that reject license strings, hardware identifiers, local usernames, VM UUIDs, MAC addresses, tenant identifiers, and device identifiers.
- [ ] Add fixtures for "tool installed but no VMs registered" states for Parallels and UTM.
- [ ] Add fixtures for "Defender intentionally absent on host; validate inside guest" states if Phase 8 uses host/guest evidence separation.

## Checklist

- [ ] Owner: Repository owner; Status: Open with preflight inputs captured; Phase gate affected: Phase 7 evidence pipeline; Why it matters: Phase 0 keeps the worked-example schema only to exercise validation tooling; Action: replace `schemas/example-config.schema.json` and its example fixtures with the real evidence-bundle schema from spec Section 25, then update `.pre-commit-config.yaml`, data-file CI, schema docs, and examples together; Acceptance condition: valid evidence examples pass schema validation, invalid examples are rejected by an explicit test or validation script, redaction failures are caught, and the worked example is fully removed; Source: `docs/phase-0-bootstrap-codex-instructions.md` and spec Section 25.
