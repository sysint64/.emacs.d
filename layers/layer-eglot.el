(use-package eglot :ensure t)

(define-key eglot-mode-map (kbd "M-RET") 'eglot-code-actions)
(define-key eglot-mode-map (kbd "C-M-l") 'eglot-format)
(define-key eglot-mode-map (kbd "C-c ^") 'eglot-rename)
(define-key eglot-mode-map (kbd "C-c &") 'xref-find-references)
;; (define-key eglot-mode-map (kbd "C-c &") 'xref-find-references)

  ;; No event buffers, disable providers cause a lot of hover traffic. Shutdown unused servers.
(setq eglot-events-buffer-size 0
      eglot-ignored-server-capabilities '(:hoverProvider
                                          :documentHighlightProvider)
      eglot-autoshutdown t)

;; Show all of the available eldoc information when we want it. This way Flymake errors
;; don't just get clobbered by docstrings.
(add-hook 'eglot-managed-mode-hook
(lambda ()
  "Make sure Eldoc will show us all of the feedback at point."
  (setq-local eldoc-documentation-strategy
              #'eldoc-documentation-compose)))

;; (setq eldoc-area-prefer-doc-buffer to t)

(provide 'layer-eglot)
