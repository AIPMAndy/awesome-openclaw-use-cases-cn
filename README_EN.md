**English** | [简体中文](README.md)

<div align="center">

# awesome-openclaw-Usecases-CN

**Turn upstream OpenClaw use cases into filterable, trackable, and execution-ready data assets.**

[![CI](https://github.com/AIPMAndy/awesome-openclaw-Usecases-CN/actions/workflows/ci.yml/badge.svg)](https://github.com/AIPMAndy/awesome-openclaw-Usecases-CN/actions/workflows/ci.yml)
[![Data](https://img.shields.io/badge/data-markdown%20%2B%20json-brightgreen)](docs/USECASES.json)
[![Sync](https://img.shields.io/badge/sync-daily-blue)](.github/workflows/sync-upstream.yml)
[![Stars](https://img.shields.io/github/stars/AIPMAndy/awesome-openclaw-Usecases-CN?style=social)](https://github.com/AIPMAndy/awesome-openclaw-Usecases-CN/stargazers)

</div>

## 🆚 Why Choose This Repo?

| Dimension | Typical Use Case Lists | awesome-openclaw-Usecases-CN |
|---|---|---|
| Data format | Markdown only | Dual format: `Markdown + JSON` |
| Change tracking | Manual comparison | Automatic `NEW/UPDATED/REMOVED` outputs |
| Reliability signals | Subjective reading | `security_risk / source_confidence / reproducibility_score` |
| Execution speed | You write steps manually | Auto-generated TopN `QUICKSTARTS` |
| Maintenance | Manual updates | CI + daily scheduled sync PR |

## 🚀 30-Second Quick Start

```bash
chmod +x scripts/*.sh
scripts/fetch_and_build.sh
```

Verify outputs:

```bash
ls docs/USECASES.md docs/USECASES.json docs/STATS.md docs/SOURCES.md docs/DIFF.md docs/DIFF.json docs/QUICKSTARTS.md docs/QUICKSTARTS.json
```

## 📦 What You Get

Each build generates these artifacts in `docs/`:

- `USECASES.md`: human-readable Chinese index
- `USECASES.json`: machine-readable index
- `STATS.md`: category, risk, and license distribution
- `SOURCES.md`: source repos, commits, and license snapshots
- `DIFF.md` / `DIFF.json`: delta report (`NEW/UPDATED/REMOVED`)
- `QUICKSTARTS.md` / `QUICKSTARTS.json`: TopN execution-ready guides

## 🔍 Typical Queries

```bash
# High-risk but high-reproducibility use cases
scripts/query_usecases.sh --risk high --min-confidence 70 --min-repro 60 --limit 20

# Keyword search
scripts/query_usecases.sh --keyword security --limit 10
```

## 🛠 Core Commands

```bash
# Full sync (fetch upstream + generate all artifacts)
scripts/fetch_and_build.sh

# Build index from local upstream repositories only
scripts/generate_usecases_index.sh --src-a /path/to/repo-a --src-b /path/to/repo-b

# Generate source and license snapshots
scripts/generate_sources_report.sh --src-a /path/to/repo-a --src-b /path/to/repo-b

# Generate delta report
scripts/generate_usecases_diff.sh --old docs/USECASES.prev.json --new docs/USECASES.json

# Generate TopN quickstarts
scripts/generate_quickstarts.sh --index docs/USECASES.json --top 20
```

## ⚙️ Makefile

```bash
make test
make quality
make build
make query Q=security
make quickstarts TOP=20
```

## 🤖 Automation

- CI: runs `lint + test + build smoke` on every Push/PR
- Scheduled sync: runs daily at UTC `02:00` and opens update PRs
- PR summary includes: `NEW / UPDATED / REMOVED / Top Quickstarts`

## 💡 Use Cases

- You are building OpenClaw products and need reusable patterns quickly
- You are building an internal knowledge base with machine-readable JSON
- You create tutorials/content and need continuous case tracking
- You prefer shipping runnable demos before deep customization

## 🧱 Repository Structure

- `scripts/fetch_and_build.sh`: pipeline entrypoint
- `scripts/generate_usecases_index.sh`: index and scoring
- `scripts/generate_sources_report.sh`: source/license snapshots
- `scripts/generate_usecases_diff.sh`: delta report
- `scripts/generate_quickstarts.sh`: TopN quickstart generator
- `scripts/query_usecases.sh`: query and filtering
- `scripts/run_quality_gates.sh`: quality gates

## 🗺️ Roadmap

- [ ] Add finer-grained tags (industry, stack, complexity)
- [ ] Add similarity-based deduplication and merge strategy
- [ ] Provide a static search UI powered by JSON
- [ ] Add executable quickstart templates/scaffolding

## 🤝 Contributing

Issues and PRs are welcome for:

- Adding new upstream sources
- Improving classification/scoring rules
- Improving sync scripts and test coverage
- Improving docs and compliance guidance

## 📄 License

- This repository is licensed under [Apache-2.0](LICENSE)
- Additional terms are included in `LICENSE`

## 👨‍💻 Author

Maintainer: **AI酋长Andy**

Business contact (WeChat): `AIPMAndy`

---

If this project helps you, please consider giving it a ⭐ Star.
