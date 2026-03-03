# Simple APK Installer

A lightweight and transparent tool for Windows to install Android apps into Windows Subsystem for Android (WSA) simply by double-clicking `.apk` files.

## Features

- **Standard Installer**: Uses Inno Setup for a professional, auditable, and easy installation experience.
- **Double-Click Install**: Automatically associates `.apk` files with the tool.
- **Automated Startup**: Wakes up WSA if it's currently inactive or closed.
- **Real APK Icons**: Integrated shell extension to display real app icons in File Explorer.
- **Robust ADB Connection**: Implements persistent polling and connectivity logic.
- **Multi-language**: Includes support for over 12 languages (English, Spanish, Arabic, German, French, etc.).
- **Open Source & Transparent**: No black-box binaries; all core logic is in readable PowerShell scripts.

## Prerequisites

- **Windows 10/11**
- **Windows Subsystem for Android (WSA)** installed.
- **Developer Mode** enabled in WSA settings.
- **ADB (Android Debug Bridge)**: Automatically handled as a dependency via WinGet.

## Installation

### Method 1: Executable Installer (Recommended)

1. Download the latest `SimpleAPKInstaller_Setup.exe` from the Releases page.
2. Run the installer (requires Administrator privileges for file association).

### Method 2: WinGet (Upcoming)

```powershell
winget install DanVerseDev.SimpleAPKInstaller
```

## Usage

Once installed, simply **double-click** any `.apk` file. A console window will guide you through the automated process.

*Note: If APK icons do not appear immediately, you may need to restart Windows Explorer or your PC.*

## Support & Contribution

If you find this tool useful, consider supporting the project:
[https://gravatar.com/danversedev](https://gravatar.com/danversedev)

Check out the source code:
[https://github.com/DanVerseDev/simple-apk-installer](https://github.com/DanVerseDev/simple-apk-installer)

## License

MIT - See [LICENSE](LICENSE) for details.
Created by **DanVerseDev**.
