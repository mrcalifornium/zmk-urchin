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
| **WIN** (5) | from EXT, chord `S+D` | momentary, only while combo held |
| **MOUSE** (6) | tap `X+C` from BASE | toggle on/off |

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

---

## SYM — symbols + numbers

```
 !   @   #   $   %   │   ^   &   *   (   )
 1   2   3   4   5   │   6   7   8   9   0
 `   "   +   [   ]   │   _   \   -   =   '
        FNC LSHIFT   │   _   _
```

Tip: `⇧+1..0` on row 2 also gives you the row-1 shifted symbols, since left-thumb shift is available.

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
- **S+D** → enter WIN layer (held)

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

## WIN — window snap (FancyZones)

```
 _   _   _   _   _   │   _   _   ↑      _   _
 _   _   _   _   _   │   _   ←   ↓      →   _
 _   _   _   _   _   │   _   _   _      _   _
        _    _       │   _   _
```

Where:
- **←** = `Win+Ctrl+Alt+1` (UW left zone)
- **→** = `Win+Ctrl+Alt+2` (UW right zone)
- **↑** = `Win+Up` (maximize current monitor)
- **↓** = `Win+Shift+→` then `Win+Ctrl+Alt+1` (cycle to other monitor + fill)

Reach: hold LO (EXT), then squeeze `S+D` (left ring + middle, home row), then press the arrow with the right hand.

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
| **Backspace** | hold LO (EXT), press `J` position |
| **Screenshot** | `J+K` (BASE) |
| **Send window to UW left** | hold LO, squeeze `S+D`, press `←` |
| **Send window to UW right** | hold LO, squeeze `S+D`, press `→` |
| **Maximize window** | hold LO, squeeze `S+D`, press `↑` |
| **Send window to thinkvision** | hold LO, squeeze `S+D`, press `↓` |
| **Mouse mode on/off** | tap `X+C` (BASE) |
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
