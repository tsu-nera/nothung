;;; modules/ai.el --- AI  (custom (AI))  -*- lexical-binding: t; -*-
;;; Commentary:
;; Doom category custom (AI).  Migrated from nothung.org (AI).
;;; Code:

;; いろいろあるので試すがつかうのは一つにしたいところ. 
;; - https://github.com/karthink/gptel

;;;; chatgpt
;; https://github.com/emacs-openai/chatgpt

;;;; chatgpt-shell
;; chatgpt-shell-openai-keyはconfig.elに記載. ChatGPT以外でもいける.
;; https://github.com/xenodium/chatgpt-shell
(use-package! chatgpt-shell
  :commands chatgpt-shell
  :init
  (bind-key "C-c z b" 'chatgpt-shell)
  :config
  (setq chatgpt-shell-chatgpt-streaming t))

;;;; Ellama
;; https://github.com/s-kostyaev/ellama/

;;;; Claude code IDE
;; https://github.com/manzaltu/claude-code-ide.el
(use-package! claude-code-ide
  :bind (("C-c z c" . claude-code-ide)
         ("C-c C-7" . claude-code-ide-menu)
         ("C-c C-r" . claude-code-ide-insert-at-mentioned)
         :map vterm-mode-map
         ("M-RET" . claude-code-ide-insert-newline))
  :config
  (setq exec-path (append exec-path '("~/.local/bin")))
  (setq claude-code-ide-window-side 'left)
  (setq claude-code-ide-cli-extra-flags "--dangerously-skip-permissions")
  (claude-code-ide-emacs-tools-setup))
;;;;; vterm
;; 内部ではvtermをつかっている. read-only-modeとなっている. vterm-yankで貼り付け.
;; C-y はEvil modeの別バインドが優先されるため、vterm バッファで明示的に vterm-yank を割り当てる。
;; vterm-copy-mode に入るとカーソルの点滅が止まる問題がある。これは vterm がターミナルエスケープシーケンスで
;; カーソルタイプを上書きするため。copy-mode 突入時に =cursor-type= を明示的にリセットし、
;; =blink-cursor-mode= を再起動することで修正する。
(after! vterm
  (define-key vterm-mode-map (kbd "C-y") #'vterm-yank)
  ;; vterm-copy-mode に入るとカーソル点滅が止まる問題の修正
  ;; vterm がエスケープシーケンスで cursor-type を上書きするため、明示的にリセットが必要
  (add-hook 'vterm-copy-mode-hook
            (lambda ()
              (when vterm-copy-mode
                (setq-local cursor-type '(box . 1))
                (blink-cursor-mode -1)
                (blink-cursor-mode 1)))))
;;;;; Windows: shell(bash) と fish端末(mintty)
;; ネイティブWindowsではvtermがビルド不可(POSIX端末/termios不在)なので代替を用意する。
;; - Emacs内シェルは =M-x shell= をMSYS2 bashに設定(eshell/PSは使わない)。コマンド作業向け。
;;   =shell-command= 等が使う =shell-file-name= は触らず、対話shell専用の =explicit-*= だけ変える。
;; - fishはネイティブ版が無くPTY前提でEmacs内(comint)では不安定なため、フル機能のfishは
;;   外部mintty端末で起動する。 =msys2_shell.cmd= が環境変数を正しく設定する。
(when (eq system-type 'windows-nt)
  ;; M-x shell を MSYS2 bash にする(ログイン+対話)
  (setq explicit-shell-file-name "C:/msys64/usr/bin/bash.exe"
        explicit-bash.exe-args '("--login" "-i"))
  ;; 外部mintty で fish(UCRT64環境) を起動
  (defun my/mintty-fish ()
    "MSYS2 mintty で fish を起動する(UCRT64環境)。"
    (interactive)
    (start-process "msys2-fish" nil "cmd.exe" "/c"
                   "C:\\msys64\\msys2_shell.cmd" "-defterm" "-here" "-ucrt64" "-shell" "fish"))
  (map! :leader :desc "fish端末(mintty)" "o f" #'my/mintty-fish))

(provide 'nothung-ai)
;;; modules/ai.el ends here
