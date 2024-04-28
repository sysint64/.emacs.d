(add-to-list 'image-types 'svg)

(use-package lsp-mode
  :ensure t
  :custom
  (lsp-headerline-breadcrumb-enable nil))

(define-key lsp-mode-map (kbd "C-S-SPC") nil)
(define-key lsp-mode-map (kbd "C-c ^") 'lsp-rename)
(define-key lsp-mode-map (kbd "C-c &") 'lsp-find-references)
(define-key lsp-mode-map (kbd "M-<return>") 'lsp-execute-code-action)
(define-key lsp-mode-map (kbd "C-M-B") 'lsp-goto-implementation)
(define-key lsp-mode-map (kbd "C-M-l") 'lsp-format-buffer)

(setq lsp-signature-render-documentation nil)
(setq lsp-log-io nil)
(setq lsp-enable-file-watchers nil)
(setq lsp-modeline-code-actions-enable nil)
(setq lsp-modeline-code-action-fallback-icon "")
(setq lsp-semantic-tokens-enable t)

;; (with-eval-after-load 'lsp-mode
;;   (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.pub-cach\\'")
;;   ;; (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]\\.my-files\\'")
;;   )

;; (with-eval-after-load 'tree-sitter-hl
;;   (add-hook
;;    'tree-sitter-hl-mode-hook
;;    (lambda ()
;;      (when (and lsp-mode lsp--semantic-tokens-teardown
;;                 (boundp 'tree-sitter-hl-mode) tree-sitter-hl-mode)
;;        (lsp-warn "It seems you have configured tree-sitter-hl to activate after lsp-mode.
;; To prevent tree-sitter-hl from overriding lsp-mode's semantic token highlighting, lsp-mode
;; will now disable both semantic highlighting and tree-sitter-hl mode and subsequently re-enable both,
;; starting with tree-sitter-hl-mode.

;; Please adapt your config to prevent unnecessary mode reinitialization in the future.")
;;        (funcall lsp--semantic-tokens-teardown)
;;        (setq lsp--semantic-tokens-teardown nil)
;;        (tree-sitter-hl-mode -1)
;;        (tree-sitter-hl-mode t)
;;        (lsp--semantic-tokens-initialize-buffer)))))

(provide 'layer-lsp)
