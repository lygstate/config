


@if "%3"=="" goto start
@if "%3"=="store" (
	@set user_inputversion=%4
	goto start
)
@set user_inputversion=%3

:start
@call :GetWindowsSdkDir
@call :GetWindowsSdkExecutablePath
@call :GetExtensionSdkDir
@call :GetVSInstallDir
@call :GetVCInstallDir
@call :GetFSharpInstallDir
@call :GetUniversalCRTSdkDir
@if "%1"=="32bit" (
	@call :GetFrameworkDir32
	@call :GetFrameworkVer32
)
@if "%2"=="64bit" (
	@call :GetFrameworkDir64
	@call :GetFrameworkVer64
)
@if "%1 %2"=="64bit 32bit" (
	@call :GetFrameworkDir64
	@call :GetFrameworkVer64
)
@SET Framework40Version=v4.0

@REM -----------------------------------------------------------------------
@REM Used by MsBuild to determine where to look in the registry for VCTargetsPath
@REM -----------------------------------------------------------------------
@SET VisualStudioVersion=14.0

@goto end

@REM -----------------------------------------------------------------------
:GetWindowsSdkDir
@set WindowsSdkDir=
@set WindowsLibPath=
@set WindowsSDKVersion=
@set WindowsSDKLibVersion=winv6.3\

@REM If the user specifically requested a Windows SDK Version, then attempt to use it.
@if "%user_inputversion%"=="8.1" (
  @call :GetWin81SdkDir
  @if errorlevel 1 call :GetWin81SdkDirError
  @if errorlevel 1 exit /B 1
  @exit /B 0
)
@if NOT "%user_inputversion%"=="" (
  @call :GetWin10SdkDir
  @if errorlevel 1 call :GetWin10SdkDirError
  @if errorlevel 1 call exit /B 1
  @exit /B 0
)

@REM If a specific SDK was not requested, first check for the latest Windows 10 SDK
@REM and if not found, fall back to the 8.1 SDK.
@if "%WindowsSdkDir%"=="" @call :GetWin10SdkDir
@if "%WindowsSdkDir%"=="" @call :GetWin81SdkDir

@exit /B 0

@REM ---------------------------------------------------------------------------
:GetWin10SdkDir

@call :GetWin10SdkDirHelper HKLM\SOFTWARE\Wow6432Node > nul 2>&1
@if errorlevel 1 call :GetWin10SdkDirHelper HKCU\SOFTWARE\Wow6432Node > nul 2>&1
@if errorlevel 1 call :GetWin10SdkDirHelper HKLM\SOFTWARE > nul 2>&1
@if errorlevel 1 call :GetWin10SdkDirHelper HKCU\SOFTWARE > nul 2>&1
@if errorlevel 1 exit /B 1
@setlocal enableDelayedExpansion
set HostArch=x86
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" ( set "HostArch=x64" )
if "%PROCESSOR_ARCHITECTURE%"=="EM64T" ( set "HostArch=x64" )
if "%PROCESSOR_ARCHITECTURE%"=="ARM64" ( set "HostArch=arm64" )
if "%PROCESSOR_ARCHITECTURE%"=="arm" ( set "HostArch=arm" )
@endlocal & set PATH=%WindowsSdkDir%bin\%WindowsSDKVersion%%HostArch%;%PATH%
@exit /B 0

:GetWin10SdkDirHelper

@REM Get Windows 10 SDK installed folder
@for /F "tokens=1,2*" %%i in ('reg query "%1\Microsoft\Microsoft SDKs\Windows\v10.0" /v "InstallationFolder"') DO (
	@if "%%i"=="InstallationFolder" (
		@SET WindowsSdkDir=%%k
	)
)

