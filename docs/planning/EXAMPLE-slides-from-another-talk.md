<!-- markdownlint-disable MD013 -->

# Unified Slide Deck + Demo + Run-of-Show (Hand-off Ready)

## Role Alchemy: Forging Least-Privilege Roles from Cloud Logs with PowerShell

**Speakers:** Danny Stutz & Frank Lesniak
**Session:** 45-minute breakout | 300-level | Security
**Works on:** PowerShell 7 + Windows PowerShell 5.1
**Primary outcome:** A practical, PowerShell-driven pipeline that derives least-privilege custom roles from activity logs, with auto-k clustering, guardrails, staged rollout, and validation. Optional AI is only for naming/docs.

---

## 0) Deck-wide rules (so the final deck is reliable)

### Visual/theme

- Dark theme (VS Code-like), high contrast, minimal distractions.
- Subtle PowerShell green/blue accents.
- Consistent stage icons/storyboard in a corner or footer:
  **🧾 Logs → 🧮 Matrix → 🧠 Clusters → 📄 JSON → ✅ Validate → 🛡️ Operate**

### Code on slides

- Keep snippets to **3–8 lines** per slide.
- All full code goes into the GitHub repo; slides show only "spine commands."

### Plots/visuals

- Use **static PNGs** for elbow/silhouette plots and any cluster visualization (reliability).
- Live demo uses **tables/summaries** rather than live plotting.

### QR code strategy

- Avoid large QR early (it distracts from the hook).
- Add a small repo shortlink + tiny QR **starting at the Demo Roadmap slide**.
- Put a large QR + URL on the final slide.

### Meme/humor strategy

- Use one or two well-placed memes or pop-culture references to break tension and anchor key concepts in memory. Candidates are noted in the slide plan below. Keep them relevant and professional enough for a 300-level security audience.

---

## 1) Non-negotiable correctness and safety statements (must appear on slides or speaker notes)

### Azure RBAC semantics (correct wording)

- `Actions` / `DataActions` = allowed permissions.
- `NotActions` / `NotDataActions` = **exclusions** from broad allow patterns; they are not explicit "deny rules."
- Demo validation should show "**not granted**" authorization failures, not deny assignment behavior.

### Logs caveat (must be stated)

- Logs show **observed** behavior in a time window, not guaranteed future requirements.
- Mitigations: longer windows, compare windows for seasonality, SME review, exception/break-glass process, staged rollout + testing.

### Succeeded vs failed operations (best practice + options)

- **Default (recommended):** derive permissions from **Succeeded** operations only.
- **Optional (recommended):** produce a separate report of **authorization failures by principal/action** as a review queue.
  - Do not auto-grant from failures.

### AI policy

- AI is optional "last-mile sugar" for naming/descriptions/formatting.
- "AI output is untrusted input."
- Human approval gate is mandatory.
- Sanitize inputs (no PII, no client identifiers, avoid raw resource IDs).

---

## 2) Content decisions where there is "no single right answer" (state options + recommended default)

### A) Time window (30 vs 60–90 days)

- **Default recommendation:** **60–90 days** (captures infrequent month-end tasks).
- **Pilot/quick test:** 30 days (fast, but incomplete).
- **Seasonal orgs:** compare multiple windows.
- Always paired with SME review + exception process.

### B) K-range for auto-k (2..15 vs 2..20 vs dynamic)

- **Fixed range:** simple and predictable (e.g., 2..15 or 2..20).
- **Dynamic Kmax (recommended):** scales with principal count, e.g.
  `Kmax = min(20, floor(Nprincipals/5))`
- Apply operational guardrails (min cluster size, max role cap, parsimony).

### C) AI in the demo

- **Recommended for stage reliability:** show **cached AI output** (screenshot or saved JSON).
- Live AI call is optional with hard timeout + fallback.

### D) Ingestion at scale (`Get-AzLog` vs Log Analytics adapter)

- **Stage + default path:** `Get-AzLog` + batching + caching (universally teachable).
- **Scale adapter (mention briefly / document in repo):** Log Analytics query / exports / SIEM pipeline.

---

## 3) Slide deck (Main deck ~28–32 slides) + speaker notes + ownership

> Slide count is intentionally sized to protect demo time.
> Put depth (metrics formulas, troubleshooting, alternatives) into backups.

### Slide 1 — Title

**Role Alchemy: Forging Least-Privilege Roles from Cloud Logs with PowerShell**
Danny Stutz & Frank Lesniak — PowerShell + DevOps Global Summit 2026
45-minute breakout | 300-level | Security

**Speaker notes:** "Practical pipeline + demo; not ML theory. We have a GitHub repo with everything you need to take this home."

---

### Slide 2 — The Hook: "Contributor Confession"

**Poll:** Who has users or service principals in "Contributor" right now because it was easier?

- You're not alone.
- Cloud moves faster than reviews.
- Convenience → sprawl → risk.

