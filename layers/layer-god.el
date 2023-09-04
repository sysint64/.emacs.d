(use-package god-mode :ensure t)
;; (god-mode)

(global-set-key (kbd "<escape>") #'god-local-mode)

;; (defun my-god-mode-update-cursor-type ()
;;   (setq cursor-type (if (or god-local-mode buffer-read-only) 'box 'bar)))

(defun nop ()
  (interactive))

;; (add-hook 'post-command-hook #'my-god-mode-update-cursor-type)
(define-key god-local-mode-map (kbd "i") #'god-local-mode)
(define-key god-local-mode-map (kbd "z") #'repeat)
(define-key god-local-mode-map (kbd "u") #'undo-tree-undo)
(define-key god-local-mode-map (kbd "r") #'undo-tree-redo)
(define-key god-local-mode-map (kbd "w") #'forward-word)
(define-key god-local-mode-map (kbd "b") #'backward-word)
(define-key god-local-mode-map (kbd "a") #'nop)

(provide 'layer-god)
