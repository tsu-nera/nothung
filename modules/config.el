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
