; #FUNCTION# ====================================================================================================================
; Name ..........: map
; Description ...: Re-maps a number from one range to another. That is, a value of fromLow would get mapped to toLow, a value of
;                  fromHigh to toHigh, values in-between to values in-between, etc.
;                  Note that the "lower bounds" of either range may be larger or smaller than the "upper bounds" so the map()
;                  function may be used to reverse a range of numbers. The function can also handle negative numbers.
; Syntax ........: map($x, $inMin, $inMax, $outMin, $outMax)
; Parameters ....: $x                   - Input value to be re-mapped.
;                  $inMin               - The minimum possible input value.
;                  $inMax               - The maximum possible input value.
;                  $outMin              - The minimum desired output value.
;                  $outMax              - The maximum desired output value.
; Return values .: The mapped value
; ===============================================================================================================================
Func map($x, $inMin, $inMax, $outMin, $outMax)
	Return ($x - $inMin) * ($outMax - $outMin) / ($inMax - $inMin) + $outMin
EndFunc   ;==>map

; Example
MsgBox(0x0, "", map(50, 0, 100, 200, 100))
