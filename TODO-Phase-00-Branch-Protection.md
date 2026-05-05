<!-- markdownlint-disable MD013 -->
# TODO Phase 00 Branch Protection

## Metadata

- **Status:** Active
- **Owner:** Repository owner
- **Last Updated:** 2026-05-05
- **Scope:** Manual GitHub-side branch-protection setup deferred until the repository implementation is complete and the final required checks are known.

## Deferred Decision

The owner approved the balanced final-hardening option on 2026-05-05: configure `main` with a GitHub ruleset or branch protection after the repository is fully implemented and the final CI/check names are known.

Target policy:

- Require pull requests before merging to `main`.
- Require the final agreed CI/status checks.
- Prohibit force pushes and branch deletion.
- Dismiss stale approvals when new commits are pushed.
- Allow administrator bypass only for emergency repository maintenance.

## Checklist

- [ ] Owner: Repository owner; Status: Deferred until final repository hardening; Phase gate affected: final implementation closeout; Why it matters: branch protection cannot be configured from the local workspace, and the final required checks should not be locked until the coding agent has finished building the repository according to the specification; Action: configure the approved balanced ruleset for `main` after the implementation is complete and the final CI/check names are known; Acceptance condition: `main` requires pull requests, agreed CI checks, stale-review dismissal, and force-push/delete protection before direct changes are allowed after final build approval; Source: `docs/phase-0-bootstrap-codex-instructions.md` and owner decision on 2026-05-05.
