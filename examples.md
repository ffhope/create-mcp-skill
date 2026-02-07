# MCP 开发示例

具体的 MCP 服务器开发示例，从简单到复杂。

## 示例 1: 基础 Echo 工具

最简单的 MCP 服务器，只有一个 echo 工具。

### 项目结构

```
echo-server/
├── index.js
├── package.json
└── README.md
```

### index.js

```javascript
#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

const server = new Server(
  {
    name: 'echo-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
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

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch(console.error);
```

### 测试

在 Cursor 中：
```
使用 echo 工具，回显"Hello MCP"
```

---

## 示例 2: 计算器工具

带错误处理的数学计算工具。

### index.js（部分）

```javascript
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: 'calculator',
      description: '执行简单的数学计算',
      inputSchema: {
        type: 'object',
        properties: {
          expression: {
            type: 'string',
            description: '数学表达式，如 "1+1" 或 "10*5"',
          },
        },
        required: ['expression'],
      },
    },
  ],
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === 'calculator') {
    try {
      // 安全计算（避免使用 eval）
      const result = Function(`"use strict"; return (${args.expression})`)();
      
      return {
        content: [
          {
            type: 'text',
            text: `计算结果: ${result}`,
          },
        ],
      };
    } catch (error) {
      return {
        content: [
          {
            type: 'text',
            text: `计算错误: ${error.message}`,
          },
        ],
        isError: true,
      };
    }
  }

  throw new Error(`未知工具: ${name}`);
});
```

---

## 示例 3: 文件操作工具

读取和写入文件的工具。

### index.js（部分）

```javascript
import fs from 'fs/promises';
import path from 'path';

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: 'readFile',
      description: '读取文件内容',
      inputSchema: {
        type: 'object',
        properties: {
          filePath: {
            type: 'string',
            description: '文件路径',
          },
        },
        required: ['filePath'],
      },
    },
    {
      name: 'writeFile',
      description: '写入文件内容',
      inputSchema: {
        type: 'object',
        properties: {
          filePath: {
            type: 'string',
            description: '文件路径',
          },
          content: {
            type: 'string',
            description: '文件内容',
          },
        },
        required: ['filePath', 'content'],
      },
    },
  ],
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === 'readFile') {
    try {
      const content = await fs.readFile(args.filePath, 'utf-8');
      return {
        content: [
          {
            type: 'text',
            text: content,
          },
        ],
      };
    } catch (error) {
      return {
        content: [
          {
            type: 'text',
            text: `读取失败: ${error.message}`,
          },
        ],
        isError: true,
      };
    }
  }

  if (name === 'writeFile') {
    try {
      await fs.writeFile(args.filePath, args.content, 'utf-8');
      return {
        content: [
          {
            type: 'text',
            text: `文件已写入: ${args.filePath}`,
          },
        ],
      };
    } catch (error) {
      return {
        content: [
          {
            type: 'text',
            text: `写入失败: ${error.message}`,
          },
        ],
        isError: true,
      };
    }
  }

  throw new Error(`未知工具: ${name}`);
});
```

---

## 示例 4: 时间资源

提供当前时间和时区信息的资源。

### index.js（部分）

```javascript
server.setRequestHandler(ListResourcesRequestSchema, async () => ({
  resources: [
    {
      uri: 'time://current',
      name: '当前时间',
      description: '获取当前时间',
      mimeType: 'application/json',
    },
    {
      uri: 'time://timezones',
      name: '时区列表',
      description: '获取所有时区',
      mimeType: 'application/json',
    },
  ],
}));

server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  const { uri } = request.params;

  if (uri === 'time://current') {
    const now = new Date();
    return {
      contents: [
        {
          uri,
          mimeType: 'application/json',
          text: JSON.stringify({
            timestamp: now.getTime(),
            iso: now.toISOString(),
            local: now.toLocaleString('zh-CN'),
            timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
          }, null, 2),
        },
      ],
    };
  }

  if (uri === 'time://timezones') {
    const timezones = Intl.supportedValuesOf('timeZone');
    return {
      contents: [
        {
          uri,
          mimeType: 'application/json',
          text: JSON.stringify(timezones, null, 2),
        },
      ],
    };
  }

  throw new Error(`未知资源: ${uri}`);
});
```

