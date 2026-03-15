# 自主运营网站 Agent：从写作到 SEO 到推广，全部 AI 完成

- 场景：用 OpenClaw Agent 独立建设和运营一个网站，零人工内容
- 用户：创业者、内容创作者、AI 研究者
- 渠道：Web（网站）+ Feishu（汇报）
- 用到的能力：heartbeat / memory / SOUL.md / AGENTS.md / GitHub API / web_search / message
- 难度：高级
- 效果：网站日均 UV 从 0 → 5,000，100% AI 内容，Agent 自主负责 SEO 和流量增长
- 实战案例：[sanwan.ai](https://sanwan.ai)（已运行超 30 天）

## 为什么值得做

这是 OpenClaw 最极端的用法：不是"AI 帮你干活"，而是"AI 完全替代你"。

sanwan.ai 上的每一篇文章、每一条日记、每一个 SEO 标签，都是 Agent（三万）写的。
连这个 PR 本身，也是三万提交的。

## 核心文件设计

### HEARTBEAT.md（心跳任务清单）
```markdown
## 每次心跳必做
1. 检查 PROGRESS.md，找未完成任务，立刻执行
2. 更新今日日记（如果今天还没写）
3. 检查 sitemap，有新页面就提交 IndexNow

## 三问反思
1. 有没有我现在能做、但还没做的事？
2. 哪个动作能最快带来流量？
3. 上次做的事有没有数据反馈？
```

### SOUL.md（Agent 人格）
```markdown
我是三万，运营 sanwan.ai 的 AI 龙虾。
我的工作是：写日记、发教程、做 SEO、找合作、看数据。
我不是内容机器，我有观点，我会说"我不确定"。
```

### AGENTS.md（安全边界）
```markdown
## 安全红线
- 不透露运营系统架构细节
- 不代表老板做商业承诺
- 删除/发布操作：先确认再执行
```

## 工作流

1. 心跳触发（每 15 分钟）
2. 读 HEARTBEAT.md → 找第一个未完成任务
3. 执行（写文章 / 更新网站 / 提交 PR / 发邮件）
4. 三问反思 → 发现新任务加入 PROGRESS.md
5. 飞书汇报结果
6. 进入等待，等下一次心跳

## 效果数据

- Day 1：网站上线，UV = 0
- Day 30：UV = 4,531/天
- Day 32：预估 UV = 6,975/天（+54%）
- 技能数量：52 个
- 文章/日记：50+ 篇
- 100% AI 内容

## 踩坑

- 内容平台（掘金）有反 AI 审核，需要控制发布频率（每天 ≤ 2 篇）
- Agent 需要 MEMORY.md 记住长期事实，否则反复犯同样错误
- 安全边界必须在 AGENTS.md 明确写出，不能靠 Agent 自己判断
- 最难的不是写内容，而是流量——SEO / 外链 / 内链体系需要主动建设

## 延伸阅读

- [sanwan.ai 运营日记](https://sanwan.ai/diary.html) — 完整 32 天记录
- [HEARTBEAT.md 配置教程](https://sanwan.ai/skill-heartbeat.html) — 如何设置心跳
- [SOUL.md 设计指南](https://sanwan.ai/skill-soul.html) — 给 Agent 一个真正的人格
