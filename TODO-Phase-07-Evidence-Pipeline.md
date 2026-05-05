<!-- markdownlint-disable MD013 -->
# TODO Phase 07 Evidence Pipeline

## Metadata

- **Status:** Completed for local implementation
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
- Provider inventory states where a disposable VM is registered and running.
- Provider configuration facts that are important evidence, including Apple Virtualization type, shared networking, vCPU/RAM/disk sizing, snapshot-list output, guest-tools state, and host integration/sharing settings.
- Defender health output in key/value text form. An owner-supplied file named `mdatp-health.raw.json` contained the same key/value text as the `.txt` capture and was not parseable JSON.
- Sanitization status for hostnames, user paths, UUIDs, MAC addresses, email addresses, license material, and other local identifiers.
- A distinction between raw local captures, sanitized review bundles, and durable evidence summaries that are safe to commit.
- The ad hoc 2026-05-05 sanitization pass can break machine-readable JSON by replacing sensitive JSON property lines with non-JSON text. The production evidence pipeline must preserve JSON validity when redacting structured artifacts.

Do not commit the raw or sanitized preflight capture bundle. The committed evidence schema should store redacted summaries and deterministic fixture data, not private host captures.

## Remaining Open Items

- [x] Owner decision on 2026-05-05: the evidence schema stores normalized parsed facts as the durable contract and MAY include redacted or synthetic command-output attachments where useful. Raw private captures MUST NOT be committed.
- [x] Add fields for host/guest macOS compatibility classification and provider manual-step gaps.
- [x] Add fields for provider isolation state, including whether host sharing, shared clipboard, shared applications, SmartMount/resource sharing, camera sharing, Bluetooth sharing, and host location sharing are disabled.
- [x] Add redaction assertions that reject license strings, hardware identifiers, local usernames, VM UUIDs, MAC addresses, tenant identifiers, device identifiers, Defender organization IDs, Defender machine IDs, Defender machine GUIDs, EDR device tags, and cloud configuration IDs.
- [x] Add fixtures for "tool installed but no VMs registered" states for Parallels and UTM.
- [x] Add fixtures for "Defender intentionally absent on host; validate inside guest" states if Phase 8 uses host/guest evidence separation.
- [x] Add fixtures for Defender unhealthy-but-installed states where `healthy` is `false` because event providers, network event provider, or Full Disk Access are missing.
- [x] Add a regression test proving structured JSON remains parseable after redaction.

## Checklist

- [x] Owner: Repository owner; Status: Completed for local implementation; Phase gate affected: Phase 7 evidence pipeline; Why it matters: Phase 0 keeps the worked-example schema only to exercise validation tooling; Action: replace `schemas/example-config.schema.json` and its example fixtures with the real evidence-bundle schema from spec Section 25, then update `.pre-commit-config.yaml`, data-file CI, schema docs, and examples together; Acceptance condition: valid evidence examples pass schema validation, invalid examples are rejected by an explicit test or validation script, redaction failures are caught, and the worked example is fully removed; Source: `docs/phase-0-bootstrap-codex-instructions.md` and spec Section 25.
