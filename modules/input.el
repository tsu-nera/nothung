;;; modules/input.el --- Input  (:input)  -*- lexical-binding: t; -*-
;;; Commentary:
;; Doom category :input.  Migrated from nothung.org (Input).
;;; Code:

;; Input
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(set-default 'buffer-filecoding-system 'utf-8)

;; pgtk Wayland のクリップボード読み取り対策。
;; pgtk Emacs は自分が gui-set-selection で CLIPBOARD を「所有」すると、
;; コンポジタに問い合わせず内部キャッシュを返すため、他アプリ(Chrome 等)で
;; コピーした内容が yank できなくなる。さらに WSLg では STRING target が
;; CP932 のまま返り化ける。いずれも wl-paste 経由 (text/plain;charset=utf-8)
;; で読めば回避できる。daemon 起動時は window-system が nil なので、
;; WSL 判定または WAYLAND_DISPLAY の有無で判定する。
(when (and (or (wsl-p) (getenv "WAYLAND_DISPLAY"))
           (executable-find "wl-paste"))
  ;; shell-file-name が fish 等だと ";" のエスケープが壊れるため、
  ;; shell を介さず call-process で直接 wl-paste を呼ぶ。
  (defun my/wl-clipboard-paste ()
    (with-temp-buffer
      (when (zerop (call-process "wl-paste" nil t nil
                                 "-n" "-t" "text/plain;charset=utf-8"))
        (let ((s (buffer-string)))
          (unless (string-empty-p s) s)))))
  (setq interprogram-paste-function #'my/wl-clipboard-paste))

;; Emacs → 外部アプリのコピー。pgtk Wayland では Emacs 自身の
;; クリップボード書き込みがコンポジタに届かないことがある(WSLg ブリッジ・
;; niri 等の素の Wayland 双方で確認)。wl-copy で明示的に書き込む。
;; daemon 起動時は window-system が nil なので、WSL 判定または
;; WAYLAND_DISPLAY の有無で判定する。
(when (and (or (wsl-p) (getenv "WAYLAND_DISPLAY"))
           (executable-find "wl-copy"))
  (defun my/wl-clipboard-copy (text)
    (let ((process-connection-type nil))
      (with-temp-buffer
        (insert text)
        (call-process-region (point-min) (point-max) "wl-copy"))))
  (setq interprogram-cut-function #'my/wl-clipboard-copy))

;; migemo: ローマ字入力で日本語を漸進検索する。外部プログラム cmigemo と辞書が必要。
;; cmigemo 未インストールの環境(新規マシン等)で migemo-init を呼ぶと
;; "Searching for program cmigemo" で load が中断するため、cmigemo が存在する
;; 場合のみ有効化する(Windows は config.el で migemo-init を override 無害化)。
;; 辞書パスはディストリにより異なるため、実在するものを採用する。
(use-package! migemo
  :when (executable-find "cmigemo")
  :config
  (setq migemo-command "cmigemo")
  (setq migemo-options '("-q" "--emacs" "-i" "\a"))
  (setq migemo-dictionary
        (cl-find-if #'file-exists-p
                    '("/usr/share/migemo/utf-8/migemo-dict"
                      "/usr/share/cmigemo/utf-8/migemo-dict"
                      "/usr/local/share/migemo/utf-8/migemo-dict")))
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (when migemo-dictionary (migemo-init)))

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
