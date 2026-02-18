# ish vision

**ish is underscore.js for bash** — a utility library that makes bash scripting productive, with a task runner and remote module registry.

```
ish = bash utility library + task runner pattern + remote execution + module registry
      │                      │                    │                  │
      │                      │                    │                  └─ share utilities across projects
      │                      │                    └─ ansible alternative
      │                      └─ make/just pattern
      └─ underscore.js/lodash for bash
```

**philosophy:** build the best tool for personal use. design by one, not by committee.

- [layers](vision/layers.md) — core library, projects, module registry
- [static analysis](vision/static_analysis.md) — convention enforcement through linting
- [strategy](vision/strategy.md) — strategic choices, design constraints
