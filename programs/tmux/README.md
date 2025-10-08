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

### Navigating Panes (Dvorak-optimized)

| Key | Action |
|-----|--------|
| `d` | Move to left pane |
| `h` | Move to down pane |
| `t` | Move to up pane |
| `n` | Move to right pane |
| `Ctrl-h` | Cycle to next pane |

### Resizing Panes

| Key | Action |
|-----|--------|
| `Ctrl-Left` | Resize pane left (10 units) |
| `Ctrl-Down` | Resize pane down (10 units) |
| `Ctrl-Up` | Resize pane up (10 units) |
| `Ctrl-Right` | Resize pane right (10 units) |

## Window Management

| Key | Action |
|-----|--------|
| `Ctrl-d` | Previous window |
| `Ctrl-n` | Next window |

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
