;;; utils.el -*- lexical-binding: t; -*-

(defun wsl-p ()
  "Return t if the WSL_DISTRO_NAME environment variable is empty or undefined."
  (let ((distro-name (getenv "WSL_DISTRO_NAME")))
    (not (= (length distro-name) 0))
    ))

(defun my-browse-url-wsl-host-browser (url &rest _args)
  "Browse URL with WSL host web browser.
  https://qiita.com/tadsan/items/8c66e7d753a1b24acd4e"
  (prog1 (message "Open %s" url)
    (shell-command-to-string
     (mapconcat #'shell-quote-argument
                (list "cmd.exe" "/c" "start" url)
                " "))))

(when (wsl-p)
  (setopt browse-url-browser-function #'my-browse-url-wsl-host-browser))

(defun copy-file-path ()
  "Copy the current buffer file path to clipboard."
  (interactive)
  (when buffer-file-name
    (kill-new buffer-file-name)
    (message "Copied: %s" buffer-file-name)))

(global-set-key (kbd "C-c p") 'copy-file-path)
