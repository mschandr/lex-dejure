# [ADR-0004] Pluggable Voting Algorithms with Majority Rule Default

**Status**: Accepted  
**Date**: 2025-05-07  
**Author**: Mark Dhas

---

## 🎯 Context

Lex-DeJure must support a variety of voting workflows across different arbitration contexts. In some cases, a simple majority vote is sufficient. In others — such as community governance, organizational decisions, or controversial proposals — more nuanced voting mechanisms (e.g., ranked choice or weighted voting) may be required.

Hardcoding a single voting algorithm would limit Lex-DeJure's applicability and flexibility. However, implementing all voting methods up front would increase complexity without immediate return.

---

## ✅ Decision

Lex-DeJure will support a **pluggable voting algorithm architecture**, where:

- Each `arbitration_case` will have a `voting_method` field (string or enum).
- The vote resolution logic will be delegated to a `VoteResolver` strategy class based on this field.
- The default method will be **plurality (first-past-the-post)**.
- Additional methods will be implemented incrementally in future phases.

This architecture will allow support for different ballot formats and tallying rules, without coupling the vote model or controller logic to any one algorithm.

---

## 💡 Justification

- Supports a wide range of dispute types and organizational needs.
- Enables growth into open-source governance, consensus-based systems, and DAOs.
- Keeps the system modular and maintainable by isolating voting logic.
- Enables future differentiation for the Lex-DeJure platform without rewriting core behavior.

---

## 🧠 Potential Voting Methods to Support

| Method | Description | Use Case | Complexity |
|--------|-------------|----------|------------|
| **Plurality** | Vote for one option, highest wins | Default for v1 | Low |
| **Ranked Choice / IRV** | Voters rank options, lowest is eliminated iteratively | Fairer multi-option elections | High |
| **Approval Voting** | Voters approve any number of options | Panel voting, community input | Low |
| **Weighted Voting** | Each vote has a different weight | Org-based authority systems | Medium |
| **Supermajority** | Passes only if vote share exceeds 66% / 75% | High-risk or final appeals | Low |
| **Random Jury Selection (Sortition)** | Randomly assign judges rather than vote type | Prevent quorum bias | Medium (not a vote method but affects vote legitimacy) |

Ballot structure must adapt to the method:
- Simple (`option`)
- Ranked (`rankings`)
- Approval (`approved_options`)
- Weighted (`option + weight`)

---

## 🔁 Alternatives Considered

| Option | Pros | Cons |
|--------|------|------|
| Hardcode plurality | Simple | Severely limits future applicability |
| Implement all methods now | Fully flexible | Over-engineered, heavy up front |
| **Pluggable system with default majority** (**chosen**) | Balanced, scalable | Slight upfront abstraction cost |

---

## 🧾 Consequences

- Vote resolution must always go through a `VoteResolver` abstraction.
- Ballot model/schema must support extensibility (e.g., `jsonb` field for ranked ballots).
- Each voting method must define:
  - Expected ballot format
  - Tally logic
  - Minimum quorum handling
- Admins (or org policies) will choose the voting method per case.

---

## 📍 Notes

- Add validations to ensure ballots match the expected format for their voting method.
- Provide vote format examples in public documentation per method.
- Consider allowing organizations to restrict which voting methods are allowed within their scope.

---

