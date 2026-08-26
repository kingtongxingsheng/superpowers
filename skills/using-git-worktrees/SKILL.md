---
name: using-git-worktrees
description: 当开始需要与当前工作区隔离的功能开发，或执行实施计划前使用；确保通过原生工具或 git worktree fallback 创建隔离工作区
---

# 使用 Git Worktree

## 概述

确保工作在隔离工作区中进行。优先使用平台原生 worktree 工具；只有没有原生工具时才回退到手动 git worktree。

**核心原则：**先检测现有隔离，再使用原生工具，最后才回退到 git。绝不要与 harness 对抗。

**开始时宣布：**“我正在使用 using-git-worktrees 技能来设置隔离工作区。”

## 第 0 步：检测现有隔离

**创建任何内容前，先检查是否已经处于隔离工作区。**

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
```

**Submodule 保护：**git submodule 内部同样满足 `GIT_DIR != GIT_COMMON`。在判断“已经处于 worktree”之前，确认当前不在 submodule：

```bash
# 如果返回路径，说明你在 submodule 中，而不是 worktree 中——按普通仓库处理
git rev-parse --show-superproject-working-tree 2>/dev/null
```

**如果 `GIT_DIR != GIT_COMMON`（且不是 submodule）：**已经处于 linked worktree。跳到第 2 步（项目设置）。不要再创建 worktree。

根据分支状态报告：
- 在分支上：“已经在 `<path>` 的隔离工作区中，当前分支为 `<name>`。”
- Detached HEAD：“已经在 `<path>` 的隔离工作区中（detached HEAD，由外部管理）。完成时需要创建分支。”

**如果 `GIT_DIR == GIT_COMMON`（或当前在 submodule 中）：**当前是普通仓库 checkout。

用户是否已在指令中说明 worktree 偏好？如果没有，在创建 worktree 前请求同意：

> “你希望我设置隔离 worktree 吗？它可以保护当前分支不受修改影响。”

尊重已经声明的偏好，不再询问。如果用户拒绝，在原地工作并跳到第 2 步。

## 第 1 步：创建隔离工作区

**有两种机制，按以下顺序尝试。**

### 1a. 原生 Worktree 工具（首选）

用户已在第 0 步同意隔离工作区。你是否已有创建 worktree 的方式？可能是名为 `EnterWorktree`、`WorktreeCreate` 的工具、`/worktree` 命令或 `--worktree` flag。如果有，使用它并跳到第 2 步。

原生工具会自动处理目录位置、分支创建和清理。你拥有原生工具时使用 `git worktree add` 会创建 harness 无法看见或管理的幽灵状态。

只有没有原生 worktree 工具时，才进入第 1b 步。

### 1b. Git Worktree Fallback

**仅当第 1a 步不适用时使用**——即没有原生 worktree 工具。使用 git 手动创建 worktree。

#### 目录选择

按以下优先级执行。用户明确偏好始终高于观察到的文件系统状态。

1. **检查指令中声明的 worktree 目录偏好。**如果用户已指定，直接使用，无需询问。

2. **检查现有项目本地 worktree 目录：**
   ```bash
   ls -d .worktrees 2>/dev/null     # 首选（隐藏目录）
   ls -d worktrees 2>/dev/null      # 备选
   ```
   如果找到，使用它。如果两者都存在，优先 `.worktrees`。

3. **没有其他指导时，**默认使用项目根目录下的 `.worktrees/`。

#### 安全验证（仅项目本地目录）

**创建 worktree 前必须验证目录已被忽略：**

```bash
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
```

**如果没有被忽略：**将其加入 .gitignore，提交修改，然后继续。

**为什么关键：**避免意外将 worktree 内容提交到仓库。

#### 创建 Worktree

```bash
# 根据选定位置确定路径
path="$LOCATION/$BRANCH_NAME"

git worktree add "$path" -b "$BRANCH_NAME"
cd "$path"
```

**Sandbox fallback：**如果 `git worktree add` 因权限错误失败（sandbox 拒绝），告诉用户 sandbox 阻止了 worktree 创建，改为在当前目录工作。然后在原地运行设置和基线测试。

## 第 2 步：项目设置

自动检测并运行适当的设置命令：

```bash
# Node.js
if [ -f package.json ]; then npm install; fi

# Rust
if [ -f Cargo.toml ]; then cargo build; fi

# Python
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi

# Go
if [ -f go.mod ]; then go mod download; fi
```

## 第 3 步：验证干净基线

运行测试，确保工作区从干净状态开始：

```bash
# 使用适合项目的命令
npm test / cargo test / pytest / go test ./...
```

**如果测试失败：**报告失败，询问是否继续或调查。

**如果测试通过：**报告已经准备好。

### 报告

```
Worktree 已准备好：<full-path>
测试通过（<N> 个测试，0 个失败）
已准备实施 <feature-name>
```

## 快速参考

| 情况 | 操作 |
|-----------|--------|
| 已处于 linked worktree | 跳过创建（第 0 步） |
| 在 submodule 中 | 按普通仓库处理（第 0 步保护） |
| 有原生 worktree 工具 | 使用它（第 1a 步） |
| 没有原生工具 | 使用 Git worktree fallback（第 1b 步） |
| 存在 `.worktrees/` | 使用它（验证已忽略） |
| 存在 `worktrees/` | 使用它（验证已忽略） |
| 两者都存在 | 使用 `.worktrees/` |
| 两者都不存在 | 检查指令文件，然后默认 `.worktrees/` |
| 目录未被忽略 | 加入 .gitignore 并提交 |
| 创建时权限错误 | Sandbox fallback，在原地工作 |
| 基线测试失败 | 报告失败并询问 |
| 没有 package.json/Cargo.toml | 跳过依赖安装 |

## 常见合理化

| 借口 | 事实 |
|--------|---------|
| “我显然不在 worktree 中，不必检查。” | 执行第 0 步。Harness 创建的隔离和 submodule 都可能误导肉眼；检测命令才能确定。 |
| “`git worktree add` 比寻找原生工具快。” | 原生工具（例如 `EnterWorktree`）负责位置、分支和清理。绕过它是第一大错误——会创建 harness 无法看见或管理的幽灵状态。 |
| “Worktree 目录肯定已经被忽略。” | 运行 `git check-ignore`。未忽略的 worktree 目录会把整个目录树提交进仓库。 |
| “目录名随便取都行。” | 明确指令优先于已有项目本地目录，已有目录优先于 `.worktrees/` 默认值。 |
| “工作区是新的，基线测试可以稍后运行。” | 不干净的基线会让后续每个失败都无法判断。现在运行测试；是否越过失败继续是 human partner 的决定。 |
