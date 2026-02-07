# 推送更新到 GitHub

由于网络连接问题，请手动执行以下命令推送更新：

## 方法 1: 使用 GitHub CLI（推荐）

```bash
cd create-mcp-skill

# 设置 token
export GH_TOKEN=your_github_token_here

# 推送
gh repo sync ffhope/create-mcp-skill --source . --force
```

## 方法 2: 使用 Git（带 token）

```bash
cd create-mcp-skill

# 设置远程 URL（包含 token，替换为你的 token）
git remote set-url origin https://your_github_token@github.com/ffhope/create-mcp-skill.git

# 推送
git push origin main
```

## 方法 3: 使用 SSH（如果已配置）

```bash
cd create-mcp-skill

# 切换到 SSH URL
git remote set-url origin git@github.com:ffhope/create-mcp-skill.git

# 推送
git push origin main
```

## 验证推送

推送成功后，检查：
- https://github.com/ffhope/create-mcp-skill
- 应该能看到更新后的 README.md

## 更新已安装的 Skill

```bash
npx skills update
# 或重新安装
npx skills add ffhope/create-mcp-skill@create-mcp --force
```
