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

; SoundVolumeView (NirSoft) — used for audio output device switching.
; Update this path if you move the exe.
SVV := '"C:\Users\aleks\Downloads\apps\soundvolumeview-x64\SoundVolumeView.exe"'

; Canonical Windows trick to force a window to the foreground even
; when foreground-lock protection (SPI_SETFOREGROUNDLOCKTIMEOUT)
; would normally refuse WinActivate. Attaches our input thread to
; the current-foreground window's thread, calls the low-level
; ShowWindow + SetForegroundWindow + SetFocus, then detaches.
; Works on apps that resist WinActivate (Teams "close to tray",
; some Electron windows, etc.).
ForceForeground(hwnd) {
    if !hwnd
        return
    DllCall("ShowWindow", "Ptr", hwnd, "Int", 9)            ; SW_RESTORE
    targetTid := DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "UInt*", 0)
    fgHwnd    := DllCall("GetForegroundWindow", "Ptr")
    fgTid     := DllCall("GetWindowThreadProcessId", "Ptr", fgHwnd, "UInt*", 0)
    thisTid   := DllCall("GetCurrentThreadId")
    attached1 := (thisTid != fgTid)
        ? DllCall("AttachThreadInput", "UInt", thisTid, "UInt", fgTid, "Int", true)
        : 0
    attached2 := (targetTid != fgTid && targetTid != thisTid)
        ? DllCall("AttachThreadInput", "UInt", targetTid, "UInt", fgTid, "Int", true)
        : 0
    DllCall("BringWindowToTop", "Ptr", hwnd)
    DllCall("SetForegroundWindow", "Ptr", hwnd)
    DllCall("SetFocus", "Ptr", hwnd)
    if attached1
        DllCall("AttachThreadInput", "UInt", thisTid, "UInt", fgTid, "Int", false)
    if attached2
        DllCall("AttachThreadInput", "UInt", targetTid, "UInt", fgTid, "Int", false)
}

