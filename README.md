# Superpowers

Superpowers 是一套面向 coding agent 的完整软件开发方法论，建立在可组合技能和一组引导 agent 使用这些技能的基础指令之上。

## 目录

- [工作原理](#工作原理)
- [商业服务](#商业服务)
- [安装](#安装)
  - [Claude Code](#claude-code)
  - [Antigravity](#antigravity)
  - [Codex App](#codex-app)
  - [Codex CLI](#codex-cli)
  - [Cursor](#cursor)
  - [Devin CLI](#devin-cli)
  - [Factory Droid](#factory-droid)
  - [Gemini CLI](#gemini-cli)
  - [GitHub Copilot CLI](#github-copilot-cli)
  - [Grok Build CLI](#grok-build-cli)
  - [Kimi Code](#kimi-code)
  - [OpenCode](#opencode)
  - [Pi](#pi)
  - [Hermes Agent](#hermes-agent)
- [基本工作流](#基本工作流)
- [社区](#社区)
- [包含内容](#包含内容)
- [理念](#理念)
- [贡献](#贡献)
- [更新](#更新)
- [许可证](#许可证)
- [Visual companion telemetry](#visual-companion-telemetry)

## 工作原理

从启动 coding agent 的那一刻起，Superpowers 就开始工作。当 agent 发现你正在构建某项内容时，它不会直接开始编写代码，而是先停下来询问你真正想完成什么。

从对话中提炼出规格后，它会将规格拆成足够短的部分，方便你阅读和理解。

你批准设计后，agent 会整理出一份清晰的实施计划，即使是经验不足、缺少项目上下文且不重视测试的初级工程师也能遵循。计划强调真正的 RED-GREEN TDD、YAGNI（You Aren't Gonna Need It）和 DRY。

当你说“go”后，agent 会在当前会话中执行实施计划，在继续下一项任务前检查并审查当前工程任务。这个过程让工作始终与计划保持一致，并保留定期验证检查点。

系统还有更多内容，但这就是核心。技能会在适用时被识别；agent 会先向你说明准备调用的技能并请求授权，获得授权后才会调用，因此你可以控制是否进入相应流程。

## 商业服务

如果你在企业中使用 Superpowers，并希望获得商业支持、额外工具或托管支出服务，欢迎联系 sales@primeradiant.com。

## 安装

安装方式取决于 harness。如果你使用多个 harness，需要分别为每个 harness 安装 Superpowers。

### Claude Code

从当前 fork 注册并安装 Superpowers：

- 注册 fork 自带的插件市场：

  ```text
  /plugin marketplace add kingtongxingsheng/superpowers
  ```

- 安装 fork 版本：

  ```text
  /plugin install superpowers-cn@superpowers-dev
  ```

### Antigravity

从本仓库安装 Superpowers 插件：

```bash
agy plugin install https://github.com/kingtongxingsheng/superpowers
```

Antigravity 会加载插件中的技能，更新时使用相同命令重新安装。

### Codex App

当前 fork 未发布到 Codex 官方插件市场，Codex App 没有可从本仓库验证的 fork 直接安装命令。不要在官方市场中安装同名原版插件。

### Codex CLI

当前 fork 未发布到 Codex 官方插件市场，Codex CLI 没有可从本仓库验证的 fork 直接安装命令。不要在官方市场中安装同名原版插件。

### Cursor

当前 fork 没有从仓库或 Cursor 官方文档中验证出的直接安装命令。不要使用 Cursor 市场中的同名原版插件。

### Devin CLI

- 从本仓库安装插件：

  ```bash
  devin plugins install kingtongxingsheng/superpowers
  ```

- 更新到最新版本：

  ```bash
  devin plugins update superpowers
  ```

### Factory Droid

- 注册市场：

  ```bash
  droid plugin marketplace add https://github.com/kingtongxingsheng/superpowers
  ```

- 安装插件：

  ```bash
  droid plugin install superpowers-cn@superpowers
  ```

### Gemini CLI

- 安装扩展：

  ```bash
  gemini extensions install https://github.com/kingtongxingsheng/superpowers
  ```

- 后续更新：

  ```bash
  gemini extensions update superpowers
  ```

### GitHub Copilot CLI

- 注册当前 fork 自带的插件市场：

  ```bash
  copilot plugin marketplace add kingtongxingsheng/superpowers
  ```

- 安装 fork 版本：

  ```bash
  copilot plugin install superpowers-cn@superpowers-dev
  ```

### Grok Build CLI

当前 fork 没有从仓库或 Grok Build CLI 官方文档中验证出的直接安装命令。不要使用 Grok 官方市场中的同名原版插件。

### Kimi Code

Superpowers 位于 Kimi Code 的插件市场中。

- 打开 Kimi Code 插件管理器：

  ```text
  /plugins
  ```

- 进入 `Marketplace` > `Superpowers` 并安装。

- 或直接从本仓库安装：

  ```text
  /plugins install https://github.com/kingtongxingsheng/superpowers
  ```

- 详细文档：[docs/README.kimi.md](docs/README.kimi.md)

### OpenCode

OpenCode 使用独立的插件安装方式；即使你已经在其他 harness 中使用 Superpowers，也需要为 OpenCode 单独安装。

- 告诉 OpenCode：

  ```text
  Fetch and follow instructions from https://raw.githubusercontent.com/kingtongxingsheng/superpowers/refs/heads/main/.opencode/INSTALL.md
  ```

- 详细文档：[docs/README.opencode.md](docs/README.opencode.md)

### Pi

从本仓库安装 Superpowers Pi package：

```bash
pi install git:github.com/kingtongxingsheng/superpowers
```

本地开发时，将当前 checkout 作为临时 package 加载运行 Pi：

```bash
pi -e /path/to/superpowers
```

Pi package 会加载 Superpowers 技能和一个小型扩展。Pi 原生支持技能，因此不需要兼容性的 `Skill` 工具。子代理和任务列表工具仍然是可选的 Pi companion packages。

### Hermes Agent

从本仓库安装 Superpowers Hermes 插件：

```bash
hermes plugins install kingtongxingsheng/superpowers --enable
```

安装后重启所有正在运行的 Hermes 会话。

## 基本工作流

1. **brainstorming** - 在准备编写代码前，检查是否需要头脑风暴；说明用途并等待用户授权后，才通过提问细化想法、探索替代方案，并分节展示设计。保存设计文档。

2. **using-git-worktrees** - 设计获用户批准并再次获得技能调用授权后使用。它会在新分支上创建隔离工作区，运行项目设置，并验证干净的测试基线。

3. **writing-plans** - 设计获批准并授权后使用。将工作拆成细小任务（每项 2—5 分钟），每项包含准确文件路径、完整代码和验证步骤。

4. **executing-plans** - 获用户授权后使用实施计划，按任务执行并在检查点验证。

5. **test-driven-development** - 仅在任务实际涉及实现代码、修复 bug、重构或测试变更，且用户授权后使用。遵循 RED-GREEN-REFACTOR：写失败测试、观察失败、写最小实现、观察通过并提交。删除测试之前编写的代码。

6. **requesting-code-review** - 获用户授权后，在需要审查时使用。根据计划检查工作，并按严重程度报告问题；关键问题会阻止继续。

7. **finishing-a-development-branch** - 获用户授权后，在任务完成时使用。验证测试，展示 merge/PR/keep/discard 选项，并清理 worktree。

**技能不是自动建议或自动调用的。**agent 只能在先说明用途并获得用户明确授权后调用适用技能。

## 社区

Superpowers 由 [Jesse Vincent](https://blog.fsck.com) 和 [Prime Radiant](https://primeradiant.com) 的其他成员共同构建。

- **Discord**：[加入社区](https://discord.gg/35wsABTejz)，获得支持、提问并分享你正在构建的内容；
- **Issues**：https://github.com/kingtongxingsheng/superpowers/issues；
- **发布公告**：[订阅](https://primeradiant.com/superpowers/)，获取新版本通知。

## 包含内容

### 技能库

**测试**
- **test-driven-development** - RED-GREEN-REFACTOR 循环（包含测试反模式参考）

**调试**
- **systematic-debugging** - 四阶段根因处理流程（包含 root-cause-tracing、defense-in-depth 和 condition-based-waiting 技术）
- **verification-before-completion** - 确保问题确实已修复

**协作**
- **brainstorming** - 苏格拉底式设计细化
- **writing-plans** - 详细实施计划
- **executing-plans** - 带检查点的任务执行
- **using-git-worktrees** - 并行开发分支
- **finishing-a-development-branch** - Merge/PR 决策工作流

**元技能**
- **writing-skills** - 按最佳实践创建技能（包含测试方法）

## 理念

- **测试驱动开发** - 始终先写测试；
- **系统化而非临时处理** - 依靠流程，而不是猜测；
- **降低复杂度** - 将简单作为首要目标；
- **证据胜于声明** - 在宣布成功前先验证。

阅读[原始发布公告](https://blog.fsck.com/2025/10/09/superpowers/)。

## 贡献

以下是 Superpowers 的通用贡献流程。请注意，我们通常不接受新技能贡献，而且技能的任何更新都必须在我们支持的所有 coding agent 上工作。

1. Fork 本仓库；
2. 切换到 `dev` 分支；
3. 创建工作分支；
4. 遵循 `writing-skills` 技能创建并测试新技能和修改后的技能；
5. 提交 PR，并完整填写 PR 模板。

技能行为测试使用 [superpowers-evals](https://github.com/prime-radiant-inc/superpowers-evals/) 的 Drill eval harness；该仓库会被克隆到 `evals/`，设置方式见 `evals/README.md`。插件基础设施测试位于 `tests/`，通过相关的 `run-*.sh` 或 `npm test` 运行。

完整指南见 `skills/writing-skills/SKILL.md`。

## 更新

Superpowers 的更新方式在一定程度上取决于 coding agent，但通常会自动更新。

## 许可证

MIT License，详见 LICENSE 文件。

## Visual companion telemetry

由于技能和插件不会向创建者提供反馈，我们不知道有多少人正在使用 Superpowers。默认情况下，brainstorming 的可选 visual companion 功能会从我们的网站加载 Prime Radiant logo，其中包含正在使用的 Superpowers 版本，但不包含项目、prompt 或 coding agent 的任何细节。我们看不到你的点击，也看不到你正在构建什么。这能帮助我们粗略了解有多少人在使用 Superpowers，以及他们使用的版本。该功能完全可选。如需禁用，将环境变量 `SUPERPOWERS_DISABLE_TELEMETRY` 设置为任意 true 值。Superpowers 也遵守 Claude Code 的 `DISABLE_TELEMETRY` 和 `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` 退出设置。
