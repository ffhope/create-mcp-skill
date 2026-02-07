# Create MCP Skill

用于 Cursor 的 Skill，帮助快速创建标准 MCP（Model Context Protocol）服务器项目。

## 功能

- 📦 创建标准 MCP 项目结构
- 🛠️ 生成基础服务器代码
- 📝 提供工具和资源模板
- ⚙️ 生成 Cursor 配置文件
- ✅ 验证项目结构
- 🧪 测试 MCP 服务器
- 📚 完整的技术文档和示例

## 安装

### 作为 Cursor Skill

**个人 Skill（推荐）**：
```bash
cp -r create-mcp-skill ~/.cursor/skills/create-mcp
```

**项目 Skill**：
```bash
cp -r create-mcp-skill .cursor/skills/create-mcp
```

### 作为 npm 包（如果发布）

```bash
npx skills add your-username/create-mcp-skill
```

## 使用方法

### 在 Cursor 中使用

- "创建一个名为 xxx 的 MCP 项目"
- "帮我创建标准 MCP 服务器"
- "添加一个新的 MCP 工具"
- "如何配置 Cursor MCP？"

### 使用脚本

```bash
# 生成新 MCP 项目
./scripts/generate-mcp.sh my-mcp-server

# 验证项目结构
./scripts/validate-mcp.sh /path/to/mcp-project

# 测试 MCP 服务器
./scripts/test-mcp.sh index.js

# 检查开发环境
./scripts/check-dependencies.sh
```

## 文件结构

```
create-mcp-skill/
├── SKILL.md                    # 主 skill 文件
├── README.md                   # 本文件
├── reference.md                # 详细技术参考
├── examples.md                 # 使用示例
├── STRUCTURE.md                 # 结构说明
├── PUBLISH.md                  # 发布指南
├── templates/                  # 模板文件
│   ├── index.js.template
│   ├── package.json.template
│   ├── cursor-config.json.template
│   └── .gitignore.template
└── scripts/                    # 工具脚本
    ├── generate-mcp.sh
    ├── validate-mcp.sh
    ├── test-mcp.sh
    └── check-dependencies.sh
```

## 文档

- **[SKILL.md](SKILL.md)** - 主 skill 文件，快速参考
- **[reference.md](reference.md)** - 完整技术文档
- **[examples.md](examples.md)** - 8+ 实际示例
- **[STRUCTURE.md](STRUCTURE.md)** - 项目结构说明

## 快速开始

1. **生成项目**：
   ```bash
   ./scripts/generate-mcp.sh my-server
   ```

2. **安装依赖**：
   ```bash
   cd my-server
   npm install
   ```

3. **配置 Cursor**：
   编辑 `cursor-config.json`，将路径替换为绝对路径

4. **重启 Cursor** 并测试

## 参考

基于 [mcp-demo](../mcp-demo) 项目的最佳实践。

## 许可证

MIT
