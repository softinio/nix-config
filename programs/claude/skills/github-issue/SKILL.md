---
name: github-issue
description: >
  Use when the user wants to start work on a GitHub issue, set up a
  worktree and development environment, plan the implementation,
  write tests, and create a PR. Triggers: "start issue", "work on #123",
  "pick up issue 123", "new issue", or /github-issue [ISSUE].
argument-hint: "[ISSUE-NUMBER|ISSUE-URL]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - TaskCreate
  - TaskUpdate
  - mcp__metals__format-file
  - mcp__metals__compile-file
  - mcp__metals__compile-full
  - mcp__metals__test
---

# GitHub Issue Workflow

Full lifecycle skill for working on a GitHub issue: scaffolding, planning, implementation, PR creation, and teardown.

The issue tracker is GitHub itself, driven entirely through the `gh` CLI — there is no separate tracker to keep in sync. Everything the workflow records (plans, decisions, completion notes) goes on the issue or the PR.

---

## Phase 0 — Issue & Worktree Setup

> **Phase 0 is mandatory and sequential. Execute Steps 1 → 6 in order, and finish all of them before any Phase 1 exploration or planning.**
>
> - At the start of Phase 0, create one task per step (Steps 1, 1.5, 2, 3, 4, 5, 6) with `TaskCreate`, and flip each to `in_progress` then `completed` as you go. A skipped step must be visibly impossible.
> - **Never silently skip a step.** If a step genuinely does not apply, name the step and state why before continuing (e.g. "Step 5: no env setup needed, this repo has no flake").
> - The user supplying context up front — base branch, approach, constraints — feeds **Step 1.5**. It does **not** authorize jumping ahead to planning; you still run Steps 2 → 6.
> - **Step 6 is easy to skip.** Run `herdr-workspace-layout open` before leaving Phase 0. It is a no-op outside herdr, so there is no condition to evaluate first.

### Step 1: Resolve the issue

If `$ARGUMENTS` contains an issue number (`123`, `#123`) or an issue URL:

```bash
gh issue view {number} --json number,title,body,state,labels,assignees,url
```

- For a URL from another repo, pass `--repo {owner}/{repo}` and carry that `--repo` through every later `gh` call.
- Display the issue title and state, and confirm with the user before proceeding.
- If the issue is already closed, say so and ask whether to continue.

If no argument is provided:

- Ask the user for a title and brief description.
- Confirm the target repo (`gh repo view --json nameWithOwner` for the current one).
- Create it, assigned to the user:
  ```bash
  gh issue create --title "{title}" --body "{description}" --assignee @me
  ```
- Confirm the new issue number and URL before continuing.

If the issue is unassigned and the user is picking it up, offer to run `gh issue edit {number} --add-assignee @me`.

### Step 1.5: Gather additional context

After displaying the issue title and description, ask the user:

> "Any additional context before I proceed? For example: a linked discussion, a specific approach you have in mind, constraints, related issues, or anything else that isn't captured in the GitHub issue. Press enter to skip."

If the user provides context:

- Acknowledge it briefly and incorporate it into the planning phase
- Do not proceed until the user has responded (even if they just press enter)

If the user skips (presses enter with no input), continue to Step 2.

Also skim what the issue already links: `gh issue view {number} --comments` for discussion, and any `Closes #N` / cross-references that show related work.

### Step 2: Check for related in-progress worktrees

Before creating a new worktree, scan for existing ones that might overlap with or be a prerequisite for this issue.

```bash
git worktree list          # git repos
jj workspace list          # jj repos (colocated repos answer to both)
```

For each worktree returned (excluding the main working tree):

1. Note its branch name and path.
2. Cross-reference against the issue's title and body: look for shared domain keywords (module names, endpoint paths, config keys, file paths).
3. If a related worktree is found, summarise its pending changes — `git log --oneline origin/main..{branch}` in that worktree, or `jj log -r 'main..@'` in a jj repo.

If any related worktrees are found, report them to the user:

