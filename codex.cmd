@echo off
setlocal
if "%1"=="-omni" (
  set "MODEL=%2"
  if "%MODEL%"=="" set "MODEL=auto"
  if "%MODEL%"=="auto" set "MODEL=omniroute/auto"
  set "PROVIDER=%3"
  if "%PROVIDER%"=="" set "PROVIDER=omniroute"
  rem Key aus Key-Datei (nicht im Skript speichern)
  if "%OMNIROUTE_API_KEY%"=="" if exist "%USERPROFILE%\.cc-providers\omniroute.key" set /p OMNIROUTE_API_KEY=<"%USERPROFILE%\.cc-providers\omniroute.key"
  shift & shift & shift
  "C:\Users\Win11 Pro\AppData\Local\Programs\OpenAI\Codex\bin\codex.exe" --profile codex-omni -c "model=\"%MODEL%\"" -c "model_provider=\"%PROVIDER%\"" %*
  exit /b
)
"C:\Users\Win11 Pro\AppData\Local\Programs\OpenAI\Codex\bin\codex.exe" %*
