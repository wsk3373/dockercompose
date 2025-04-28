# 设置代理
$env:http_proxy = "http://proxy.grep2000.com:710"
$env:https_proxy = "http://proxy.grep2000.com:710"

# 创建工作目录
$workDir = "$env:USERPROFILE\vnc_novnc"
New-Item -ItemType Directory -Path $workDir -Force | Out-Null
Set-Location $workDir

# # 下载并安装 Python（静默）
# Write-Host "📦 安装 Python..."
# $pythonInstaller = "$workDir\python-installer.exe"
# Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.10.10/python-3.10.10-amd64.exe" -OutFile $pythonInstaller
# Start-Process -Wait -FilePath $pythonInstaller -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1"

# # 安装 pip 包：websockify
# Write-Host "📦 安装 websockify..."
# $env:Path += ";C:\Program Files\Python310\Scripts;C:\Program Files\Python310\"
# pip install websockify

# # 下载 noVNC
# Write-Host "🌐 下载 noVNC..."
# Invoke-WebRequest -Uri "https://github.com/novnc/noVNC/archive/refs/tags/v1.6.0.zip" -OutFile "$workDir\novnc.zip"
# Expand-Archive "$workDir\novnc.zip" -DestinationPath "$workDir\novnc"
# Rename-Item "$workDir\novnc\noVNC-1.6.0" "$workDir\novnc\web"

# 下载 NSSM（服务注册工具）
# Write-Host "📦 下载 NSSM..."
# Invoke-WebRequest -Uri "https://nssm.cc/release/nssm-2.24.zip" -OutFile "$workDir\nssm.zip"
# Expand-Archive "$workDir\nssm.zip" -DestinationPath "$workDir\nssm"
# $NSSM = "$workDir\nssm\nssm-2.24\win64\nssm.exe"

下载并安装 TigerVNC（静默安装）
Write-Host "📺 安装 TigerVNC..."
$VNCInstaller = "$workDir\tigervnc.exe"
Invoke-WebRequest -Uri "https://github.com/TigerVNC/tigervnc/releases/download/v1.12.0/tigervnc64-1.12.0.exe" -OutFile $VNCInstaller
Start-Process -Wait -FilePath $VNCInstaller -ArgumentList "/silent"

# # 配置 VNC 密码
# Write-Host "🔐 设置 VNC 密码为：123456"
# $vncPassDir = "$env:USERPROFILE\.vnc"
# New-Item -ItemType Directory -Force -Path $vncPassDir | Out-Null
# "123456" | & 'C:\Program Files\TigerVNC\vncpasswd.exe' -f > "$vncPassDir\passwd"

# # 创建运行 bat 脚本
# $batScript = @"
# @echo off
# python -m websockify 6104 localhost:5900 --web=$workDir\novnc\web
# "@
# $batPath = "$workDir\run_websockify.bat"
# $batScript | Out-File -Encoding ASCII -FilePath $batPath

# # 注册 websockify 服务
# Write-Host "🔧 注册 websockify 服务..."
# Start-Process -Wait -FilePath $NSSM -ArgumentList "install noVNC", "$batPath"

# # 设置服务自动启动并启动
# Start-Process -Wait -FilePath $NSSM -ArgumentList "set noVNC Start SERVICE_AUTO_START"
# Start-Service -Name noVNC

# # 开放防火墙端口
# Write-Host "🧱 放行防火墙端口 5900 和 6104..."
# netsh advfirewall firewall add rule name="Allow VNC" dir=in action=allow protocol=TCP localport=5900
# netsh advfirewall firewall add rule name="Allow noVNC" dir=in action=allow protocol=TCP localport=6104

# # 打印结果
# $ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "169.*" }).IPAddress | Select-Object -First 1
# Write-Host "`n🎉 安装完成！请使用其他电脑访问：" -ForegroundColor Green
# Write-Host "👉 http://$ip:6104/vnc.html" -ForegroundColor Yellow
