""
$ScriptSourceRepo = "https://raw.githubusercontent.com/DrawboardLtd/db-uwp-ci-buildvm-public/main"

$PowerShellVersion = "7.5.4";

$ProgressPreference = "SilentlyContinue"

"Downloading Resources"
if (-not (Test-Path "C:\Build")) {
    New-Item -Path "c:\" -Name "Build" -ItemType Directory | Out-Null
}
Push-Location C:\Build
New-Item -Path "c:\Build" -Name "2022" -ItemType Directory | Out-Null
New-Item -Path "c:\Build" -Name "2026" -ItemType Directory | Out-Null
Invoke-WebRequest https://aka.ms/vscollect.exe -OutFile C:\Build\collect.exe

Invoke-WebRequest https://aka.ms/vs/17/release/vs_buildtools.exe -OutFile C:\Build\2022\vs_buildtools.exe
#Invoke-WebRequest https://aka.ms/vs/17/release/channel -OutFile C:\Build\2022\VisualStudio.chman

Invoke-WebRequest https://download.visualstudio.microsoft.com/download/pr/d3b4e0f6-4bc0-4ec0-ba9c-20b355d61cc4/c3e4b70501bd09103bd52cf66d331dd29c80700fa63a2f8a872e365ff5a4282e/vs_BuildTools.exe -OutFile C:\Build\2026\vs_buildtools.exe

Invoke-WebRequest "$ScriptSourceRepo/CollectLogs.cmd" -OutFile C:\Build\CollectLogs.cmd
Invoke-WebRequest "$ScriptSourceRepo/InstallVS.cmd" -OutFile C:\Build\InstallVS.cmd

Invoke-WebRequest https://marketplace.visualstudio.com/_apis/public/gallery/publishers/AdMediator/vsextensions/MicrosoftStoreServicesSDK/10.0.5/vspackage -OutFile C:\Build\MicrosoftStoreServicesSDK.msi
Invoke-WebRequest https://github.com/PowerShell/PowerShell/releases/download/v$($PowerShellVersion)/PowerShell-$($PowerShellVersion)-win-x64.msi -OutFile C:\Build\PowerShell-win-x64.msi

Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.53.0.windows.2/Git-2.53.0.2-64-bit.exe -OutFile C:\Build\Git-x64.exe
Invoke-WebRequest https://github.com/ninja-build/ninja/releases/download/v1.13.2/ninja-win.zip -OutFile C:\Build\ninja-win.zip
Invoke-WebRequest https://github.com/Kitware/CMake/releases/download/v4.3.1/cmake-4.3.1-windows-x86_64.msi -OutFile C:\Build\cmake-x64.msi

"Installing PowerShell $PowerShellVersion"
Start-Process msiexec.exe -ArgumentList "/i C:\Build\PowerShell-win-x64.msi /quiet" -NoNewWindow -Wait

"Installing Git for Windows"
Start-Process C:\Build\Git-x64.exe -ArgumentList "/VERYSILENT /NORESTART" -NoNewWindow -Wait

"Installing CMake"
Start-Process msiexec.exe -ArgumentList "/i C:\Build\cmake-x64.msi /quiet" -NoNewWindow -Wait

"Installing Ninja"
Expand-Archive C:\Build\ninja-win.zip -DestinationPath C:\Build\ninja

$machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
[Environment]::SetEnvironmentVariable("Path", "$machinePath;C:\Program Files\CMake\bin;C:\Build\ninja", "Machine")

"Configuring Virtual Machine"
# Disable Windows Defender for build performance
Add-MpPreference -ExclusionPath 'c:\' -ErrorAction Ignore;
[Environment]::SetEnvironmentVariable("VSTS_AGENT_INPUT_WORK", "C:\a", "Machine")
[Environment]::SetEnvironmentVariable("NUGET_PACKAGES", "C:\nuget", "Machine")

$DesiredSize = (Get-PartitionSupportedSize -DriveLetter C).SizeMax
$CurrentSize = (Get-Partition -DriveLetter C).Size

if ($CurrentSize -lt $DesiredSize) {
    "Expanding Disk Size to $DesiredSize"
    Resize-Partition -DriveLetter C -Size $DesiredSize
}

# "Installing Visual Studio Build Tools"
# ./InstallVS.cmd
Pop-Location
