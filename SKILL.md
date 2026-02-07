---
name: create-mcp
description: 创建标准 MCP（Model Context Protocol）服务器项目。当用户需要创建新的 MCP 服务器、添加 MCP 工具或资源、配置 Cursor MCP 时使用。提供完整的项目模板、工具和资源开发指南、Cursor 配置说明。
---

# 创建标准 MCP 服务器

快速创建标准 MCP（Model Context Protocol）服务器项目的完整指南。

## 何时使用此 Skill

使用此 skill 当：
- 创建新的 MCP 服务器项目
- 添加 MCP 工具（Tools）
- 添加 MCP 资源（Resources）
- 配置 Cursor MCP 连接
- 调试 MCP 服务器问题

## 快速开始

### 方法一：使用生成脚本

```bash
./scripts/generate-mcp.sh my-mcp-server
```

### 方法二：手动创建

1. 创建项目目录
2. 初始化 package.json（参考 [reference.md](reference.md#packagejson-配置)）
3. 创建 index.js（参考 [reference.md](reference.md#服务器代码结构)）
4. 配置 Cursor（参考 [reference.md](reference.md#cursor-配置)）

## 项目结构

```
mcp-project-name/
├── index.js              # MCP 服务器主文件
├── package.json          # 项目依赖配置
├── cursor-config.json    # Cursor MCP 配置模板
├── .gitignore           # Git 忽略文件
└── README.md            # 项目说明
```

## 核心概念

### Tools（工具）
AI 可以调用的函数，如计算器、文件操作等。

### Resources（资源）
AI 可以读取的数据，如配置文件、数据库信息等。

## 标准模板

基础模板代码见 [reference.md](reference.md#标准模板代码)。

## 添加工具和资源

详细指南见 [reference.md](reference.md#添加工具) 和 [reference.md](reference.md#添加资源)。

## Cursor 配置

配置文件位置和格式见 [reference.md](reference.md#cursor-配置)。

## 验证和测试

使用验证脚本：
```bash
./scripts/validate-mcp.sh .
./scripts/test-mcp.sh index.js
```

## 完整示例

查看 [examples.md](examples.md) 获取：
- 简单 echo 工具示例
- 计算器工具示例
- 文件操作工具示例
- 数据库资源示例
- 复杂 MCP 服务器示例

## 工具脚本

- **generate-mcp.sh** - 生成 MCP 项目模板
- **validate-mcp.sh** - 验证 MCP 项目结构
- **test-mcp.sh** - 测试 MCP 服务器
- **check-dependencies.sh** - 检查依赖安装

## 常见问题

见 [reference.md](reference.md#常见问题)。

## 更多资源

- 详细技术文档：[reference.md](reference.md)
- 使用示例：[examples.md](examples.md)
- 项目结构说明：[STRUCTURE.md](STRUCTURE.md)
