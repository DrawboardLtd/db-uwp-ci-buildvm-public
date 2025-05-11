""
$ScriptSourceRepo = "https://raw.githubusercontent.com/DrawboardLtd/db-uwp-ci-buildvm-public/main"

$ProgressPreference = "SilentlyContinue"
Set-SConfig -AutoLaunch $false

"Downloading Resources"
if (-not (Test-Path "C:\Build")) {
    New-Item -Path "c:\" -Name "Build" -ItemType Directory | Out-Null
}
Push-Location C:\Build
Invoke-WebRequest https://aka.ms/vscollect.exe -OutFile C:\Build\collect.exe
Invoke-WebRequest https://aka.ms/vs/17/release/vs_buildtools.exe -OutFile C:\Build\vs_buildtools.exe
Invoke-WebRequest https://aka.ms/vs/17/release/channel -OutFile C:\Build\VisualStudio.chman
Invoke-WebRequest "$ScriptSourceRepo/CollectLogs.cmd" -OutFile C:\Build\CollectLogs.cmd
Invoke-WebRequest "$ScriptSourceRepo/InstallVS.cmd" -OutFile C:\Build\InstallVS.cmd
Invoke-WebRequest https://marketplace.visualstudio.com/_apis/public/gallery/publishers/AdMediator/vsextensions/MicrosoftStoreServicesSDK/10.0.5/vspackage -OutFile C:\Build\MicrosoftStoreServicesSDK.msi

"Configuring Virtual Machine"
# Disable Windows Defender for build performance
Add-MpPreference -ExclusionPath 'c:\', 'd:\' -ErrorAction Ignore;
[Environment]::SetEnvironmentVariable("VSTS_AGENT_INPUT_WORK", "D:\a", "Machine")
[Environment]::SetEnvironmentVariable("NUGET_PACKAGES", "D:\nuget", "Machine")

$DesiredSize = (Get-PartitionSupportedSize -DriveLetter C).SizeMax
$CurrentSize = (Get-Partition -DriveLetter C).Size

if ($CurrentSize -lt $DesiredSize) {
    "Expanding Disk Size to $DesiredSize"
    Resize-Partition -DriveLetter C -Size $DesiredSize
}

# "Installing Visual Studio Build Tools"
# ./InstallVS.cmd
Pop-Location
