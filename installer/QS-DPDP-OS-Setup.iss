; QS-DPDP OS - Inno Setup Installer Script
; Creates a proper Windows Setup.exe installer

[Setup]
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName=QS-DPDP Operating System
AppVersion=1.0.0
AppPublisher=NeurQ Technologies
AppPublisherURL=https://neurq.com
AppSupportURL=https://neurq.com/support
AppUpdatesURL=https://neurq.com/updates
DefaultDirName={localappdata}\NeurQ\QS-DPDP-OS
DefaultGroupName=NeurQ\QS-DPDP OS
AllowNoIcons=yes
LicenseFile=
OutputDir=installer\output
OutputBaseFilename=QS-DPDP-OS-Setup
SetupIconFile=QS-DPDP-OS-Icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
ArchitecturesInstallIn64BitMode=x64
DisableProgramGroupPage=yes
DisableReadyPage=no
DisableFinishedPage=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode

[Files]
Source: "dist\executables\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "splash-screen.html"; DestDir: "{app}"; Flags: ignoreversion
Source: "QS-DPDP-OS-Icon.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "docs\*"; DestDir: "{app}\docs"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "START-HERE.md"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\QS-DPDP OS"; Filename: "{app}\launch.bat"; IconFilename: "{app}\QS-DPDP-OS-Icon.ico"
Name: "{group}\{cm:UninstallProgram,QS-DPDP OS}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\QS-DPDP OS"; Filename: "{app}\launch.bat"; IconFilename: "{app}\QS-DPDP-OS-Icon.ico"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\QS-DPDP OS"; Filename: "{app}\launch.bat"; IconFilename: "{app}\QS-DPDP-OS-Icon.ico"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\launch.bat"; Description: "{cm:LaunchProgram,QS-DPDP OS}"; Flags: nowait postinstall skipifsilent

[Code]
procedure InitializeWizard;
begin
  WizardForm.WelcomeLabel1.Caption := 'Welcome to QS-DPDP OS Installation';
  WizardForm.WelcomeLabel2.Caption := 'Quantum-Safe DPDP Compliance Operating System' + #13#10 + 
    'This wizard will guide you through the installation.';
end;

function InitializeSetup(): Boolean;
begin
  Result := True;
end;