---

## 示例 5: 配置管理资源

读取和管理应用配置的资源。

### index.js（部分）

```javascript
import fs from 'fs/promises';

const CONFIG_PATH = './config.json';

server.setRequestHandler(ListResourcesRequestSchema, async () => ({
  resources: [
    {
      uri: 'config://app',
      name: '应用配置',
      description: '读取应用配置',
      mimeType: 'application/json',
    },
  ],
}));

server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  const { uri } = request.params;

  if (uri === 'config://app') {
    try {
      const configContent = await fs.readFile(CONFIG_PATH, 'utf-8');
      const config = JSON.parse(configContent);
      
      return {
        contents: [
          {
            uri,
            mimeType: 'application/json',
            text: JSON.stringify(config, null, 2),
          },
        ],
      };
    } catch (error) {
      // 如果文件不存在，返回默认配置
      const defaultConfig = {
        appName: 'My App',
        version: '1.0.0',
        settings: {
          theme: 'light',
          language: 'zh-CN',
        },
      };
      
      return {
        contents: [
          {
            uri,
            mimeType: 'application/json',
            text: JSON.stringify(defaultConfig, null, 2),
          },
        ],
      };
    }
  }

  throw new Error(`未知资源: ${uri}`);
});
```

---

## 示例 6: HTTP 请求工具

调用外部 API 的工具。

### index.js（部分）

```javascript
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: 'httpRequest',
      description: '发送 HTTP 请求',
      inputSchema: {
        type: 'object',
        properties: {
          url: {
            type: 'string',
            description: '请求 URL',
          },
          method: {
            type: 'string',
            description: 'HTTP 方法（GET, POST, PUT, DELETE）',
            enum: ['GET', 'POST', 'PUT', 'DELETE'],
            default: 'GET',
          },
          headers: {
            type: 'object',
            description: '请求头',
          },
          body: {
            type: 'string',
            description: '请求体（JSON 字符串）',
          },
        },
        required: ['url'],
      },
    },
  ],
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === 'httpRequest') {
    try {
      const options = {
        method: args.method || 'GET',
        headers: {
          'Content-Type': 'application/json',
          ...args.headers,
        },
      };

      if (args.body) {
        options.body = args.body;
      }

      const response = await fetch(args.url, options);
      const data = await response.json();

      return {
        content: [
          {
            type: 'text',
            text: JSON.stringify({
              status: response.status,
              statusText: response.statusText,
              data,
            }, null, 2),
          },
        ],
      };
    } catch (error) {
      return {
        content: [
          {
            type: 'text',
            text: `请求失败: ${error.message}`,
          },
        ],
        isError: true,
      };
    }
  }

  throw new Error(`未知工具: ${name}`);
});
```

---

## 示例 7: 数据库查询工具

查询数据库的工具（使用 SQLite 示例）。

### package.json（添加依赖）

```json
{
  "dependencies": {
    "@modelcontextprotocol/sdk": "^0.5.0",
    "better-sqlite3": "^9.0.0"
  }
}
```

### index.js（部分）

```javascript
import Database from 'better-sqlite3';

const db = new Database('./database.db');

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: 'queryDatabase',
      description: '执行 SQL 查询',
      inputSchema: {
        type: 'object',
        properties: {
          sql: {
            type: 'string',
            description: 'SQL 查询语句',
          },
        },
        required: ['sql'],
      },
    },
  ],
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === 'queryDatabase') {
    try {
      const stmt = db.prepare(args.sql);
      const result = stmt.all();
      
      return {
        content: [
          {
            type: 'text',
            text: JSON.stringify(result, null, 2),
          },
        ],
      };
    } catch (error) {
      return {
        content: [
          {
            type: 'text',
            text: `查询失败: ${error.message}`,
          },
        ],
        isError: true,
      };
    }
  }

  throw new Error(`未知工具: ${name}`);
});
```

