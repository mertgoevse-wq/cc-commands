#Requires -Version 5.1
<#
free-astra launcher for Claude Code.
Starts the free-astra adapter (if not running) and launches Claude Code routed through it.
#>
param([switch]$NoBrowser)

$ErrorActionPreference = 'Stop'
$RepoPath = 'C:\Users\Win11 Pro\Desktop\free-astra\repo'
$Autom = Join-Path $env:LOCALAPPDATA 'FreeAstraAuto'
$SessionFile = Join-Path $HOME '.free-astra\session.json'
$Port = 8319

function Start-AdapterIfNeeded {
    $health = "http://127.0.0.1:$Port/v1/models"
    try { $null = Invoke-WebRequest -Uri $health -TimeoutSec 2 -UseBasicParsing; return }
    catch { }
    if (-not (Test-Path -LiteralPath $SessionFile)) {
        Write-Host "[free-astra] Keine Prism-Sitzung vorhanden. Führen Sie zuerst aus:" -ForegroundColor Yellow
        Write-Host "  powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\Win11 Pro\.free-astra\FreeAstra-Auto-Chrome.ps1 -Mode Setup" -ForegroundColor Cyan
        throw 'Session fehlt.'
    }
    $py = if (Get-Command py.exe -ErrorAction SilentlyContinue) { py.exe -3 -c 'import sys;print(sys.executable)' } else { python.exe -c 'import sys;print(sys.executable)' }
    Start-Process -FilePath $py -ArgumentList @('-u', (Join-Path $RepoPath 'freeastra.py')) -WorkingDirectory $RepoPath -WindowStyle Hidden -PassThru | Out-Null
    for ($i=0; $i -lt 25; $i++) { Start-Sleep -Milliseconds 600; try { $null = Invoke-WebRequest -Uri $health -TimeoutSec 2 -UseBasicParsing; return } catch {} }
    throw 'Adapter antwortet nicht.'
}

Start-AdapterIfNeeded
Write-Host "[free-astra] Adapter läuft auf http://127.0.0.1:$Port/v1" -ForegroundColor Green
Write-Host "[free-astra] Starte Claude Code (cc)..." -ForegroundColor Cyan
Start-Process -FilePath 'cmd.exe' -ArgumentList '/c cc' -WorkingDirectory $RepoPath