@REM get windows 10 sdk version number
@setlocal enableDelayedExpansion
@if not "%WindowsSdkDir%"=="" @for /f %%i IN ('dir "%WindowsSdkDir%include\" /b /ad-h /on') DO (
    @REM Skip if Windows.h is not found in %%i\um.  This would indicate that only the UCRT MSIs were
    @REM installed for this Windows SDK version.
    @if EXIST "%WindowsSdkDir%include\%%i\um\Windows.h" (
        @set result=%%i
        @if "!result:~0,3!"=="10." (
            @set SDK=!result!
            @if "!result!"=="%user_inputversion%" set findSDK=1
        )
    )
)

@if "%findSDK%"=="1" set SDK=%user_inputversion%
@endlocal & set WindowsSDKVersion=%SDK%\

@if not "%user_inputversion%"=="" (
  @REM if the user specified a version of the SDK and it wasn't found, then use the
  @REM user-specified version to set environment variables.

  @if not "%user_inputversion%\"=="%WindowsSDKVersion%" (
    @set WindowsSDKVersion=%user_inputversion%\
    @set WindowsSDKNotFound=1
  )
) else (
  @REM if no full Windows 10 SDKs were found, unset WindowsSDKDir and exit with error.

  @if "%WindowsSDKVersion%"=="\" (
    @set WindowsSDKNotFound=1
    @set WindowsSDKDir=
    @goto :GetWin10SdkDirExit
  )
)

@if not "%WindowsSDKVersion%"=="\" @set WindowsSDKLibVersion=%WindowsSDKVersion%
@if not "%WindowsSdkDir%"=="" @set WindowsLibPath=%WindowsSdkDir%UnionMetadata;%WindowsSdkDir%References

:GetWin10SdkDirExit

@if "%WindowsSDKNotFound%"=="1" (
  @set WindowsSDKNotFound=
  @exit /B 1
)
@exit /B 0

:GetWin10SdkDirError

@echo !ERROR! Windows SDK %user_inputversion% : '%WindowsSdkDir%include\%user_inputversion%\um'
@cd %WindowsSdkDir%include\%user_inputversion%\um
@exit /B 1

@REM ---------------------------------------------------------------------
:GetWin81SdkDir

@REM Set paths to the Windows 8.1 SDK

@call :GetWin81SdkDirHelper HKLM\SOFTWARE\Wow6432Node > nul 2>&1
@if errorlevel 1 call :GetWin81SdkDirHelper HKCU\SOFTWARE\Wow6432Node > nul 2>&1
@if errorlevel 1 call :GetWin81SdkDirHelper HKLM\SOFTWARE > nul 2>&1
@if errorlevel 1 call :GetWin81SdkDirHelper HKCU\SOFTWARE > nul 2>&1
@if errorlevel 1 exit /B 1
@exit /B 0

:GetWin81SdkDirHelper

@REM Get Windows 8.1 SDK installed folder, if Windows 10 SDK is not installed or user specified to use 8.1 SDK

@set WindowsSDKLibVersion=winv6.3\
@set WindowsSdkDir=
@set WindowsLibPath=

@if "%WindowsSdkDir%"=="" @for /F "tokens=1,2*" %%i in ('reg query "%1\Microsoft\Microsoft SDKs\Windows\v8.1" /v "InstallationFolder"') DO (
	@if "%%i"=="InstallationFolder" (
		@SET WindowsSdkDir=%%k
	)
)
@if "%WindowsLibPath%"==""  @set WindowsLibPath=%WindowsSdkDir%References\CommonConfiguration\Neutral
@if "%WindowsSdkDir%"=="" exit /B 1
@exit /B 0

:GetWin81SdkDirError

@echo !ERROR! Windows SDK 8.1 : '%WindowsSdkDir%include'
@cd %WindowsSdkDir%include
@exit /B 1

@REM -----------------------------------------------------------------------
:GetExtensionSdkDir
@set ExtensionSdkDir=

@REM Windows 8.1 Extension SDK
@if exist "%ProgramFiles%\Microsoft SDKs\Windows\v8.1\ExtensionSDKs\Microsoft.VCLibs\14.0\SDKManifest.xml" set ExtensionSdkDir=%ProgramFiles%\Microsoft SDKs\Windows\v8.1\ExtensionSDKs
@if exist "%ProgramFiles(x86)%\Microsoft SDKs\Windows\v8.1\ExtensionSDKs\Microsoft.VCLibs\14.0\SDKManifest.xml" set ExtensionSdkDir=%ProgramFiles(x86)%\Microsoft SDKs\Windows\v8.1\ExtensionSDKs

