;;; modules/org.el --- Org-mode  (:lang org)  -*- lexical-binding: t; -*-
;;; Commentary:
;; Doom category :lang org.  Migrated from nothung.org (Org-mode).
;;; Code:

;; ご存知！
;; - [[https://github.com/tsu-nera/dotfiles/blob/master/.emacs.d/inits/50_org-mode.org][dotfiles/50_org-mode.org at master · tsu-nera/dotfiles · GitHub]]
;;   - 昔の設定. すこしずつ移植したい.

;;;; ファイルパス
;; ファイルパス関連の定義はまとめてここで実施.
(after! org
  (setq org-directory (file-truename "~/repo/gtd"))

  (defconst my/gtd-projects-file (concat org-directory "/home.org"))
  (defconst my/inbox-file
    (concat org-directory "/inbox/inbox.org"))
  (defconst my/daily-journal-dir
    (concat org-directory "/journals/daily"))
  (defconst my/weekly-journal-dir
    (concat org-directory "/journals/weekly"))
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
         ;; my/daily-journal-dir
         my/gtd-projects-file
         )))

(defun my/create-weekly-org-file (path)
  (expand-file-name (format "%s.org" (format-time-string "%Y-w%V")) path))
(defun my/create-daily-org-file (path)
  (expand-file-name (format "%s.org" (format-time-string "%Y-%m-%d")) path))

(defconst my/weekly-journal-dir "~/repo/keido/notes/zk")

(defconst my/weekly-private-dir "~/repo/gtd/journals/weekly")
(defconst my/daily-private-dir "~/repo/gtd/journals/daily")

;;;; Basics
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
  (setq org-indent-indentation-per-level 1) ;; indent波浅く

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

;;;; org-agenda
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

