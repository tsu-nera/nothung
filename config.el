;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; doom specific config
;; あとでプライベートな宣言方法うしらべる.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")
;;
;; どうもフォントが奇数だとorg-tableの表示が崩れる.
;; Source Han Code JPだとそもそもorg-tableの表示が崩れる.
(setq doom-font (font-spec :family "Source Han Code JP" :size 13 ))

(setq doom-theme 'doom-one)
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
  (define-key view-mode-map (kbd "p") 'View-scroll-line-backward)
  (define-key view-mode-map (kbd "n") 'View-scroll-line-forward)
  ;; defaultのeでもいいけど，mule時代にvにbindされてたので, emacsでもvにbindしておく.
  (define-key view-mode-map (kbd "v") 'read-only-mode))

;; org-mode
;; https://github.com/hlissner/doom-emacs/blob/develop/modules/lang/org/README.org
;; https://github.com/tsu-nera/dotfiles/blob/master/.emacs.d/inits/50_org-mode.org

;; スマホとの共有のため, githubをcloneしたものをDropboxに置いて$HOMEにsymlinkしている.
(after! org
  (setq org-directory "~/gtd")
  (setq org-default-notes-file "main.org")

  (setq org-return-follows-link t) ;; Enterでリンク先へジャンプ
  (setq org-use-speed-commands t)  ;; bulletにカーソルがあると高速移動
  (setq org-hide-emphasis-markers t)

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
  (setq org-agenda-files '("~/gtd"))
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
  ;; とりあえずnotes以下は最適化のために保留.
  ;; 時間が絡むものはorg-roamで扱わないほうがいいのかな? もしくは，notes/dialy限定
  (setq org-agenda-files '("~/gtd/main.org"
                           "~/gtd/futurismo.org"
                           "~/gtd/journal.org"
                           "~/gtd/notes/journal/"
                           "~/gtd/inbox.org"))
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
        '(("i" "Inbox" entry (file "~/gtd/inbox.org") "* %T %?\n")
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

;; org-roam
(setq org-roam-directory "~/gtd/notes")
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
        "T" #'org-roam-tag-remove)
  :custom
  (org-roam-dailies-directory "journal/")
  (org-roam-dailies-capture-templates
     '(("d" "default" entry "* %T %?\n"
        :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n")
        :unnarrowed t)))
  ;; :bind (("C-c r l" . org-roam-buffer-toggle)
  ;;        ("C-c r f" . org-roam-node-find)
  ;;        ("C-c r i" . org-roam-node-insert)
  ;;        :map org-mode-map
  ;;        ("C-M-i"    . completion-at-point)
  ;;        :map org-roam-dailies-map
  ;;        ("Y" . org-roam-dailies-capture-yesterday)
  ;;        ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c r d" . org-roam-dailies-map)
  :config
  (setq org-roam-completion-everywhere nil)
  (require 'org-roam-dailies) ; Ensure the keymap is available
  (org-roam-db-autosync-mode))


;; (use-package! websocket
;;     :after org-roam)
;; (use-package! org-roam-ui
;;     :after org-roam ;; or :after org
;; ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;; ;;         a hookable mode anymore, you're advised to pick something yourself
;; ;;         if you don't care about startup time, use
;; ;;  :hook (after-init . org-roam-ui-mode)
;;     :config
;;     (setq org-roam-ui-sync-theme t
;;           org-roam-ui-follow t
;;           org-roam-ui-update-on-save t
;;           org-roam-ui-open-on-start t))

;; 今どきのアウトライナー的な線を出す.
(require 'org-bars)
(add-hook! 'org-mode-hook #'org-bars-mode)

;; twittering-mode
;; この設定がないと認証が失敗した.
;; twittering-oauth-get-access-token: Failed to retrieve a request token
(add-hook! 'twittering-mode-hook
  (setq twittering-allow-insecure-server-cert t))

(add-hook! writeroom-mode
  (setq +zen-text-scale 1))

;; 読書のためのマーカー（仮）
;; あとでちゃんと検討と朝鮮しよう.
(setq org-emphasis-alist
  '(("*" bold)
    ("/" italic)
    ("_" underline)
    ("=" (:background "red" :foreground "white")) ;; 書き手の主張
    ("~" (:background "blue" :foreground "white"))　;; 根拠
    ("+" (:background "green" :foreground "black")))) ;; 自分の考え

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
