# vision

where the FP core goes after local dotfiles management.

## the pattern

infrastructure orchestration reduces to three operations:

```
1. query actual state    (ssh, curl, git)
2. compare to desired    (text config)
3. apply diff            (ssh, curl, git)
```

no stored state. reality is the source of truth. query it when you need it.

## universal protocols

three tools exist everywhere. they're the adapters:

| protocol | what it queries | integration module |
|----------|----------------|-------------------|
| ssh | hosts (packages, services, users, files) | `ish_ssh_*` |
| curl | APIs (cloud resources, webhooks, endpoints) | `ish_curl_*` |
| git | repos (code, config, state) | `ish_git_*` |

each is an integration module built on the FP primitives.

## state sync

```bash
# generic pattern — works for any queryable system
actual=$(query_fn "$target")
desired=$(load_config "$config_path")
diff=$(compare_fn "$desired" "$actual")
apply_fn "$target" "$diff"
```

- **idempotent** — safe to run repeatedly
- **no locks** — multiple operators can run concurrently
- **no drift** — always queries current state, never caches

## what this enables

- host configuration management (ssh)
- cloud resource provisioning (curl)
- code/config deployment (git)
- fleet operations (parallel across hosts)
- policy validation (query + check against rules)
- drift detection (compare without applying)

## dependencies

```
bash (universal)
├── ssh (hosts)
├── curl (APIs)
├── git (repos)
└── jq (JSON parsing)
```

that's it. no runtime, no agents, no plugins.

## see also

- [layers.md](../architecture/layers.md) — the architecture stack
- [monads.md](../architecture/monads.md) — how composition works at each layer
- [primitives.md](../architecture/primitives.md) — what the FP modules do
