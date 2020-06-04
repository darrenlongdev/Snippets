Global Const $tagSYSTEMTIME = "struct;word Year;word Month;word Dow;word Day;word Hour;word Minute;word Second;word MSeconds;endstruct"

Local $tCur, $tNew, $temp
$tCur = _Date_Time_GetSystemTime()
$Form1 = GUICreate("Set Time and Date", 274, 120, 192, 124)
$Date1 = GUICtrlCreateDate(@YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC, 24, 16, 234, 21, 0)
$Input1 = GUICtrlCreateInput(@HOUR, 24, 48, 73, 21)
$Input2 = GUICtrlCreateInput(@MIN, 104, 48, 73, 21)
$Input3 = GUICtrlCreateInput(@SEC, 184, 48, 73, 21)
$Button1 = GUICtrlCreateButton("Set", 184, 80, 75, 25)
$Button2 = GUICtrlCreateButton("Restore", 100, 80, 75, 25)
GUISetState(@SW_SHOW)
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case -3
			Exit
		Case $Button1
			$temp = GUICtrlRead($Date1)
			$tNew = _Date_Time_EncodeSystemTime(StringLeft($temp, 2), StringMid($temp, 4, 2), StringRight($temp, 4), GUICtrlRead($Input1), GUICtrlRead($Input2), GUICtrlRead($Input3))
			If Not _Date_Time_SetSystemTime($tNew) Then
				MsgBox(4096, "Error", "System clock cannot be SET" & @CRLF & @CRLF & _WinAPI_GetLastErrorMessage())
				Exit
			EndIf
			$tNew = _Date_Time_GetSystemTime()
		Case $Button2
			_Date_Time_SetSystemTime($tCur)
	EndSwitch
WEnd

Func _WinAPI_FormatMessage($iFlags, $pSource, $iMessageID, $iLanguageID, ByRef $pBuffer, $iSize, $vArguments)
	Local $sBufferType = "struct*"
	If IsString($pBuffer) Then $sBufferType = "wstr"
	Local $aResult = DllCall("kernel32.dll", "dword", "FormatMessageW", "dword", $iFlags, "struct*", $pSource, "dword", $iMessageID, "dword", $iLanguageID, $sBufferType, $pBuffer, "dword", $iSize, "ptr", $vArguments)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, 0)
	If $sBufferType = "wstr" Then $pBuffer = $aResult[5]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_FormatMessage
Func _WinAPI_GetLastError(Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
	Local $aResult = DllCall("kernel32.dll", "dword", "GetLastError")
	Return SetError($_iCurrentError, $_iCurrentExtended, $aResult[0])
EndFunc   ;==>_WinAPI_GetLastError
Func _WinAPI_GetLastErrorMessage(Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
	Local $iLastError = _WinAPI_GetLastError()
	Local $tBufferPtr = DllStructCreate("ptr")
	Local $nCount = _WinAPI_FormatMessage(BitOR(0x00000100, 0x00001000), 0, $iLastError, 0, $tBufferPtr, 0, 0)
	If @error Then Return SetError(-@error, @extended, "")
	Local $sText = ""
	Local $pBuffer = DllStructGetData($tBufferPtr, 1)
	If $pBuffer Then
		If $nCount > 0 Then
			Local $tBuffer = DllStructCreate("wchar[" & ($nCount + 1) & "]", $pBuffer)
			$sText = DllStructGetData($tBuffer, 1)
			If StringRight($sText, 2) = @CRLF Then $sText = StringTrimRight($sText, 2)
		EndIf
		DllCall("kernel32.dll", "handle", "LocalFree", "handle", $pBuffer)
	EndIf
	Return SetError($_iCurrentError, $_iCurrentExtended, $sText)
EndFunc   ;==>_WinAPI_GetLastErrorMessage
Func _Date_Time_EncodeSystemTime($iMonth, $iDay, $iYear, $iHour = 0, $iMinute = 0, $iSecond = 0, $iMSeconds = 0)
	Local $tSYSTEMTIME = DllStructCreate($tagSYSTEMTIME)
	DllStructSetData($tSYSTEMTIME, "Month", $iMonth)
	DllStructSetData($tSYSTEMTIME, "Day", $iDay)
	DllStructSetData($tSYSTEMTIME, "Year", $iYear)
	DllStructSetData($tSYSTEMTIME, "Hour", $iHour)
	DllStructSetData($tSYSTEMTIME, "Minute", $iMinute)
	DllStructSetData($tSYSTEMTIME, "Second", $iSecond)
	DllStructSetData($tSYSTEMTIME, "MSeconds", $iMSeconds)
	Return $tSYSTEMTIME
EndFunc   ;==>_Date_Time_EncodeSystemTime
Func _Date_Time_GetSystemTime()
	Local $tSystTime = DllStructCreate($tagSYSTEMTIME)
	DllCall("kernel32.dll", "none", "GetSystemTime", "struct*", $tSystTime)
	If @error Then Return SetError(@error, @extended, 0)
	Return $tSystTime
EndFunc   ;==>_Date_Time_GetSystemTime
Func _Date_Time_SetSystemTime($tSYSTEMTIME)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetSystemTime", "struct*", $tSYSTEMTIME)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_Date_Time_SetSystemTime
