; partly ported from a JavaScript by Keith Burnett

Global Const $fRad = 0.0174532925
Global $quadout[5]
Global $SunMoonOutStr = ""

Local $y, $m, $day, $glong, $glat, $tz, $mj, $sollun_out[11]

$y = @YEAR
$m = @MON
$day = @MDAY

$glong = 0.441090
$glat = 51.283859
$tz = TZInfo()
$mj = mjd($day, $m, $y, 0)
find_sun_and_twi_events_for_date($mj, $tz, $glong, $glat)
find_moonrise_set($mj, $tz, $glong, $glat)
$sollun_out = StringSplit($SunMoonOutStr, " ", 2)

MsgBox(0x0, "OUTPUT - Full String", $SunMoonOutStr)
MsgBox(0x0, "OUTPUT - Sun Rise", StringLeft($sollun_out[1], 2) & ":" & StringRight($sollun_out[1], 2))
MsgBox(0x0, "OUTPUT - Sun Set", StringLeft($sollun_out[2], 2) & ":" & StringRight($sollun_out[2], 2))
MsgBox(0x0, "OUTPUT - Moon Rise", StringLeft($sollun_out[9], 2) & ":" & StringRight($sollun_out[9], 2))
MsgBox(0x0, "OUTPUT - Moon Set", StringLeft($sollun_out[10], 2) & ":" & StringRight($sollun_out[10], 2))

$SunMoonOutStr = "" ; Reset for next use

Func TZInfo()
	Local Const $tTimeZone = DllStructCreate("struct;long Bias;wchar StdName[32];word StdDate[8];long StdBias;wchar DayName[32];word DayDate[8];long DayBias;endstruct")
	Local $aResult = DllCall("kernel32.dll", "dword", "GetTimeZoneInformation", "struct*", $tTimeZone)
	Local $aInfo[3]
	$aInfo[0] = $aResult[0]
	$aInfo[1] = DllStructGetData($tTimeZone, "Bias")
	If $aInfo[0] = 2 Then
		$aInfo[2] = 1
	Else
		$aInfo[2] = 0
	EndIf
	Return ($aInfo[1] / 60) + $aInfo[2]
EndFunc   ;==>TZInfo
Func hrsmin($hours)
	Local $hrs, $h, $m, $dum
	$hrs = Floor($hours * 60 + 0.5) / 60
	$h = Floor($hrs)
	$m = Floor(60 * ($hrs - $h) + 0.5)
	$dum = $h * 100 + $m
	If ($dum < 1000) Then $dum = "0" & $dum
	If ($dum < 100) Then $dum = "0" & $dum
	If ($dum < 10) Then $dum = "0" & $dum
	Return $dum
EndFunc   ;==>hrsmin
Func ipart($x)
	Local $a
	If ($x > 0) Then
		$a = Floor($x)
	Else
		$a = Ceiling($x)
	EndIf
	Return $a
EndFunc   ;==>ipart
Func frac($x)
	$x = $x - Floor($x)
	If ($x < 0) Then $x = $x + 1.0
	Return $x
EndFunc   ;==>frac
Func range($x)
	Local $a, $b
	$b = $x / 360
	$a = 360 * ($b - ipart($b))
	If ($a < 0) Then
		$a = $a + 360
	EndIf
	Return $a
EndFunc   ;==>range
Func mjd($day, $month, $year, $hour)
	Local $a, $b
	If ($month <= 2) Then
		$month = $month + 12
		$year = $year - 1
	EndIf
	$a = 10000 * $year + 100 * $month + $day
	If ($a <= 15821004.1) Then
		$b = -2 * Floor(($year + 4716) / 4) - 1179
	Else
		$b = Floor($year / 400) - Floor($year / 100) + Floor($year / 4)
	EndIf
	$a = 365 * $year - 679004
	Return ($a + $b + Floor(30.6001 * ($month + 1)) + $day + $hour / 24)
EndFunc   ;==>mjd
Func quad($ym, $yz, $yp)
	Local $nz, $a, $b, $c, $dis, $dx, $xe, $ye, $z1, $z2, $nz
	$nz = 0
	$a = 0.5 * ($ym + $yp) - $yz
	$b = 0.5 * ($yp - $ym)
	$c = $yz
	$xe = -$b / (2 * $a)
	$ye = ($a * $xe + $b) * $xe + $c
	$dis = $b * $b - 4 * $a * $c
	If ($dis > 0) Then
		$dx = 0.5 * Sqrt($dis) / Abs($a)
		$z1 = $xe - $dx
		$z2 = $xe + $dx
		If (Abs($z1) <= 1) Then $nz += 1
		If (Abs($z2) <= 1) Then $nz += 1
		If ($z1 < -1) Then $z1 = $z2
	EndIf
	$quadout[0] = $nz
	$quadout[1] = $z1
	$quadout[2] = $z2
	$quadout[3] = $xe
	$quadout[4] = $ye
	Return $quadout