**Speaker notes:** Keep it light and relatable; get hands in the air. Transition quickly to the problem framing. This is the "shared pain" moment that earns the audience's attention for the next 43 minutes.

---

### Slide 3 — The Problem: Permission Sprawl is a Security and Ops Tax

- Built-in roles are broad by design
- Manual custom roles are slow and drift quickly
- Over-permissioning increases blast radius
- Audits and reviews lag behind reality

**Visual:** A timeline graphic showing privileges accumulating over time with risk increasing — could be styled like a "tech debt snowball" rolling downhill.

**🎨 Meme opportunity:** "This is fine" dog-in-burning-room meme, captioned "Our 'Contributor' assignments are fine." Gets a laugh, anchors the pain point.

**Speaker notes:** Emphasize this is not a niche problem — it is the *default state* in most cloud environments. Tie directly to breach statistics or compliance audit findings if available.

---

### Slide 4 — Why Activity Logs? (Transition Slide)

**Core insight:** The best evidence for what permissions someone needs is what they actually do.

- Activity logs are the *behavioral source of truth*
- They capture management-plane operations with timestamps, principals, and outcomes
- They already exist — you're just not using them for RBAC yet

**Visual:** Simple before/after contrast — "Guessing" (person staring at a permissions matrix with a question mark) vs. "Deriving" (data flowing through a funnel into a precise role definition).

**Speaker notes:** This slide bridges the problem and the solution. It answers the implicit "so what do we do instead?" question. Preview the "behavior fingerprints" analogy here: "Think of it as reading the cloud's diary to find out what people actually need." The audience needs the *why* before the *how*.

---

### Slide 5 — The Promise + Roadmap (the "spine" slide)

**Stop guessing roles: derive them from behavior.**

**Pipeline diagram:**

1. Logs
2. User-action matrix
3. Auto-k clustering (k-means++)
4. Minimal role JSON draft
5. Human approval
6. Deploy + validate
7. Drift/CI/CD/rollback

**Speaker notes:** This is the "spine" that appears in the footer throughout the deck. Point to it and say: "This is the entire talk in one slide. Every section maps to a stage. If you ever feel lost, look at the footer — it tells you where we are." Revisit this slide briefly before the demo to re-orient the audience.

---

### Slide 6 — What You'll Leave With

- PowerShell pipeline blueprint (PS7 + WinPS 5.1)
- Auto-k method with guardrails (no role explosion, no mega-roles)
- Role JSON emitter + deployment + validation scripts
- Governance patterns (approvals, staging, rollback, drift)
- Optional AI for naming/docs (gated)
- Repo: scripts + sample sanitized data + templates + docs
- Multi-cloud extension guide (Azure primary, AWS + GCP adapters documented)

**Speaker notes:** This is the "contract" with the audience. Read this list once, clearly. The goal is to set expectations so attendees know exactly what they're getting — and to hook the skeptics who are thinking "this sounds theoretical" by promising concrete artifacts. Confirm that this slide visually maps to all five key takeaways from the session proposal:

1. "Ingest and process cloud activity logs" → covered by blueprint
2. "Apply unsupervised clustering with auto-k" → covered by auto-k method
3. "Generate least-privilege, production-ready RBAC role definitions" → covered by JSON emitter
4. "Validate the deployed roles" → covered by deployment + validation scripts
5. "Adapt this methodology to multi-cloud" → covered by multi-cloud extension guide

---

### Slide 7 — Scope and "Truth in Advertising"

**In scope:** management-plane RBAC role definitions derived from control-plane operations
**Not magic:** observed behavior ≠ complete requirements
**Non-negotiable:** human review + testing + staged rollout

**Speaker notes:** This is a trust-building slide. Be candid. Say: "I'm going to tell you what this *can't* do before I show you what it can." Acknowledge that logs only capture a time window, that seasonal tasks may be missed, and that subject-matter-expert review is always required. This honesty makes the rest of the talk more credible.

---

### Slide 8 — Data Sources (Conceptual Multi-Cloud)

| Cloud | Log Source | Role Output |
| --- | --- | --- |
| Azure | Activity Logs (`Get-AzLog`) | Custom Role Definition JSON |
| AWS | CloudTrail (management events) | IAM Policy JSON |
| GCP | Cloud Audit Logs | IAM Custom Role YAML |

**Message:** ingestion and permission-mapping are adapters; the clustering core stays the same.

**Visual:** Three-column diagram with cloud logos at top, "adapter layer" in the middle, and a shared "clustering engine" box at the bottom.

**Speaker notes:** Keep this conceptual — do not deep-dive AWS or GCP here. The point is: "If your org is multi-cloud, the hard part (clustering) is reusable. You only swap the edges." Reference the repo's multi-cloud adapter notes for attendees who want to explore further.

---

### Slide 9 — Ingest Logs (Azure) — Minimal Code

