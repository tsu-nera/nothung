# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概要

"Nothung" — Doom Emacs設定リポジトリ(`~/.doom.d`)。メインの設定はliterate org-modeファイル(`nothung.org`)に記述され、`org-babel-load-file`経由で`nothung.el`にタングルされる。

## アーキテクチャ

- **config.el** — Doomが読み込むエントリポイント。`private/config.el`、`utils.el`を読み込み、`nothung.org`をタングル&ロード
- **nothung.org** — Literate config（設定の本体）。org-babelで`nothung.el`に出力される。編集はこのファイルに対して行う
- **nothung.el** — `nothung.org`から自動生成。手動で編集しないこと
- **init.el** — Doomモジュール宣言（`doom!`ブロック）
- **packages.el** — パッケージ宣言（`doom sync`用）
- **utils.el** — ユーティリティ関数（WSL判定、ブラウザ連携、パスコピー）
- **private/config.el** — APIキー等の秘密情報（コミットしないこと）
- **custom.el** — Emacs customizeの出力先

## コマンド

設定変更後:
```
doom sync    # packages.elやinit.el変更後にパッケージ同期
doom build   # 大きな変更後にリビルド
```

## 編集ワークフロー

設定を変更する場合は`nothung.org`（literate source）を編集する。`nothung.el`は直接編集しない。タングル出力はEmacs起動時に再生成される。orgファイルの構成は`init.el`のDoomモジュールカテゴリに対応している。

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

MCP（claude-code-ide.el）はLSP診断・シンボル検索などの構造化データに向いており、emacsclientは任意のElisp評価が必要な場面（変数の状態、パッケージの挙動確認など）に使う。

