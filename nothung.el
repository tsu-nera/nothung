;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;; (load-file "~/.doom.d/private/config.el")

(use-package! chatgpt-shell
  :commands chatgpt-shell
  :init
  (bind-key "C-c z b" 'chatgpt-shell)
  :config
  (setq chatgpt-shell-chatgpt-streaming t))

(use-package! eww
  :bind
  ("C-c s w" . eww-search-words)
  ("C-c o w" . eww-open-in-new-buffer))

(use-package! ace-link
  :config
  (eval-after-load 'eww '(define-key eww-mode-map "f" 'ace-link-eww))
  (ace-link-setup-default)
  (define-key org-mode-map (kbd "M-o") 'ace-link-org))

;; Checkers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Completion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-roam の completion-at-point が動作しないのはこいつかな...
;; (add-hook! 'org-mode-hook (company-mode -1))
;; company はなにげに使いそうだからな，TAB でのみ補完発動させるか.
(setq company-idle-delay nil)
(global-set-key (kbd "TAB") #'company-indent-or-complete-common)

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

(use-package! swiper
  ;; :bind
  ;;  ("C-s" . swiper) ;; migemo とうまく連携しないので isearch 置き換えを保留. C-c s s で swiper 起動.
  :config
  (require 'ivy-hydra)
  (ivy-mode 1))


  
;; avy-migemo-e.g.swiper だけバクる
;; https://github.com/abo-abo/swiper/issues/2249
;;(after! avy-migemo
;;  (require 'avy-migemo-e.g.swiper))

(use-package! affe
  :after consult
  :config
  (defun affe-orderless-regexp-compiler (input _type)
    (setq input (orderless-pattern-compiler input))
    (cons input (lambda (str) (orderless--highlight input str))))
  (setq affe-regexp-compiler #'affe-orderless-regexp-compiler))

;; Config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; doom specific config
;; (setq user-full-name "John Doe"
;;      user-mail-address "john@doe.com")
(setq confirm-kill-emacs nil) ; 終了時の確認はしない.

;; フルスクリーンで Emacs 起動
;; ブラウザと並べて表示することが多くなったのでいったんマスク
;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; This is to use pdf-tools instead of doc-viewer
(use-package! pdf-tools
  :config
  (pdf-tools-install)
  ;; This means that pdfs are fitted to width by default when you open them
  (setq-default pdf-view-display-size 'fit-width)
  :custom
  (pdf-annot-activate-created-annotations t "automatically annotate highlights"))

;; projectileの検索スピードを上げる
(setq projectile-indexing-method 'alien)

;; Editor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 英数字と日本語の間にスペースをいれる.
(use-package! pangu-spacing
  :config
  (global-pangu-spacing-mode 1)
  ;; 保存時に自動的にスペースを入れるのを抑止.あくまで入力時にしておく.
  (setq pangu-spacing-real-insert-separtor nil))

;; 記号の前後にスペースを入れる.
(use-package! electric-operator)
(add-hook! 'org-mode-hook #'electric-operator-mode)

(cua-mode t)
(setq cua-enable-cua-keys nil)

;; (auto-fill-mode -1)

(auto-fill-mode -1)
(remove-hook 'org-mode-hook #'auto-fill-mode)
;; (remove-hook 'org-mode-hook #'turn-on-auto-fill)
;; (remove-hook 'text-mode-hook #'auto-fill-mode)
;; (remove-hook 'text-mode-hook #'turn-on-auto-fill)
;; (add-hook 'org-mode-hook #'turn-off-auto-fill)
;; (add-hook 'text-mode-hook #'turn-off-auto-fill)
;; (add-hook 'org-roam-mode-hook #'turn-off-auto-fill)

(setq-default fill-column 99999)
(setq fill-column 99999)

;; / を削除
(set-display-table-slot standard-display-table 'wrap ?\ )
;; $ を削除
(set-display-table-slot standard-display-table 0 ?\ )

(setq word-wrap-by-category t)

;; (add-hook! visual-line-mode 'visual-fill-column-mode)

(use-package! perfect-margin
  :config
  (perfect-margin-mode t)
  ;; disable special window
  (setq perfect-margin-ignore-regexps '("*vterm*"))
  (setq perfect-margin-ignore-filters nil)  ;; disable minibuffer
)

(unless (display-graphic-p)
  ;; ターミナルの縦分割線をUTF-8できれいに描く
  (defun my-change-window-divider ()
    (interactive)
    (let ((display-table (or buffer-display-table
           standard-display-table
           (make-display-table))))
      (set-display-table-slot display-table 5 ?│)
      (set-window-display-table (selected-window) display-table)))
  (add-hook 'window-configuration-change-hook 'my-change-window-divider))

(use-package! whitespace
  :config
  ;; limit lie length -> display-fill-column-indicator-modeを使うためマスク. 
  ;; (setq whitespace-line-column 80) 
  (setq whitespace-style '(face 
                           ;;lines-tail
                           ))
  ;; 全角スペースを可視化
  (setq whitespace-space-regexp "\\(\u3000+\\)")
  (global-whitespace-mode 1))

(setq-default display-fill-column-indicator-column 78)
(global-display-fill-column-indicator-mode)

(use-package! iedit
  :bind
  ("C-;" . iedit-mode))

(use-package! bm
  :bind   (("<f5>" . bm-toggle))
  :config
  (setq temporary-bookmark-p t)
  (setq bm-face '((t (:background "steel blue" :foreground "#272822")))))
;;(setq bm-face '((t (:background "#525252" :foreground ""))))
;;	   ("<C-f5>"  . bm-next)
;;	   ("<S-f5>" . bm-previous))

(use-package! atomic-chrome
  ;; auto generated by gpt4
  ;; :init
  ;; (setq atomic-chrome-default-major-mode 'markdown-mode
  ;;       atomic-chrome-buffer-open-style 'frame
  ;;       atomic-chrome-url-major-mode-alist
  ;;       '(("github\\.com" . gfm-mode)
  ;;         ("redmine\\." . textile-mode)))
  :config
  (setq atomic-chrome-buffer-open-style 'full)
  (atomic-chrome-start-server))

;; Emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Emacs29
(pixel-scroll-precision-mode)

;; doomだとhelpが割り当てられていたがdoomのhelpはF1をつかう.

(global-set-key (kbd "C-h") 'backward-delete-char)
(global-set-key (kbd "C-c h r") 'doom/reload)

;; Emacs起動時にいちいち質問されるのはうざい.
;; default tではなぜか無視できないので:allを設定しておく.
(setq enable-local-variables :all)

;;; 右から左に読む言語に対応させないことで描画高速化
(setq-default bidi-display-reordering nil)

;; recentfに保存する数. 
(setq recentf-max-saved-items 300)

;; GCを減らして軽くする.
;; (setq gc-cons-threshold (* gc-cons-threshold 10))
;; GCの上限閾値をあえて下げる(低スペックPC)
;; (setq gc-cons-threshold (/ gc-cons-threshold 10))

;; どうもDoom だとデフォルトで大きな値が設定されている模様なので戻す. 
;; (setq gc-cons-percentage 0.1)
;; (setq gc-cons-threshold 800000)
;; GC実行のメッセージを出す
(setq garbage-collection-messages nil)

;; Email
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Input
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(set-default 'buffer-filecoding-system 'utf-8)

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

(use-package! fcitx
  :config
  (setq fcitx-remote-command "fcitx5-remote")
  (fcitx-aggressive-setup)
  ;; Linux なら t が推奨されるものの、fcitx5 には未対応なためここは nil
  (setq fcitx-use-dbus nil))

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

(use-package! codic)

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

(add-hook! clojure-mode
  (clj-refactor-mode 1)
  (yas-minor-mode 1) ; for adding require/use/import statements
  ;; This choice of keybinding leaves cider-macroexpand-1 unbound
  (cljr-add-keybindings-with-prefix "C-c C-m")

  ;; cljr-rename-symbolでのプロンプト抑止. 
  ;; どうも初回実行が遅く２回目からは問題ない. 
  (setq cljr-warn-on-eval nil)
)

(add-hook! clojure-mode
  (set-formatter! 'cljstyle "cljstyle pipe" :modes '(clojure-mode))
  (add-hook 'before-save-hook 'format-all-buffer t t))

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

(use-package! vega-view
 :config
 (define-key clojure-mode-map (kbd "C-c M-n v") 'vega-view))

(defun clerk-show ()
  (interactive)
  (when-let
      ((filename
        (buffer-file-name)))
    (save-buffer)
    (cider-interactive-eval
     (concat "(nextjournal.clerk/show! \"" filename "\")"))))
(define-key clojure-mode-map (kbd "<M-return>") 'clerk-show)

(setq exec-path (append exec-path '("~/.cargo/bin")))

(use-package! restclient
  :mode (("\\.rest\\'" . restclient-mode)
         ("\\.restclient\\'" . restclient-mode)))
(use-package! ob-restclient
  :after org restclient
  :init
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((restclient . t))))

(use-package! mermaid-mode)

;; OS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package! exwm
  :after counsel
  :init
  (setq counsel-linux-app-format-function
        #'counsel-linux-app-format-function-name-only)
  (map!
        :leader
        :prefix ("z" . "exwm")
        "c" #'exwm-reset
        "o" (lambda (command)
                         (interactive (list (read-shell-command "$ ")))
                         (start-process-shell-command command nil command))
        "z" #'exwm-workspace-switch
        "m" #'exwm-workspace-move-window
        "a" #'counsel-linux-app
        "s" #'counsel-search  ;; open chrome and search
        )
  (add-hook 'exwm-input--input-mode-change-hook
            'force-mode-line-update)
  (add-hook 'exwm-update-class-hook
            (lambda ()
              (exwm-workspace-rename-buffer exwm-class-name)))
  ;; どうもChromeを立ち上げるとハングするので無効にしておく.
  (winner-mode -1)

  :config
  (require 'exwm-randr)
  (setq exwm-randr-workspace-output-plist '(0 "HDMI-1"))
  (add-hook
   'exwm-randr-screen-change-hook
   (lambda ()
     (start-process-shell-command
      "xrandr" nil "xrandr --output HDMI-1 --primary --right-of eDP-1 --auto")))
  (exwm-randr-enable)

  (require 'exwm-systemtray)
  (exwm-systemtray-enable)

  ;; edit-server的な. C-c 'で編集できるのでよりbetter
  ;; 一度入力したものを再度開くと文字化けする.
  (require 'exwm-edit)
  (setq exwm-edit-split t)

  (setf epg-pinentry-mode 'loopback)
  (defun pinentry-emacs (desc prompt ok error)
    (let ((str (read-passwd
                (concat (replace-regexp-in-string
                         "%22" "\""
                         (replace-regexp-in-string
                          "%0A" "\n" desc)) prompt ": "))))
      str))

  ;; from https://github.com/ch11ng/exwm/wiki/Configuration-Example
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (fringe-mode 1)

  ;; google-chromeを起動するとmouse on menu-barがpopupしてハングする対策
  ;; https://stackoverflow.com/questions/17280845/emacs-disable-pop-up-menus-on-mouse-clicks
  (fset 'menu-bar-open nil)
  (fset 'x-menu-bar-open nil)

  ;; Turn on `display-time-mode' if you don't use an external bar.
  (setq display-time-default-load-average nil)
  (display-time-mode t)
  (display-battery-mode 1)

  (setq exwm-workspace-number 2)

  (setq exwm-input-simulation-keys
        '(([?\C-b] . [left])
          ;; Chromeページ内検索のために空ける          
          ;; ([?\C-f] . [right])
          ;; 2022.03.23 やっぱり解除. どうもC-fがスムーズな操作を阻害する.
          ;; ページ内検索はSurfingkeysというExtensionを利用(/).
          ([?\C-f] . [right])
          ([?\C-p] . [up])
          ([?\C-n] . [down])
          ([?\C-a] . [home])
          ([?\C-e] . [end])
          ([?\M-v] . [prior])
          ([?\C-v] . [next])
          ([?\C-d] . [delete])
          ([?\C-m] . [return])
          ([?\C-h] . [backspace])
          ([?\C-k] . [S-end delete])))

  (exwm-enable))

(after! org
  (setq org-directory (file-truename "~/repo/gtd"))

  (defconst my/gtd-projects-file (concat org-directory "/home.org"))
  (defconst my/inbox-file
    (concat org-directory "/inbox/inbox.org"))
  (defconst my/daily-journal-dir
    (concat org-directory "/journals/daily"))
  (defconst my/project-journal-bakuchi
    (file-truename "~/repo/bakuchi-doc/notes/journal.org"))
  (defconst my/project-journal-deepwork
    (file-truename "~/repo/keido/notes/zk/journal_deepwork.org"))

  ;; org-captureのtargetは詳しくいろいろ設定するのでdefaultは不要.
  ;; (setq org-default-notes-file "gtd/gtd_projects.org")

  ;; 何でもかんでも agenda すると思いので厳選.
  ;; org-journalの機能でこのほかに今日のjournal fileが追加される.
  (setq org-agenda-files
        (list
         ;; my/project-journal-bakuchi
         ;; my/project-journal-deepwork
         my/daily-journal-dir
         my/gtd-projects-file
         )))

(defun my/create-weekly-org-file (path)
  (expand-file-name (format "%s.org" (format-time-string "%Y-w%W")) path))
(defun my/create-daily-org-file (path)
  (expand-file-name (format "%s.org" (format-time-string "%Y-%m-%d")) path))

(defconst my/weekly-journal-dir "~/repo/keido/notes/zk")

(defconst my/weekly-private-dir "~/repo/gtd/journals/weekly")
(defconst my/daily-private-dir "~/repo/gtd/journals/daily")

;; Org mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; スマホとの共有のため, github を clone したものを Dropbox に置いて$HOME に symlink している.
(after! org

  (setq org-return-follows-link t) ;; Enter でリンク先へジャンプ
  (setq org-use-speed-commands t)  ;; bullet にカーソルがあると高速移動
  (setq org-hide-emphasis-markers t) ;; * を消して表示.
  (setq org-pretty-entities t)

  ;; カレンダー表示を英語表記へ
  (setq system-time-locale "C") 

  ;; defaultではFootnotes
  (setq org-footnote-section "Footnotes")
  (setq org-footnote-auto-adjust t)

  ;; M-RET の挙動の調整
  ;; t だと subtree の最終行に heading を挿入
  ;; nil だと current point に挿入
  ;; なお，C-RET だと subtree の最終行に挿入され
  ;; C-S-RET だと手前に挿入される.
  (setq org-insert-heading-respect-content nil)

  (setq org-startup-indented t)
  (setq org-indent-mode-turns-on-hiding-stars nil)

  (setq org-startup-folded 'showall) ;; 見出しの階層指定
  (setq org-startup-truncated nil) ;; 長い文は折り返す.

  ;; electric-indent は org-mode で誤作動の可能性があることのこと
  ;; たまにいきなり org-mode の tree 構造が壊れる.とりあえず設定しておく
  ;; この設定の効果が以下の記事で gif である.
  ;; https://www.philnewton.net/blog/electric-indent-with-org-mode/
  (add-hook! org-mode (electric-indent-local-mode -1)))

(after! org
  ;; org-agenda
  (setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
  ;; 時間表示が 1 桁の時, 0 をつける
  (setq org-agenda-time-leading-zero t) 
  (setq calendar-holidays nil) ;; 祝日を利用しない.
  (setq org-log-done 'time);; 変更時の終了時刻記録.

  ;; スケジュールやデッドラインアイテムは DONE になっていれば表示する
  (setq org-agenda-skip-deadline-if-done nil)
  (setq org-agenda-skip-scheduled-if-done nil)

  ;; inactive timestamp [] を非表示.
  (setq org-agenda-include-inactive-timestamps nil)
  ;; default で 時間を表示
  (setq org-agenda-start-with-log-mode t) 

  ;; org-agenda speedup tips
  ;; https://orgmode.org/worg/agenda-optimization.html

  (setq org-agenda-file-regexp "\\`\\\([^.].*\\.org\\\|[0-9]\\\{8\\\}\\\(\\.gpg\\\)?\\\)\\'")

  ;; 期間を限定
  (setq org-agenda-span 14)
  ;; Inhibit the dimming of blocked tasks:
  (setq org-agenda-dim-blocked-tasks nil)
  ;; Inhibit agenda files startup options:memo
  (setq org-agenda-inhibit-startup nil)
  ;; Disable tag inheritance in agenda:
  (setq org-agenda-use-tag-inheritance nil)

  ;; https://emacs.stackexchange.com/questions/13237/in-org-mode-how-to-view-todo-items-for-current-buffer-only
  (defun org-todo-list-current-file (&optional arg)
    "Like `org-todo-list', but using only the current buffer's file."
    (interactive "P")
    (let ((org-agenda-files (list (buffer-file-name (current-buffer)))))
      (if (null (car org-agenda-files))
        (error "%s is not visiting a file" (buffer-name (current-buffer)))
        (org-todo-list arg))))
)

(setq org-todo-keywords
      '((sequence "📊(a)" "💡(b)" "✅(c)" "👨(d)" "🔬(e)" "👩(f)" "🎨(g)" "|")
        (sequence "📂(h)" "✨(i)" "🔌(k)" "🔗(l)" "📝(m)" "🌳(n)" "|")
        (sequence "🪨(o)" "🧩(p)" "📜(q)" "📍(r)" "🔍(s)" "🔦(t)" "|")
        (sequence "🔧(w)" "🌱(z)" "|")))

(after! org
  (setq org-capture-templates
        '(("i" "📥 Inbox" entry
           (file my/inbox-file) 
           "* %?\nCaptured On: %U\n"
           :klll-buffer t)
          ("I" "📥+🌐 Inbox+Browser" entry
           (file my/inbox-file)
           "* %?\nSource: [[%:link][%:description]]\nCaptured On: %U\n"
           :klll-buffer t)
          ("q" "📥+🌐 Inbox+Browser(quote)" entry
           (file my/inbox-file)
           "* %?\nSource: [[%:link][%:description]]\nCaptured On: %U\n%i\n"
           :klll-buffer t))))

;; 現状つかってないのでマスク
;; (defun my/create-timestamped-org-file (path)
;;   (expand-file-name (format "%s.org" (format-time-string "%Y%m%d%H%M%S")) path))

(after! org
  (setq org-capture-templates
        (append 
          '(("c" "☑ Planning" plain
             (file+headline
              (lambda () 
                (my/create-daily-org-file my/daily-private-dir))
              "Planning")
             "%?"
             :unnarrowed t
             :kill-buffer t)
            ("t" "🤔 Thought" entry
             (file+headline
              (lambda () 
                (my/create-daily-org-file my/daily-private-dir))
              "Thoughts")
             "* 🤔 %?\n%T"
             :empty-lines 1
             :unnarrowed t
             :kill-buffer t)
            ("T" "🤔+📃 Thought+Ref" entry
             (file+headline
              (lambda () 
                (my/create-daily-org-file my/daily-private-dir))
              "Thoughts")
             "* 🤔 %?\n%T from %a\n"
             :empty-lines 1
             :unnarrowed t
             :kill-buffer t)
            ("l" "🤔+🌐 Thought+Browser" entry
             (file+headline
              (lambda () 
                (my/create-daily-org-file my/daily-private-dir))
              "Thoughts")
             "* 🤔 %?\n%T from [[%:link][%:description]]\n"
             :empty-lines 1
             :unnarrowed t
             :kill-buffer t)
            ("p" "🍅 Pomodoro" entry
             (file+headline
              (lambda () 
                (my/create-daily-org-file my/daily-private-dir))
              "DeepWork")
             "* 🍅 %?\n%T"
             :empty-lines 1
             :unnarrowed t
             :kill-buffer t)
            ("r" "🧘 Recovery" entry
             (file+headline
              (lambda () 
                (my/create-daily-org-file my/daily-private-dir))
              "Recovery")
             "* 🧘 %?\n%T"
             :empty-lines 1
             :unnarrowed t
             :kill-buffer t)
            ("j" "🖊 Journal" plain
             (file 
              (lambda ()
                (my/create-daily-org-file my/daily-private-dir)))
             "%?"
             :empty-lines 1
             :unnarrowed t
             :kill-buffer t)
            ("J" "🖊+📃 Journal+Ref" plain
             (file 
              (lambda ()
                (my/create-daily-org-file my/daily-private-dir)))
             "%?\n%a"
             :empty-lines 1
             :unnarrowed t
             :kill-buffer t)
            ("L" "🖊+🌐 Journal+Browser" plain
             (file 
              (lambda ()
                (my/create-daily-org-file my/daily-private-dir)))
             "%?\nSource: [[%:link][%:description]]\nCaptured On: %U\n"
             :empty-lines 1
             :unnrrowed t
             :kill-buffer t)) org-capture-templates)))

(after! org
  (setq org-capture-templates
        (append 
        '(("b" "🖊 bakuchi entry" entry
           (file+olp+datetree my/project-journal-bakuchi)
           "* %?\nCaptured On: %T\n"
           :unnarrowed t
           :empty-lines 1
           :tree-type week
           :klll-buffer t)
          ("B" "🖊+✍ bakuchi append" plain
           (file my/project-journal-bakuchi)
           "%?"
           :empty-lines 1
           :unnarrowed t
           :jump-to-captured t
           :kill-buffer t)
          ("d" "🖊 DeepWork entry" entry
           (file+olp+datetree my/project-journal-deepwork)
           "* %?\nCaptured On: %T\n"
           :unnarrowed t
           :empty-lines 1
           :tree-type week
           :klll-buffer t)) org-capture-templates)))

(after! ox
;; (setq org-export-async-init-file "/home/tsu-nera/.doom.d/async-init.el")

  (defun my/hugo-filter-html-amp (text backend info)
    (when (org-export-derived-backend-p backend 'hugo)
      (replace-regexp-in-string "&amp;" "&" text)))
  (defun my/hugo-filter-html-gt (text backend info)
    (when (org-export-derived-backend-p backend 'hugo)
      (replace-regexp-in-string "&gt;" ">" text)))
  (defun my/hugo-filter-html-lt (text backend info)
    (when (org-export-derived-backend-p backend 'hugo)
      (replace-regexp-in-string "&lt;" "<" text)))
  (add-to-list
   'org-export-filter-plain-text-functions 'my/hugo-filter-html-amp)
  (add-to-list
   'org-export-filter-plain-text-functions 'my/hugo-filter-html-gt)
  (add-to-list
   'org-export-filter-plain-text-functions 'my/hugo-filter-html-lt))

(use-package! org-preview-html)

(use-package! ox-hugo
  :after ox
  :bind
  ;; org-roamのexportで多様するのでC-c rのprefixをつけておく.
  ("C-c r e" . org-hugo-export-to-md)
  :config
  (setq org-hugo-auto-set-lastmod t)
  ;; なんか.dir-locals.elに書いても反映してくれないな. 
  (setq org-export-with-author nil)
  ;; org-hugo-get-idを使うように設定.
  (setq org-hugo-anchor-functions 
        '(org-hugo-get-page-or-bundle-name
          org-hugo-get-custom-id
          org-hugo-get-id
          org-hugo-get-md5
          ;; 日本語に不向きな気がする
          ;; org-hugo-get-heading-slug
          )))

(use-package! ox-rst
  :after ox)

(after! ox
  (defun my/rst-to-sphinx-link-format (text backend info)
    (when (and (org-export-derived-backend-p backend 'rst)
               (not (search "<http" text)))
      (replace-regexp-in-string
       "\\(\\.org>`_\\)" ">`"
       (concat ":doc:" text) nil nil 1)))

  (add-to-list 'org-export-filter-link-functions
               'my/rst-to-sphinx-link-format))

(use-package! ox-qmd)

(after! org
  ;; https://stackoverflow.com/questions/53469017/org-mode-source-editing-indents-code-after-exiting-source-code-block-editor
  ;; インデント. default 2になっているとへんな隙間が先頭に入る.
  (setq org-edit-src-content-indentation 0)
  (setq org-src-preserve-indentation t)
  ;; TABの挙動
  (setq org-src-tab-acts-natively t)

  ;; org-babel のソースをキレイに表示.
  (setq org-src-fontify-natively t)
  (setq org-fontify-whole-heading-line t)

  ;; 評価でいちいち質問されないように.
  (setq org-confirm-babel-evaluate nil)

  ;; org-babel で 実行した言語を書く. デフォルトでは emacs-lisp だけ.
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((lisp . t)
     (shell . t)
     (clojure . t)))

  ;; org-modeからclojure codeを評価.
  (define-key org-mode-map (kbd "C-c C-v e") 'cider-eval-last-sexp)
  ;; (org-defkey org-mode-map "\C-u\C-x\C-e" 'cider-eval-last-sexp)

  ;; Clojure Modeの特別対応. keybindingが上書きされるので.
  (define-key clojure-mode-map (kbd "C-c C-x k") 'org-edit-src-exit)
  (define-key clojure-mode-map (kbd "C-c C-x q") 'org-edit-src-abort))

(use-package! ob-html
  :after org
  :config
  ;; C-c C-o でブラウザで開く.
  (org-babel-html-enable-open-src-block-result-temporary))

(after! org
;;; Titles and Sections
;; hide #+TITLE:
;; (setq org-hidden-keywords '(title))
;; set basic title font
;; (set-face-attribute 'org-level-8 nil :weight 'bold :inherit 'default)
;; Low levels are unimportant => no scaling
;; (set-face-attribute 'org-level-7 nil :inherit 'org-level-8)
;; (set-face-attribute 'org-level-6 nil :inherit 'org-level-8)
;; (set-face-attribute 'org-level-5 nil :inherit 'org-level-8)
;; (set-face-attribute 'org-level-4 nil :inherit 'org-level-8)
;; Top ones get scaled the same as in LaTeX (\large, \Large, \LARGE)
;; (set-face-attribute 'org-level-3 nil :inherit 'org-level-8 :height 1.2) ;\large
;; (set-face-attribute 'org-level-2 nil :inherit 'org-level-8 :height 1.44) ;\Large
;; (set-face-attribute 'org-level-1 nil :inherit 'org-level-8 :height 1.728) ;\LARGE
;; Only use the first 4 styles and do not cycle.
(setq org-cycle-level-faces nil)

;; orgの階層の色分けレベル.
;; (setq org-n-level-faces 8)

;; Document Title, (\huge)
;; (set-face-attribute 'org-document-title nil
;;                    :height 2.074
;;                    :foreground 'unspecified
;;                    :inherit 'org-level-8)

;; (with-eval-after-load 'org-superstar
;;  (set-face-attribute 'org-superstar-item nil :height 1.2)
;;  (set-face-attribute 'org-superstar-header-bullet nil :height 1.2)
;;  (set-face-attribute 'org-superstar-leading nil :height 1.3))
;; Set different bullets, with one getting a terminal fallback.
(setq org-superstar-headline-bullets-list '("■" "◆" "●" "▷"))
;; (setq org-superstar-special-todo-items t)

;; Stop cycling bullets to emphasize hierarchy of headlines.
(setq org-superstar-cycle-headline-bullets nil)
;; Hide away leading stars on terminal.
;; (setq org-superstar-leading-fallback ?\s)
(setq inhibit-compacting-font-caches t))

;; org-roam
(setq org-roam-directory (file-truename "~/repo/keido/notes"))
(setq org-roam-zk-dir (concat org-roam-directory "/zk"))
(setq org-roam-db-location (file-truename "~/repo/keido/db/org-roam.db"))

(use-package! org-roam
  :after org
  :init
  (setq org-roam-v2-ack t)
  (map!
        :leader
        :prefix ("r" . "org-roam")
        "f" #'org-roam-node-find
        "i" #'org-roam-node-insert
        "l" #'org-roam-buffer-toggle
        "t" #'org-roam-tag-add
        "T" #'org-roam-tag-remove
        "a" #'org-roam-alias-add
        "A" #'org-roam-alias-remove
        "r" #'org-roam-ref-add
        "R" #'org-roam-ref-remove
        "o" #'org-id-get-create
        "u" #'my/org-roam-update
        "D" #'org-roam-dailies-goto-today
        )
  :custom
  ;;ファイル名を ID にする.
  (org-roam-capture-templates
   '(("z" "🌱 Zettel" plain "%?"
      :target (file+head "zk/%<%Y%m%d%H%M%S>.org"
                         "\n#+date: %T\n#+title:🌱${title}\n#+filetags: :ZETTEL:\n")
      :unnarrowed t)
     ("w" "📝 Wiki" plain "%?"
      :target (file+head "zk/%<%Y%m%d%H%M%S>.org"
                         "#+title:📝${title}\n#+filetags: :WIKI:\n")
      :unnarrowed t)
     ("t" "🔖 Tag" plain "%?"
      :target (file+head "zk/%<%Y%m%d%H%M%S>.org"
                         "#+title:🔖${title}\n#+filetags: :TAG:\n")
      :unnarrowed t)
     ("h" "👨 Person" plain "%?"
      :target (file+head 
               "zk/%<%Y%m%d%H%M%S>.org"                 
               "#+title:👨${title}\n#+filetags: :PERSON:\n")
      :unnarrowed t)
     ("f" "📂 Type" plain "%?"
      :target (file+head "zk/%<%Y%m%d%H%M%S>.org"
                         "#+title:📂${title}\n#+filetags: :TYPE:\n")
      :unnarrowed t)
     ("m" "🌳 MOC" plain "%?"
      :target (file+head "zk/%<%Y%m%d%H%M%S>.org"
                         "#+title:🌳${title}\n#+filetags: :MOC:\n")
      :unnarrowed t)
     ("i" "✅ Issue" plain "%?"
      :target (file+head "zk/%<%Y%m%d%H%M%S>.org"
                        "#+title:✅${title}\n#+filetags: :ISSUE:\n")
      :unnarrowed t)
     ("d" "💡 Idea" plain "%?"
      :target (file+head "zk/%<%Y%m%d%H%M%S>.org"
                         "#+title:💡${title}\n#+filetags: :IDEA:\n")
      :unnarrowed t)
     ("c" "📑 Concept" plain "%?"
      :target (file+head 
               "zk/%<%Y%m%d%H%M%S>.org"
               "#+title:🎓${title}\n#+filetags: :CONCEPT:\n")
      :unnarrowed t)
     ("k" "🦊 Darkfox" plain "%?"
      :target (file+head 
               "zk/%<%Y%m%d%H%M%S>.org"
               "#+title:🦊${title}\n#+filetags: :DARKFOX:\n")
      :unnarrowed t)
     ("b" "📚 Book" plain
      "%?

- title: %^{title}
- authors: %^{author}
- date: %^{date}
- publisher: %^{publisher}
- url: http://www.amazon.co.jp/dp/%^{isbn}
"
      :target (file+head "zk/%<%Y%m%d%H%M%S>.org"
                         "#+title:📚${title} - ${author}(${date})\n#+filetags: :BOOK:SOURCE:\n")
      :unnarrowed t)
     ("s" "🎙‍ Talk" plain
      "%?

- title: %^{title}
- url: %^{url}
"
      :target (file+head "zk/%<%Y%m%d%H%M%S>.org"
                         "#+title:🎙 ${title} - ${editor}(${date})\n#+filetags: :TALK:SOURCE:\n")
      :unnarrowed t)
     ("o" "💻 Online" plain
      "%?

- title: %^{title}
- authors: %^{author}
- url: %^{url}
"
      :target (file+head "zk/%<%Y%m%d%H%M%S>.org"
                         "#+title:💻${title}\n#+filetags: :ONLINE:SOURCE:\n")
      :unnarrowed t)))
  (org-roam-extract-new-file-path "%<%Y%m%d%H%M%S>.org")
  ;;        :map org-mode-map
  ;;        ("C-M-i"    . completion-at-point)
  :config
  (defun my/org-roam-update ()
    (interactive)
    (org-id-update-id-locations)
    (org-roam-db-sync)
    (org-roam-update-org-id-locations))

  (setq org-roam-mode-sections
        '((org-roam-backlinks-section :unique t)))

  (setq org-roam-db-gc-threshold most-positive-fixnum)

  ;; for speed up
  ;; (setq org-roam-node-default-sort 'file-mtime)
 
  (setq +org-roam-open-buffer-on-find-file nil)
  ;; (org-roam-db-autosync-mode)
)

(setq org-roam-db-node-include-function
      (lambda ()
        (not (member "" (org-get-tags)))))

(use-package! consult-org-roam
   :init
   (require 'consult-org-roam)
   ;; Activate the minor-mode
   (consult-org-roam-mode 1)
   :custom
   (consult-org-roam-grep-func #'consult-ripgrep)
   :config
   ;; Eventually suppress previewing for certain functions
   (consult-customize
    consult-org-roam-forward-links
    :preview-key (kbd "M-."))
   :bind
   ("C-c r F" . consult-org-roam-file-find)
   ("C-c r b" . consult-org-roam-backlinks)
   ("C-c r S" . consult-org-roam-search))

(defun my/org-roam-rg-search ()
  "Search org-roam directory using consult-ripgrep. With live-preview."
  (interactive)
  (counsel-rg nil org-roam-directory))
(global-set-key (kbd "C-c r s") 'my/org-roam-rg-search)

(after! org-roam
  (setq org-roam-dailies-directory "zk")

  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry "** %?" :if-new
           (file+head+olp "%<%G-w%V>.org" "#+title: 📓%<%G-w%V>\n"
                          ("🖊Journals"))))))

(after! org-capture
  (add-to-list 'org-capture-templates
        '("w" "💭 Thought(weekly)" entry
          (file+headline (lambda ()
                     (my/create-weekly-org-file my/weekly-journal-dir))
                         "🖊Journals")
              "* 💭%?\n%T\n\n" 
              :empty-lines 1 
              :unnarrowed nil ;; ほかのエントリは見えないように.
              :klll-buffer t)))

;; 2. Memoize the function that costs the most.
(load-file "~/.doom.d/private/memoize.el")
(require 'memoize)

(memoize 'org-roam-node-read--completions "10 minute")

(defun memoize-force-update (func &optional timeout)
  (when (get func :memoize-original-function)
    (progn (memoize-restore func)
           (memoize func timeout))))
(defun my/force-update-org-roam-node-read-if-memoized (&optional timeout)
  (interactive)
  (memoize-force-update 'org-roam-node-read--completions
                        (if timeout timeout memoize-default-timeout)))
(run-with-idle-timer 60 t #'my/force-update-org-roam-node-read-if-memoized)
;; Note: it might be better to hack org-roam to make it use
;; hash-tables instead of lists. Have a way to quickly detect
;; which node is to be updated.

(use-package! org-toggl
  :after org
  :config
  (setq org-toggl-inherit-toggl-properties t)
  (toggl-get-projects)
  (setq toggl-default-project "GTD")
  (org-toggl-integration-mode))

(use-package! org-journal
  :after org
  :bind
  ;; org-roamと揃えたいので C-c rまでをprefixにする.
  ("C-c r d n" . org-journal-new-entry)
  ("C-c r d d" . org-journal-open-current-journal-file)
  :config
  (setq org-journal-date-prefix "#+TITLE: ✍")
  (setq org-journal-file-format "%Y-%m-%d.org")
  (setq org-journal-date-format "%Y-%m-%d")
  ;; (setq org-journal-file-type `daily)
  ;; これはorg-journalの変数ではない.
  (setq org-weekly-file-format "%Y-w%W.org")
  (setq org-weekly-date-format "%Y-w%W")
  (setq org-journal-file-type `weekly)
  (setq org-journal-dir my/daily-private-dir)
  ;; (setq org-journal-enable-agenda-integration t)
)

(use-package! org-anki
  :after org
  :custom
  ;; one big deckの原則に従う.
  ;; ref: http://augmentingcognition.com/ltm.html
  (org-anki-default-deck "Default")
  :config
  (define-key org-mode-map (kbd "C-c n A s") #'org-anki-sync-entry)
  (define-key org-mode-map (kbd "C-c n A u") #'org-anki-update-all)
  (define-key org-mode-map (kbd "C-c n A d") #'org-anki-delete-entry))

(require 'org-bars)
(add-hook! 'org-mode-hook #'org-bars-mode)

(setq org-table-export-default-format "orgtbl-to-csv")

(after! org
  (defun my/insert-timestamp ()
    (interactive)
    (org-insert-time-stamp (current-time) t))
  (defun my/insert-timestamp-inactive ()
    (interactive)
    (org-time-stamp-inactive (current-time)))
  (map! :map org-mode-map "C-u C-c C-." #'my/insert-timestamp-inactive)
  (map! :map org-mode-map "C-c C-." #'my/insert-timestamp))

(add-hook! 'org-mode-hook (ws-butler-mode -1))

(use-package! org-web-tools
  :bind
  ("C-c i l" . org-web-tools-insert-link-for-url))

(use-package! org-ai
  :load-path (lambda () "~/.emacs.d/.local/straight/repos/org-ai")
  :commands (org-ai-mode)
  ;; :custom
  ;; (org-ai-openai-api-token "")
  :init
  (add-hook 'org-mode-hook #'org-ai-mode)
  :config
  ;; if you are using yasnippet and want `ai` snippets
  (org-ai-install-yasnippets))

;; Term
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! magit
  (setq auth-sources '("~/.authinfo"))
  (setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))
  ;; (setq magit-diff-refine-hunk 'all)
)

(global-set-key (kbd "C-c s g") 'git-link)
(use-package! git-link
  :config
  ;; urlにbranchではなくcommit番号をつかう.
  ;; org-journalへの貼り付けを想定しているのでこの設定にしておく.
  (setq git-link-use-commit t))

;; UI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; どうもフォントが奇数だと org-table の表示が崩れる.
;; Source Han Code JP だとそもそも org-table の表示が崩れる.
;; terminal だと大丈夫な模様.そもそも Terminal はこの設定ではなくて 
;; Terminal Emulator の設定がきく.

;; Twitterで拾った設定だけど若干org-table表示がマシになったので採用.
;; (set-face-attribute 'fixed-pitch nil :font "Ricty Diminished" :height 160)
(setq doom-font (font-spec :family "Source Han Code JP" :size 15 ))
;; (setq doom-font (font-spec :family "Ricty Diminished" :size 16))
;; doom-molokaiやdoom-monokai-classicだとewwの表示がいまいち.
(setq doom-theme 'doom-molokai)
(doom-themes-org-config)

;; counselとdoom-modelineが相性悪いようなので
;; workspace name表示のためには追加で設定.
;; https://github.com/hlissner/doom-emacs/issues/314
;; (after! doom-modeline
;;  (setq doom-modeline-icon (display-graphic-p))
;;  (setq doom-modeline-major-mode-icon t))

(after! emojify
;;   (setq emojify-emoji-set "openmoji-v13-0")
  ;; (setq emojify-emoji-set "emojione-v2.2.6.22")
)

;; doomだと C-c i eでemojify-insert-emoji
(global-set-key (kbd "C-c i E") 'emoji-search)

(use-package! svg-tag-mode
  :config
  (setq svg-tag-tags
        '(
          ;; :XXX:
          ("\\(:[A-Z]+:\\)" . ((lambda (tag)
                                 (svg-tag-make tag :beg 1 :end -1))))          
          ;; :XXX|YYY:
          ("\\(:[A-Z]+\\)\|[a-zA-Z#0-9]+:" . ((lambda (tag)
                                                (svg-tag-make tag :beg 1 :inverse t
                                                              :margin 0 :crop-right t))))
          (":[A-Z]+\\(\|[a-zA-Z#0-9]+:\\)" . ((lambda (tag)
                                                (svg-tag-make tag :beg 1 :end -1
                                                              :margin 0 :crop-left t))))
          ;; :#TAG1:#TAG2:…:$
          ("\\(:#[A-Za-z0-9]+\\)" . ((lambda (tag)
                                       (svg-tag-make tag :beg 2))))
          ("\\(:#[A-Za-z0-9]+:\\)$" . ((lambda (tag)
                                       (svg-tag-make tag :beg 2 :end -1))))
          )))

;; これがスクロールを遅くする可能性があるので実験的に抑止.
(setq display-line-numbers-type nil) ; 行番号表示

;; less でのファイル閲覧に操作性を似せる mode.
;; view-mode は emacs 内蔵. C-x C-r で read-only-mode でファイルオープン
;; doom emacs だと C-c t r で read-only-mode が起動する.
(add-hook! view-mode
  (setq view-read-only t)
  (define-key ctl-x-map "\C-q" 'view-mode) ;; assinged C-x C-q.

  ;; less っぼく.
  (define-key view-mode-map (kbd "p") 'view-scroll-line-backward)
  (define-key view-mode-map (kbd "n") 'view-scroll-line-forward)
  ;; default の e でもいいけど，mule 時代に v に bind されてたので, 
  ;; emacs でも v に bind しておく.
  (define-key view-mode-map (kbd "v") 'read-only-mode))

;; EXWMの場合suspend-frameでハングするのはたちが悪いので封印.
(use-package! frame
  :bind
  ("C-z" . nil))

;; 実験, どうもマウス操作でEmacsの制御が効かなくなることがあるので.
(setq make-pointer-invisible nil)

;; (general-def
;;  :keymaps 'override
;;   "C-u" 'universal-argument)
