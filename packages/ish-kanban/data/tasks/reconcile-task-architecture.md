# reconcile task architecture

**phase:** 2

**dependencies:** complete-doc-audit

## description

document the top-down architectural decision in the appropriate architecture doc (likely overview.md).

**decision:** ish uses top-down architecture. ish orchestrates, packages extend. dependency direction is `ish → packages`. rejected bottom-up (projects importing framework).

## subtasks

- [ ] add top-down decision to architecture overview (or appropriate doc)
- [x] delete `core/docs/architecture/task_reconciliation.md`

## deliverable

architectural decision documented in its proper home. reconciliation doc removed.
