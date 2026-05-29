;;; modules/app.el --- App  (:app)  -*- lexical-binding: t; -*-
;;; Commentary:
;; Doom category :app.  Migrated from nothung.org (App).
;;; Code:


;;;; eww
;; Emacsのテキストブラウザ([[https://www.gnu.org/software/emacs/manual/html_mono/eww.html][Manual]])
;; notes:
;; - ewwを起動しただけだとminibufferなのでC-gで消えてしまうので大きくC-x 1とかで大きくする.
;; - C-u M-x ewwでひとつのbufferを使いまわすのではなく別のBufferでewwを開く.
;; - M-RETでURLを新しいBufferで開く.
;; - Doom EmacsだとC-c s o(online)でいろいろと検索できる(w/Chrome). helm-google-suggest的な.
(use-package! eww
  :bind
  ("C-c s w" . eww-search-words)
  ("C-c o w" . eww-open-in-new-buffer))
;; - ace-linkをつかうとewwのlinkをインタラクティブに選択できて便利.
(use-package! ace-link
  :config
  (eval-after-load 'eww '(define-key eww-mode-map "f" 'ace-link-eww))
  (ace-link-setup-default)
  (define-key org-mode-map (kbd "M-o") 'ace-link-org))

;;;; Pocket
;; あとで読むサービス.

;;;; RSS(Elfeed)

;;;; Habitica

;;;; Twitter
;; もうメンテされてない. 

;;;; Tidalcycles
;; 音楽
;; https://tidalcycles.org/docs/getting-started/editor/Emacs

(provide 'nothung-app)
;;; modules/app.el ends here