```powershell
$start = (Get-Date).AddDays(-90)
$end   = Get-Date
$logs  = Get-AzLog -StartTime $start -EndTime $end |
  Where-Object { $_.Status.Value -eq 'Succeeded' } |
  Select-Object EventTimestamp, Caller, OperationName, ResourceId
```

**Scale note:** at enterprise scale, swap ingestion adapter (documented in repo).

**Speaker notes:** Walk through the code line by line. Emphasize: "Succeeded only — we derive roles from what *worked*, not what was attempted." Briefly mention that the repo includes a separate script to generate an authorization-failure report as a review queue for access requests.

---

### Slide 10 — Performance Pro Tips

- Batch by time slices (daily/weekly) to avoid API throttling
- Cache raw results locally — don't re-pull while iterating on clustering parameters
- Use memory-safe grouping patterns (e.g., `Group-Object -NoElement`)
- For enterprise scale: consider Log Analytics KQL export or Azure Data Explorer

**Speaker notes:** This is a "save you pain" slide. Speak from consulting experience: "We learned these the hard way so you don't have to." Keep it brisk — 60 seconds max.

---

### Slide 11 — Artifact Strategy (Auditability + Repeatability)

Persist at each stage:

- Raw logs snapshot
- Shaped counts
- Matrix + settings (normalization method, thresholds)
- Auto-k report (scores per candidate k + chosen k + random seed)
- Cluster summaries (including sample principals)
- Role JSON drafts
- Validation transcript (timestamp + git commit hash)

Export formats:

- CSV (small datasets / demos)
- Parquet (large / repeated runs)
- JSON / CLIXML (fidelity / debug)

**Speaker notes:** "If you can't reproduce it, you can't defend it in an audit." This slide matters for the security audience — they need to show auditors *why* a role looks the way it does. The artifact chain is your evidence trail.

---

### Slide 12 — Shape Data: Events → Counts

**Goal:** Transform raw log entries into (principal, action, count) tuples.

**Cleaning steps:**

- Normalize principal identities (UPN, object ID, SPN display name)
- Filter noise operations (e.g., repeated health checks) — optional but recommended
- Deduplicate retries (e.g., multiple 200s for the same logical operation) — optional
- **Include workload identities** (service principals, managed identities) — they need roles too

**Speaker notes:** "Don't forget your service principals. In most environments we've seen, SPNs and managed identities are the *most* over-permissioned principals because they were set up once and never reviewed."

---

### Slide 13 — The User-Action Matrix ("Behavior Fingerprints")

- Rows: principals (users, SPNs, managed identities)
- Columns: distinct actions (e.g., `Microsoft.Storage/storageAccounts/read`)
- Cells: frequency or normalized frequency

**Analogy:** "Think of it as a Spotify listening profile — but for cloud operations. Each person has a unique pattern, and similar patterns reveal natural groups."

**Visual:** A small, color-coded heatmap snippet showing 5–6 principals and 8–10 actions, with warmer colors for higher frequency. The heatmap makes the "fingerprint" analogy tangible and is far more memorable than a raw table.

**Design options to decide:**

- Cluster all principals together (simpler, works well for small environments)
- Cluster humans and workload identities separately (often produces cleaner results in larger environments)

**Speaker notes:** "This is the single most important data structure in the pipeline. Everything downstream depends on getting this right." Use the heatmap visual to point out obvious groupings — "See how these three users light up the same columns? That's a natural role waiting to be discovered."

---

### Slide 14 — Matrix Build (Conceptual Code)

```powershell
$counts = $logs |
  Group-Object Caller, OperationName -NoElement |
  Select-Object @{n='Caller'; e={($_.Name -split ',',2)[0].Trim()}},
                @{n='Action'; e={($_.Name -split ',',2)[1].Trim()}},
                @{n='Count';  e={$_.Count}}

$matrix = ConvertTo-UserActionMatrix -Counts $counts -Normalize
```

**Optional tunables (documented in repo):**

- Relative frequency normalization (default)
- Log scaling
- TF-IDF-like weighting (advanced, for environments with very common "noise" actions)

**Important implementation note (speaker notes only, not on slide):**

- The `-split ',',2` pattern is shown for clarity; the repo uses a safer keying approach to handle edge cases like commas in resource names.
- `ConvertTo-UserActionMatrix` is a custom function in the repo that pivots the counts into a dense or sparse matrix object.

**Speaker notes:** "This is the 'glue' code. It's not glamorous, but it's where most bugs hide. The repo handles edge cases — on stage I want you to see the *shape* of the logic, not wrestle with string parsing."

---

### Slide 15 — K-Means in 60 Seconds

**What it does:** groups similar "fingerprints" into clusters without being told what the groups should be.

**Analogy:** "Imagine dumping a bag of mixed Lego bricks on a table and asking someone to sort them into piles by 'similarity' — without giving them any labels. K-means does that, but with math."