EndFunc   ;==>quad
Func lmst($mjd, $glong)
	Local $lst, $t, $d
	$d = $mjd - 51544.5
	$t = $d / 36525
	$lst = range(280.46061837 + 360.98564736629 * $d + 0.000387933 * $t * $t - $t * $t * $t / 38710000)
	Return ($lst / 15 + $glong / 15)
EndFunc   ;==>lmst
Func minisun($t)
	Local $p2 = 6.283185307, $coseps = 0.91748, $sineps = 0.39778
	Local $L, $m, $DL, $SL, $x, $y, $Z, $RHO, $ra, $dec
	Local $suneq[3]
	$suneq[0] = ""
	$m = $p2 * frac(0.993133 + 99.997361 * $t)
	$DL = 6893 * Sin($m) + 72 * Sin(2 * $m)
	$L = $p2 * frac(0.7859453 + $m / $p2 + (6191.2 * $t + $DL) / 1296000)
	$SL = Sin($L)
	$x = Cos($L)
	$y = $coseps * $SL
	$Z = $sineps * $SL
	$RHO = Sqrt(1 - $Z * $Z)
	$dec = (360 / $p2) * ATan($Z / $RHO)
	$ra = (48 / $p2) * ATan($y / ($x + $RHO))
	If ($ra < 0) Then $ra += 24
	$suneq[1] = $dec
	$suneq[2] = $ra
	Return $suneq
EndFunc   ;==>minisun
Func minimoon($t)
	Local $p2 = 6.283185307, $arc = 206264.8062, $coseps = 0.91748, $sineps = 0.39778
	Local $L0, $L, $LS, $f, $d, $h, $S, $N, $DL, $CB, $L_moon, $B_moon, $V, $W, $x, $y, $Z, $RHO
	Local $mooneq[3]
	$mooneq[0] = ""
	$L0 = frac(0.606433 + 1336.855225 * $t)
	$L = $p2 * frac(0.374897 + 1325.552410 * $t)
	$LS = $p2 * frac(0.993133 + 99.997361 * $t)
	$d = $p2 * frac(0.827361 + 1236.853086 * $t)
	$f = $p2 * frac(0.259086 + 1342.227825 * $t)
	$DL = 22640 * Sin($L)
	$DL += -4586 * Sin($L - 2 * $d)
	$DL += +2370 * Sin(2 * $d)
	$DL += +769 * Sin(2 * $L)
	$DL += -668 * Sin($LS)
	$DL += -412 * Sin(2 * $f)
	$DL += -212 * Sin(2 * $L - 2 * $d)
	$DL += -206 * Sin($L + $LS - 2 * $d)
	$DL += +192 * Sin($L + 2 * $d)
	$DL += -165 * Sin($LS - 2 * $d)
	$DL += -125 * Sin($d)
	$DL += -110 * Sin($L + $LS)
	$DL += +148 * Sin($L - $LS)
	$DL += -55 * Sin(2 * $f - 2 * $d)
	$S = $f + ($DL + 412 * Sin(2 * $f) + 541 * Sin($LS)) / $arc
	$h = $f - 2 * $d
	$N = -526 * Sin($h)
	$N += +44 * Sin($L + $h)
	$N += -31 * Sin(-$L + $h)
	$N += -23 * Sin($LS + $h)
	$N += +11 * Sin(-$LS + $h)
	$N += -25 * Sin(-2 * $L + $f)
	$N += +21 * Sin(-$L + $f)
	$L_moon = $p2 * frac($L0 + $DL / 1296000)
	$B_moon = (18520 * Sin($S) + $N) / $arc
	$CB = Cos($B_moon)
	$x = $CB * Cos($L_moon)
	$V = $CB * Sin($L_moon)
	$W = Sin($B_moon)
	$y = $coseps * $V - $sineps * $W
	$Z = $sineps * $V + $coseps * $W
	$RHO = Sqrt(1 - $Z * $Z)
	$dec = (360 / $p2) * ATan($Z / $RHO)
	$ra = (48 / $p2) * ATan($y / ($x + $RHO))
	If ($ra < 0) Then $ra += 24
	$mooneq[1] = $dec
	$mooneq[2] = $ra
	Return $mooneq
EndFunc   ;==>minimoon
Func sin_alt($iobj, $mjd0, $hour, $glong, $cglat, $sglat)
	Local $mjd, $t, $ra, $dec, $tau, $salt
	Local $objpos[3]
	$objpos[0] = ""
	$mjd = $mjd0 + $hour / 24
	$t = ($mjd - 51544.5) / 36525
	If ($iobj == 1) Then
		$objpos = minimoon($t)
	Else
		$objpos = minisun($t)
	EndIf
	$ra = $objpos[2]
	$dec = $objpos[1]
	$tau = 15 * (lmst($mjd, $glong) - $ra)
	$salt = $sglat * Sin($fRad * $dec) + $cglat * Cos($fRad * $dec) * Cos($fRad * $tau)
	Return $salt
