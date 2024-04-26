#!/bin/bash

# 新主机名
NEW_HOSTNAME="pve1"

# 设置主机名
sudo hostname $NEW_HOSTNAME

# 编辑 hosts 文件
sudo sed -i "s/127.0.0.1.*/127.0.0.1\t$NEW_HOSTNAME/" /etc/hosts

# 输出提示信息
echo "主机名已成功修改为 $NEW_HOSTNAME"
