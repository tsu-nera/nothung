;;; modules/config.el --- Config  (:config)  -*- lexical-binding: t; -*-
;;; Commentary:
;; Doom category :config.  Migrated from nothung.org (Config).
;;; Code:

;; Config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; doom specific config
;; (setq user-full-name "John Doe"
;;      user-mail-address "john@doe.com")
(setq confirm-kill-emacs nil) ; 終了時の確認はしない.

;; フルスクリーンで Emacs 起動
;; ブラウザと並べて表示することが多くなったのでいったんマスク
;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; This is to use pdf-tools instead of doc-viewer
;; Windowsはepdfinfoがビルド不可(poppler等が無い)で起動が固まるため除外。pdfモジュールもinit.elでWindows除外済み。
(unless (eq system-type 'windows-nt)
  (use-package! pdf-tools
    :config
    (pdf-tools-install)
    ;; This means that pdfs are fitted to width by default when you open them
    (setq-default pdf-view-display-size 'fit-width)
    :custom
    (pdf-annot-activate-created-annotations t "automatically annotate highlights")))

;; projectileの検索スピードを上げる
(setq projectile-indexing-method 'alien)

;; グローバルに有効化
(global-auto-revert-mode 1)
;; WSL2ではinotifyが効かないためポーリングを使う
(setq auto-revert-use-notify nil)
(setq auto-revert-interval 1)

;; custom-fileの設定
(setq custom-file (expand-file-name "custom.el" doom-user-dir))
(when (file-exists-p custom-file)
  (load custom-file))

(provide 'nothung-config)
;;; modules/config.el ends here
