---
name: create-mcp
description: 创建标准 MCP（Model Context Protocol）服务器项目。当用户需要创建新的 MCP 服务器、添加 MCP 工具或资源、配置 Cursor MCP 时使用。
---

# 创建标准 MCP 服务器

## 快速开始

创建标准 MCP 项目结构：

1. 创建项目目录和基础文件
2. 初始化 package.json
3. 创建 index.js 服务器代码
4. 创建 Cursor 配置文件模板

## 项目结构

```
mcp-project-name/
├── index.js              # MCP 服务器主文件
├── package.json          # 项目依赖配置
├── cursor-config.json    # Cursor MCP 配置模板
├── .gitignore           # Git 忽略文件
└── README.md            # 项目说明
```

## 标准模板

### package.json

```json
{
  "name": "mcp-project-name",
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
```

### index.js 基础结构

```javascript
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
    name: 'mcp-project-name',
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
```

### cursor-config.json 模板

```json
{
  "mcpServers": {
    "mcp-project-name": {
      "command": "node",
      "args": ["/完整路径/mcp-project-name/index.js"]
    }
  }
}
```

## 添加新工具

在 `ListToolsRequestSchema` 中添加工具定义：

```javascript
{
  name: 'tool-name',
  description: '工具描述',
  inputSchema: {
    type: 'object',
    properties: {
      param1: {
        type: 'string',
        description: '参数描述',
      },
    },
    required: ['param1'],
  },
}
```

在 `CallToolRequestSchema` 中添加处理逻辑：

```javascript
if (name === 'tool-name') {
  const { param1 } = args;
  return {
    content: [
      {
        type: 'text',
        text: `结果: ${param1}`,
      },
    ],
  };
}
```

## 添加新资源

在 `ListResourcesRequestSchema` 中添加资源定义：

```javascript
{
  uri: 'demo://resource-name',
  name: '资源名称',
  description: '资源描述',
  mimeType: 'text/plain',
}
```

在 `ReadResourceRequestSchema` 中添加读取逻辑：

```javascript
if (uri === 'demo://resource-name') {
  return {
    contents: [
      {
        uri,
        mimeType: 'text/plain',
        text: '资源内容',
      },
    ],
  };
}
```

## Cursor 配置

配置文件位置（macOS）：
```
~/Library/Application Support/Cursor/User/globalStorage/rooveterinaryinc.roo-cline/settings/cline_mcp_settings.json
```

**重要**：
- 使用绝对路径
- 配置后需重启 Cursor
- 确保 Node.js 版本 >= 18

## 验证方法

在 Cursor 中测试：
- 工具：`使用 echo 工具，回显"测试成功"`
- 资源：`读取当前时间资源`

## 常见问题

1. **服务器启动失败**：检查 Node.js 版本和依赖安装
2. **Cursor 找不到工具**：检查配置文件路径是否为绝对路径
3. **工具调用错误**：检查参数格式是否符合 inputSchema
