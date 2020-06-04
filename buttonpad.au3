#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>

Global $menArr1[3] = ["element 1", "element 2", "element 3"]
Global $cur = 0
Local Const $blk = 0x000000
Local Const $red = 0x961361

Opt("GUIOnEventMode", 1)

$Form1 = GUICreate("Control Pad", 346, 147, 192, 124)
GUISetBkColor(0xCFCECA)

$Input = GUICtrlCreateInput("", 16, 8, 313, 21)
GUICtrlSetData($Input, $menArr1[$cur])

$dPadhspt1 = GUICtrlCreateButton("", 46, 48, 30, 30)
GUICtrlSetBkColor($dPadhspt1, $blk)
$dPadhspt2 = GUICtrlCreateButton("", 16, 78, 30, 30)
GUICtrlSetBkColor($dPadhspt2, $blk)
$dPadhspt3 = GUICtrlCreateButton("", 76, 78, 30, 30)
GUICtrlSetBkColor($dPadhspt3, $blk)
$dPadhspt4 = GUICtrlCreateButton("", 46, 108, 30, 30)
GUICtrlSetBkColor($dPadhspt4, $blk)

$buttonA = GUICtrlCreateButton("", 224, 80, 44, 44)
GUICtrlSetBkColor($buttonA, $red)

$buttonB = GUICtrlCreateButton("", 286, 52, 44, 44)
GUICtrlSetBkColor($buttonB, $red)

GUISetState(@SW_SHOW)

GUICtrlSetOnEvent($dPadhspt1, "du")
GUICtrlSetOnEvent($dPadhspt2, "dl")
GUICtrlSetOnEvent($dPadhspt3, "dr")
GUICtrlSetOnEvent($dPadhspt4, "dd")
GUICtrlSetOnEvent($buttonA, "ba")
GUICtrlSetOnEvent($buttonB, "bb")
GUISetOnEvent($GUI_EVENT_CLOSE, "Close")

While 1
   Sleep (100)
WEnd

Func Close()
   Exit
EndFunc

Func dl()
   ConsoleWrite("Left")
   GUICtrlSetData($Input, "Left")
EndFunc

Func dr()
   ConsoleWrite("Right")
   GUICtrlSetData($Input, "Right")
EndFunc

Func du()
   ConsoleWrite("Up")
   If $cur > 0 Then
	  $cur-=1
   EndIf
   GUICtrlSetData($Input, $menArr1[$cur])
EndFunc

Func dd()
   ConsoleWrite("Down")
   If $cur < UBound($menArr1)-1 Then
	  $cur+=1
   EndIf
   GUICtrlSetData($Input, $menArr1[$cur])
EndFunc

Func ba()
   GUICtrlSetData($Input, "Selected: " & $menArr1[$cur])
   ConsoleWrite("A")
EndFunc

Func bb()
   GUICtrlSetData($Input, "Return")
   ConsoleWrite("B")
EndFunc