# =============================================================================
# FILE: brute_force.ps1
# PURPOSE: Simulate a brute-force credential attack against a local Windows
#          account to trigger Event ID 4625 (Failed Logon) alerts in the SIEM
# RUN ON: Windows 11 Endpoint VM
# RUN AS: Administrator (PowerShell)
# MITRE:  T1110 - Brute Force (Credential Access)
# =============================================================================
# BEFORE RUNNING:
#   1. Create a dummy local account to target:
#      net user targetuser Password123! /add
#   2. Make sure Elastic Agent is enrolled and logs are flowing to Kibana
# =============================================================================

Write-Host "=============================================" -ForegroundColor Yellow
Write-Host " Brute Force Simulation" -ForegroundColor Yellow
Write-Host " MITRE ATT&CK: T1110 - Brute Force" -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Simulating 15 failed logon attempts against 'targetuser'..." -ForegroundColor Cyan
Write-Host "This generates Event ID 4625 entries in Windows Security log." -ForegroundColor Cyan
Write-Host ""

# Run 15 failed login attempts
# Each iteration generates a 4625 event — red errors in console are expected
for ($i=1; $i -le 15; $i++) {
    $p = ConvertTo-SecureString "wrongpassword$i" -AsPlainText -Force
    $c = New-Object System.Management.Automation.PSCredential("targetuser", $p)
    try {
        Start-Process cmd -Credential $c -WindowStyle Hidden -ErrorAction Stop
    } catch {}
}

Write-Host ""
Write-Host "Simulation complete." -ForegroundColor Green
Write-Host "Check Kibana Security -> Alerts for 'Brute Force - Multiple Failed Logons'" -ForegroundColor Cyan
Write-Host ""
Write-Host "VERIFY IN EVENT VIEWER:" -ForegroundColor Yellow
Write-Host "  Windows Logs -> Security -> Filter for Event ID 4625" -ForegroundColor Yellow
Write-Host ""
Write-Host "VERIFY IN KIBANA DISCOVER:" -ForegroundColor Yellow
Write-Host "  event.code:4625 and user.name:targetuser" -ForegroundColor Yellow
