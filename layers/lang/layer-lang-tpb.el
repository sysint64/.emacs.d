(define-derived-mode tpb-mode rust-mode "tech paws buffer major mode"
  "major mode for editing tech paws buffer."
  (font-lock-add-keywords nil '(("\\([a-z][a-z0-9_]+\\) ->" 1 font-lock-function-name-face)))
  (font-lock-add-keywords nil '(("->" . 'font-lock-function-name-face)))
  (font-lock-add-keywords nil '(("signal" . 'font-lock-keyword-face))))

(add-to-list 'auto-mode-alist '("\\.tpb\\'" . tpb-mode))

(provide 'layer-lang-tpb)
