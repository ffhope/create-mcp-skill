# 发布到 GitHub

## 步骤

1. 在 GitHub 创建新仓库：
   - 访问 https://github.com/new
   - 仓库名：`create-mcp-skill`（或自定义）
   - 选择 Public
   - 不要初始化 README、.gitignore 或 license

2. 添加远程仓库并推送：
   ```bash
   cd /Users/fufanghao/Desktop/ai-doc/create-mcp-skill
   git remote add origin https://github.com/ffhope/create-mcp-skill.git
   git branch -M main
   git push -u origin main
   ```

## 使用

其他人可以通过以下方式安装：

```bash
npx skills add ffhope/create-mcp-skill@create-mcp
```
