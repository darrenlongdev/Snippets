; Partly ported from a JavaScript by Jurgen Giesen

Local $iLong = Number("0.000000001") ; If calculating longditude by W instead of E we precede value with -, here we are using 0 for grenwhich

Local $aUTCTime = UTCTimeArr()
Local $sJulianTime = Julian($aUTCTime[2], $aUTCTime[0], $aUTCTime[1] + ($aUTCTime[3] / 24.0) + ($aUTCTime[4] / 1440) + ($aUTCTime[5] / 86400))

MsgBox(0x0, "DEBUG", SideRealTime($sJulianTime, $iLong))

Func UTCTimeArr()
	Local $tSystTime, $aInfo[6]
	$tSystTime = DllStructCreate("struct;word Year;word Month;word Dow;word Day;word Hour;word Minute;word Second;endstruct")
	DllCall("kernel32.dll", "none", "GetSystemTime", "struct*", $tSystTime)
	$aInfo[0] = DllStructGetData($tSystTime, "Month")
	$aInfo[1] = DllStructGetData($tSystTime, "Day")
	$aInfo[2] = DllStructGetData($tSystTime, "Year")
	$aInfo[3] = DllStructGetData($tSystTime, "Hour")
	$aInfo[4] = DllStructGetData($tSystTime, "Minute")
	$aInfo[5] = DllStructGetData($tSystTime, "Second")
	Return $aInfo
EndFunc   ;==>UTCTimeStr

Func Julian($year, $month, $day)
	Local $a, $b, $c, $e
	If $month < 3 Then
		$year -= 1
		$month += 12
	EndIf
	If ($year > 1582 Or ($year = 1582 And $month > 10) Or ($year = 1582 And $month = 10 And $day > 15)) Then
		$a = ($year / 100)
		$b = Int(2 - $a + $a / 4)
	EndIf
	$c = Int(365.25 * $year)
	$e = Int(30.6001 * ($month + 1))
	Return $b + $c + $e + $day + 1720994.5
EndFunc   ;==>Julian

Func frac($x)
	$x = $x - Floor($x)
	If ($x < 0) Then $x = $x + 1.0
	Return $x
EndFunc   ;==>frac

Func SideRealTime($jd, $iLongitude)
	Local $t_eph, $ut, $MJD0, $MJD, $GMST, $LMST, $h, $min, $secs, $str
	$MJD = $jd - 2400000.5
	$MJD0 = Floor($MJD)
	$ut = ($MJD - $MJD0) * 24.0
	$t_eph = ($MJD0 - 51544.5) / 36525.0
	$GMST = 6.697374558 + 1.0027379093 * $ut + (8640184.812866 + (0.093104 - 0.0000062 * $t_eph) * $t_eph) * $t_eph / 3600.0
	$LMST = 24.0 * frac(($GMST + $iLongitude / 15.0) / 24.0)
	$h = Floor($LMST)
	$min = Floor(60.0 * frac($LMST))
	$secs = Round(60.0 * (60.0 * frac($LMST) - $min))
	If ($min >= 10) Then
		$str = $h & ":" & $min
	Else
		$str = $h & ":0" & $min
	EndIf
	If ($secs < 10) Then
		$str = $str & ":0" & $secs
	Else
		$str = $str & ":" & $secs
	EndIf
	Return " " & $str
EndFunc   ;==>SideRealTime
