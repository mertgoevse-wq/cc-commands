@echo off
rem Startet das cc-blues-Bash-Skript über Git Bash. Quelle: %HOME%\.bluesminds\api_key
"C:\Program Files\Git\usr\bin\bash.exe" -c 'export PATH="$HOME/bin:$PATH"; cc-blues %*'
