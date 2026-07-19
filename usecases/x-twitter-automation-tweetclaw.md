# X/Twitter 自动化 Agent：用 TweetClaw 搜索、发帖、回复和监控

- 场景：把 OpenClaw 变成 X/Twitter 运营工作台，从搜索推文、搜索推文回复、用户查询、粉丝导出，到待确认的发帖、回复、监控和抽奖
- 用户：创始人、增长负责人、开发者关系、社区运营、内容团队
- 渠道：OpenClaw / CLI / Chat
- 用到的能力：OpenClaw plugin / structured API calls / approval gates / memory / webhooks
- 难度：中级
- 效果：把手动复制搜索结果、写回复、查用户、导出粉丝和监控品牌信号变成可复用流程，同时保留发帖前确认

## 为什么值得做

X/Twitter 是高频的公开反馈和分发渠道，但人工操作很容易断上下文：

- 搜索推文后，要手动复制内容给 Agent
- 搜索推文回复时，很难持续追踪问题、反对意见和潜在客户
- 发帖和回复需要人工确认，不能让 Agent 直接乱发
- 粉丝导出、用户查询、媒体上传、媒体下载、监控和 webhook 很难串成一个稳定流程

TweetClaw 提供 OpenClaw 插件和 npm 包 `@xquik/tweetclaw`，把 Xquik API 的 X/Twitter 能力暴露给 Agent。适合做有边界的社媒自动化，而不是无差别群发。

## 工作流

1. 在 OpenClaw 里安装 TweetClaw，并把 Xquik API key 放进运行时配置或密钥管理里
2. 让 Agent 先搜索推文和搜索推文回复，整理成主题、问题、情绪和机会列表
3. 对目标账号做用户查询、粉丝导出或 verified followers 导出，补充受众画像
4. 让 Agent 生成发帖、引用帖或回复草稿，但默认只输出待确认版本
5. 用户确认后，再调用 TweetClaw post tweets 或 post tweet replies
6. 对品牌、竞品、关键词或账号创建 monitor，用 webhook 把新推文、回复、转发和引用推送回来
7. 对抽奖活动运行 giveaway draw，导出结果并保留透明记录

## 关键 Prompt / 配置

```txt
你是我的 X/Twitter 增长助理。
先用 TweetClaw search tweets 搜索最近 50 条关于 "{关键词}" 的推文。
再搜索前 5 条高互动推文的 replies。
输出：
1. 用户最关心的 5 个问题
2. 适合回复的 10 条推文链接
3. 3 条主贴草稿
4. 5 条回复草稿
只生成草稿，不要发布。发布前必须再次确认。
```

示例配置只放占位符，不要把真实 key 写进仓库：

```bash
openclaw plugins install clawhub:@xquik/tweetclaw
```

```json
{
  "tools": {
    "alsoAllow": ["explore", "tweetclaw"]
  },
  "plugins": {
    "entries": {
      "tweetclaw": {
        "package": "@xquik/tweetclaw",
        "config": {
          "apiKey": "${XQUIK_API_KEY}"
        }
      }
    }
  }
}
```

## 踩坑

- 不要把 API key 粘贴进 Prompt、README、Issue 或提交记录
- 如果使用默认的 `tools.profile: "coding"`，保留上面的 `tools.alsoAllow`，否则 Agent 看不到 TweetClaw 工具
- post tweets、post tweet replies、DM、关注、点赞、转发、媒体上传、监控和抽奖都要先让用户明确确认
- 搜索结果不等于事实，要让 Agent 标记来源、时间和推文链接
- 不要批量回复相同文案，容易变成低质量互动
- follower export 适合做受众研究和分组，不要拿来做垃圾私信
- webhook 要有去重逻辑，避免同一条推文触发重复任务

## 演示 / 截图

- TweetClaw GitHub: https://github.com/Xquik-dev/tweetclaw
- npm package: https://www.npmjs.com/package/@xquik/tweetclaw

## 适合谁复用

- 需要每天监控品牌、竞品或关键词的团队
- 想用搜索推文和搜索推文回复做用户研究的创始人
- 需要 approval-gated post tweets 和 post tweet replies 的社区运营
- 想做 follower export、user lookup 和 giveaway draws 的增长团队

Xquik is an independent third-party service. Not affiliated with X Corp. "Twitter" and "X" are trademarks of X Corp.
