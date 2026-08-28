---
name: requesting-code-review
description: 当完成任务、实现重要功能或合并前需要验证工作是否满足要求时使用；
---

# 请求代码审查

派发一个代码审查 subagent。围绕给定的 git 范围、需求和实现结果，尽早发现会被放大的问题。不要把完整会话历史直接当作上下文；只提取审查所需的信息。

**核心原则：**尽早审查，频繁审查。

## 何时请求审查

**必须请求：**
- 子代理驱动开发中的每个任务之后
- 重要功能完成后
- 合并到 main 前

**可选但很有价值：**
- 卡住时，换一个视角
- 重构前，先建立基线
- 修复复杂 bug 后

## 如何请求

**1. 获取 git SHA：**
```bash
BASE_SHA=$(git rev-parse HEAD~1)  # 或 origin/main
HEAD_SHA=$(git rev-parse HEAD)
```

**2. 派发代码审查 subagent：**

派发一个 `general-purpose` subagent，填写 [code-reviewer.md](code-reviewer.md) 中的模板。
  
**占位符：**
- `{DESCRIPTION}` - 对已完成内容的简短总结
- `{PLAN_OR_REQUIREMENTS}` - 它应该完成什么
- `{BASE_SHA}` - 起始提交
- `{HEAD_SHA}` - 结束提交

**3. 处理反馈：**
- 立即修复 Critical 问题
- 继续前修复 Important 问题
- 将 Minor 问题记录下来稍后处理
- 如果审查结论有误，用技术理由反驳

## 示例

```
[刚完成任务 2：添加验证函数]

你：在继续之前，我先请求代码审查。

BASE_SHA=$(git log --oneline | grep "Task 1" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

[派发代码审查subagent整理审查上下文]
  DESCRIPTION: 添加了 verifyIndex() 和 repairIndex()，支持 4 类问题
  PLAN_OR_REQUIREMENTS: docs/superpowers/plans/deployment-plan.md 中的任务 2
  BASE_SHA: a7981ec
  HEAD_SHA: 3df7661                                                             

[subagent完成审查返回：]
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
| “我自己审查 diff 就行了。” | 当前会话的上下文应该只保留必要信息；先整理审查上下文，再系统性检查 diff、测试和相关文件。 |
| “需要完整会话历史才能理解修改。” | 不需要。只提供精确编写的上下文，聚焦实现结果。 |

## 红旗

**绝不要：**
- 因为“很简单”而跳过审查
- 忽略 Critical 问题
- 带着未修复的 Important 问题继续
- 回避明确结论

**如果审查结论有误：**
- 用技术理由反驳
- 展示证明其有效的代码或测试
- 请求澄清

模板见：[code-reviewer.md](code-reviewer.md)
