---
name: writing-plans
description: 当你已有规格或多步骤任务要求、并且尚未接触代码时使用
---

# 编写计划

编写完整实施计划，假设工程师对代码库没有上下文，且品味值得质疑。记录他们需要知道的一切：每个任务要修改哪些文件、代码、要检查的测试和文档，以及如何测试。将完整计划拆成小任务。遵循 DRY、YAGNI、TDD，并频繁提交。

假设他们是熟练开发者，但几乎不了解我们的工具集或问题领域，也不太熟悉好的测试设计。

**开始时宣布：**“我正在使用 writing-plans 技能来创建实施计划。”

**上下文：**如果在隔离 worktree 中工作，它应在执行时通过 `superpowers:using-git-worktrees` 技能创建。

**保存计划到：**`docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
-（用户对计划位置的偏好优先于默认值）

## 范围检查

如果规格覆盖多个独立子系统，头脑风暴期间就应该拆成子项目规格。如果没有，建议拆成多个计划——每个子系统一个。每个计划都应独立产出可运行、可测试的软件。

## 文件结构

定义任务前，先列出要创建或修改的文件及各自职责。这一步锁定拆分决策。

- 设计边界清晰、接口定义明确的单元。每个文件只有一个清晰职责。
- 你对能一次放入上下文的代码推理最好，聚焦文件也能让编辑更可靠。优先小而聚焦的文件，而不是承担过多职责的大文件。
- 一起变化的文件应放在一起。按职责拆分，不要按技术层拆分。
- 在已有代码库中遵循既有模式。如果代码库使用大文件，不要单方面重构；但若要修改的文件已经难以维护，将拆分纳入计划是合理的。

此结构会指导任务拆分。每个任务都应独立产出有意义的自包含变更。

## 任务大小

任务是能承担自己测试循环、值得新审查者设置门禁的最小单元。划分任务时，将设置、配置、脚手架和文档步骤并入需要这些交付物的任务；只有当审查者可能批准一个任务却拒绝相邻任务时才拆分。每个任务结束时都必须有可独立测试的交付物。

## 小步任务粒度

**每一步只做一个动作（2-5 分钟）：**
- “编写失败测试”——一步
- “运行它，确认失败”——一步
- “编写让测试通过的最小代码”——一步
- “运行测试，确认通过”——一步
- “提交”——一步

## 计划文档头部

**每份计划必须以以下头部开始：**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking。

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

**Spec:** [path to the spec/design doc this plan implements — the plan
argues from the spec, so the spec travels with it; executors read both]

## Global Constraints

[The spec's project-wide requirements — version floors, dependency limits,
naming and copy rules, platform requirements — one line each, with exact
values copied verbatim from the spec. Every task's requirements implicitly
include this section.]

---
```

以上机器字段和格式必须保留原样。

## 任务结构

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Interfaces:**
- Consumes: [what this task uses from earlier tasks — exact signatures]
- Produces: [what later tasks rely on — exact function names, parameter
  and return types. A task's implementer sees only their own task; this
  block is how they learn the names and types neighboring tasks use.]

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## 不使用占位符

每一步必须包含工程师实际需要的内容。以下属于**计划失败**，绝不要写：
- “TBD”“TODO”“稍后实现”“补充细节”
- “添加适当错误处理”/“增加验证”/“处理边界情况”
- “为上述内容编写测试”（没有实际测试代码）
- “类似任务 N”（重复代码；工程师可能按非顺序阅读任务）
- 只描述做什么却不展示如何做的步骤（代码步骤必须有代码块）
- 引用任何任务都没有定义的类型、函数或方法

## 自审

完整计划写完后，用全新视角检查规格，并对照计划。这是自己执行的清单，不是派遣子代理。

**1. 规格覆盖：**浏览规格的每节/每项要求。能指出实现它的任务吗？列出缺口。

**2. 占位符扫描：**搜索上述“不使用占位符”中的红旗模式并修复。

**3. 类型一致性：**后续任务中的类型、方法签名和属性名是否与前置任务一致？任务 3 叫 `clearLayers()`，任务 7 却叫 `clearFullLayers()` 就是 bug。

发现问题时直接修复，不需要重新审查。如果规格要求没有对应任务，添加任务。

## 执行交接

保存计划后，提供执行选项：

**“计划已完成并保存到 `docs/superpowers/plans/<filename>.md`。有两个执行选项：**

**Inline Execution**——在当前会话使用 executing-plans 执行任务，按任务逐项执行并在检查点进行复核。

**选择继续执行？**

**必需子技能：**使用 superpowers:executing-plans
- 在当前会话中执行任务
- 按计划运行测试和检查点验证
