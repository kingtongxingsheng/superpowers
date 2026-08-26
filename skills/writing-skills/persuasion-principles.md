# 技能设计的说服原则

## 概述

LLM 会像人类一样响应说服原则。理解这些心理机制有助于设计更有效的技能——目的不是操纵，而是确保关键实践即使在压力下也能得到遵守。

**研究基础：** Meincke 等人（2025）以 N=28,000 次 AI 对话测试了 7 项说服原则。说服技术使遵从率提升了一倍以上（33% → 72%，p < .001）。

## 七项原则

### 1. 权威
**含义：** 服从专业知识、资质或官方来源。

**在技能中的作用：**
- 使用祈使语言：“YOU MUST”“Never”“Always”
- 使用不可协商的表述：“No exceptions”
- 减少决策疲劳和合理化

**适用场景：**
- 强制纪律的技能（TDD、验证要求）
- 安全关键实践
- 已确立的最佳实践

**示例：**
```markdown
✅ Write code before test? Delete it. Start over. No exceptions.
❌ Consider writing tests first when feasible.
```

### 2. 承诺
**含义：** 与先前的行动、声明或公开承诺保持一致。

**在技能中的作用：**
- 要求明确宣布：“Announce skill usage”
- 强制做出明确选择：“Choose A, B, or C”
- 使用跟踪机制：用 todos 管理清单

**适用场景：**
- 确保技能确实被遵守
- 多步骤流程
- 责任追踪机制

**示例：**
```markdown
✅ When you find a skill, you MUST announce: "I'm using [Skill Name]"
❌ Consider letting your partner know which skill you're using.
```

### 3. 稀缺性
**含义：** 来自时间限制或有限可用性的紧迫感。

**在技能中的作用：**
- 有时限的要求：“Before proceeding”
- 顺序依赖：“Immediately after X”
- 防止拖延

**适用场景：**
- 必须立即执行的验证
- 有时间限制的工作流
- 防止“以后再做”

**示例：**
```markdown
✅ After completing a task, IMMEDIATELY request code review before proceeding.
❌ You can review code when convenient.
```

### 4. 社会认同
**含义：** 遵从他人的做法或公认规范。

**在技能中的作用：**
- 使用普遍性表述：“Every time”“Always”
- 明确失败模式：“X without Y = failure”
- 建立规范

**适用场景：**
- 记录通用实践
- 警告常见失败
- 强化标准

**示例：**
```markdown
✅ Checklists without todo tracking = steps get skipped. Every time.
❌ Some people find a todo list helpful for checklists.
```

### 5. 统一性
**含义：** 共享身份、“我们感”和群体归属。

**在技能中的作用：**
- 协作语言：“our codebase”“we're colleagues”
- 共享目标：“we both want quality”

**适用场景：**
- 协作工作流
- 建立团队文化
- 非等级化实践

**示例：**
```markdown
✅ We're colleagues working together. I need your honest technical judgment.
❌ You should probably tell me if I'm wrong.
```

### 6. 互惠
**含义：** 对已获得的好处负有回报义务。

**使用方式：**
- 谨慎使用——可能让人感到被操纵
- 技能中很少需要

**避免场景：**
- 几乎总是避免（其他原则更有效）

### 7. 喜爱
**含义：** 更愿意与自己喜欢的人合作。

**使用方式：**
- **不要用于促成遵从**
- 与诚实反馈文化冲突
- 会造成迎合

**避免场景：**
- 纪律强制场景中始终避免

## 按技能类型组合原则

| 技能类型 | 使用 | 避免 |
|---|---|---|
| 纪律强制 | 权威 + 承诺 + 社会认同 | 喜爱、互惠 |
| 指导/技术 | 适度权威 + 统一性 | 过强权威 |
| 协作型 | 统一性 + 承诺 | 权威、喜爱 |
| 参考型 | 仅清晰性 | 所有说服原则 |

## 为什么有效：心理机制

**明确边界的规则减少合理化：**
- “YOU MUST” 消除决策疲劳
- 绝对化语言消除“这是不是例外？”的问题
- 明确的反合理化反制具体堵住漏洞

**实施意图会形成自动行为：**
- 清晰触发条件 + 必须执行的动作 = 自动执行
- “When X, do Y” 比“通常做 Y”更有效
- 降低遵从所需的认知负担

**LLM 具有拟人特征：**
- 它们的训练数据包含大量带有这些模式的人类文本
- 权威语言在训练数据中常先于遵从出现
- 承诺序列（声明 → 行动）经常被建模
- 社会认同模式（人人都做 X）会建立规范

## 合乎伦理的使用

**正当用途：**
- 确保关键实践得到遵守
- 创建有效文档
- 防止可预见的失败

**不当用途：**
- 为个人利益操纵他人
- 制造虚假紧迫感
- 通过羞耻或内疚促成遵从

**判断标准：** 如果用户完全理解该技术，它仍然会服务于用户的真实利益吗？

## 研究引用

**Cialdini, R. B. (2021).** *Influence: The Psychology of Persuasion (New and Expanded).* Harper Business.
- 七项说服原则
- 影响力研究的实证基础

**Meincke, L., Shapiro, D., Duckworth, A. L., Mollick, E., Mollick, L., & Cialdini, R. (2025).** Call Me A Jerk: Persuading AI to Comply with Objectionable Requests. University of Pennsylvania.
- 以 N=28,000 次 LLM 对话测试 7 项原则
- 说服技术使遵从率从 33% 提升至 72%
- 权威、承诺、稀缺性最有效
- 验证 LLM 拟人行为模型

## 快速参考

设计技能时，询问：

1. **它属于哪种类型？**（纪律、指导还是参考）
2. **我想改变什么行为？**
3. **哪些原则适用？**（纪律技能通常是权威 + 承诺）
4. **是否组合了过多原则？**（不要使用全部七项）
5. **是否合乎伦理？**（是否服务于用户的真实利益？）
