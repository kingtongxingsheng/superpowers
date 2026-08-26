# Antigravity CLI（`agy`）工具映射

技能使用动作来描述操作（“派遣子代理”“创建待办”“读取文件”）。在 Antigravity CLI（`agy`）中，这些动作对应以下工具。

| 技能请求的动作 | Antigravity CLI 等价操作 |
|---|---|
| 派遣子代理（`Subagent (general-purpose):` 模板） | 使用内置 `TypeName` 调用 `invoke_subagent`：具备完整能力的工作使用 `self`，只读调查使用 `research` |
| 任务跟踪（“创建待办”“标记完成”） | 使用任务 artifact——通过 `write_to_file` 并设置 `IsArtifact: true` 和 `ArtifactType: "task"`（见[任务跟踪](#任务跟踪)）。不要使用管理后台进程的 `manage_task`。 |

## 任务跟踪

Antigravity 没有 todo 工具（`manage_task` 管理后台进程——`list`/`kill`/`status`/`send_input`，不是清单）。当技能要求创建待办列表或跟踪任务时，使用任务 artifact：通过 `write_to_file` 保存 Markdown 清单，并设置 `IsArtifact: true`、`ArtifactMetadata.ArtifactType: "task"`；执行过程中使用 `replace_file_content` / `multi_replace_file_content` 编辑。

开始任何多步骤任务时，创建列出计划全部步骤的任务 artifact。每完成一步，就编辑 artifact 将其标记为完成（`- [x]`）。如果计划发生变化，更新清单。保持清单最新——它是剩余工作的真实来源；对话变长后，在开始每一步前重新读取它。
