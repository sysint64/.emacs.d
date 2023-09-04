(defun load-layers ()
  (add-to-list 'load-path (concat user-emacs-directory "layers"))
  (add-to-list 'load-path (concat user-emacs-directory "vendor"))
  (add-to-list 'load-path (concat user-emacs-directory "layers/lang"))

  (require 'layer-vertico)
  (require 'layer-eglot)
  (require 'layer-lsp)

  ;; Langauges
  (require 'layer-lang-rust)
  (require 'layer-lang-dart)
  (require 'layer-lang-glsl)
  (require 'layer-lang-json)
  (require 'layer-lang-markdown)
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

  (require 'llvm-mode)
  (require 'wgsl-mode)

  (require 'layer-theme))

(provide 'loader)
