# [ADR-0002] Ephemeral User Handling

**Status**: Accepted
**Date**: 2025-05-07
**Author**: Mark Dhas

---

## 🎯 Context

Lex-DeJure is designed to support both long-term registered users and temporary participants (e.g., one-off voters, public observers, or invited guest judges). Requiring full account creation for every interaction would introduce unnecessary friction and reduce accessibility.

At the same time, these users may need scoped access to vote or observe within a single arbitration case — and may later choose to “claim” their voting history by registering.

---

## ✅ Decision

Lex-DeJure will use **ephemeral participants** stored in the `case_participants` table to handle temporary or guest users.

Key rules:

- Ephemeral participants will:
  - Exist only in the context of a single arbitration case.
  - Be identified by an email, hashed `user_ref`, and secure `access_token`.
  - Have no associated `user_id` unless they later register.
  - Be marked with `ephemeral: true`.
- Tokens will:
  - Expire after a configured window (e.g., 48 hours).
  - Be required for access to vote or observe the case.

If a user later registers:
- The system will scan for any matching `case_participants.email` or `user_ref`.
- Matching records will be:
  - Assigned to the new `user_id`.
  - Marked `ephemeral: false`.
  - Their tokens can be revoked or archived.

This enables smooth promotion from guest → persistent user without data loss.

---

## 💡 Justification

- Supports **zero-friction, token-based participation** in public or invite-only cases.
- Avoids polluting the `users` table with non-committed participants.
- Preserves **privacy** and **scope isolation** while enabling **post-hoc account claiming**.
- Allows future conversion of casual users to long-term accounts (SaaS onboarding funnel).
- Keeps system clean and predictable: one record per role, per case.

---

## 🔁 Alternatives Considered

| Option | Pros | Cons |
|--------|------|------|
| Force all users to register | Clean user system | High friction, discourages participation |
| Store all participants in `users` table | Uniformity | Clutters user table with single-use records |
| **Use `case_participants` with ephemeral flag (**chosen**)** | Flexible, minimal, extensible | Requires extra join logic for some analytics |

---

## 🧠 Consequences

- Requires `case_participants` to support both token-based and user-linked entries.
- All voting links must include access token logic + expiration checks.
- If analytics or audit queries are required across users, joins will need to account for both `user_id` and `user_ref`.

---

## 📍 Notes

- Add a migration strategy to "promote" ephemeral records on user registration.
- Future: allow orgs to invite non-registered observers with limited permissions.

---

