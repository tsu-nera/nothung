;;; modules/emacs.el --- Emacs  (:emacs)  -*- lexical-binding: t; -*-
;;; Commentary:
;; Doom category :emacs.  Migrated from nothung.org (Emacs).
;;; Code:

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

;;;; Copy file path with line
;; ファイルパスと行番号をコピーする。Claude Codeでのコード参照形式（file_path:line_number）に対応。
;; - +default/yank-buffer-path
(defun my/copy-file-path-with-line ()
  "Copy the current buffer's file path with line number."
  (interactive)
  (let ((path-with-line
         (concat (buffer-file-name) ":" (number-to-string (line-number-at-pos)))))
    (kill-new path-with-line)
    (message "%s" path-with-line)))

(map! :leader
      :desc "Copy file path with line"
      "f Y" #'my/copy-file-path-with-line)

;;;; recentf
;; けっこうrecentfでハングすることが多いので少なくする. 
;; recentfに保存する数. 
(setq recentf-max-saved-items 300)

;;;; Emacs ガーベジコレクション
;; ガーベジコレクションでEmacsのつかうメモリを最適化する. 
;; ガーベジコレクションが走る間隔が多ければ途中で重くなるが, 低スペックPCだとガーベジコレクションをこまめに走らせることで全体的に軽くすることも. 要調整. 
;; GCを減らして軽くする.
;; (setq gc-cons-threshold (* gc-cons-threshold 10))
;; GCの上限閾値をあえて下げる(低スペックPC)
;; (setq gc-cons-threshold (/ gc-cons-threshold 10))

;; どうもDoom だとデフォルトで大きな値が設定されている模様なので戻す. 
;; (setq gc-cons-percentage 0.1)
;; (setq gc-cons-threshold 800000)
;; GC実行のメッセージを出す
(setq garbage-collection-messages nil)

;;;; ace-window
;; 3つ以上のwindowの選択が番号でできる. defaultでC-x oを上書きしてる? C-u C-x o だとwindowをswapできる(ace-swap-window).

;;;; undo-tree
;; ビジュアライズされたundoを提供. 
;; C-x uでvisualizerのバッファを開く. qで終了. 

;;;; Helpful
;; Emacsの*Help Bufferを強化する. 
;; https://github.com/Wilfred/helpful

(provide 'nothung-emacs)
;;; modules/emacs.el ends here
