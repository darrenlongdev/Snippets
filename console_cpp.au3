#AutoIt3Wrapper_Change2CUI=y
#include-once
#NoTrayIcon
#include <String.au3>
#include <Array.au3>
#include <WinAPI.au3>

#cs ----------------------------------------------------------------------------
 console_cpp
 Console Applications C++ Functions
 Author: Darren Long

 printf()
 system()
 _sleep()
 createChar()
 getChar()
 releaseChar()
 createInt()
 getInt()
 releaseInt()
 cin()
 _exit()

#ce ----------------------------------------------------------------------------

Global Const $_msvcrtdll = DllOpen("msvcrt.dll")
Global Const $_kernel32dll = DllOpen("kernel32.dll")

; ---------------------------------------
; printf(string) - used with CLI applications to output a formatted string, for example printf("Line one\n\t\tLine two\n")
; ---------------------------------------
Func printf($s)
   Local $sFormated = StringFormat($s)
   DllCall($_msvcrtdll, "int:cdecl", "printf", "str", $sFormated)
	  If @error Then
		 DllClose($_msvcrtdll)
		 Return SetError(1)
	  EndIf
EndFunc

; ---------------------------------------
; system(string) - used to call the system() function and will return the CLI output, for example system("echo %username%") will return the current logged in username
; ---------------------------------------
Func system($s)
   DllCall($_msvcrtdll, "int:cdecl", "system", "str", $s)
	  If @error Then
		 DllClose($_msvcrtdll)
		 Return SetError(1)
	  EndIf
EndFunc

; ---------------------------------------
; _sleep(timems) - used to pause a script for set amount of ms
; ---------------------------------------
Func _sleep($i)
   DllCall($_kernel32dll,"none","Sleep","dword",$i)
	  If @error Then
		 DllClose($_kernel32dll)
		 Return SetError(1)
	  EndIf
EndFunc

; ---------------------------------------
; createChar(Var, String) - used to create a char variable, for example createChar("var1","WestMalling")
; To call a variable use getChar("var1")
; to clear all char varibales use releaseChar()
; ---------------------------------------
Global $structChar, $aChar[2]
Func createChar($Var, $sString=" ")
   Local $vCharAS, $sCharAS
   $aChar[0] &= 'char ' & $Var & '[' & StringLen($sString) & '];'
   $aChar[1] &= $sString & ","
   $structChar = DllStructCreate('struct;' & $aChar[0] & 'endstruct')
   $vCharAS = _StringBetween($aChar[0], "char ", "[")
   $sCharAS = StringSplit($aChar[1], ",")
   For $i = 0 to UBound($vCharAS)-1 Step 1
	  If ($vCharAS[$i] = $Var) Then
		 DllStructSetData($structChar, $vCharAS[$i], $sString)
	  Else
		 DllStructSetData($structChar, $vCharAS[$i], $sCharAS[$i+1])
	  EndIf
   Next
   Return $structChar
EndFunc
Func getChar($Var)
   Return DllStructGetData($structChar, $Var)
EndFunc
Func releaseChar()
   $structChar = 0
EndFunc

; ---------------------------------------
; createInt(Var, Int) - used to create an int variable, for example createInt("var1",20)
; To call a variable use getInt("var1")
; to clear all int varibales use releaseInt()
; ---------------------------------------
Global $structInt, $aInt[2]
Func createInt($Var, $sInt=0)
   Local $vIntAS, $sIntAS
   $aInt[0] &= 'int ' & $Var & ';'
   $aInt[1] &= $sInt & ","
   $structInt = DllStructCreate('struct;' & $aInt[0] & 'endstruct')
   $vIntAS = _StringBetween($aInt[0], "int ", ";")
   $sIntAS = StringSplit($aInt[1], ",")
   For $i = 0 to UBound($vIntAS)-1 Step 1
	  If ($vIntAS[$i] = $Var) Then
		 DllStructSetData($structInt, $vIntAS[$i], $sInt)
	  Else
		 DllStructSetData($structInt, $vIntAS[$i], $sIntAS[$i+1])
	  EndIf
   Next
   Return $structInt
EndFunc
Func getInt($Var)
   Return DllStructGetData($structInt, $Var)
EndFunc
Func releaseInt()
   $structInt = 0
EndFunc

; ---------------------------------------
; cin(string) - Use to read user input from console window
; ---------------------------------------
Func cin($sPrompt)
    If Not @Compiled Then Return SetError(1, 0, 0) ; Not compiled
    ConsoleWrite($sPrompt)
    Local $tBuffer = DllStructCreate("char"), $nRead, $sRet = ""
    Local $hFile = _WinAPI_CreateFile("CON", 2, 2)
    While 1
        _WinAPI_ReadFile($hFile, DllStructGetPtr($tBuffer), 1, $nRead)
        If DllStructGetData($tBuffer, 1) = @CR Then ExitLoop
        If $nRead > 0 Then $sRet &= DllStructGetData($tBuffer, 1)
    WEnd
    _WinAPI_CloseHandle($hFile)
    Return $sRet
EndFunc

; ---------------------------------------
; _exit() - Closes DLL and releases variables before exiting
; ---------------------------------------
Func _exit()
   DllCall($_kernel32dll, "BOOL", "FreeConsole")
   DllClose($_msvcrtdll)
   DllClose($_kernel32dll)
   releaseChar()
   releaseInt()
   Exit
EndFunc
