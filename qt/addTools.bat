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
    --id "company.product.kit.qt5.1.1.msvc2010_opengl_32bit" ^
    --name "Desktop Qt %%{Qt:Version} MSVC2010 OpenGL 32bit" ^
    --devicetype Desktop ^
    --qt "company.product.qt5.1.1.msvc2010_opengl_32bit" ^
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
