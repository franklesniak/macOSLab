<!-- markdownlint-disable MD013 -->

# Phase 0 Bootstrap Codex Instructions

## Metadata

- **Status:** Deprecated
- **Owner:** Repository Maintainers
- **Last Updated:** 2026-05-05
- **Scope:** Historical task instructions used for the initial Phase 0 bootstrap work in `franklesniak/macOSLab`. This document is retained for context; current repository rules live in the related governance and planning documents.
- **Related:** [`README.md`](../README.md), [`AGENTS.md`](../AGENTS.md), [Repository Copilot Instructions](../.github/copilot-instructions.md), [Phase 0 PR description](phase-0-bootstrap-pr-description.md), [macOSLab repository specification](spec/macOSLab-repository-spec.md), [macOSLab ADRs](planning/macOS-imaging-08e-ADRs.md)

## Purpose

This document is retained as historical context for the initial Phase 0 bootstrap work. Do not treat it as current task authorization; current protected-file authorization is recorded in [Phase 0 Bootstrap PR Description Draft](phase-0-bootstrap-pr-description.md) and governed by [Repository Copilot Instructions](../.github/copilot-instructions.md).

The original prompt incorporated the owner updates made on 2026-05-04:

- Do not use `franklesniak@users.noreply.github.com` as a contact email.
- For general conduct/contact guidance, instruct people to contact the repository owners using the contact links on their GitHub profiles.
- For security vulnerabilities, direct people to GitHub private vulnerability reporting, which the owner has already enabled.
- Discussions are already enabled; update issue-template contact links accordingly.
- After Phase 0 bootstrap edits are complete, create a root TODO file for manual `main` branch-protection setup.

## Task Prompt

### Initialize `franklesniak/macOSLab` Phase 0 Bootstrap

You are working in `franklesniak/macOSLab`, a repository created from `franklesniak/copilot-repo-template`. A branch named `phase-0-bootstrap` already exists remotely and contains planning docs under `docs/planning/`. Base your work on that branch. If the branch is not present locally, fetch it and check it out before making Phase 0 changes.

Your job is to perform Phase 0 (Bootstrap) by walking through, in order, every relevant step in:

1. The now-removed template guide `GETTING_STARTED_NEW_REPO.md`.
2. The now-removed template guide `OPTIONAL_CONFIGURATIONS.md`.

Tailor the result to this repository's actual goals. Skip steps that require manual GitHub-side action, and explicitly note each skipped step in the PR description.

### Source Of Truth

Before making any change, read these files on the `phase-0-bootstrap` branch and treat them as authoritative:

- `docs/planning/macOSLab-spec.md`: full repository specification, including `MLAB-REQ-001` through `MLAB-REQ-015`, file map, cmdlet contracts, phases, evidence schema, and naming conventions.
- `docs/planning/ADRs.md`: accepted architecture decisions.
- `docs/planning/setup-step-by-step.md`: user-facing prerequisites and snapshot runbook.
- `docs/planning/session-runbook.md`: additional operational context.
- `docs/planning/CFP-submission.md`: additional project context.

If a template getting-started guide conflicts with the spec or ADRs, the spec and ADRs win. If a getting-started step is irrelevant to this repository's goal, skip it and explicitly note the skip in the PR description.

Also obey `.github/copilot-instructions.md` and `AGENTS.md`. Do not edit protected instruction files unless the repository owner explicitly authorizes that exact protected-file edit in the current task.

Protected files include:

- `.github/copilot-instructions.md`
- `AGENTS.md`
- `CLAUDE.md`
- `GEMINI.md`
- any file under `.github/instructions/`

Do not infer authorization from this Phase 0 task. Surface any desired protected-file changes as Open Questions / Requested Authorization in the PR description.

### Repository Identity

- Owner / GitHub handle: `franklesniak`
- Full repository: `franklesniak/macOSLab`
- Module name: `MacLab`
- `LICENSE` copyright holder: `Frank Lesniak`
- `LICENSE` year: `2026`
- General contact wording: contact the repository owners using the contact links on their GitHub profiles.
- Security vulnerability reporting: use GitHub private vulnerability reporting at `https://github.com/franklesniak/macOSLab/security/advisories/new`.
- VS Code `window.title`: `macOSLab`

### Repository Goal

