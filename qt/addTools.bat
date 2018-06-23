cd /d C:\
set ROOT=C:\
cd /d C:\Qt
set QTROOT=%CD%

cd /d qtcreator-4.6.2\bin
:: sdktool https://github.com/qt-creator/qt-creator/tree/master/src/tools/sdktool
sdktool rmQt --id "company.product.qt5.1.1.msvc2010_opengl_32bit"
sdktool rmQt --id "company.product.qt5.5.1.msvc2010_32bit"
sdktool rmQt --id "company.product.qt5.7.1.msvc2015_32bit"
sdktool rmQt --id "company.product.qt5.7.1.msvc2015_64bit"
sdktool rmQt --id "company.product.qt5.9.4.msvc2015_32bit"
sdktool rmTC --id "ProjectExplorer.ToolChain.Gcc:arm-2010q1-189-arm-uclinuxeabi-C"
sdktool rmTC --id "ProjectExplorer.ToolChain.Gcc:arm-2010q1-189-arm-uclinuxeabi-CPP"
sdktool rmDebugger --id "company.product.toolchain.gdb.arm-2010q1-189-arm-uclinuxeabi"
sdktool rmKit --id "company.product.kit.arm-2010q1-189-arm-uclinuxeabi"
sdktool rmKit --id "company.product.kit.qt5.5.1.msvc2010_32bit"

sdktool rmTC --id "ProjectExplorer.ToolChain.Gcc:arm-linux-gnueabihf-4.9.2-C"
sdktool rmTC --id "ProjectExplorer.ToolChain.Gcc:arm-linux-gnueabihf-4.9.2-CPP"
sdktool rmQt --id "company.product.qt.arm-linux-gnueabihf-4.9.2"
sdktool rmKit --id "company.product.kit.qt-arm-linux-gnueabihf-4.9.2"
set ARM_LINUX_GNUEABIHF_4_9_2_ROOT=%ROOT%\MentorGraphics\linaro
sdktool addTC --id "ProjectExplorer.ToolChain.Gcc:arm-linux-gnueabihf-4.9.2-C" ^
    --language 1 ^
    --name "GCC arm-linux-gnueabihf-4.9.2 (C)" ^
    --path "%ARM_LINUX_GNUEABIHF_4_9_2_ROOT%\bin\arm-linux-gnueabihf-gcc.exe" ^
    --abi "arm-linux-generic-elf-32" ^
    --supportedAbis arm-linux-generic-elf-32
sdktool addTC --id "ProjectExplorer.ToolChain.Gcc:arm-linux-gnueabihf-4.9.2-CPP" ^
    --language 2 ^
    --name "GCC arm-linux-gnueabihf-4.9.2 (CPP)" ^
    --path "%ARM_LINUX_GNUEABIHF_4_9_2_ROOT%\bin\arm-linux-gnueabihf-g++.exe" ^
    --abi "arm-linux-generic-elf-32" ^
    --supportedAbis arm-linux-generic-elf-32
sdktool addDebugger ^
    --id "company.product.toolchain.gdb.arm-linux-gnueabihf-4.9.2" ^
    --name "GCC arm-linux-gnueabihf-4.9.2 (GDB)" ^
    --engine 1 ^
    --binary "%ARM_LINUX_GNUEABIHF_4_9_2_ROOT%\bin\arm-linux-gnueabihf-gdb.exe" ^
    --abis arm-linux-generic-elf-32
sdktool addQt --id "company.product.qt.arm-linux-gnueabihf-4.9.2" ^
    --name "Qt %%{Qt:Version} arm-linux-gnueabihf-4.9.2" ^
    --qmake %ARM_LINUX_GNUEABIHF_4_9_2_ROOT%\arm-linux-gnueabihf\libc\usr\local\qt5\bin\qmake.exe ^
    --type RemoteLinux.EmbeddedLinuxQt
sdktool addKit ^
    --id "company.product.kit.qt-arm-linux-gnueabihf-4.9.2" ^
    --name "EmbeddedLinux Qt %%{Qt:Version} arm-linux-gnueabihf-4.9.2" ^
    --devicetype RemoteLinux.EmbeddedLinuxQt ^
    --qt "company.product.qt.arm-linux-gnueabihf-4.9.2" ^
    --debuggerid "company.product.toolchain.gdb.arm-linux-gnueabihf-4.9.2" ^
    --qt "company.product.qt.arm-linux-gnueabihf-4.9.2" ^
    --sysroot "%ARM_LINUX_GNUEABIHF_4_9_2_ROOT%\arm-linux-gnueabihf\libc" ^
    --Ctoolchain "ProjectExplorer.ToolChain.Gcc:arm-linux-gnueabihf-4.9.2-C" ^
    --Cxxtoolchain "ProjectExplorer.ToolChain.Gcc:arm-linux-gnueabihf-4.9.2-CPP"

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

sdktool addQt ^
    --id "company.product.qt5.9.4.msvc2015_32bit" ^
    --name "Qt %%{Qt:Version} MSVC2015 32bit" ^
    --qmake %QTROOT%\Qt5.9.4\5.9.4\msvc2015\bin\qmake.exe ^
    --type Qt4ProjectManager.QtVersion.Desktop

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
    --id "company.product.kit.qt5.5.1.msvc2010_32bit" ^
    --name "Desktop Qt %%{Qt:Version} MSVC2010 32bit" ^
    --devicetype Desktop ^
    --qt "company.product.qt5.5.1.msvc2010_32bit"

sdktool addKit ^
    --id "company.product.kit.qt5.9.4.msvc2015_32bit" ^
    --name "Desktop Qt %%{Qt:Version} MSVC2015 32bit" ^
    --devicetype Desktop ^
    --qt "company.product.qt5.9.4.msvc2015_32bit"
    
sdktool addKit ^
    --id "company.product.kit.arm-2010q1-189-arm-uclinuxeabi" ^
    --name "uClinux (Sourcery 2010q1, Emcraft STM32F429)" ^
    --debuggerid "company.product.toolchain.gdb.arm-2010q1-189-arm-uclinuxeabi" ^
    --devicetype RemoteLinux.EmbeddedLinuxQt ^
    --qt "" ^
    --sysroot "%ROOT%\GCC\arm-2010q1-189-arm-uclinuxeabi\arm-uclinuxeabi\libc" ^
    --Ctoolchain "ProjectExplorer.ToolChain.Gcc:arm-2010q1-189-arm-uclinuxeabi-C" ^
    --Cxxtoolchain "ProjectExplorer.ToolChain.Gcc:arm-2010q1-189-arm-uclinuxeabi-CPP"

pause
