#!/bin/bash
# Rime 配置自动化校验脚本

DEPLOYER="/Library/Input Methods/Squirrel.app/Contents/MacOS/rime_deployer"
USER_DIR=$(pwd)
SHARED_DIR="/Library/Input Methods/Squirrel.app/Contents/SharedSupport"
BUILD_DIR="/tmp/rime_check_build"

echo "--- 开始校验 Rime 配置 ---"
rm -rf "$BUILD_DIR" && mkdir -p "$BUILD_DIR"

# 运行编译，捕获所有输出
"$DEPLOYER" --build "$USER_DIR" "$SHARED_DIR" "$BUILD_DIR" > /tmp/rime_check_log.txt 2>&1
RESULT=$?

if [ $RESULT -eq 0 ]; then
    echo "✅ 语法校验通过！所有文件编译正常。"
else
    # 如果是因为缺少词库文件报错
    if grep -q "does not exist" /tmp/rime_check_log.txt; then
        echo "❌ 校验失败：检测到缺失增强词库文件。"
        echo "💡 提示：请确保已运行以下命令同步词库："
        echo "   1. git submodule update --init --recursive"
        echo "   2. ./sync_dicts.sh"
        echo "--- 详细错误 ---"
        grep "does not exist" /tmp/rime_check_log.txt | head -n 3
    else
        echo "❌ 校验失败！具体错误如下："
        grep "E" /tmp/rime_check_log.txt | grep -v "Encode failure" | head -n 10
    fi
fi

echo "--- 校验结束 ---"
