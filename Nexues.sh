#!/bin/bash

set -e  # 遇到错误时终止脚本执行即可

echo "📦 更新系统并安装必要的软件包..."
sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -yq

# 预设 GRUB 安装设备，避免交互式选择
echo "grub-pc grub-pc/install_devices multiselect /dev/nvme0n1" | sudo debconf-set-selections
echo "grub-pc grub-pc/continue_without_bootloader boolean true" | sudo debconf-set-selections
sudo apt install --reinstall -y grub-pc

# 预设 SSH 配置文件更新策略，保持本地版本
echo "openssh-server openssh-server/sshd_config select keep" | sudo debconf-set-selections

sudo apt install -y build-essential pkg-config libssl-dev git-all protobuf-compiler curl

echo "☑️ 安装 Rust 环境..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

rustup target add riscv32i-unknown-none-elf

echo "🚀 正在安装 Nexus 节点..."
curl https://cli.nexus.xyz | sh -s -- -y

echo "✅ 安装完成！"
echo "请运行 'nexus' 命令并输入 2 选择配置节点，然后输入你的 Node ID并回车。"