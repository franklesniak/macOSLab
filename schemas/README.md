<!-- markdownlint-disable MD013 -->

# Schemas

## Metadata

- **Status:** Active
- **Owner:** Repository Maintainers
- **Last Updated:** 2026-05-05
- **Scope:** Schema conventions and the temporary worked-example schema retained during Phase 0 bootstrap. The real macOSLab evidence-bundle schema is deferred to Phase 7.
- **Related:** [JSON authoring standards](../.github/instructions/json.instructions.md), [YAML authoring standards](../.github/instructions/yaml.instructions.md), [Phase 7 TODO](../TODO-Phase-07-Evidence-Pipeline.md)

This directory contains JSON Schemas for load-bearing JSON and YAML contracts.

During Phase 0, macOSLab keeps the template worked example so the schema-validation toolchain remains exercised:

- Schema: [example-config.schema.json](example-config.schema.json)
- Valid examples: [examples/example-config/valid/](examples/example-config/valid/)
- Invalid reference fixtures: [examples/example-config/invalid/](examples/example-config/invalid/)

The valid examples are checked by the `Validate example-config valid examples` pre-commit hook. The schema is checked by the `Self-validate example-config schema` pre-commit hook. The invalid fixtures are retained only as reference material during Phase 0; they are not wired into a normal pre-commit hook because they are expected to fail validation.

## Future Evidence Schema

The repository specification defines the real evidence-bundle schema in Section 25 of [macOSLab Repository Specification](../docs/planning/macOS-imaging-08c-repo-spec-final.md#25-evidence-bundle-schema). Phase 7 must replace this worked example with that real schema and update `.pre-commit-config.yaml`, data-file CI, examples, and documentation in the same change.

That work is tracked in [TODO-Phase-07-Evidence-Pipeline.md](../TODO-Phase-07-Evidence-Pipeline.md).

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
