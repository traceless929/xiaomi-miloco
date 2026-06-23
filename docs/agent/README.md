# Miloco Agent（替换 OpenClaw）

> **Fork 专属** · 独立 Sidecar，**不修改** Miloco 官方 `backend/` / `cli/` / `web/`。

## 文档

| 文档 | 说明 |
|------|------|
| [ARCHITECTURE.md](./ARCHITECTURE.md) | 架构设计：边界、Webhook 契约、Session、AgentScope、飞书、Cron |
| [DEVELOPMENT_PLAN.md](./DEVELOPMENT_PLAN.md) | 分期开发计划 P0～P5、验收标准、合并策略 |
| [FEISHU_SETUP.md](./FEISHU_SETUP.md) | 飞书机器人接入与排错 |
| [ADMIN_PLATFORM.md](./ADMIN_PLATFORM.md) | Agent 管理配置台（:18789/admin） |
| [BRIDGE.md](./BRIDGE.md) | OpenClaw 生态桥接（Skill + 专有工具） |

## 一句话

用仓库根目录 **`miloco-agent/`** Sidecar（AgentScope + 飞书）兼容现有 `agent.webhook_url`，退役 OpenClaw；合并 [upstream](https://github.com/XiaoMi/xiaomi-miloco) 时官方树保持零改动。

## 实现状态

| 阶段 | 状态 |
|------|------|
| P0 Webhook 骨架 | ✅ 已完成 |
| P1 AgentScope + 设备 Tools | ✅ 已完成 |
| P2 飞书 | ✅ 长连接 + MD/流式 + 多轮历史（`feishu:{open_id}`） |
| P3 通知 | ✅ policy + notify_send + TTS |
| P4 Cron/记忆/trace | ✅ 调度 + Tools + catalog + get_trace meta |
| P5 任务 Cron/运维 | ✅ user cron + agent_pending + 安装/supervisor 文档 |
| P6 管理配置平台 | ✅ `/admin` + API（LLM/飞书/Cron/桥接/P6+） |

（实现启动后更新上表。）
