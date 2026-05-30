# archive/

旧運用のファイル置き場。**現在の設定では読み込まれない。**

- `nothung.org` — 旧 literate config(設定本体)。`org-babel-load-file` で
  `nothung.el` にタングルしてロードしていた。
- `nothung.el` — `nothung.org` からの自動生成物。

## 移行について

AIエージェント主導の編集に合わせ、設定は `modules/` 配下のカテゴリ別 Elisp に
分割した(ローダーは `config.el`)。`:tangle yes` だった有効設定はすべて
`modules/` に移植済み(移植時に旧 `nothung.el` とコード行が完全一致することを
検証済み: 1304行)。

`nothung.org` を残しているのは、`:tangle no` だった**無効化済みの設定・実験
メモ**(29ブロック)を失わないため。再利用したい設定があればここから
`modules/` の該当カテゴリへ移すこと。
