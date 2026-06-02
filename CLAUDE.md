# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概要

"Nothung" — Doom Emacs設定リポジトリ(`~/.doom.d`)。設定は Doom のカテゴリ単位に
分割した素の Elisp(`modules/*.el`)で管理し、`config.el` がローダーとして順に
読み込む。

> 旧運用(〜2026-05)は literate org-mode(`nothung.org`)→ `org-babel-load-file`
> で `nothung.el` にタングルする方式だった。AIエージェント主導の編集に合わせて
> モジュール分割 Elisp へ移行済み。旧ファイルは `archive/` を参照。

## アーキテクチャ

- **config.el** — Doomが読み込むエントリポイント兼ローダー。Windows固有の初期化
  (native-comp調整、migemo無害化、tr-ime)を行い、`private/config.el`・`utils.el`・
  `modules/` 配下のカテゴリ別設定を順に `load` する
- **modules/*.el** — 設定の本体。Doomカテゴリ単位に分割(下記)。**ここを編集する**
- **init.el** — Doomモジュール宣言(`doom!`ブロック)
- **packages.el** — パッケージ宣言(`doom sync`用)
- **utils.el** — ユーティリティ関数(WSL判定、ブラウザ連携、パスコピー)
- **private/config.el** — APIキー等の秘密情報(コミットしないこと)
- **custom.el** — Emacs customizeの出力先
- **archive/** — 旧 `nothung.org` / `nothung.el`。読み込まれない(`archive/README.md`参照)

### modules/ 構成(Doomカテゴリ準拠)

`config.el` の `nothung-modules` がロード順を定義する(旧orgのタングル順を踏襲)。
ファイル名が org/emacs 等の組み込み feature 名と衝突するため、ローダーは require
ではなくパス直指定で `load` する(各ファイルの `provide` は `nothung-<cat>`)。

| ファイル | Doomカテゴリ | 内容 |
|---|---|---|
| `app.el` | `:app` | eww・ace-link 等 |
| `checkers.el` | `:checkers` | flycheck |
| `completion.el` | `:completion` | company・avy・affe 等 |
| `config.el` | `:config` | default(基本設定・キーバインド・auto-revert 等) |
| `editor.el` | `:editor` | 改行・折り返し・whitespace・iedit 等 |
| `emacs.el` | `:emacs` | recentf・GC・ace-window・undo 等 |
| `email.el` | `:email` | メール関連 |
| `input.el` | `:input` | fcitx・artist mode 等 |
| `lang.el` | `:lang` | clojure・rust・rest・mermaid 等 |
| `os.el` | `:os` | EXWM |
| `org.el` | `:lang org` | org-mode・org-roam・capture・export 等(最大) |
| `term.el` | `:term` | eshell・vterm 等 |
| `tools.el` | `:tools` | magit/forge・lsp・lookup 等 |
| `ui.el` | `:ui` | テーマ・modeline・フォント・表示まわり |
| `ai.el` | custom | AI連携(gptel・copilot・claude-code-ide 等) |

各ファイルは先頭に `;;; Commentary:`、本体に旧orgの見出しを `;;;;` 形式の
コメントヘッダ、解説文を `;;` コメントとして保持している。

## コマンド

設定変更後:
```
doom sync    # packages.elやinit.el変更後にパッケージ同期
doom build   # 大きな変更後にリビルド
```

## 編集ワークフロー

設定を変更する場合は `modules/` 配下の該当カテゴリの `.el` を直接編集する。
タングル工程は無い(編集対象がそのまま実行される)。新しいカテゴリのファイルを
追加したら `config.el` の `nothung-modules` にも追加すること。

`archive/nothung.org` には旧運用で無効化していた設定・実験メモ(`:tangle no`
ブロック)が残っている。再利用する場合はそこから該当 `modules/` へ移植する。

## Emacsの状態調査

`emacsclient` を使って起動中のEmacsに任意のElispを評価させ、内部状態を調査できる。

```bash
# 接続確認
emacsclient -e "(version)"

# パッケージのロード確認
emacsclient -e "(featurep 'forge)"

# 変数の値確認
emacsclient -e "(symbol-value 'some-variable)"

# auth-sourceの認証情報確認
emacsclient -e "(auth-source-search :host \"api.github.com\")"
```

設定の構文・括弧バランス確認(バッチ):
```bash
emacs --batch --eval "(with-temp-buffer (insert-file-contents \"modules/org.el\") (check-parens))"
```

### 設定変更の即時反映

`modules/*.el` を編集したあと、起動中のEmacsへ再起動なしで反映できる。変更内容で方法を使い分ける:

- **setq 等の冪等な変更** — ファイルごと再読込する。式を打ち直さずに済むのでエスケープ不要:
  ```bash
  emacsclient -e '(load "/home/tsu-nera/.doom.d/modules/org.el")'
  ```
- **`run-with-idle-timer`・`use-package!`・`add-hook` 等の副作用を含む変更** — 全loadはタイマー/フックの二重登録を招くため避け、変更した該当フォームだけを `emacsclient -e` で eval する。

MCP（claude-code-ide.el）はLSP診断・シンボル検索などの構造化データに向いており、emacsclientは任意のElisp評価が必要な場面（変数の状態、パッケージの挙動確認など）に使う。
