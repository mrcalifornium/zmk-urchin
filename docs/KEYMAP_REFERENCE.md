# Urchin keymap — quick reference

> Print at A4. Each layer is one block. Position numbering is left-to-right,
> top-to-bottom, 0–33. Thumbs are 30 (LO), 31 (LI), 32 (RI), 33 (RO).
> "LO" = left outer thumb, "RI" = right inner thumb, etc.

---

## How to enter each layer

| Layer | How to activate | Style |
|---|---|---|
| **BASE** (0) | default | always-on |
| **SYM** (1) | tap right-outer thumb (RO) | sticky — applies to next key |
| **EXT** (2) | hold left-outer thumb (LO) | momentary — released on let-go |
| **FNC** (3) | hold both outer thumbs (LO + RO) — i.e. EXT + RO | nested momentary |
| **SETTINGS** (4) | hold both left thumbs (LO + LI) | combo |
| **MOUSE** (5) | tap `X+C` from BASE | toggle on/off |

---

## BASE — alphas + thumbs

```
 Q   W   E   R   T   │   Y   U   I   O   P
 A   S   D   F   G   │   H   J   K   L   ;
 Z   X   C   V   B   │   N   M   ,   .   /
        EXT  ⇧/SPC   │   SPC  SYM↗
              (qt LSHIFT/SPACE)         (sl 1)
```

Combos active here:
- **D+F** → `Alt+Space`
- **J+K** → `Win+Shift+S` (Snipping Tool screenshot)
- **X+C** → toggle MOUSE layer
- **F+J** → sticky Meh (`Ctrl+Alt+Shift`); next letter is caught by AHK to launch / focus an app or snap the active window

---

## SYM — symbols + numbers (Miryoku-style)

```
 ~   <   >   "   '   │   |   +   [   ]   =
 1   2   3   4   5   │   6   7   8   9   0
 `   ^   &   *   \   │   /   -   (   )   _
        FNC LSHIFT   │   _   _
```

Right-hand columns: `[ 8 (` and `] 9 )` line up so opens-on-top, closes-on-bottom. Index = math (`+ 7 -`), pinky = `= 0 _`.

`! @ # $ %` and `^ & * ( )` accessible via shift+number on this layer (left thumb is LSHIFT). `{ }` via shift+`[`/`]`. `?` via shift+`/`.

---

## EXT — modifiers, arrows, clipboard

```
 ESC  ⏮   ⏯   ⏭   ⏸   │   PgUp  Home  ↑    End   Caps
 sLA  sLG sLS  sLC  HYP │   PgDn  ←     ↓    →     Del
 ^Z   ^X  ^C  Tab  ^V   │   ^BSP  BSP  ⊞SPC  _    _
        _    LCTRL      │   ENT   FNC↗
```

`s*` = sticky modifier (`&sk`). HYP = `Hyper` = LA+LC+LG+LS, useful for unique app shortcuts.

Combos active here:

---

## FNC — function row + sticky mods

```
 F1   F2  F3  F4  F5  │   F6  F7  F8  F9  F10
 sLA  sLG sLS sLC RAlt│   F11 F12 PrtSc  _   _
 _    _   _   _   _   │   _   _   _      _   _
 _    _                │   _   _
```

Reach: hold LO + RO simultaneously.

---

## SETTINGS — bluetooth, reset, recovery

```
 BOOT _   _   BTclr BT0 │ BT3  _   unstick _    BOOT
 _    _   _   _     BT1 │ BT4  _   _       _    _
 _    _   _   _     BT2 │ BT5  _   _       _    _
        _    _          │ _    _
```

Reach: both left thumbs at once.

---

## Window snap (host-side via AHK)

Window snapping is no longer a ZMK layer — it's a set of Meh+letter chords routed by the `urchin-apps.ahk` script. The Meh combo (F+J) arms `Ctrl+Alt+Shift`, then the next letter fires a pixel-perfect `WinMove`. Robust to resolution / scaling changes, no FancyZones dependency.

| Chord | Action |
|---|---|
App letters: `B` Edge personal, `C` Claude, `E` Edge work, `F` Explorer, `M` Outlook, `N` OneNote, `P` PowerPoint, `R` Calculator, `S` Excel, `T` Teams, `W` Word.

Audio output: `H` Jabra headset, `D` SMSL DAC.

Volume (left pinky column): `Q` up, `A` down, `Z` mute.

Window snap letters — `U I O` top row, `J K L` home row on the right hand:

| `Meh+I` | UW maximize |
| `Meh+U` | top-center box on UW — 1/3 width × 1/2 height, anchored to top |
| `Meh+O` | bottom-center 1920×1080 (Teams share-friendly) on UW |
| `Meh+J` | UW left half |
| `Meh+K` | ThinkVision (move + maximize) |
| `Meh+L` | UW right half |

Other: `Meh+X` closes the active window (Alt+F4).

Usage: tap **F+J**, then a letter.

---

## MOUSE — pointer + scroll + clicks

```
 _   _   _   _   _   │   ▲↻   _   ↑    _   _
 _   _   _   _   _   │   ▼↻   ←   ↓    →   _
 _   _   _   _   _   │   ↺↻   ↻↺  _    _   _
        _    _       │   LCK  RCK
```

Where:
- `↑↓←→` on right hand: cursor movement
- `▲↻` / `▼↻` (H / N): scroll up / down
- `↺↻` / `↻↺` (Y / U): scroll left / right
- right inner thumb: left click; right outer thumb: right click

Reach: tap `X+C` to toggle on. Tap again to exit.

---

## Cheat-sheet — wishlist actions

| Want | Do this |
|---|---|
| **Backspace** | hold LO (EXT), press `M` position |
| **Screenshot** | `J+K` (BASE) |
| **Send window to UW left** | tap `F+J`, then `J` |
| **Send window to UW right** | tap `F+J`, then `L` |
| **Maximize window** | tap `F+J`, then `I` |
| **Send window to thinkvision** | tap `F+J`, then `K` |
| **Top box on UW** | tap `F+J`, then `U` |
| **Teams share 1920×1080 box** | tap `F+J`, then `O` |
| **Close window** | tap `F+J`, then `X` |
| **Switch audio** | tap `F+J`, then `H` (Jabra) / `D` (SMSL) |
| **Mouse mode on/off** | tap `X+C` (BASE) |
| **Launch app (Meh)** | tap `F+J`, then a letter (B/C/E/F/M/N/P/R/S/T/W) |
| **Volume up / down / mute** | tap `F+J`, then `Q` / `A` / `Z` |
| **`Alt+Space`** (FZ cycle) | `D+F` (BASE) |
| **Recover from stuck modifier** | both left thumbs → SETTINGS, press position 7 |
| **Switch BT profile** | both left thumbs → SETTINGS, `BT0..BT5` keys |

---

## Position-number reference (for editing the keymap)

```
  0   1   2   3   4   │   5   6   7   8   9
 10  11  12  13  14   │  15  16  17  18  19
 20  21  22  23  24   │  25  26  27  28  29
         30  31       │  32  33
```
