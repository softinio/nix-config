# Tmux Cheatsheet

## Prefix Key
**Prefix:** `Ctrl-a`

All commands below require pressing the prefix first, unless otherwise noted.

## Copy Mode (Vi-style)

| Key | Action |
|-----|--------|
| `Esc` or `Ctrl-[` | Enter copy mode |
| `v` | Begin selection (in copy mode) |
| `y` or `Enter` | Copy selection to macOS clipboard |
| `p` | Paste from tmux buffer |

## Pane Management

### Creating Panes

| Key | Action |
|-----|--------|
| `'` | Split pane horizontally (side by side) |
| `-` | Split pane vertically (top/bottom) |

### Navigating Panes

| Key | Action |
|-----|--------|
| `h` | Move to left pane |
| `j` | Move to down pane |
| `k` | Move to up pane |
| `l` | Move to right pane |
| `Ctrl-j` | Cycle to next pane |

### Resizing Panes

| Key | Action |
|-----|--------|
| `H` | Resize pane left (10 units) |
| `J` | Resize pane down (10 units) |
| `K` | Resize pane up (10 units) |
| `L` | Resize pane right (10 units) |

## Window Management

| Key | Action |
|-----|--------|
| `Ctrl-h` | Previous window |
| `Ctrl-l` | Next window |

## Session Management (TMS Integration)

| Key | Action |
|-----|--------|
| `(` | Previous session (with refresh) |
| `)` | Next session (with refresh) |
| `Ctrl-o` | Open TMS popup for session switching |

## Configuration Details

- **Base Index:** Windows and panes start at 1 (not 0)
- **Escape Time:** 10ms (for vim responsiveness)
- **History Limit:** 10,000 lines
- **Key Mode:** Vi
- **Terminal:** xterm-256color
- **Mouse:** Disabled
- **Repeat Time:** 1000ms for repeatable commands
- **Auto-renumber:** Windows are renumbered when one is closed
- **Activity Monitoring:** Visual alerts when window has activity

## Plugins

- **sensible:** Sensible default settings
- **tokyo-night-tmux:** Tokyo Night theme with transparency
- **yank:** Better clipboard integration
- **resurrect:** Save/restore tmux sessions
- **continuum:** Auto-save sessions every 60 minutes
