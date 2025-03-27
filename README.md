Option Explicit

Dim moveTimer As Double
Dim moveCounter As Integer

Sub StartMouseMover()
    moveCounter = 0
    MoveMouse
End Sub

Sub MoveMouse()
    Dim x As Integer, y As Integer
    
    ' Check if A1 has content, stop if it does
    If Trim(Range("A1").Value) <> "" Then
        StopMouseMover
        Exit Sub
    End If
    
    ' Get current mouse position
    x = 500 + moveCounter * 5
    y = 500 + moveCounter * 5
    
    ' Move the mouse
    SetCursorPos x, y
    moveCounter = moveCounter + 1
    
    ' Set next timer: First 10 sec, then 15 sec alternately
    If moveCounter Mod 2 = 1 Then
        moveTimer = Now + TimeValue("00:00:10")
    Else
        moveTimer = Now + TimeValue("00:00:15")
    End If
    
    ' Schedule the next move
    Application.OnTime moveTimer, "MoveMouse"
End Sub

Sub StopMouseMover()
    ' Stop the scheduled movement
    On Error Resume Next
    Application.OnTime moveTimer, "MoveMouse", , False
    On Error GoTo 0
End Sub

' API for setting the cursor position
Private Declare PtrSafe Sub SetCursorPos Lib "user32" (ByVal x As Long, ByVal y As Long)
