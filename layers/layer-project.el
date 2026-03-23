(use-package xterm-color :ensure t)
(use-package harpoon :ensure t)

(setq compilation-environment '("TERM=xterm-256color"))
(setq compilation-max-output-line-length nil)
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

(dolist (key '("r" "R" "p" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "q" "Q" "m" "M"))
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

(use-package treemacs :ensure t)

;; (global-set-key (kbd "C-1") 'switch-to-buffer)
(global-set-key (kbd "C-1") 'consult-buffer)
;; (global-set-key (kbd "C-2") 'project-switch-to-buffer)
(global-set-key (kbd "C-2") 'consult-project-buffer)
(global-set-key (kbd "C-3") 'harpoon-toggle-quick-menu)
(global-set-key (kbd "C-7") 'save-all-and-compile)
(global-set-key (kbd "C-S-n") 'project-find-file)
(global-set-key (kbd "C-S-f") 'consult-git-grep)
(global-set-key (kbd "M-C-n") 'project-switch-project)
(global-set-key (kbd "C-b") 'treemacs)

(defhydra hydra-project (global-map "<escape>")
  "Command"
  ("pf" project-find-file)
  ("pd" project-find-dir)
  ("pen" flymake-goto-next-error)
  ("pep" flymake-goto-prev-error)
  ("er" recompile-run)
  ("ea" recompile-analyze)
  ("et" recompile-test)
  ("eg" recompile-generate)
  ("hm" harpoon-toggle-quick-menu :exit t)
  ("ha" harpoon-add-file :exit t)
  ("h1" harpoon-go-to-1 :exit t)
  ("h2" harpoon-go-to-2 :exit t)
  ("h3" harpoon-go-to-3 :exit t)
  ("h4" harpoon-go-to-4 :exit t)
  ("h5" harpoon-go-to-5 :exit t)
  ("h6" harpoon-go-to-6 :exit t)
  ("h7" harpoon-go-to-7 :exit t)
  ("h8" harpoon-go-to-8 :exit t)
  ("h9" harpoon-go-to-9 :exit t)
  ("hd1" harpoon-delete-1 :exit t)
  ("hd2" harpoon-delete-2 :exit t)
  ("hd3" harpoon-delete-3 :exit t)
  ("hd4" harpoon-delete-4 :exit t)
  ("hd5" harpoon-delete-5 :exit t)
  ("hd6" harpoon-delete-6 :exit t)
  ("hd7" harpoon-delete-7 :exit t)
  ("hd8" harpoon-delete-8 :exit t)
  ("hd9" harpoon-delete-9 :exit t)
  ("hc" harpoon-clear :exit t))

(provide 'layer-project)
