; QS-DPDP OS - NSIS Installer Script
; Creates a proper Windows .exe installer

!define PRODUCT_NAME "QS-DPDP OS"
!define PRODUCT_VERSION "1.0.0"
!define PRODUCT_PUBLISHER "NeurQ Technologies"
!define PRODUCT_WEB_SITE "https://www.neurq.com"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\QS-DPDP-OS.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKCU"

; Include Modern UI
!include "MUI2.nsh"

; Installer Attributes
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "QS-DPDP-OS-Setup.exe"
InstallDir "$LOCALAPPDATA\NeurQ\QS-DPDP-OS"
InstallDirRegKey HKCU "${PRODUCT_DIR_REGKEY}" ""
RequestExecutionLevel user
ShowInstDetails show
ShowUnInstDetails show

; Interface Settings
!define MUI_ABORTWARNING
!define MUI_ICON "QS-DPDP-OS-Icon.ico"
!define MUI_UNICON "QS-DPDP-OS-Icon.ico"
!define MUI_WELCOMEPAGE_TITLE "Welcome to QS-DPDP OS Setup"
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of Quantum-Safe DPDP Compliance Operating System.$\r$\n$\r$\nClick Next to continue."

; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; Languages
!insertmacro MUI_LANGUAGE "English"

; Installer Sections
Section "QS-DPDP OS Core" SecCore
    SectionIn RO
    SetOutPath "$INSTDIR"
    
    ; Copy application files
    File /r "dist\executables\*"
    File "splash-screen.html"
    File "QS-DPDP-OS-Icon.ico"
    File "README.md"
    File "START-HERE.md"
    
    ; Copy documentation
    SetOutPath "$INSTDIR\docs"
    File /r "docs\*"
    
    ; Create configuration
    SetOutPath "$INSTDIR"
    FileOpen $0 "$INSTDIR\config.properties" w
    FileWrite $0 "# QS-DPDP OS Configuration$\r$\n"
    FileWrite $0 "install.path=$INSTDIR$\r$\n"
    FileWrite $0 "install.date=$%DATE% $%TIME%$\r$\n"
    FileWrite $0 "version=${PRODUCT_VERSION}$\r$\n"
    FileClose $0
    
    ; Create registry entries
    WriteRegStr HKCU "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\launch.bat"
    WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
    WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninstall.exe"
    WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\QS-DPDP-OS-Icon.ico"
    WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
    WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
    WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Section "Desktop Shortcut" SecDesktop
    CreateShortcut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\launch.bat" "" "$INSTDIR\QS-DPDP-OS-Icon.ico"
SectionEnd

Section "Start Menu Shortcut" SecStartMenu
    CreateDirectory "$SMPROGRAMS\NeurQ"
    CreateShortcut "$SMPROGRAMS\NeurQ\${PRODUCT_NAME}.lnk" "$INSTDIR\launch.bat" "" "$INSTDIR\QS-DPDP-OS-Icon.ico"
    CreateShortcut "$SMPROGRAMS\NeurQ\Uninstall ${PRODUCT_NAME}.lnk" "$INSTDIR\uninstall.exe"
SectionEnd

; Uninstaller
Section -Uninstaller
    WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

; Uninstaller Section
Section "Uninstall"
    Delete "$INSTDIR\uninstall.exe"
    Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
    Delete "$SMPROGRAMS\NeurQ\${PRODUCT_NAME}.lnk"
    Delete "$SMPROGRAMS\NeurQ\Uninstall ${PRODUCT_NAME}.lnk"
    RMDir /r "$INSTDIR"
    RMDir "$SMPROGRAMS\NeurQ"
    
    DeleteRegKey HKCU "${PRODUCT_UNINST_KEY}"
    DeleteRegKey HKCU "${PRODUCT_DIR_REGKEY}"
    
    MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
SectionEnd

; Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecCore} "Core QS-DPDP OS application files"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktop} "Create desktop shortcut"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecStartMenu} "Create Start Menu shortcuts"
!insertmacro MUI_FUNCTION_DESCRIPTION_END
