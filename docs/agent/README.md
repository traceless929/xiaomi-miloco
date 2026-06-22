# Miloco Agent（替换 OpenClaw）

> **Fork 专属** · 独立 Sidecar，**不修改** Miloco 官方 `backend/` / `cli/` / `web/`。

## 文档

| 文档 | 说明 |
|------|------|
| [ARCHITECTURE.md](./ARCHITECTURE.md) | 架构设计：边界、Webhook 契约、Session、AgentScope、飞书、Cron |
| [DEVELOPMENT_PLAN.md](./DEVELOPMENT_PLAN.md) | 分期开发计划 P0～P5、验收标准、合并策略 |

## 一句话

用仓库根目录 **`miloco-agent/`** Sidecar（AgentScope + 飞书）兼容现有 `agent.webhook_url`，退役 OpenClaw；合并 [upstream](https://github.com/XiaoMi/xiaomi-miloco) 时官方树保持零改动。

## 实现状态

| 阶段 | 状态 |
|------|------|
| P0 Webhook 骨架 | 未开始 |
| P1 AgentScope + 规则 | 未开始 |
| P2 飞书 | 未开始 |
| P3 通知 | 未开始 |
| P4 Cron | 未开始 |
| P5 运维 GA | 未开始 |

（实现启动后更新上表。）
