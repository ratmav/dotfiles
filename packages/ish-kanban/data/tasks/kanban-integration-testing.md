# kanban-integration-testing

**milestone:** 1 - restructure

**dependencies:** kanban-task-create-integration, kanban-task-close, kanban-task-list-filters

**priority:** high

## description

Complete integration test coverage for kanban task-board integration.

Test scenarios:
- Full lifecycle: create → close
- Validation errors: missing milestone, invalid milestone, nonexistent dependencies
- Board updates: task added to correct section, task removed on close
- Filters: status and milestone filters work

Create test fixtures:
- Minimal fixture board with 2 phases
- Fixture tasks with various priorities and dependencies
- Use `ISH_TESTING` flag

## deliverable

- Integration tests in `core/test/integration/kanban/task.bats`
- Test fixtures in appropriate location
- All tests passing
