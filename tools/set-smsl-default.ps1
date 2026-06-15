# set-smsl-default.ps1
# -------------------
# Sets the SMSL iDea v1.2 USB DAC as the default playback device.
#
# Why this exists: the SMSL's friendly name in the registry is blank
# and its device name is just "Speakers" (same as the Realtek onboard),
# so name-based matching is ambiguous. Its MMDevice GUID and the "N- "
# enumeration prefix both change whenever it's replugged into a
# different USB port. The ONE stable identifier is the USB hardware ID
# VID_152A & PID_85DD, so we resolve the current GUID from that at
# run time, then hand the GUID-based Item ID to SoundVolumeView.
#
# Called from urchin-apps.ahk on the F+J -> D chord.

$ErrorActionPreference = 'Stop'
$svv = 'C:\Users\aleks\Downloads\apps\soundvolumeview-x64\SoundVolumeView.exe'
$usbPattern = '*152A*85DD*'

$guid = $null
Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render' |
  ForEach-Object {
    $g = Split-Path $_.PSPath -Leaf
    $state = (Get-ItemProperty $_.PSPath).DeviceState
    $p = Get-ItemProperty "$($_.PSPath)\Properties" -ErrorAction SilentlyContinue
    $enum = $p.'{b3f8fa53-0004-438e-9003-51a46e139bfc},2'
    # State 1 = Active. Pick the active endpoint for this USB device.
    if ($state -eq 1 -and $enum -like $usbPattern) { $guid = $g }
  }

if (-not $guid) {
  # DAC not currently present/active — nothing to switch to.
  exit 1
}

$itemId = '{0.0.0.00000000}.' + $guid
& $svv /SetDefault $itemId all
