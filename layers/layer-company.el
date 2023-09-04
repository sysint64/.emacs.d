(use-package company :ensure t
  :init
  (global-company-mode))

(setq company-idle-delay 0.5)

(defhydra hydra-company (global-map "<escape>")
  "Command"
  ("SPC" company-complete :exit t))

(provide 'layer-company)
