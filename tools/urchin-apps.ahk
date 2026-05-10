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

; ─── Tray ────────────────────────────────────────────────────────────
; Optional: rename the tray entry so you can spot it.
A_IconTip := "Urchin app launcher"
