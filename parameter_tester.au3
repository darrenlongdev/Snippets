If $CmdLine[0] == 1 Then
   Local $param = InputBox("Parameters", "Enter required parameters.", "")
   Local $pid = ShellExecute($CmdLine[1], $param)
   FileWriteLine(@ScriptDir & "\log.txt", "PID: " & $pid & ", Param: " & $param & @CRLF)
Else
   MsgBox(4096, "No Input File", "Please drag an application or au3 file onto " & @ScriptName)
EndIf

