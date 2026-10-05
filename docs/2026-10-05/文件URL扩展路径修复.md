# 文件 URL 扩展路径修复

## Intent：最终目标

修复 Windows 扩展本地盘符路径转换时被误当成 UNC 主机的问题。

## Data：可用证据

独立测试会话反馈正式 file URL 语料的 local extended path 失败。生产 from_path 在检查两个前导反斜杠时直接进入 UNC 分支，将扩展前缀中的问号送入 host 解析。Node v26.10.0 官方 test/parallel/test-url-pathtofileurl.js 第 170 行列出该路径形式。

## Edges：边界与限制

仅在扩展前缀后确实为绝对盘符根时剥离扩展前缀；复用 path.syntax.root 判定，不匹配特定盘符或文件名。扩展 UNC 继续使用其既有 server/share 分支。平台、cwd 和编码规则不变。

## Answer：交付与验证

from_path 在 UNC 分类前识别本地扩展盘符路径，并交给既有 resolve 与编码流程。局部编译通过；[四次路径观测](完整URL/扩展本地路径观测.json)分别覆盖两个不同盘符的扩展本地路径、扩展 UNC 和普通 UNC，输出与 Node 一致。没有运行全量测试，正式语料和分配失败复验由原测试会话继续。

自我批判：此前只覆盖扩展 UNC，未覆盖同样以双反斜杠开头的扩展本地路径，说明仅按表面前缀分类不充分。本次依据前缀后的根结构修复，不将四次观测视为所有 Windows 路径形式的证明。
