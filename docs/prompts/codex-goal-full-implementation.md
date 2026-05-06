<!-- markdownlint-disable MD013 -->
# Codex Goal Prompt for Full Implementation

## Metadata

- **Status:** Active
- **Owner:** Frank Lesniak
- **Last Updated:** 2026-05-06
- **Scope:** Reusable OpenAI Codex CLI `/goal` prompt for autonomously implementing the `macOSLab` repository from the approved specification, ADRs, and root phase TODO files. This file does not replace the repository instructions, specification, ADRs, or phase gates.
- **Related:** [Repository Copilot Instructions](../../.github/copilot-instructions.md), [macOSLab Repository Specification](../spec/macOSLab-repository-spec.md), [macOSLab Architecture Decision Records](../planning/macOS-imaging-08e-ADRs.md), [Phase 00 Branch Protection TODO](../../TODO-Phase-00-Branch-Protection.md), [Phase 04 Media Acquisition TODO](../../TODO-Phase-04-Media-Acquisition.md), [Phase 05 Parallels Provider TODO](../../TODO-Phase-05-Parallels-Provider.md), [Phase 06 UTM Provider TODO](../../TODO-Phase-06-UTM-Provider.md), [Phase 07 Evidence Pipeline TODO](../../TODO-Phase-07-Evidence-Pipeline.md), [Phase 08 Validation Loop TODO](../../TODO-Phase-08-Validation-Loop.md), [Phase 10 Deferred Work TODO](../../TODO-Phase-10-Deferred-Work.md)

## Prompt

Use the following prompt with the OpenAI Codex CLI `/goal` feature.

```text
Autonomously implement the macOSLab repository according to docs/spec/macOSLab-repository-spec.md.

Treat docs/spec/macOSLab-repository-spec.md as the primary implementation contract, with docs/planning/macOS-imaging-08e-ADRs.md and the root TODO-Phase-*.md files as active supporting requirements. Use docs/planning/macOS-imaging-08d-closed-questions-archive.md only as historical context.

Before making changes:
1. Read .github/copilot-instructions.md.
2. Read any relevant .github/instructions/*.md files for the file types you will edit.
3. Read docs/spec/macOSLab-repository-spec.md.
4. Read docs/planning/macOS-imaging-08e-ADRs.md.
5. Read all root TODO-Phase-*.md files.

Important constraints:
- Do not edit protected instruction files unless I explicitly authorize that exact file change in the current task: .github/copilot-instructions.md, anything under .github/instructions/, AGENTS.md, CLAUDE.md, or GEMINI.md.
- Do not add telemetry, external logging, secret-management services, or cloud mutation behavior unless explicitly approved.
- Do not commit secrets, tenant IDs, device IDs, recovery keys, local private data, screenshots, recordings, .ipsw/.iso/.dmg/.app files, .utm bundles, or credential-bearing files.
- Do not start a new macOS media download for the MMS demo path if the prepared IPSW exists at ~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw and matches SHA-256 8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32.
- Do not pivot Demo 4 back to Defender-unhealthy. The active Demo 4 story is Gatekeeper/System Policy Control blocking Visual Studio Code through an App-Store-only policy, followed by rollback to a known-good checkpoint.
- Do not commit a sample Gatekeeper `.mobileconfig`, screenshot, recording, app bundle, Team ID, tenant ID, UPN, device ID, profile UUID, recovery key, or tenant export.
- Do not push, tag a release, enable branch protection/rulesets, or perform destructive provider/cloud actions without explicit owner approval.

Work phase by phase, following Section 21 of the spec. For each phase:
1. Determine whether the phase is already complete.
2. Implement the missing deliverables for that phase.
3. Keep changes narrowly scoped to the phase.
4. Use mocks/fixtures for tests by default; default tests must not require real Parallels, UTM, Tart, Microsoft Graph, Defender, Intune, Apple ID, or a real macOS VM.
5. Run the required validation for the changed files, including pre-commit, Markdown lint, nested Markdown lint, Pester/PSScriptAnalyzer when PowerShell is added, and any repo-specific checks.
6. Fix validation failures.
7. Produce a concise phase summary listing deliverables, validation results, open issues, and whether any root TODO remains deferred.
8. Do not stop at every phase gate. Treat phase gates as implementation checkpoints: record the summary, keep each phase's changes reviewable, and continue into the next phase when the next phase can be implemented from the approved spec, ADRs, TODO files, and committed fixtures without destructive provider/cloud action or new owner-only input.
9. Pause at the owner-validation boundary instead. Based on the current supplied evidence, the expected autonomous span is Phase 2 through Phase 9 local implementation and validation. Pause after Phase 9 local validation, before any owner live dry run, push, release tag, branch protection/ruleset change, new media download, destructive provider/cloud action, optional Phase 10 expansion, or other action that explicitly requires owner approval. Pause earlier only if a requirement is ambiguous, required evidence is missing, validation cannot be fixed locally, or implementation would require a real provider, real cloud tenant, real macOS VM, or secret-bearing data.

Use the latest owner decisions already captured in the ADRs/TODOs:
- Module GUID is 4d6748ba-859d-4171-9785-889eaabdb048.
- Main branch protection/ruleset setup is deferred until after the repo is fully implemented and final check names are known.
- UTM v1 is a documented/manual provider-swap path with partial lifecycle automation, not full live Parallels parity.
- Tart remains stubbed/documented in v1 unless later explicitly approved.
- Defender validation is guest-scoped; do not require Defender on the host.
- Defender remains a required validation doc/test area, but it is no longer the live Demo 4 failure path.
- Gatekeeper/System Policy Control validation must include split broken/recovered plans, sanitized fixtures, redaction tests for Team IDs/profile identifiers, Demo 4 script/config updates, docs, and the generated slide-description artifact.
- Phase 8 documentation must include step-by-step Intune setup for macOS Defender deployment because it is part of the accepted session contract.
- Parallels implementation must use the verified same-major Tahoe path, hardening sequence, snapshot ID restore behavior, reliable VM existence checks, final-state verification, and explicit ShouldProcess/confirmation behavior documented in TODO-Phase-05-Parallels-Provider.md.
- Evidence should store normalized parsed facts as the durable contract and may include redacted/synthetic command-output attachments where useful.

Start by identifying the current phase state of the repository and then implement the next incomplete phase.
```
