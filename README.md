[English](README_EN.md) | **简体中文**

<div align="center">

# awesome-openclaw-Usecases-CN

**把 OpenClaw 上游案例转成可筛选、可追踪、可直接执行的中文数据资产。**

[![CI](https://github.com/AIPMAndy/awesome-openclaw-Usecases-CN/actions/workflows/ci.yml/badge.svg)](https://github.com/AIPMAndy/awesome-openclaw-Usecases-CN/actions/workflows/ci.yml)
[![Data](https://img.shields.io/badge/data-markdown%20%2B%20json-brightgreen)](docs/USECASES.json)
[![Sync](https://img.shields.io/badge/sync-daily-blue)](.github/workflows/sync-upstream.yml)
[![Stars](https://img.shields.io/github/stars/AIPMAndy/awesome-openclaw-Usecases-CN?style=social)](https://github.com/AIPMAndy/awesome-openclaw-Usecases-CN/stargazers)

</div>

## 🆚 为什么选这个？

| 维度 | 常见用例列表 | awesome-openclaw-Usecases-CN |
|---|---|---|
| 数据形态 | 纯 Markdown | `Markdown + JSON` 双格式 |
| 增量追踪 | 手工比对 | 自动产出 `NEW/UPDATED/REMOVED` |
| 可靠性判断 | 靠主观阅读 | `security_risk / source_confidence / reproducibility_score` |
| 落地速度 | 自己拆步骤 | 自动生成 TopN `QUICKSTARTS` |
| 持续维护 | 人工更新 | CI + 每日定时同步 PR |

## 🚀 30 秒快速开始

```bash
chmod +x scripts/*.sh
scripts/fetch_and_build.sh
```

验证产物：

```bash
ls docs/USECASES.md docs/USECASES.json docs/STATS.md docs/SOURCES.md docs/DIFF.md docs/DIFF.json docs/QUICKSTARTS.md docs/QUICKSTARTS.json
```

## 📦 你会得到什么

每次构建会在 `docs/` 生成：

- `USECASES.md`：中文总索引（人读）
- `USECASES.json`：结构化索引（程序读）
- `STATS.md`：分类、风险、License 分布
- `SOURCES.md`：来源仓库、提交、许可证快照
- `DIFF.md` / `DIFF.json`：增量变化（NEW/UPDATED/REMOVED）
- `QUICKSTARTS.md` / `QUICKSTARTS.json`：TopN 可执行落地手册

## 🔍 典型检索

```bash
# 高风险且高可复现用例
scripts/query_usecases.sh --risk high --min-confidence 70 --min-repro 60 --limit 20

# 关键词检索
scripts/query_usecases.sh --keyword security --limit 10
```

## 🛠 核心命令

```bash
# 全量同步（抓取上游 + 生成所有产物）
scripts/fetch_and_build.sh

# 仅基于本地上游仓库生成索引
scripts/generate_usecases_index.sh --src-a /path/to/repo-a --src-b /path/to/repo-b

# 生成来源与许可证快照
scripts/generate_sources_report.sh --src-a /path/to/repo-a --src-b /path/to/repo-b

# 生成增量对比报告
scripts/generate_usecases_diff.sh --old docs/USECASES.prev.json --new docs/USECASES.json

# 生成 TopN 快速落地手册
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

## 🤖 自动化维护

- CI：每次 Push/PR 执行 `lint + test + build smoke`
- 定时同步：每天 UTC `02:00` 自动抓取上游并创建更新 PR
- PR 摘要自动包含：`NEW / UPDATED / REMOVED / Top Quickstarts`

## 💡 使用场景

- 你在做 OpenClaw 相关产品，需要快速复用案例
- 你在搭建知识库，需要机器可读 JSON 数据源
- 你在做教程/内容，需要持续跟踪社区新增案例
- 你想优先做“能跑起来”的 Demo，而非手工整理资料

## 🧱 仓库结构

- `scripts/fetch_and_build.sh`：总入口
- `scripts/generate_usecases_index.sh`：索引与评分生成
- `scripts/generate_sources_report.sh`：来源与许可证快照
- `scripts/generate_usecases_diff.sh`：增量变化报告
- `scripts/generate_quickstarts.sh`：TopN 快速落地手册
- `scripts/query_usecases.sh`：检索与过滤
- `scripts/run_quality_gates.sh`：质量门

## 🗺️ Roadmap

- [ ] 增加更细粒度标签（行业、技术栈、复杂度）
- [ ] 引入相似度去重与冲突合并策略
- [ ] 提供静态检索页面（直接消费 JSON）
- [ ] 增加 Quickstart 模板的可执行脚手架

## 🤝 贡献

欢迎提交 Issue / PR：

- 新增上游来源
- 改进分类/评分规则
- 改进同步脚本与测试覆盖
- 优化文档与合规说明

## 📄 License

- 本仓库采用 [Apache-2.0](LICENSE)
- 同时附加 `ADDITIONAL TERMS / 附加条款`（见 `LICENSE`）

## 👨‍💻 作者

维护者：**AI酋长Andy**

商业授权联系：微信 `AIPMAndy`

---

如果这个项目对你有帮助，欢迎给个 ⭐ Star。
