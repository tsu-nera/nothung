' Doom Emacs ランチャー (GUI直接起動・コンソール窓なし)
'
' 旧方式 (daemon + emacsclient) は廃止した。旧 .vbs は start-doom-emacs.vbs.daemon.bak 参照。
' 理由: デーモン起動 → 最大120秒接続待ち → emacsclientw でフレーム を開く設計だったが、
'   起動時処理 (org-roam の全ノート同期で数分 / かつ atomic-chrome のポート衝突ハング) で
'   デーモンが server-start に到達するのが120秒を超え、emacsclient が接続できずフレームが
'   開かなかった。GUIフレームを直接起動すればタイムアウトの仕組みが無く確実に立ち上がる。
'
' 注意: この方式はクリック毎に新しい Emacs プロセスを起動する (デーモン共有ではない)。
'   多重起動を避けたい場合は1回だけクリックすること。
Option Explicit
Dim sh, env, re, idir
Set sh = CreateObject("WScript.Shell")
Set env = sh.Environment("PROCESS")
env("HOME") = "C:\Users\fox10"
env("PATH") = "C:\msys64\ucrt64\bin;C:\msys64\usr\bin;" & env("PATH")

' runemacs.exe はコンソール窓を出さずに GUI フレームを起動する専用ランチャー
re   = """C:\msys64\ucrt64\bin\runemacs.exe"""
idir = "--init-directory=C:/Users/fox10/.config/emacs"

' 通常ウィンドウで起動 (no-wait)
sh.Run re & " " & idir, 1, False
