# 基于条件的等待

## 概述

不稳定测试经常用任意延迟猜测时序。这会产生竞态条件：在快速机器上通过，但在负载下或 CI 中失败。

**核心原则：**等待真正关心的条件，而不是猜测它需要多长时间。

## 何时使用

```dot
digraph when_to_use {
    "Test uses setTimeout/sleep?" [shape=diamond];
    "Testing timing behavior?" [shape=diamond];
    "Document WHY timeout needed" [shape=box];
    "Use condition-based waiting" [shape=box];

    "Test uses setTimeout/sleep?" -> "Testing timing behavior?" [label="yes"];
    "Testing timing behavior?" -> "Document WHY timeout needed" [label="yes"];
    "Testing timing behavior?" -> "Use condition-based waiting" [label="no"];
}
```

**适用于：**
- 测试包含任意延迟（`setTimeout`、`sleep`、`time.sleep()`）
- 测试不稳定（有时通过，负载下失败）
- 并行运行时超时
- 等待异步操作完成

**不适用于：**
- 测试真实时序行为（debounce、throttle 间隔）
- 使用任意超时时必须记录原因

## 核心模式

```typescript
// ❌ 修改前：猜测时序
await new Promise(r => setTimeout(r, 50));
const result = getResult();
expect(result).toBeDefined();

// ✅ 修改后：等待条件
await waitFor(() => getResult() !== undefined);
const result = getResult();
expect(result).toBeDefined();
```

## 快速模式

| 场景 | 模式 |
|----------|---------|
| 等待事件 | `waitFor(() => events.find(e => e.type === 'DONE'))` |
| 等待状态 | `waitFor(() => machine.state === 'ready')` |
| 等待数量 | `waitFor(() => items.length >= 5)` |
| 等待文件 | `waitFor(() => fs.existsSync(path))` |
| 复杂条件 | `waitFor(() => obj.ready && obj.value > 10)` |

## 实现

通用轮询函数：
```typescript
async function waitFor<T>(
  condition: () => T | undefined | null | false,
  description: string,
  timeoutMs = 5000
): Promise<T> {
  const startTime = Date.now();

  while (true) {
    const result = condition();
    if (result) return result;

    if (Date.now() - startTime > timeoutMs) {
      throw new Error(`Timeout waiting for ${description} after ${timeoutMs}ms`);
    }

    await new Promise(r => setTimeout(r, 10)); // 每 10ms 轮询
  }
}
```

完整实现以及来自实际调试会话的领域辅助函数（`waitForEvent`、`waitForEventCount`、`waitForEventMatch`）见本目录的 `condition-based-waiting-example.ts`。

## 常见错误

**❌ 轮询过快：**`setTimeout(check, 1)`——浪费 CPU
**✅ 修复：**每 10ms 轮询

**❌ 没有超时：**条件永远不满足时无限循环
**✅ 修复：**始终包含超时和清晰错误

**❌ 数据过时：**在循环前缓存状态
**✅ 修复：**在循环内调用 getter，获取新鲜数据

## 何时任意超时是正确的

```typescript
// Tool 每 100ms tick 一次——需要 2 次 tick 来验证部分输出
await waitForEvent(manager, 'TOOL_STARTED'); // 首先：等待条件
await new Promise(r => setTimeout(r, 200));   // 然后：等待有时序的行为
// 200ms = 100ms 间隔的 2 次 tick——有记录且有理由
```

**要求：**
1. 先等待触发条件
2. 基于已知时序，而不是猜测
3. 添加解释原因的注释

## 实际影响

来自调试会话（2025-10-03）：
- 修复了 3 个文件中的 15 个不稳定测试
- 通过率：60% → 100%
- 执行时间：快 40%
- 不再有竞态条件
