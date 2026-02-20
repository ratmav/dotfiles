# setup mdBook documentation system

**phase:** 6

**dependencies:** none

## description

set up mdBook-based documentation for ish core and packages. use mdbook-mermaid for diagrams. `ish docs` auto-discovers package docs alongside core docs.

clean, browsable documentation with mermaid diagrams, built from markdown.

## subtasks

**installation (system-level, not nix):**
- [ ] install mdBook via cargo: `cargo install mdbook`
- [ ] install mdbook-mermaid: `cargo install mdbook-mermaid`
- [ ] verify installation: `mdbook --version`

**core docs:**
- [ ] initialize mdBook in `core/docs/`
- [ ] configure book.toml with mermaid plugin
- [ ] organize existing docs into book structure:
  - architecture/ docs
  - conventions/ (split into 13 files)
  - testing/ (split into 4 files)
  - vision/ (split into 3 files)
- [ ] add SUMMARY.md with chapter structure
- [ ] build and verify: `mdbook build`

**package docs auto-discovery:**
- [ ] `ish docs build` scans `packages/ish-*/docs/` for package books
- [ ] if a package has docs, include as a chapter or linked book
- [ ] packages without docs are silently skipped
- [ ] convention: each package can have its own `book.toml` or just markdown files that get pulled into the main book

**ish commands:**
- [ ] implement `ish_docs_build` - build core + discovered package docs
- [ ] implement `ish_docs_serve` - serve docs locally (mdbook serve), print URL
- [ ] add routing for `ish docs`

**CI integration:**
- [ ] add docs build to CI workflow
- [ ] fail CI if docs build fails
- [ ] optionally: deploy docs to GitHub Pages

## deliverable

working mdBook documentation system with auto-discovery. `ish docs serve` shows core docs + any package docs that exist.

## notes

**why mdBook:**
- markdown-based (already using)
- clean, searchable HTML output
- built-in local server
- mermaid diagram support
- simple, no complex build system

**NOT via nix — nix is only for per-project dev environments.**

**structure:**
```
core/docs/
├── book.toml
├── src/
│   ├── SUMMARY.md
│   ├── introduction.md
│   ├── architecture/
│   ├── conventions/
│   ├── testing/
│   └── vision/
└── book/                        # generated HTML (gitignored)

packages/ish-kanban/docs/        # auto-discovered, included in build
packages/ish-ratfiles/docs/      # auto-discovered, included in build
```

**commands:**
```bash
ish docs build
# builds core/docs + discovers packages/ish-*/docs/

ish docs serve
# serves combined docs, prints URL to visit
```
