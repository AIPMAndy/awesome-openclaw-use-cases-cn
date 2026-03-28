# 用加密货币全自主注册域名 — LobsterDomains

## 场景
AI Agent 在构建新项目时需要自动注册域名，但传统注册商需要浏览器操作和信用卡，无法自动化。

## 用户对象
开发者、AI Agent 自动化工作流、独立创业者

## 使用渠道
WhatsApp / Telegram / 命令行 / 自动化工作流

## 用到的 OpenClaw 能力
- HTTP 请求工具
- LobsterDomains REST API（[clawhub.ai/esokullu/lobsterdomains](https://clawhub.ai/esokullu/lobsterdomains)）

## 工作流步骤
1. 调用 `GET /api/v1/domains/check?domain=xxx.com` 查询可用性和价格
2. 确认价格，向指定地址发送 USDC（支持 Ethereum/Arbitrum/Base/Optimism）
3. 提交交易 hash 到 `POST /api/v1/domains/register`
4. 收到 DNS 管理凭据

## Prompt 示例
```
帮我查询 myproject.xyz 是否可用，如果可以，告诉我需要支付多少钱，
我确认后你再帮我完成注册。
```

## 结果 / 效果
- 全程无需打开浏览器，无验证码
- 支持 1000+ 顶级域名后缀

## 踩坑
- 域名到期不自动续费，需手动在到期前续费
- ETH/BTC 支付需注意汇率，建议优先使用 USDC
