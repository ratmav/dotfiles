# strategic choices

## bash as foundation

- universal runtime — every system has it
- self-contained — no interpreter to install
- bootstrap-friendly — can install everything else
- native system integration — shell commands are first-class

## self-hosted registry

you control trust, internal modules stay internal, no external service dependency. registry is a signed flat file. pgp signatures provide trust without centralization.

## design constraints

1. **live off the land** — minimal dependencies, maximum portability
2. **convention over configuration** — patterns, not yaml
3. **let abstractions emerge** — wait for 2+ instances before extracting
4. **production parity** — test on real systems with real constraints
5. **brevity** — minimum hierarchy levels needed
6. **fail fast** — errors are fatal, warnings continue
7. **self-contained** — copy one file, it works
8. **remote-ready** — same commands work locally or over ssh
