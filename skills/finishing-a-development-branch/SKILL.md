---
name: finishing-a-development-branch
description: 当实现完成、所有测试通过，并需要决定如何整合工作时使用
---

# 完成开发分支

## 概述

**核心原则：**验证测试 → 检测环境 → 展示选项 → 执行选择 → 清理。

**开始时宣布：**“我正在使用 finishing-a-development-branch 技能来完成这项工作。”

## 第一步：验证测试

运行项目完整测试套件（`npm test` / `cargo test` / `pytest` / `go test ./...`）。

**如果测试失败：**报告失败并停止——菜单必须等测试套件通过后再展示：

```
测试失败（<N> 个失败）。完成前必须修复：

[显示失败信息]
```

**如果测试通过：**继续第二步。

## 第二步：检测环境

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
# 现在仍在工作区中，先捕获这些值——第五步会切换目录，第六步清理时需要它们
WORKTREE_PATH=$(git rev-parse --show-toplevel)
```

这决定要展示的菜单以及清理方式：

| 状态 | 菜单 | 清理 |
|-------|-------|-------|
| `GIT_DIR == GIT_COMMON`（普通仓库） | 标准 3 个选项 | 不需要清理 worktree |
| `GIT_DIR != GIT_COMMON`，命名分支 | 标准 3 个选项 | 基于来源清理（见第六步） |
| `GIT_DIR != GIT_COMMON`，detached HEAD | 精简 2 个选项（无合并） | 由外部管理——保留原样 |

## 第三步：确定基础分支

基础分支就是当前工作分支从哪个分支分叉而来——通常会在计划、会话或分支的 upstream 中说明。如果还不知道，应询问：“这个分支看起来是从 <你的最佳猜测> 分出的——对吗？”

合并前必须确认：合并到错误的基础分支很难撤销。

## 第四步：展示选项

**普通仓库和命名分支 worktree——必须准确展示以下 3 个选项：**

```
实现已完成。你希望如何处理？

1. 在本地合并回 <base-branch>
2. 推送并创建 Pull Request
3. 保持分支原样（稍后由我处理）

选择哪个选项？
```

**Detached HEAD——必须准确展示以下 2 个选项：**

```
实现已完成。当前处于 detached HEAD（由外部管理的工作区）。

1. 作为新分支推送并创建 Pull Request
2. 保持原样（稍后由我处理）

选择哪个选项？
```

必须按原样展示菜单——简洁，并且每个选项都来自上面的列表。只有你的 human partner 明确要求时才能丢弃工作（见下面“如果你的 human partner 要求丢弃工作”）。等待他们回答；整合决策属于他们。

## 第五步：执行选择

### 选项 1：本地合并

```bash
# 获取主仓库根目录，确保 CWD 安全
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"

# 先合并——确认成功后再删除任何内容
git checkout <base-branch>
git pull
git merge <feature-branch>

# 在合并结果上验证测试
<test command>
```

如果合并结果上的测试失败：停止，保留 worktree 和分支并进行调查——尚未推送，因此本地合并仍可恢复。

合并结果通过后，清理 worktree（第六步），然后删除分支：

```bash
git branch -d <feature-branch>
```

### 选项 2：推送并创建 PR

```bash
git push -u origin <feature-branch>
# detached HEAD 时，在远程创建新分支并指定名称：
# git push origin HEAD:refs/heads/<new-branch>
```

然后使用 forge 的工具对 <base-branch> 创建 pull/merge request——优先使用其 CLI；如果没有可用 CLI，则使用推送后大多数 forge 输出的创建 URL。若仓库提供 PR 模板和约定，必须遵循，并将 URL 报告给你的 human partner。

保留 worktree——你的 human partner 会在那里迭代处理 PR 反馈。

### 选项 3：保持原样

报告：“保留分支 <name>。Worktree 保存在 <path>。”

### 如果你的 human partner 要求丢弃工作

只有在对方明确要求丢弃工作时才走这条路径。先确认：

```
这将永久删除：
- 分支 <name>
- 全部提交：<commit-list>
- <path> 处的 worktree

请输入 'discard' 确认。
```

等待对方输入完全匹配的确认。收到后：

```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"
```

然后清理 worktree（第六步）并强制删除分支：

```bash
git branch -D <feature-branch>
```

## 第六步：清理工作区

**适用于选项 1 和已确认的丢弃操作。**选项 2 和 3 始终保留 worktree。两种调用方都已切换到主仓库根目录——必须从 worktree 外部移除 worktree——并使用第二步在切换目录前捕获的 `GIT_DIR`/`GIT_COMMON`/`WORKTREE_PATH` 值。

**如果 `GIT_DIR == GIT_COMMON`：**普通仓库，无需清理 worktree。完成。

**如果 `WORKTREE_PATH` 位于 `.worktrees/` 或 `worktrees/` 下：**这是 Superpowers 创建的 worktree——我们负责清理：

```bash
git worktree remove "$WORKTREE_PATH"
git worktree prune  # 自修复：清理任何过时的注册信息
```

**如果移除被拒绝**（`contains modified or untracked files`）：worktree 中存在其他位置没有的文件——未提交的计划、笔记或临时工作。绝不能主动使用 `--force`。向你的 human partner 展示风险并询问：

```bash
git -C "$WORKTREE_PATH" status --porcelain -uall
```

```
Worktree removal refused — these files were never committed:

<file list>

1. 将它们提交到 <branch> 后再清理
2. 将它们移动到 <main repo root>
3. 删除它们（不可恢复）

选择哪个？
```

执行对方的选择，然后移除 worktree。

**其他情况：**工作区由宿主环境管理——保留原样。如果平台提供工作区退出工具，则使用它。

## 快速参考

| 选项 | 合并 | 推送 | 保留 Worktree | 清理分支 |
|--------|-------|------|---------------|----------------|
| 1. 本地合并 | 是 | - | - | 是 |
| 2. 创建 PR | - | 是 | 是 | - |
| 3. 保持原样 | - | - | 是 | - |
| 丢弃（仅限明确请求） | - | - | - | 是（强制） |

## 常见借口

| 借口 | 事实 |
|--------|---------|
| “本次会话早些时候测试通过了。” | 在即将整合的树上运行测试套件。绿色结果只证明运行测试时的那棵树。 |
| “他们显然想让我合并。” | 整合决策属于你的 human partner。展示菜单并等待。 |
| “他们看起来已经完成这个功能了——我来提议丢弃。” | 菜单必须完整如上。只有 human partner 明确要求时才能丢弃。 |
| “‘好，删掉它’算确认。” | 只有输入完全匹配的 `discard` 才授权删除。 |
| “PR 已经创建，worktree 只是多余的。” | PR 反馈需要在这个 worktree 中修复。工作合并前都要保留。 |
| “另一个 worktree 看起来过时了——我也清理掉。” | 只清理位于 `.worktrees/` 或 `worktrees/` 下的 worktree。其他 worktree 属于宿主环境。 |
| “移除被拒绝——`--force` 只是完成清理。” | 拒绝意味着这些文件只存在于该 worktree。`--force` 会永久销毁它们。向 human partner 展示并询问。 |
| “合并结果失败可能只是 flaky。” | 合并结果失败就必须停止。调查期间保留分支和 worktree。 |
| “基础分支显然是 main。” | 确认分叉点或询问。合并到错误基础分支很难撤销。 |
| “推送被拒绝——force-push 能解决。” | 被拒绝表示远程已发生变化。先调查；只有 human partner 明确要求时才 force-push。 |
