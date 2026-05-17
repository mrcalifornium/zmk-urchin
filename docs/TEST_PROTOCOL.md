# Post-flash test protocol

Run these in order after flashing both halves. If any step fails, **stop** and note which one — the failure mode points directly at the cause.

## 0. Prerequisites

- [ ] Both halves flashed with the new firmware.
- [ ] Both halves powered on, connected to the same host via Bluetooth profile 0 (or whichever you use).
- [ ] PowerToys FancyZones running with Split Screen on the ultrawide and Fullscreen on the thinkvision.

---

## 1. Sanity — typing still works

- [ ] Type `the quick brown fox jumps over the lazy dog` in any text field. All letters appear, nothing duplicates, nothing drops.
- [ ] Type `jk` and `kj` rapidly five times each. **No screenshot tool should pop up** — the 35 ms timeout should reject these.
- [ ] Type `xc` and `cx` rapidly five times each. **Mouse layer should NOT toggle** — the 50 ms timeout should reject these.

If step 1 fails: combo timeouts are too generous → tighten `combo_screenshot` and `combo_mouse` `timeout-ms`.

## 2. Existing combos still work

- [ ] On BASE: press `D+F` simultaneously → `Alt+Space` fires (FancyZones cycle/Spotlight/whatever you have bound).
- [ ] Both left thumbs simultaneously → SETTINGS layer (battery/BT info on display, if applicable).

## 3. BLE snappiness — the backspace fix

- [ ] Hold left-outer thumb to enter EXT, then mash `BSPC` (position 26, where `M` sits) rapidly 20 times. No drops, no missed presses.
- [ ] Same test from the SYM layer using `&kp MINUS` (or any rapid-repeat key) for 20 presses.
- [ ] Walk 3 metres from the host and repeat above. Should still feel solid.

If still missing keys: layer-release race (you're releasing the EXT thumb before BSPC registers). Tell me and we'll add a base-layer backspace combo.

## 4. Screenshot — J+K combo

- [ ] On BASE, press `J+K` simultaneously → Snipping Tool selection overlay appears.
- [ ] Cancel with `Esc`.
- [ ] Repeat 3 more times to confirm reliability.

## 5. Window snap — Meh+letter via AHK

Set up: open a window on the ultrawide. `urchin-apps.ahk` must be running.

- [ ] Tap `F+J`, then `H` → window snaps to UW left half (exactly half the UW width).
- [ ] Tap `F+J`, then `L` → UW right half.
- [ ] Tap `F+J`, then `M` → maximizes on UW.
- [ ] Tap `F+J`, then `V` → window moves to ThinkVision and maximizes there.
- [ ] From ThinkVision, `F+J`, then `M` → returns to UW and maximizes.
- [ ] Tap `F+J`, then `I` → small box top-center of UW (~1/3 × 1/3).
- [ ] Tap `F+J`, then `S` → bottom-center 1920×1080 box (Teams share rectangle).

If nothing happens: AHK script not running. Tray → AutoHotkey icon should be visible. If wrong monitor for V: open `tools/urchin-apps.ahk` and swap which `GetMonitor()` index is 1 vs 2.

## 6. Mouse layer

- [ ] On BASE, tap `X+C` simultaneously → cursor mode is active (no visual indicator — verify by trying to move).
- [ ] Press and hold `J` → cursor moves left, accelerating after ~0.3 s.
- [ ] Press `I` → up. `K` → down. `L` → right.
- [ ] Press right inner thumb → left click. Test on a window's close button or a link.
- [ ] Press right outer thumb → right click. Context menu appears.
- [ ] Hold `H` → page scrolls up. `N` → scrolls down.
- [ ] Tap `X+C` again → cursor stops responding to HJKL, normal typing resumes.

If acceleration feels too slow / too jumpy, tell me and we'll tune `&mmv` defaults via a `&mmv` config block.

## 7. No regressions on FNC layer

- [ ] Both thumbs (EXT + FNC), press position 17 (`K`) → `PrintScreen` still fires.
- [ ] F-keys F1–F12 still work via FNC.

## 8. Settings layer

- [ ] Both left thumbs (combo) → SETTINGS.
- [ ] Verify Bluetooth profile switching still works (`BT_SEL 0..5`).
- [ ] Verify `&unstick` macro still recovers from stuck modifiers.

---

## Rollback

If anything is fundamentally broken, revert with:

```
git revert f3b4a5c
git push
```

…then re-flash from the previous successful Actions build.