**Key properties:**

- Unsupervised — no labeled training data required
- k-means++ initialization for stability (avoids bad random starts)
- Fast, scalable, and "explainable enough" for security and ops teams

**Interpretation:** each cluster is a candidate "job-to-be-done" role persona.

**Visual:** A simple 2D scatter plot showing colored clusters with centroids marked — the classic k-means visual, but annotated with role-relevant labels ("Storage Readers," "VM Operators," "Network Admins") to connect the math to the business outcome.

**Speaker notes:** "You don't need to understand the linear algebra. The key insight is: users who do similar things end up in the same cluster, and each cluster becomes a candidate role. The algorithm finds structure that humans would miss — or take weeks to find manually." Labeling clusters with role-relevant names on the scatter plot directly connects the abstract math to the concrete security outcome — this is the "aha moment" for the audience.

---

### Slide 16 — Auto-k: The Goldilocks Problem

**Too few clusters → mega-roles** (overly permissive, back to the original problem)
**Too many clusters → role explosion** (unmanageable, defeats the purpose)

We evaluate candidate k values and score them:

- **Silhouette score** (primary): measures how well-separated and internally cohesive each cluster is. Higher is better.
- **Inertia / SSE elbow** (secondary): measures total within-cluster variance. Look for the "elbow" where adding more clusters stops helping much.

**Operational guardrails:**

