#Requires -Version 5.1
<#
free-astra: starts the adapter server for Codex CLI.
#>
param([switch]$NoBrowser)

$ErrorActionPreference = 'Stop'
$RepoPath = 'C:\Users\Win11 Pro\Desktop\free-astra\repo'
$SessionFile = Join-Path $HOME '.free-astra\session.json'
$Port = 8319

$health = "http://127.0.0.1:$Port/v1/models"
try { $null = Invoke-WebRequest -Uri $health -TimeoutSec 2 -UseBasicParsing; Write-Host "[free-astra] Adapter lÃ¤uft bereits."; exit 0 } catch {}

if (-not (Test-Path -LiteralPath $SessionFile)) {
    Write-Host "[free-astra] Keine Prism-Sitzung vorhanden. Führen Sie zuerst das Setup aus." -ForegroundColor Yellow
    Write-Host "  powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\Win11 Pro\.free-astra\FreeAstra-Auto-Chrome.ps1 -Mode Setup" -ForegroundColor Cyan
    exit 1
}

$py = if (Get-Command py.exe -ErrorAction SilentlyContinue) { py.exe -3 -c 'import sys;print(sys.executable)' } else { python.exe -c 'import sys;print(sys.executable)' }
Start-Process -FilePath $py -ArgumentList @('-u', (Join-Path $RepoPath 'freeastra.py')) -WorkingDirectory $RepoPath -WindowStyle Hidden -PassThru | Out-Null
for ($i=0; $i -lt 25; $i++) { Start-Sleep -Milliseconds 600; try { $null = Invoke-WebRequest -Uri $health -TimeoutSec 2 -UseBasicParsing; Write-Host "[free-astra] Adapter gestartet: http://127.0.0.1:$Port/v1" -ForegroundColor Green; exit 0 } catch {} }
throw 'Adapter antwortet nicht.'
