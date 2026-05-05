<!-- markdownlint-disable MD013 -->
# FileVault

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Documents FileVault validation evidence boundaries for macOSLab.
- **Related:** [Evidence Redaction](Evidence-Redaction.md), [Evidence and CAB](Evidence-and-CAB.md), [FileVault smoke plan](../examples/TestCases/FileVault-Smoke.yml)

## Validation Model

FileVault validation proves policy receipt, local encryption state, and escrow-path evidence without exposing a recovery key. VM evidence can support the workflow, but physical Mac sign-off remains required for production confidence.

The minimum evidence path is:

- local `fdesetup status` result;
- profile receipt or policy receipt evidence;
- escrow existence or retrieval-path evidence from Intune or Graph;
- redaction verification proving no personal recovery key value is written.

## Redaction

Recovery-key-shaped values MUST be redacted even when the surrounding field name looks harmless. Evidence bundles SHOULD prove redaction with a `RedactionVerification` test result.
