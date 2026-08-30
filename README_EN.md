**English** | [简体中文](README.md)

<div align="center">

# 🔥 Awesome OpenClaw Use Cases CN

**Don't ask what OpenClaw can do. See what people have already built.**

> 17 real-world cases · Copy-paste Prompts & Configs · Markdown + JSON dual format
>
> The most comprehensive Chinese OpenClaw use case library

[![CI](https://github.com/AIPMAndy/awesome-openclaw-use-cases-cn/actions/workflows/ci.yml/badge.svg)](https://github.com/AIPMAndy/awesome-openclaw-use-cases-cn/actions/workflows/ci.yml)
[![Data](https://img.shields.io/badge/data-markdown%20%2B%20json-brightgreen)](docs/USECASES.json)
[![Sync](https://img.shields.io/badge/sync-daily%20auto-blue)](.github/workflows/sync-upstream.yml)
[![Stars](https://img.shields.io/github/stars/AIPMAndy/awesome-openclaw-use-cases-cn?style=social)](https://github.com/AIPMAndy/awesome-openclaw-use-cases-cn/stargazers)

</div>

---

## 💡 What This Solves

Most people don't struggle with "Is OpenClaw powerful?" — they struggle with:

- **What can it actually do?** → Browse real cases
- **Which setups actually work?** → Every case here has been validated
- **Where should I start?** → Check [QUICKSTARTS](docs/QUICKSTARTS.md)

---

## ⭐ Featured Cases (17 Real Scenarios)

### 🤖 Personal Assistant / Life OS

| Case | What It Does | Channel |
|------|-------------|---------|
| [Feishu Personal Assistant](usecases/feishu-personal-assistant.md) | Turn OpenClaw into your daily collaboration hub | Feishu |
| [Telegram Coach](usecases/telegram-coach-assistant.md) | AI in your most-used messenger — ask anything, anytime | Telegram |
| [Founder Chief-of-Staff](usecases/founder-chief-of-staff.md) | AI Chief of Staff for founders: briefings, decisions, follow-ups | Multi |
| [Heartbeat Proactive Assistant](usecases/heartbeat-proactive-assistant.md) | Proactively checks email, calendar, notifications without being asked | All |
| [Calendar Reminder Agent](usecases/calendar-reminder-agent.md) | Smart calendar sync and reminders — never miss a meeting | All |

### ✍️ Content & Research

| Case | What It Does | Channel |
|------|-------------|---------|
| [AI YouTube Video Editing](usecases/ai-youtube-video-editing.md) | Remove pauses and filler words automatically, reducing video length by 40% | Tubeify API |
| [Autonomous Website Operator](usecases/ai-website-operator.md) | Run a website independently with automated journals, SEO, and outreach | All |
| [Content Repurpose](usecases/content-repurpose.md) | One long article → multi-platform content (Twitter, blog, etc.) | CLI / Chat |
| [X/Twitter Automation Agent](usecases/x-twitter-automation-tweetclaw.md) | Search tweets/replies, export followers, draft approved posts/replies, monitor signals | OpenClaw / TweetClaw |
| [AI Research Digest](usecases/ai-research-digest.md) | Auto-fetch + summarize + push daily industry updates | Multi |

### 📊 Productivity

| Case | What It Does | Channel |
|------|-------------|---------|
| [Weekly Report Agent](usecases/weekly-report-agent.md) | Turn scattered updates into polished reports automatically | Feishu / Chat |
| [WhatsApp Client Follow-up](usecases/whatsapp-client-followup.md) | Auto-classify client messages, remind follow-ups, never drop a lead | WhatsApp |
| [Knowledge Base QA](usecases/knowledge-base-qa.md) | Turn scattered info into a queryable knowledge base | All |

### 🛠 Developer & Advanced

| Case | What It Does | Channel |
|------|-------------|---------|
| [Autonomous Domain Registration](usecases/autonomous-domain-registration.md) | Check, pay for, and register domains without browser interaction | LobsterDomains API |
| [GitHub PR Review Agent](usecases/github-pr-review-agent.md) | Code review from your chat — no browser switching | Discord / Chat |
| [Browser Automation](usecases/browser-automation-demo.md) | Agent that clicks, not just talks — web automation | Web |
| [Multi-Agent Orchestration](usecases/multi-agent-orchestration.md) | Multiple agents collaborating on complex tasks | CLI / Chat |

---

## 🆚 Why This Repo?

| Dimension | Typical Lists | This Project |
|-----------|--------------|--------------|
| **Data format** | Markdown only | Markdown + JSON |
| **Change tracking** | Manual | Auto `NEW / UPDATED / REMOVED` |
| **Reliability** | Subjective | `security_risk` / `reproducibility_score` |
| **Time to action** | DIY | [TopN Quickstarts](docs/QUICKSTARTS.md) ready to go |
| **Maintenance** | Manual | CI + daily auto-sync |

---

## 🚀 Quick Start

**Just browsing?** → Click the case links above

**Want to run the data pipeline?** ↓

```bash
chmod +x scripts/*.sh
scripts/fetch_and_build.sh
```

Generates in `docs/`:

| File | Purpose |
|------|---------|
| `USECASES.md` / `.json` | Full index (human + machine readable) |
| `DIFF.md` / `.json` | Delta tracking |
| `QUICKSTARTS.md` / `.json` | TopN execution-ready guides |
| `STATS.md` | Category & risk distribution |
| `SOURCES.md` | Source repos & license snapshots |

<details>
<summary>📎 More commands</summary>

```bash
# Query cases
scripts/query_usecases.sh --keyword security --limit 10

# Generate delta report
scripts/generate_usecases_diff.sh --old docs/USECASES.prev.json --new docs/USECASES.json

# Makefile shortcuts
make test
make build
make query Q=xxx
make quickstarts TOP=20
```

</details>

---

## 🤝 Contributing

**Easiest way:** Open an [Issue](https://github.com/AIPMAndy/awesome-openclaw-use-cases-cn/issues/new) describing:
- What you built with OpenClaw
- Which capabilities you used
- Results & lessons learned

I'll help format it into a publishable case.

**Want to submit a PR?** See [case template](templates/usecase-template.md) and [CONTRIBUTING.md](CONTRIBUTING.md).

---

## 🗺️ Roadmap

- [x] README restructure + bilingual
- [x] Case templates + contribution guide
- [x] 13 example cases
- [x] CI + daily auto-sync
- [ ] Screenshots / GIFs / demo videos
- [ ] Visual navigation page
- [ ] Tag-based search (platform / difficulty / impact)
- [ ] Weekly curated picks / Newsletter

---

## 📄 License

[Apache-2.0](LICENSE) (with additional terms — see LICENSE file)

## 👨‍💻 Author

**AI酋长Andy** — Ex-Tencent/Baidu AI Product Expert, AI Business Strategy Consultant

Business inquiries: WeChat `AIPMAndy`

---

[OpenClaw Docs](https://docs.openclaw.ai) · [OpenClaw GitHub](https://github.com/openclaw/openclaw) · [OpenClaw Community](https://discord.com/invite/clawd)

---

<div align="center">

**Found it useful? Give it a ⭐ Star to help others discover this project**

</div>
