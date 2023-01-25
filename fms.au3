; Flight Management System - unmanned flight computer written by Darren Long based on NASA opensource FMS

; PI Start
Global $pi = 3.141592653589793238462643383279502884197 & _
		16939937510582097494459230781640628620899 & _
		86280348253421170679821480865132823066470 & _
		93844609550582231725359408128481117450284 & _
		10270193852110555964462294895493038196442 & _
		88109756659334461284756482337867831652712 & _
		01909145648566923460348610454326648213393 & _
		60726024914127372458700660631558817488152 & _
		09209628292540917153643678925903600113305 & _
		30548820466521384146951941511609

; PI End

; Mission Waypoint
Local $Missionlat ; Use to set mission waypoint
Local $Missionlon ; Use to set mission waypoint
Local $Missionalt ; Use to set mission waypoint

; Aircraft Data
Local $roll, $pitch, $yaw, $heading
Local $lat, $lon, $alt
Local $reset = False

;FMS Variables
Local $RefreshRate = 100 ; Used to set delay between each program cycle
Local $fmsState = 0 ;IDLE
Local $afmsState[0]
_ArrayAdd($afmsState, "IDLE|TAKEOFF|CLIMB|CRUISE|DESCEND|LAND|TERMINATE", "|") ; 0-6

Func FlightManagement()
	Local $hTimer = TimerInit() ; Begin the timer

	;Update Aircraft Data
	$roll = $roll * 180 / $pi
	$pitch = $pitch * 180 / $pi
	$yaw = $yaw * 180 / $pi
	If ($heading < 0) Then
		$heading = 360 + $heading
	EndIf
	$lat = $lat / 1.0E7
	$lon = $lon / 1.0E7
	$alt = $alt / 1.0E3

	;Check Mission Waypoint Reached
	If ($lat = $Missionlat) And ($lon = $Missionlon) And ($alt = $Missionalt) Then
		ConsoleWrite("MISSION COMPLETE" & @CRLF)
	EndIf

	;Check Reset Flag
	If $reset = True Then
		ConsoleWrite("RESET" & @CRLF)
	EndIf

	Switch $fmsState ; Used to perform actions depending on setting of Flight Management System
		Case 0
			ConsoleWrite($afmsState[0] & @CRLF)
		Case 1
			ConsoleWrite($afmsState[1] & @CRLF)
		Case 2
			ConsoleWrite($afmsState[2] & @CRLF)
		Case 3
			ConsoleWrite($afmsState[3] & @CRLF)
		Case 4
			ConsoleWrite($afmsState[4] & @CRLF)
		Case 5
			ConsoleWrite($afmsState[5] & @CRLF)
		Case 6
			ConsoleWrite($afmsState[6] & @CRLF)
			Exit ; Terminate Program
	EndSwitch

	Local $fDiff = TimerDiff($hTimer)
	ConsoleWrite("Execution Time " & $fDiff)
EndFunc   ;==>FlightManagement

Func RestartScript()
	If @Compiled = 1 Then
		Run(FileGetShortName(@ScriptFullPath))
	Else
		Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
	EndIf
	Exit
EndFunc   ;==>RestartScript

While $reset = False
	FlightManagement()
	Sleep($RefreshRate)
WEnd

If $reset = True Then
	RestartScript()
EndIf

