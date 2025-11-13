@if not defined _echo echo off
echo "Installing Visual Studio Build Tools 2022"
call C:\Build\CollectLogs.cmd C:\Build\2022\vs_buildtools.exe --wait --quiet --norestart --nocache ^
    --installPath "%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools" ^
    --add Microsoft.VisualStudio.Workload.MSBuildTools ^
    --add Microsoft.VisualStudio.Workload.UniversalBuildTools ^
    --add Microsoft.NetCore.Component.SDK ^
    --add Microsoft.NetCore.Component.Runtime.3.1 ^
    --add Microsoft.NetCore.Component.Runtime.6.0 ^
    --add Microsoft.NetCore.Component.Runtime.7.0 ^
    --add Microsoft.NetCore.Component.Runtime.8.0 ^
    --add Microsoft.NetCore.Component.Runtime.9.0 ^
    --add Microsoft.VisualStudio.Component.Windows11SDK.26100 ^
    || IF "%ERRORLEVEL%"=="3010" EXIT 0

echo "Installing Visual Studio Build Tools 2026"
call C:\Build\CollectLogs.cmd C:\Build\2026\vs_buildtools.exe --wait --quiet --norestart --nocache ^
    --installPath "%ProgramFiles%\Microsoft Visual Studio\2026\BuildTools" ^
    --add Microsoft.VisualStudio.Workload.MSBuildTools ^
    --add Microsoft.VisualStudio.Workload.UniversalBuildTools ^
    --add Microsoft.NetCore.Component.SDK ^
    --add Microsoft.NetCore.Component.Runtime.3.1 ^
    --add Microsoft.NetCore.Component.Runtime.6.0 ^
    --add Microsoft.NetCore.Component.Runtime.7.0 ^
    --add Microsoft.NetCore.Component.Runtime.8.0 ^
    --add Microsoft.NetCore.Component.Runtime.9.0 ^
    --add Microsoft.NetCore.Component.Runtime.10.0 ^
    --add Microsoft.VisualStudio.Component.Windows11SDK.26100 ^
    || IF "%ERRORLEVEL%"=="3010" EXIT 0

echo "Installing Microsoft Store Services SDK"
msiexec /i C:\Build\MicrosoftStoreServicesSDK.msi /quiet

echo "Visual Studio Build Tools installation complete"