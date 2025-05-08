# [ADR-0003] Case-Scoped Role System

**Status**: Accepted
**Date**: 2025-05-07
**Author**: Mark Dhas

---

## 🎯 Context

In Lex-DeJure, participants may take on different roles in different contexts:
- A user might be a judge in one arbitration, and a proposer in another.
- Organizations may designate different internal roles (e.g., admin, arbitrator).
- Some arbitrations may be fully public or open to guest observers.

Assigning a single global `role` in the `users` table would be inflexible and inaccurate for these workflows. Additionally, global roles create role collision problems, introduce unnecessary permissions, and violate multi-tenancy boundaries.

---

## ✅ Decision

Lex-DeJure will use **contextual role assignments** scoped to:

1. **Organizations** via the `organization_memberships` table
2. **Arbitration cases** via the `case_participants` table

Each will define `role` independently. Examples:
- Org roles: `admin`, `member`, `inviter`, `observer`
- Case roles: `proposer`, `respondent`, `judge`, `observer`

There will be **no global role column** in the `users` table.

This approach supports dynamic, reusable, and permission-safe access modeling across:
- Arbitrations
- Hosted SaaS tenants
- Public vs. private contexts

---

## 💡 Justification

- Avoids hardcoding global roles that don’t translate across contexts.
- Allows a user to participate in many cases with different responsibilities.
- Keeps permissions scoped to the relevant unit (case or org).
- Aligns with common patterns from GitHub (repo roles), Slack (workspace roles), and Notion (page roles).
- Supports multi-tenancy, traceability, and auditability more effectively.

---

## 🔁 Alternatives Considered

| Option | Pros | Cons |
|--------|------|------|
| Global `users.role` | Simple | Collides across contexts, can't vary by org/case |
| Per-role flags in `users` | Minimal schema | Grows unmanageable, hard to trace |
| **Contextual roles via memberships/participants (**chosen**)** | Granular, future-proof | Requires joins and scoped role logic |

---

## 🧠 Consequences

- Requires permission logic to always be scoped through `case_participants` or `organization_memberships`.
- APIs must resolve role dynamically per context.
- Potential for duplicate role logic across orgs and cases — must be cleanly separated.

---

## 📍 Notes

- Consider building shared RoleResolver service/module to cleanly encapsulate role-checking logic.
- Long-term: case types may define custom role hierarchies or permissions per arbitration type.

---