Func _ArrayAdd(ByRef $aArray, $vValue, $iStart = 0, $sDelim_Item = "|", $sDelim_Row = @CRLF, $iForce = 0)
	Local Enum $ARRAYFILL_FORCE_DEFAULT, $ARRAYFILL_FORCE_SINGLEITEM, $ARRAYFILL_FORCE_INT, $ARRAYFILL_FORCE_NUMBER, $ARRAYFILL_FORCE_PTR, $ARRAYFILL_FORCE_HWND, $ARRAYFILL_FORCE_STRING, $ARRAYFILL_FORCE_BOOLEAN
	If $iStart = Default Then $iStart = 0
	If $sDelim_Item = Default Then $sDelim_Item = "|"
	If $sDelim_Row = Default Then $sDelim_Row = @CRLF
	If $iForce = Default Then $iForce = $ARRAYFILL_FORCE_DEFAULT
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, 1)
	Local $hDataType = 0
	Switch $iForce
		Case $ARRAYFILL_FORCE_INT
			$hDataType = Int
		Case $ARRAYFILL_FORCE_NUMBER
			$hDataType = Number
		Case $ARRAYFILL_FORCE_PTR
			$hDataType = Ptr
		Case $ARRAYFILL_FORCE_HWND
			$hDataType = Hwnd
		Case $ARRAYFILL_FORCE_STRING
			$hDataType = String
		Case $ARRAYFILL_FORCE_BOOLEAN
			$hDataType = "Boolean"
	EndSwitch
	Switch UBound($aArray, 0)
		Case 1
			If $iForce = $ARRAYFILL_FORCE_SINGLEITEM Then
				ReDim $aArray[$iDim_1 + 1]
				$aArray[$iDim_1] = $vValue
				Return $iDim_1
			EndIf
			If IsArray($vValue) Then
				If UBound($vValue, 0) <> 1 Then Return SetError(5, 0, -1)
				$hDataType = 0
			Else
				Local $aTmp = StringSplit($vValue, $sDelim_Item, 2 + 1)
				If UBound($aTmp, 1) = 1 Then
					$aTmp[0] = $vValue
				EndIf
				$vValue = $aTmp
			EndIf
			Local $iAdd = UBound($vValue, 1)
			ReDim $aArray[$iDim_1 + $iAdd]
			For $i = 0 To $iAdd - 1
				If String($hDataType) = "Boolean" Then
					Switch $vValue[$i]
						Case "True", "1"
							$aArray[$iDim_1 + $i] = True
						Case "False", "0", ""
							$aArray[$iDim_1 + $i] = False
					EndSwitch
				ElseIf IsFunc($hDataType) Then
					$aArray[$iDim_1 + $i] = $hDataType($vValue[$i])
				Else
					$aArray[$iDim_1 + $i] = $vValue[$i]
				EndIf
			Next
			Return $iDim_1 + $iAdd - 1
		Case 2
			Local $iDim_2 = UBound($aArray, 2)
			If $iStart < 0 Or $iStart > $iDim_2 - 1 Then Return SetError(4, 0, -1)
			Local $iValDim_1, $iValDim_2 = 0, $iColCount
			If IsArray($vValue) Then
				If UBound($vValue, 0) <> 2 Then Return SetError(5, 0, -1)
				$iValDim_1 = UBound($vValue, 1)
				$iValDim_2 = UBound($vValue, 2)
				$hDataType = 0
			Else
				Local $aSplit_1 = StringSplit($vValue, $sDelim_Row, 2 + 1)
				$iValDim_1 = UBound($aSplit_1, 1)
				Local $aTmp[$iValDim_1][0], $aSplit_2
				For $i = 0 To $iValDim_1 - 1
					$aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, 2 + 1)
					$iColCount = UBound($aSplit_2)
					If $iColCount > $iValDim_2 Then
						$iValDim_2 = $iColCount
						ReDim $aTmp[$iValDim_1][$iValDim_2]
					EndIf
					For $j = 0 To $iColCount - 1
						$aTmp[$i][$j] = $aSplit_2[$j]
					Next
				Next
				$vValue = $aTmp
			EndIf
			If UBound($vValue, 2) + $iStart > UBound($aArray, 2) Then Return SetError(3, 0, -1)
			ReDim $aArray[$iDim_1 + $iValDim_1][$iDim_2]
			For $iWriteTo_Index = 0 To $iValDim_1 - 1
				For $j = 0 To $iDim_2 - 1
					If $j < $iStart Then
						$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
					ElseIf $j - $iStart > $iValDim_2 - 1 Then
						$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
					Else
						If String($hDataType) = "Boolean" Then
							Switch $vValue[$iWriteTo_Index][$j - $iStart]
								Case "True", "1"
									$aArray[$iWriteTo_Index + $iDim_1][$j] = True
								Case "False", "0", ""
									$aArray[$iWriteTo_Index + $iDim_1][$j] = False
							EndSwitch
						ElseIf IsFunc($hDataType) Then
							$aArray[$iWriteTo_Index + $iDim_1][$j] = $hDataType($vValue[$iWriteTo_Index][$j - $iStart])
						Else
							$aArray[$iWriteTo_Index + $iDim_1][$j] = $vValue[$iWriteTo_Index][$j - $iStart]
						EndIf
					EndIf
				Next
			Next
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
	Return UBound($aArray, 1) - 1
EndFunc   ;==>_ArrayAdd