---

## 示例 8: 复杂 MCP 服务器

包含多个工具和资源的完整示例。

### 功能列表

- **工具**：
  - 文本处理（反转、大写、小写）
  - 文件操作（读取、写入）
  - HTTP 请求
- **资源**：
  - 当前时间
  - 系统信息
  - 配置信息

### 完整代码结构

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
import fs from 'fs/promises';
import os from 'os';

const server = new Server(
  {
    name: 'complex-mcp-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
      resources: {},
    },
  }
);

// 工具列表
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: 'reverseText',
      description: '反转文本',
      inputSchema: {
        type: 'object',
        properties: {
          text: { type: 'string', description: '要反转的文本' },
        },
        required: ['text'],
      },
    },
    {
      name: 'toUpperCase',
      description: '转换为大写',
      inputSchema: {
        type: 'object',
        properties: {
          text: { type: 'string', description: '要转换的文本' },
        },
        required: ['text'],
      },
    },
    {
      name: 'readFile',
      description: '读取文件',
      inputSchema: {
        type: 'object',
        properties: {
          filePath: { type: 'string', description: '文件路径' },
        },
        required: ['filePath'],
      },
    },
  ],
}));

// 工具处理
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case 'reverseText':
      return {
        content: [{ type: 'text', text: args.text.split('').reverse().join('') }],
      };
    case 'toUpperCase':
      return {
        content: [{ type: 'text', text: args.text.toUpperCase() }],
      };
    case 'readFile':
      try {
        const content = await fs.readFile(args.filePath, 'utf-8');
        return {
          content: [{ type: 'text', text: content }],
        };
      } catch (error) {
        return {
          content: [{ type: 'text', text: `错误: ${error.message}` }],
          isError: true,
        };
      }
    default:
      throw new Error(`未知工具: ${name}`);
  }
});

// 资源列表
server.setRequestHandler(ListResourcesRequestSchema, async () => ({
  resources: [
    {
      uri: 'system://info',
      name: '系统信息',
      description: '获取系统信息',
      mimeType: 'application/json',
    },
    {
      uri: 'time://current',
      name: '当前时间',
      description: '获取当前时间',
      mimeType: 'application/json',
    },
  ],
}));

// 资源处理
server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  const { uri } = request.params;

  switch (uri) {
    case 'system://info':
      return {
        contents: [
          {
            uri,
            mimeType: 'application/json',
            text: JSON.stringify({
              platform: os.platform(),
              arch: os.arch(),
              cpus: os.cpus().length,
              totalMemory: os.totalmem(),
              freeMemory: os.freemem(),
            }, null, 2),
          },
        ],
      };
    case 'time://current':
      return {
        contents: [
          {
            uri,
            mimeType: 'application/json',
            text: JSON.stringify({
              timestamp: Date.now(),
              iso: new Date().toISOString(),
              local: new Date().toLocaleString('zh-CN'),
            }, null, 2),
          },
        ],
      };
    default:
      throw new Error(`未知资源: ${uri}`);
  }
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch(console.error);
```

---

## 测试示例

### 测试 Echo 工具

在 Cursor 中：
```
使用 echo 工具，回显"测试成功"
```

### 测试计算器

```
使用 calculator 工具，计算表达式 "10 * 5 + 3"
```

### 测试文件读取

```
使用 readFile 工具，读取文件 "/path/to/file.txt"
```

### 测试资源

```
读取当前时间资源
读取系统信息资源
```

---

## 最佳实践总结

1. **错误处理**：始终使用 try-catch
2. **参数验证**：检查必需参数
3. **返回格式**：统一使用标准格式
4. **日志记录**：使用 console.error 记录调试信息
5. **文档注释**：清晰的工具和资源描述
