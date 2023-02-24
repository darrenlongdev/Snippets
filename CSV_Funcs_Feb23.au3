; #FUNCTION# ====================================================================================================================
; Name ..........: GenColNames
; Description ...: Creates Global variables named after Excel column names containing relevant row number
; ...............: As an example of usage MsgBox(0x0, "", $ZZ) will provide the column number for cell ZZ.
; Syntax ........: GenColNames()
; Return values .: None
; ===============================================================================================================================
Func GenColNames()
	Local $sLetters, $aAlpha, $i = 0
	; Create string and split into individual column names.
	For $a = Asc("A") To Asc("Z")
		$sLetters &= Chr($a) & ","
	Next
	For $a = Asc("A") To Asc("Z")
		For $b = Asc("A") To Asc("Z")
			$sLetters &= Chr($a) & Chr($b) & ","
		Next
	Next
	$aAlpha = StringSplit(StringTrimRight($sLetters, 1), ",", 2)
	; Create variables named after Excel column names containing array row numbers.
	While $i <= UBound($aAlpha) - 1
		Assign($aAlpha[$i], $i, 2)
		$i += 1
	WEnd
	; =============================================================================================================================
EndFunc   ;==>GenColNames

; #FUNCTION# ====================================================================================================================
; Name ..........: CSVCountLines
; Description ...: Return the amount of lines in a file
; Syntax ........: CSVCountLines($sFilePath)
; Parameters ....: $sFilePath - The file path.
; Return values .: integer value
; ===============================================================================================================================
Func CSVCountLines($sFilePath)
	FileReadToArray($sFilePath)
	If @error Then Return SetError(@error, @extended, 0)
	Return @extended
EndFunc   ;==>CSVCountLines

