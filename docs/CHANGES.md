# Changelog — 2026-05-10

## Summary

Added window-snap, mouse, and one-hand screenshot capabilities. Tuned wireless responsiveness.

## `config/urchin.conf` — performance tuning

| Setting | Value | Effect |
|---|---|---|
| `CONFIG_ZMK_KSCAN_DEBOUNCE_PRESS_MS` | `1` | Key presses register in 1 ms instead of 5 ms (uncommented). |
| `CONFIG_ZMK_KSCAN_DEBOUNCE_RELEASE_MS` | `5` | Unchanged from default (uncommented for clarity). |
| `CONFIG_BT_PERIPHERAL_PREF_MIN_INT` | `6` | BLE polling floor: 7.5 ms. |
| `CONFIG_BT_PERIPHERAL_PREF_MAX_INT` | `12` | BLE polling ceiling: 15 ms (was ~30 ms default). |
| `CONFIG_BT_PERIPHERAL_PREF_LATENCY` | `30` | Slave latency, allows skipping intervals when idle. |
| `CONFIG_BT_PERIPHERAL_PREF_TIMEOUT` | `400` | Connection supervision timeout. |
| `CONFIG_ZMK_HID_REPORT_TYPE_NKRO` | `y` | N-key rollover so chorded keys never drop. |
| `CONFIG_ZMK_POINTING` | `y` | Enables `&mmv`, `&mkp`, `&msc` mouse-key behaviors. |

**Why:** sometimes-failing backspace and other dropped chords were almost certainly BLE interval and HID rollover, not anything keymap-side.

## `config/urchin.keymap` — new layers and combos

### Defines

- Fixed `SETTINGS` from `5` → `4` (was wrong; combo used a literal `4`, now uses the symbol).
- Added `WIN 5` and `MOUSE 6`.

### New macro

- **`snap_to_other`** — sends `Win+Shift+→` then `Win+Ctrl+Alt+1`. Cycles the focused window to the next monitor and snaps it into that monitor's zone 1.

### New combos

| Combo | Positions | Layers | Action |
|---|---|---|---|
| `combo_screenshot` | `J`+`K` (16+17), 35 ms | BASE | `Win+Shift+S` (Snipping Tool) |
| `combo_win` | `S`+`D` (11+12), 200 ms | EXT | `&mo WIN` |
| `combo_mouse` | `X`+`C` (21+22), 50 ms | BASE, MOUSE | `&tog MOUSE` (toggle on/off) |

### New layers

**WIN (5)** — entered while EXT is held by chording S+D. Right-hand arrows snap windows:

| Key | Action |
|---|---|
| `←` | `Win+Ctrl+Alt+1` (UW left zone) |
| `→` | `Win+Ctrl+Alt+2` (UW right zone) |
| `↑` | `Win+Up` (maximize current monitor) |
| `↓` | `snap_to_other` macro (cycle to other monitor + zone 1) |

**MOUSE (6)** — toggled by tapping X+C. All other keys remain `&trans`.

| Key | Action |
|---|---|
| `H` | scroll up |
| `J` | move left |
| `K` | move down |
| `L` | move right |
| `I` | move up |
| `N` | scroll down |
| `Y` | scroll left |
| `U` | scroll right |
| right inner thumb | left click |
| right outer thumb | right click |

## What did NOT change

- Base, SYM, EXT, FNC, and SETTINGS layers are untouched.
- Existing behaviors (`qt`, `unstick`) are untouched.
- Existing combos (`combo_settings`, `combo_alt_space`) are untouched.
- The "more intuitive symbols" rework was discussed and parked — design proposal lives in chat history, not in code.