@REM Windows 10 Extension SDK, this will replace the Windows 8.1 "ExtensionSdkDir" if Windows 10 SDK is installed
@if exist "%ProgramFiles%\Microsoft SDKs\Windows Kits\10\ExtensionSDKs\Microsoft.VCLibs\14.0\SDKManifest.xml" set ExtensionSdkDir=%ProgramFiles%\Microsoft SDKs\Windows Kits\10\ExtensionSDKs
@if exist "%ProgramFiles(x86)%\Microsoft SDKs\Windows Kits\10\ExtensionSDKs\Microsoft.VCLibs\14.0\SDKManifest.xml" set ExtensionSdkDir=%ProgramFiles(x86)%\Microsoft SDKs\Windows Kits\10\ExtensionSDKs

@if "%ExtensionSdkDir%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetWindowsSdkExecutablePath
@set WindowsSDK_ExecutablePath_x86=
@set WindowsSDK_ExecutablePath_x64=
@set NETFXSDKDir=
@call :GetWindowsSdkExePathHelper HKLM\SOFTWARE > nul 2>&1
@if errorlevel 1 call :GetWindowsSdkExePathHelper HKCU\SOFTWARE > nul 2>&1
@if errorlevel 1 call :GetWindowsSdkExePathHelper HKLM\SOFTWARE\Wow6432Node > nul 2>&1
@if errorlevel 1 call :GetWindowsSdkExePathHelper HKCU\SOFTWARE\Wow6432Node > nul 2>&1
@exit /B 0

:GetWindowsSdkExePathHelper
@REM Get .NET 4.6.1 SDK tools and libs include path
@for /F "tokens=1,2*" %%i in ('reg query "%1\Microsoft\Microsoft SDKs\NETFXSDK\4.6.1\WinSDK-NetFx40Tools-x86" /v "InstallationFolder"') DO (
	@if "%%i"=="InstallationFolder" (
		@SET WindowsSDK_ExecutablePath_x86=%%k
	)
)

@for /F "tokens=1,2*" %%i in ('reg query "%1\Microsoft\Microsoft SDKs\NETFXSDK\4.6.1\WinSDK-NetFx40Tools-x64" /v "InstallationFolder"') DO (
	@if "%%i"=="InstallationFolder" (
		@SET WindowsSDK_ExecutablePath_x64=%%k
	)
)

@for /F "tokens=1,2*" %%i in ('reg query "%1\Microsoft\Microsoft SDKs\NETFXSDK\4.6.1" /v "KitsInstallationFolder"') DO (
	@if "%%i"=="KitsInstallationFolder" (
		@SET NETFXSDKDir=%%k
	)
)

@REM Falls back to get .NET 4.6 SDK tools and libs include path
@if "%NETFXSDKDir%"=="" @for /F "tokens=1,2*" %%i in ('reg query "%1\Microsoft\Microsoft SDKs\NETFXSDK\4.6\WinSDK-NetFx40Tools-x86" /v "InstallationFolder"') DO (
	@if "%%i"=="InstallationFolder" (
		@SET WindowsSDK_ExecutablePath_x86=%%k
	)
)

@if "%NETFXSDKDir%"=="" @for /F "tokens=1,2*" %%i in ('reg query "%1\Microsoft\Microsoft SDKs\NETFXSDK\4.6\WinSDK-NetFx40Tools-x64" /v "InstallationFolder"') DO (
	@if "%%i"=="InstallationFolder" (
		@SET WindowsSDK_ExecutablePath_x64=%%k
	)
)

@if "%NETFXSDKDir%"=="" @for /F "tokens=1,2*" %%i in ('reg query "%1\Microsoft\Microsoft SDKs\NETFXSDK\4.6" /v "KitsInstallationFolder"') DO (
	@if "%%i"=="KitsInstallationFolder" (
		@SET NETFXSDKDir=%%k
	)
)

