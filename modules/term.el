;;; modules/term.el --- Term  (:term)  -*- lexical-binding: t; -*-
;;; Commentary:
;; Doom category :term.  Migrated from nothung.org (Term).
;;; Code:

;; Term
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; vterm のシェルはログインシェルの fish に固定する。vterm-shell の既定は環境変数
;; $SHELL を見るため、daemon を起動した環境(端末・サービス)によっては zsh 等に化ける。
;; 環境非依存にするためここで明示する。
(setq vterm-shell "/bin/fish")

(after! vterm
  (add-hook 'vterm-mode-hook #'hl-line-mode))

(provide 'nothung-term)
;;; modules/term.el ends here
