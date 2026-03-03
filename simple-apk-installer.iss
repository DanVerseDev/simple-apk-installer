; Simple APK Installer - Inno Setup Script
; Author: DanVerseDev
; Description: Standard auditable installer for Windows Subsystem for Android APK integration.

[Setup]
AppId={{8B9C2D1E-4A5F-4B2C-9D3E-1F2A3B4C5D6E}
AppName=Simple APK Installer
AppVersion=1.2.0
AppPublisher=DanVerseDev
AppPublisherURL=https://github.com/DanVerseDev/simple-apk-installer
AppSupportURL=https://gravatar.com/danversedev
ArchitecturesInstallIn64BitMode=x64compatible
DefaultDirName={autopf}\DanVerseDev\Simple APK Installer
DefaultGroupName=DanVerseDev
AllowNoIcons=yes
PrivilegesRequired=admin
OutputDir=.
OutputBaseFilename=SimpleAPKInstaller_v1.2.0_Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
SetupIconFile=resources\appicon.ico
CloseApplications=yes
RestartApplications=yes
AppMutex=SimpleAPKInstaller_Mutex

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Files]
Source: "simple-apk-installer.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "simple-apk-installer.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "lang\*"; DestDir: "{app}\lang"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "resources\*"; DestDir: "{app}\resources"; Flags: ignoreversion recursesubdirs createallsubdirs
; Shell Extension files
Source: "ext\ApkShellext2.dll"; DestDir: "{app}\ext"; Flags: ignoreversion
Source: "ext\libwebp_x64.dll"; DestDir: "{app}\ext"; Flags: ignoreversion
Source: "ext\libwebp_x86.dll"; DestDir: "{app}\ext"; Flags: ignoreversion
Source: "ext\LICENSE_apkshellext.txt"; DestDir: "{app}\ext"; Flags: ignoreversion

[Registry]
Root: HKA; Subkey: "Software\Classes\.apk"; ValueType: string; ValueName: ""; ValueData: "APKInstaller.ApkFile"; Flags: uninsdeletevalue
Root: HKA; Subkey: "Software\Classes\APKInstaller.ApkFile"; ValueType: string; ValueName: ""; ValueData: "Android Package File"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\APKInstaller.ApkFile\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\resources\appicon.ico"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\APKInstaller.ApkFile\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\simple-apk-installer.bat"" ""%1"""; Flags: uninsdeletekey

[Run]
; Register the shell extension using .NET regasm
Filename: "{dotnet4064}\regasm.exe"; Parameters: "/codebase ""{app}\ext\ApkShellext2.dll"""; StatusMsg: "Registering APK Shell Extension..."; Flags: runhidden; Check: Is64BitInstallMode
Filename: "{dotnet40}\regasm.exe"; Parameters: "/codebase ""{app}\ext\ApkShellext2.dll"""; StatusMsg: "Registering APK Shell Extension..."; Flags: runhidden; Check: "not Is64BitInstallMode"

[UninstallRun]
; Unregister the shell extension
Filename: "{dotnet4064}\regasm.exe"; Parameters: "/u ""{app}\ext\ApkShellext2.dll"""; StatusMsg: "Unregistering APK Shell Extension..."; Flags: runhidden; RunOnceId: "UnregisterApkShellExt64"; Check: Is64BitInstallMode
Filename: "{dotnet40}\regasm.exe"; Parameters: "/u ""{app}\ext\ApkShellext2.dll"""; StatusMsg: "Unregistering APK Shell Extension..."; Flags: runhidden; RunOnceId: "UnregisterApkShellExt32"; Check: "not Is64BitInstallMode"
