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

;; org-mode
(setq org-directory "~/repo/gtd/")

(setq org-return-follows-link t)
(setq org-use-speed-commands t)
(setq org-hide-emphasis-markers t)
(setq org-insert-heading-respect-content nil)

(setq org-startup-indented t)
(setq org-indent-mode-turns-on-hiding-stars nil)

(setq org-startup-folded 'show2levels)
