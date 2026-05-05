<!-- markdownlint-disable MD013 -->
# Evidence and CAB

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Describes the evidence-bundle shape, summary files, Provider Version Matrix, and CAB-facing usage boundary for macOSLab validation runs.
- **Related:** [macOSLab Repository Specification](spec/macOSLab-repository-spec.md), [Evidence Redaction](Evidence-Redaction.md), [Provider Version Matrix](Provider-Version-Matrix.md), [Evidence bundle schema](../schemas/evidence-bundle.schema.json)

## Evidence Bundle

Each meaningful validation run produces a redacted evidence directory with:

- `evidence.json` as the durable machine-readable contract;
- `evidence.summary.txt` as a short human-readable summary;
- `provider-version-matrix.json` when provider matrix data is present;
- `MANIFEST.json` when exported through `Export-MacLabEvidence`.

The schema lives at [schemas/evidence-bundle.schema.json](../schemas/evidence-bundle.schema.json). Valid examples live under [schemas/examples/evidence-bundle/valid/](../schemas/examples/evidence-bundle/valid/).

## Provider Version Matrix

Evidence MUST capture the host and guest macOS versions and builds, provider version, PowerShell version, Pester version, Defender version when relevant, host/guest compatibility classification, provider manual-step gaps, and provider isolation state.

Provider isolation state records whether host sharing, shared clipboard, shared applications, SmartMount-style resource sharing, camera sharing, Bluetooth sharing, and host location sharing are disabled. UTM may report manual-step gaps because v1 intentionally does not claim full Parallels parity.

## CAB Usage

The CAB-facing artifact is the redacted bundle, not the raw capture folder. The summary should answer:

- which VM and provider were tested;
- which checkpoint or manual provider-swap state was used;
- which fidelity color applies;
- which tests passed, failed, or warned;
- whether any failure was an expected engineered demo failure;
- whether physical Mac sign-off remains required.

The evidence bundle does not prove cloud rollback. It MUST keep the cloud-state warning visible: VM rollback does not rewind Intune, Entra, Defender portal state, audit logs, or reporting history.

## Export

Use `Export-MacLabEvidence` to create a portable directory or zip bundle. Export re-runs redaction over JSON and text artifacts before writing the bundle and produces `MANIFEST.json` with SHA-256 hashes for exported files.
