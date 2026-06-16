# Detection Rules — Logic, KQL Breakdown & MITRE Mapping

## How to Import Into Elastic Security
1. Kibana -> Security -> Rules -> Detection Rules
2. Click "Import rules" (top right)
3. Upload rules.ndjson
4. Enable each rule after importing

---

## Rule 1 — Brute Force: Multiple Failed Logons
**MITRE:** Credential Access -> T1110 | **Severity:** Medium

**KQL:**
```
event.code:"4625" and winlog.event_data.LogonType:("2" or "3" or "10")
```
**Threshold:** ≥5 events in 1 minute grouped by host.name + source.ip

- event.code:"4625" = failed logon event
- LogonType 2 = interactive, 3 = network, 10 = remote interactive

---

## Rule 2 — Execution: Encoded PowerShell
**MITRE:** Execution -> T1059.001 | **Severity:** High

**KQL:**
```
event.code:"4688" and process.name:("powershell.exe" or "pwsh.exe") and process.command_line:(*EncodedCommand* or *-enc*)
```
- event.code:"4688" = new process created
- Matches PowerShell launched with encoded command flags
- Requires process command line logging enabled via registry

**How to decode payload:**
```powershell
[System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String('<base64-here>'))
```

---

## Rule 3 — Reconnaissance: Port Scan
**MITRE:** Reconnaissance -> T1046 | **Severity:** Medium

**KQL:**
```
event.code:"5156"
```
**Threshold:** ≥20 events in 2 minutes grouped by source.ip + host.name

- Requires Filtering Platform Connection audit policy enabled
- Enable with: auditpol /set /subcategory:"Filtering Platform Connection" /success:enable /failure:enable

---

## Rule 4 — Persistence: New Service Installed
**MITRE:** Persistence -> T1543.003 | **Severity:** Medium

**KQL:**
```
event.code:"7045"
```
- Event 7045 = Service Control Manager logged a new service
- Investigate winlog.event_data.ImagePath for suspicious binary locations

---

## KQL Quick Reference

| Operator | Example |
|----------|---------|
| `:` equals | `event.code:"4625"` |
| `and` | `event.code:"4688" and process.name:"powershell.exe"` |
| `or` | `process.name:("powershell.exe" or "pwsh.exe")` |
| `not` | `not user.name:"SYSTEM"` |
| `*` wildcard | `process.command_line:*EncodedCommand*` |
