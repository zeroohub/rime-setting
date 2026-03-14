# 🐉 Rime Setting - 极致输入体验配置

一套专为 macOS 鼠须管（Squirrel）打造的 Rime 高级配置，基于 **“模块化共享架构”** 设计，集成了 **Lua 增强**、**中英混输** 和 **语义模型**。

---

## ✨ 核心特性

- 🧠 **语义模型**: 集成 `Octagram` 语言模型，大幅提升长句子预测准确率。
- 🔤 **中英混输**: 内置 `Easy_en` 英文词库，输入英文单词自动联想。
- 🧮 **动态计算器**: 在输入框直接计算结果。输入 `q` + 表达式（如 `q1+2*3`）。
- 💰 **金额大写**: 财务报销神器。输入 `R` + 数字（如 `R123.45`）自动转换人民币大写。
- 🔍 **笔画反查**: 遇到生僻字，按 `` ` `` 键进入笔画模式（h横、s竖、p撇、n捺、z折）查拼音。
- 📅 **快捷时间**: 输入 `rq` 出日期，`sj` 出时间，`xq` 出星期。
- 🎨 **精美皮肤**: 内置 10+ 套配色方案（微信键盘风格、Mac 风格、Nord 等）。

---

## 🚀 快速上手

1.  **备份**: 备份现有的 `~/Library/Rime` 文件夹。
2.  **安装字体**: 安装 `fonts/` 目录下的字体（HanaMinA/B）。
3.  **同步文件**: 将本仓库所有文件拷贝至 `~/Library/Rime`。
4.  **重新部署**: 点击 Rime 图标，选择 **“重新佈署 (Redeploy)”**。

---

## 🛠 功能指令说明

| 指令 | 描述 | 示例 |
| :--- | :--- | :--- |
| `q` | 动态计算器 | `q1+2*3` -> `7` |
| `R` | 人民币/大写转换 | `R123.4` -> `壹佰贰拾叁元肆角` |
| `rq` | 日期转换 | `2024-03-14` |
| `sj` | 时间转换 | `09:15:20` |
| `` ` `` | 笔画反查 | `` `hspnz `` |
| `Ctrl + Shift + 4` | 繁简切换 | 实时切换 |

---

## 📂 模块化配置文件指南

本项目采用了 **“核心逻辑分离”** 的架构，方便维护：

- **核心共享层**:
  - `shared_common.yaml`: **[最重要]** 存放所有方案共用的 Lua 插件、Emoji、英文混输、反查逻辑。
  - `rime.lua`: 存放计算器、日期、金额转换的底层 Lua 代码。
- **方案定义层**:
  - `default.custom.yaml`: 全局开关、方案列表、快捷键。
  - `luna_pinyin_simp.custom.yaml`: 朙月拼音简体。
  - `double_pinyin_flypy.custom.yaml`: 小鹤双拼。
  - `double_pinyin.custom.yaml`: 自然码双拼。
- **外观与个性化**:
  - `squirrel.custom.yaml`: macOS 专属设置（App 默认中/英状态、皮肤选择）。
  - `custom_phrase.txt`: 用户自定义静态短语。

---

## 🎨 切换皮肤

打开 `squirrel.custom.yaml`，修改以下两行：

```yaml
style/color_scheme: wechat_light      # 浅色模式皮肤
style/color_scheme_dark: wechat_dark # 深色模式皮肤
```

推荐可选：`wechat_light`, `mac_light`, `google`, `nord_light`, `apathy` 等。

---

## 📝 开发者提示 (Maintenance)

如果您需要修改 **全方案通用** 的功能（例如调整计算器的触发键或修改 Emoji 过滤规则）：
👉 请直接修改 `shared_common.yaml`。修改后，所有输入方案都会同步更新。

---

## 感谢

- [librime-lua](https://github.com/higeno/librime-lua)
- [easy-en](https://github.com/BlindingDark/rime-easy-en)
- [octagram-data](https://github.com/lotem/rime-octagram-data)
