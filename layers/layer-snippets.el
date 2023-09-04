(use-package yasnippet :ensure t
  :init
  (yas-global-mode 1)
  (yas/load-directory "~/.emacs.d/snippets"))

(eval-after-load "yasnippet"
  '(define-key yas-minor-mode-map (kbd "C-c &") nil))

(provide 'layer-snippets)
