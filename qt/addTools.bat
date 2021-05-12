cd /d C:\
set ROOT=C:
cd /d Qt
set QTROOT=%CD%

cd /d %QTROOT%\qtcreator-4.14.2\bin
:: sdktool https://github.com/qt-creator/qt-creator/tree/master/src/tools/sdktool

sdktool addQt ^
    --id "company.product.qt5.1.1.msvc2010_opengl_32bit" ^
    --name "Qt %%{Qt:Version} MSVC2010 OpenGL 32bit" ^
    --qmake %QTROOT%\Qt5.1.1\5.1.1\msvc2010_opengl\bin\qmake.exe ^
    --type Qt4ProjectManager.QtVersion.Desktop
sdktool addKit ^
    --id "company.product.kit.qt5.5.1.msvc2010_opengl_32bit" ^
    --name "Desktop Qt %%{Qt:Version} MSVC2010 OpenGL 32bit" ^
    --devicetype Desktop ^
    --qt "company.product.qt5.5.1.msvc2010_opengl_32bit" ^
    --Ctoolchain "x86-windows-msvc2010-pe-32bit" ^
    --Cxxtoolchain "x86-windows-msvc2010-pe-32bit"

sdktool addQt ^
    --id "company.product.qt5.5.1.msvc2010_32bit" ^
    --name "Qt %%{Qt:Version} MSVC2010 32bit" ^
    --qmake %QTROOT%\Qt5.5.1\5.5\msvc2010\bin\qmake.exe ^
    --type Qt4ProjectManager.QtVersion.Desktop
sdktool addKit ^
    --id "company.product.kit.qt5.5.1.msvc2010_32bit" ^
    --name "Desktop Qt %%{Qt:Version} MSVC2010 32bit" ^
    --devicetype Desktop ^
    --qt "company.product.qt5.5.1.msvc2010_32bit" ^
    --Ctoolchain "x86-windows-msvc2010-pe-32bit" ^
    --Cxxtoolchain "x86-windows-msvc2010-pe-32bit"

sdktool addTC  ^
    --id "ProjectExplorer.ToolChain.Gcc:arm-2010q1-189-arm-uclinuxeabi-C" ^
    --language 1 ^
    --name "GCC arm-2010q1-189-arm-uclinuxeabi (C)" ^
    --path "%ROOT%\GCC\arm-2010q1-189-arm-uclinuxeabi\bin\arm-uclinuxeabi-gcc.exe" ^
    --abi "arm-linux-generic-elf-32" ^
    --supportedAbis arm-linux-generic-elf-32
sdktool addTC  ^
    --id "ProjectExplorer.ToolChain.Gcc:arm-2010q1-189-arm-uclinuxeabi-CPP" ^
    --language 2 ^
    --name "GCC arm-2010q1-189-arm-uclinuxeabi(C++)" ^
    --path "%ROOT%\GCC\arm-2010q1-189-arm-uclinuxeabi\bin\arm-uclinuxeabi-g++.exe" ^
    --abi "arm-linux-generic-elf-32" ^
    --supportedAbis arm-linux-generic-elf-32
sdktool addDebugger ^
    --id "company.product.toolchain.gdb.arm-2010q1-189-arm-uclinuxeabi" ^
    --name "GDB (Sourcery G++ Lite for ARM uClinux, arm-2010q1-189)" ^
    --engine 1 ^
    --binary "%ROOT%\GCC\arm-2010q1-189-arm-uclinuxeabi\bin\arm-uclinuxeabi-gdb.exe" ^
    --abis arm-linux-generic-elf-32
sdktool addKit ^
    --id "company.product.kit.arm-2010q1-189-arm-uclinuxeabi" ^
    --name "uClinux (Sourcery 2010q1, Emcraft STM32F429)" ^
    --debuggerid "company.product.toolchain.gdb.arm-2010q1-189-arm-uclinuxeabi" ^
    --devicetype RemoteLinux.EmbeddedLinuxQt ^
    --qt "" ^
    --sysroot "%ROOT%\GCC\arm-2010q1-189-arm-uclinuxeabi\arm-uclinuxeabi\libc" ^
    --Ctoolchain "ProjectExplorer.ToolChain.Gcc:arm-2010q1-189-arm-uclinuxeabi-C" ^
    --Cxxtoolchain "ProjectExplorer.ToolChain.Gcc:arm-2010q1-189-arm-uclinuxeabi-CPP"

sdktool addQt ^
    --id "company.product.qt5.9.9.msvc2015_32bit" ^
    --name "Qt 5.9.9 MSVC2015 32bit" ^
    --qmake %QTROOT%\Qt5.9.9\5.9.9\msvc2015\bin\qmake.exe ^
    --type Qt4ProjectManager.QtVersion.Desktop
sdktool addKit ^
    --id "company.product.kit.qt5.9.9.msvc2015_32bit" ^
    --name "Desktop Qt 5.9.9 MSVC2015 32bit" ^
    --devicetype Desktop ^
    --qt "company.product.qt5.9.9.msvc2015_32bit" ^
    --Ctoolchain "x86-windows-msvc2015-pe-32bit" ^
    --Cxxtoolchain "x86-windows-msvc2015-pe-32bit"

sdktool addQt ^
    --id "company.product.qt5.9.9.msvc2015_64bit" ^
    --name "Qt 5.9.9 MSVC2015 64bit" ^
    --qmake %QTROOT%\Qt5.9.9\5.9.9\msvc2015\bin\qmake.exe ^
    --type Qt4ProjectManager.QtVersion.Desktop
sdktool addKit ^
    --id "company.product.kit.qt5.9.9.msvc2015_64bit" ^
    --name "Desktop Qt 5.9.9 MSVC2015 64bit" ^
    --devicetype Desktop ^
    --qt "company.product.qt5.9.9.msvc2015_64bit" ^
    --Ctoolchain "x86-windows-msvc2015-pe-64bit" ^
    --Cxxtoolchain "x86-windows-msvc2015-pe-64bit"

pause
