;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; doom specific config
;; あとでプライベートな宣言方法うしらべる.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")
(setq doom-font (font-spec :family "Source Han Code JP" :size 12))
(setq doom-theme 'doom-monokai-pro)
(setq doom-monokai-pro-brighter-comments t)
(doom-themes-org-config)

;; general config
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(set-default 'buffer-filec-oding-system 'utf-8)
(setq display-line-numbers-type t)

;; migemo
(require 'migemo)
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs" "-i" "\a"))
(setq migemo-dictionary "/usr/share/migemo/utf-8/migemo-dict")
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(migemo-init)

;; org-mode
;; https://github.com/hlissner/doom-emacs/blob/develop/modules/lang/org/README.org
;; https://github.com/tsu-nera/dotfiles/blob/master/.emacs.d/inits/50_org-mode.org
(setq org-directory "~/repo/gtd/")
(setq org-default-notes-file "main.org")

(setq org-return-follows-link t) ;; Enterでリンク先へジャンプ
(setq org-use-speed-commands t)  ;; bulletにカーソルがあると高速移動
(setq org-hide-emphasis-markers t)

(setq org-insert-heading-respect-content nil)

(setq org-startup-indented t)
(setq org-indent-mode-turns-on-hiding-stars nil)

(setq org-startup-folded 'show2levels);; 見出しの階層指定
(setq org-startup-truncated nil) ;; 長い文は折り返す.

;; org-babelのソースをキレイに表示.
(setq org-src-fontify-natively t)
(setq org-fontify-whole-heading-line t)

;; org-agenda
(setq org-agenda-files '("~/repo/gtd/"))
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
(setq org-log-done 'time) ;; 変更時の終了時刻記録.


;; org-journal
;;   (org-journal-dir “~/Dropbox/Org/journal”)
;;
(setq org-journal-date-format "%x")
(setq org-journal-time-format "<%Y-%m-%d %R> ")
(setq org-journal-file-format "%Y-%m-%d.org")
(setq org-journal-dir "~/repo/gtd/reports/daily")
(defun org-journal-find-location ()
  (org-journal-new-entry t)
  (goto-char (point-min)))

;; org-capture
(setq org-capture-templates
      '(("i" "Inbox" entry (file+datetree "~/repo/gtd/inbox.org") "** TODO %?\n")
        ("r" "Random" entry (file+headline "~/repo/gtd/random.org" "Random")
         "* %?\nEntered on %U\n %i\n %a")
        ("d" "Daily Log" entry (function org-journal-find-location)
                               "* %(format-time-string org-journal-time-format)%i%?")
        ))

;; org-babel
;; 評価でいちいち質問されないように.
(setq org-confirm-babel-evaluate nil)


;; org-roam
(setq org-roam-directory (file-truename "~/repo/gtd/notes"))
(org-roam-db-autosync-mode)

(use-package! fcitx
  :config
  (setq fcitx-remote-command "fcitx5-remote")
  (fcitx-aggressive-setup)
  ;; Linuxなら t が推奨されるものの、fcitx5には未対応なためここはnil
  (setq fcitx-use-dbus nil))
