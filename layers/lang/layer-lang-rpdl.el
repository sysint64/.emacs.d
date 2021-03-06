(defface font-lock-rpdl-number-face
  '((t :inherit font-lock-constant-face))
  "Face for highlighting attributes")

(defvar font-lock-rpdl-number-face 'font-lock-rpdl-number-face)

(defface font-lock-rpdl-enum
  '((t :inherit font-lock-constant-face))
  "Face for highlighting attributes")

(defvar font-lock-rpdl-enum 'font-lock-rpdl-enum)

(setq rpdl-font-lock-keywords
      `((,"#.*" 0 font-lock-comment-face prepend)
        (,"\\btrue\\b\\|\\bfalse\\b" . font-lock-constant-face)
        (,"\\b[a-zA-Z]\\([a-zA-Z0-9_]+\\)?\\b\\(\s+\\)?:" . font-lock-variable-name-face)
        (,"\\b[A-Z]\\([a-zA-Z0-9_]+\\)?\\b\\|include" . font-lock-keyword-face)
        (,"\\b[0-9.]+\\b" . font-lock-rpdl-number-face)
        (,"\\b[a-zA-Z_][a-zA-Z_0-9]+\\b" . font-lock-rpdl-enum)
        ))

(defun rpdl-extra-font-lock-is-in-double-quoted-string ()
  "Non-nil if point in inside a double-quoted string."
  (let ((state (syntax-ppss)))
    (eq (nth 3 state) ?\")))

(defun rpdl-extra-font-lock-match-ref-in-double-quoted-string (limit)
  "Search for reference in double-quoted strings."
  (let (res)
    (while
        (and (setq res
                   (re-search-forward
                    "@[a-zA-Z0-9.]+"
                    limit t))
             (not (rpdl-extra-font-lock-is-in-double-quoted-string))))
    res))

(defface font-lock-rpdl-ref-face
  '((t :inherit font-lock-constant-face))
  "Face for highlighting attributes")

(defvar font-lock-rpdl-ref-face 'font-lock-rpdl-ref-face)

(defvar rpdl-extra-font-lock-keywords
  '((rpdl-extra-font-lock-match-ref-in-double-quoted-string
     (0 'font-lock-rpdl-ref-face prepend))))

(defun rpdl-extra-font-lock-activate ()
  (interactive)
  (font-lock-add-keywords nil rpdl-extra-font-lock-keywords)
  (if (fboundp 'font-lock-flush)
      (font-lock-flush)
    (when font-lock-mode
      (with-no-warnings
        (font-lock-fontify-buffer)))))

(define-derived-mode rpdl-mode fundamental-mode "rpdl mode"
  "Major mode for editing RPDL (RedPaws Declarative Language)"
  (set (make-local-variable 'comment-start) "# ")
  (setq font-lock-defaults '((rpdl-font-lock-keywords))))

(add-to-list 'auto-mode-alist '("\\rdl\\'" . rpdl-mode))
(add-to-list 'auto-mode-alist '("\\.rpdl\\'" . rpdl-mode))

(add-hook 'rpdl-mode-hook 'rpdl-extra-font-lock-activate)
(add-hook 'rpdl-mode-hook 'linum-mode)

(use-package highlight-numbers :ensure t
  :config
  (add-hook 'rpdl-mode-hook 'highlight-numbers-mode))

;; (font-lock-add-keywords 'rpdl-mode '(("#.+" . font-lock-comment-face)))

(provide 'layer-lang-rpdl)
