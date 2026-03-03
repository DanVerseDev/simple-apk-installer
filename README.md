# Simple APK Installer 📱

A lightweight, transparent, and professional tool for Windows to install Android apps into Windows Subsystem for Android (WSA) simply by double-clicking `.apk` files.

[**📦 Download Latest Version**](https://github.com/DanVerseDev/simple-apk-installer/releases/latest)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Version](https://img.shields.io/badge/Version-1.2.0-blue)
![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-brightgreen)

## ✨ Features

- **🔋 Double-Click Install:** Automatically associates `.apk` files with the tool for a native experience.
- **⚡ Automated Startup:** Wakes up WSA if it's currently inactive, closed, or in standby.
- **🎨 Real APK Icons:** Integrated shell extension to display the real application icons in File Explorer.
- **🌐 Multi-language:** Native support for 12+ languages including English, Spanish, Arabic, Japanese, and more.
- **🛡️ Open Source:** Fully auditable code using PowerShell and Inno Setup. No hidden binaries.
- **🤖 Robust Connectivity:** Advanced polling logic that waits for the Android system to fully boot before installing.

## 📦 Installation

### 1. Executable Installer (Recommended)
The easiest way to get started. It handles file associations and shell extensions automatically.

1. Download `SimpleAPKInstaller_v1.2.0_Setup.exe` from the [Releases](https://github.com/DanVerseDev/simple-apk-installer/releases) page.
2. Run the installer as Administrator.

### 2. Via WinGet (Community)
```powershell
winget install DanVerseDev.SimpleAPKInstaller
```

## 🚀 Usage

Once installed, the process is completely seamless:

1. **Double-click** any `.apk` file on your computer.
2. A console window will appear, waking up WSA if necessary.
3. The tool will wait for the ADB connection and the Android boot sequence.
4. Your app will be installed and ready to use from the Start Menu.

*Note: If APK icons do not appear immediately, you may need to restart Windows Explorer or your PC.*

## 🛠 Prerequisites

- **Windows 10 or 11** with WSA installed.
- **Developer Mode** enabled in the Windows Subsystem for Android settings.
- **ADB** (Managed automatically as a dependency via WinGet).

## 📄 License

MIT License - Copyright (c) 2026 Daniel Martí

---
Built with ❤️ by [Daniel Martí](https://gravatar.com/danversedev) aka [DanVerseDev](https://github.com/DanVerseDev).
