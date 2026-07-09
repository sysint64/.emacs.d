(require 'wgsl-mode)

(defun my-wgsl-hook ()
  (setq-local c-basic-offset 4)
  (setq-local tab-width 4))

(add-hook 'wgsl-mode-hook 'my-wgsl-hook)

(provide 'layer-lang-wgsl)
