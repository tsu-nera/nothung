;;; modules/os.el --- Os  (:os)  -*- lexical-binding: t; -*-
;;; Commentary:
;; Doom category :os.  Migrated from nothung.org (Os).
;;; Code:

;; OS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; EXWM
;; EmacsのWindow Manager.
;; もはやこれをつかうと世界がEmacsになりEmacs 引きこもり生活が完成する.
;; counsel-linux-appだと起動時にハングしてPC再起動になることが多い. Shift+Alt+&によるアプリケーション起動がいいかも. 
(use-package! exwm
  :if (not (wsl-p))
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

(provide 'nothung-os)
;;; modules/os.el ends here
