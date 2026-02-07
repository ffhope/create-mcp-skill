#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "用法: generate-mcp.sh <项目名称>"
    echo ""
    echo "示例:"
    echo "  ./generate-mcp.sh my-mcp-server"
    exit 1
fi

PROJECT_NAME="$1"

# 验证项目名称
if ! echo "$PROJECT_NAME" | grep -qE '^[a-z0-9-]+$'; then
    echo "❌ 错误: 项目名称只能包含小写字母、数字和连字符"
    echo "   输入: $PROJECT_NAME"
    exit 1
fi

echo "📦 生成 MCP 项目: $PROJECT_NAME"

# 创建项目目录
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# 生成 package.json
cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "type": "module",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^0.5.0"
  }
}
EOF

# 生成 index.js
cat > index.js << 'EOF'
#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  ListResourcesRequestSchema,
  ReadResourceRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

const server = new Server(
  {
    name: 'PROJECT_NAME',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
      resources: {},
    },
  }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: 'echo',
      description: '回显输入的文本',
      inputSchema: {
        type: 'object',
        properties: {
          text: {
            type: 'string',
            description: '要回显的文本',
          },
        },
        required: ['text'],
      },
    },
  ],
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === 'echo') {
    return {
      content: [
        {
          type: 'text',
          text: `回显: ${args.text}`,
        },
      ],
    };
  }

  throw new Error(`未知工具: ${name}`);
});

server.setRequestHandler(ListResourcesRequestSchema, async () => ({
  resources: [
    {
      uri: 'demo://time',
      name: '当前时间',
      description: '获取当前时间',
      mimeType: 'text/plain',
    },
  ],
}));

server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  const { uri } = request.params;

  if (uri === 'demo://time') {
    return {
      contents: [
        {
          uri,
          mimeType: 'text/plain',
          text: `当前时间: ${new Date().toLocaleString('zh-CN')}`,
        },
      ],
    };
  }

  throw new Error(`未知资源: ${uri}`);
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch(console.error);
EOF

# 替换 PROJECT_NAME
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/PROJECT_NAME/$PROJECT_NAME/g" index.js
else
    sed -i "s/PROJECT_NAME/$PROJECT_NAME/g" index.js
fi

# 生成 .gitignore
cat > .gitignore << EOF
node_modules/
.DS_Store
*.log
.env
*.db
EOF

# 生成 README.md
cat > README.md << EOF
# $PROJECT_NAME

MCP 服务器项目

## 安装依赖

\`\`\`bash
npm install
\`\`\`

## 运行

\`\`\`bash
npm start
\`\`\`

## Cursor 配置

在 Cursor MCP 配置文件中添加：

\`\`\`json
{
  "mcpServers": {
    "$PROJECT_NAME": {
      "command": "node",
      "args": ["$(pwd)/index.js"]
    }
  }
}
\`\`\`

**注意**: 将路径替换为实际绝对路径。
EOF

# 生成 cursor-config.json 模板
cat > cursor-config.json << EOF
{
  "mcpServers": {
    "$PROJECT_NAME": {
      "command": "node",
      "args": ["$(pwd)/index.js"]
    }
  }
}
EOF

# 设置执行权限
chmod +x index.js

echo "✅ MCP 项目已创建！"
echo ""
echo "📁 目录: $PROJECT_NAME/"
echo "📄 已创建文件:"
echo "   - index.js"
echo "   - package.json"
echo "   - README.md"
echo "   - .gitignore"
echo "   - cursor-config.json"
echo ""
echo "下一步:"
echo "  1. cd $PROJECT_NAME"
echo "  2. npm install"
echo "  3. 编辑 cursor-config.json 中的路径"
echo "  4. 重启 Cursor"
