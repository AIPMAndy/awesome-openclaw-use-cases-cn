[English](README_EN.md) | **简体中文**

<div align="center">

# 🔥 Awesome OpenClaw Use Cases CN

**别问 OpenClaw 能干嘛。看别人已经干成了什么。**

> 13 个真实落地案例 · 可复制的 Prompt & 配置 · Markdown + JSON 双格式
>
> 中文世界最值得收藏的 OpenClaw 实战案例库

[![CI](https://github.com/AIPMAndy/awesome-openclaw-use-cases-cn/actions/workflows/ci.yml/badge.svg)](https://github.com/AIPMAndy/awesome-openclaw-use-cases-cn/actions/workflows/ci.yml)
[![Data](https://img.shields.io/badge/data-markdown%20%2B%20json-brightgreen)](docs/USECASES.json)
[![Sync](https://img.shields.io/badge/sync-daily%20auto-blue)](.github/workflows/sync-upstream.yml)
[![Stars](https://img.shields.io/github/stars/AIPMAndy/awesome-openclaw-use-cases-cn?style=social)](https://github.com/AIPMAndy/awesome-openclaw-use-cases-cn/stargazers)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](#-贡献指南)

</div>

---

## 💡 这个项目解决什么

大多数人卡住的不是 "OpenClaw 强不强"，而是：

- **到底能做什么？** → 看案例
- **哪些玩法真能跑通？** → 每个案例都经过验证
- **我应该先抄哪一个？** → 看 [QUICKSTARTS](docs/QUICKSTARTS.md)
- **哪个场景最容易出 wow effect？** → 看下面的精选

---

## ⭐ 精选案例（13 个真实场景）

### 🤖 私人助理 / Life OS

| 案例 | 一句话说明 | 渠道 |
|------|-----------|------|
| [飞书私人助理](usecases/feishu-personal-assistant.md) | 把 OpenClaw 变成日常协作中枢，日程/待办/记忆一体化 | Feishu |
| [Telegram 陪跑助理](usecases/telegram-coach-assistant.md) | 把 AI 放进最高频的聊天入口，随时问随时答 | Telegram |
| [创始人参谋台](usecases/founder-chief-of-staff.md) | 给创始人的 AI Chief of Staff，决策/简报/跟进 | 多渠道 |
| [心跳巡检助理](usecases/heartbeat-proactive-assistant.md) | 不等你问，主动巡检邮件/日历/通知并汇报 | 全平台 |
| [日历提醒 Agent](usecases/calendar-reminder-agent.md) | 自动同步日历，智能提醒不漏事 | 全平台 |

### ✍️ 内容创作 & 研究

| 案例 | 一句话说明 | 渠道 |
|------|-----------|------|
| [内容改写工作流](usecases/content-repurpose.md) | 一篇长文 → 多平台内容（小红书/Twitter/公众号） | CLI / Chat |
| [AI 研究日报](usecases/ai-research-digest.md) | 自动抓取 + 摘要 + 推送，每天 5 分钟看完行业动态 | 多渠道 |

### 📊 办公提效

| 案例 | 一句话说明 | 渠道 |
|------|-----------|------|
| [日报 / 周报 Agent](usecases/weekly-report-agent.md) | 碎片进展自动整理成可汇报内容 | Feishu / Chat |
| [WhatsApp 客户跟进](usecases/whatsapp-client-followup.md) | 客户消息自动分类、提醒跟进、不漏单 | WhatsApp |
| [知识库问答助手](usecases/knowledge-base-qa.md) | 散落信息变成可问可答的知识库 | 全平台 |

### 🛠 开发者 & 高级玩法

| 案例 | 一句话说明 | 渠道 |
|------|-----------|------|
| [GitHub PR Review Agent](usecases/github-pr-review-agent.md) | 在聊天里发起代码 Review，不用切到浏览器 | Discord / Chat |
| [Browser 自动化](usecases/browser-automation-demo.md) | Agent 不只会说，还会点——网页操作自动化 | Web |
| [多 Agent 协作](usecases/multi-agent-orchestration.md) | 让多个 Agent 分工协作，复杂任务拆解执行 | CLI / Chat |

---

## 🆚 跟普通案例列表有什么不同？

| 维度 | 普通列表 | 本项目 |
|------|---------|--------|
| **数据格式** | 纯 Markdown | Markdown + JSON 双格式 |
| **增量追踪** | 手动比对 | 自动 `NEW / UPDATED / REMOVED` |
| **可靠性** | 靠感觉 | `security_risk` / `reproducibility_score` |
| **落地速度** | 自己拆 | [TopN Quickstarts](docs/QUICKSTARTS.md) 一键可用 |
| **维护方式** | 人工更新 | CI + 每日自动同步 |

---

## 🚀 快速使用

**只想看案例？** → 直接点上面的链接

**想跑数据管线？** ↓

```bash
chmod +x scripts/*.sh
scripts/fetch_and_build.sh
```

构建后在 `docs/` 目录生成：

| 文件 | 用途 |
|------|------|
| `USECASES.md` / `.json` | 全量索引（人读 + 机读） |
| `DIFF.md` / `.json` | 增量变化追踪 |
| `QUICKSTARTS.md` / `.json` | TopN 快速落地手册 |
| `STATS.md` | 分类 & 风险分布 |
| `SOURCES.md` | 来源 & 许可证快照 |

<details>
<summary>📎 更多命令</summary>

```bash
# 检索案例
scripts/query_usecases.sh --keyword security --limit 10
scripts/query_usecases.sh --risk high --min-confidence 70 --min-repro 60 --limit 20

# 生成增量报告
scripts/generate_usecases_diff.sh --old docs/USECASES.prev.json --new docs/USECASES.json

# Makefile 快捷方式
make test          # 运行测试
make build         # 全量构建
make query Q=xxx   # 关键词检索
make quickstarts TOP=20
```

</details>

---

## 🤝 贡献指南

**最简单的参与方式：** 提一个 [Issue](https://github.com/AIPMAndy/awesome-openclaw-use-cases-cn/issues/new)，写下：
- 你用 OpenClaw 做了什么
- 用了哪些能力
- 效果 & 踩坑

我会帮你整理成可收录版本。

**想直接提 PR？** 参考 [案例模板](templates/usecase-template.md) 和 [CONTRIBUTING.md](CONTRIBUTING.md)。

### 收录标准

✅ 真实跑通过（不是停留在想法）
✅ 别人能复用（不是只有你看得懂）
✅ 有结果感（截图 / GIF / 效果对比更佳）

❌ 只有概念没有细节
❌ 与 OpenClaw 关系很弱的通用 AI 用例

---

## 🗺️ Roadmap

- [x] README 首页重构 + 中英双语
- [x] 案例模板 + 贡献指南
- [x] 13 个示例案例
- [x] CI + 每日自动同步
- [ ] 补充截图 / GIF / 演示视频
- [ ] 可视化导航页
- [ ] 标签检索（按平台 / 难度 / 效果）
- [ ] 精选案例周刊 / Newsletter

---

## 📄 License

[Apache-2.0](LICENSE)（含附加条款，详见 LICENSE 文件）

## 👨‍💻 作者

**AI酋长Andy** — 前腾讯/百度 AI 产品专家，AI 商业战略顾问

商业授权 / 合作：微信 `AIPMAndy`

---

## 相关资源

- [OpenClaw Docs](https://docs.openclaw.ai) · [OpenClaw GitHub](https://github.com/openclaw/openclaw) · [OpenClaw Community](https://discord.com/invite/clawd)

---

<div align="center">

**觉得有用？给个 ⭐ Star，让更多人发现这个项目**

</div>
