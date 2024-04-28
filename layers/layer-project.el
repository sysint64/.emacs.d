(use-package xterm-color :ensure t)

(setq compilation-environment '("TERM=xterm-256color"))
(defun my/advice-compilation-filter (f proc string)
  (funcall f proc (xterm-color-filter string)))
(advice-add 'compilation-filter :around #'my/advice-compilation-filter)

(defun save-all-and-compile ()
  (interactive)
  (save-some-buffers 1)
  (project-compile))

(defun endless/send-input (input &optional nl)
  "Send INPUT to the current process.
Interactively also sends a terminating newline."
  (interactive "MInput: \nd")
  (let ((string (concat input (if nl "\n"))))
    ;; This is just for visual feedback.
    (let ((inhibit-read-only t))
      (insert-before-markers string))
    ;; This is the important part.
    (process-send-string
     (get-buffer-process (current-buffer))
     string)))

(defun endless/send-self ()
  "Send the pressed key to the current process."
  (interactive)
  (endless/send-input
   (apply #'string
          (append (this-command-keys-vector) nil))))

(dolist (key '("r" "R" "p" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "q" "Q"))
  (define-key compilation-mode-map key
    #'endless/send-self))

(setq compile-command "")

(defun recompile-buffer (buffer)
  (if (get-buffer buffer)
      (progn
        (windmove-down)
        (switch-to-buffer buffer)
        (recompile)
        ;; (windmove-up)
        )))

(defun recompile-run ()
  (interactive)
  (recompile-buffer "*compilation run*"))

(defun recompile-test ()
  (interactive)
  (recompile-buffer "*compilation test*"))

(defun recompile-analyze ()
  (interactive)
  (recompile-buffer "*compilation analyze*"))

(defun recompile-generate ()
  (interactive)
  (recompile-buffer "*compilation generate*"))

;; (global-set-key (kbd "C-1") 'switch-to-buffer)
(global-set-key (kbd "C-1") 'consult-buffer)
;; (global-set-key (kbd "C-2") 'project-switch-to-buffer)
(global-set-key (kbd "C-2") 'consult-project-buffer)
(global-set-key (kbd "C-7") 'save-all-and-compile)
(global-set-key (kbd "C-S-n") 'project-find-file)
(global-set-key (kbd "C-S-f") 'consult-git-grep)
(global-set-key (kbd "M-C-n") 'project-switch-project)

(defhydra hydra-project (global-map "<escape>")
  "Command"
  ("pf" project-find-file)
  ("pd" project-find-dir)
  ("pen" flymake-goto-next-error)
  ("pep" flymake-goto-prev-error)
  ("er" recompile-run)
  ("ea" recompile-analyze)
  ("et" recompile-test)
  ("eg" recompile-generate))

(provide 'layer-project)
