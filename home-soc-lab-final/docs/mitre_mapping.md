# MITRE ATT&CK Reference — Home SOC Lab

## What Is MITRE ATT&CK?
A globally recognized framework cataloging attacker tactics, techniques, and procedures based on real-world observations.
Reference: https://attack.mitre.org

## Structure
- **Tactics** = the attacker's goal (WHY)
- **Techniques** = the method used (HOW)
- **Sub-techniques** = specific variants

## This Lab's MITRE Coverage

| Rule | Tactic | Tactic ID | Technique | Technique ID |
|------|--------|-----------|-----------|--------------|
| Brute Force | Credential Access | TA0006 | Brute Force | T1110 |
| Encoded PowerShell | Execution | TA0002 | PowerShell | T1059.001 |
| Port Scan | Reconnaissance | TA0043 | Network Service Discovery | T1046 |
| New Service | Persistence | TA0003 | Windows Service | T1543.003 |

## The 14 ATT&CK Tactics (Attack Lifecycle Order)

| # | Tactic | ID | Goal |
|---|--------|----|------|
| 1 | Reconnaissance | TA0043 | Gather info before attacking |
| 2 | Resource Development | TA0042 | Build attack infrastructure |
| 3 | Initial Access | TA0001 | Get into the target network |
| 4 | Execution | TA0002 | Run malicious code |
| 5 | Persistence | TA0003 | Maintain access after reboots |
| 6 | Privilege Escalation | TA0004 | Get higher permissions |
| 7 | Defense Evasion | TA0005 | Avoid detection |
| 8 | Credential Access | TA0006 | Steal credentials |
| 9 | Discovery | TA0007 | Learn about the environment |
| 10 | Lateral Movement | TA0008 | Move to other machines |
| 11 | Collection | TA0009 | Gather data to steal |
| 12 | Command & Control | TA0011 | Communicate with compromised systems |
| 13 | Exfiltration | TA0010 | Steal the data out |
| 14 | Impact | TA0040 | Destroy, encrypt, or disrupt |

## Key Interview Terms

| Term | Definition |
|------|-----------|
| TTP | Tactics, Techniques, and Procedures — the full attacker picture |
| IoC | Indicator of Compromise — evidence of an attack (IP, hash, domain) |
| APT | Advanced Persistent Threat — sophisticated, long-term attacker |
| True Positive | Alert correctly identified a real attack |
| False Positive | Alert fired but no actual attack occurred |
| Tier 1 Analyst | First responder — monitors alerts, performs initial triage |
| Tier 2 Analyst | Deeper investigation, threat hunting, escalation handling |
