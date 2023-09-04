(use-package magit :ensure t)

(use-package diff-hl :ensure t
             :init
             (global-diff-hl-mode)
             (diff-hl-flydiff-mode))

(defhydra hydra-git (global-map "<escape>")
  "Command"
  ("vl" magit-log :exit t)
  ("vs" magit-status :exit t)
  ("vc" magit-commit :exit t)
  ("vp" magit-push :exit t))

(provide 'layer-git)
