;;; config.el --- Doom 設定エントリポイント兼ローダー -*- lexical-binding: t; -*-

;; 設定本体は modules/ 配下のカテゴリ別 Elisp に分割管理している。
;; (旧運用: nothung.org -> nothung.el への org-babel タングル。AIエージェント
;;  主導の編集に合わせ、素の Elisp モジュール + ローダー方式へ移行した。
;;  旧ファイルは archive/ を参照)

;; Windows専用: native-compの並列数をモジュールロード前に絞る(16コア機でCPU飽和・ファン暴走回避)
(when (eq system-type 'windows-nt)
  (setq native-comp-async-jobs-number 4
        native-comp-async-report-warnings-errors 'silent)
  ;; cmigemoが無いWindowsでは(migemo-init)が失敗しモジュールのロードが中断するため無害化
  ;; (migemo-init はautoloadなので with-eval-after-load では間に合わず、直接 advice する)
  (advice-add 'migemo-init :override #'ignore))

(defconst nothung-modules
  '("app" "checkers" "completion" "config" "editor" "emacs" "email"
    "input" "lang" "os" "org" "term" "tools" "ui" "ai")
  "ロードする modules/ 配下のカテゴリ別設定(ロード順、拡張子なし)。
順序は旧 nothung.org のタングル順を踏襲(load順依存の挙動差を避けるため)。")

(defun nothung-load-config ()
  "秘密情報・ユーティリティ・カテゴリ別設定を順に読み込む。
ファイル名が org/emacs 等の組み込み feature 名と衝突するため、modules は
require ではなくパス直指定で load する。"
  ;; 秘密情報と自作関数(旧 nothung.org 冒頭ブロック相当)
  ;; private/config.el は API キー等のマシン固有秘密情報(gitignore 済み)。
  ;; 新規マシンでは存在しないため、有無を確認してから読み込む(無くても起動可能)。
  (let ((private-config (expand-file-name "private/config.el" doom-user-dir)))
    (when (file-exists-p private-config)
      (load-file private-config)))
  (load-file (expand-file-name "utils.el" doom-user-dir))
  ;; カテゴリ別設定
  (dolist (m nothung-modules)
    (load (expand-file-name (format "modules/%s" m) doom-user-dir)
          nil 'nomessage)))

(if (not (eq system-type 'windows-nt))
    (nothung-load-config)
  ;; Windowsでは残りのロードエラーを自動記録(handler-bindでアンワインド前にbacktrace捕捉)
  (condition-case e
      (handler-bind ((error (lambda (_)
                              (ignore-errors
                                (write-region (with-output-to-string (backtrace))
                                              nil (expand-file-name "~/nothung-bt.log") nil 'silent)))))
        (nothung-load-config))
    (error (write-region (format "NOTHUNG LOAD ABORTED: %S\n" e)
                         nil (expand-file-name "~/nothung-load-errors.log") nil 'silent))))

;; Windows専用: tr-imeでGoogle日本語入力の未確定文字列・変換候補をカーソル位置(over-the-spot)に表示
;;
;; 注意: tr-ime はW32メッセージポンプにフックするため、GUIフレームが無い状態
;; (ヘッドレスな emacs --daemon の初期化中など)で実行するとハングする。本設定は
;; runemacs での通常GUI起動を前提とするが、念のため display-graphic-p でガードする。
(when (and (eq system-type 'windows-nt) (display-graphic-p))
  (tr-ime-advanced-install 'no-confirm)
  (setq default-input-method "W32-IME")
  (w32-ime-initialize)
  (modify-all-frames-parameters '((ime-font . "HackGen-12"))))
