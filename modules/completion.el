;;; modules/completion.el --- Completion  (:completion)  -*- lexical-binding: t; -*-
;;; Commentary:
;; Doom category :completion.  Migrated from nothung.org (Completion).
;;; Code:


;;;; company-mode
;; Completion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-roam の completion-at-point が動作しないのはこいつかな...
;; (add-hook! 'org-mode-hook (company-mode -1))
;; company はなにげに使いそうだからな，TAB でのみ補完発動させるか.
(setq company-idle-delay nil)
(global-set-key (kbd "TAB") #'company-indent-or-complete-common)

;;;; avy/swiper
;; 検索強化. 
(use-package! avy
  :bind
  ("C-x ," . avy-goto-char) ;; doom の keybind 上書き.
  ("C-c g l" . avy-goto-line) ;; doom の keybind 上書き.
  ("C-c s c". avy-goto-word-1))
(global-set-key (kbd "C-c g L") 'consult-goto-line)

;; うまく動かないので封印 doom との相性が悪いのかも.
;; ひとまず migemo したいときは isearch で対応.
;; (use-package! avy-migemo
;;  :after migemo
;;  :bind
;;  ("M-g m m" . avy-migemo-mode)
;;  ("M-g c" . avy-migemo-goto-char-timer) ;; doom の keybind 上書き.
;;  :config
;;  (avy-migemo-mode 1)
;;  (setq avy-timeout-seconds nil))

;; Vertico使用のためswiperとivyは無効化
;; (use-package! swiper
;;   :config
;;   (ivy-mode 1))


  
;; avy-migemo-e.g.swiper だけバクる
;; https://github.com/abo-abo/swiper/issues/2249
;;(after! avy-migemo
;;  (require 'avy-migemo-e.g.swiper))

;;;; affe
;; fuzzy find. あいまい検索 for consult.
;; https://github.com/minad/affe
(use-package! affe
  :after consult
  :config
  (defun affe-orderless-regexp-compiler (input _type)
    (setq input (orderless-pattern-compiler input))
    (cons input (lambda (str) (orderless--highlight input str))))
  (setq affe-regexp-compiler #'affe-orderless-regexp-compiler))

;;;; all-the-icons-completion
;; https://github.com/iyefrat/all-the-icons-completion

;;;; Copilot.el
;; https://github.com/copilot-emacs/copilot.el
;; Strongly recommend to enable childframe option in company module ((company +childframe)) to prevent overlay conflict.

(provide 'nothung-completion)
;;; modules/completion.el ends here
