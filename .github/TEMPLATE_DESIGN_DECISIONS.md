<!-- markdownlint-disable MD013 -->
# macOSLab Design Decisions

## Metadata

- **Status:** Phase 0 bootstrap
- **Owner:** Repository Maintainers
- **Last Updated:** 2026-05-05
- **Scope:** Repository-local design decisions for the `franklesniak/macOSLab` bootstrap state. The planning ADRs remain the source of truth for product architecture decisions.
- **Related:** [macOSLab ADRs](../docs/planning/macOS-imaging-08e-ADRs.md), [macOSLab Repository Specification](../docs/spec/macOSLab-repository-spec.md), [Phase 0 bootstrap instructions](../docs/phase-0-bootstrap-codex-instructions.md)

This file replaces the inherited template design-decision record with macOSLab-specific bootstrap decisions. Protected instruction files still contain inherited links and language until the repository owner explicitly authorizes changes to those protected files.

## Phase 0 Bootstrap Decisions

### PowerShell and Markdown Project Shape

macOSLab is a PowerShell 7.4+ and Markdown repository. Python project source, Python package metadata, sample pytest tests, and HCL sample artifacts were removed during Phase 0. Python remains available only as development tooling where pre-commit hooks require it.

### Pre-commit Remains the Aggregate Hygiene Gate

The repository keeps pre-commit for trailing-whitespace, end-of-file, JSON syntax, YAML syntax/style, GitHub Actions linting, schema validation, large-file checks, and Markdown linting. Black, Ruff, and HCL hooks were removed because they do not match the repository language set.

### Worked Example Schema Temporarily Retained

The worked-example schema remains in `schemas/` during Phase 0 so `check-jsonschema` and `check-metaschema` are still exercised. Phase 7 must replace it with the real evidence-bundle schema from the repository specification.

### Private Vulnerability Reporting

Security reporting points to GitHub private vulnerability reporting at `https://github.com/franklesniak/macOSLab/security/advisories/new`. Phase 0 does not add the optional project-specific `SECURITY.md` paragraph from ADR-0009; that remains deferred for owner review.

### Protected Instruction Files

Protected instruction files were not edited during Phase 0. Any request to remove, de-link, or rewrite inherited protected guidance must be approved explicitly by the repository owner.
