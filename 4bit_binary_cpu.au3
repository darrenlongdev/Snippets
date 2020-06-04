#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>

; Gates
Func aG($nA, $nB) ; andGate
   If NOT ($nA == 0 or $nA == 1) or NOT ($nB == 0 or $nB == 1) Then
	  $Err = 1
	  return
   EndIf
	If $nA == 1 AND $nB == 1 Then
		return 1
	Else
		return 0
	EndIf
EndFunc

Func oG($nA, $nB) ; orGate
   If NOT ($nA == 0 or $nA == 1) or NOT ($nB == 0 or $nB == 1) Then
	  $Err = 1
	  return
   EndIf
	If $nA == 0 AND $nB == 0 Then
		return 0
	Else
		return 1
	EndIf
EndFunc

Func naG($nA, $nB) ; nandGate
   If ($nB = Null) Then $nB = $nA ; If 2nd leg Null then make both inputs $nA to create NOT gate
   If NOT ($nA == 0 or $nA == 1) or NOT ($nB == 0 or $nB == 1) Then
	  $Err = 1
	  return
   EndIf
	If $nA == 1 AND $nB == 1 Then
		return 0
	Else
		return 1
	EndIf
EndFunc

Func noG($nA, $nB) ; norGate
If ($nB = Null) Then $nB = $nA ; If 2nd leg Null then make both inputs $nA to create NOT gate
   If NOT ($nA == 0 or $nA == 1) or NOT ($nB == 0 or $nB == 1) Then
	  $Err = 1
	  return
   EndIf
	  If $nA == 1 AND $nB == 1 Then
		 return 1
	  Else
		 return 0
	  EndIf
EndFunc

 Func eorG($nA, $nB) ; exorGate
   If NOT ($nA == 0 or $nA == 1) or NOT ($nB == 0 or $nB == 1) Then
	  $Err = 1
	  return
   EndIf
	If $nA == $nB Then
		return 0
	Else
		return 1
	EndIf
EndFunc

 Func enorG($nA, $nB) ; exnorGate
   If NOT ($nA == 0 or $nA == 1) or NOT ($nB == 0 or $nB == 1) Then
	  $Err = 1
	  return
   EndIf
	If $nA == $nB Then
		return 1
	Else
		return 0
	EndIf
EndFunc

Local $A, $B, $C, $D ; Inputs
Local $Err = 0 ; Error check
Local $NOut ; Number
Local $AO1, $AO2, $AO3, $AO4, $AOut1, $AOut2, $AOut3 ; Add Outputs
Local $MO1, $MO2, $MO3, $MO4, $MOut1, $MOut2, $MOut3, $MOut4 ; Multiply Outputs

; Create GUI
$Form1 = GUICreate("4bit Binary CPU", 219, 133, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE))
GUISetBkColor(0x6D6D6D)
; Input
$GUIA = GUICtrlCreateInput("0", 32, 24, 33, 21)
$GUIB = GUICtrlCreateInput("0", 72, 24, 33, 21)
$GUIC = GUICtrlCreateInput("0", 112, 24, 33, 21)
$GUID = GUICtrlCreateInput("0", 152, 24, 33, 21)
; Output
$GUINOut = GUICtrlCreateInput("0", 128, 56, 33, 21)
$GUIAOut1 = GUICtrlCreateInput("0", 24, 80, 33, 21)
$GUIAOut2 = GUICtrlCreateInput("0", 64, 80, 33, 21)
$GUIAOut3 = GUICtrlCreateInput("0", 104, 80, 33, 21)
$GUIMOut1 = GUICtrlCreateInput("0", 8, 104, 33, 21)
$GUIMOut2 = GUICtrlCreateInput("0", 48, 104, 33, 21)
$GUIMOut3 = GUICtrlCreateInput("0", 88, 104, 33, 21)
$GUIMOut4 = GUICtrlCreateInput("0", 128, 104, 33, 21)
; Text / Graphics
$TxtAdd = GUICtrlCreateLabel("Add", 168, 80, 26, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$TxtMult = GUICtrlCreateLabel("Multiply", 168, 104, 47, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Txt1 = GUICtrlCreateLabel("1 / B1", 152, 8, 34, 17)
GUICtrlSetBkColor(-1, 0xFF00FF)
$Txt2 = GUICtrlCreateLabel("2 / B2", 112, 8, 34, 17)
GUICtrlSetBkColor(-1, 0xFF00FF)
$Txt4 = GUICtrlCreateLabel("4 / A1", 72, 8, 34, 17)
GUICtrlSetBkColor(-1, 0x0066CC)
$Txt8 = GUICtrlCreateLabel("8 / A2", 32, 8, 34, 17)
GUICtrlSetBkColor(-1, 0x0066CC)
$TxtNum = GUICtrlCreateLabel("Number:", 72, 56, 51, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$HorizRule = GUICtrlCreateGraphic(8, 48, 201, 1)
GUICtrlSetColor(-1, 0xFFFFFF)
GUISetState(@SW_SHOW)

While $Err = 0
   ; Data in
   $A = GUICtrlRead($GUIA)
   $B = GUICtrlRead($GUIB)
   $C = GUICtrlRead($GUIC)
   $D = GUICtrlRead($GUID)

   ; Number
   $NOut = 0 ; reset on each cycle
   If noG($D, Null) == 1 Then $NOut += 1
   If noG($C, Null) == 1 Then $NOut += 2
   If noG($B, Null) == 1 Then $NOut += 4
   If noG($A, Null) == 1 Then $NOut += 8

   ; Add
   $AO1 = aG($B, $D)
   $AOut3 = aG(oG($B, $D), naG($AO1, Null)) ; output
   $AO2 = naG(aG($AO1, $A), Null)
   $AO3 = oG(aG($AO1, $AO2), aG($AO2, $A))
   $AOut1 = oG(aG($AO1, $A), oG(aG($AO1, $C), aG($C, $A))) ; output
   $AO4 = naG(aG($AO3, $C), Null)
   $AOut2 = oG(aG($AO3, $AO4), aG($AO4, $C)) ; output

   ; Multiply
   $MOut4 = aG($B, $D) ; output
   $MO1 = aG($A, $D)
   $MO2 = aG($B, $C)
   $MOut3 = eorG($MO1, $MO2) ; output
   $MO3 = aG($MO1, $MO2)
   $MO4 = aG($A, $C)
   $MOut2 =eorG($MO3, $MO4) ; output
   $MOut1 = aG($MO3, $MO4) ; output

   ; Data out
   GUICtrlSetData($GUINOut, $NOut)
   GUICtrlSetData($GUIAOut1, $AOut1)
   GUICtrlSetData($GUIAOut2, $AOut2)
   GUICtrlSetData($GUIAOut3, $AOut3)
   GUICtrlSetData($GUIMOut1, $MOut1)
   GUICtrlSetData($GUIMOut2, $MOut2)
   GUICtrlSetData($GUIMOut3, $MOut3)
   GUICtrlSetData($GUIMOut4, $MOut4)

   ; Check for GUI close
   $msg = GUIGetMsg()
   Select
	  Case $msg = $GUI_EVENT_CLOSE
		 ExitLoop
   EndSelect
WEnd
If $Err = 1 Then
   MsgBox($MB_OK, "Error", "Input error, value isnt binary", 10)
EndIf
GUIDelete()