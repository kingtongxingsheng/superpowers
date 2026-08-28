---
name: handoff
description: 把当前对话压缩成一份交接文档，供另一个 agent 接手。
argument-hint: "下一个会话将用于什么？"
disable-model-invocation: true
---

写一份交接文档，总结当前对话，让一个新 agent 能继续这项工作。保存到用户操作系统的临时目录——不是当前工作区。

在文档中包含一个 "suggested skills" 小节，点名下一个 agent 应对哪些技能调用 Skill 工具。

不要重复其他产物（specs、plans、ADR、issues、commits、diffs）已捕获的内容。改为按路径或 URL 引用它们。

脱敏任何敏感信息，如 API keys、密码或可识别个人身份的信息。

如果用户传了参数，把它们当作对下一个会话将聚焦什么的描述，并据此定制文档。
