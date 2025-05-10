# [ADR-0005] Deferring Case Archive Implementation (Planned Support)

**Status**: Accepted (Deferred Feature)  
**Date**: 2025-05-07  
**Author**: Mark Dhas

---

## 🎯 Context

As arbitration cases accumulate over time, the system may experience data bloat, slower queries, or administrative friction caused by retaining all case-related data in active tables.

To mitigate this, an archive mechanism is under consideration — one that moves full case details (votes, submissions, participants) out of primary tables and into a read-only, compressed storage format.

However, this need is **not immediate** and should not complicate core development of Lex-DeJure v1.

---

## ✅ Decision

We will **not implement a dedicated archival system** in v1.

Instead, we will:
- Add a nullable `archived_at` column to `arbitration_cases` to mark future archive state
- Avoid unnecessary foreign key coupling to `users`, so data can be flattened later
- Use `user_ref` where practical for long-term identity representation
- Encapsulate all arbitration resolution logic in service classes, so archived resolution can be substituted later

When needed, we may introduce a `arbitration_archives` table with a structured JSONB blob representing a frozen case, and optionally compress/remove related active records.

---

## 💡 Justification

- Keeps v1 lean and focused
- Avoids premature optimization
- Preserves future extensibility without committing to unnecessary complexity
- Future archive support is technically feasible with minimal schema changes

---

## 🔁 Alternatives Considered

| Option | Pros | Cons |
|--------|------|------|
| Implement archive system now | Full readiness | Unneeded complexity, slows v1 |
| Never archive | Simple | Risks performance and legal bloat |
| **Defer but plan support (**chosen**)** | Lightweight, intentional | Requires future implementation effort |

---

## 🧠 Consequences

- All models must be designed with potential “removal from active table” in mind
- Auditability must remain intact post-archival
- All API and logic that summarizes a case must route through a service object, not raw associations

---

## 📍 Notes

- Archive implementation will be re-evaluated after v1 is live and case volume exceeds threshold (TBD).
- If archive