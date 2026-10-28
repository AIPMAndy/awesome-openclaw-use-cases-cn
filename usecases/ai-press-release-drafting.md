# AI 自动起草并发布新闻稿 — pressreleases.online

## 场景
产品发布或重要里程碑时，需要快速生成专业的新闻稿并对外发布，但写稿耗时、发布平台繁琐。

## 用户对象
独立开发者、初创团队、产品经理、AI Agent 自动化营销工作流

## 使用渠道
命令行 / WhatsApp / Telegram / 自动化工作流

## 用到的 OpenClaw 能力
- HTTP 请求工具
- pressreleases.online API（[pressreleases.online](https://pressreleases.online)）

## 工作流步骤
1. 调用 `POST /api/v1/releases`，传入 `website`（产品网址）、`email`、`notes`（发布要点）
2. AI 自动抓取网站内容并起草新闻稿
3. 收到邮件验证码（取 md5(email)[-4:]），调用 `POST /api/v1/releases/confirm` 确认发布
4. 获得公开新闻稿链接，附带 RSS feed 和 Sitemap

## Prompt 示例
```
帮我为 https://myapp.com 起草一篇新闻稿，主题是我们刚刚上线了 v2.0，
新增了 AI 自动摘要功能。请用 pressreleases.online 发布。
```

## 结果 / 效果
- 几秒内生成专业新闻稿并发布上线
- 自动生成 RSS feed，便于媒体订阅
- 无需注册账号，完全免费

## 踩坑
- 需要访问邮件获取 4 位验证码才能确认发布
- 发布后暂不支持编辑，请在确认前仔细核对内容
