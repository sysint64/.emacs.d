(use-package dart-mode :ensure t)

(use-package lsp-dart
  :ensure t
  :hook (dart-mode . lsp))

(defun my-dart-hook ()
  (add-to-list 'compilation-error-regexp-alist 'dart-analyze)
  (add-to-list 'compilation-error-regexp-alist-alist '(dart-analyze "\\([^ ]*\\.dart\\):\\([0-9]+\\):\\([0-9]+\\)" 1 2 3))
  (setq tab-width 2)
  (display-line-numbers-mode)
  (setq truncate-lines t)

  (setq lsp-dart-main-code-lens nil)
  (setq lsp-dart-test-code-lens nil)
  (setq lsp-lens-enable nil)
  (setq lsp-ui-doc-enable nil)
  (setq lsp-modeline-code-actions-enable nil)
  (setq lsp-diagnostics-provider :none)
  (setq lsp-modeline-diagnostics-enable nil)

  ;; (setq lsp-signature-auto-activate nil)
  ;; (setq lsp-enable-symbol-highlighting nil)

  ;; (setq lsp-completion-provider :none)
)

;; (defun project-try-dart (dir)
;;   (let ((project (or (locate-dominating-file dir "pubspec.yaml")
;;                      (locate-dominating-file dir "BUILD"))))
;;     (if project
;;         (cons 'dart project)
;;       (cons 'transient dir))))

;; (add-hook 'project-find-functions #'project-try-dart)

;; (cl-defmethod project-roots ((project (head dart)))
;;   (list (cdr project)))

(add-hook 'dart-mode-hook 'my-dart-hook)
;; (add-hook 'dart-mode-hook 'eglot-ensure)

;; (require 'password-generator)

;; (defun make-password ()
;;   (interactive)
;;   (password-generator-simple 12))

;; (define-key dart-mode-map (kbd "C-c p") 'make-password)

(defalias 'flutter/convert-to-consumer-widget
  (kmacro "C-f e x t e n d s <return> <right> C-S-<right> <backspace> C o n s u m e r W i d g e t C-f B u i l d C o n t e x t SPC c o n t e x t <return> , SPC W i d g e t R e f SPC r e f <down> <home>"))

(defalias 'flutter/convert-consumer-widget-to-consumer-stateful-widget
   (kmacro "C-f C o n s u m e r W i d g e t <return> <left> <left> <left> <left> <left> <left> S t a t e f u l C-f b u i l d <return> C-f W i d g e t R e f <return> C-<right> C-S-<left> C-S-<left> S-<left> S-<left> <backspace> <up> <home> C-S-SPC <down> M-<up> M-<up> M-<up> M-<up> C-w <down> <return> <return> c l a s s SPC { <return> C-y <down> M-<down> C-r C o n s u m e r S t a t e f u l W i d g e t <return> C-<left> C-<left> C-d C-q C-f { <return> <left> M-<up> <up> <right> C-y C-<left> C o n s u m e r S t a t e < C-<right> > <up> <return> @ o v e r r i d e <down> <end> SPC c r e a t e S t a t e ( ) SPC = > SPC C-y S t a t e ( ) ; <down> <down> <down> <left> <left> SPC C-y S t a t e SPC e x t e n d s SPC C o n s u m e r W <backspace> S t a t e < > <left> C-y <down> <down> <down> <home>"))

(defhydra hydra-dart (global-map "<escape>")
  "Command"
  ("tdc" flutter/convert-to-consumer-widget :exit t)
  ("tdsc" flutter/convert-consumer-widget-to-consumer-stateful-widget :exti t))

(provide 'layer-lang-dart)
