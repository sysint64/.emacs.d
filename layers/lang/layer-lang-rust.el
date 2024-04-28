(use-package rustic
  :ensure t
  :config (progn (add-to-list 'compilation-error-regexp-alist-alist
                              (cons 'rustic-error rustic-compilation-error))
                 (add-to-list 'compilation-error-regexp-alist-alist
                              (cons 'rustic-warning rustic-compilation-warning))
                 (add-to-list 'compilation-error-regexp-alist-alist
                              (cons 'rustic-info rustic-compilation-info))
                 (add-to-list 'compilation-error-regexp-alist-alist
                              (cons 'rustic-panic rustic-compilation-panic))

                 (add-to-list 'compilation-error-regexp-alist 'rustic-error)
                 (add-to-list 'compilation-error-regexp-alist 'rustic-warning)
                 (add-to-list 'compilation-error-regexp-alist 'rustic-info)
                 (add-to-list 'compilation-error-regexp-alist 'rustic-panic))
  :init
  ;; (setq rustic-lsp-server 'rust-analyzer)
  (setq rustic-flycheck-setup-mode-line-p nil))

;; (setq rustic-lsp-client 'eglot)

;; (defun create-rusty-tags ()
;;   "Create tags file."
;;   (interactive)
;;   (when (derived-mode-p 'sr-mode 'rustic-mode)
;;     (with-temp-buffer
;;       (shell-command "rusty-tags emacs -O TAGS" t))
;;     (message "Tags rebuilt sucessfully")))

(add-hook 'rustic-mode-hook 'rust-ts-mode)
(add-hook 'rust-ts-mode-hook 'my-rust-hook)

(use-package highlight-numbers :ensure t
  :config
  ;; (add-hook 'rust-ts-mode-hook 'highlight-numbers-mode)
  )

;; (add-hook 'rust-ts-mode-hook 'eglot-ensure)
;; (add-hook 'rust-ts-mode-hook 'linum-mode)

;; (define-key rust-ts-mode-map (kbd "C-M-L") 'rustic-format-buffer)
;; (define-key rust-ts-mode-map (kbd "C-<return>") 'comment-indent-new-line)

;; (add-hook 'rustic-mode-hook #'tree-sitter-mode)

;; (define-key rustic-mode-map (kbd "C-<return>") 'comment-indent-new-line)

(defun my-rust-hook ()
  (setq truncate-lines t)
  (setq require-final-newline nil)
  (setq mode-require-final-newline nil)
  (display-line-numbers-mode)
  (lsp-mode)
  ;; (add-hook 'after-save-hook 'create-rusty-tags)
  )

;; (setq rustic-lsp-server 'rust-analyzer)
;; TODO:
;; (flycheck-list-errors)

(provide 'layer-lang-rust)
