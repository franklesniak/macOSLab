<!-- markdownlint-disable MD013 -->
# Evidence Redaction

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Documents `Protect-MacLabEvidence` behavior, sensitive field names, value-shape redaction, and verification expectations for macOSLab evidence.
- **Related:** [macOSLab Repository Specification](spec/macOSLab-repository-spec.md), [Evidence and CAB](Evidence-and-CAB.md), [Evidence bundle schema](../schemas/evidence-bundle.schema.json), [Phase 7 TODO](../TODO-Phase-07-Evidence-Pipeline.md)

## Contract

All evidence written by the module MUST pass through `Protect-MacLabEvidence`. The helper clones the input object, redacts sensitive fields and sensitive value shapes, and stamps the root evidence object with:

- `redactionApplied: true`
- `redactionVersion: "1.0.0"`

The repository MUST NOT introduce a `Redact-MacLabEvidence` helper because `Redact` is not an approved PowerShell verb.

## Redaction Inputs

Redaction is triggered by field names and value shapes.

Field-name redaction covers recovery keys, tokens, client secrets, passwords, license strings, tenant identifiers, device identifiers, Defender organization and machine identifiers, EDR device tags, serial numbers, UUIDs, MAC addresses, local usernames, email addresses, UPNs, and cloud configuration or policy-set IDs.

Value-shape redaction covers:

- FileVault-style recovery-key groups;
- BitLocker-style numeric recovery-key groups;
- JWT-shaped strings beginning with `eyJ`;
- UUIDs;
- MAC addresses;
- email addresses;
- `/Users/<name>` local path segments.

Callers MAY pass additional field names to `Protect-MacLabEvidence -AdditionalSensitiveFieldName` when a test plan introduces a new local identifier.

## Failure Boundary

Evidence export re-runs redaction before writing a bundle. `Write-EvidenceRecord` also re-runs redaction before writing `evidence.json`, `evidence.summary.txt`, and `provider-version-matrix.json`.

If evidence cannot be stamped with `redactionApplied: true`, the write path MUST fail closed. If a reviewer needs raw command output for troubleshooting, that output belongs in an uncommitted private capture, not in the durable evidence bundle.

## Verification

Pester tests cover:

- recovery-key-shaped values;
- JWT-shaped values;
- nested objects and arrays;
- idempotent repeated redaction;
- structured JSON remaining parseable after redaction;
- evidence export preserving redaction.
