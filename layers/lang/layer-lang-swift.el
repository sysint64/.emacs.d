(use-package swift-mode :ensure t)

(defun xcode-open-current-file()
  (interactive)
  (shell-command-to-string
    (concat "open -a \"/Applications/Xcode.app\" " (buffer-file-name))))

(defun xcode-build()
  (interactive)
  (xcode-open-current-file)
  (shell-command-to-string
    "osascript -e 'tell application \"Xcode\"' -e 'set targetProject to active workspace document' -e 'build targetProject' -e 'end tell'"))

(defun xcode-run()
  (interactive)
  (xcode-open-current-file)
  (shell-command-to-string
    "osascript -e 'tell application \"Xcode\"' -e 'set targetProject to active workspace document' -e 'stop targetProject' -e 'run targetProject' -e 'end tell'"))

(defun xcode-test()
  (interactive)
  (shell-command-to-string
    "osascript -e 'tell application \"Xcode\"' -e 'set targetProject to active workspace document' -e 'stop targetProject' -e 'test targetProject' -e 'end tell'"))

(defun print-swift-var-under-point()
  (interactive)
  (if (string-match-p (string (preceding-char)) "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
      (backward-sexp)
    nil)
  (kill-sexp)
  (yank)
  (move-end-of-line nil)
  (newline)
  (insert "print(\"")
  (yank)
  (insert ": \\(")
  (yank)
  (insert ")\")")
  (indent-for-tab-command))

(defhydra hydra-swift (swift-mode-map "<escape>")
  "Command"
  ("xb" xcode-build :exit t)
  ("xr" xcode-run :exit t)
  ("xt" xcode-test :exit t)
  ("xf" xcode-open-current-file :exit t)
  ("lp" print-swift-var-under-point :exit t))

(provide 'layer-lang-swift)
