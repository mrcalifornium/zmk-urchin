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

- [ ] Hold left-outer thumb to enter EXT, then mash `BSPC` (position 16, where `J` sits) rapidly 20 times. No drops, no missed presses.
- [ ] Same test from the SYM layer using `&kp MINUS` (or any rapid-repeat key) for 20 presses.
- [ ] Walk 3 metres from the host and repeat above. Should still feel solid.

If still missing keys: layer-release race (you're releasing the EXT thumb before BSPC registers). Tell me and we'll add a base-layer backspace combo.

## 4. Screenshot — J+K combo

- [ ] On BASE, press `J+K` simultaneously → Snipping Tool selection overlay appears.
- [ ] Cancel with `Esc`.
- [ ] Repeat 3 more times to confirm reliability.

## 5. Window snap — WIN layer

Set up: open a window on the ultrawide.

- [ ] Hold left-outer thumb (EXT), squeeze `S+D`, then press `←` → window snaps to UW left zone.
- [ ] Same gesture, press `→` → window snaps to UW right zone.
- [ ] Same gesture, press `↑` → window maximizes on the ultrawide.
- [ ] Same gesture, press `↓` → window moves to thinkvision and fills it.
- [ ] With the window now on thinkvision, repeat S+D + `↓` → window cycles back to UW left.

If `↓` doesn't reach the thinkvision: the macro uses `Win+Shift+→`. If your monitor adjacency makes `Win+Shift+←` go there instead, both should still cycle, but if neither works, check Windows Display Settings → arrange monitors physically.

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
