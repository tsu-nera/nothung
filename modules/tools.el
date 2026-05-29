;;; modules/tools.el --- Tools  (:tools)  -*- lexical-binding: t; -*-
;;; Commentary:
;; Doom category :tools.  Migrated from nothung.org (Tools).
;;; Code:

;; Tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; forge
;; magit拡張, EmacsとGitHubを連携.
;; doom emacsだと [[https://github.com/hlissner/doom-emacs/blob/develop/modules/tools/magit/README.org][(magit +forge)]] のオプションでインストールできる.
;; ref: [[https://magit.vc/manual/forge/][Forge User and Developer Manual]]
(after! magit
  (setq auth-sources '("~/.authinfo"))
  (setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))
  ;; (setq magit-diff-refine-hunk 'all)
)
;; リポジトリ名を変更した場合はissueやPRの作成が失敗する.
;; これは .git/configの問題なのでローカルのファイルを修正する.

;;;; git-link
;; 現在のバッファの位置のGitHubのurlを取得.
;; [[https://github.com/sshaw/git-link][sshaw/git-link]]
(global-set-key (kbd "C-c s g") 'git-link)
(use-package! git-link
  :config
  ;; urlにbranchではなくcommit番号をつかう.
  ;; org-journalへの貼り付けを想定しているのでこの設定にしておく.
  (setq git-link-use-commit t))

(provide 'nothung-tools)
;;; modules/tools.el ends here
