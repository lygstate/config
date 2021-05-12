cd /d C:\
set ROOT=C:
cd /d Qt
set QTROOT=%CD%

cd /d %QTROOT%\qtcreator-4.14.2\bin
:: sdktool https://github.com/qt-creator/qt-creator/tree/master/src/tools/sdktool

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

pause