- Minimum cluster size (don't create a role for one user)
- Maximum role cap (organizational sanity check)
- Parsimony principle: if two k values score similarly, choose fewer roles

**🎨 Visual opportunity:** A "Goldilocks and the Three Bears" styled graphic — three bowls labeled "Too few," "Just right," "Too many" — with cluster counts underneath. Light humor that reinforces the core concept.

**Speaker notes:** "This is the part most people get stuck on when they try k-means for the first time: 'How do I pick k?' Our answer: you don't. The algorithm picks it for you, subject to guardrails that encode your organization's operational reality."

---

### Slide 17 — Auto-k Visuals (Static)

**Show two side-by-side plots:**

- **Elbow plot:** inertia vs. k, with the chosen "knee" region highlighted
- **Silhouette plot:** silhouette score vs. k, with the chosen k marked

**Decision rule (on slide):**
"Pick the smallest k that is near-best on silhouette and past the elbow, subject to guardrails."

**Speaker notes:** "These plots are static PNGs generated during the analysis. In the repo, you'll find the script that produces them. For the demo, we'll show the *output* of the auto-k analysis — the recommended k and the scores — rather than re-generating these plots live."

---

### Slide 18 — Cluster Summaries (Human Review Output)

**Example table:**

| Cluster | Size | Top Actions | Sample Principals | Flags |
| ---: | ---: | --- | --- | --- |
| 1 | 12 | storage/read, resources/read | u-001, u-014 | — |
| 2 | 8 | compute/write, network/write | sp-002, sp-031 | — |
| 3 | 4 | authorization/\*, policy/write | u-009, u-017 | ⚠ sensitive |
| 4 | 6 | sql/read, sql/write | sp-045, u-022 | — |
| 5 | 3 | keyvault/read, keyvault/write | sp-011 | ⚠ sensitive |

**Notes:**

- Include "sample principals" (sanitized) to accelerate SME review — reviewers can say "oh, those are the DBAs"
- Flag clusters with sensitive actions (authorization writes, key vault access, policy changes)
- Flag unusually small clusters for manual inspection

**Speaker notes:** "This table is the *conversation starter* with your security team. You're not asking them to design roles from scratch — you're asking them to validate a data-driven proposal. That's a fundamentally different conversation."

---

### Slide 19 — Representative Members (Centroid Distance Analysis)

**Purpose:** Identify the most "typical" members of each cluster for faster review and optional AI labeling.

**Method:**

- Compute each member's Euclidean distance to the cluster centroid
- The closest members are the most representative — their action profiles best summarize the cluster's "personality"
- Show the **3–5 most representative members** and their top actions

**Visual:** A single-cluster scatter plot with the centroid marked and concentric distance rings. The closest points are highlighted and labeled with their top actions.

**Use cases:**

- Feed only representative action sets to AI (if used) — reduces noise and token cost
- Present to SMEs for quick "does this grouping make sense?" validation
- Use for role naming ("the representative members are all storage monitors → call it Storage Monitor")

**Speaker notes:** "This is a technique Danny and I developed in our earlier text-clustering work at the Summit. For each cluster, we calculate who is closest to the center — who is most 'typical.' Those representative members tell you what the cluster is *about* more efficiently than looking at every single member."

---

### Slide 20 — Cluster → Minimal Permissions (Draft)

**Steps:**

1. Union all distinct actions observed across cluster members
2. Threshold outliers — remove "one-off" actions performed by a single member (flag for review instead of including)
3. Apply policy checks against a configurable sensitive-action list
4. Separate management-plane `Actions` from `DataActions`
5. Emit role JSON draft

**RBAC correctness callout (on slide, visually prominent):**
`NotActions` are **exclusions from broad allow patterns**, not explicit deny rules. If you need a hard deny, use Azure Deny Assignments (a separate mechanism).

**Speaker notes:** "Step 2 is where you prevent a single user's unusual Tuesday from defining everyone's role. If one person in Cluster 1 ran a delete operation once, that doesn't mean 'Storage Reader' needs delete permissions. We flag it and send it to a review queue."

---

### Slide 21 — Role JSON Artifact (Excerpt)

```json
{
  "Name": "RoleAlchemy-StorageMonitor",
  "IsCustom": true,
  "Description": "Read-only storage and resource group access. Derived from 90-day activity log analysis. Review required before production assignment.",
  "Actions": [
    "Microsoft.Storage/storageAccounts/read",
    "Microsoft.Storage/storageAccounts/listKeys/action",
    "Microsoft.Resources/subscriptions/resourceGroups/read"
  ],
  "NotActions": [],
  "DataActions": [
    "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read"
  ],
  "NotDataActions": [],
  "AssignableScopes": ["/subscriptions/00000000-0000-0000-0000-000000000000"]
}
```

**Speaker notes:** "This is the artifact your pipeline produces. Notice the description includes *how* it was derived and a reminder that review is required. That's not just good practice — it's your audit trail." Highlight that `DataActions` are separated from `Actions` — this is a common mistake in manually crafted roles. The JSON example includes all four permission fields (`Actions`, `NotActions`, `DataActions`, `NotDataActions`) to be production-accurate.

---

### Slide 22 — Approval Gate + Circuit Breakers

**Non-negotiable governance steps:**

- PR review (git-based workflow)
- Security team sign-off on any role containing sensitive actions
- Scope decision explicitly recorded (subscription, resource group, or management group)
- Validation plan + rollback plan documented before deployment

**Policy banners (display prominently):**

- "Automation output is untrusted input."
- "AI output is untrusted input."

**Sensitive actions review list (examples):**

- `Microsoft.Authorization/*/write` (role and policy assignments)
- `Microsoft.Authorization/policyExemptions/*`
- `Microsoft.KeyVault/vaults/secrets/*`
- Broad deletes or wildcard writes
- Network boundary changes (NSG rules, firewall policies)

**Tool behavior:**

- Auto-flag any role containing sensitive actions
- Optional: block JSON emission unless explicit override + audit log entry

**Speaker notes:** "This is the slide that makes your security team comfortable with the whole approach. The pipeline is *designed* to stop here and wait for a human. No role gets deployed without someone signing off."

---

### Slide 23 — Deploy + Validate (Staged Rollout)

**Staged rollout process:**

1. Deploy role definition to a **test scope** (not production)
2. Assign to a **test principal**
3. Validate: confirm allowed actions succeed AND unauthorized actions are correctly denied
4. Promote to production scope via CI/CD pipeline with approval gate

```powershell
New-AzRoleDefinition -InputFile .\RoleAlchemy-StorageMonitor.json
```

**Validation evidence to capture:**

- Timestamp of validation test
- Role definition version + git commit hash
- Exact commands executed + outputs (succeed and fail)
- Tester identity

**Speaker notes:** "The validation step is the *payoff* of the entire talk. This is where we prove the role works. We'll show this live in the demo — a command that succeeds and a command that gets denied. If you remember one thing from this talk, remember: never deploy a role you haven't tested."

---

### Slide 24 — Optional AI Assist (Quality-of-Life Only)

**AI can accelerate:**

- Proposing business-friendly role names (e.g., "Storage Monitoring Specialist" instead of "Cluster-3")
- Writing human-readable role descriptions
- Formatting/grouping permissions logically
- Drafting PR notes for the approval workflow

**AI cannot and must not:**

- Decide which permissions to include or exclude
- Approve or deploy roles
- Override human judgment

**Integration approach:**

- Send a sanitized, representative permission list to an LLM via `Invoke-RestMethod`
- Use a reproducible prompt that instructs the model to act as a security architect
- Parse the structured response (role name, description, formatted JSON)

**Stage reliability options:**

1. No AI (default — pipeline is fully functional without it)
2. Cached AI output (recommended for demos and presentations)
3. Live API call (higher risk; use hard timeout + fallback to cached output)

**Guardrails:** sanitize all inputs (no PII, no client identifiers, no raw resource IDs); validate schema of outputs; human approval gate remains mandatory.

**Speaker notes:** "We want to be very clear: the AI is *documentation sugar*. It makes the output nicer for humans to read. It does not make security decisions. If your organization can't use external AI services, skip this step entirely — the pipeline produces the same security outcome without it."

**Consider adding a small visual:** Side-by-side of "Cluster-3: Microsoft.Storage/storageAccounts/read, ..." (raw output) vs. "Storage Monitoring Specialist: Read-only access to storage accounts and resource metadata for monitoring dashboards" (AI-enhanced output). This makes the value proposition of the AI layer instantly obvious without overselling it.

---

### Slide 25 — Operate It: Drift Detection + CI/CD + Rollback

**Ongoing operations:**

- Rerun the analysis monthly or quarterly to detect behavioral drift
- Compare new cluster compositions against existing role definitions
- Generate a diff report and open a PR for review
- Same approval + staged rollout process applies to role updates

**CI/CD integration pattern:**

- Scheduled pipeline trigger (e.g., Azure DevOps, GitHub Actions)
- Pulls fresh logs → runs clustering → compares to baseline → opens PR if drift detected
- Human reviews and approves before any role changes are deployed

**Rollback:**

- Keep versioned JSON role definitions in git
- Rollback = deploy previous version + re-validate

**Speaker notes:** "Roles aren't 'set and forget.' People's jobs change, new services get deployed, teams reorganize. The same pipeline that *created* your roles can *maintain* them. Schedule it, review the diffs, and your RBAC stays aligned with reality instead of drifting back toward sprawl."

---

### Slide 26 — Multi-Cloud Extension (One Slide, Conceptual)

**Core message:** The clustering engine is cloud-agnostic. Only the "edges" change.

| Component | Azure | AWS | GCP |
| --- | --- | --- | --- |
| **Ingest** | `Get-AzLog` | CloudTrail (`Get-CTEvent`) | `gcloud logging read` |
| **Action format** | `Microsoft.Storage/*/read` | `s3:GetObject` | `storage.objects.get` |
| **Role output** | Custom Role Definition JSON | IAM Policy JSON | IAM Custom Role YAML |
| **Deploy** | `New-AzRoleDefinition` | `aws iam create-policy` | `gcloud iam roles create` |

**What stays the same:** matrix construction, k-means clustering, auto-k algorithm, approval workflow, validation pattern.

**Speaker notes:** "We're not going to deep-dive AWS or GCP today — that's a whole separate talk. But the repo includes adapter notes and starter scripts for both. The key insight is that the *hard* part — clustering and role generation — is identical. You're just swapping the plumbing on either end."

---

### Slide 27 — Consulting War Story (Brief Case Study)

**Purpose:** Ground the methodology in real-world impact. Keep it brief (60–90 seconds).

**Structure (anonymized):**

- **Situation:** Client had 40+ custom roles, many overlapping, accumulated over 3 years of ad hoc requests. Quarterly access reviews took 2 weeks of manual effort.
- **Approach:** Ran the pipeline against 90 days of activity logs.
- **Result:** Pipeline recommended consolidating to ~12 distinct role profiles. After SME review, deployed 14 custom roles (2 added for edge cases). Review cycle dropped from 2 weeks to 2 days.
- **Lesson:** "The data showed us that 40 'unique' roles were really 12 patterns with cosmetic differences."

**Speaker notes:** "If you have your own metrics from client engagements, substitute them here. Even approximate numbers ('reduced by ~60%') are more persuasive than no numbers. A brief, anonymized example makes the methodology feel battle-tested rather than theoretical."

---

### Slide 28 — Demo Roadmap (start footer with repo shortlink + tiny QR)

**Demo steps:**

1. Load sanitized sample logs from a local file
2. Build the user-action matrix
3. Show auto-k analysis result (static plots + recommended k)
4. Inspect one cluster's summary and representative members
5. Emit role JSON
6. Deploy to Azure test scope
7. **The Payoff:** validate allowed action succeeds + unauthorized action is denied

**Speaker notes:** "We're about to run the whole pipeline. I'll blend short live steps with pre-captured screenshots for the long-running parts to keep the pace crisp. Watch the footer — we'll walk through every stage."

---

### Slide 29 — Demo Freeze Frame 1: Input → Matrix

**Pre-captured screenshot** of sample log data loading + a glimpse of the matrix output (showing the heatmap-style summary or a table excerpt).

**Live element:** Show the actual `ConvertTo-UserActionMatrix` command running and outputting row/column counts.

**Speaker notes:** "Here's our raw data — [X] principals, [Y] distinct actions, [Z] days of logs. The matrix is [X] by [Y]. Let's see what patterns are hiding in there."

---

### Slide 30 — Demo Freeze Frame 2: Auto-k Decision

**Static plots:** Elbow and silhouette charts (same format as Slide 17) with the recommended k highlighted.

**Live element:** Show the console output: "Recommended k = 5 (silhouette: 0.72, past elbow at k = 3, all clusters ≥ 3 members)."

**Speaker notes:** "The algorithm says 5 roles. Let's look at what it found."

---

### Slide 31 — Demo Freeze Frame 3: Cluster → JSON (+ optional cached AI name)

**Live element:** Show the cluster summary table (similar to Slide 18) for the demo dataset.

**Live element:** Show the generated JSON for one cluster, opened in the editor.

**Optional:** Show the cached AI-suggested role name and description alongside the raw cluster output (the before/after visual described in Slide 24 notes).

**Speaker notes:** "Cluster 1 is clearly our storage readers. The JSON is ready. Now let's deploy it and prove it works."

---

### Slide 32 — Demo Freeze Frame 4: Deploy + Validate (The Payoff)

**Live elements:**

- Run `New-AzRoleDefinition` to deploy the custom role
- Assign to test principal
- Run a **permitted** command → ✅ success
- Run a **disallowed** command → ❌ "not granted" authorization error
- Show evidence metadata (timestamp, role version, git commit hash)

**Speaker notes:** "This is the moment. The test user can do exactly what they need — and nothing more. That 'AuthorizationFailed' error is the sound of least privilege working. This is evidence you can hand to an auditor." Make this slide visually distinct (e.g., green checkmark / red X icons). The demo runbook includes a fallback (guided walkthrough with screenshots) if Azure is unresponsive.

---

### Slide 33 — Lessons Learned and Practical Tips

**Tips from production experience:**

- Start with a **single subscription** and a **read-only pilot role** — don't boil the ocean
- **60–90 day windows** catch monthly edge cases; 30 days is fine for a proof of concept
- **Separate human and workload identity** clustering for cleaner results in larger environments
- Run a **break-glass / exception process** in parallel — not everyone's needs are in the logs yet
- **Version everything in git** — role definitions, auto-k parameters, cluster summaries, validation transcripts

**Speaker notes:** "These are things we wish someone had told us before we started. Each one cost us time to learn. Take them for free."

---

### Slide 34 — Resources + Q&A (big QR)

**Repo includes:**

- Scripts/modules (PS7 + WinPS 5.1 compatible)
- Sample sanitized dataset + schema documentation
- Auto-k utilities + plot generation scripts
- Policy checks + configurable sensitive action list
- Validation scripts + evidence capture templates
- Scaling/performance documentation (including `Group-Object -NoElement`)
- Troubleshooting guide
- Multi-cloud adapter notes (Azure primary, AWS + GCP conceptual + references)

**Call to action:** "Pull 60–90 days of activity logs from a test subscription next week and run the pipeline. See what roles are waiting to be discovered."

**Large QR code + shortened URL prominently displayed.**

**Speaker notes:** Thank the audience. Open for 1–2 final questions. If time is tight, say: "I'll be in the hallway after this session — come find me with questions."

---

## 4) Backup slides (appendix)

Include the following as backup slides for Q&A or deep-dive requests:

- **Glossary:** k-means, centroid, silhouette score, inertia, SSE, elbow method, k-means++, RBAC, deny assignment
- **Suggested defaults table:** Time window (90 days), k-range (2..min(20, N/5)), normalization (relative frequency), min cluster size (3), sensitive action list (starter set)
- **Authorization-failure report:** How to generate and use the "failed operations by principal" review queue
- **Scaling ingestion options:** Log Analytics KQL adapter, Azure Data Explorer export, SIEM integration patterns
- **Troubleshooting clusters:** What to do when clusters don't make sense (check normalization, try different k-ranges, separate humans from workloads, check for seasonal skew)
- **Alternative clustering algorithms:** DBSCAN, hierarchical clustering — when they might be better and why k-means is the recommended default (speed, explainability, works well for this problem shape)
- **Repo structure:** Directory layout and module dependency diagram
- **DataActions deep dive:** When to include data-plane actions in the analysis and how to handle mixed management/data-plane roles
- **Case study template:** Structure for documenting your own before/after metrics (only if defensible metrics exist from client engagements)
- **Deny Assignments vs NotActions:** Clarifying the difference for audience members who conflate them

---

## 5) Run-of-show (minute-by-minute with handoffs)

| Time | Duration | Content | Slides | Notes |
| --- | --- | --- | --- | --- |
| 0:00–1:00 | 1 min | Title + expectations | 1 | Set the tone: practical, demo-heavy |
| 1:00–3:00 | 2 min | Poll + hook | 2, 3 | Get hands up, establish shared pain |
| 3:00–4:00 | 1 min | Why activity logs? | 4 | Bridge from problem to solution |
| 4:00–6:00 | 2 min | Roadmap + takeaways + scope | 5, 6, 7 | Set expectations clearly |
| 6:00–8:00 | 2 min | Data sources + multi-cloud concept | 8 | Keep conceptual, reference repo |
| 8:00–12:00 | 4 min | Ingestion + performance + artifacts | 9, 10, 11 | First code on screen |
| 12:00–16:00 | 4 min | Shaping + matrix + heatmap | 12, 13, 14 | Key analogy: "behavior fingerprints" |
| 16:00–22:00 | 6 min | K-means + auto-k + plots + summaries | 15, 16, 17, 18 | Core technical content |
| 22:00–24:00 | 2 min | Representative members | 19 | Connect to 2023 talk methodology |
| 24:00–28:00 | 4 min | Permissions → JSON + RBAC semantics | 20, 21 | Correctness matters here |
| 28:00–30:00 | 2 min | Approval gate + circuit breakers | 22 | Trust-building slide |
| 30:00–32:00 | 2 min | Optional AI assist | 24 | Keep tight; position as optional |
| 32:00–34:00 | 2 min | Drift/CI/CD/rollback + multi-cloud | 25, 26 | Operational lifecycle |
| 34:00–35:00 | 1 min | Case study | 27 | Brief, impactful |
| 35:00–36:00 | 1 min | Demo roadmap | 28 | Re-orient before demo |
| 36:00–43:00 | 7 min | Demo (freeze frames + live steps) | 29, 30, 31, 32 | **Never cut validation payoff** |
| 43:00–44:00 | 1 min | Lessons learned | 33 | Practitioner tips |
| 44:00–45:00 | 1 min | Big QR + call to action + Q&A | 34 | End strong |

**Time protection rules:**

- If behind by 2+ minutes at the 30:00 mark: compress AI section to 60 seconds (just show cached output), skip case study, reduce multi-cloud to a single sentence referencing the repo.
- If behind by 4+ minutes at the 30:00 mark: additionally compress drift/CI/CD to "it's in the repo" and go straight to demo.
- **Never compress or cut:** the demo validation payoff (Slide 32) or the closing QR/resources slide.

---

## 6) Demo runbook (inputs, steps, fallbacks)

### Must-hit outcomes

- Emit a role JSON from a cluster
- Deploy role to an Azure test scope
- Show an allowed action succeeding
- Show an unauthorized action failing ("not granted")
- Show evidence metadata (timestamp + commit hash)

### Pre-staged inputs

- Sanitized dataset file (JSON or CSV) loaded on the demo machine
- Cached auto-k plots (PNG files, same format as Slides 17/30)
- Cached AI output (JSON file with role name + description) — optional
- Azure test scope pre-created and accessible
- Test principal pre-created with no existing role assignments
- All required PowerShell modules pre-installed and imported

### Demo flow

1. **Load logs** from local file → show row count and date range
2. **Build matrix** → show dimensions (principals × actions)
3. **Auto-k** → display cached plots + console output with recommended k
4. **Inspect cluster** → show summary table + representative members for one cluster
5. **Emit JSON** → open generated file in editor, highlight key fields
6. **Deploy** → run `New-AzRoleDefinition`, show confirmation
7. **Assign** → assign role to test principal
8. **Validate allow** → run a permitted command, show success
9. **Validate deny** → run a disallowed command, show "AuthorizationFailed"
10. **Evidence** → show timestamp + role version

### Fallbacks

- **Azure unreachable during demo:** Switch to a guided walkthrough using pre-captured screenshots for steps 6–10. Narrate: "Here's what this looks like when Azure cooperates." The audience still sees the full flow.
- **AI API fails (if attempting live call):** Show cached output file and say: "This is what the API returned when we ran it earlier."
- **Clustering takes too long:** Use cached auto-k report and cluster summaries. Say: "On a full dataset this takes [X] seconds; let me show you the pre-computed result."
- **Module import fails:** Have a backup terminal session with everything pre-imported.

---

## 7) Repo checklist (so attendees can reproduce)

### README

- Quickstart guide with 5-command demo
- Prerequisites (PowerShell version, Azure modules, optional Python for plots)
- Architecture diagram matching the pipeline spine

### Sample data

- Sanitized dataset (JSON + CSV formats)
- Schema documentation
- Data dictionary for action names

### Modular scripts

- `Invoke-LogIngestion` — `Get-AzLog` path + scale adapter notes
- `ConvertTo-UserActionMatrix` — transform/matrix with normalization options
- `Find-OptimalClusters` — auto-k algorithm (records seed + settings + scores)
- `Invoke-KMeansClustering` — k-means with k-means++ initialization
- `Get-ClusterRepresentatives` — centroid distance analysis
- `Export-RoleDefinition` — emit role JSON with all four permission fields
- `Test-SensitiveActions` — policy checks against configurable sensitive action list
- `Test-RoleAssignment` — validation + evidence capture
- `Invoke-AIRoleNaming` — optional AI integration (with offline/cached mode)

### Documentation

- Scaling and performance guide (including `Group-Object -NoElement` pattern)
- Tuning defaults reference
- Troubleshooting guide
- Multi-cloud adapter notes (Azure primary, AWS + GCP conceptual with references)
- Sensitive action list starter configuration
- Approval workflow template (PR template + security review checklist)
