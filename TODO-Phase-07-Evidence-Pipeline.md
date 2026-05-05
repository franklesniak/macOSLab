<!-- markdownlint-disable MD013 -->
# TODO Phase 07 Evidence Pipeline

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Deferred replacement of the temporary worked-example schema with the real macOSLab evidence-bundle schema.

## Checklist

- [ ] Owner: Repository owner; Status: Open; Phase gate affected: Phase 7 evidence pipeline; Why it matters: Phase 0 keeps the worked-example schema only to exercise validation tooling; Action: replace `schemas/example-config.schema.json` and its example fixtures with the real evidence-bundle schema from spec Section 25, then update `.pre-commit-config.yaml`, data-file CI, schema docs, and examples together; Acceptance condition: valid evidence examples pass schema validation, invalid examples are rejected by an explicit test or validation script, and the worked example is fully removed; Source: `docs/phase-0-bootstrap-codex-instructions.md` and spec Section 25.