; Helper: bring an app forward if it's running, otherwise launch it
; into the share-view layout (1920x1080 centered at the bottom of
; the ultrawide). Running case un-hides tray-minimized + restores
; minimized + uses ForceForeground to bypass focus-lock protection.
ActivateOrLaunch(winQuery, runTarget) {
    prevDH := A_DetectHiddenWindows
    DetectHiddenWindows(true)
    try {
        if hwnd := WinExist(winQuery) {
            try WinShow(hwnd)
            if WinGetMinMax(hwnd) = -1
                WinRestore(hwnd)
            ForceForeground(hwnd)
            return
        }
    } finally {
        DetectHiddenWindows(prevDH)
    }

    ; Not running — launch and place into the share-view rectangle
    try Run(runTarget)
    if !hwnd := WinWait(winQuery, , 8)
        return
    Sleep(300)  ; give the app a moment to finish creating its window
    try {
        WinRestore(hwnd)
        m := GetMonitor(1)
        w := 1920
        h := 1080
        WinMove(m.left + (m.width - w) / 2, m.top + m.height - h, w, h, hwnd)
        ForceForeground(hwnd)
    }
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

; C = Claude desktop (Microsoft Store install)
; Launched via Windows AUMID (App User Model ID) instead of a path,
; since MSIX install dirs contain a version number that changes on
; every Store update. AUMID is stable.
; To find your AUMID if it ever changes:
;   Get-StartApps | Where-Object { $_.Name -like "*Claude*" }
^!+c::ActivateOrLaunch("ahk_exe Claude.exe", "shell:AppsFolder\Claude_pzs8sxrjxfjjc!Claude")

; E = Work browser at taskbar slot 7 (Edge with work profile pinned
;     in position 7 of the taskbar from the left.)
^!+e::TaskbarSlot(7)

; F = File Explorer
^!+f::ActivateOrLaunch("ahk_class CabinetWClass", "explorer.exe")

; N = OneNote
^!+n::ActivateOrLaunch("ahk_exe ONENOTE.EXE", "onenote.exe")

; M = Outlook (new) — "Mail". Moved off O so O can be a window snap.
^!+m::ActivateOrLaunch("ahk_exe olk.exe", "olk.exe")

; R = Calculator
^!+r::ActivateOrLaunch("Calculator", "calc.exe")

; T = Teams (new) — match by title + exe because Teams runs as two
; processes (a background ms-teams.exe with no visible window and
; the main one with "Microsoft Teams" in its window title).
^!+t::ActivateOrLaunch("Microsoft Teams ahk_exe ms-teams.exe", "ms-teams.exe")

; W = Word
^!+w::ActivateOrLaunch("ahk_exe WINWORD.EXE", "winword.exe")

; S = Excel ("Spreadsheet"). Moved off X so X can close windows.
^!+s::ActivateOrLaunch("ahk_exe EXCEL.EXE", "excel.exe")

; P = PowerPoint
^!+p::ActivateOrLaunch("ahk_exe POWERPNT.EXE", "powerpnt.exe")

; G = Guide — toggle the keyboard manual as an always-on-top
; translucent overlay on the ultrawide, no title bar, 5 px inset
; from the screen edges. Tap again (or Esc) to close.
MANUAL_PATH := "file:///C:/Users/aleks/Productivity/zmk-urchin/docs/manual.html"
MANUAL_MATCH := "Urchin"           ; matches the page title prefix
MANUAL_INSET := 5                  ; gap from screen edges, px
MANUAL_OPACITY := 230              ; 0..255 (230 ~= 90%)

^!+g::{
    global MANUAL_PATH, MANUAL_MATCH, MANUAL_INSET, MANUAL_OPACITY
    SetTitleMatchMode(2)

    ; Toggle off if already showing
    if hwnd := WinExist(MANUAL_MATCH " ahk_exe msedge.exe") {
        try WinClose(hwnd)
        return
    }

    ; Launch at 170% zoom via Chromium device-scale-factor flag
    Run('"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --app=' MANUAL_PATH ' --force-device-scale-factor=1.7')
    if !hwnd := WinWait(MANUAL_MATCH " ahk_exe msedge.exe", , 4)
        return

    ; Strip the title bar + thick frame for a clean overlay look
    ; (WS_CAPTION 0xC00000 | WS_THICKFRAME 0x40000 = 0xC40000)
    WinSetStyle("-0xC40000", hwnd)

    ; Maximize on UW (monitor 1) with the requested edge inset
    m := GetMonitor(1)
    WinMove(m.left + MANUAL_INSET, m.top + MANUAL_INSET,
            m.width - 2 * MANUAL_INSET, m.height - 2 * MANUAL_INSET, hwnd)

    WinSetAlwaysOnTop(true, hwnd)
}

; X = close active window (Alt+F4).
; Release the sticky-Meh modifiers first so the host sees a clean
; Alt+F4, not Ctrl+Alt+Shift+F4.
^!+x::SendInput("{LCtrl up}{LAlt up}{LShift up}!{F4}")

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
; Right-hand cluster — U I O on top row, J K L on home row:
;   U = top-mid box   I = maximize UW   O = share box
;   J = left half     K = ThinkVision   L = right half

; I = maximize on the ultrawide
^!+i::SnapToMonitor(1)

; U = top-center box on UW — 1/3 width, 1/2 height, anchored to top
; (Was on Y briefly; moved here because something on the host grabs
; Ctrl+Alt+Shift+Y at higher priority than AHK.)
^!+u::{
    m := GetMonitor(1)
    w := m.width / 3
    h := m.height / 2
    SnapTo(m.left + (m.width - w) / 2, m.top, w, h)
}

; K = ThinkVision (lower screen) maximize
^!+k::SnapToMonitor(2)

; J = UW left half
^!+j::{
    m := GetMonitor(1)
    SnapTo(m.left, m.top, m.width / 2, m.height)
}

; L = UW right half
^!+l::{
    m := GetMonitor(1)
    SnapTo(m.left + m.width / 2, m.top, m.width / 2, m.height)
}

; O = bottom-center 1920×1080 box on UW (Teams share-friendly)
^!+o::{
    m := GetMonitor(1)
    w := 1920
    h := 1080
    SnapTo(m.left + (m.width - w) / 2, m.top + m.height - h, w, h)
}

; ─── Meh + letter audio output switching ────────────────────────────
; Sets the default playback device (all roles: Console, Multimedia,
; Communications) via SoundVolumeView. Device IDs are the
; "Command-Line Friendly ID" from SoundVolumeView's GUI.

SetAudio(deviceId) {
    Run(SVV ' /SetDefault "' deviceId '" all')
}

; H = Jabra headset — "Headset". Moved off J so J can be a window snap.
^!+h::SetAudio("Jabra Engage 75\Device\Headset Earphone\Render")

; D = SMSL iDea DAC
; The SMSL has no friendly name in the registry, its device name is
; the generic "Speakers" (collides with Realtek onboard), and both
; its MMDevice GUID and "N- " enumeration prefix change on replug —
; so no static SoundVolumeView string is stable. Instead a helper
; PowerShell script resolves the current GUID from the stable USB
; hardware ID (VID_152A & PID_85DD) and sets it default by GUID.
^!+d::Run('powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\aleks\Productivity\zmk-urchin\tools\set-smsl-default.ps1"', , "Hide")

; ─── Meh + letter volume control (left pinky column) ──────────────
; Rate-limited so holding Q or A ramps gently instead of shooting
; up/down 10% in half a second.

VOLUME_DEBOUNCE_MS := 200
lastVolumeAt := 0
VolumeStep(virtualKey) {
    global VOLUME_DEBOUNCE_MS, lastVolumeAt
    now := A_TickCount
    if (now - lastVolumeAt < VOLUME_DEBOUNCE_MS)
        return
    lastVolumeAt := now
    Send(virtualKey)
}

; Q = volume up (left pinky top)
^!+q::VolumeStep("{Volume_Up}")

; A = volume down (left pinky home)
^!+a::VolumeStep("{Volume_Down}")

; Z = mute toggle (left pinky bottom) — not debounced, only one tap matters
^!+z::Send("{Volume_Mute}")

; ─── Tray ────────────────────────────────────────────────────────────
A_IconTip := "Urchin app launcher + window snaps + audio"
