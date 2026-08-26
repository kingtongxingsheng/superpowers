# 技能目录中文化实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将 `skills/` 下全部技能及配套文档的人类可读内容翻译为中文，同时保持技能触发、工具契约、可执行资源和测试意图不变。

**Architecture:** 按技能目录分批翻译，每批只处理一个或一组职责明确的技能目录。Markdown 文档翻译自然语言；脚本和结构化文件仅翻译安全注释/用户可见文案，保留语法、标识符、命令、路径、协议字段和字符串契约。每批完成后进行结构检查，全部完成后运行统一验证。

**Tech Stack:** Markdown、YAML frontmatter、Shell、JavaScript/CJS、TypeScript、Graphviz DOT；仓库现有 shell/node/python 测试工具。

**Spec:** `docs/2026-08-26-skills-chinese-translation-design.md`

## Global Constraints

- 覆盖 `skills/` 下所有文件。
- 技能目录名、技能名、frontmatter 字段名和 `name` 值保持原样。
- 工具名、命令名、参数名、路径、URL、环境变量、代码标识符、JSON key、断言标识和协议字段保持原样。
- 可执行代码逻辑、正则、文件名和代码块边界不得改变。
- 只将自然语言翻译为中文，不做无关重构，不改变规则强度、例外条件和测试意图。
- 代码注释和安全的用户可见文案可以翻译，但不得改变程序行为。

---

### Task 1: 翻译核心流程技能

**Files:**
- Modify: `skills/brainstorming/**`
- Modify: `skills/dispatching-parallel-agents/SKILL.md`
- Modify: `skills/executing-plans/SKILL.md`
- Modify: `skills/finishing-a-development-branch/SKILL.md`
- Modify: `skills/receiving-code-review/SKILL.md`
- Modify: `skills/requesting-code-review/**`

**Interfaces:**
- 保持技能名、frontmatter、技能交叉引用、工具调用格式和 browser companion 脚本接口不变。
- 后续任务依赖这些技能仍能被原有触发机制发现和加载。

- [ ] 翻译所有 Markdown 自然语言，保留代码块、命令、路径、技能标识和协议字段。
- [ ] 仅翻译脚本中的安全注释或明确的用户可见文案，不改 JavaScript/CJS 逻辑。
- [ ] 检查 frontmatter 字段和 `name` 值与修改前一致。
- [ ] 检查相对链接、锚点和代码块数量未变化。
- [ ] 运行该批次的 Markdown 链接和脚本语法检查。

### Task 2: 翻译开发纪律与调试技能

**Files:**
- Modify: `skills/subagent-driven-development/**`
- Modify: `skills/systematic-debugging/**`
- Modify: `skills/test-driven-development/**`
- Modify: `skills/using-git-worktrees/SKILL.md`
- Modify: `skills/using-superpowers/**`
- Modify: `skills/verification-before-completion/SKILL.md`

**Interfaces:**
- 保持提示模板中的输入/输出契约、占位符、工具名称、脚本参数、测试文件名和技能引用不变。
- 保持 `find-polluter.sh`、TypeScript 示例和 runtime reference 文件可执行/可复制。

- [ ] 翻译所有 Markdown、提示模板、测试说明和安全的代码注释。
- [ ] 不翻译 Shell/TypeScript 代码中的命令、参数、路径、变量、正则、输出契约和测试匹配文本。
- [ ] 对 `find-polluter.sh` 运行 `bash -n`；对 TypeScript 示例进行文本结构检查，确认代码块与标识符未损坏。
- [ ] 检查各技能 frontmatter、交叉引用和相对链接。
- [ ] 对比规则表、红旗清单和 TDD 流程，确认强制性语义未减弱或增强。

### Task 3: 翻译写作与技能创作技能

**Files:**
- Modify: `skills/writing-plans/**`
- Modify: `skills/writing-skills/**`

**Interfaces:**
- 保持计划模板中的字段名、路径格式、命令、代码示例契约和评估 JSON schema 字段不变。
- 保持 Graphviz DOT 语法、脚本文件名、CLI 参数和资源引用不变。

- [ ] 翻译 Markdown、提示模板、参考资料、示例说明和测试方法中的自然语言。
- [ ] 仅翻译 DOT/JS 中安全注释或不参与协议的用户可见文案；保留 DOT 语法和脚本逻辑。
- [ ] 检查计划模板仍包含所有要求的英文机器字段和可复制命令。
- [ ] 运行 `node --check` 检查 JavaScript；运行 Graphviz 解析或仓库已有渲染检查（若环境提供）。
- [ ] 检查 `SKILL.md` 的 frontmatter、交叉引用和资源路径。

### Task 4: 全量契约与结构验证

**Files:**
- Test: `skills/**`
- Verify: `docs/2026-08-26-skills-chinese-translation-design.md`

**Interfaces:**
- 验证结果必须能证明翻译覆盖范围、机器契约稳定性和资源可执行性。

- [ ] 列出所有 `skills/` 文件，确认没有遗漏未处理文件。
- [ ] 扫描每个 `SKILL.md` 的 frontmatter，确认 `name` 和字段结构有效。
- [ ] 扫描代码块边界、相对链接、技能标识、命令、路径和关键 schema 字段。
- [ ] 运行仓库现有测试及可用的 Shell/Node/Python 静态检查。
- [ ] 查看 git diff，确认没有把代码、路径、协议字段或无关项目内容误改成中文。
- [ ] 记录所有无法执行的验证及其真实原因，不虚构测试结果。

### Task 5: 最终复核

**Files:**
- Review: `skills/**`
- Review: `docs/2026-08-26-skills-chinese-translation-design.md`

- [ ] 按原文件逐项检查强制规则、例外、警告、工具调用和测试意图。
- [ ] 检查中文术语一致性、标点、标题层级、表格可读性和 Markdown 格式。
- [ ] 执行一次任务复盘，确认没有形成符合条件但未提出审核的项目规则候选。
- [ ] 汇报修改文件范围、验证命令及实际结果；不提交或推送，除非用户另行要求。
