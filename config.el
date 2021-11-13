;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; doom specific config
;; あとでプライベートな宣言方法うしらべる.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")
(setq doom-font (font-spec :family "Source Han Code JP" :size 12))
(setq doom-theme 'doom-one)
(doom-themes-org-config)

;; general config
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(set-default 'buffer-filecoding-system 'utf-8)

;; 行番号表示
(setq display-line-numbers-type t)
;; フルスクリーンでEmacs起動
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; memo:
;; use-package! は:defer, :hook, :commands, or :afterが省略されると起動時にloadされる.
;; after! はpackageがloadされたときに評価される.
;; add-hook! はmode有効化のとき. setq-hook!はequivalent.
;; どれを使うかの正解はないがすべてuse-package!だと起動が遅くなるので
;; 場合によってカスタマイズせよ，とのこと.
;; https://github.com/hlissner/doom-emacs/blob/develop/docs/getting_started.org#configuring-packages

(use-package! fcitx
  :config
  (setq fcitx-remote-command "fcitx5-remote")
  (fcitx-aggressive-setup)
  ;; Linuxなら t が推奨されるものの、fcitx5には未対応なためここはnil
  (setq fcitx-use-dbus nil))

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

;; lessでのファイル閲覧に操作性を似せるmode.
;; view-modeはemacs内蔵. C-x C-rでread-only-modeでファイルオープン
;; doom emacsだと　C-c t r で　read-only-modeが起動する.
(add-hook! view-mode
  (setq view-read-only t)
  (define-key ctl-x-map "\C-q" 'view-mode) ;; assinged C-x C-q.

  ;; less っぼく.
  (define-key view-mode-map (kbd "p") 'View-scroll-line-backward)
  (define-key view-mode-map (kbd "n") 'View-scroll-line-forward)
  ;; defaultのeでもいいけど，mule時代にvにbindされてたので, emacsでもvにbindしておく.
  (define-key view-mode-map (kbd "v") 'read-only-mode))

;; org-mode
;; https://github.com/hlissner/doom-emacs/blob/develop/modules/lang/org/README.org
;; https://github.com/tsu-nera/dotfiles/blob/master/.emacs.d/inits/50_org-mode.org

;; スマホとの共有のため, githubをcloneしたものをDropboxに置いて$HOMEにsymlinkしている.
(setq org-directory "~/gtd")
(setq org-default-notes-file "main.org")

(setq org-return-follows-link t) ;; Enterでリンク先へジャンプ
(setq org-use-speed-commands t)  ;; bulletにカーソルがあると高速移動
(setq org-hide-emphasis-markers t)

;; M-RETの挙動の調整
;; tだとsubtreeの最終行にheadingを挿入
;; nilだとcurrent pointに挿入
;; なお，C-RETだとsubtreeの最終行に挿入される模様.
(setq org-insert-heading-respect-content nil)

(setq org-startup-indented t)
(setq org-indent-mode-turns-on-hiding-stars nil)

(setq org-startup-folded 'show2levels);; 見出しの階層指定
(setq org-startup-truncated nil) ;; 長い文は折り返す.

;; org-babelのソースをキレイに表示.
(setq org-src-fontify-natively t)
(setq org-fontify-whole-heading-line t)

;; org-agenda
(setq org-agenda-files '("~/gtd"))
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
(setq org-log-done 'time) ;; 変更時の終了時刻記録.


;; org-journal
;;   (org-journal-dir “~/Dropbox/Org/journal”)
;;
(setq org-journal-date-format "%x")
(setq org-journal-time-format "<%Y-%m-%d %R> ")
(setq org-journal-file-format "%Y-%m-%d.org")
(setq org-journal-dir "~/gtd/reports/daily")
(defun org-journal-find-location ()
  (org-journal-new-entry t)
  (goto-char (point-min)))

;; org-capture
(setq org-capture-templates
      '(("i" "Inbox" entry (file+datetree "~/gtd/inbox.org") "** TODO %?\n")
        ("j" "Journal" entry (file+headline "~/gtd/journal.org" "Random")
         "* %?\nEntered on %U\n %i\n %a")
        ("d" "Daily Log" entry (function org-journal-find-location)
                               "* %(format-time-string org-journal-time-format)%i%?")
        ))

;; org-babel
;; 評価でいちいち質問されないように.
(setq org-confirm-babel-evaluate nil)

;; org-roam
;; そもそもgtdとroamを同じリポジトリで管理するかどうかは疑問なのであとで見極める.
(setq org-roam-directory (file-truename "~/gtd/notes"))
(org-roam-db-autosync-mode)

(require 'org-bars)
(add-hook! 'org-mode-hook #'org-bars-mode)

;; twittering-mode
;; この設定がないと認証が失敗した.
;; twittering-oauth-get-access-token: Failed to retrieve a request token
(add-hook! 'twittering-mode-hook
  (setq twittering-allow-insecure-server-cert t))

(add-hook! writeroom-mode
  (setq +zen-text-scale 1))

;; 読書のためのマーカー（仮）
;; あとでちゃんと検討と朝鮮しよう.
(setq org-emphasis-alist
  '(("*" bold)
    ("/" italic)
    ("_" underline)
    ("=" (:background "red" :foreground "white")) ;; 書き手の主張
    ("~" (:background "blue" :foreground "white"))　;; 根拠
    ("+" (:background "green" :foreground "black")))) ;; 自分の考え
