;;; modules/input.el --- Input  (:input)  -*- lexical-binding: t; -*-
;;; Commentary:
;; Doom category :input.  Migrated from nothung.org (Input).
;;; Code:

;; Input
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(set-default 'buffer-filecoding-system 'utf-8)

;; pgtk Emacs + WSLg のクリップボード文字化け対策
;; GTK 経由だと STRING target が CP932 のまま返り化けるため、
;; wl-paste 経由で text/plain;charset=utf-8 を取得する
;; daemon 起動時は window-system が nil なので wsl-p で判定する
(when (and (wsl-p) (executable-find "wl-paste"))
  (defun my/wsl-clipboard-paste ()
    (let ((s (shell-command-to-string
              "wl-paste -n -t text/plain\\;charset=utf-8 2>/dev/null")))
      (unless (string-empty-p s) s)))
  (setq interprogram-paste-function #'my/wsl-clipboard-paste))

;; Emacs → Windows コピー用。pgtk Wayland のクリップボード書き込みが
;; WSLg ブリッジに届かないケースがあるため、wl-copy で明示的に書き込む
(when (and (wsl-p) (executable-find "wl-copy"))
  (defun my/wsl-clipboard-copy (text)
    (let ((process-connection-type nil))
      (with-temp-buffer
        (insert text)
        (call-process-region (point-min) (point-max) "wl-copy"))))
  (setq interprogram-cut-function #'my/wsl-clipboard-copy))

;; migemo
(use-package! migemo
  :config
  (setq migemo-command "cmigemo")
  (setq migemo-options '("-q" "--emacs" "-i" "\a"))
  (setq migemo-dictionary "/usr/share/migemo/utf-8/migemo-dict")
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (migemo-init))

;;;; fcitx
;; aggressive-setupでのminibuffer でのfcitx自動disableはよい. 相性が悪いのか, しばしば日本語入力とminibufferでEmacsがハングするので. 
;; fcitxはLinuxの入力メソッド連携。WindowsはGoogle日本語入力+tr-imeを使うため除外。
(unless (eq system-type 'windows-nt)
  (use-package! fcitx
    :config
    (setq fcitx-remote-command "fcitx5-remote")
    ;; aggressive-setup は post-self-insert-hook 内で fcitx5-remote を毎回呼ぶため
    ;; X11 Emacs + WSLg で打鍵がもたつく。default-setup に変更
    (fcitx-default-setup)
    ;; Linux なら t が推奨されるものの、fcitx5 には未対応なためここは nil
    (setq fcitx-use-dbus nil)))

;;;; artist mode
;; [[https://www.emacswiki.org/emacs/ArtistMode][EmacsWiki: Artist Mode]]
;; Emacs上でカーソルやマウスを使って線が書ける.
;; - M-x artist-modeで起動. 
;; - C-c C-c で終了.
;; - defaultでは *.* を描写, Shiftで *-* になる.
;; 昔なんちゃってelispを書いたけど, なんだdefaultであったのか.
;; ref: [[https://futurismo.biz/archives/1972/][秀丸のような罫線マクロないかなと思ってelisp作成した | Futurismo]]

(provide 'nothung-input)
;;; modules/input.el ends here
