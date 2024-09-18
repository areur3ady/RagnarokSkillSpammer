#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance

if (!JEE_AhkIsAdmin())	{
	MsgBox, You need to run as Admin!
	ExitApp
}

; Global variables
global GlobalSpamEnabled := false
global CustomHotkey := "F12"  ; Default hotkey

Gui, Add, GroupBox, x11 y2 w370 h50 , F Keys

Gui, Add, CheckBox, x21 y22 w38 h24 vF1ClickStatus gSubmitClickStatus, F1
Gui, Add, CheckBox, x61 y22 w38 h24 vF2ClickStatus gSubmitClickStatus, F2
Gui, Add, CheckBox, x101 y22 w38 h24 vF3ClickStatus gSubmitClickStatus, F3
Gui, Add, CheckBox, x141 y22 w38 h24 vF4ClickStatus gSubmitClickStatus, F4
Gui, Add, CheckBox, x181 y22 w38 h24 vF5ClickStatus gSubmitClickStatus, F5
Gui, Add, CheckBox, x221 y22 w38 h24 vF6ClickStatus gSubmitClickStatus, F6
Gui, Add, CheckBox, x261 y22 w38 h24 vF7ClickStatus gSubmitClickStatus, F7
Gui, Add, CheckBox, x301 y22 w38 h24 vF8ClickStatus gSubmitClickStatus, F8
Gui, Add, CheckBox, x341 y22 w38 h24 vF9ClickStatus gSubmitClickStatus, F9

Gui, Add, GroupBox, x11 y52 w370 h50 , Number Keys

Gui, Add, CheckBox, x21 y72 w38 h24 v1ClickStatus gSubmitClickStatus, 1
Gui, Add, CheckBox, x61 y72 w38 h24 v2ClickStatus gSubmitClickStatus, 2
Gui, Add, CheckBox, x101 y72 w38 h24 v3ClickStatus gSubmitClickStatus, 3
Gui, Add, CheckBox, x141 y72 w38 h24 v4ClickStatus gSubmitClickStatus, 4
Gui, Add, CheckBox, x181 y72 w38 h24 v5ClickStatus gSubmitClickStatus, 5
Gui, Add, CheckBox, x221 y72 w38 h24 v6ClickStatus gSubmitClickStatus, 6
Gui, Add, CheckBox, x261 y72 w38 h24 v7ClickStatus gSubmitClickStatus, 7
Gui, Add, CheckBox, x301 y72 w38 h24 v8ClickStatus gSubmitClickStatus, 8
Gui, Add, CheckBox, x341 y72 w38 h24 v9ClickStatus gSubmitClickStatus, 9

Gui, Add, GroupBox, x11 y102 w370 h50 , Other Keys

Gui, Add, CheckBox, x21 y122 w60 h24 vEnterClickStatus gSubmitClickStatus, Enter

; Add global switch
Gui, Add, GroupBox, x11 y152 w370 h70 , Global Switch
Gui, Add, Text, x21 y172 w150 h20 , Global Spam Status:
Gui, Add, Text, x171 y172 w100 h20 vGlobalStatus, Disabled
Gui, Add, Button, x281 y167 w90 h30 gToggleGlobalSpam, Toggle Spam

; Add custom hotkey setting
Gui, Add, Text, x21 y197 w150 h20 , Custom Hotkey:
Gui, Add, Hotkey, x171 y192 w100 h25 vNewHotkey gSetCustomHotkey, %CustomHotkey%
Gui, Add, Button, x281 y192 w90 h30 gApplyHotkey, Apply Hotkey

; Generated using SmartGUI Creator 4.0
Gui, Show, x404 y316 h237 w393, Ragnarok Skill Spammer

Gui, Add, Link, x341 y222 w40 h20 , <a href="https://github.com/areur3ady/RagnarokSkillSpammer">v1.06</a>

Gui, Submit, NoHide
gosub, updateKeys

Menu, Tray, Add, Restore, Restore
Menu, Tray, default, Restore
Menu, Tray, Click, 2

; Set initial custom hotkey
Hotkey, %CustomHotkey%, ToggleGlobalSpam

return

SubmitClickStatus:
	Gui, Submit, NoHide
	gosub, updateKeys
return

updateKeys:
{
	i := 1
	Loop, 9 {
		if (F%i%ClickStatus && GlobalSpamEnabled) {
			hotkey, f%i%, spam, On
		} else {
			hotkey, f%i%, spam, Off
		}
		if (%i%ClickStatus && GlobalSpamEnabled) {
			hotkey, %i%, spam, On
		} else {
			hotkey, %i%, spam, Off
		}
		i := i + 1
	}	
	if (EnterClickStatus && GlobalSpamEnabled) {
		hotkey, Enter, spam, On
	} else {
		hotkey, Enter, spam, Off
	}
}
return

spam:
{
	#If WinActive("ahk_class Ragnarok")
		while getkeystate(a_thishotkey, "p") && GlobalSpamEnabled {
				ControlSend, ahk_parent, {%a_thishotkey%}, ahk_class Ragnarok
				ControlClick,, ahk_class Ragnarok
				Sleep, 10
		}
}
return

ToggleGlobalSpam:
{
	GlobalSpamEnabled := !GlobalSpamEnabled
	if (GlobalSpamEnabled) {
		GuiControl,, GlobalStatus, Enabled
	} else {
		GuiControl,, GlobalStatus, Disabled
	}
	gosub, updateKeys
}
return

SetCustomHotkey:
{
	Gui, Submit, NoHide
}
return

ApplyHotkey:
{
	if (NewHotkey != "") {
		Hotkey, %CustomHotkey%, ToggleGlobalSpam, Off
		CustomHotkey := NewHotkey
		Hotkey, %CustomHotkey%, ToggleGlobalSpam, On
		MsgBox, New hotkey set to %CustomHotkey%
	}
}
return

;==================================================

JEE_AhkIsAdmin()
{
	vVersion := DllCall("kernel32\GetVersion", "UInt")
	if (vVersion & 0xFF < 5)
		return 1

	hSC := DllCall("advapi32\OpenSCManager", "Ptr",0, "Ptr",0, "UInt",0x8, "Ptr")
	vRet := 0
	if hSC
	{
		if (vLock := DllCall("advapi32\LockServiceDatabase", "Ptr",hSC, "Ptr"))
		{
			DllCall("advapi32\UnlockServiceDatabase", "Ptr",vLock)
			vRet := 1
		}
		else
		{
			vLastError := DllCall("kernel32\GetLastError", "UInt")
			if (vLastError = 1055)
				vRet := 1
		}
		DllCall("advapi32\CloseServiceHandle", "Ptr",hSC)
	}
	return vRet
}
;==============================

GuiSize:
  if (A_EventInfo = 1)
    WinHide
  return

Restore:
  gui +lastfound
  WinShow
  WinRestore
  return

GuiClose:
	ExitApp
