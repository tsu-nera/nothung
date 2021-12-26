;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; doom specific config
;; あとでプライベートな宣言方法うしらべる.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")
;;
;; どうもフォントが奇数だとorg-tableの表示が崩れる.
;; Source Han Code JPだとそもそもorg-tableの表示が崩れる.
;; terminalだと大丈夫な模様.そもそもTerminalはこの設定ではなくてTerminal Emulatorの設定がきく.
(setq doom-font (font-spec :family "Source Han Code JP" :size 12 ))

(setq doom-theme 'doom-molokai)
(doom-themes-org-config)

;; general config
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(set-default 'buffer-filecoding-system 'utf-8)

(setq display-line-numbers-type t) ; 行番号表示
(setq confirm-kill-emacs nil) ; 終了時の確認はしない.

;; フルスクリーンでEmacs起動
;; ブラウザと並べて表示することが多くなったのでいったんマスク
;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; memo:
;; use-package! は:defer, :hook, :commands, or :afterが省略されると起動時にloadされる.
;; after! はpackageがloadされたときに評価される.
;; add-hook! はmode有効化のとき. setq-hook!はequivalent.
;; どれを使うかの正解はないがすべてuse-package!だと起動が遅くなるので
;; 場合によってカスタマイズせよ，とのこと.
;; https://github.com/hlissner/doom-emacs/blob/develop/docs/getting_started.org#configuring-packages

(use-package! fcitx
  :config
  (setq fcitx-remote-command "fcitx5-remote")
  (fcitx-aggressive-setup)
  ;; Linuxなら t が推奨されるものの、fcitx5には未対応なためここはnil
  (setq fcitx-use-dbus nil))

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

;; lessでのファイル閲覧に操作性を似せるmode.
;; view-modeはemacs内蔵. C-x C-rでread-only-modeでファイルオープン
;; doom emacsだと　C-c t r で　read-only-modeが起動する.
(add-hook! view-mode
  (setq view-read-only t)
  (define-key ctl-x-map "\C-q" 'view-mode) ;; assinged C-x C-q.

  ;; less っぼく.
  (define-key view-mode-map (kbd "p") 'view-scroll-line-backward)
  (define-key view-mode-map (kbd "n") 'view-scroll-line-forward)
  ;; defaultのeでもいいけど，mule時代にvにbindされてたので, emacsでもvにbindしておく.
  (define-key view-mode-map (kbd "v") 'read-only-mode))

;; org-mode
;; https://github.com/hlissner/doom-emacs/blob/develop/modules/lang/org/README.org
;; https://github.com/tsu-nera/dotfiles/blob/master/.emacs.d/inits/50_org-mode.org

;; スマホとの共有のため, githubをcloneしたものをDropboxに置いて$HOMEにsymlinkしている.
(after! org
  (setq org-directory "~/keido")
  (setq org-default-notes-file "gtd/gtd_projects.org")

  (setq org-return-follows-link t) ;; Enterでリンク先へジャンプ
  (setq org-use-speed-commands t)  ;; bulletにカーソルがあると高速移動
  (setq org-hide-emphasis-markers t) ;; * を消して表示.

  ;; M-RETの挙動の調整
  ;; tだとsubtreeの最終行にheadingを挿入, nilだとcurrent pointに挿入
  ;; なお，C-RETだとsubtreeの最終行に挿入され, C-S-RETだと手前に挿入される.
  (setq org-insert-heading-respect-content nil)

  (setq org-startup-indented t)
  (setq org-indent-mode-turns-on-hiding-stars nil)

  (setq org-startup-folded 'show2levels);; 見出しの階層指定
  (setq org-startup-truncated nil) ;; 長い文は折り返す.

  ;; org-babelのソースをキレイに表示.
  (setq org-src-fontify-natively t)
  (setq org-fontify-whole-heading-line t)

  ;; electric-indentはorg-modeで誤作動の可能性があることのこと
  ;; たまにいきなりorg-modeのtree構造が壊れるから，とりあえず設定しておく.
  ;; この設定の効果が以下の記事でgifである.
  ;; https://www.philnewton.net/blog/electric-indent-with-org-mode/
  (add-hook! org-mode (electric-indent-local-mode -1))

  ;; org-agenda
  (setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
  (setq org-agenda-time-leading-zero t) ;; 時間表示が 1 桁の時, 0 をつける
  (setq calendar-holidays nil) ;; 祝日を利用しない.
  (setq org-log-done 'time);; 変更時の終了時刻記録.

  ;; スケジュールやデッドラインアイテムは DONE になっていれば表示する
  (setq org-agenda-skip-deadline-if-done nil)
  (setq org-agenda-skip-scheduled-if-done nil)

  (setq org-agenda-include-inactive-timestamps t) ;; default で logbook を表示
  (setq org-agenda-start-with-log-mode t) ;; ;; default で 時間を表示

  ;; org-agenda speedup tips
  ;; https://orgmode.org/worg/agenda-optimization.html

  ;; 何でもかんでもagendaすると思いので厳選.
  (setq org-agenda-files '("~/keido/zk/gtd/gtd_projects.org"
                           "~/keido/zk/logs/daily"))

  ;; 期間を限定
  (setq org-agenda-span 30)
                                        ; Inhibit the dimming of blocked tasks:
  (setq org-agenda-dim-blocked-tasks nil)
  ;; Inhibit agenda files startup options:
  (setq org-agenda-inhibit-startup nil)
  ;; Disable tag inheritance in agenda:
  (setq org-agenda-use-tag-inheritance nil)

  ;; org-capture
  ;; 使いこなせてないな...
  (setq org-capture-templates
        '(("i" "Inbox" entry (file "~/keido/inbox/inbox.org") "* %T %?\n")
          ;;        ("j" "Journal" entry (file+headline "~/gtd/journal.org" "Journal")
                                        ;         "* %?\nEntered on %U\n %i\n %a")
          ;;        ("d" "Daily Log" entry (function org-journal-find-location)
          ;;                               "* %(format-time-string org-journal-time-format)%i%?")
          ))

  ;; org-babel
  ;; 評価でいちいち質問されないように.
  (setq org-confirm-babel-evaluate nil)
  ;; org-babel で 実行した言語を書く. デフォルトでは emacs-lisp だけ.
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((lisp . t)
     (shell . t)))
  )

;; org-modeでtimestampのみを挿入するカスタム関数(hh:mm)
(after! org
  (defun my/insert-timestamp ()
    "Insert time stamp."
    (interactive)
    (insert (format-time-string "%H:%M")))
 (map! :map org-mode-map "C-c C-." #'my/insert-timestamp))

;; +pretty(org-superstar-mode)関連
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
(setq org-n-level-faces 4)
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
(setq org-superstar-headline-bullets-list
      '("◉" ("🞛" ?◈) "○" "▷"))
;; (setq org-superstar-special-todo-items t)

;; Stop cycling bullets to emphasize hierarchy of headlines.
(setq org-superstar-cycle-headline-bullets nil)
;; Hide away leading stars on terminal.
;; (setq org-superstar-leading-fallback ?\s)
(setq inhibit-compacting-font-caches t)

;; org-roam
(setq org-roam-directory (file-truename "~/keido/zk"))
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
        "s" #'org-roam-db-sync
        "u" #'org-roam-update-org-id-locations
        )
  :custom
  ;; ファイル名をIDにする.
  (org-roam-capture-templates
   '(("d" "default" plain "%?"
      :target (file+head "%<%Y%m%d%H%M%S>.org"
                         "#+title: ${title}\n")
      :unnarrowed t)))
  (org-roam-extract-new-file-path "%<%Y%m%d%H%M%S>.org")
  (org-roam-dailies-directory "logs/daily/")
  (org-roam-dailies-capture-templates
   '(("d" "default" item "%?"
      :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n")
      :unnarrowed t)))
  ;;        :map org-mode-map
  ;;        ("C-M-i"    . completion-at-point)
  ;;        :map org-roam-dailies-map
  ;;        ("Y" . org-roam-dailies-capture-yesterday)
  ;;        ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c r d" . org-roam-dailies-map)
  :config
  (setq +org-roam-open-buffer-on-find-file nil)
  (require 'org-roam-dailies) ; Ensure the keymap is available
  (org-roam-db-autosync-mode))


(use-package! websocket
    :after org-roam)
(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
    ;; :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(use-package! org-roam-timestamps
   :after org-roam
   :config
   (org-roam-timestamps-mode))

;; 今どきのアウトライナー的な線を出す.
;; Terminal Modeではつかえないので一旦無効化する.
;; (require 'org-bars)
;; (add-hook! 'org-mode-hook #'org-bars-mode)

;; twittering-mode
;; この設定がないと認証が失敗した.
;; twittering-oauth-get-access-token: Failed to retrieve a request token
(add-hook! 'twittering-mode-hook
  (setq twittering-allow-insecure-server-cert t))

(add-hook! writeroom-mode
  (setq +zen-text-scale 1))

;; 読書のためのマーカー（仮）
;; あとでちゃんと検討と朝鮮しよう.
;; (setq org-emphasis-alist
;;   '(("*" bold)
;;     ("/" italic)
;;     ("_" underline)
;;     ("=" (:background "red" :foreground "white")) ;; 書き手の主張
;;     ("~" (:background "blue" :foreground "white"))　;; 根拠
;;     ("+" (:background "green" :foreground "black")))) ;; 自分の考え

;; org-clock関連
(require 'org-toggl)
(setq toggl-auth-token "4b707d3e5bc71cc5f0010ac7ea76185d")
(setq org-toggl-inherit-toggl-properties nil)
(org-toggl-integration-mode)

(use-package! ox-hugo
  :after 'ox)

;; 空白が保存時に削除されるとbullet表示がおかしくなる.
;; なおwl-bulterはdoom emacsのデフォルトで組み込まれている.
(add-hook! 'org-mode-hook (ws-butler-mode -1))

;; org-roamのcompletion-at-pointが動作しないのはこいつかな...
;; (add-hook! 'org-mode-hook (company-mode -1))
;; companyはなにげに使いそうだからな，TABでのみ補完発動させるか.
(setq company-idle-delay nil)
(global-set-key (kbd "TAB") #'company-indent-or-complete-common)

(use-package! deft
  :after org
  :bind
  ("C-c r j" . deft)
  :config
  (setq deft-default-extension "org")
  (setq deft-directory org-directory)
  (setq deft-recursive t)
  (setq deft-strip-summary-regexp ":PROPERTIES:\n\\(.+\n\\)+:END:\n")
  (setq deft-use-filename-as-title nil)
  ;; (setq deft-use-filter-string-for-filename t)
  ;; (setq deft-org-mode-title-prefix t)
  ;;
  ;; deftでorg-roamのtitleをparseするためのworkaround
  ;; see: https://github.com/jrblevin/deft/issues/75
  (advice-add 'deft-parse-title :override
    (lambda (file contents)
      (if deft-use-filename-as-title
          (deft-base-filename file)
        (let* ((case-fold-search 't)
               (begin (string-match "title: " contents))
               (end-of-begin (match-end 0))
               (end (string-match "\n" contents begin)))
          (if begin
              (substring contents end-of-begin end)
            (format "%s" file))))))
  )

;; elfeed
(global-set-key (kbd "C-x w") 'elfeed)

(use-package! elfeed
  :config
  (setq elfeed-feeds
        '("https://futurismo.biz")))
