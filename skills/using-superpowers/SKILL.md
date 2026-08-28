---
name: using-superpowers
description: 在会话开始时使用；在任何回复或操作前检查并调用适用的技能
---

<SUBAGENT-STOP>
如果你被派遣为子代理来执行特定任务，请忽略本技能。
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
如果你认为某个技能哪怕有 1% 的可能适用于你正在做的事情，就**必须**调用它。

如果技能适用于你的任务，你没有选择权，必须使用它。

这不是可协商的。不要为自己找理由。
</EXTREMELY-IMPORTANT>

## 规则

**在任何回复或动作之前调用相关或请求的技能**——包括澄清问题、探索代码库或检查文件。如果后来发现判断不对，也没关系，但你必须先调用。

**在进入 plan mode 之前：**如果你还没有先进行 brainstorming，先调用 brainstorming 技能。

然后说明“Using [skill] to [purpose]”，并严格遵循该技能。如果它有清单，为每一项创建一个 todo。

## 技能优先级

当多个技能同时适用时，流程技能优先——它们决定方法，然后再调用实现技能（frontend-design 等）。Brainstorming 和 systematic-debugging 是 Superpowers 最常见的流程技能，但这个规则对任何技能都适用。

- “开发 xx ” → 先用 superpowers-cn:brainstorming，然后再用实现技能。
- “解决这个bug” → 先用 superpowers-cn:systematic-debugging，然后再用领域技能。
- 如果判断需要使用 `test-driven-development`，先向用户说明为什么要用它，并提供“先按 TDD 走”与“直接实现”这类选择；获得确认后再调用，不要直接进入。

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

用户指令（CLAUDE.md、AGENTS.md、GEMINI.md 等，以及直接请求）优先于技能，其次才是默认行为。只有当你的 human partner 明确要求时，才能跳过技能流程或指令。
