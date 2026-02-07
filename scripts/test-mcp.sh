#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "用法: test-mcp.sh <index.js路径>"
    echo ""
    echo "示例:"
    echo "  ./test-mcp.sh ./index.js"
    echo "  ./test-mcp.sh /path/to/mcp-server/index.js"
    exit 1
fi

INDEX_FILE="$1"

if [ ! -f "$INDEX_FILE" ]; then
    echo "❌ 错误: 文件不存在: $INDEX_FILE"
    exit 1
fi

echo "🧪 测试 MCP 服务器: $INDEX_FILE"
echo ""

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "❌ 错误: 未安装 Node.js"
    exit 1
fi

# 检查文件语法
echo "📝 检查语法..."
if node --check "$INDEX_FILE" 2>/dev/null; then
    echo "✅ 语法检查通过"
else
    echo "❌ 语法错误"
    node --check "$INDEX_FILE"
    exit 1
fi

# 检查依赖
echo ""
echo "📦 检查依赖..."
DIR=$(dirname "$INDEX_FILE")
if [ ! -d "$DIR/node_modules/@modelcontextprotocol" ]; then
    echo "⚠️  警告: 依赖未安装，请先运行 npm install"
    echo "   在目录 $DIR 中运行: npm install"
fi

echo ""
echo "✅ 基础检查通过"
echo ""
echo "💡 提示:"
echo "   1. 启动服务器: node $INDEX_FILE"
echo "   2. 在 Cursor 中配置 MCP 服务器"
echo "   3. 重启 Cursor 后测试工具调用"
echo ""
echo "📋 Cursor 配置示例:"
echo "{"
echo "  \"mcpServers\": {"
echo "    \"test-server\": {"
echo "      \"command\": \"node\","
echo "      \"args\": [\"$(realpath "$INDEX_FILE" 2>/dev/null || echo "$INDEX_FILE")\"]"
echo "    }"
echo "  }"
echo "}"
