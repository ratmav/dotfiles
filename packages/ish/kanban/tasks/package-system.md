# 002: package system for extending ish

**milestone:** 4 - module registry

**dependencies:** phase 3 task 003 (framework stable)

## description

create a package system for sharing ish modules across projects with a signed, self-hostable registry.

## subtasks

- [ ] design package structure (git repos with ish-style code)
- [ ] implement `ish package install user/repo` (clones into packages directory)
- [ ] implement package loading (source modules into ish namespace)
- [ ] enforce namespace convention (packages must prefix functions with package name)
- [ ] create registry format (simple static json/yaml file)
- [ ] implement pgp signature verification for registry
- [ ] make registry self-hostable
- [ ] host as ish-registry repo or static site
- [ ] document package creation guide

## deliverable

package system with signed, self-hostable registry

## notes

**registry example:** `{"ish-docker": "github.com/ratmav/ish-docker"}`
verification checks signature before trusting registry contents (like debian package lists)
