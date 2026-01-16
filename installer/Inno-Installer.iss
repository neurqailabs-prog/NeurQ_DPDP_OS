; QS-DPDP OS - Inno Setup Installer Script
; Creates a proper Windows .exe installer

[Setup]
AppName=QS-DPDP OS
AppVersion=1.0.0
AppPublisher=NeurQ Technologies
AppPublisherURL=https://www.neurq.com
DefaultDirName={localappdata}\NeurQ\QS-DPDP-OS
DefaultGroupName=NeurQ\QS-DPDP OS
OutputDir=.
OutputBaseFilename=QS-DPDP-OS-Setup
SetupIconFile=..\QS-DPDP-OS-Icon.ico
Compression=lzma
SolidCompression=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
WizardStyle=modern
LicenseFile=..\LICENSE.txt
InfoBeforeFile=..\README.md

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1

[Files]
Source: "..\dist\executables\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\splash-screen.html"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\QS-DPDP-OS-Icon.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\START-HERE.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\docs\*"; DestDir: "{app}\docs"; Flags: ignoreversion recursesubdirs createallsubdirs

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
  WizardForm.WelcomeLabel1.Caption := 'Welcome to QS-DPDP OS Setup';
  WizardForm.WelcomeLabel2.Caption := 'This wizard will guide you through the installation of Quantum-Safe DPDP Compliance Operating System.';
end;
