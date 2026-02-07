# Create MCP Skill 结构说明

## 完整文件结构

```
create-mcp-skill/
├── SKILL.md                    # 主 skill 文件
├── README.md                   # 仓库文档
├── reference.md                # 详细技术参考文档
├── examples.md                 # 使用示例
├── STRUCTURE.md                # 本文件
├── PUBLISH.md                  # 发布指南
├── .gitignore                  # Git 忽略规则
├── publish.sh                  # 发布脚本（GitHub CLI）
├── templates/                  # 模板文件目录
│   ├── index.js.template
│   ├── package.json.template
│   ├── cursor-config.json.template
│   └── .gitignore.template
└── scripts/                    # 工具脚本
    ├── generate-mcp.sh        # 生成 MCP 项目模板
    ├── validate-mcp.sh        # 验证 MCP 项目结构
    ├── test-mcp.sh           # 测试 MCP 服务器
    └── check-dependencies.sh  # 检查依赖安装
```

## 文件用途

### 核心文件

- **SKILL.md** - 主指令文件，包含快速参考和链接
  - 渐进式披露模式
  - 链接到详细文档

- **reference.md** - 完整技术参考文档
  - MCP 架构详解
  - SDK API 说明
  - 工具和资源开发指南
  - Cursor 配置详解
  - 故障排查指南
  - 最佳实践

- **examples.md** - 具体使用示例
  - 10+ 完整示例
  - 简单到复杂的渐进示例
  - 实际应用场景

### 工具脚本

- **generate-mcp.sh** - 生成 MCP 项目模板
  - 创建目录结构
  - 生成基础文件
  - 初始化 git

- **validate-mcp.sh** - 验证 MCP 项目结构
  - 检查必需文件
  - 验证代码格式
  - 检查依赖配置

- **test-mcp.sh** - 测试 MCP 服务器
  - 启动服务器
  - 测试工具调用
  - 测试资源读取

- **check-dependencies.sh** - 检查依赖安装
  - 检查 Node.js 版本
  - 检查 npm 包
  - 验证 SDK 版本

### 模板文件

- **templates/index.js.template** - MCP 服务器代码模板
- **templates/package.json.template** - package.json 模板
- **templates/cursor-config.json.template** - Cursor 配置模板
- **templates/.gitignore.template** - Git 忽略文件模板

## 使用方式

### 生成新 MCP 项目

```bash
./scripts/generate-mcp.sh my-mcp-server
```

### 验证项目结构

```bash
./scripts/validate-mcp.sh /path/to/mcp-project
```

### 测试 MCP 服务器

```bash
./scripts/test-mcp.sh /path/to/mcp-project/index.js
```

### 检查依赖

```bash
./scripts/check-dependencies.sh
```

## 统计信息

- **总文件数**: 15+
- **脚本数**: 4
- **文档数**: 5
- **模板数**: 4
- **总文档行数**: 2000+ 行
