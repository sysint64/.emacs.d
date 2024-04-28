(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled

  ;; (load-theme 'doom-dark+ t)
  ;; (load-theme 'doom-old-hope t)

  (load-theme 'doom-material-dark t)
  (load-theme 'doom-oceanic-next t)
  ;; (load-theme 'doom-feather-light t)
  ;; (load-theme 'doom-vibrant t)

  (fringe-mode 0)

  ;; (set-window-margins nil 0)
  ;; (setq-default left-margin-width 0 right-margin-width 0)

  ;; (load-theme 'doom-peacock t)
  ;; (load-theme 'doom-spacegrey t)
  ;; (load-theme 'doom-tokyo-night t)
  ;; (load-theme 'doom-gruvbox t)
  ;; (load-theme 'doom-pine t)

  ;; (load-theme 'doom-homage-black t)
  ;; (load-theme 'doom-one t)
  ;; (load-theme 'doom-ayu-dark t)
  ;; (load-theme 'doom-challenger-deep t)
  ;; (load-theme 'doom-Iosvkem t)
  ;; (load-theme 'doom-ir-black t)
  ;; (load-theme 'doom-material-dark t)
  ;; (load-theme 'doom-opera t)
  ;; (load-theme 'doom-palenight t)
  ;; (load-theme 'doom-peacock t)
  ;; (load-theme 'doom-pine t)
  ;; (load-theme 'doom-plain-dark t)
  ;; (load-theme 'doom-rouge t)
  ;; (load-theme 'doom-spacegrey t)
  ;; (load-theme 'doom-vibrant t)
  ;; (load-theme 'doom-wilmersdorf t)
  ;; (load-theme 'doom-zenburn t)

  ;; Enable flashing mode-line on errors
  ;; (doom-themes-visual-bell-config)

  ;; (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;; (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(setq show-paren-style 'parenthesis)
(show-paren-mode 1)

;; (use-package highlight-parentheses :ensure t
;;   :init
;;   (global-highlight-parentheses-mode))

;; (set-face-attribute 'font-lock-number-face nil :weight 'bold)

;; (set-face-attribute 'font-lock-number-face nil :inherit 'font-lock-string-face)
(set-face-attribute 'font-lock-keyword-face nil :weight 'bold)

;; (set-face-attribute 'font-lock-constant-face nil :weight 'bold)

;; -----------------------------------------------------------------------------
;; (set-face-attribute 'region nil :foreground "#ccc")
(set-face-attribute 'region nil :background "#121f28")

(custom-set-faces
 '(window-divider ((t (:foreground "gray11"))))
 '(window-divider-first-pixel ((t nil)))
 '(window-divider-last-pixel ((t nil))))

(setq window-divider-default-right-width 2)
(window-divider-mode)

(provide 'layer-theme)