@REM Falls back to use .NET 4.5.1 SDK
@if "%WindowsSDK_ExecutablePath_x86%"=="" @for /F "tokens=1,2*" %%i in ('reg query "%1\Microsoft\Microsoft SDKs\Windows\v8.1A\WinSDK-NetFx40Tools-x86" /v "InstallationFolder"') DO (
	@if "%%i"=="InstallationFolder" (
		@SET WindowsSDK_ExecutablePath_x86=%%k
	)
)

@if "%WindowsSDK_ExecutablePath_x64%"=="" @for /F "tokens=1,2*" %%i in ('reg query "%1\Microsoft\Microsoft SDKs\Windows\v8.1A\WinSDK-NetFx40Tools-x64" /v "InstallationFolder"') DO (
	@if "%%i"=="InstallationFolder" (
		@SET WindowsSDK_ExecutablePath_x64=%%k
	)
)

@if "%WindowsSDK_ExecutablePath_x86%"=="" @if "%WindowsSDK_ExecutablePath_x64%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetVSInstallDir
@set VSINSTALLDIR=
@call :GetVSInstallDirHelper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetVSInstallDirHelper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetVSInstallDirHelper64  HKLM > nul 2>&1
@if errorlevel 1 call :GetVSInstallDirHelper64  HKCU > nul 2>&1
@exit /B 0

:GetVSInstallDirHelper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\VisualStudio\SxS\VS7" /v "14.0"') DO (
	@if "%%i"=="14.0" (
		@SET VSINSTALLDIR=%%k
	)
)
@if "%VSINSTALLDIR%"=="" exit /B 1
@exit /B 0

:GetVSInstallDirHelper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VS7" /v "14.0"') DO (
	@if "%%i"=="14.0" (
		@SET VSINSTALLDIR=%%k
	)
)
@if "%VSINSTALLDIR%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetVCInstallDir
@set VCINSTALLDIR=
@call :GetVCInstallDirHelper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetVCInstallDirHelper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetVCInstallDirHelper64  HKLM > nul 2>&1
@if errorlevel 1 call :GetVCInstallDirHelper64  HKCU > nul 2>&1
@exit /B 0

:GetVCInstallDirHelper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" /v "14.0"') DO (
	@if "%%i"=="14.0" (
		@SET VCINSTALLDIR=%%k
	)
)
@if "%VCINSTALLDIR%"=="" exit /B 1
@exit /B 0

:GetVCInstallDirHelper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7" /v "14.0"') DO (
	@if "%%i"=="14.0" (
		@SET VCINSTALLDIR=%%k
	)
)
@if "%VCINSTALLDIR%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetFSharpInstallDir
@set FSHARPINSTALLDIR=
@call :GetFSharpInstallDirHelper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetFSharpInstallDirHelper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetFSharpInstallDirHelper64  HKLM > nul 2>&1
@if errorlevel 1 call :GetFSharpInstallDirHelper64  HKCU > nul 2>&1
@exit /B 0

:GetFSharpInstallDirHelper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\VisualStudio\14.0\Setup\F#" /v "ProductDir"') DO (
	@if "%%i"=="ProductDir" (
		@SET FSHARPINSTALLDIR=%%k
	)
)
@if "%FSHARPINSTALLDIR%"=="" exit /B 1
@exit /B 0

:GetFSharpInstallDirHelper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\14.0\Setup\F#" /v "ProductDir"') DO (
	@if "%%i"=="ProductDir" (
		@SET FSHARPINSTALLDIR=%%k
	)
)
@if "%FSHARPINSTALLDIR%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetUniversalCRTSdkDir
@call :GetUniversalCRTSdkDirHelper HKLM\SOFTWARE\Wow6432Node > nul 2>&1
@if errorlevel 1 call :GetUniversalCRTSdkDirHelper HKCU\SOFTWARE\Wow6432Node > nul 2>&1
@if errorlevel 1 call :GetUniversalCRTSdkDirHelper HKLM\SOFTWARE > nul 2>&1
@if errorlevel 1 call :GetUniversalCRTSdkDirHelper HKCU\SOFTWARE > nul 2>&1
@exit /B 0

