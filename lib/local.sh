#!/usr/bin/env bash
git init -qqq
git remote add origin https://github.com/whalestore/docker-magento/tree/local
git fetch origin -qqq
git checkout origin/master -- compose

if [ -d "./bin" ]; then
  echo "Error: The current directory is not empty. Please remove all contents within this directory and try again."
  exit 1
fi

mv compose/* ./
mv compose/.gitignore ./
mv compose/.vscode ./
rm -rf compose .git
git init

# Ensure these are created so Docker doesn't create them as root
mkdir -p ~/.composer ~/.ssh

# 修改 ~/.composer/auth.json 权限
if [ -f ~/.composer/auth.json ]; then
  chown $(id -u):$(id -g) ~/.composer/auth.json
  chmod 600 ~/.composer/auth.json
fi