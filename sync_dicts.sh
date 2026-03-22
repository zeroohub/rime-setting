#!/bin/bash
# Rime 增强词库全自动同步与激活工具

# 这里的路径是相对于本项目根目录的
DICT_DIR="dicts"
EXTENDED_DICT="luna_pinyin.extended.dict.yaml"
CURRENT_DIR=$(pwd)

echo "--- 1. 检查子模块目录 ---"
if [ ! -d "$DICT_DIR" ]; then
    echo "❌ 错误：未检测到 $DICT_DIR 目录。"
    echo "💡 提示：请先运行以下命令下载词库："
    echo "   git submodule update --init --recursive"
    exit 1
fi

echo "--- 2. 创建软链接到当前目录 ---"
count=0
# 进入子目录遍历文件，确保路径正确
cd "$DICT_DIR"
for dict_file in *.dict.yaml; do
    if [ -f "$dict_file" ]; then
        # 如果这个词库不是主扩展词库本身
        if [[ "$dict_file" == "$EXTENDED_DICT" ]]; then continue; fi
        
        target_link="$CURRENT_DIR/$dict_file"
        source_file="$CURRENT_DIR/$DICT_DIR/$dict_file"
        
        # 如果当前目录下不存在同名文件或链接，则创建
        if [ ! -e "$target_link" ]; then
            ln -s "$DICT_DIR/$dict_file" "$target_link"
            echo "🔗 已链接: $dict_file"
            ((count++))
        else
            echo "ℹ️  跳过已存在文件: $dict_file"
        fi
    fi
done
cd "$CURRENT_DIR"

echo "--- 3. 自动激活 $EXTENDED_DICT 中的配置 ---"
if [ -f "$EXTENDED_DICT" ]; then
    # 扫描当前根目录下所有的 .dict.yaml 软链接
    for link in *.dict.yaml; do
        if [ -L "$link" ]; then
            dict_name="${link%.dict.yaml}"
            # 在主文件中查找并取消注释该词库名
            if grep -q "#[[:space:]]*- $dict_name" "$EXTENDED_DICT"; then
                sed -i "s/^[[:space:]]*#[[:space:]]*- $dict_name$/  - $dict_name/" "$EXTENDED_DICT"
                echo "✅ 已激活配置: $dict_name"
            fi
        fi
    done
fi

echo "--- 同步完成！ ---"
if [ $count -gt 0 ]; then
    echo "✨ 成功创建了 $count 个词库链接。"
fi
echo "👉 现在运行 ./check.sh 验证，或直接在 Rime 菜单中“重新佈署”。"