;;;; TODOキーワード拡張
;; TODOキーワードのカスタマイズ. M-x C-c t.
;; ref. [[https://orgmode.org/manual/TODO-Extensions.html][TODO Extensions (The Org Manual)]]
(setq org-todo-keywords
      '((sequence "📊(a)" "💡(b)" "✅(c)" "👨(d)" "🔬(e)" "👩(f)" "🎨(g)" "|")
        (sequence "📂(h)" "✨(i)" "🔌(k)" "🔗(l)" "📝(m)" "🌳(n)" "|")
        (sequence "🪨(o)" "🧩(p)" "📜(q)" "📍(r)" "🔍(s)" "🔦(t)" "|")
        (sequence "🔧(w)" "🌱(z)" "|")))

;;;; org-capture
;; [[https://orgmode.org/manual/Capture-templates.html][Capture templates (The Org Manual)]]
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
;;;;; capture to daily journal
;; 現状つかってないのでマスク
;; (defun my/create-timestamped-org-file (path)
;;   (expand-file-name (format "%s.org" (format-time-string "%Y%m%d%H%M%S")) path))

(after! org
  (setq org-capture-templates
        (append 
          '(("c" "☑ Planning" plain
             (file+headline
              (lambda () 
                (my/create-weekly-org-file my/weekly-private-dir))
              "Planning")
             "%?"
             :unnarrowed t
             :kill-buffer t)
            ("t" "🤔 Thought" entry
             (file+headline
              (lambda () 
                (my/create-weekly-org-file my/weekly-private-dir))
              "Thoughts")
             "* 🤔 %?\n%T"
             :empty-lines 1
             :unnarrowed t
             :kill-buffer t)
            ("T" "🤔+📃 Thought+Ref" entry
             (file+headline
              (lambda () 
                (my/create-weekly-org-file my/weekly-private-dir))
              "Thoughts")
             "* 🤔 %?\n%T from %a\n"
             :empty-lines 1
             :unnarrowed t
             :kill-buffer t)
            ("l" "🤔+🌐 Thought+Browser" entry
             (file+headline
              (lambda () 
                (my/create-weekly-org-file my/weekly-private-dir))
              "Thoughts")
             "* 🤔 %?\n%T from [[%:link][%:description]]\n"
             :empty-lines 1
             :unnarrowed t
             :kill-buffer t)
            ("p" "🍅 Pomodoro" entry
             (file+headline
              (lambda () 
                (my/create-weekly-org-file my/weekly-private-dir))
              "DeepWork")
             "* 🍅 %?\n%T"
             :empty-lines 1
             :unnarrowed t
             :kill-buffer t)
            ("r" "🧘 Recovery" entry
             (file+headline
              (lambda () 
                (my/create-weekly-org-file my/weekly-private-dir))
              "Recovery")
             "* 🧘 %?\n%T"
             :empty-lines 1
             :unnarrowed t
             :kill-buffer t)
            ("j" "🖊 Journal" plain
             (file 
              (lambda ()
                (my/create-weekly-org-file my/weekly-private-dir)))
             "%?"
             :empty-lines 1
             :unnarrowed t
             :kill-buffer t)
            ("J" "🖊+📃 Journal+Ref" plain
             (file 
              (lambda ()
                (my/create-weekly-org-file my/weekly-private-dir)))
             "%?\n%a"
             :empty-lines 1
             :unnarrowed t
             :kill-buffer t)
            ("L" "🖊+🌐 Journal+Browser" plain
             (file 
              (lambda ()
                (my/create-weekly-org-file my/weekly-private-dir)))
             "%?\nSource: [[%:link][%:description]]\nCaptured On: %U\n"
             :empty-lines 1
             :unnrrowed t
             :kill-buffer t)) org-capture-templates)))
;;;;; capture to project journal
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
;;;;; Google Chrome Extention: Org Capture
;; Google Chromeにを入れることでWeb Pageがorg-captureと連携([[https://chrome.google.com/webstore/detail/org-capture/kkkjlfejijcjgjllecmnejhogpbcigdc?hl=ja][link]]).
;; ChromeでCtrl + Shift + Lで起動.

;;;; org-export(ox)
;; Org-modeのファイルをエクスポートする機能. ox package.
;; サブパッケージが数多くあるが, ここでは共通情報まとめ.
;; org-export-with-xxxという設定項目でいろいろ制御できる.
;; [[https://orgmode.org/manual/Export-Settings.html][Export Settings (The Org Manual)]]
;; しかし, 以下が自動的に変換されてしまう...この文字に対する制御方法が見つからない...
;; - > &gt; 
;; - < &lt;
;; - & &amp;
;; どうもHTML tagとかHTML Entitiesと呼ばれている(ref. [[https://orgmode.org/org.html#Headlines-in-HTML-export][The Org Manual]]).
;; The HTML export back-end transforms ‘<’ and ‘>’ to ‘&lt;’ and ‘&gt;’.
;; ただox-html.elにはこういう設定がdefaultでされている. 他のexportへの移植が必要.
;; [[https://orgmode.org/manual/Advanced-Export-Configuration.html][Advanced Export Configuration (The Org Manual)]]
;; おそらく, exportをかけたあとにhook関数によって文字列変換が必要.
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
;;;;; org-preview-html
;; 今のEmacs, xwidget用にコンパイルしてなかったな...
;; ewwでプレビューできる.
(use-package! org-preview-html)
;;;;; ox-hugo
;; Org-modeで書いたブログ記事をHugoにあったMarkdown形式に変換する.
;; ブログFuturismoはOrg-modeで執筆してこれを利用してMarkdownに変換している.
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
          ))
  ;; WebP画像の自動コピーを有効化
  (add-to-list 'org-hugo-external-file-extensions-allowed-for-copying "webp"))
;; このox-hugoで出力されるMarkdownはどうもリスト表示でスペースが4つ入ってしまう. GitHub Favorite Markdownのようにリストでのスペース２であって欲しいものの解決方法が見つからない.
;;;;; ox-rst
;; Org-modeで書いたWiki用のページをSphinxで公開するためにreST形式に変換する.
;; リンク形式がうまく変換できないのでけっこう強引に変換している(もう少しうまく改善したい).
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
;;;;; ox-qmd
;; GitHub Flavored Markdown.
;; 標準のMarkdownの出力だと見た目が悪い. Bufferに書き出してGitHubとかにコピペするとき用にいれておく.
;; ref. [[https://qiita.com/0x60df/items/3cde67967e3db30d9afe][Org-modeからQiita準拠のMarkdownをexportするパッケージを作ってみました - Qiita]]
(use-package! ox-qmd)
;; ox-gfmは2017からメンテされてないのでやめとくか([[https://github.com/larstvei/ox-gfm/issues/44][ref]]).

;;;; org-babel(ob)
;; Org-modeのなかでLiterature Programming.
;; 基本操作:
;; - C-c C-, コードブロックの挿入テンプレート呼び出し(org-insert-structure-tempate)
;; - C-c C-c コード実行(org-babel-execute-src-block)
;; - C-c C-o コード実行結果を開く(org-babel-open-src-block-result)
;; - C-c ' ソースコード編集(org-edit-src-code)
;;   - どうもEoom Emacsだと keybindingが外れいてる.
;;   - C-c l '(org-edit-special)で開く.
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
    ;; (define-key clojure-mode-map (kbd "C-c C-x k") 'org-edit-src-exit)
    ;; (define-key clojure-mode-map (kbd "C-c C-x q") 'org-edit-src-abort)
    )
;; refs:
;; - [[https://orgmode.org/manual/Key-bindings-and-Useful-Functions.html][org-babel Key bindings and Useful Functions (The Org Manual)]]
;; - [[https://misohena.jp/blog/2017-10-26-how-to-use-code-block-of-emacs-org-mode.html][org-modeのコードブロック(Babel)の使い方 | Misohena Blog]]
;;;;; ob-html
;; [[https://misohena.jp/blog/2021-08-03-execute-html-in-org-mode-code-blocks.html][org-modeのコードブロックでHTMLを「実行」する | Misohena Blog]]
(use-package! ob-html
  :after org
  :config
  ;; C-c C-o でブラウザで開く.
  (org-babel-html-enable-open-src-block-result-temporary))

;;;; org-superstar
;; org-superstar-mode(+pretty option)関連.
;; bulletをおしゃれにかえる. ただそれと引き換えにパフォーマンスはちょっと落ちるかも.

;;;; org-roam
;; Zettelkasten MethodのOrg-roam実装.
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
    ;; org-roam-db-autosync-enable は起動時に DB 全同期(org-roam-db-sync)を一度走らせる。
    ;; ノート数千件 + Windows の遅いファイルI/O(Defender スキャン含む)で、これが起動時間の
    ;; ほぼ全て(実測 130〜160 秒)を占めていた。起動フレームをブロックしないよう、
    ;; 初回アイドル時(5秒)まで遅延させる。Linux でも害は無い。
    (run-with-idle-timer 5 nil #'org-roam-db-autosync-enable)

    ;; (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))

    ;; for emacs 29~
    ;; (when (>= emacs-major-version 29)
    ;; (setq org-roam-database-connector 'sqlite-builtin))
  )
(setq org-roam-db-node-include-function
      (lambda ()
        (not (member "" (org-get-tags)))))
;;;;; consult-org-roam(Org-roam検索強化)
;; ref. https://github.com/jgru/consult-org-roam
;; 以下の機能を提供.ファイル名は今は日付にしているからいらないかな.全文検索は動かない.バックリンク検索だけ使えそう.
;; - ファイル名検索
;; - バックリンク検索
;; - 全文検索
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
;;;;; Org-roam管理下のノートの全文検索
;; [[https://org-roam.discourse.group/t/using-consult-ripgrep-with-org-roam-for-searching-notes/1226][Using consult-ripgrep with org-roam for searching notes - How To - Org-roam]]
;; consult-ripgrepを [[https://jblevins.org/projects/deft/][deft]] の代わりに使う. より高速.
;; 検索対象が多すぎるとハングするので改善したい.
(defun my/org-roam-rg-search ()
  "Search org-roam directory using consult-ripgrep. With live-preview."
  (interactive)
  (consult-ripgrep org-roam-directory))
(global-set-key (kbd "C-c r s") 'my/org-roam-rg-search)
;;;;; org-publish(Org-roamのノートをサイトへ公開)
;; hugo用. 現状exit abnormally で動かないので調べる.
;; html用.
;;;;; org-roam-dailies
;; Org-roamに組み込まれた劣化版org-journal. 現状使用するのをやめた.
;; org-roam-dialiesよりもorg-journalを利用する(org-agendaの都合).
;; ref. [[https://org-roam.discourse.group/t/org-journal-vs-org-roam-dailies/384][Org-journal vs org-roam-dailies - Troubleshooting - Org-roam]]
;; 週単位で日記のようなページを外部公開用に使う.
;; ツイッターのようなマイクロブログの利用を想定している.
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
;;;;; org-roam-ui(disabled)
;; Web UI.
;;;;; org-roam-timestamps(disabled)
;; org-roam-uiでつかうメタ情報を付与することが目的だが現状使っていないのでいったん封印.
;;;;; org-roamのslowdownを回避するTip
;; https://www.reddit.com/r/orgmode/comments/s8xv5j/orgroam_slows_down_as_nodes_increase_solution/
;; 2. Memoize the function that costs the most.
;; memoize は packages.el で宣言した MELPA パッケージを使う
;; (旧運用では private/memoize.el を vendor していたが、マシン固有の private/
;;  配下に依存すると新規環境で起動できないためパッケージ管理へ移行した)。
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

;;;; org-toggl
;; org-modeをTogglと連携させる.
;; https://github.com/mbork/org-toggl

;;;; org-journal
;; https://github.com/bastibe/org-journal
(use-package! org-journal
  :after org
  :bind
  ;; org-roamと揃えたいので C-c rまでをprefixにする.
  ("C-c r d n" . org-journal-new-entry)
  ("C-c r d d" . org-journal-open-current-journal-file)
  :config
  (setq org-journal-date-prefix "#+TITLE: ✍")
  ;; (setq org-journal-file-type `daily)
  ;; (setq org-journal-file-format "%Y-%m-%d.org")
  ;; (setq org-journal-date-format "%Y-%m-%d")
  ;; これはorg-journalの変数ではない.
  (setq org-journal-file-format "%Y-w%V.org")
  (setq org-journal-date-format "%Y-w%V")
  (setq org-journal-file-type `weekly)
  (setq org-journal-dir my/weekly-private-dir)
  ;; (setq org-journal-enable-agenda-integration t)
)

;;;; org-ref(bibtex)
;; 文献管理. Zoteroと連携して，論文というよりは書籍やYoutube動画やWeb記事のメモに利用.
;; - org-ref
;; - ivy-bibtex
;;   - ivyのactionは ivy-bibtexでC-SPCで選択-> C-M-oでaction選択候補を出し，pとかeとか押す.
;; - org-roam-bibtex
;; なんかzoteroからデータエクスポートできなくなって動かなくなった.
;; なんかorg-mode開くたびにreloadが走るのでmaskした.
;; つかってないのでエラーたのでいったんマスク.

;;;; org-anki
;; Org-modeとAnkiをつなぐ.
;; https://github.com/eyeinsky/org-anki
;; 今までanki-editorを利用していたものの，その記法とwikiの相性が悪かった（冗長）. これならorg-modeのheadlineがそのままつかえるのでよさそう.
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
;; URLの挿入はorg-link形式でできる. これは便利.

;;;; org-bars(deprecated)
;; 今どきのアウトライナー的な線を出す.
;; - Terminal Mode ではつかえない.
;; - リストの折返しでのインデントは崩れる.
;; <2025-11-12 Wed 16:25> 表示が気持ち悪くなったので無効化.

;;;; Org-noter(disabled)
;; PDFの注釈を管理する. [[https://github.com/weirdNox/org-noter][:link:weirdNox/org-noter]]
;; はじめの起動がどうやればいいのかワカラなかった. 特定のファイルに記録を残したい場合はPDFのBufferではなく, 適当なheading作成してM-x org-noterを起動するとPDFを選択できる.
;; M-x org-noter-create-skeltonという関数がヤばい. [[https://youtu.be/lCc3UoQku-E?t=68][🔗Youtube動画(1:08)]] PDFからOutlineを抜き出してOrg fileに生成して，あとはそのOrg-fileのBulletのカーソルを移動するとPDFのほうもシンクロして移動できる. 
;; 凄すぎて笑った😂

;;;; org-trello(disabled)
;; Kanbanツール Trello連携. 
;; - refs.
;;   - [[http://org-trello.github.io/][org-trello(official)]]
;;   - [[https://github.com/org-trello/org-trello][GitHub - org-trello/org-trello]]
;; 古いプロジェクトだがメンテもされていてスターも500以上ついている.
;; ただし動かない...native comp無効で行けるか. -> いけた.
;; https://github.com/org-trello/org-trello/issues/418
;; どうもDoom Emacsだと C-uが効かない. そしてそれによってtrello->org-fileへのdownloadがC-u C-c o sに頼っているので不便になる. *(org-trello-sync-buffer t)* を評価するとダウンロードが走るという仕様のためこれを関数にして呼ぶことによって代替.
;; [[https://github.com/org-trello/org-trello/issues/409][Synching from and to Trello does not work · Issue #409]]

;;;; org-table
(setq org-table-export-default-format "orgtbl-to-csv")

;;;; org-sidebar
;; https://github.com/alphapapa/org-sidebar
;; org-sidebar-treeでサイドバーにアウトラインを表示.

;;;; Org timestamps
;; org-mode で timestamp のみを挿入するカスタム関数. Doom EmacsのせいでC-u C-c .が動作しないので.
(after! org
  (defun my/insert-timestamp ()
    (interactive)
    (org-insert-time-stamp (current-time) t))
  (defun my/insert-timestamp-inactive ()
    (interactive)
    (org-time-stamp-inactive (current-time)))
  (map! :map org-mode-map "C-u C-c C-." #'my/insert-timestamp-inactive)
  (map! :map org-mode-map "C-c C-." #'my/insert-timestamp))
;; ---
;; 空白が保存時に削除されると bullet 表示がおかしくなる.
;; なお wl-bulter は doom emacs のデフォルトで組み込まれている.
(add-hook! 'org-mode-hook
  (when (fboundp 'ws-butler-mode)
    (ws-butler-mode -1)))

;;;; org-pomodoro

;;;; org-web-tools
;; ewwとorgを便利にするツール群(https://github.com/alphapapa/org-web-tools).
(use-package! org-web-tools
  :bind
  ("C-c i l" . org-web-tools-insert-link-for-url))

;;;; org-ai
;; https://github.com/rksm/org-ai
;; openai-api-tokenの設定が必要. private/config.elで定義している.
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

(provide 'nothung-org)
;;; modules/org.el ends here
