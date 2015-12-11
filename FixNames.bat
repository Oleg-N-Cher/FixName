@SET PATH=%CD%;%PATH%
CD %1
@FOR %%i IN (*.*) DO FixName.exe "%%i"
