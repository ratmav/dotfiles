# style

## comments

- keep code comments minimal
- document **why**, not **what**
- complex patterns reference docs: `# see docs/conventions/dag.md`
- put extensive documentation in `docs/` directory

## documentation style

**writing style: ee cummings meets hemingway**
- lowercase throughout documentation (headings, body text, lists)
- brief, direct sentences
- conversational tone
- humor and satire welcome ("bash sed into submission", "we live in the best of all possible worlds")
- avoid marketing language and hype

**rationale:**
- consistency with how people naturally communicate
- reduces cognitive load (no shifting between cases)
- focuses attention on content, not formatting
- brevity and clarity over formality
- humor makes technical content more enjoyable

**examples:**
```markdown
## command structure                    correct

commands follow left-to-right scope narrowing:

## Command Structure                    wrong

Commands follow left-to-right scope narrowing:
```
