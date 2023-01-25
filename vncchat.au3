#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Icons\chat.ico
#Au3Stripper_Parameters=/sf /sv /pe /rm
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Local Const $width = 500, $height = 380
Global Const $date = @MDAY & "/" & @MON & "/" & @YEAR
Global Const $hGUIMain = GUICreate("VNC Chat", $width, $height, @DesktopWidth - ($width + 5), 0, 0x00C40020)
Global $ed_History = GUICtrlCreateEdit("--- VNC Messaging Session " & $date & " ---", 5, 5, 490, 300)
GUICtrlSetStyle(-1, 0x0800)
Global $ed_Chat = GUICtrlCreateEdit("", 5, 310, 470, 60, 0x00201040)
Local $bSend = GUICtrlCreateButton(">", 478, 310, 18, 60)
WinSetTrans($hGUIMain, "", 230)
GUISetState()
GUICtrlSetState($ed_Chat, 0x0100)
HotKeys()

While 1
	Local $iMsg = GUIGetMsg()
	Switch $iMsg
		Case -3
			ExitLoop
		Case $bSend
			SendTxt()
	EndSwitch
WEnd

terminate()

Func HotKeys($switch = 0x0)
	Local Const $key = "{ENTER}"
	If $switch = 0x1 Then
		HotKeySet($key)
		Send($key)
	EndIf
	HotKeySet($key, "sendtxt")
EndFunc   ;==>HotKeys

Func SendTxt()
	Local $cache = GUICtrlRead($ed_Chat)
	If $cache = "hide" Then GUISetState(@SW_MINIMIZE, $hGUIMain)
	If $cache = "exit" Then terminate()
	If $cache = "exitforced" Then Exit
	If $cache = "beep" Then Beep(700, 500)
	If WinActive($hGUIMain) = True Then
		GUICtrlSetData($ed_History, GUICtrlRead($ed_History) & @CRLF & """" & $cache & """" & @TAB & @HOUR & ":" & @MIN)
		GUICtrlSetData($ed_Chat, "")
	Else
		HotKeys(0x1)
	EndIf
EndFunc   ;==>SendTxt

Func terminate()
	Local $hFile = FileOpen(@ScriptDir & "\http\htdocs\chat\Chat_" & StringReplace($date, "/", "") & ".txt", 1)
	HotKeySet("{ENTER}")
	FileWrite($hFile, GUICtrlRead($ed_History) & @CRLF)
	FileClose($hFile)
	Exit
EndFunc   ;==>terminate