This repository is a PowerShell 7.4+ module (`MacLab`) plus supporting scripts and documentation to build and validate Intune-managed macOS VMs. The supported local virtualization paths are Parallels Desktop Pro and UTM, with Tart kept as a stubbed advanced path. The repository languages are PowerShell and Markdown only.

There is no Python source code and no Terraform / HCL.

Therefore:

- Purge all Terraform / HCL content from the template: CI jobs, examples, `.gitignore` entries, pre-commit hooks, Terraform-named directories, README sections, PR-template sections, Dependabot ecosystems, and related docs.
- Historical exception: the original Phase 0 task did not authorize deleting or editing `.github/instructions/terraform.instructions.md` or any other protected instruction file. That authorization was granted separately on 2026-05-05 and applied in the protected-instruction cleanup.
- Purge Python sample/source content and Python-specific CI jobs per ADR-0008.
- Keep pre-commit itself and pre-commit hooks that happen to be implemented in Python, including `check-jsonschema`, `check-json`, `check-yaml`, `yamllint`, and `actionlint`. These are development tooling, not project Python code.
- If all Python source code is removed, delete the Black and Ruff hook entries from `.pre-commit-config.yaml`.
- Keep and harden PowerShell tooling, Markdown linting, pre-commit, GitHub Actions for PowerShell/Pester, issue and PR templates, CODEOWNERS, and governance files.
- macOS CI runner: `macos-latest`.
- Pester version: `5.7.1` everywhere it is installed or pinned, per ADR-0008.
- PowerShell floor: `7.4` everywhere configurable, per ADR-0001.
- Do not rewrite `SECURITY.md` per ADR-0009. Limit Phase 0 edits to placeholder substitution and private-vulnerability-reporting link updates required by this task. Do not add the project-specific `SECURITY.md` paragraph in Phase 0.

### Manual GitHub-Side Actions

Skip these actions and list them in the PR description under "Manual actions deferred to owner":

- Creating the repository from the template, because it is already done.
- Local-machine prerequisites, including Git, Python, Node.js installs, cloning, `npm install`, and `pre-commit install`.
- Creating the `triage` label. The owner is doing this. Assume the label will exist by PR review time and uncomment the `- triage` line in each issue template.
- Branch protection rules. Create the branch-protection TODO file described below, but do not attempt to configure GitHub settings yourself.
- Repository About description and topics.

Do not skip these, because the owner has already enabled the required GitHub-side features:

- Private vulnerability reporting is enabled. Update repository links that point security reporters to private vulnerability reporting.
- Discussions are enabled. Enable or uncomment the Discussions contact link where the issue-template configuration supports it.

### Step 1: Walk `GETTING_STARTED_NEW_REPO.md`

For each section, do the work that applies and explicitly note skipped sections in the PR description with a one-line reason.

#### Initial Placeholder Replacement

Perform every replacement that applies:

- Replace `OWNER/REPO` with `franklesniak/macOSLab` in all listed files.
- Replace `@OWNER` with `@franklesniak` in `.github/CODEOWNERS`.
- Replace `[INSERT CONTACT METHOD]` in `CODE_OF_CONDUCT.md` with wording that tells people to contact the repository owners using the contact links on their GitHub profiles.
- Replace `[security contact email]` in `SECURITY.md` with wording that directs security researchers to GitHub private vulnerability reporting at `https://github.com/franklesniak/macOSLab/security/advisories/new`. Keep this as a narrow placeholder substitution; do not rewrite `SECURITY.md`.
- Keep `Frank Lesniak` in `LICENSE`, but update the copyright year to `2026`.
- Set `.vscode/settings.json` `window.title` to `macOSLab`.

#### Creating Optional Labels

Do not create the `triage` label. The owner is doing that in GitHub. Uncomment the `- triage` line in each issue template anyway and note this assumption in the PR description.

#### Pre-Commit Configuration

Make sure `.pre-commit-config.yaml` is valid for the kept hook set. Do not run `pre-commit install`. If the environment allows, run:

```bash
pre-commit run --all-files
```

Include all auto-fixes in the same commit as the related change. If pre-commit cannot run, explain exactly why in the PR description and reason through the remaining hooks.

#### Language-Specific Customization

Apply the repository-goal purge and hardening described above. Update at least:

