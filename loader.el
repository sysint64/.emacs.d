(defun load-layers ()
  (add-to-list 'load-path (concat user-emacs-directory "layers"))
  (add-to-list 'load-path (concat user-emacs-directory "vendor"))
  (add-to-list 'load-path (concat user-emacs-directory "layers/lang"))

  (use-package hydra :ensure t)
  (use-package all-the-icons :ensure t)

  (require 'layer-vertico)
  (require 'layer-eglot)
  (require 'layer-lsp)

  ;; Langauges
  (require 'layer-lang-rust)
  (require 'layer-lang-dart)
  (require 'layer-lang-glsl)
  (require 'layer-lang-json)
  (require 'layer-lang-swift)
  (require 'layer-lang-markdown)
  (require 'layer-lang-tpb)
  (require 'layer-lang-elixir)
  (require 'layer-git)

  ;; Other
  ;; (require 'layer-treesitter)
  (require 'layer-general)
  (require 'layer-frame)
  (require 'layer-navigation)
  (require 'layer-motions)
  (require 'layer-project)
  (require 'layer-company)
  (require 'layer-snippets)
  (require 'layer-org)

  (require 'llvm-mode)
  (require 'wgsl-mode)
  (require 'jai-mode)

  (require 'layer-theme))

(provide 'loader)
