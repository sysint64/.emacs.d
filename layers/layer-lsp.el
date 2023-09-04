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

;; (with-eval-after-load 'lsp-mode
;;   (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.pub-cach\\'")
;;   ;; (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]\\.my-files\\'")
;;   )

(provide 'layer-lsp)