- `.gitignore`
- `.pre-commit-config.yaml`
- `.github/workflows/*.yml`
- `.github/ISSUE_TEMPLATE/*.yml`
- `.github/ISSUE_TEMPLATE/config.yml`
- `.github/pull_request_template.md`
- `.github/CODEOWNERS`
- `package.json`
- `README.md`
- `CONTRIBUTING.md`
- `CODE_OF_CONDUCT.md`
- `SECURITY.md`
- `LICENSE`

Do not edit protected instruction files. List any desired protected-file changes as Open Questions / Requested Authorization.

#### Package Metadata, README, CONTRIBUTING, Code Of Conduct, Copilot Instructions

Apply the customizations that are not protected-file edits. Do not edit `.github/copilot-instructions.md`, `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, or `.github/instructions/*.instructions.md`. Put recommended protected-file updates in the PR description instead.

### Step 2: Walk `OPTIONAL_CONFIGURATIONS.md`

Apply or skip each section deliberately. Include an applied-vs-skipped checklist in the PR description.

#### Issue Template Configuration

- Leave `blank_issues_enabled: true`.
- Enable the Discussions contact link because Discussions are already enabled.
- Enable or update the security contact link to use GitHub private vulnerability reporting at `https://github.com/franklesniak/macOSLab/security/advisories/new`.
- Skip Support/FAQ links unless the repository already has concrete support or FAQ docs.

#### Pull Request Template

- Strengthen pre-commit language to the unconditional form because this repository definitely uses pre-commit.
- Add a PowerShell-specific checklist section:
  - Pester `5.7.1` passes locally.
  - PSScriptAnalyzer is clean.
  - `Test-LabReadiness.ps1` runs without parameter errors when applicable.
- Do not add Node, .NET, Go, Rust, Java, Python, or Terraform checklist sections.
- Update the contributing-guidelines link to `franklesniak/macOSLab`.

#### Dependabot Configuration

- Keep weekly cadence.
- Remove `pip` and Terraform ecosystems if present.
- Keep `github-actions` and `npm`.

#### Pre-Commit Configuration

- Disable Black and Ruff hooks by deleting those hook entries.
- Keep `check-json`, `check-yaml`, `yamllint`, `actionlint`, `check-jsonschema`, `check-metaschema`, `trailing-whitespace`, `end-of-file-fixer`, `check-added-large-files`, and `markdownlint-cli2`.

#### Schema Validation Configuration

Per spec Section 25, the real evidence-bundle schema belongs under `schemas/`. In Phase 0, do not add the real schema. Leave the worked-example schema and its `check-jsonschema` hook in place so schema validation remains exercised.

Add a TODO entry in `TODO-Phase-07-Evidence-Pipeline.md` to replace the worked example with the real evidence schema during Phase 7.

#### Markdown Linting / Workflow

Keep Markdown linting and the Markdown workflow enabled.

#### Copilot Instructions Configuration

Do not edit any `.github/instructions/*.instructions.md` file or other protected instruction file. Surface recommended changes as Open Questions / Requested Authorization.

#### CI Workflow / PowerShell CI Workflow

- Set macOS jobs to `macos-latest`.
- Set the PowerShell minimum to `7.4`.
- Pin Pester to `5.7.1`.
- Remove Terraform CI jobs entirely.
- Remove Python CI jobs unless a minimal Python job is strictly required to drive retained pre-commit hooks. If such a job is retained, keep it narrowly scoped to pre-commit/tooling and explain why.

#### Auto-Fix Pre-Commit Workflow / Placeholder Check Workflow

Keep both workflows. Verify the placeholder check passes after replacements.

#### Pester Test Template / PSScriptAnalyzer Configuration

Keep both. Align with spec Sections 13.1 and 13.3.

#### Python Template Files

Delete Python template/source/sample files. Keep Python-based development tooling only when used by retained pre-commit hooks.

#### CODEOWNERS / Node.js Package Configuration / Gitignore / License / VS Code PowerShell Encoding

Apply normally:

- Tailor `.gitignore` to drop Terraform-specific patterns.
- Add macOS, PowerShell, Parallels, UTM, and local evidence/cache patterns defined by the spec, including `*.pvm/`, `*.utm/`, `.DS_Store`, and any local evidence/cache directories the spec defines.
- Keep Node.js package configuration only for repository tooling such as Markdown linting.
- Keep license metadata aligned with `Frank Lesniak` and `2026`.
- Preserve or add VS Code PowerShell encoding settings if the template provides them.

#### Ongoing Maintenance

Leave ongoing-maintenance guidance in place unless it contradicts the spec or ADRs.

### Step 3: Root TODO Files

Create root-level TODO files for outstanding work. Omit a phase file only if the phase has no outstanding TODOs after Phase 0.

Each TODO file must follow the metadata block style used in the planning docs:

- **Status**
- **Owner**
- **Last Updated**
- **Scope**

Each file must contain one clear checklist item per outstanding verification.

Create these files:

- `TODO-Phase-04-Media-Acquisition.md`: verify current `mist-cli` list/download syntax.
- `TODO-Phase-05-Parallels-Provider.md`: verify current `prlctl` syntax and version/edition detection.
- `TODO-Phase-06-UTM-Provider.md`: verify current UTM / `utmctl` automation surface and manual-step gaps.
- `TODO-Phase-07-Evidence-Pipeline.md`: replace the worked-example schema with the real evidence-bundle schema from spec Section 25.
- `TODO-Phase-08-Validation-Loop.md`: verify current Defender `mdatp health` output shape and sanitize fixtures.
- `TODO-Phase-10-Deferred-Work.md`: track deferred items, including Tart full provider parity (ADR-0006), `Reset-IntuneMacLabDevice.ps1` cloud-mutation mode (ADR-0010), and any `SECURITY.md` paragraph proposed for Phase 1.
- `TODO-Phase-00-Branch-Protection.md`: document the owner action to configure branch protection on `main`.

`TODO-Phase-00-Branch-Protection.md` must include a checklist for:

- Require a pull request before merging.
- Require status checks before merging:
  - Markdown lint workflow.
  - Placeholder check workflow.
  - PowerShell CI workflow.
  - Auto-fix pre-commit workflow.
- Require linear history.
- Require CODEOWNERS review.

### Step 4: README

Replace the template `README.md` body with a minimal `macOSLab` README that:

- States the repository goal in one paragraph.
- Points to `docs/planning/macOSLab-spec.md` as the source of truth for design and `docs/planning/ADRs.md` for accepted decisions.
- Lists supported PowerShell and macOS targets:
  - PowerShell 7.4+
  - Tahoe 26.4.1 demo path
  - Sequoia 15.7.5 compatibility
  - Sonoma 14.8.5 compatibility
- Names providers:
  - Primary: Parallels Desktop Pro
  - Secondary: UTM
  - Stubbed advanced path: Tart
- States the v1 cloud-cleanup posture: report-only, per ADR-0010.
- Links to `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, and active `TODO-Phase-*.md` files.
- States explicitly that this repository is not legal advice. Users must verify Apple licensing and Tart / Orchard Fair Source terms with their own legal and procurement teams, per ADR-0006 and ADR-0007.

### Out Of Scope

Do not do these in Phase 0:

- Do not implement cmdlets in `MacLab/`. Phase 0 is bootstrap only; cmdlet implementation begins in Phase 2 and later.
- Do not edit protected instruction files.
- Do not add the project-specific `SECURITY.md` paragraph; ADR-0009 defers it to Phase 1.
- Do not add the real evidence-bundle JSON Schema; defer it to Phase 7.
- Do not configure cloud-mutation behavior in cleanup scripts; ADR-0010 says report-only first.
- Do not perform manual GitHub settings changes from the local coding environment.

### PR Description Deliverables

The PR description must include:

1. A checklist showing which `GETTING_STARTED_NEW_REPO.md` steps were applied vs. skipped, with a reason for every skip.
2. A checklist showing which `OPTIONAL_CONFIGURATIONS.md` sections were applied vs. skipped, with a reason for every skip.
3. A "Manual actions deferred to owner" section listing every skipped GitHub-side action, including label creation, branch protection, and About/topics.
4. An "Open Questions / Requested Authorization" section listing:
   - Any change that should happen to a protected instruction file.
   - Whether the owner approves removing or de-linking Terraform instruction references.
   - Whether the profile-contact wording in `CODE_OF_CONDUCT.md` is acceptable.
   - Whether the private-vulnerability-reporting wording in `SECURITY.md` is acceptable.
5. Output of `pre-commit run --all-files`, or a clear note that it could not run, including the reason and hook-by-hook risk assessment.

Follow the constitution's pre-commit discipline rule: include all auto-fixes in the same commit as the change that introduced them. Do not push a separate formatting-only or lint-only commit.
