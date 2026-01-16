' ========================================
' VBScript Launcher for QS-DPDP Core
' This should work more reliably than batch file shortcuts
' ========================================

Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Set paths
InstallDir = WshShell.ExpandEnvironmentStrings("%LOCALAPPDATA%") & "\NeurQ\QS-DPDP-Core"
Launcher = InstallDir & "\launch.bat"

' Check if launcher exists
If fso.FileExists(Launcher) Then
    ' Change to installation directory
    WshShell.CurrentDirectory = InstallDir
    
    ' Run the launcher
    WshShell.Run "cmd /c """ & Launcher & """", 1, False
Else
    ' Show error message
    MsgBox "Launcher not found at: " & Launcher & vbCrLf & vbCrLf & "Please run the installer first.", vbCritical, "QS-DPDP Core - Error"
End If
