# Incident Report — IR-001
# Security Operations Center — Home SOC Lab

---

## INCIDENT SUMMARY

| Field | Value |
|-------|-------|
| **Report ID** | IR-001 |
| **Date/Time (UTC)** | 2026-06-12 06:23:33.324 |
| **Analyst** | Joseph Daise |
| **Alert Name** | Brute Force - Multiple Failed Logons |
| **Rule ID** | soc-lab-rule-001 |
| **Severity** | Medium |
| **Risk Score** | 47 |
| **Status** | Open |
| **Verdict** | True Positive (Simulated) |

---

## AFFECTED ASSETS

| Field | Value |
|-------|-------|
| **Hostname** | desktop-il7j5pg |
| **IP Address** | 172.16.7.x (Windows11-Endpoint VM) |
| **Operating System** | Windows 11 Enterprise ARM64 |
| **User Account** | targetuser (local account) |

---

## ALERT DETAILS

**Alert triggered by:**
Threshold rule detected 10 or more failed logon events (Event ID 4625) from host desktop-il7j5pg within the detection window, targeting local account "targetuser."

**Detection rule logic:**
```kql
event.code:"4625" and winlog.event_data.LogonType:("2" or "3" or "10")
Threshold: ≥ 5 events grouped by host.name + source.ip
```

**Number of events in alert:** 10 (kibana.alert.threshold_result.count)

**Alert type:** Threshold rule

**Timeframe of activity:** Jun 12, 2026 @ 06:23:33 UTC

---

## TIMELINE

| Time (UTC) | Event |
|------------|-------|
| 06:22:xx | Brute force script initiated on desktop-il7j5pg |
| 06:23:33 | Threshold of failed logons exceeded — alert fired |
| 06:23:33 | Alert entered Open status in Elastic Security |
| 06:27:xx | Alert triaged by analyst |

---

## INVESTIGATION

### Raw Log Evidence

```
Event ID:    4625 (Failed Logon) x10+
Host:        desktop-il7j5pg
Target User: targetuser (local account)
Rule Type:   threshold
Threshold Count: 10
Threshold Value: desktop-il7j5pg::1
Alert Severity: Medium
Risk Score: 47
```

### Analysis

The alert captured a burst of failed logon attempts against local account "targetuser" on host desktop-il7j5pg. The threshold rule fired after detecting 10 or more Event ID 4625 entries within the configured detection window.

Key indicators reviewed:

- **Volume and velocity:** 10+ failed logon attempts in a short window is inconsistent with a user mistyping their password. This pattern is characteristic of automated credential testing.
- **Target account:** "targetuser" is a local account with no business purpose in a production environment. Its presence and targeting warrants investigation.
- **No successful logon:** Event ID 4624 (Successful Logon) was not observed following the failed attempts, indicating the brute force did not succeed.
- **Alert type is threshold:** The rule fired because a volume threshold was crossed, not a single anomalous event — indicating sustained, automated activity.

The pattern is consistent with MITRE ATT&CK T1110 (Brute Force) under the Credential Access tactic.

### MITRE ATT&CK Mapping
- **Tactic:** Credential Access (TA0006)
- **Technique:** Brute Force (T1110)
- **Technique ID:** T1110

---

## VERDICT

**Classification:** True Positive (Simulated Lab Activity)

**Justification:**
The alert accurately detected a simulated brute-force credential attack executed via PowerShell on the monitored Windows endpoint. The volume (10+ attempts), automated timing, and consistent failure pattern confirm malicious-pattern behavior. No legitimate user activity would produce this volume of failed logons against a local account in a short window.

In a production environment this would be escalated as a confirmed true positive requiring immediate response.

---

## RESPONSE ACTIONS

- [x] No action required (lab simulation — no actual threat)

**If this were production, actions would include:**
- [ ] Immediately lock or disable account "targetuser"
- [ ] Isolate desktop-il7j5pg from the network
- [ ] Identify the process that initiated the logon attempts
- [ ] Check for any successful logon (Event ID 4624) before or after the alert window
- [ ] Verify account lockout policy is configured (lockout after 5 attempts)
- [ ] Escalate to Tier 2 with full log export

---

## RECOMMENDATIONS

1. **Configure Account Lockout Policy:** Windows does not lock accounts by default. In a production environment, set lockout threshold to 5 failed attempts with a 15-minute lockout duration via Group Policy.

2. **Monitor for Event ID 4740:** Account lockout events should be correlated with brute force alerts automatically. Add a secondary rule to alert when lockouts follow a burst of 4625 events.

3. **Tune detection threshold:** The current rule fires at 5 events in 1 minute. Monitor baseline logon failure rates for 2 weeks and adjust the threshold to reduce false positives from legitimate password resets.

4. **Investigate account "targetuser":** In a real environment, any local account with no documented business purpose should be reviewed and removed if unnecessary, as it represents an unnecessary attack surface.

---

## REFERENCES
- MITRE ATT&CK T1110: https://attack.mitre.org/techniques/T1110/
- Event ID 4625: https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=4625
- Windows Logon Types: https://learn.microsoft.com/en-us/windows-server/identity/securing-privileged-access/reference-tools-logon-types
