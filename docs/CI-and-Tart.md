<!-- markdownlint-disable MD013 -->
# CI and Tart

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Documents the v1 Tart provider posture, license due-diligence boundary, and why Tart is not part of the default MMSMOA demo path.
- **Related:** [macOSLab Repository Specification](spec/macOSLab-repository-spec.md), [macOSLab Architecture Decision Records](planning/macOS-imaging-08e-ADRs.md), [Provider Version Matrix](Provider-Version-Matrix.md)

## V1 Posture

Tart is visible in the provider contract so the repository can discuss macOS CI and runner options without making Tart a dependency for the talk path. V1 implements Tart installation and version detection only. VM creation, lifecycle, checkpoint, restore, and removal primitives MUST fail clearly with "documented but not implemented in v1" guidance unless a later owner-approved phase expands the provider.

The default MMSMOA demo path uses Parallels for live automation. UTM is a documented/manual provider-swap path. Tart is an optional future extension point.

## License Boundary

The [Tart licensing page](https://tart.run/licensing/) says Tart Virtualization and Orchard Orchestration are licensed under Fair Source License. It describes the free tier as 100 CPU cores for Tart and 4 Orchard Workers for Orchard. The same page links to the free-tier license text in the [Tart repository](https://github.com/cirruslabs/tart/blob/main/LICENSE) and [Orchard repository](https://github.com/cirruslabs/orchard/blob/main/LICENSE).

This repository does not provide legal advice. Users MUST verify Tart, Orchard, Apple, and organizational license suitability before using Tart or Orchard in their own environment.

## Provider Behavior

The v1 Tart provider:

- detects whether the `tart` command is installed;
- captures `tart --version` when available;
- reports `Implementation = StubbedInV1` in provider version metadata;
- throws a clear v1 stub error for lifecycle and VM mutation commands.

The provider MUST NOT silently expand into Tart VM creation or lifecycle automation without explicit owner approval.
