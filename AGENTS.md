# AGENTS.md — AI 协作者指南（Fork 本地专用）

本文件面向 Cursor、Codex、Claude Code 等 AI 编码助手，帮助在本 fork 上安全地参与开发。

> **勿向官方上游 PR 提交本文件及 `.cursor/` 目录。** 见下文「向官方贡献 PR」。

---

## Git 远端

| Remote | 仓库 | 用途 |
|--------|------|------|
| `origin` | [traceless929/xiaomi-miloco](https://github.com/traceless929/xiaomi-miloco) | 个人 fork，日常 push |
| `upstream` | [XiaoMi/xiaomi-miloco](https://github.com/XiaoMi/xiaomi-miloco) | 官方源，同步与向上游提 PR |

```bash
git fetch upstream
git merge upstream/main          # 或 rebase，按团队习惯
git push origin main
```

---

## Fork 专属文件（勿进官方 PR）

以下路径**仅存在于本 fork**，向 [XiaoMi/xiaomi-miloco](https://github.com/XiaoMi/xiaomi-miloco) 提 PR 时必须排除：

```
AGENTS.md
.cursor/
docs/
miloco-agent/
.fork-only
scripts/check-upstream-pr.sh
scripts/miloco-agent-*.sh
```

清单亦见 [`.fork-only`](.fork-only)（供脚本读取）。

**项目开发文档**：[docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)  
**Agent 替换 OpenClaw（零侵入官方代码）**：[docs/agent/ARCHITECTURE.md](docs/agent/ARCHITECTURE.md) · [docs/agent/DEVELOPMENT_PLAN.md](docs/agent/DEVELOPMENT_PLAN.md)

### 向官方贡献 PR

1. 从 `upstream/main` 拉功能分支，**只 cherry-pick / 提交业务改动**，不要带上 fork 专属文件。
2. 开 PR 前自检：

```bash
bash scripts/check-upstream-pr.sh
```

3. 若误把 fork 文件带进分支，在 PR 分支上移除：

```bash
git rm -r --cached AGENTS.md .cursor 2>/dev/null || true
git checkout upstream/main -- AGENTS.md 2>/dev/null || git rm -f AGENTS.md 2>/dev/null || true
# .cursor 在 upstream 不存在，直接 git rm -r --cached .cursor
```

4. PR 目标仓库：`XiaoMi/xiaomi-miloco`（base: `main`）。

---

## 项目是什么

**Miloco 2.0** 是小米开源的全屋智能 AI 方案：以米家摄像头为感知入口、MiMo 等多模态大模型为大脑，以 **OpenClaw 插件 + 16 个 Skill** 形式运行，联动米家设备实现主动智能。

四条主链路：**设备控制**、**感知→规则→设备**、**Agent 指令**、**家庭记忆注入**。详见 [knowledge/01-overview/overview.md](knowledge/01-overview/overview.md)。

---

## 仓库结构

```
backend/          # Python uv workspace：miloco（FastAPI 服务）+ miot（SDK 子包）
cli/              # miloco-cli（Click）
plugins/
  openclaw/       # TypeScript OpenClaw 插件
  skills/         # miloco-* Skill 文档（构建时复制进插件）
web/              # 家庭面板（React 19 + Vite + Tailwind）
knowledge/        # 项目知识库（与官方共享，改功能时同步更新）
scripts/          # build.sh / install.sh / install-guide.md
.agents/commands/ # Agent 斜杠命令（官方仓库，review-pr 指向 XiaoMi）
```

---

## 读文档的顺序

1. **[docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)** — 项目结构、架构、模块职责与开发落地（Fork 专属）
2. **[docs/agent/ARCHITECTURE.md](docs/agent/ARCHITECTURE.md)** — 用 AgentScope Sidecar 替换 OpenClaw（**不侵入官方 backend**）
3. **[knowledge/README.md](knowledge/README.md)** — 知识库规范与全局索引
4. **[knowledge/01-overview/overview.md](knowledge/01-overview/overview.md)** — 架构、分层、数据流
5. **[knowledge/06-dev-guide/dev-guide.md](knowledge/06-dev-guide/dev-guide.md)** — 安装、启动、测试、配置
6. 改具体模块时读 **knowledge/03-features/** 对应篇目

**原则**：配置默认值、API 字段、函数内部流程以代码 / schema / `--help` 为准。

---

## 后端分层约定

Server 遵循 **Router → Service/Runner → Repo/外部代理**，依赖由 `manager.py` 注入。

| 层 | 职责 | 勿做 |
|----|------|------|
| Router | HTTP、参数校验、鉴权前置 | 业务逻辑、直接 SQL |
| Service | 跨域编排 | 长循环后台任务 |
| Runner | 感知/规则等持续循环 | 同步阻塞 HTTP |
| Repo | SQLite 持久化 | 调用外部 API |

---

## 常用命令

```bash
# Backend（在 backend/ 目录）
uv sync --all-groups
uv run task dev      # 开发服务器 :1810
uv run task test     # pytest
uv run task lint     # ruff
uv run task check    # ty 类型检查

# OpenClaw 插件
cd plugins/openclaw && pnpm run build && pnpm test

# 家庭面板
cd web && pnpm dev && pnpm test && pnpm typecheck
```

一键本地安装：`bash scripts/install.sh --dev`

---

## 修改时的注意事项

- **单进程**：Server 不支持 multi-worker。
- **Skill 单一来源**：只改 `plugins/skills/`，构建时复制到 `plugins/openclaw/skills/`。
- **知识库**：功能变更同步 `knowledge/03-features/`（L1/L2）。
- **许可证**：非商业用途；未要求勿提交 commit。

---

## Cursor 规则

Fork 专属规则在 [`.cursor/rules/`](.cursor/rules/)，按文件类型自动生效，勿提交至官方 PR。
