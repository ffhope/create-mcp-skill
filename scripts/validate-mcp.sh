#!/bin/bash

set -e

PROJECT_DIR="${1:-.}"
ERRORS=0

echo "🔍 验证 MCP 项目: $PROJECT_DIR"

# 检查目录是否存在
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ 错误: 目录不存在: $PROJECT_DIR"
    exit 1
fi

# 检查必需文件
echo ""
echo "📄 检查必需文件..."

if [ ! -f "$PROJECT_DIR/index.js" ]; then
    echo "❌ 缺少: index.js"
    ERRORS=$((ERRORS + 1))
else
    echo "✅ index.js 存在"
fi

if [ ! -f "$PROJECT_DIR/package.json" ]; then
    echo "❌ 缺少: package.json"
    ERRORS=$((ERRORS + 1))
else
    echo "✅ package.json 存在"
    
    # 检查 package.json 内容
    if ! grep -q '"@modelcontextprotocol/sdk"' "$PROJECT_DIR/package.json"; then
        echo "⚠️  警告: package.json 中缺少 @modelcontextprotocol/sdk 依赖"
    fi
    
    if ! grep -q '"type": "module"' "$PROJECT_DIR/package.json"; then
        echo "⚠️  警告: package.json 中缺少 \"type\": \"module\""
    fi
fi

# 检查 index.js 内容
echo ""
echo "📝 检查 index.js 内容..."

if [ -f "$PROJECT_DIR/index.js" ]; then
    if ! grep -q "Server" "$PROJECT_DIR/index.js"; then
        echo "⚠️  警告: index.js 中未找到 Server 导入"
    fi
    
    if ! grep -q "StdioServerTransport" "$PROJECT_DIR/index.js"; then
        echo "⚠️  警告: index.js 中未找到 StdioServerTransport 导入"
    fi
    
    if ! grep -q "ListToolsRequestSchema" "$PROJECT_DIR/index.js"; then
        echo "⚠️  警告: index.js 中未找到 ListToolsRequestSchema"
    fi
    
    if ! grep -q "setRequestHandler" "$PROJECT_DIR/index.js"; then
        echo "⚠️  警告: index.js 中未找到 setRequestHandler"
    fi
fi

# 检查 node_modules
echo ""
echo "📦 检查依赖..."

if [ ! -d "$PROJECT_DIR/node_modules" ]; then
    echo "⚠️  警告: node_modules 不存在，请运行 npm install"
else
    if [ ! -d "$PROJECT_DIR/node_modules/@modelcontextprotocol" ]; then
        echo "❌ 错误: @modelcontextprotocol SDK 未安装"
        ERRORS=$((ERRORS + 1))
    else
        echo "✅ @modelcontextprotocol SDK 已安装"
    fi
fi

# 检查 Node.js 版本
echo ""
echo "🔧 检查环境..."

NODE_VERSION=$(node --version 2>/dev/null || echo "未安装")
echo "Node.js 版本: $NODE_VERSION"

if command -v node &> /dev/null; then
    MAJOR_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$MAJOR_VERSION" -lt 18 ]; then
        echo "⚠️  警告: Node.js 版本应 >= 18，当前: $MAJOR_VERSION"
    else
        echo "✅ Node.js 版本符合要求"
    fi
fi

# 总结
echo ""
if [ $ERRORS -eq 0 ]; then
    echo "✅ MCP 项目验证通过！"
    exit 0
else
    echo "❌ 验证失败，发现 $ERRORS 个错误"
    exit 1
fi
