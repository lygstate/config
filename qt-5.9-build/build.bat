cd /d "%~dp0"
set WD=%CD%
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64_x86
set PATH=%WD%\qt-deps\rubyinstaller-2.4.10-1-x64\bin;%PATH%
set PATH=C:\ActivePython27\;%PATH%
set PATH=%WD%\qt\gnuwin32\bin;%PATH%
set PATH=%WD%\qt-deps\jom_1_1_3;%PATH%
:: https://doc.qt.io/qt-5/build-sources.html
:: https://doc.qt.io/qt-5/windows-building.html
mkdir qt-build
cd qt-build
:: https://doc.qt.io/qt-5/configure-options.html
call %WD%\qt\configure -debug-and-release ^
 -opensource -confirm-license ^
 -platform win32-msvc2015 -opengl dynamic ^
 -nomake examples -nomake tests ^
 -pepper-plugins ^
 -printing-and-pdf ^
 -proprietary-codecs ^
 -webrtc ^
 -prefix C:\Qt\Qt5.9.9\5.9.9\msvc2015

:: -ssl -openssl -openssl-runtime OPENSSL_INCDIR="C:\Program Files (x86)\OpenSSL-Win32\include"
:: -openssl-runtime
cmd /k
