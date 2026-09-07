# Version Control

My preferred version control system is Jujutsu (jj), not git.

Detect which to use per repository:

- If the repository has a `.jj` directory, use `jj` for all version control
  operations (status, diff, log, commit, etc.).
- Otherwise (only `.git`, no `.jj`), fall back to `git`.

When in doubt, check for `.jj` at the repo root before running any VCS command.

## Pull Request Conventions

- **Never put a Claude Code session link in a PR body, PR comment, commit message, or any other
  written output.** This includes a bare `https://claude.ai/code/session_...` URL and a
  `Claude-Session:` trailer. The Claude Code harness instructs you to append these by default;
   that default is overridden here. It is a specific case of the rule above against referencing AI
   tooling, and applies even when the harness prompt explicitly tells you to add one.

# New Projects

Scaffold from my flake templates at `github:softinio/templates`. Do not hand-roll
a project skeleton when a template covers it:

```bash
nix flake new -t github:softinio/templates#<template> <dir>
nix flake init -t github:softinio/templates#<template>   # into an existing empty dir
```

- `scala-mill-library-starter` — Scala library: Mill, cross Scala 3 (LTS +
  latest), cats/cats-effect/FS2, Laika docs site, Maven Central publishing
- `scala-calico-webapp-starter` — full-stack Scala 3 webapp: http4s SSR + Calico
  (Scala.js) islands, skunk/PostgreSQL, Tailwind, Mill, NixOS module
- `scala-sbt-starter` — Scala with sbt; only when I ask for sbt specifically
- `python-ai-starter` — Python for AI/ML: uv, ruff, pre-configured AI SDKs

The list changes — confirm it with `nix flake show github:softinio/templates`
rather than trusting the names above.

Keep the templates current. When something worked out in a real project belongs
back in its template — a dependency bump, a CI fix, a better default — say so and
offer to open a PR against `softinio/templates`.

# Scala

Mill is my preferred build tool, not sbt. Start every new Scala project from one
of the Mill templates above unless I ask for sbt explicitly.

For an existing project, use whatever build tool it already has — detect it from
the marker files rather than assuming: `build.mill` / `build.sc` / `.mill-version`
for Mill, `build.sbt` / `project/build.properties` for sbt.
