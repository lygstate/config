cd /d "%~dp0"
set QTROOT=%CD%

cd /d qtcreator-4.6.1\bin

sdktool rmQt --id "company.product.qt5.1.1.msvc2010_opengl_32bit"
sdktool rmQt --id "company.product.qt5.5.1.msvc2010_32bit"
sdktool rmQt --id "company.product.qt5.7.1.msvc2015_32bit"
sdktool rmQt --id "company.product.qt5.7.1.msvc2015_64bit"


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
    --qmake %QTROOT%\Qt5.7.1\5.5\msvc2010\bin\qmake.exe ^
    --type Qt4ProjectManager.QtVersion.Desktop

sdktool addQt ^
    --id "company.product.qt5.5.1.msvc2010_32bit" ^
    --name "Qt %%{Qt:Version} MSVC2010 32bit" ^
    --qmake %QTROOT%\Qt5.5.1\5.5\msvc2010\bin\qmake.exe ^
    --type Qt4ProjectManager.QtVersion.Desktop

pause
