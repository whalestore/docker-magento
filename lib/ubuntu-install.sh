#!/usr/bin/env bash

# 初始化并设置远程仓库
echo "Initializing git repository..."
git init -qqq
git remote add origin https://github.com/whalestore/docker-magento.git
git fetch origin -qqq

# 检查 release/next 分支是否存在
branch_name="release/next"
if ! git ls-remote --heads origin $branch_name &>/dev/null ; then
  echo "Error: Branch '$branch_name' not found in the remote repository."
  exit 1
fi

echo "Checking out branch $branch_name..."
git checkout origin/$branch_name -- compose

# 检查 compose 目录是否存在
if [ -d "./compose" ]; then
  if [ "$(ls -A ./bin 2>/dev/null)" ]; then
    echo "Error: The current directory is not empty. Please remove all contents within this directory and try again."
    exit 1
  fi

  echo "Moving files from compose directory..."
  mv compose/* ./ 2>/dev/null
  mv compose/.gitignore ./ 2>/dev/null
  mv compose/.vscode ./ 2>/dev/null

  # 删除 compose 目录和 .git 文件夹
  rm -rf compose .git

  echo "Initializing new git repository..."
  git init
else
  echo "Error: 'compose' directory does not exist. Please check the repository."
  exit 1
fi

# 创建必要的目录
echo "Ensuring ~/.composer and ~/.ssh directories..."
mkdir -p ~/.composer ~/.ssh

# 修改 ~/.composer/auth.json 权限（如果存在）
if [ -f ~/.composer/auth.json ]; then
  echo "Updating ~/.composer/auth.json permissions..."
  chown $(id -u):$(id -g) ~/.composer/auth.json
  chmod 600 ~/.composer/auth.json
fi

echo "Script execution completed."