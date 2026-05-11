; urchin-apps.ahk
; ----------------
; AutoHotkey v2 script — listens for Meh+letter (Ctrl+Alt+Shift+<letter>)
; and either focuses the app if it's already running, or launches it.
;
; The Urchin keyboard fires this from a base-layer combo: F+J = sticky Meh.
; Tap F+J, then a letter, AHK does the rest.
;
; Setup:
;   1. Install AutoHotkey v2.0 from https://www.autohotkey.com
;   2. Drop this file into:
;        %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
;      (open with: Win+R -> shell:startup)
;   3. Double-click to run now (also auto-starts on login).

#Requires AutoHotkey v2.0
#SingleInstance Force

LOCALAPPDATA := EnvGet("LOCALAPPDATA")

; Helper: focus existing window if it exists, otherwise launch it.
; Handles tray-minimized / hidden windows (Teams, Outlook, etc.
; "close to tray" leaves the window hidden — default WinExist doesn't
; see those, so old launcher always thought the app wasn't running).
ActivateOrLaunch(winQuery, runTarget) {
    prevDH := A_DetectHiddenWindows
    DetectHiddenWindows(true)
    try {
        if hwnd := WinExist(winQuery) {
            try WinShow(hwnd)             ; un-hide if tray-minimized
            if WinGetMinMax(hwnd) = -1
                WinRestore(hwnd)          ; restore if window-minimized
            WinActivate(hwnd)
            return
        }
    } finally {
        DetectHiddenWindows(prevDH)
    }
    try Run(runTarget)
}

; Forward a Win+<slot> taskbar shortcut to Windows.
; Windows interprets Win+1..9 as "activate or launch the Nth pinned
; taskbar app" with built-in toggle behaviour. We use this for the
; Edge profiles since Edge profile windows can't be distinguished by
; process or title — but if each profile lives at a fixed taskbar
; slot, Windows already knows which is which.
;
; We release the sticky-Meh modifiers (Ctrl/Alt/Shift) first so the
; host sees a clean Win+<slot> chord, not Ctrl+Alt+Shift+Win+<slot>.
TaskbarSlot(slot) {
    SendInput("{LCtrl up}{LAlt up}{LShift up}#" slot)
}

; ─── Meh + letter app bindings ──────────────────────────────────────
; Hotkey syntax: ^ = Ctrl, ! = Alt, + = Shift
; So ^!+b means Ctrl+Alt+Shift+B = "Meh+B"

; B = Personal browser at taskbar slot 8 (Chrome — or whichever you
;     end up using for personal. Keep it pinned in position 8 of the
;     taskbar from the left, counting only pinned items.)
^!+b::TaskbarSlot(8)

; C = Claude desktop
^!+c::ActivateOrLaunch("ahk_exe claude.exe", LOCALAPPDATA "\AnthropicClaude\claude.exe")

; E = Work browser at taskbar slot 7 (Edge with work profile pinned
;     in position 7 of the taskbar from the left.)
^!+e::TaskbarSlot(7)

; F = File Explorer
^!+f::ActivateOrLaunch("ahk_class CabinetWClass", "explorer.exe")

; N = OneNote
^!+n::ActivateOrLaunch("ahk_exe ONENOTE.EXE", "onenote.exe")

; O = Outlook (new)
^!+o::ActivateOrLaunch("ahk_exe olk.exe", "olk.exe")

; R = Calculator
^!+r::ActivateOrLaunch("Calculator", "calc.exe")

; T = Teams (new)
^!+t::ActivateOrLaunch("ahk_exe ms-teams.exe", "ms-teams.exe")

; W = Word
^!+w::ActivateOrLaunch("ahk_exe WINWORD.EXE", "winword.exe")

; X = Excel
^!+x::ActivateOrLaunch("ahk_exe EXCEL.EXE", "excel.exe")

; ─── Window snap helpers ─────────────────────────────────────────────
; Pixel-perfect WinMove based on MonitorGetWorkArea — robust to
; resolution / scaling changes, no FancyZones dependency.
;
; Monitor numbering (Settings → Display → Identify):
;   1 = Ultrawide (UW)         3440 x 1440  @ 125%, top
;   2 = ThinkVision (FullHD)   1920 x 1080  @ 125%, below UW

GetMonitor(idx) {
    MonitorGetWorkArea(idx, &L, &T, &R, &B)
    return { left: L, top: T, right: R, bottom: B, width: R - L, height: B - T }
}

SnapTo(x, y, w, h) {
    if !WinExist("A")
        return
    WinRestore("A")
    WinMove(x, y, w, h, "A")
}

SnapToMonitor(idx) {
    if !WinExist("A")
        return
    m := GetMonitor(idx)
    WinRestore("A")
    WinMove(m.left, m.top, m.width, m.height, "A")
    WinMaximize("A")
}

; ─── Meh + letter window snap bindings ──────────────────────────────

; H = UW left half
^!+h::{
    m := GetMonitor(1)
    SnapTo(m.left, m.top, m.width / 2, m.height)
}

; I = top-center 1/3 × 1/3 box on UW
^!+i::{
    m := GetMonitor(1)
    w := m.width / 3
    h := m.height / 3
    SnapTo(m.left + (m.width - w) / 2, m.top, w, h)
}

; L = UW right half
^!+l::{
    m := GetMonitor(1)
    SnapTo(m.left + m.width / 2, m.top, m.width / 2, m.height)
}

; M = UW maximize
^!+m::SnapToMonitor(1)

; S = bottom-center 1920×1080 box on UW (Teams share-friendly)
^!+s::{
    m := GetMonitor(1)
    w := 1920
    h := 1080
    SnapTo(m.left + (m.width - w) / 2, m.top + m.height - h, w, h)
}

; V = ThinkVision maximize
^!+v::SnapToMonitor(2)

; ─── Tray ────────────────────────────────────────────────────────────
A_IconTip := "Urchin app launcher + window snaps"
