# MoonFountain

**把纯文本剧本变成可核对的场次表、角色统计和排练提示。**

MoonFountain is an original, bounded Fountain screenplay parser and rehearsal
breakdown library written in MoonBit. It retains exact source ranges instead of
round-tripping a screenplay through Markdown. It is not a full Fountain renderer,
PDF typesetter, subtitle processor, or production-management system.

## 一分钟体验 / Quick start

需要 MoonBit 工具链和 Node.js 22+；完整验证另需 Python 3.8+，native 运行需 C 编译器。
本地复验工具链：moon 0.1.20260904 / moonc 0.10.12 (2026-09-07)。
安装工具链参考 [MoonBit 官方安装文档](https://www.moonbitlang.com/download/)。
公开源码仓库：[2200732518gjy/moonfountain](https://github.com/2200732518gjy/moonfountain)。
先 `git clone https://github.com/2200732518gjy/moonfountain.git`，再
`cd moonfountain`。在仓库根目录执行（PowerShell / bash 均可）：

```sh
moon test --target wasm-gc
moon run examples/rehearsal --target wasm-gc
moon build --target js --release
node _build/js/release/build/cmd/moonfountain/moonfountain.js scenes examples/last-train.fountain
node _build/js/release/build/cmd/moonfountain/moonfountain.js cues examples/last-train.fountain 林
```

样例是原创的《Last Train / 末班车》，包含双语角色、两场戏、同步对白和隐藏草稿注释。
`scenes` 应输出两场：SIGNAL ROOM / PLATFORM；`cues ... 林` 输出三次出场，
第二场不错误沿用上一场的触发台词。嵌入式示例包含断言，跨目标复现相同语义。

**版本：0.1.0，公开源码；尚未发布 MoonCakes。** 因此不提供假定可用的
`moon add` 命令。当前安装/评估方式是取得本仓库源码后运行上述命令；公开源码已经推送，四目标托管 CI 已通过，见下方可核验的运行证据。

## 核心能力

- Fountain 场景、标题页、角色、对白、括号动作、转场、章节大纲与有限内联强调。
- 保留 LF / CRLF / CR、BOM、中文及 emoji 的原始文本；位置统一为 UTF-16 单元，
  `start..end` 左闭右开，行号从 1 开始，不冒充字节偏移或显示列。
- 角色按精确名称分组，剥离 V.O. 等扩展；按首次出场排序，统计场次、轮次和台词行。
- 排练提示保留台词中间的动作顺序，标明同步对白，不把同步关系伪装成顺序触发。
- JSON v1、转义的独立 HTML、场次表、角色表、诊断及精确源码片段。
- 默认 JSON/HTML 隐去成功闭合的 notes / boneyards；原始源码须显式选择。

## CLI

```text
moonfountain <json|json-source|html|scenes|cast|lint|cues> FILE|- [CHARACTER]
```

上面的 `moonfountain` 指 `node _build/js/release/build/cmd/moonfountain/moonfountain.js`，
不是声称系统已安装同名命令。带空格的文件名/角色名要加引号，`-` 读取 UTF-8 stdin。
命令不修改输入文件、不联网。Node 文件系统宿主仅支持 JS，库支持四个编译目标。

| 模式 | 输出 / 注意事项 |
|---|---|
| `json` | 结构、场次、角色、轮次、诊断；不附原文和注释正文 |
| `json-source` | 同上，但明确包含完整原文和注释；不要用于公开脱敏 |
| `html` | 可直接保存打开的静态预览，转义用户文本；无外部脚本资源 |
| `scenes` / `cast` | 人读场次表 / JSON 角色统计 |
| `cues FILE CHARACTER` | 指定精确角色的排练单；未知角色报错 |
| `lint` | 稳定诊断码和行号；不自动改写剧本 |

退出码：0 正常；`lint` 有诊断为 1；参数、I/O、非法 UTF-8 或资源拒绝为 2。
其他内容导出模式不会因一般诊断自动失败：严格流水线请先运行 `lint`。

## MoonBit API

项目内部包可导入 `"2200732518gjy/moonfountain" @fountain`，参见
[可运行示例](examples/rehearsal/main.mbt) 与其 `moon.pkg`。

```moonbit
let doc = @fountain.parse("INT. BOOTH - NIGHT\n\nADA\nReady?\n")
let scenes = @fountain.scenes(doc)
let people = @fountain.cast(doc)
let cues = @fountain.cue_sheet(doc, "ADA")
let safe_report = @fountain.report_json(doc)
let original_scene = @fountain.extract_scene(doc, 1)
```

更多入口与字段见 [生成接口](pkg.generated.mbti)、[API 与数据约定](docs/API.md)
和 [JSON v1](docs/JSON.md)。`parse` 保留解析诊断；`lint` 返回解析+语义诊断，
必须检查 `FNT900`，不可把被拒绝的空结构当作空剧本。

## 验证

```sh
python scripts/verify.py
# Windows 缺少 C 编译器时，仅明确延期 native 执行：
python scripts/verify.py --native-check-only
```

本地验证：46 项单元测试分别在 wasm-gc / wasm / JS 通过，25 个真实 CLI 用例通过；
四目标严格检查通过。native 未在 Windows 本机执行，但已在 Ubuntu CI 中完成构建、
46 项测试与示例运行。首个通过的 [四目标 CI 运行](https://github.com/2200732518gjy/moonfountain/actions/runs/34613640264)
对应提交 `5ef0b00`；后续运行可在仓库 Actions 页面核对。
[CI 合约](docs/CI.md) 说明命令、工具链、校验和与不可混淆的证据边界。

## 支持边界与安全

这不是 Fountain 1.1 全量兼容声明。强制语法 `@林` 可表达非拉丁角色；自动角色识别
要求 ASCII 大写字母。连续空白、双对白配对、注释恢复、强调深度均有明确边界，详见
[支持矩阵及诊断](docs/SUPPORT.md)。不做精确分页、FDX/PDF、SRT/VTT、实时编辑、
角色别名推断、中文分词、时长估算、权限管理或 AI 写作。

输入硬上限：262144 个 UTF-16 单元、20000 行、单行 8192 单元；CLI 先限制 4 MiB
UTF-8 字节。预算可收紧不可提高。原文抽取、未闭合注释和标题联系信息可能含隐私，
输出公开前必须人工复核；这不是 PII 清洗器，见 [安全说明](SECURITY.md)。

## 工程与来源

[设计](docs/ARCHITECTURE.md) · [查重证据](docs/competition/duplicate-check.md) ·
[贡献指南](CONTRIBUTING.md) · [更新记录](CHANGELOG.md) ·
[第三方说明](THIRD_PARTY.md) · [AI 使用披露](AI_USAGE.md) · [MIT](LICENSE)

查重使用 MoonCakes 关键词 API 和相邻 GitHub 项目，没有在已检查范围内发现直接
重合的成熟实现；API 结果上限及索引覆盖有限，不能证明绝对不存在。检索不等于发布。
参赛者个人申报材料不存入仓库。MoonCakes 发布是参与者另行操作的验收步骤。
