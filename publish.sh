#!/bin/bash

set -e

REPO_NAME="create-mcp-skill"
REPO_OWNER=$(gh api user --jq .login 2>/dev/null || echo "")

if [ -z "$REPO_OWNER" ]; then
    echo "错误: 请先登录 GitHub CLI"
    echo "运行: gh auth login"
    exit 1
fi

echo "仓库所有者: $REPO_OWNER"
echo "仓库名称: $REPO_NAME"

# 检查是否已有远程仓库
if git remote get-url origin &> /dev/null; then
    echo "远程仓库已配置，直接推送..."
    git push -u origin main
else
    echo "创建 GitHub 仓库..."
    gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
fi

echo ""
echo "✅ 发布成功！"
echo "📍 仓库地址: https://github.com/$REPO_OWNER/$REPO_NAME"
echo ""
echo "安装命令:"
echo "  npx skills add $REPO_OWNER/$REPO_NAME"
