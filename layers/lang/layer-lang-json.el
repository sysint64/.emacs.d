(use-package json-mode :ensure t)

(defun my-json-hook ()
  (make-local-variable 'js-indent-level)
  (setq tab-width 2)
  (setq js-indent-level 2)
  (setq truncate-lines t))

(add-hook 'json-mode-hook 'my-json-hook)

(provide 'layer-lang-json)
