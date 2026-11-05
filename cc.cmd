@echo off
if /i "%~1"=="list" (
    "C:\Program Files\Git\usr\bin\bash.exe" -lc 'exec cc-list'
    exit /b %ERRORLEVEL%
)
claude %*
