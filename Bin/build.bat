@IF /%XDev%==/ GOTO NoXDev

@SET Name=FixName
@IF EXIST .djgpp GOTO djgpp

:MinGW
@SET WinDev=%XDev%\WinDev
@SET PATH=%WinDev%\Bin\MinGW\bin;%PATH%
@SET gcc=gcc.exe -nostartfiles %WinDev%\Lib\C\crt1.c -Wl,-e,__WinMain -D_WINGUI -DDJGPP

::windres ..\Rsrc\FixName.ico -O coff -o FixNameRes.o

%gcc% %Name%.c -s -Os -fno-exceptions -fno-asynchronous-unwind-tables -Wl,--gc-sections -Wl,--file-alignment,512 -I "." -I ..\Lib -I %WinDev%\Lib\Obj -I %WinDev%\Lib\C %WinDev%\Lib\XDev.a %WinDev%\Lib\Kol.a -o ..\%Name%.exe
@IF errorlevel 1 PAUSE
@EXIT

:djgpp
@SET DJGPP=d:\Archive\Projects\XDev\WinDev\Bin\djgpp\djgpp.env
@SET PATH=d:\Archive\Projects\XDev\WinDev\Bin\djgpp\bin;%PATH%

gcc.exe %Name%.c -o ..\%Name%.exe @..\Bin\djgpp.opt
@IF errorlevel 1 PAUSE
@EXIT

:NoXDev

@ECHO Please set system variable XDev=X:\Path\To\XDev
@PAUSE
