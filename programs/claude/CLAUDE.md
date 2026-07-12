# Version Control

My preferred version control system is Jujutsu (jj), not git.

Detect which to use per repository:

- If the repository has a `.jj` directory, use `jj` for all version control
  operations (status, diff, log, commit, etc.).
- Otherwise (only `.git`, no `.jj`), fall back to `git`.

When in doubt, check for `.jj` at the repo root before running any VCS command.
