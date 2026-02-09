## Dependency Management

### Declaration

Packages declare dependencies in `source/self/dependencies.sh`:

```bash
#!/usr/bin/env bash

# List of required peer packages (namespace format)
foo_self_dependencies() {
  cat <<EOF
github/ratmav/ish
github/user/another-package
EOF
}
```

### Resolution

**Key Principle:** Dependencies are PEER packages (composition, not inheritance)

- ish loads packages, not packages loading packages
- All packages install to same directory: `~/.local/share/ish/packages/`
- No parent/child relationships
- No nested dependencies (flat dependency graph)
- Prevents cross-tree complexity and DAG sprawl

**Algorithm:**

```bash
ish package install --namespace=foo
  1. Check if foo is in registry
  2. Clone foo to packages/
  3. Read foo_self_dependencies()
  4. For each dependency:
     a. Check if already installed
     b. If not, install it (non-recursive - dependencies are flat)
     c. Validate dependency exists
  5. Load all packages (including dependencies)
```

**Validation:**

- Circular dependencies: Not possible (flat graph)
- Missing dependencies: Fail install with error
- Version conflicts: Not applicable (always HEAD of main)
