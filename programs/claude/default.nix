{
  pkgs,
  ...
}:

let
  # Define the settings as a Nix attribute set
  settings = {
    attribution = {
      commit = "";
      pr = "";
    };

    permissions = {
      allow = [
        "mcp__claude_ai_Atlassian__search"
        "mcp__claude_ai_Atlassian__getConfluencePage"
        "mcp__claude_ai_Linear__get_issue"
        "Bash(bloop compile:*)"
        "Bash(bloop test:*)"
        "Bash(cat:*)"
        "Bash(curl:*)"
        "Bash(find:*)"
        "Bash(gh pr view:*)"
        "Bash(gh api:*)"
        "Bash(gh pr diff:*)"
        "Bash(grep:*)"
        "Bash(mill:*)"
        "Bash(poetry:*)"
        "Bash(python3:*)"
        "Bash(sbt:*)"
        "Bash(uv:*)"
        "Bash(xargs cat:*)"
        "WebFetch(domain:docs.dagster.io)"
        "WebFetch(domain:github.com)"
        "WebFetch(domain:raw.githubusercontent.com)"
        "WebFetch(domain:twitter.github.io)"
        "WebFetch(domain:developer.zendesk.com)"
        "WebFetch(domain:www.useanvil.com)"
      ];
      deny = [ ];
      ask = [ ];
    };

    model = "sonnet";

    enabledMcpjsonServers = [
      "metals"
    ];

    alwaysThinkingEnabled = true;

    enabledPlugins = {
      "swift-lsp@claude-plugins-official" = true;
    };
  };

  # Generate formatted JSON using jq
  formattedSettings =
    pkgs.runCommand "claude-settings.json"
      {
        buildInputs = [ pkgs.jq ];
        json = builtins.toJSON settings;
      }
      ''
        echo "$json" | jq '.' > $out
      '';
  claudeMd = ''
    # User Preferences

    ## Tech Stack

    - **Scala 2.13** — primary backend language
    - **sbt** — build tool and fallback for builds/tests (use `sbt --client`, not Maven or Mill)
    - **Metals MCP** — preferred tool for Scala compile, format, and test operations (see Scala Tools below)
    - **PostgreSQL** — database
    - **Temporal** — workflow orchestration
    - **TypeScript** — frontend
    - **pnpm** — frontend package management (not npm or yarn)

    ## Communication Style

    - Balanced: brief explanations where helpful, code-first
    - No emojis in responses or code

    ## Workflow Rules

    - **Never commit** without explicit confirmation from the user
    - **Never push** to a remote without explicit confirmation from the user
    - Never mention that code or content was written by or generated with AI tools

    ## Project Locations

    - `~/Projects/` — main projects
    - `~/Projects_2/` — additional projects
    - `~/Projects_3/` — additional projects
    - `~/Learn/` — learning projects

    ## Documentation & Knowledge Base

    - `~/Projects/MyAI/` is the personal knowledge base for all work: planning, discovery, design notes, and troubleshooting
    - When helping with any task, save useful reference material, decisions, findings, or summaries as markdown files in the appropriate subdirectory of `~/Projects/MyAI/`
    - Structure within `~/Projects/MyAI/`: `projects/` for project-specific docs, `discovery/` for research and exploration

    ## GitHub

    - Use `gh` CLI for all GitHub interactions (PRs, issues, checks, releases, etc.)
    - Never use the GitHub web UI when `gh` can accomplish the same thing

    ## Git Conventions

    - **Branch naming**: When a Linear story ID is available, prefix the branch with the ID (no dash) followed by `/` then a descriptive name
      - Format: `{PROJECTID}{NUM}/{descriptive-name}`
      - Example: story `ANN-10` → branch `ANN10/create-claude-file`
    - **PR titles**: Prefix with the full Linear story ID (with dash) followed by ` - ` and a descriptive title
      - Format: `{PROJECT-ID} - Descriptive Title`
      - Example: `ANN-10 - Create Claude File`

    ## Work Management & Documentation

    - **Linear** — used for work management (tickets, stories, etc.); MCP server is configured and available as a tool
    - **Atlassian Confluence** — used for company-wide documentation; MCP server is configured and available as a tool
    - Use the Linear and Confluence MCP tools directly rather than asking the user to look things up manually

    ## Local Environment

    - **Nix** — used to manage local packages as much as possible
    - **Nix flakes** — used for per-project development environments
    - Nix config lives at `~/.config/nixpkgs`

    ## Scala Testing

    - When writing ScalaTest tests, always use the **FunSuite** style (Twitter's recommended ScalaTest style, as outlined in the [Finatra testing guide](https://twitter.github.io/finatra/user-guide/testing/index.html#scalatest))
    - Test classes extend `FunSuite` (or Finatra's test traits built on it) rather than `FlatSpec`, `WordSpec`, or other styles
    - Tests are defined with `test("description") { ... }` blocks

    ## Scala Tools

    Use the Metals MCP server tools whenever possible. Fall back to `sbt --client` only when the MCP tool is unavailable or insufficient.

    | Task | Preferred (MCP) | Fallback (sbt) |
    |---|---|---|
    | Compile a file | `mcp__metals__compile-file` | `sbt --client compile` |
    | Compile full project | `mcp__metals__compile-full` | `sbt --client compile` |
    | Compile a module | `mcp__metals__compile-module` | `sbt --client compile` |
    | Format a file | `mcp__metals__format-file` | `sbt --client scalafmt` |
    | Run tests | `mcp__metals__test` | `sbt --client test` |
    | Find usages | `mcp__metals__get-usages` | — |
    | Get docs | `mcp__metals__get-docs` | — |
    | Search by type | `mcp__metals__typed-glob-search` | — |
    | List modules | `mcp__metals__list-modules` | — |
    | Import build | `mcp__metals__import-build` | — |

    After finishing changes to a Scala file:
    1. Format using `mcp__metals__format-file`
    2. Compile using `mcp__metals__compile-file` or `mcp__metals__compile-full` to verify correctness
    3. Run tests using `mcp__metals__test`

    ## Pull Request Conventions

    - In PR test plans, use plain bullet points (not checkboxes)

    ## Coding Best Practices

    - **Never compare with strings** when an enum or custom type can be used instead — define one
    - **Scala algebraic data types**: use `case class` for product types and `sealed trait` for sum types
    - **Type-driven, functional programming**: model the domain with types, prefer pure functions, immutable data, and type-safe abstractions over runtime checks

    ## General Guidelines

    - Prefer editing existing files over creating new ones
    - Keep solutions simple and focused — avoid over-engineering
    - Use `pnpm` for all frontend package management
  '';
in
{
  # Manage Claude Code settings file
  home.file.".claude/settings.json".source = formattedSettings;

  # Manage Claude Code global instructions file
  home.file.".claude/CLAUDE.md".text = claudeMd;
}
