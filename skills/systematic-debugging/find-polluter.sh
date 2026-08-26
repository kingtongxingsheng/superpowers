#!/usr/bin/env bash
# 用二分脚本找出创建不需要文件/状态的测试
# 用法：./find-polluter.sh <file_or_dir_to_check> <test_pattern>
# 示例：./find-polluter.sh '.git' 'src/**/*.test.ts'

set -e

if [ $# -ne 2 ]; then
  echo "用法：$0 <file_to_check> <test_pattern>"
  echo "示例：$0 '.git' 'src/**/*.test.ts'"
  exit 1
fi

POLLUTION_CHECK="$1"
TEST_PATTERN="$2"

echo "🔍 正在搜索创建以下内容的测试：$POLLUTION_CHECK"
echo "测试模式：$TEST_PATTERN"
echo ""

# Get list of test files (find . emits ./-prefixed paths, so accept the
# pattern written with or without a leading ./)
TEST_PATTERN="${TEST_PATTERN#./}"
# find -path can't match '**/' against zero directory levels, so a pattern
# like src/**/*.test.ts would skip src/top.test.ts; also try the pattern
# with '**/' collapsed to cover files directly under the base directory.
TEST_FILES=$(find . \( -path "./$TEST_PATTERN" -o -path "./${TEST_PATTERN//\*\*\//}" \) | sort -u)
if [ -z "$TEST_FILES" ]; then
  TOTAL=0
else
  TOTAL=$(printf '%s\n' "$TEST_FILES" | wc -l | tr -d ' ')
fi

echo "找到 $TOTAL 个测试文件"
echo ""

COUNT=0
for TEST_FILE in $TEST_FILES; do
  COUNT=$((COUNT + 1))

  # Skip if pollution already exists
  if [ -e "$POLLUTION_CHECK" ]; then
    echo "⚠️  测试 $COUNT/$TOTAL 前已存在污染"
    echo "   跳过：$TEST_FILE"
    continue
  fi

  echo "[$COUNT/$TOTAL] 测试：$TEST_FILE"

  # Run the test
  npm test "$TEST_FILE" > /dev/null 2>&1 || true

  # Check if pollution appeared
  if [ -e "$POLLUTION_CHECK" ]; then
    echo ""
    echo "🎯 找到污染者！"
    echo "   测试：$TEST_FILE"
    echo "   创建了：$POLLUTION_CHECK"
    echo ""
    echo "污染详情："
    ls -la "$POLLUTION_CHECK"
    echo ""
    echo "调查方法："
    echo "  npm test $TEST_FILE    # 只运行这个测试"
    echo "  cat $TEST_FILE         # 查看测试代码"
    exit 1
  fi
done

echo ""
echo "✅ 未找到污染者——所有测试都干净！"
exit 0
