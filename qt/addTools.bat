cd "%~dp0/.."
set ROOT=%CD%
cd /d "%~dp0"
set QTROOT=%CD%

cd /d qtcreator-4.6.1\bin
:: sdktool https://github.com/qt-creator/qt-creator/tree/master/src/tools/sdktool
sdktool rmQt --id "company.product.qt5.1.1.msvc2010_opengl_32bit"
sdktool rmQt --id "company.product.qt5.5.1.msvc2010_32bit"
sdktool rmQt --id "company.product.qt5.7.1.msvc2015_32bit"
sdktool rmQt --id "company.product.qt5.7.1.msvc2015_64bit"
sdktool rmTC --id "ProjectExplorer.ToolChain.Gcc:arm-2010q1-189-arm-uclinuxeabi-C" ^
sdktool rmTC --id "ProjectExplorer.ToolChain.Gcc:arm-2010q1-189-arm-uclinuxeabi-CPP" ^
sdktool rmDebugger --id "company.product.toolchain.gdb.arm-2010q1-189-arm-uclinuxeabi" ^

sdktool addQt ^
    --id "company.product.qt5.1.1.msvc2010_opengl_32bit" ^
    --name "Qt %%{Qt:Version} MSVC2010 OpenGL 32bit" ^
    --qmake %QTROOT%\Qt5.1.1\5.1.1\msvc2010_opengl\bin\qmake.exe ^
    --type Qt4ProjectManager.QtVersion.Desktop

sdktool addQt ^
    --id "company.product.qt5.5.1.msvc2010_32bit" ^
    --name "Qt %%{Qt:Version} MSVC2010 32bit" ^
    --qmake %QTROOT%\Qt5.5.1\5.5\msvc2010\bin\qmake.exe ^
    --type Qt4ProjectManager.QtVersion.Desktop

sdktool addQt ^
    --id "company.product.qt5.7.1.msvc2015_32bit" ^
    --name "Qt %%{Qt:Version} MSVC2015 32bit" ^
    --qmake %QTROOT%\Qt5.7.1\5.7\msvc2015\bin\qmake.exe ^
    --type Qt4ProjectManager.QtVersion.Desktop

sdktool addQt ^
    --id "company.product.qt5.7.1.msvc2015_64bit" ^
    --name "Qt %%{Qt:Version} MSVC2015 64bit" ^
    --qmake %QTROOT%\Qt5.7.1\5.7\msvc2015_64\bin\qmake.exe ^
    --type Qt4ProjectManager.QtVersion.Desktop

sdktool addTC  ^
    --id "ProjectExplorer.ToolChain.Gcc:arm-2010q1-189-arm-uclinuxeabi-C" ^
    --language 1 ^
    --name "GCC arm-2010q1-189-arm-uclinuxeabi (C)" ^
    --path "%ROOT%\GCC\arm-2010q1-189-arm-uclinuxeabi\bin\arm-uclinuxeabi-gcc.exe" ^
    --abi "arm-uclinuxeabi-generic-elf-32" ^
    --supportedAbis arm-uclinuxeabi-generic-elf-32

sdktool addTC  ^
    --id "ProjectExplorer.ToolChain.Gcc:arm-2010q1-189-arm-uclinuxeabi-CPP" ^
    --language 2 ^
    --name "GCC arm-2010q1-189-arm-uclinuxeabi(C++)" ^
    --path "%ROOT%\GCC\arm-2010q1-189-arm-uclinuxeabi\bin\arm-uclinuxeabi-g++.exe" ^
    --abi "arm-uclinuxeabi-generic-elf-32" ^
    --supportedAbis arm-uclinuxeabi-generic-elf-32

sdktool addDebugger ^
    --id "company.product.toolchain.gdb.arm-2010q1-189-arm-uclinuxeabi" ^
    --name "GDB (Sourcery G++ Lite for ARM uClinux, arm-2010q1-189)" ^
    --engine 1 ^
    --binary "%ROOT%\GCC\arm-2010q1-189-arm-uclinuxeabi\bin\arm-uclinuxeabi-gdb.exe" ^
    --abis arm-uclinuxeabi-generic-elf-32
pause