:GetUniversalCRTSdkDirHelper
@for /F "tokens=1,2*" %%i in ('reg query "%1\Microsoft\Windows Kits\Installed Roots" /v "KitsRoot10"') DO (
	@if "%%i"=="KitsRoot10" (
		@SET UniversalCRTSdkDir=%%k
	)
)
@if "%UniversalCRTSdkDir%"=="" exit /B 1
@setlocal enableDelayedExpansion
@for /f %%i IN ('dir "%UniversalCRTSdkDir%include\" /b /ad-h /on') DO (
    @set result=%%i
    @if "!result:~0,3!"=="10." set CRT=!result!
    @if "!result!"=="%user_inputversion%" set match=1
)
@if not "%match%"=="" set CRT=%user_inputversion%
@endlocal & set UCRTVersion=%CRT%
@exit /B 0

@REM -----------------------------------------------------------------------
:GetFrameworkDir32
@set FrameworkDir32=
@call :GetFrameworkDir32Helper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkDir32Helper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetFrameworkDir32Helper64  HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkDir32Helper64  HKCU > nul 2>&1
@exit /B 0

:GetFrameworkDir32Helper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkDir32"') DO (
	@if "%%i"=="FrameworkDir32" (
		@SET FrameworkDIR32=%%k
	)
)
@if "%FrameworkDir32%"=="" exit /B 1
@exit /B 0

:GetFrameworkDir32Helper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkDir32"') DO (
	@if "%%i"=="FrameworkDir32" (
		@SET FrameworkDIR32=%%k
	)
)
@if "%FrameworkDIR32%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetFrameworkDir64
@set FrameworkDir64=
@call :GetFrameworkDir64Helper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkDir64Helper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetFrameworkDir64Helper64  HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkDir64Helper64  HKCU > nul 2>&1
@exit /B 0

:GetFrameworkDir64Helper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkDir64"') DO (
	@if "%%i"=="FrameworkDir64" (
		@SET FrameworkDIR64=%%k
	)
)
@if "%FrameworkDIR64%"=="" exit /B 1
@exit /B 0

:GetFrameworkDir64Helper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkDir64"') DO (
	@if "%%i"=="FrameworkDir64" (
		@SET FrameworkDIR64=%%k
	)
)
@if "%FrameworkDIR64%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetFrameworkVer32
@set FrameworkVer32=
@call :GetFrameworkVer32Helper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkVer32Helper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetFrameworkVer32Helper64  HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkVer32Helper64  HKCU > nul 2>&1
@exit /B 0

:GetFrameworkVer32Helper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkVer32"') DO (
	@if "%%i"=="FrameworkVer32" (
		@SET FrameworkVersion32=%%k
	)
)
@if "%FrameworkVersion32%"=="" exit /B 1
@exit /B 0

:GetFrameworkVer32Helper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkVer32"') DO (
	@if "%%i"=="FrameworkVer32" (
		@SET FrameworkVersion32=%%k
	)
)
@if "%FrameworkVersion32%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetFrameworkVer64
@set FrameworkVer64=
@call :GetFrameworkVer64Helper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkVer64Helper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetFrameworkVer64Helper64  HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkVer64Helper64  HKCU > nul 2>&1
@exit /B 0

:GetFrameworkVer64Helper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkVer64"') DO (
	@if "%%i"=="FrameworkVer64" (
		@SET FrameworkVersion64=%%k
	)
)
@if "%FrameworkVersion64%"=="" exit /B 1
@exit /B 0

:GetFrameworkVer64Helper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkVer64"') DO (
	@if "%%i"=="FrameworkVer64" (
		@SET FrameworkVersion64=%%k
	)
)
@if "%FrameworkVersion64%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:end

