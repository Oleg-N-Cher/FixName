@IF /%XDev%==/ GOTO noXDev

@SET Name=FixName

:MinGW64
@SET WinDev=%XDev%\WinDev
@SET PATH=%WinDev%\Bin\MinGW64\bin;%PATH%
@SET gcc=gcc.exe -nostartfiles %WinDev%\Lib\C\crt1.c -Wl,-e,__WinMain -D_WINGUI -DDJGPP

%gcc% %Name%.c -s -Os -fno-exceptions -fno-asynchronous-unwind-tables -Wl,--gc-sections -Wl,--file-alignment,512 -I "." -I ..\Lib -I %WinDev%\Lib\Obj64 -I %WinDev%\Lib\C %WinDev%\Lib\XDev64.a %WinDev%\Lib\Kol64.a -o ..\x64\%Name%.exe
@IF errorlevel 1 PAUSE
@EXIT

:noXDev

@ECHO Please set system variable XDev=X:\Path\To\XDev
@PAUSE
