@if not defined _echo echo off
call C:\Build\CollectLogs.cmd C:\Build\vs_buildtools.exe --wait --quiet --norestart --nocache ^
    --installPath "%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools" ^
    --add Microsoft.VisualStudio.Workload.MSBuildTools ^
    --add Microsoft.VisualStudio.Workload.UniversalBuildTools ^
    --add Microsoft.NetCore.Component.SDK ^
    --add Microsoft.NetCore.Component.Runtime.3.1 ^
    --add Microsoft.NetCore.Component.Runtime.6.0 ^
    --add Microsoft.NetCore.Component.Runtime.7.0 ^
    --add Microsoft.NetCore.Component.Runtime.8.0 ^
    --add Microsoft.VisualStudio.Component.Windows10SDK.18362 ^
    --add Microsoft.VisualStudio.Component.Windows10SDK.19041 ^
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 ^
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 ^
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 ^
    --remove Microsoft.VisualStudio.Component.Windows81SDK ^
    || IF "%ERRORLEVEL%"=="3010" EXIT 0

msiexec /i C:\Build\MicrosoftStoreServicesSDK.msi /quiet