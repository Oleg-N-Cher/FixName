@IF /%XDev%==/ GOTO noXDev

@FOR %%i IN (*.sym) DO COPY /B /Y %XDev%\WinDev\Lib\Sym64\%%i
@EXIT

:noXDev

@ECHO Please set system variable XDev=X:\Path\To\XDev
@PAUSE
