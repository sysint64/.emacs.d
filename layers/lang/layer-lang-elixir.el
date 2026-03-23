(use-package elixir-mode :ensure t)
(use-package elixir-ts-mode :ensure t)

(defun my-elixir-hook ()
  (display-line-numbers-mode)
  (lsp-mode)
  (setq truncate-lines t)
)

(add-hook 'elixir-mode-hook 'my-elixir-hook)
(add-hook 'elixir-ts-mode-hook 'my-elixir-hook)

(provide 'layer-lang-elixir)
