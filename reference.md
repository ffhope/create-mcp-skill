# MCP 开发技术参考

完整的 MCP（Model Context Protocol）开发技术文档。

## 目录

1. [MCP 架构](#mcp-架构)
2. [环境准备](#环境准备)
3. [项目结构](#项目结构)
4. [SDK API 详解](#sdk-api-详解)
5. [工具开发](#工具开发)
6. [资源开发](#资源开发)
7. [Cursor 配置](#cursor-配置)
8. [调试和测试](#调试和测试)
9. [最佳实践](#最佳实践)
10. [常见问题](#常见问题)

---

## MCP 架构

### 核心概念

MCP（Model Context Protocol）是一个协议，让 AI 助手能够：
- **调用工具（Tools）**：执行函数，如计算、文件操作、API 调用
- **访问资源（Resources）**：读取数据，如配置文件、数据库信息

### 通信方式

MCP 服务器通过 **stdio**（标准输入输出）与 Cursor 通信：
- Cursor 发送 JSON-RPC 请求到标准输入
- MCP 服务器处理请求并返回结果到标准输出

### 请求类型

1. **ListTools** - 列出所有可用工具
2. **CallTool** - 调用指定工具
3. **ListResources** - 列出所有可用资源
4. **ReadResource** - 读取指定资源

---

## 环境准备

### Node.js 版本要求

- **最低版本**: Node.js 18+
- **推荐版本**: Node.js 20 LTS

检查版本：
```bash
node --version
```

### 安装 SDK

```bash
npm install @modelcontextprotocol/sdk
```

### 项目初始化

```bash
mkdir my-mcp-server
cd my-mcp-server
npm init -y
```

---

## 项目结构

### 标准结构

```
my-mcp-server/
├── index.js              # 服务器主文件
├── package.json          # 项目配置
├── .gitignore           # Git 忽略
└── README.md            # 项目说明
```

### package.json 配置

```json
{
  "name": "my-mcp-server",
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

**关键配置说明**：
- `"type": "module"` - 使用 ES6 模块语法
- `"main": "index.js"` - 入口文件
- SDK 版本建议使用 `^0.5.0` 或更高

---

## SDK API 详解

### 导入模块

```javascript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  ListResourcesRequestSchema,
  ReadResourceRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
```

### Server 类

创建服务器实例：

```javascript
const server = new Server(
  {
    name: 'my-mcp-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
      resources: {},
    },
  }
);
```

**参数说明**：
- `name`: 服务器名称（用于标识）
- `version`: 版本号
- `capabilities`: 声明支持的功能

### 注册请求处理器

```javascript
server.setRequestHandler(RequestSchema, async (request) => {
  // 处理逻辑
});
```

---

## 工具开发

### 工具定义结构

```javascript
{
  name: 'tool-name',           // 工具名称（唯一标识）
  description: '工具描述',      // AI 理解工具用途
  inputSchema: {                // JSON Schema 格式
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

### 列出工具

```javascript
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
```

### 处理工具调用

```javascript
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
```

### 返回格式

**成功返回**：
```javascript
{
  content: [
    {
      type: 'text',
      text: '结果文本',
    },
  ],
}
```

**错误返回**：
```javascript
{
  content: [
    {
      type: 'text',
      text: '错误信息',
    },
  ],
  isError: true,
}
```

### 参数类型

支持 JSON Schema 类型：
- `string` - 字符串
- `number` - 数字
- `boolean` - 布尔值
- `array` - 数组
- `object` - 对象

---

## 资源开发

### 资源定义结构

```javascript
{
  uri: 'demo://resource-name',  // 资源 URI（唯一标识）
  name: '资源名称',              // 显示名称
  description: '资源描述',       // AI 理解资源用途
  mimeType: 'text/plain',       // MIME 类型
}
```

### 列出资源

```javascript
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
```

### 处理资源读取

```javascript
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
```

### 返回格式

```javascript
{
  contents: [
    {
      uri: 'demo://resource-name',
      mimeType: 'text/plain',
      text: '资源内容',
    },
  ],
}
```

### MIME 类型

常用 MIME 类型：
- `text/plain` - 纯文本
- `application/json` - JSON 数据
- `text/markdown` - Markdown 文档
- `text/html` - HTML 内容

---

## Cursor 配置

### 配置文件位置

**macOS**:
```
~/Library/Application Support/Cursor/User/globalStorage/rooveterinaryinc.roo-cline/settings/cline_mcp_settings.json
```

**Windows**:
```
%APPDATA%\Cursor\User\globalStorage\rooveterinaryinc.roo-cline\settings\cline_mcp_settings.json
```

**Linux**:
```
~/.config/Cursor/User/globalStorage/rooveterinaryinc.roo-cline/settings/cline_mcp_settings.json
```

### 配置格式

```json
{
  "mcpServers": {
    "my-mcp-server": {
      "command": "node",
      "args": ["/完整路径/my-mcp-server/index.js"]
    }
  }
}
```

**重要提示**：
- `args` 中的路径必须是**绝对路径**
- 不能使用相对路径或 `~` 符号
- 配置后需要**重启 Cursor**

### 获取绝对路径

**macOS/Linux**:
```bash
realpath index.js
# 或
pwd
```

**Windows**:
```powershell
(Resolve-Path index.js).Path
```

---

## 调试和测试

### 添加调试日志

```javascript
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  console.error('收到工具调用:', JSON.stringify(request.params, null, 2));
  // 处理逻辑
});
```

**注意**：使用 `console.error` 而不是 `console.log`，日志会输出到 Cursor 的日志文件。

### 查看 Cursor 日志

**macOS**:
```bash
tail -f ~/Library/Logs/Cursor/main.log | grep -i mcp
```

### 手动测试服务器

```bash
# 启动服务器（会等待输入）
node index.js

# 在另一个终端发送测试请求（需要 JSON-RPC 格式）
echo '{"jsonrpc":"2.0","method":"tools/list","id":1}' | node index.js
```

### 使用测试脚本

```bash
./scripts/test-mcp.sh index.js
```

---

## 最佳实践

### 1. 工具命名

- 使用小写字母和连字符：`my-tool-name`
- 避免下划线和驼峰命名
- 名称要清晰描述功能

### 2. 工具描述

- 清晰描述工具功能
- 说明使用场景
- 帮助 AI 理解何时调用

### 3. 参数验证

```javascript
if (!args.text || typeof args.text !== 'string') {
  return {
    content: [{ type: 'text', text: '参数 text 是必需的' }],
    isError: true,
  };
}
```

### 4. 错误处理

```javascript
try {
  // 处理逻辑
} catch (error) {
  return {
    content: [{ type: 'text', text: `错误: ${error.message}` }],
    isError: true,
  };
}
```

### 5. 资源 URI 设计

- 使用自定义 scheme：`demo://`, `app://`
- URI 要唯一且有意义
- 避免使用 `http://` 或 `https://`

### 6. 性能优化

- 避免阻塞操作
- 使用异步处理
- 缓存重复计算结果

---

## 常见问题

### Q1: 服务器启动失败

**检查清单**：
1. Node.js 版本 >= 18
2. 运行了 `npm install`
3. 文件路径正确
4. 代码语法正确

### Q2: Cursor 找不到工具

**检查清单**：
1. 配置文件路径是绝对路径
2. 重启了 Cursor
3. 服务器代码无错误
4. 检查 Cursor 日志

### Q3: 工具调用返回错误

**检查清单**：
1. 参数格式符合 inputSchema
2. 工具名称匹配
3. 返回格式正确
4. 错误处理完善

### Q4: 资源读取失败

**检查清单**：
1. URI 格式正确
2. 资源已注册
3. 返回格式正确
4. MIME 类型匹配

### Q5: 如何调试

**方法**：
1. 添加 `console.error` 日志
2. 查看 Cursor 日志文件
3. 使用测试脚本
4. 检查 JSON-RPC 格式

---

## 标准模板代码

### 完整 index.js 模板

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
    name: 'my-mcp-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
      resources: {},
    },
  }
);

// 列出工具
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

// 处理工具调用
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

// 列出资源
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

// 处理资源读取
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

// 启动服务器
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch(console.error);
```

---

## 参考资源

- [MCP 官方文档](https://modelcontextprotocol.io/)
- [MCP 示例仓库](https://github.com/modelcontextprotocol/servers)
- [JSON Schema 规范](https://json-schema.org/)
- [JSON-RPC 2.0 规范](https://www.jsonrpc.org/specification)
