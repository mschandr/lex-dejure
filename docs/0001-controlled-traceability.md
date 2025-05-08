# [ADR-0001] Controlled Traceability of Votes

**Status**: Accepted  
**Date**: 2025-05-07  
**Author**: Mark Dhas

---

## 🎯 Context

Lex-DeJure must support secure, anonymous voting in arbitration cases. However, legal and compliance needs may require traceability in certain situations — such as audit investigations, internal misconduct, or challengeable arbitration outcomes.

Full anonymity makes it impossible to verify who cast which vote in retrospect. However, unrestricted traceability compromises privacy, introduces potential abuse, and breaks user trust.

---

## ✅ Decision

Lex-DeJure will implement **controlled traceability**:

- Votes will **not expose user identity by default** (UI/API level).
- Each vote will be linked in the database to a `user_id` or `case_participant_id`.
- A `privileged_auditor` flag on the `users` table will gate access to this traceability.
- All vote-trace access events will be logged in the `audit_logs` table, including:
  - `actor_id` (admin who traced)
  - `target_user_id`
  - `arbitration_case_id`
  - `reason` (manual entry)
- The system will require privileged auditors to provide justification for each trace access.
- All of this behavior must be **documented in the Terms of Use or Privacy Policy**.

---

## 💡 Justification

- Enables Lex-DeJure to satisfy **legal accountability and compliance** needs without sacrificing default privacy.
- Balances **user trust** with **auditability**.
- Provides legal defensibility in environments where anonymous decisions must still be traceable post-factum (e.g. corporate, legal, HR, or government settings).
- Ensures we are not blind to vote tampering, fraud, or procedural abuse.

---

## 🔁 Alternatives Considered

| Option | Pros | Cons |
|--------|------|------|
| Full anonymity (no traceability) | Strong privacy, easy to build | Legally risky, unverifiable outcomes |
| Unrestricted traceability | Simple implementation | Breaches privacy, invites abuse, violates compliance norms |
| Controlled traceability (**chosen**) | Balanced, auditable, compliant | Requires strict role enforcement + audit logging |

---

## 🧠 Consequences

- Must implement secure role-checking for vote trace access.
- All vote access must be routed through a tracing service or gateway that logs the request.
- Adds minimal performance overhead but significant compliance coverage.
- Must maintain user-facing documentation describing traceability policy.

---

## 📍 Notes

- Consider exposing vote-tracing audit logs to users in their account settings for transparency.
- Long-term: allow organizations to enforce stricter or looser vote privacy policies.

---
