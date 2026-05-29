;;; modules/term.el --- Term  (:term)  -*- lexical-binding: t; -*-
;;; Commentary:
;; Doom category :term.  Migrated from nothung.org (Term).
;;; Code:

;; Term
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 (after! vterm                                                                               (add-hook 'vterm-mode-hook #'hl-line-mode))

(provide 'nothung-term)
;;; modules/term.el ends here
