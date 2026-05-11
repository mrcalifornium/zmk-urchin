; urchin-apps.ahk
; ----------------
; AutoHotkey v2 script — listens for Hyper+letter (Ctrl+Alt+Win+Shift+<letter>)
; and either focuses the app if it's already running, or launches it.
;
; The Urchin keyboard fires this from a base-layer combo: F+J = sticky Hyper.
; Tap F+J, then a letter, AHK does the rest.
;
; Setup:
;   1. Install AutoHotkey v2.0 from https://www.autohotkey.com
;   2. Drop this file into:
;        %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
;      (open with: Win+R -> shell:startup)
;   3. Double-click to run now (also auto-starts on login).
;
; Edit this file to taste — the path-or-name in Run() needs to match
; what's installed on this machine. The window title in WinExist() must
; be loose enough to match the running window. ahk_exe matches the .exe
; name; ahk_class matches the window class.

#Requires AutoHotkey v2.0
#SingleInstance Force

; Helper: focus existing window if it exists, otherwise launch it.
; winQuery: an ahk_exe / ahk_class / partial title to find a running window
; runTarget: what to pass to Run (a path or a name on PATH)
ActivateOrLaunch(winQuery, runTarget) {
    if WinExist(winQuery) {
        WinActivate
    } else {
        try Run(runTarget)
    }
}

; ─── Hyper key bindings ──────────────────────────────────────────────
; Hotkey syntax: ^ = Ctrl, ! = Alt, # = Win, + = Shift
; So ^!#+b means Ctrl+Alt+Win+Shift+B = "Hyper+B"

; B = Browser (Edge — change to chrome.exe / firefox.exe as needed)
^!#+b::ActivateOrLaunch("ahk_exe msedge.exe", "msedge.exe")

; E = Email (Outlook)
^!#+e::ActivateOrLaunch("ahk_exe OUTLOOK.EXE", "outlook.exe")

; F = File Explorer
^!#+f::ActivateOrLaunch("ahk_class CabinetWClass", "explorer.exe")

; T = Terminal (Windows Terminal)
^!#+t::ActivateOrLaunch("ahk_exe WindowsTerminal.exe", "wt.exe")

; C = VS Code
^!#+c::ActivateOrLaunch("ahk_exe Code.exe", "code")

; X = Excel
^!#+x::ActivateOrLaunch("ahk_exe EXCEL.EXE", "excel.exe")

; W = Word
^!#+w::ActivateOrLaunch("ahk_exe WINWORD.EXE", "winword.exe")

; S = Slack
; ^!#+s::ActivateOrLaunch("ahk_exe slack.exe", A_AppData "\..\Local\slack\slack.exe")

; M = Music (Spotify)
; ^!#+m::ActivateOrLaunch("ahk_exe Spotify.exe", A_AppData "\..\Roaming\Spotify\Spotify.exe")

; O = Obsidian
; ^!#+o::ActivateOrLaunch("ahk_exe Obsidian.exe", A_AppData "\..\Local\Obsidian\Obsidian.exe")

; P = PowerShell (alternative to T)
; ^!#+p::ActivateOrLaunch("ahk_exe pwsh.exe", "pwsh.exe")

; ─── Window snap helpers ─────────────────────────────────────────────
; Snap actions live on the same Hyper trigger as app launches, just on
; different letters. AHK does pixel-perfect WinMove based on the actual
; monitor work area, so it stays correct across resolution / scaling
; changes and doesn't depend on FancyZones / Windows Snap behaviour.
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

; ─── Window snap bindings (Hyper + letter) ───────────────────────────

; Hyper+H : UW left half
^!#+h::{
    m := GetMonitor(1)
    SnapTo(m.left, m.top, m.width / 2, m.height)
}

; Hyper+L : UW right half
^!#+l::{
    m := GetMonitor(1)
    SnapTo(m.left + m.width / 2, m.top, m.width / 2, m.height)
}

; Hyper+M : UW full / maximize
^!#+m::SnapToMonitor(1)

; Hyper+N : ThinkVision full / maximize
^!#+n::SnapToMonitor(2)

; Hyper+I : top-center 1/3 × 1/3 box on UW
^!#+i::{
    m := GetMonitor(1)
    w := m.width / 3, h := m.height / 3
    SnapTo(m.left + (m.width - w) / 2, m.top, w, h)
}

; Hyper+R : bottom-center 1920×1080 box on UW (Teams share-friendly)
^!#+r::{
    m := GetMonitor(1)
    w := 1920, h := 1080
    SnapTo(m.left + (m.width - w) / 2, m.top + m.height - h, w, h)
}

; ─── Tray ────────────────────────────────────────────────────────────
; Optional: rename the tray entry so you can spot it.
A_IconTip := "Urchin app launcher + window snaps"