EndFunc   ;==>sin_alt
Func find_sun_and_twi_events_for_date($mjd, $tz, $glong, $glat)
	Local $sglong, $sglat, $date, $ym, $yz, $above, $utrise, $utset, $j
	Local $yp, $nz, $rise, $sett, $hour, $z1, $z2, $iobj
	$quadout[0] = ""
	Local $sinho[4]
	Local $always_up = " ****"
	Local $always_down = " ...."
	$sinho[0] = Sin($fRad * -0.833)
	$sinho[1] = Sin($fRad * -6)
	$sinho[2] = Sin($fRad * -12)
	$sinho[3] = Sin($fRad * -18)
	$sglat = Sin($fRad * $glat)
	$cglat = Cos($fRad * $glat)
	$date = $mjd - $tz / 24
	For $j = 0 To 3
		$rise = False
		$sett = False
		$above = False
		$hour = 1
		$ym = sin_alt(2, $date, $hour - 1, $glong, $cglat, $sglat) - $sinho[$j]
		If ($ym > 0) Then $above = True
		While ($hour < 25 And ($sett == False Or $rise == False))
			$yz = sin_alt(2, $date, $hour, $glong, $cglat, $sglat) - $sinho[$j]
			$yp = sin_alt(2, $date, $hour + 1, $glong, $cglat, $sglat) - $sinho[$j]
			$quadout = quad($ym, $yz, $yp)
			$nz = $quadout[0]
			$z1 = $quadout[1]
			$z2 = $quadout[2]
			$xe = $quadout[3]
			$ye = $quadout[4]
			If ($nz == 1) Then
				If ($ym < 0) Then
					$utrise = $hour + $z1
					$rise = True
				Else
					$utset = $hour + $z1
					$sett = True
				EndIf
			EndIf
			If ($nz == 2) Then
				If ($ye < 0) Then
					$utrise = $hour + $z2
					$utset = $hour + $z1
				Else
					$utrise = $hour + $z1
					$utset = $hour + $z2
				EndIf
			EndIf
			$ym = $yp
			$hour += 2
		WEnd
		If ($rise == True Or $sett == True) Then
			If ($rise == True) Then
				$SunMoonOutStr &= " " & hrsmin($utrise)
			Else
				$SunMoonOutStr &= " ----"
			EndIf
			If ($sett == True) Then
				$SunMoonOutStr &= " " & hrsmin($utset)
			Else
				$SunMoonOutStr &= " ----"
			EndIf
		Else
			If ($above == True) Then
				$SunMoonOutStr &= $always_up & $always_up
			Else
				$SunMoonOutStr &= $always_down & $always_down
			EndIf
		EndIf
	Next
	Return $SunMoonOutStr
EndFunc   ;==>find_sun_and_twi_events_for_date
Func find_moonrise_set($mjd, $tz, $glong, $glat)
	Local $sglong, $sglat, $date, $ym, $yz, $above, $utrise, $utset, $j
	Local $yp, $nz, $rise, $sett, $hour, $z1, $z2, $iobj
	$quadout[0] = ""
	Local $sinho
	Local $always_up = " ****"
	Local $always_down = " ...."
	$sinho = Sin($fRad * 8 / 60)
	$sglat = Sin($fRad * $glat)
	$cglat = Cos($fRad * $glat)
	$date = $mjd - $tz / 24
	$rise = False
	$sett = False
	$above = False
	$hour = 1
	$ym = sin_alt(1, $date, $hour - 1, $glong, $cglat, $sglat) - $sinho
	If ($ym > 0) Then $above = True
	While ($hour < 25 And ($sett == False Or $rise == False))
		$yz = sin_alt(1, $date, $hour, $glong, $cglat, $sglat) - $sinho
		$yp = sin_alt(1, $date, $hour + 1, $glong, $cglat, $sglat) - $sinho
		$quadout = quad($ym, $yz, $yp)
		$nz = $quadout[0]
		$z1 = $quadout[1]
		$z2 = $quadout[2]
		$xe = $quadout[3]
		$ye = $quadout[4]
		If ($nz == 1) Then
			If ($ym < 0) Then
				$utrise = $hour + $z1
				$rise = True
			Else
				$utset = $hour + $z1
				$sett = True
			EndIf
		EndIf
		If ($nz == 2) Then
			If ($ye < 0) Then
				$utrise = $hour + $z2
				$utset = $hour + $z1
			Else
				$utrise = $hour + $z1
				$utset = $hour + $z2
			EndIf
		EndIf
		$ym = $yp
		$hour += 2
	WEnd
	If ($rise == True Or $sett == True) Then
		If ($rise == True) Then
			$SunMoonOutStr &= " " & hrsmin($utrise)
		Else
			$SunMoonOutStr &= " ----"
		EndIf
		If ($sett == True) Then
			$SunMoonOutStr &= " " & hrsmin($utset)
		Else
			$SunMoonOutStr &= " ----"
		EndIf
	Else
		If ($above == True) Then
			$SunMoonOutStr &= $always_up & $always_up
		Else
			$SunMoonOutStr &= $always_down & $always_down
		EndIf
	EndIf
	Return $SunMoonOutStr
EndFunc   ;==>find_moonrise_set
