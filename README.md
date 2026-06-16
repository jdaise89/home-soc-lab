# Home SOC Lab: SIEM Deployment & Threat Detection

## Project Overview

Built a virtualized Security Operations Center (SOC) home lab using Elastic Stack (SIEM) to simulate real-world threat detection workflows. Deployed a monitored Windows 11 endpoint, configured centralized log ingestion, simulated attacker behavior mapped to MITRE ATT&CK, developed custom detection rules, and documented alert triage using industry-standard incident reporting.

**Tools:** VMware Fusion · Elastic Stack 8.x (Elasticsearch, Kibana, Elastic Security) · Elastic Agent · Fleet Server · Windows 11 Enterprise ARM · Ubuntu Server 24.04 ARM · Nmap · PowerShell

**Host Machine:** Apple M5 Pro (ARM architecture)

---

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                 M5 Mac Host (VMware Fusion)          │
│                                                     │
│  ┌──────────────────┐      ┌──────────────────────┐ │
│  │  Windows 11 VM   │      │   Ubuntu 24.04 VM    │ │
│  │  (Monitored      │─────▶│   (Elastic Stack)    │ │
│  │   Endpoint)      │ logs │                      │ │
│  │                  │      │  - Elasticsearch     │ │
│  │  Elastic Agent   │      │  - Kibana            │ │
│  │  (log collector) │      │  - Fleet Server      │ │
│  │                  │      │  - Elastic Security  │ │
│  └──────────────────┘      └──────────────────────┘ │
│                                                     │
│  Network: VMware NAT (172.16.7.0/24)               │
│  Ubuntu SIEM IP: 172.16.7.129                       │
│  Kibana: http://172.16.7.129:5601                   │
└─────────────────────────────────────────────────────┘
```

---

## What Was Built

### 1. Lab Environment
- Configured two ARM64 VMs in VMware Fusion on Apple M5 Pro
- Installed Elastic Stack 8.x on Ubuntu Server 24.04 (ARM64)
- Configured Fleet Server for centralized Elastic Agent management
- Enrolled a Windows 11 Enterprise ARM endpoint via Fleet
- Verified log ingestion: 1,155+ Windows security events flowing into Kibana

### 2. Windows Audit Policy Configuration
Enabled the following audit policies on the Windows endpoint via `auditpol`:

| Policy | Events Generated |
|--------|-----------------|
| Process Creation | Event ID 4688 |
| Logon | Event ID 4624, 4625 |
| Filtering Platform Connection | Event ID 5156 |

Also enabled command-line logging via registry to capture full PowerShell arguments in Event 4688.

### 3. Attack Simulations
Three attacks were simulated to generate detectable log activity:

| Attack | Method | Events Generated |
|--------|--------|-----------------|
| Brute Force | 15 failed local account logon attempts via PowerShell | Event ID 4625 (x15) |
| Encoded PowerShell | Base64-encoded command execution using `-EncodedCommand` flag | Event ID 4688 |
| Port Scan | Nmap TCP scan against Ubuntu SIEM IP | Network connection flood |

### 4. Detection Rules (MITRE ATT&CK Mapped)

| Rule Name | Type | Tactic | Technique |
|-----------|------|--------|-----------|
| Brute Force - Multiple Failed Logons | Threshold (≥5/1min) | Credential Access | T1110 |
| Execution - Encoded PowerShell Command | Query | Execution | T1059.001 |
| Reconnaissance - Network Port Scan | Threshold (≥20/2min) | Reconnaissance | T1046 |
| Persistence - New Service Installed | Query | Persistence | T1543.003 |

All 4 rules imported into Elastic Security and confirmed firing during simulations.

### 5. Alert Triage & Incident Report
- All 3 simulations generated alerts in Elastic Security
- Brute force alert triaged end-to-end: detection → investigation → documentation
- Completed incident report written using real alert data (see `/incident-reports/`)

---

## Confirmed Alert Results

| Alert | Status | Notes |
|-------|--------|-------|
| Brute Force - Multiple Failed Logons | ✅ Fired | 10 events detected, Medium severity |
| Execution - Encoded PowerShell Command | ✅ Fired | High severity, encoded payload detected |
| Reconnaissance - Network Port Scan | ✅ Fired | 20 alerts generated during Nmap scan |
| Persistence - New Service Installed | ✅ Fired | Triggered by Elastic Agent service installation |

---

## Repository Contents

```
home-soc-lab/
├── README.md                          ← This file
├── setup/
│   ├── 01_install_elastic.sh          ← Elastic Stack install (Ubuntu 24.04 ARM)
│   └── 02_post_install_config.sh      ← Fleet Server & Kibana configuration guide
├── detection-rules/
│   ├── rules.ndjson                   ← Importable Elastic Security rules (4 rules)
│   └── rules_explained.md             ← Rule logic, KQL breakdown, MITRE mapping
├── attack-simulations/
│   ├── brute_force.ps1                ← PowerShell brute force simulator
│   ├── encoded_powershell.ps1         ← Encoded command execution simulation
│   └── nmap_commands.md               ← Nmap scan commands used
├── incident-reports/
│   ├── template.md                    ← Blank incident report template
│   └── IR-001_brute_force.md          ← Completed report with real alert data
└── docs/
    └── mitre_mapping.md               ← Full ATT&CK mapping reference
```

---

## Key Takeaways

- Gained hands-on experience with SIEM log ingestion, search, and alerting using Elastic Security
- Practiced writing detection logic in KQL and structuring rules against the MITRE ATT&CK framework
- Performed end-to-end alert triage: detection → investigation → documentation
- Configured Windows audit policy to enable security event log collection
- Worked through real-world virtualization challenges on Apple Silicon (ARM64)

---

## Skills Demonstrated

`SIEM` `Log Analysis` `Threat Detection` `Elastic Stack` `KQL` `MITRE ATT&CK` `Incident Response` `Windows Event Logs` `Audit Policy` `Virtualization` `Linux Administration` `Network Security Monitoring` `Fleet Management` `PowerShell`

---

## Certifications
- CompTIA Security+ (December 2025)
- Google Cloud: Introduction to Generative AI
- TryHackMe: Pre-Security Path (Completed)
