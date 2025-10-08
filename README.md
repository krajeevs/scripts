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
/*

Initial Phase
•	Step 1: Initial consultation for business engagement
•	Step 2 : Questionnaire require to be completed
•	Step 3: Application team should  able to identify Schema name and Server name for migration
•	Step 4: Application team will  provide DDL detail to PostgreSQL Team with required format
•	Step 5: LOE report - PostgreSQL team will share DDL detail with EDB to generate LOE
•	Step 6: LOE report walkthrough - EDB team will evaluate DDL for complexity and suggest compatible PostgreSQL flavour for VM and implementation type (Standalone/Cluster)
•	Step 7: EDB team will share DDL's with  PostgreSQL DBA Team
•	Step 8: Migration date agreement  
•	Step 9: POC start /Complete date agreement
•	Step 10: Prod start/Complete date agreement
•	Step 11: Decommission period agreement 
POC Phase
•	Step 12: Start POC Build - Application team will raise VM with agreement of Postgres Team with attached template form
•	Step 13: PostgreSQL VM Build
•	Step 14: Application team will raise Firewall request to establish connectivity from New VM and Source Database
•	Step 15: Postgres team will install/configure required migration tools in new VM
•	Step 16: Migration will be initiated via. Tool ( Multiple run only during PoC stage, Avg. one week )
•	Step 17: Postgres team grant required privileges to users
•	Step 18: POC Testing - Application team will perform POC and confirm completion
SIT Phase
•	Step 19: SIT : PostgreSQL VM Build
•	Step 20: SIT : Application team will raise Firewall request to establish connectivity from New VM and Source Database
•	Step 21: SIT : Postgres team will install/configure required migration tools in new VM
•	Step 22: SIT : Postgres Team use DDL used in lower environment and create the structure 
•	Step 23: SIT : Migration will be initiated via. Tool
•	Step 24: SIT : Postgres team grant required privileges to users 
•	Step 25: SIT : Testing by application Team
Production Phase
•	Step 26: Production : PostgreSQL VM Build
•	Step 27: Application team will raise Firewall request to establish connectivity from New VM and Source Database
•	Step 28: Application will raise FFP request
•	Step 29: Postgres team will install required migration tools in new PROD  VM
•	Step 30: Application team will raise MCR for prod environment (Dry Run or Go Live)
•	Step 31: Postgres Team will raise TCR for Prod environment  (Dry Run or Go Live)
•	Step 32: Postgres Team use DDL used in UAT environment and create structure in PROD and migrate data from PROD source database
•	Step 33: Data Migration will be initiated via. Tool
•	Step 34: Postgres team grant required privileges to users
•	Step 35: Application team will verify data, connectivity and validate
•	Step 36: Application go-live


*/
