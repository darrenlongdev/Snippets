#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#Au3Stripper_Parameters=/pe /sf /sv
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; Flight Management System - unmanned flight computer written by Darren Long based on NASA opensource FMS

; PI Start
Global Const $pi = 3.141592653589793238462643383279502884197 & _
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

;FMS Variables
Local Const $iRefreshRate = 100 ; Used to set delay between each program cycle
Local Const $afmsState = ["IDLE", "TAKEOFF", "CLIMB", "CRUISE", "DESCEND", "LAND", "TERMINATE"]
Local $sFmsStatus, $iFmsState = 0 ;IDLE

; Mission Waypoint
Local $iMissionlat, $iMissionlon, $iMissionalt ; Use to set mission waypoint

; Aircraft Data
Local $iRoll, $iPitch, $iYaw, $iHeading, $iLat, $iLon, $iAlt
Local $bReset = False

While $bReset = False
	$sFmsStatus = FlightManagement()
	ConsoleWrite($sFmsStatus)
	Sleep($iRefreshRate)
WEnd

If $bReset = True Then
	RestartScript()
EndIf

Func FlightManagement()
	Local Const $hTimer = TimerInit() ; Begin the timer
	Local $sRtn

	;Update Aircraft Data
	$iRoll = $iRoll * 180 / $pi
	$iPitch = $iPitch * 180 / $pi
	$iYaw = $iYaw * 180 / $pi
	If ($iHeading < 0) Then
		$iHeading = 360 + $iHeading
	EndIf
	$iLat = $iLat / 1.0E7
	$iLon = $iLon / 1.0E7
	$iAlt = $iAlt / 1.0E3

	;Check Mission Waypoint Reached
	If ($iLat = $iMissionlat) And ($iLon = $iMissionlon) And ($iAlt = $iMissionalt) Then
		$sRtn &= "MISSION WAYPOINT REACHED" & @CRLF
	EndIf

	;Check Reset Flag
	If $bReset = True Then
		$sRtn &= "RESET" & @CRLF
	EndIf

	$sRtn &= "State: "
	Switch $iFmsState ; Used to perform actions depending on setting of Flight Management System
		Case 0 ; Idle
			$sRtn &= $afmsState[0] & @CRLF
		Case 1 ; Takeoff
			$sRtn &= $afmsState[1] & @CRLF
		Case 2 ; Climb
			$sRtn &= $afmsState[2] & @CRLF
		Case 3 ; Cruise
			$sRtn &= $afmsState[3] & @CRLF
		Case 4 ; Descend
			$sRtn &= $afmsState[4] & @CRLF
		Case 5 ; Land
			$sRtn &= $afmsState[5] & @CRLF
		Case 6 ; Terminate
			$sRtn &= $afmsState[6] & @CRLF
			Exit
	EndSwitch

	Return $sRtn & "Execution Time: " & TimerDiff($hTimer) & @CRLF
EndFunc   ;==>FlightManagement

Func RestartScript()
	If @Compiled = 1 Then
		Run(FileGetShortName(@ScriptFullPath))
	Else
		Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
	EndIf
	Exit
EndFunc   ;==>RestartScript
