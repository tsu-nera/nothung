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

;; Twitterで拾った設定だけど若干org-table表示がマシになったので採用.
;; (set-face-attribute 'fixed-pitch nil :font "Ricty Diminished" :height 160)
;; (setq doom-font (font-spec :family "Source Han Code JP" :size 15 ))
;; (setq doom-font (font-spec :family "Ricty Diminished" :size 16))
;; WSL・ネイティブWindowsはHackGen(インストール済)。Source Han Code JPはWindowsに無く、
;; doom-init-fonts-hが失敗するとafter-init-hookが中断しテーマ(doom-init-theme-h)未適用→白画面になる。
;; Linux(CachyOS等)では環境によりインストール済みフォントが異なるため、候補リストから
;; 実際に存在する最初のフォントを選ぶ(find-fontで判定)。これによりフォント未インストールでも
;; 白画面化せず起動できる。日本語グリフはfontconfigのフォールバック(Noto CJK等)に任せる。
(defun nothung--first-available-font (candidates size)
  "CANDIDATES のうち最初にインストール済みのファミリで font-spec を返す。
どれも無ければ \"monospace\" にフォールバックする。"
  (let ((fam (or (seq-find (lambda (f) (find-font (font-spec :family f))) candidates)
                 "monospace")))
    (font-spec :family fam :size size)))
(cond
 ((or (wsl-p) (eq system-type 'windows-nt))
  (setq doom-font (font-spec :family "HackGen" :size 18)))
 (t
  ;; Linux(CachyOS等): 日本語と「コード用Nerd Fontのアイコン/合字」を単一フォントで
  ;; 賄えるフォント(HackGen等)が無い環境向けに、ASCII/コードと日本語(CJK)を分担させる。
  ;;   - ASCII/アイコン: JetBrainsMono Nerd Font (合字・Nerdアイコン入り)
  ;;   - 日本語(漢字・かな): Noto Sans CJK JP をフォールバックに割り当て(下の set-fontset-font)
  ;; 注意: 存在判定の find-font は display の無い daemon 初期化時に常に nil を返す
  ;; (emacs --daemon 起動だと doom-font が monospace に落ちる)。このため:
  ;;   - display あり(直起動 emacs %F): 候補から実在する最良を選ぶ(HackGen等があれば優先)
  ;;   - display なし(emacs --daemon): 確実に存在する既定を直接指定
  ;;     (クライアントフレーム生成時に doom-init-fonts-h がこの font-spec を適用)
  (setq doom-font
        (if (display-graphic-p)
            (nothung--first-available-font
             '("HackGen" "Source Han Code JP"
               "JetBrainsMono Nerd Font" "JetBrainsMono NF" "Noto Sans Mono CJK JP")
             15)
          (font-spec :family "JetBrainsMono Nerd Font" :size 15)))
  ;; CJK(漢字・かな・CJK記号)を Noto Sans CJK JP に割り当てる。
  ;; 既定フォントセット t に設定するため、今後生成される全フレーム(daemon含む)に適用される。
  ;; 対象フォントが無くても set-fontset-font は無害(マッチしないだけ)。
  (dolist (charset '(han kana cjk-misc))
    (set-fontset-font t charset (font-spec :family "Noto Sans CJK JP") nil 'prepend))))
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
