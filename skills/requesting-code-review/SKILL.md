---
name: requesting-code-review
description: 当完成任务、实现重要功能或合并前需要验证工作是否满足要求时使用
---

# 请求代码审查

派遣代码审查子代理，在问题扩散前发现问题。审查者会获得精确编写的评估上下文——绝不要把你的会话历史直接交给它。

**核心原则：**尽早审查，频繁审查。

## 何时请求审查

**必须请求：**
- 子代理驱动开发中的每个任务完成后
- 重要功能完成后
- 合并到 main 前

**可选但很有价值：**
- 卡住时（获取新的视角）
- 重构前（建立基线检查）
- 修复复杂 bug 后

## 如何请求

**1. 获取 git SHA：**
```bash
BASE_SHA=$(git rev-parse HEAD~1)  # 或 origin/main
HEAD_SHA=$(git rev-parse HEAD)
```

**2. 派遣代码审查子代理：**

派遣一个 `general-purpose` 子代理，并填写 [code-reviewer.md](code-reviewer.md) 中的模板。

**占位符：**
- `{DESCRIPTION}` - 对所构建内容的简短总结
- `{PLAN_OR_REQUIREMENTS}` - 它应该完成什么
- `{BASE_SHA}` - 起始提交
- `{HEAD_SHA}` - 结束提交

**3. 处理反馈：**
- 立即修复 Critical 问题
- 继续前修复 Important 问题
- 将 Minor 问题记录下来稍后处理
- 如果审查者错误，用理由反驳

## 示例

```
[刚完成任务 2：添加验证函数]

你：在继续之前，我先请求代码审查。

BASE_SHA=$(git log --oneline | grep "Task 1" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

[派遣代码审查子代理]
  DESCRIPTION: 添加了 verifyIndex() 和 repairIndex()，支持 4 类问题
  PLAN_OR_REQUIREMENTS: docs/superpowers/plans/deployment-plan.md 中的任务 2
  BASE_SHA: a7981ec
  HEAD_SHA: 3df7661

[子代理返回：]
  优点：架构清晰，使用真实测试
  问题：
    Important：缺少进度指示器
    Minor：报告间隔（100）是 magic number
  评估：可以继续

你：[修复进度指示器]
[继续任务 3]
```

## 常见借口

| 借口 | 事实 |
|---------|---------|
| “我自己审查 diff，不派遣审查者就行了。” | 你是协调者——在当前上下文中审查 diff 会消耗本来用于持续推进工作的上下文窗口。派遣代码审查子代理：diff 和评估结果位于它的上下文中，只有发现的问题返回给你。 |
| “审查者需要我的完整会话历史才能理解修改。” | 只提供精确编写的上下文，绝不要提供会话历史。这样审查者关注工作成果，而不是你的思考过程。 |

## 红旗

**绝不要：**
- 因为“很简单”而跳过审查
- 忽略 Critical 问题
- 带着未修复的 Important 问题继续
- 反驳有效的技术反馈

**如果审查者错误：**
- 用技术理由反驳
- 展示证明其有效的代码/测试
- 请求澄清

模板见：[code-reviewer.md](code-reviewer.md)