> "Found in-progress worktree(s) that may be related to this issue:
> - `{branch-name}` at `.claude/worktrees/{name}` — {one-line summary of what's in progress}
>
> Does this work depend on, conflict with, or build on top of that branch? Options:
> (a) Branch from `{related-branch}` instead of `origin/main`
> (b) Note the dependency but still branch from `main`
> (c) The overlap is coincidental — proceed normally"

Act on the user's choice:

- **(a)** In Step 4, use the related branch as the base instead of `origin/main`. Post a comment on the issue flagging the dependency.
- **(b)** Branch from `main` as normal. Post a comment on the issue naming the dependency and the expected merge order.
- **(c)** Proceed without any changes.

If no related worktrees exist, continue silently.

### Step 3: Derive the branch name

Format: `{prefix}/{issue-number}-{kebab-slug}`

- `{prefix}` is the user's push-bookmark prefix (`jj config get git.push-bookmark-prefix`, falling back to the GitHub login from `gh api user --jq .login`).
- Slugify the issue title: lowercase, spaces to hyphens, strip special characters, max ~40 chars.
- Example: issue #123 "Fix connection timeout on cold start" → `salar/123-fix-connection-timeout-on-cold`

The worktree directory takes the same name minus the prefix: `.claude/worktrees/{issue-number}-{kebab-slug}`. Both halves matter — `herdr-workspace-layout` names the workspace from the branch's last segment, and falls back to the worktree directory name when HEAD is detached (which is the normal state in a jj-colocated repo). Keeping the two aligned means the workspace is called `123-fix-connection-timeout-on-cold` either way.

### Step 4: Create the worktree from main

Run from the repository root. **jj repo** (`.jj` directory present):

```bash
jj git fetch
jj workspace add --name {issue-number}-{slug} .claude/worktrees/{issue-number}-{slug} -r 'trunk()'
jj bookmark create {prefix}/{issue-number}-{slug} -r @
```

**git repo** (no `.jj`):

```bash
git fetch origin
git worktree add .claude/worktrees/{issue-number}-{slug} -b {prefix}/{issue-number}-{slug} origin/main
```

Confirm the repo's default branch first rather than assuming `main` — `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`.

### Step 5: Development environment

Nothing sets the worktree up automatically — do it here.

1. If the repo root has a `flake.nix` and the worktree has no `.envrc`, write `use flake` to `.envrc` in the worktree and run `direnv allow` there. nvim and the build tool in Step 6 then come up inside the flake dev shell without a manual `nix develop`.
2. If the repo root has a gitignored local env file (check `.gitignore` for `*.env`-style entries and look for what actually exists), ask whether to copy it into the worktree — these are per-checkout and do not come across with the branch.
3. Ask the user:

   > "Any env vars to override for this worktree? Enter as `KEY=VALUE` pairs, one per line, or press enter to skip."

   Write any overrides to a gitignored file in the worktree root and source it from `.envrc` (after `use flake`, so it wins). Confirm the filename is covered by `.gitignore` before writing — if it is not, use `.envrc.local` and add it.

### Step 6: Open the herdr workspace

```bash
WORKTREE_PATH=$(git rev-parse --show-toplevel)/.claude/worktrees/{issue-number}-{slug}
herdr-workspace-layout open "$WORKTREE_PATH"
```

That one command renames the workspace and tab after the worktree's branch, opens the reviewr review sidebar full height beside Claude, and adds a second `build` tab running nvim and the project's build tool in the worktree:

```
TAB 1 "{name}"                      TAB 2 "build"
+-------------+-------------+       +-------------+-------------+
| Claude      | reviewr     |       | nvim        | build       |
+-------------+-------------+       +-------------+-------------+
```

- Outside herdr the command prints a message and exits 0, so it is always safe to run — there is no `HERDR_WORKSPACE_ID` check to make first.
- The name is derived automatically. Pass an explicit second argument only when the derived name would be useless — e.g. `herdr-workspace-layout open "$WORKTREE_PATH" "123-cold-start"`.
- There are no pane ids to remember. Teardown finds the panes itself.
- The `build` pane detects the build tool from the worktree: `sbt --client` for an sbt project, `mill -w __.compile` for a mill one, and a plain shell for anything else. Export `HERDR_BUILD_CMD` before the `open` call to override it — do that for a repo whose real build is something else (`nix build`, `just watch`).
- reviewr keys worth knowing when handing work back: `t` scopes the diff to what the agent changed in its last turn, `b` to the whole branch, `u` to uncommitted; `c` comments on a line and `s` sends every comment into Claude's input at once.

---

## Phase 1 — Planning (no code yet)

**Do not write any production code in this phase.** Use plan mode: explore first, present a complete plan, wait for explicit approval.

### Exploration

Search the codebase for context related to the issue:

- Existing types, modules, routes, and tests in the relevant domain
- The seams the change plugs into, and how comparable features were added before
- Existing test patterns for the area being changed
- If the issue references a stack trace, error message, or failing behavior, locate the exact code path before planning a fix

### Plan content

Draft a complete implementation plan covering:

- Files to create or modify (full paths)
- New types, functions, or endpoints to add
- Test strategy: which unit tests, which integration tests, and how to run them
- Migrations, config, or infrastructure changes, called out explicitly
- Risk areas and edge cases
- What "done" means in terms the issue can be checked against

Present the full plan to the user. **Wait for explicit approval before writing any code.**

### On approval: offer to post the plan to the issue

Do **not** post anything automatically. Ask the user:

> "Would you like me to post this plan as a comment on issue #{number}? (y/n)"

**Only if the user explicitly approves:**

```bash
gh issue comment {number} --body-file {plan-file}
```

Write the plan to a scratch file first rather than inlining a long heredoc. Include Mermaid diagrams where they earn their place — GitHub renders them in comments:

- Sequence diagram for new request flows
- ERD for schema changes
- Component diagram for new services

If a plan comment from a previous run already exists, edit it in place (`gh issue comment --edit-last`) instead of stacking a second one.

If the user declines, skip the comment entirely and continue to implementation.

---

## Phase 2 — Implementation

All edits happen inside `.claude/worktrees/{issue-number}-{slug}`. Do not modify files in the main working tree during this phase.

### Verify after every edit

Match the repo's own tooling — check `flake.nix`, `justfile`, `Makefile`, and the CI workflow for the canonical commands rather than guessing.

**Scala.** Per-edit verification goes through metals and is the same either way — metals drives whichever build tool the workspace already imported:

1. `mcp__metals__format-file` — format the changed file
2. `mcp__metals__compile-file` (or `mcp__metals__compile-full`) — verify compilation
3. `mcp__metals__test` — run tests in the affected module

The project-wide commands differ by build tool, so detect it before running anything — the marker files are unambiguous, and a repo may carry both (check for a `mill` wrapper script first, then `build.sbt`):

- **sbt** — `build.sbt`, or a `project/` directory with `build.properties`:
  ```bash
  sbt --client scalafmtCheckAll     # must pass cleanly before any commit
  sbt --client compile
  sbt --client test
  ```
- **mill** — `build.mill` (or the older `build.sc`), `.mill-version`, or a `./mill` wrapper script. Use the wrapper when the repo ships one, otherwise plain `mill` from the flake dev shell:
  ```bash
  ./mill __.compile
  ./mill __.checkFormat              # scalafmt; must pass cleanly before any commit
  ./mill __.fix --check              # scalafix, only if .scalafix.conf exists
  ./mill __.test
  ```
  Notes that save a round trip:
  - `__` is the recursive wildcard over all modules. For a **cross-built** module, target a specific version instead — `mill "{module}[{scala-version}].test"` — since `__` runs every cross instance.
  - `__.checkFormat` / `__.reformat` are the current per-module scalafmt tasks. Older builds call the external module instead: `mill mill.scalalib.scalafmt.ScalafmtModule/checkFormatAll __.sources`. If one form does not resolve, try the other before concluding the build is broken.
  - CI adds `--no-server` for a clean one-shot run. Leave it off interactively — the background server is what makes repeat runs fast.
  - If `mill` is not on `PATH`, the dev shell is not loaded: run `direnv allow`, or prefix with `nix develop --command`.

Whichever tool is in play: the format check passes cleanly before any commit, and all compiler warnings are resolved — unused imports, dead code, deprecations.

**Nix:** `nix flake check`, and `nix build .#{attr}` for the affected output. Format with `nixfmt` (or whatever the repo's formatter attribute is). For this config repo specifically, `darwin-rebuild build --flake .#{hostname}` before switching.

**Any other language:** establish the repo's four canonical commands — **format, lint/typecheck, build, test** — once at the start of this phase and state them to the user. The CI workflow is the most reliable source, since it is what actually has to pass; the lockfile settles which package manager to use. If a command cannot be determined, ask rather than inventing one. Then run them after each edit: format the changed file, compile or typecheck it, run the tests covering it. Where an LSP or build MCP server is connected for that language, prefer its format/compile/test tools over shelling out — they are faster and scoped to the file.

### Test requirements (non-negotiable)

- Every new function or method gets a unit test in the corresponding test file
- Every new endpoint, workflow, or service gets an integration test
- Follow the existing test file's conventions — framework, naming, assertion style
- A bug-fix issue gets a regression test that fails against the old code

### Keeping the issue current

After significant implementation decisions or deviations from the approved plan, offer to post a short update comment on the issue. Do not narrate routine progress there — only decisions a reader of the issue would need to understand the eventual PR.

---

## Phase 3 — PR Creation

After the user confirms the implementation is ready and all tests pass:

```bash
gh pr create \
  --draft \
  --title "{Issue title}" \
  --body "$(cat <<'EOF'
## Summary

- {bullet points describing what changed — no checkboxes}

Closes #{number}

## Test plan

- {bullet points describing what was tested and how}
EOF
)"
```

- `Closes #{number}` in the body is what links the PR to the issue and closes it on merge — do not omit it. Use `Refs #{number}` instead when the PR only partially addresses the issue.
- Use plain bullet points throughout — no markdown checkboxes
- Share the resulting PR URL with the user
- To review the PR yourself with inline comments, `tuicr pr {NUM}` in the worktree — `c` to comment, `:submit` to post them to GitHub as a real review

---

## Phase 4 — Teardown

When the user signals the work is complete or wants to clean up:

1. **Remove any worktree-local env files** written in Step 5:
   ```bash
   rm -f .claude/worktrees/{issue-number}-{slug}/.envrc.local
   ```

2. **Remove the worktree:**
   ```bash
   jj workspace forget {issue-number}-{slug}          # jj repo
   rm -rf .claude/worktrees/{issue-number}-{slug}

   git worktree remove .claude/worktrees/{issue-number}-{slug}   # git repo
   ```

3. **Branch cleanup** — ask the user: "Delete branch `{branch-name}` locally and remotely?"
   - If yes (git):
     ```bash
     git branch -d {branch-name}
     git push origin --delete {branch-name}
     ```
   - If yes (jj):
     ```bash
     jj bookmark delete {branch-name}
     jj git push --deleted
     ```

4. **Close the tool panes** (if a workspace was opened in Phase 0 Step 6). Claude's own pane stays open — do not close it.

   ```bash
   herdr-workspace-layout close
   ```

5. **Issue status** — if the PR merged, the `Closes #{number}` line already closed the issue; confirm with `gh issue view {number} --json state`. If the work was abandoned or the issue is still open, ask the user whether to comment or close it, and never close it without confirmation.

---

## Hard Rules

These apply throughout all phases with no exceptions:

- **Never skip a Phase 0 step.** Complete Steps 1 → 6 in order before any Phase 1 exploration. A step may only be passed over by explicitly naming it and the reason it does not apply — never silently. User-supplied context up front is not a license to jump ahead.
- **Use jj when the repo has a `.jj` directory**, git otherwise. Check before running any VCS command.
- **Never commit** without explicit user confirmation — this applies even in automode; pause and wait for the user to say "commit" or "continue" before staging or committing anything
- **Never push** without explicit user confirmation
- **Never use `--no-verify`** or bypass pre-commit hooks for any reason
- **Never close or reopen an issue** without explicit user confirmation
- **Fix all linting and formatting issues** before any commit — zero warnings, zero unformatted files
- **Always add tests** for every feature addition or behavioral change
- **No emojis** in code, commit messages, PR descriptions, or issue comments
