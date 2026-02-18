# setup mdBook documentation system

**milestone:** 2 - fp core + cleanup

**dependencies:** phase 1 (restructure complete)

## description

Set up mdBook-based documentation for ish and dotfiles packages. Use mdbook-mermaid for diagrams. Each package has its own book in docs/.

Clean, browsable documentation with mermaid diagrams, built from markdown.

## subtasks

**Installation (system-level, not nix):**
- [ ] install mdBook via cargo: `cargo install mdbook`
- [ ] install mdbook-mermaid: `cargo install mdbook-mermaid`
- [ ] verify installation: `mdbook --version`

**ish Package Docs:**
- [ ] initialize mdBook in packages/ish/docs/
- [ ] configure book.toml with mermaid plugin
- [ ] organize existing docs into book structure:
  - architecture/ docs
  - conventions/ (split into 13 files)
  - testing/ (split into 4 files)
  - vision/ (split into 3 files)
- [ ] add SUMMARY.md with chapter structure
- [ ] build and verify: `mdbook build`

**dotfiles Package Docs:**
- [ ] initialize mdBook in packages/ish_dotfiles/docs/
- [ ] configure book.toml with mermaid plugin
- [ ] organize bootstrap/nix/git documentation
- [ ] add SUMMARY.md
- [ ] build and verify

**ish Commands:**
- [ ] implement `ish_self_docs_build` - build ish documentation
- [ ] implement `ish_self_docs_serve` - serve docs locally (mdbook serve)
- [ ] implement `ish_self_docs_open` - open docs in browser
- [ ] add routing for `ish self docs`

**CI Integration:**
- [ ] add docs build to CI workflow
- [ ] fail CI if docs build fails
- [ ] optionally: deploy docs to GitHub Pages

**Documentation:**
- [ ] document mdBook setup in README
- [ ] document how to add new chapters
- [ ] document mermaid diagram usage

## deliverable

Working mdBook documentation system for ish and dotfiles packages, with build/serve commands.

## notes

**Why mdBook:**
- Markdown-based (already using)
- Clean, searchable HTML output
- Built-in local server
- Mermaid diagram support
- Used by Rust (proven tool)
- Simple, no complex build system

**Installation (system-level):**
```bash
# Install via cargo (rust toolchain)
cargo install mdbook
cargo install mdbook-mermaid

# Or via system package manager
# macOS: brew install mdbook
# Debian/Ubuntu: cargo install (not in apt)
```

**NOT via nix - nix is only for per-project dev environments.**

**Structure:**
```
packages/ish/docs/
├── book.toml                    # mdBook config
├── src/
│   ├── SUMMARY.md              # Table of contents
│   ├── introduction.md
│   ├── architecture/
│   │   ├── overview.md
│   │   ├── core_concepts.md
│   │   └── functional_future/
│   ├── conventions/
│   ├── testing/
│   └── vision/
└── book/                        # Generated HTML (gitignored)
```

**book.toml example:**
```toml
[book]
title = "ish Documentation"
authors = ["ratmav"]
language = "en"
multilingual = false
src = "src"

[output.html]
mathjax-support = false

[preprocessor.mermaid]
command = "mdbook-mermaid"

[output.html.fold]
enable = true
level = 0
```

**Commands:**
```bash
# Build docs
ish self docs build
# Runs: mdbook build packages/ish/docs

# Serve locally
ish self docs serve
# Runs: mdbook serve packages/ish/docs
# Opens: http://localhost:3000

# Open in browser
ish self docs open
# Opens: packages/ish/docs/book/index.html
```

**Mermaid diagrams:**
````markdown
```mermaid
graph LR
    A[FP Core] --> B[Semantic Layer]
    B --> C[Clean Code]
```
````

**Benefits:**
- Clean, professional documentation
- Searchable
- Versioned (in git with code)
- Local preview while writing
- Mermaid diagrams render properly
- Can deploy to GitHub Pages
- System utility (installed via cargo, not nix)
