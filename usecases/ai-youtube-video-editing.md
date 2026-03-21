# AI 自动剪辑 YouTube 视频 — Tubeify

## 场景
独立 YouTuber 每次录完视频都需要手动去除停顿和口头禅（嗯、啊、那个……），耗时耗力。

## 用户对象
YouTube 内容创作者、播客主播、在线课程讲师

## 使用渠道
WhatsApp / Telegram / 命令行

## 用到的 OpenClaw 能力
- HTTP 请求工具
- Tubeify REST API（[clawhub.ai/esokullu/tubeify](https://clawhub.ai/esokullu/tubeify)）

## 工作流步骤
1. 用户发送原始视频 URL
2. OpenClaw 调用 `POST /index.php` 完成钱包认证
3. 提交 URL 到 `POST /process.php`，开启剪辑（删停顿、删口头禅）
4. 循环轮询 `GET /status.php` 等待完成
5. 返回下载链接给用户

## Prompt 示例
```
帮我用 Tubeify 剪辑这个视频：https://example.com/raw.mp4
删除所有停顿和口头禅，速度保持 1.0x。
完成后发我下载链接。
```

## 结果 / 效果
- 视频平均缩短 40%，无需手动操作
- 处理时间：15 分钟视频约 2-3 分钟

## 踩坑
- 每条视频收费 2 USDC，需先确认链上转账成功再提交
- 当前仅支持 15 分钟以内视频