; #FUNCTION# ====================================================================================================================
; Name ..........: CSVStringToArray
; Description ...: Take a comma & @CRLF deliminated string and convert to a 2d array
; Syntax ........: CSVStringToArray($sString[, $sDelimiters = '[, $sQuote = '"']])
; Parameters ....: $sString             - a string value.
;                  $sDelimiters         - [optional] a string value. Default is '.
;                  $sQuote              - [optional] a string value. Default is '"'.
; Return values .: Array
; ===============================================================================================================================
Func CSVStringToArray($sString, $sDelimiters = ',;', $sQuote = '"')
	If $sDelimiters = "" Or IsKeyword($sDelimiters) Then $sDelimiters = ',;'
	If $sQuote = "" Or IsKeyword($sQuote) Then $sQuote = '"'
	$sQuote = StringLeft($sQuote, 1)
	Local $srDelimiters = StringRegExpReplace($sDelimiters, '[\\\^\-\[\]]', '\\\0')
	Local $srQuote = StringRegExpReplace($sQuote, '[\\\^\-\[\]]', '\\\0')
	Local $sPattern = StringReplace(StringReplace('(?m)(?:^|[,])\h*(["](?:[^"]|["]{2})*["]|[^,\r\n]*)(\v+)?', ',', $srDelimiters, 0, 1), '"', $srQuote, 0, 1)
	Local $aREgex = StringRegExp($sString, $sPattern, 3)
	If @error Then Return SetError(2, @error, 0)
	$sString = ''
	Local $iBound = UBound($aREgex), $iIndex = 0, $iSubBound = 1, $iSub = 0
	Local $aResult[$iBound][$iSubBound]
	For $i = 0 To $iBound - 1
		If $iSub = $iSubBound Then
			$iSubBound += 1
			ReDim $aResult[$iBound][$iSubBound]
		EndIf
		Select
			Case StringLen($aREgex[$i]) < 3 And StringInStr(@CRLF, $aREgex[$i])
				$iIndex += 1
				$iSub = 0
				ContinueLoop
			Case StringLeft(StringStripWS($aREgex[$i], 1), 1) = $sQuote
				$aREgex[$i] = StringStripWS($aREgex[$i], 3)
				$aResult[$iIndex][$iSub] = StringReplace(StringMid($aREgex[$i], 2, StringLen($aREgex[$i]) - 2), $sQuote & $sQuote, $sQuote, 0, 1)
			Case Else
				$aResult[$iIndex][$iSub] = $aREgex[$i]
		EndSelect
		$aREgex[$i] = 0
		$iSub += 1
	Next
	If $iIndex = 0 Then $iIndex = 1
	ReDim $aResult[$iIndex][$iSubBound]
	Return $aResult
EndFunc   ;==>CSVStringToArray

; #FUNCTION# ====================================================================================================================
; Name ..........: CSVStringFromArray
; Description ...: Create a comma & @CRLF seperated string from array
; Syntax ........: CSVStringFromArray(Const Byref $aData[, $sDelimiter = '[, $sQuote = '"']])
; Parameters ....: $aData               - [in/out and const] an array of unknowns.
;                  $sDelimiter          - [optional] a string value. Default is '.
;                  $sQuote              - [optional] a string value. Default is '"'.
; Return values .: String value
; ===============================================================================================================================
Func CSVStringFromArray(Const ByRef $aData, $sDelimiter = ',', $sQuote = '"')
	Local $sStream
	If $sDelimiter = "" Or IsKeyword($sDelimiter) Then $sDelimiter = ','
	If $sQuote = "" Or IsKeyword($sQuote) Then $sQuote = '"'
	Local $iBound = UBound($aData, 1), $iSubBound = UBound($aData, 2)
	If Not $iSubBound Then Return SetError(2, 0, 0)
	For $i = 0 To $iBound - 1
		For $j = 0 To $iSubBound - 1
			$sStream &= $sQuote & StringReplace($aData[$i][$j], $sQuote, $sQuote & $sQuote, 0, 1) & $sQuote
			If $j < $iSubBound - 1 Then $sStream &= $sDelimiter
		Next
		$sStream &= @CRLF
	Next
	Return $sStream
EndFunc   ;==>CSVStringFromArray

; #FUNCTION# ====================================================================================================================
; Name ..........: ReadCell
; Description ...: Read cell data
; Syntax ........: ReadCell(Byref $aData, $sCol, $sRow)
; Parameters ....: $aData               - [in/out] an array of unknowns.
;                  $sCol                - a string value.
;                  $sRow                - a string value.
; Return values .: String
; ===============================================================================================================================
Func ReadCell(ByRef $aData, $sCol, $sRow)
	If IsString($sCol) Then
		$sCol = Eval($sCol)
	ElseIf IsInt($sCol) Then
		$sCol -= 1
	EndIf
	If IsString($sRow) Then $sRow = Int($sRow)
	$sRow -= 1
	Return $aData[$sRow][$sCol]
EndFunc   ;==>ReadCell

; #FUNCTION# ====================================================================================================================
; Name ..........: WriteCell
; Description ...: Write value to cell (2d array)
; Syntax ........: WriteCell(Byref $aData, $sCol, $sRow, $sData)
; Parameters ....: $aData               - [in/out] an array of unknowns.
;                  $sCol                - a string value.
;                  $sRow                - a string value.
;                  $sData               - a string value.
; Return values .: None
; ===============================================================================================================================
Func WriteCell(ByRef $aData, $sCol, $sRow, $sData)
	If IsString($sCol) Then
		$sCol = Eval($sCol)
	ElseIf IsInt($sCol) Then
		$sCol -= 1
	EndIf
	If IsString($sRow) Then $sRow = Int($sRow)
	$sRow -= 1
	$aData[$sRow][$sCol] = $sData
	Return 1
EndFunc   ;==>WriteCell

; #FUNCTION# ====================================================================================================================
; Name ..........: CRLFtoComma
; Description ...: Converts line seperated data into comma seperated
; Syntax ........: CRLFtoComma($sFile)
; Parameters ....: $sFile - path to file to read, or a string value containing line feeds.
; ...............: $iRemoveBlanks - default is 1 to remove blanks, set to 0 to disable.
; Return values .: Comma seperated data
; ===============================================================================================================================
Func CRLFtoComma($sFile, $iRemoveBlanks = 1)
	Local $sOpen, $sRead
	If $sFile <> "" And FileExists($sFile) Then
		$sOpen = FileOpen($sFile, 0)
		If Not @error Then
			$sRead = FileRead($sOpen)
			FileClose($sOpen)
		Else
			SetError(1)
			Return ""
		EndIf
	Else
		$sRead = $sFile
	EndIf
	$sRead = StringReplace($sRead, @CRLF, ",")
	$sRead = StringReplace($sRead, @CR, ",")
	If $iRemoveBlanks = 1 Then $sRead = StringReplace($sRead, ",,", ",")
	Return $sRead
EndFunc   ;==>CRLFtoComma

; #FUNCTION# ====================================================================================================================
; Name ..........: CommatoCRLF
; Description ...: Converts comma seperated data into line seperated data
; Syntax ........: CRLFtoComma($sFile)
; Parameters ....: $sFile - path to file to read, or a string value containing line feeds.
; Return values .: Line seperated data
; ===============================================================================================================================
Func CommatoCRLF($sFile)
	Local $sOpen, $sRead
	If $sFile <> "" And FileExists($sFile) Then
		$sOpen = FileOpen($sFile, 0)
		If Not @error Then
			$sRead = FileRead($sOpen)
			FileClose($sOpen)
		Else
			SetError(1)
			Return ""
		EndIf
	Else
		$sRead = $sFile
	EndIf
	$sRead = StringReplace($sRead, ",", @CRLF)
	Return $sRead
EndFunc   ;==>CommatoCRLF

; #FUNCTION# ====================================================================================================================
; Name ..........: FileExt
; Syntax ........: FileExt($string)
; Parameters ....: $string              - a string value.
; ===============================================================================================================================
Func FileExt($string)
	Local $test = StringRegExp($string, "([.][a-z]+)", 3, 1)
	If UBound($test) >= 1 Then Return $test[0]
EndFunc   ;==>FileExt

; #FUNCTION# ====================================================================================================================
; Name ..........: PostCodeArea
; Description ...: Returns area code from a full Postcode
; ===============================================================================================================================
Func PostCodeArea($sString)
	Local $sTemp = $sString
	$sTemp = StringReplace($sTemp, ", GB", "") ; In our data we had some records with ,GB after the postcode
	$sTemp = StringReplace($sTemp, @TAB, "")
	$sTemp = StringReplace($sTemp, """", "")
	If StringLeft($sTemp, 1) = " " Then $sTemp = StringTrimLeft($sTemp, 1)
	$sTemp = StringLeft($sTemp, 2)
	If StringRegExp(StringRight($sTemp, 1), "^\d+(?:\.\d+)?$") Then $sTemp = StringTrimRight($sTemp, 1)
	Return $sTemp
EndFunc   ;==>PostCodeArea

; #FUNCTION# ====================================================================================================================
; Name ..........: UStoUKDate
; Description ...: Swaps month and day of US formated date
; ===============================================================================================================================
Func UStoUKDate($line)
	Return StringMid($line, 4, 2) & "\" & StringLeft($line, 2) & "\" & StringRight($line, 4)
EndFunc   ;==>UStoUKDate

; #FUNCTION# ====================================================================================================================
; Name ..........: IsIPAddress
; Description ...: Checks if a string is in the format of an IP Address
; Syntax ........: IsIPAddress($ip)
; Parameters ....: $ip - The IP Address to check
; Return values .: 1 if true, 0 if false
; ===============================================================================================================================
Func IsIPAddress($ip)
	If StringRegExp($ip, "^((25[0-5]|2[0-4]\d|1?\d?\d)\.){3}(25[0-5]|2[0-4]\d|1?\d?\d)$") Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>IsIPAddress

; #FUNCTION# ====================================================================================================================
; Name ..........: IsDate
; Syntax ........: IsDate($string)
; Parameters ....: $string              - a string value.
; Return values .: 0 or 1
; ===============================================================================================================================
Func IsDate($string)
	Local $test = StringRegExp($string, "\d{1,2}\/\d{1,2}\/\d{4}", 0)
	$test += StringRegExp($string, "\d{1,2}\/\d{1,2}\/\d{2}", 0)
	$test += StringRegExp($string, "(\d+)-(\d+)-(\d+)", 0)
	If $test > 0 Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>IsDate

; #FUNCTION# ====================================================================================================================
; Name ..........: GarbageRemove
; Description ...: Strips unwanted characters from a string returning a human English string
; Syntax ........: GarbageRemove($str)
; Parameters ....: $str - A string to be tidied
; Return values .: Formatted string in human English
; ===============================================================================================================================
Func GarbageRemove($str)
	Return StringRegExpReplace($str, "(?i)[^\w\h-\()^a-zA-Z0-9_\.\:\- ]+", "")
EndFunc   ;==>GarbageRemove

; #FUNCTION# ====================================================================================================================
; Name ..........: Map
; Description ...: Re-maps a number from one range to another. That is, a value of fromLow would get mapped to toLow, a value of
;                  fromHigh to toHigh, values in-between to values in-between, etc.
;                  Note that the "lower bounds" of either range may be larger or smaller than the "upper bounds" so the map()
;                  function may be used to reverse a range of numbers. The function can also handle negative numbers.
; Syntax ........: Map($x, $inMin, $inMax, $outMin, $outMax)
; Parameters ....: $x                   - Input value to be re-mapped.
;                  $inMin               - The minimum possible input value.
;                  $inMax               - The maximum possible input value.
;                  $outMin              - The minimum desired output value.
;                  $outMax              - The maximum desired output value.
; Return values .: The mapped value
; ===============================================================================================================================
Func Map($x, $inMin, $inMax, $outMin, $outMax)
	Return ($x - $inMin) * ($outMax - $outMin) / ($inMax - $inMin) + $outMin
EndFunc   ;==>Map

; #FUNCTION# ====================================================================================================================
; Name ..........: Average
; Description ...: Outputs the average of given values
; Syntax ........: Average($values)
; Parameters ....: $values              - Comma seperated values
; Return values .: Integer Average Value
; ===============================================================================================================================
Func Average($values)
	Local $Avalues = StringSplit($values, ",")
	Local $Asize = UBound($Avalues) - 1
	Local $total
	For $n = 1 To $Asize
		$total += $Avalues[$n]
	Next
	Return $total / $Asize
EndFunc   ;==>Average
