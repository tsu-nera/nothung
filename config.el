;; (require 'org-install)

;; Windows専用: native-compの並列数を org ロード前に絞る(16コア機でCPU飽和・ファン暴走回避)
(when (eq system-type 'windows-nt)
  (setq native-comp-async-jobs-number 4
        native-comp-async-report-warnings-errors 'silent)
  ;; cmigemoが無いWindowsでは(migemo-init)が失敗しnothung.elのロードが中断するため無害化
  ;; (migemo-init はautoloadなので with-eval-after-load では間に合わず、直接 advice する)
  (advice-add 'migemo-init :override #'ignore))

;; nothung設定本体を通常ロード(nothung.org更新時は自動でre-tangle)。
;; Windows固有の停止要因(pdf-tools/migemo)はinit.el・nothung.org側でOSガード済み。
(if (not (eq system-type 'windows-nt))
    (org-babel-load-file "~/.doom.d/nothung.org")
  ;; Windowsでは残りのロードエラーを自動記録(handler-bindでアンワインド前にbacktrace捕捉)
  (condition-case e
      (handler-bind ((error (lambda (_)
                              (ignore-errors
                                (write-region (with-output-to-string (backtrace))
                                              nil (expand-file-name "~/nothung-bt.log") nil 'silent)))))
        (org-babel-load-file "~/.doom.d/nothung.org"))
    (error (write-region (format "NOTHUNG LOAD ABORTED: %S\n" e)
                         nil (expand-file-name "~/nothung-load-errors.log") nil 'silent))))

;; Windows専用: tr-imeでGoogle日本語入力の未確定文字列・変換候補をカーソル位置(over-the-spot)に表示
(when (eq system-type 'windows-nt)
  (tr-ime-advanced-install 'no-confirm)
  (setq default-input-method "W32-IME")
  (w32-ime-initialize)
  (modify-all-frames-parameters '((ime-font . "HackGen-12"))))
