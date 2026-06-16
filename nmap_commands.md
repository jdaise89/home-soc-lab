# Nmap Port Scan Simulation
# MITRE ATT&CK: T1046 — Network Service Discovery

## Setup
Install Nmap: https://nmap.org/download.html
Run installer with defaults (include Npcap when prompted)

Get Ubuntu SIEM IP (from Ubuntu terminal):
```
ip addr show
```

## Enable WFP Audit Logging (required for Event ID 5156)
Run in CMD as Administrator on Windows VM:
```
auditpol /set /subcategory:"Filtering Platform Connection" /success:enable /failure:enable
```

## Scan Commands
Run in PowerShell on Windows VM against Ubuntu SIEM IP (172.16.7.129):

### Basic TCP scan (triggers threshold rule)
```
& "C:\Program Files (x86)\Nmap\nmap.exe" -sT 172.16.7.129
```

### Full port scan (more events)
```
& "C:\Program Files (x86)\Nmap\nmap.exe" -sT -p- 172.16.7.129
```

### Common attacker targets
```
& "C:\Program Files (x86)\Nmap\nmap.exe" -p 22,80,443,445,3389,8080 172.16.7.129
```

## Verify in Kibana
After scanning, search in Discover:
```kql
event.code:"5156" and host.name:<windows-hostname>
```

Check Security -> Alerts for "Reconnaissance - Network Port Scan Detected"
