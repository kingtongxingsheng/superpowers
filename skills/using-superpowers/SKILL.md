---
name: using-superpowers
description: 在每次会话开始时使用；用于了解如何查找和使用技能，并要求在任何响应（包括澄清问题）之前调用技能
---

<SUBAGENT-STOP>
如果你被派遣为子代理来执行特定任务，请忽略本技能。
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
如果你认为某个技能有哪怕 1% 的可能适用于当前任务，就绝对必须调用它。

如果某个技能适用于你的任务，你没有选择余地，必须使用它。

这不可协商。不能用任何理由为自己开脱。
</EXTREMELY-IMPORTANT>

## 规则

**在任何响应或行动之前调用相关或被请求的技能**——包括澄清问题、探索代码库或检查文件。如果后来发现技能不适用，可以不继续使用它。

**进入 plan mode 之前：**如果还没有进行头脑风暴，先调用 brainstorming 技能。

然后宣布“Using [skill] to [purpose]”，并严格遵循该技能。如果技能包含清单，为每个项目创建待办事项。

## 技能优先级

多个技能同时适用时，先处理流程技能——它们决定方法，然后再由实施技能（frontend-design 等）执行。Brainstorming 和 systematic-debugging 是 Superpowers 中最常见的流程技能，但规则适用于所有技能。

- “Let's build X” → 先使用 superpowers:brainstorming，再使用实施技能。
- “Fix this bug” → 先使用 superpowers:systematic-debugging，再使用领域技能。

## 红旗

出现以下想法时必须停止——你正在合理化跳过流程：

| 想法 | 事实 |
|---------|---------|
| “这只是一个简单问题。” | 问题也是任务。检查技能。 |
| “我需要先了解更多上下文。” | 技能检查必须先于澄清问题。 |
| “我先探索代码库。” | 技能会告诉你应该如何探索。先检查技能。 |
| “我快速检查一下 git/文件就好。” | 文件没有会话上下文。先检查技能。 |
| “我先收集资料。” | 技能会告诉你如何收集资料。 |
| “这不需要正式技能。” | 只要存在适用技能，就必须使用。 |
| “我记得这个技能。” | 技能会演进。读取当前版本。 |
| “这不算任务。” | 行动就是任务。检查技能。 |
| “这个技能太重了。” | 简单任务也会变复杂。使用技能。 |
| “我先做这一件小事。” | 做任何事之前先检查。 |
| “这样做很有生产力。” | 无纪律的行动会浪费时间。技能可以避免。 |
| “我知道那是什么意思。” | 知道概念不等于使用技能。调用它。 |

## 平台适配

如果你的 harness 出现在这里，请读取对应参考文件中的特殊说明：

- Codex：`references/codex-tools.md`
- Pi：`references/pi-tools.md`
- Antigravity：`references/antigravity-tools.md`
- Hermes Agent：`references/hermes-tools.md`

## 用户指令

用户指令（CLAUDE.md、AGENTS.md、GEMINI.md 等，以及直接请求）优先于技能；技能又优先于默认行为。只有当你的 human partner 明确要求时，才能跳过技能流程或指令。
