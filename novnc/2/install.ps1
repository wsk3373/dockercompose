# install.ps1
# 请使用管理员权限运行！

# ⚙️ 设置全局变量
$proxy = "http://proxy.grep2000.com:710"
$env:HTTP_PROXY = $proxy
$env:HTTPS_PROXY = $proxy

$pythonInstaller = "$env:TEMP\python-installer.exe"
$tigerVNCInstaller = "$env:TEMP\tigervnc.exe"
$nssmZip = "$env:TEMP\nssm.zip"
$novncZip = "$env:TEMP\novnc.zip"
$installDir = "$env:ProgramData\vnc_novnc"
$pythonPath = "$installDir\python"
$novncDir = "$installDir\novnc"
$websockifyDir = "$installDir\websockify"
$nssmDir = "$installDir\nssm"

New-Item -ItemType Directory -Force -Path $installDir

# ✅ Step 1: 安装 Python（官网下载）
Invoke-WebRequest "https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe" -OutFile $pythonInstaller
Start-Process -FilePath $pythonInstaller -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait

# 重新加载 PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

# ✅ Step 2: 安装 pip 和 websockify
python -m ensurepip
pip install --upgrade pip
pip install websockify

# ✅ Step 3: 安装 TigerVNC（官网下载）
Invoke-WebRequest "https://sourceforge.net/projects/tigervnc/files/stable/1.12.0/tigervnc64-1.12.0.exe/download" -OutFile $tigerVNCInstaller
Start-Process -FilePath $tigerVNCInstaller -ArgumentList "/silent" -Wait

# ✅ Step 4: 下载并解压 noVNC
Invoke-WebRequest "https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.zip" -OutFile $novncZip
Expand-Archive $novncZip -DestinationPath $novncDir
Rename-Item "$novncDir\noVNC-1.4.0" "$novncDir\app"

# ✅ Step 5: 下载 websockify（noVNC 依赖）
git clone https://github.com/novnc/websockify.git $websockifyDir

# ✅ Step 6: 下载 NSSM
Invoke-WebRequest "https://nssm.cc/release/nssm-2.24.zip" -OutFile $nssmZip
Expand-Archive $nssmZip -DestinationPath $nssmDir

# ✅ Step 7: 创建 websockify 启动脚本
$runBat = "$installDir\run_websockify.bat"
@"
cd /d $websockifyDir
python websockify.py 6104 127.0.0.1:5900 --web $novncDir\app
"@ | Out-File -Encoding ASCII $runBat

# ✅ Step 8: 注册服务（用 NSSM）
$nssmExe = Get-ChildItem -Path "$nssmDir\nssm-2.24\win64" -Filter "nssm.exe" -Recurse | Select-Object -First 1
& $nssmExe.FullName install noVNC "$runBat"

# ✅ Step 9: 启动服务
& $nssmExe.FullName start noVNC

# ✅ Step 10: 防火墙放行端口
New-NetFirewallRule -DisplayName "Allow VNC Port 5900" -Direction Inbound -Protocol TCP -LocalPort 5900 -Action Allow
New-NetFirewallRule -DisplayName "Allow noVNC Port 6104" -Direction Inbound -Protocol TCP -LocalPort 6104 -Action Allow

# ✅ Step 11: 提示用户访问地址
$ip = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Ethernet" | Where-Object {$_.IPAddress -notlike "169*"}).IPAddress
Write-Host "✅ 部署成功！请访问： http://$ip:6104/vnc.html"
