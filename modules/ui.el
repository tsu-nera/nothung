;;; modules/ui.el --- UI  (:ui)  -*- lexical-binding: t; -*-
;;; Commentary:
;; Doom category :ui.  Migrated from nothung.org (UI).
;;; Code:

;; みため周りの設定.

;;;; Doom
;; UI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; どうもフォントが奇数だと org-table の表示が崩れる.
;; Source Han Code JP だとそもそも org-table の表示が崩れる.
;; terminal だと大丈夫な模様.そもそも Terminal はこの設定ではなくて 
;; Terminal Emulator の設定がきく.

;; フォントは全環境で HackGen Console NF / size 20 に統一(WSL2/Windows/CachyOS
;; いずれもインストール済み)。HackGen は ASCII・日本語(CJK)・Nerd アイコン・合字を
;; 1フォントで賄うため、CJK フォールバック(set-fontset-font)も候補リストからの
;; find-font 探索も不要。なお family を実在する1つに固定するため、daemon 初期化時
;; (find-font が nil を返す)でも doom-init-fonts-h が monospace に落ちることはない。
(setq doom-font (font-spec :family "HackGen Console NF" :size 20))
;; doom-molokaiやdoom-monokai-classicだとewwの表示がいまいち.
(setq doom-theme 'doom-molokai)
(doom-themes-org-config)

;; counselとdoom-modelineが相性悪いようなので
;; workspace name表示のためには追加で設定.
;; https://github.com/hlissner/doom-emacs/issues/314
;; (after! doom-modeline
;;  (setq doom-modeline-icon (display-graphic-p))
;;  (setq doom-modeline-major-mode-icon t))
;; https://github.com/seagle0128/doom-modeline

;;;; emojify
;; Emacsで絵文字をつかう.
;; どうもemojifyの絵文字辞書は，emojione-v2.2.6-22というものでやや古い.
;; Twitterが好きなのでTwitterのオープンソース辞書のtwemojiに変更.
;; https://github.com/iqbalansari/emacs-emojify/blob/master/data/emoji-sets.json
(after! emojify
  ;; openmoji v13に変更(カラー・線画風)。各環境で初回セットアップが必要:
  ;;   M-x emojify-download-emoji RET openmoji-v13-0
  ;;   → 展開先dirが "openmoji-v13.0" になる不一致があるので emojify-emojis-dir 内で
  ;;     "openmoji-v13-0"(ハイフン) にリネームする(emojify-image-dirがハイフン名を探すため)
  ;; 既知の制約: emojify同梱の認識データが古く、🥳(U+1F973,2018)等の最新codepointは
  ;;   画像があっても認識されず描画されない。最新まで出すならSegoe UI Emoji等のフォント描画が要る
  (setq emojify-emoji-set "openmoji-v13-0"))
;; ただ，2022現在twemojiはv13なのでv2は古いな..というかでないやつもおおい.
;; Emacsの機能でemoji-searchがあるのでこれも設定しておこう. 
;; こっちの辞書のほうが扱える文字か多い.
;; doomだと C-c i eでemojify-insert-emoji
(global-set-key (kbd "C-c i E") 'emoji-search)

;;;; svg-tag-mode
;; TODOほかラベルを美しく. 
;; [[https://github.com/rougier/svg-tag-mode][GitHub - rougier/svg-tag-mode]]
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

;;;; Others
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

(provide 'nothung-ui)
;;; modules/ui.el ends here
