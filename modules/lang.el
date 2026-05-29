;;; modules/lang.el --- Lang  (:lang)  -*- lexical-binding: t; -*-
;;; Commentary:
;; Doom category :lang.  Migrated from nothung.org (Lang).
;;; Code:

;; 編集補助の中でも特にコーディング支援をまとめる.

;;;; Generals
;; 言語に依存しないコーディング支援ツール. 
;;;;; smartparens
;; https://github.com/Fuco1/smartparens
;; Emacsでカッコの対応を取りつつ編集をするminor-mode. pareditを新しくrewriteした.
;; refs:
;; - https://ebzzry.com/en/emacs-pairs/
;; - http://kimi.im/2021-11-27-sexp-operations-in-emacs
;; [[https://github.com/hlissner/doom-emacs/blob/master/modules/config/default/%2Bemacs-bindings.el][doom emacsのsmartparens定義]]. +bindings +smartparensで有効.
;; 足りないのは自分で定義する必要あり. というかいろいろ再定義するか...
(use-package! smartparens-config
  :bind
  ("C-<right>" . sp-forward-slurp-sexp)
  ("M-<right>" . sp-forward-barf-sexp)
  ("C-<left>"  . sp-backward-slurp-sexp)
  ("M-<left>"  . sp-backward-barf-sexp)
  ("C-M-w" . sp-copy-sexp)
  ("M-[" . sp-backward-unwrap-sexp)
  ("M-]" . sp-unwrap-sexp)
  :config
  ;; copilot.elをいれたら相性が悪くなった.. 
  ;; (add-hook! 'clojure-mode-hook 'smartparens-strict-mode)
  (setq smartparens-strict-mode nil))

;;;;; symbol-overlay
;; シンボルのハイライトをキー入力で制御できる.
;; https://github.com/wolray/symbol-overlay/
;; 使ってないし companyとkeybindがかぶったのでいったん封印.
;;;;; codic
;; よい変数名を教えてくれるwebサービスcodicクライアント. 
;; [[https://codic.jp/][codic - プログラマーのためのネーミング辞書]]
;; - M-x codic: 英語 => 日本語
;; - M-x codic-translate => 日本語 => 英語(要token)
;; codic-translateを使うにはtokenを codic-api-tokenに設定する必要がある. 
;; 現状は"private/config.el"に書いて読み込んでいる. 
(use-package! codic)
;; - [[https://github.com/emacsorphanage/codic][codic - GitHub]]
;; - [[https://futurismo.biz/archives/2538/][英語力を向上させたいのでまずは Emacs からはじめた | Futurismo]]

;;;; Clojure
;; ref: [[https://github.com/hlissner/doom-emacs/blob/develop/modules/lang/clojure/README.org][doom-emacs/README.org - GitHub]]
;; とりあえず，doomのclojureモジュール有効.
;; + cider
;; + clj-refactor
;; + flycheck-clj-kondo
;; その他，
;; + rainbow-delimiters, smartparensはdoomのcoreパッケージとしてすでにはいっている.
;; + pereditはciderの中に入っている.
;; やりすぎindent mode
(add-hook! 'clojure-mode-hook 'aggressive-indent-mode)
;; 自動でalign整形.
(setq clojure-align-forms-automatically t)

(use-package! cider
  :bind
  ;; desing journal用にbinding追加
  ("C-c C-v C-p" . cider-pprint-eval-defun-to-comment)
  ("C-c C-v M-p" . cider-pprint-eval-last-sexp-to-comment)
  :config
  ;; connectとともにREPL bufferを表示.
  (setq  cider-repl-pop-to-buffer-on-connect t)
  ;; replに 出力しすぎてEmacsがハングするのを防ぐ.
  ;; 基本的にREPLへのprintは非効率なので cider inspect推奨. 
  ;; https://github.com/practicalli/spacemacs.d/issues/4
  (setq  cider-repl-buffer-size-limit 50)


  ;; companyでのあいまい補完.
  (add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
  (add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion)

  ;; うまくうごかないな.. 
  (setq cider-special-mode-truncate-lines nil)
  ;; (add-hook 'cider-stacktrace-mode-hook (lambda () (setq truncate-lines nil)))
  ;; (add-hook 'cider-inspector-mode-hook (lambda () (setq truncate-lines nil)))

  ;; stack-frame表示をプロジェクトに限定
  (setq cider-stacktrace-default-filters '(project))

  ;; cider-connectで固定portを選択候補に表示.
  ;; 固定port自体は tools.depsからのnrepl起動時optionで指定.
  (setq cider-known-endpoints '(("kotori" "0.0.0.0" "34331")))
)
;;;;; clj-refactor
;; Emacs CIDERでClojureを書くための便利なファクタツール提供.
;; https://github.com/clojure-emacs/clj-refactor.el
(add-hook! clojure-mode
  (clj-refactor-mode 1)
  (yas-minor-mode 1) ; for adding require/use/import statements
  ;; This choice of keybinding leaves cider-macroexpand-1 unbound
  (cljr-add-keybindings-with-prefix "C-c C-m")

  ;; cljr-rename-symbolでのプロンプト抑止. 
  ;; どうも初回実行が遅く２回目からは問題ない. 
  (setq cljr-warn-on-eval nil)
)
;; - cljr-clean-ns
;;   - namespaceを整理, cljr-project-cleanでプロジェクト全体に適用.
;; - cljr-rename-symbol 
;;   - シンボル(関数名や変数名含む). 
;;   - どうも遅いのてLSPのほうがここはいいのかも. 
;;;;; cljstyle: formatter for Clojure
;; ref: [[https://qiita.com/lagenorhynque/items/a5d83b4a36a1cf1cacbe][GitHub]]
;; Doom Emascの editor/format moduleと連携可能.
;; Clojureだとdefaultが node-cljfmtなのでcljstyleを使うには設定が必要.
(add-hook! clojure-mode
  (set-formatter! 'cljstyle "cljstyle pipe" :modes '(clojure-mode))
  (add-hook 'before-save-hook 'format-all-buffer t t))
;;;;; clj-kondo: linter for Clojure
;; ref: [[https://qiita.com/lagenorhynque/items/dd9d6a1d97cbea738bc0][GitHub]]
;;;;; portal
;; Data Visualization for Clojure.
;; ref. https://github.com/djblue/portal
(defun portal.api/open ()
  (interactive)
  (cider-nrepl-sync-request:eval
   "(require 'portal.api) (portal.api/tap) (portal.api/open)"))

(defun portal.api/clear ()
  (interactive)
  (cider-nrepl-sync-request:eval "(portal.api/clear)"))

(defun portal.api/close ()
  (interactive)
  (cider-nrepl-sync-request:eval "(portal.api/close)"))
;;;;; vega-view
;;;;; clerk
;; https://github.com/nextjournal/clerk

;;;; Rust
(setq exec-path (append exec-path '("~/.cargo/bin")))

;;;; rest

;;;; mermaid-mode
;; https://github.com/abrochard/mermaid-mode
(use-package! mermaid-mode)
;; mermaid-open-browser(C-c C-o)でmermaid-jsのサイトに飛んで表示できる. 
;; https://mermaid-js.github.io/mermaid-live-editor
;; ローカルで表を生成するにはmermaid-cliのインストールが別途必要. 

(provide 'nothung-lang)
;;; modules/lang.el ends here
