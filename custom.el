(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((eval setq-local org-roam-db-location
           (expand-file-name "org-roam.db" org-roam-directory))
     (eval setq-local org-roam-directory
           (expand-file-name
            (locate-dominating-file default-directory ".dir-locals.el")))))
 '(warning-suppress-log-types '((org-roam) (before-save-hook)))
 '(warning-suppress-types '((before-save-hook))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
