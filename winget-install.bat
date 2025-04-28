Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
winget source remove winget
winget source add winget https://mirrors.ustc.edu.cn/winget-source 
winget source update
winget install -e --id Git.Git
@REM winget install --id=NSSM.NSSM  -e
@REM winget install -e --id Kitware.CMake
@REM windowns编译环境工具
@REM winget install --id=alesimula.wsa_pacman  -e
pacman -S mingw-w64-x86_64-cmake
pacman -S mingw-w64-x86_64-fltk
pacman -S mingw-w64-x86_64-gnutls
pacman -S mingw-w64-x86_64-gcc
pacman -S mingw-w64-x86_64-make
pacman -S mingw-w64-x86_64-pixman
@REM windowns编译环境工具
choco install nssm
winget install -e --id Notepad++.Notepad++
winget install -e --id GlavSoft.TightVNC
winget install -e --id Anaconda.Miniconda3
winget install -e --id CoreyButler.NVMforWindows
winget install --id=TheDocumentFoundation.LibreOffice  -e
@REM winget install -e --id Microsoft.VisualStudioCode
choco install vscode
winget install -e --id Tencent.WeChat
winget install -e --id Tencent.QQ
winget install --id=iFlytek.iFlyIME  -e
#winget install -e --id Microsoft.WindowsTerminal
winget install --id=Guyutongxue.Vscch  -e