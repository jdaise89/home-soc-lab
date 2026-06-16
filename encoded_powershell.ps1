# =============================================================================
# FILE: encoded_powershell.ps1
# PURPOSE: Simulate encoded PowerShell execution to trigger Event ID 4688 alerts
# RUN ON: Windows 11 Endpoint VM (PowerShell as Administrator)
# MITRE:  T1059.001 - Command and Scripting Interpreter: PowerShell
# =============================================================================

Write-Host "=============================================" -ForegroundColor Yellow
Write-Host " Encoded PowerShell Simulation" -ForegroundColor Yellow
Write-Host " MITRE ATT&CK: T1059.001 - PowerShell" -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Yellow

# Benign payload — content doesn't matter, the TECHNIQUE is what we're simulating
$plainCommand = "Write-Output 'SOC Lab Simulation - Encoded Command Executed'"
$bytes = [System.Text.Encoding]::Unicode.GetBytes($plainCommand)
$encoded = [Convert]::ToBase64String($bytes)

Write-Host "Executing encoded command..." -ForegroundColor Cyan
Start-Process powershell.exe -ArgumentList "-NonInteractive -EncodedCommand $encoded" -Wait

Write-Host "Done. Check Kibana Security -> Alerts for 'Execution - Encoded PowerShell Command'" -ForegroundColor Green
Write-Host ""
Write-Host "HOW TO DECODE IN AN INVESTIGATION:" -ForegroundColor Yellow
Write-Host '[System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String("<paste-base64>"))' -ForegroundColor Cyan

# Demonstrate decode
Write-Host ""
Write-Host "Decoded payload:" -ForegroundColor Gray
$decoded = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($encoded))
Write-Host "  $decoded" -ForegroundColor Green
