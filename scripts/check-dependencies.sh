#!/bin/bash

set -e

echo "🔍 检查 MCP 开发环境..."

# 检查 Node.js
echo ""
echo "📦 Node.js:"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "  ✅ 已安装: $NODE_VERSION"
    
    MAJOR_VERSION=$(echo "$NODE_VERSION" | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$MAJOR_VERSION" -lt 18 ]; then
        echo "  ⚠️  警告: 版本应 >= 18，当前: $MAJOR_VERSION"
    else
        echo "  ✅ 版本符合要求"
    fi
else
    echo "  ❌ 未安装"
    echo "     安装: https://nodejs.org/"
fi

# 检查 npm
echo ""
echo "📦 npm:"
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "  ✅ 已安装: v$NPM_VERSION"
else
    echo "  ❌ 未安装"
fi

# 检查 @modelcontextprotocol/sdk
echo ""
echo "📦 @modelcontextprotocol/sdk:"
if [ -d "./node_modules/@modelcontextprotocol" ]; then
    SDK_VERSION=$(cat ./node_modules/@modelcontextprotocol/sdk/package.json 2>/dev/null | grep '"version"' | head -1 | cut -d'"' -f4 || echo "未知")
    echo "  ✅ 已安装: v$SDK_VERSION"
else
    echo "  ⚠️  未安装（在当前目录）"
    echo "     安装: npm install @modelcontextprotocol/sdk"
fi

# 检查全局安装
if npm list -g @modelcontextprotocol/sdk &> /dev/null; then
    GLOBAL_VERSION=$(npm list -g @modelcontextprotocol/sdk 2>/dev/null | grep @modelcontextprotocol | head -1 | cut -d'@' -f3 || echo "")
    if [ -n "$GLOBAL_VERSION" ]; then
        echo "  ✅ 全局安装: v$GLOBAL_VERSION"
    fi
fi

# 检查 Cursor
echo ""
echo "🖥️  Cursor:"
if [ -d "$HOME/Library/Application Support/Cursor" ]; then
    echo "  ✅ Cursor 已安装（macOS）"
    MCP_CONFIG="$HOME/Library/Application Support/Cursor/User/globalStorage/rooveterinaryinc.roo-cline/settings/cline_mcp_settings.json"
    if [ -f "$MCP_CONFIG" ]; then
        echo "  ✅ MCP 配置文件存在"
        SERVER_COUNT=$(grep -c '"command"' "$MCP_CONFIG" 2>/dev/null || echo "0")
        echo "  📊 已配置服务器数: $SERVER_COUNT"
    else
        echo "  ⚠️  MCP 配置文件不存在"
    fi
elif [ -d "$HOME/.config/Cursor" ]; then
    echo "  ✅ Cursor 已安装（Linux）"
elif [ -d "$APPDATA/Cursor" ]; then
    echo "  ✅ Cursor 已安装（Windows）"
else
    echo "  ⚠️  未检测到 Cursor"
fi

echo ""
echo "✅ 检查完成"
