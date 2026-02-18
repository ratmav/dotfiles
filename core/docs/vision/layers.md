# the three layers

```mermaid
graph tb
    subgraph "layer 3: module registry"
        a[ish-docker<br/>docker utilities]
        b[ish-kubernetes<br/>k8s operations]
        c[ish-aws<br/>aws cli helpers]
        d[ish-postgres<br/>db utilities]
        e[community modules...]
    end

    subgraph "layer 2: projects"
        f[ish-dotfiles<br/>personal config]
        g[ish-infra<br/>infrastructure]
        h[ish-myapp<br/>application tasks]
    end

    subgraph "layer 1: framework/utility library"
        i[core utilities]
        j[tui.sh - terminal ui]
        k[platform.sh - detection]
        l[utils.sh - common ops]
        m[remote.sh - ssh execution]
        n[routing.sh - cli dispatch]
    end

    a --> i; b --> i; c --> i; d --> i; e --> i
    f --> i; g --> i; h --> i
    f -.can use.-> a; g -.can use.-> b; h -.can use.-> d
```

## layer 1: core utility library

the foundation — utility functions every bash project needs:

- **terminal ui** (`tui.sh`) — `ish_tui_error`, `ish_tui_warn`, `ish_tui_info`, prompts, template rendering
- **platform detection** (`platform.sh`) — `ish_platform_os` → macos, kali, linux; architecture detection
- **common utilities** (`utils.sh`) — `ish_utils_exists_executable`, `ish_utils_exists_file`, file/string ops
- **remote execution** (`remote.sh`) — ssh-based command execution, file transfer, host groups
- **routing system** — cli argument parsing, command dispatch, convention-driven routing

```bash
ish_tui_info --message="processing..."
ish_platform_os  # returns "macos"
ish_utils_exists_executable brew
ish_remote_exec host1,host2 "uptime"
```

these are the primitives. everything builds on these.

## layer 2: projects

projects consume the framework and add domain-specific tasks:

- **ish-dotfiles** — `ish bootstrap macos all`, `ish git clean prune`
- **ish-infra** — `ish provision web all`, `ish deploy app staging`
- **ish-myapp** — `ish db migrate`, `ish test integration` via `.ishrc`

## layer 3: module registry

reusable modules shared across projects:

- `ish-docker`, `ish-kubernetes`, `ish-aws`, `ish-postgres`, `ish-ssl`, `ish-nginx`

```bash
ish package install ratmav/ish-docker
ish docker container list --format=table
ish docker image prune --all
```

**registry features:**
- git-based distribution (no central package server)
- pgp-signed registry file (verify authenticity)
- self-hostable (private registries)
- namespace enforcement (ish-docker → `ish_docker_*` functions)
- version pinning
