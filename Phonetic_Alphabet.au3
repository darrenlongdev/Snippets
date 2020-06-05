Local $sConvStr = InputBox("Phonetic Alphabet", "Enter the text to convert...", "Hello123. There")
Local $aConvStr = StringSplit($sConvStr, "", 2)
Local $sOut

For $i = 1 To UBound($aConvStr)
	Select
		Case $aConvStr[$i - 1] = "a"
			$sOut &= "Alpha "
		Case $aConvStr[$i - 1] = "b"
			$sOut &= "Bravo "
		Case $aConvStr[$i - 1] = "c"
			$sOut &= "Charlie "
		Case $aConvStr[$i - 1] = "d"
			$sOut &= "Delta "
		Case $aConvStr[$i - 1] = "e"
			$sOut &= "Echo "
		Case $aConvStr[$i - 1] = "f"
			$sOut &= "Foxtrot "
		Case $aConvStr[$i - 1] = "g"
			$sOut &= "Golf "
		Case $aConvStr[$i - 1] = "h"
			$sOut &= "Hotel "
		Case $aConvStr[$i - 1] = "i"
			$sOut &= "India "
		Case $aConvStr[$i - 1] = "j"
			$sOut &= "Juliet "
		Case $aConvStr[$i - 1] = "k"
			$sOut &= "Kilo "
		Case $aConvStr[$i - 1] = "l"
			$sOut &= "Lima "
		Case $aConvStr[$i - 1] = "m"
			$sOut &= "Mike "
		Case $aConvStr[$i - 1] = "n"
			$sOut &= "November "
		Case $aConvStr[$i - 1] = "o"
			$sOut &= "Oscar "
		Case $aConvStr[$i - 1] = "p"
			$sOut &= "Papa "
		Case $aConvStr[$i - 1] = "q"
			$sOut &= "Quebec "
		Case $aConvStr[$i - 1] = "r"
			$sOut &= "Romeo "
		Case $aConvStr[$i - 1] = "s"
			$sOut &= "Sierra "
		Case $aConvStr[$i - 1] = "t"
			$sOut &= "Tango "
		Case $aConvStr[$i - 1] = "u"
			$sOut &= "Uniform "
		Case $aConvStr[$i - 1] = "v"
			$sOut &= "Victor "
		Case $aConvStr[$i - 1] = "w"
			$sOut &= "Whisky "
		Case $aConvStr[$i - 1] = "x"
			$sOut &= "Xray "
		Case $aConvStr[$i - 1] = "y"
			$sOut &= "Yankee "
		Case $aConvStr[$i - 1] = "z"
			$sOut &= "Zulu "
		Case Else
			$sOut &= $aConvStr[$i - 1]
	EndSelect
Next

ConsoleWrite($sOut)
MsgBox(0x0, "Output", $sOut)
