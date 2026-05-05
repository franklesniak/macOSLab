<!-- markdownlint-disable MD013 -->

# Schemas

## Metadata

- **Status:** Active
- **Owner:** Repository Maintainers
- **Last Updated:** 2026-05-05
- **Scope:** Schema conventions and the macOSLab evidence-bundle schema used by validation evidence and exports.
- **Related:** [JSON authoring standards](../.github/instructions/json.instructions.md), [YAML authoring standards](../.github/instructions/yaml.instructions.md), [Phase 7 TODO](../TODO-Phase-07-Evidence-Pipeline.md)

This directory contains JSON Schemas for load-bearing JSON and YAML contracts.

The Phase 7 implementation replaced the temporary template worked example with the real macOSLab evidence-bundle contract:

- Schema: [evidence-bundle.schema.json](evidence-bundle.schema.json)
- Valid examples: [examples/evidence-bundle/valid/](examples/evidence-bundle/valid/)
- Invalid reference fixtures: [examples/evidence-bundle/invalid/](examples/evidence-bundle/invalid/)

The valid examples are checked by the `Validate evidence-bundle valid examples` pre-commit hook. The schema is checked by the `Self-validate evidence-bundle schema` pre-commit hook. The invalid fixtures are retained as reference material and are covered by Pester tests because they are expected to fail validation.

## Evidence Schema

The repository specification defines the evidence-bundle shape in Section 25 of [macOSLab Repository Specification](../docs/spec/macOSLab-repository-spec.md#25-evidence-bundle-schema). The committed schema extends that contract with Phase 7 owner decisions: normalized provider version matrix fields, host/guest compatibility classification, provider manual-step gaps, provider isolation state, and redaction-required fields.

The evidence schema validates durable redacted evidence summaries. It does not permit raw recovery keys, tokens, tenant identifiers, device IDs, MAC addresses, VM UUIDs, license strings, or local private host data.

## Authoring Rules

- Schemas SHOULD use JSON Schema Draft 2020-12 unless a concrete consumer requires another draft.
- Schema files SHOULD use the `.schema.json` suffix and lowercase kebab-case names.
- Project-owned object schemas SHOULD set `"additionalProperties": false` unless the schema intentionally mirrors an external open contract.
- Examples MUST use synthetic data and MUST NOT contain secrets, tenant identifiers, tokens, recovery keys, production policy names, device IDs, or personal data.
- New schema-backed file families SHOULD add narrowly scoped `check-jsonschema` hooks. Do not add placeholder hooks for schemas that do not exist.

## Validation

Run the configured schema hooks through pre-commit:

```bash
pre-commit run check-jsonschema --all-files
pre-commit run check-metaschema --all-files
```

The dedicated data-file workflow also runs these hooks for pull requests and pushes.
