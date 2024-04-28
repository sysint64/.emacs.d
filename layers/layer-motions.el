(use-package avy :ensure t
  :bind (("C-s" . avy-goto-char)
         ;; ("M-g g" . 'avy-goto-line)
         ))

(use-package expand-region :ensure t
  :bind (("C-d" . er/expand-region)
         ("C-9" . er/mark-outside-pairs)
         ("C-0" . er/mark-inside-pairs)
         ("C-'" . er/mark-inside-quotes)
         ("C-\"" . er/mark-outside-quotes)))

(use-package string-inflection :ensure t)

(use-package multiple-cursors :ensure t
  :bind (("C-S-l" . mc/edit-lines)
         ("M-S-<down>" . mc/mark-next-like-this)
         ("M-S-<up>" . mc/mark-previous-like-this)
         ("M-C-S-j" . mc/mark-all-like-this)
         ("M-j" . mc/mark-next-like-this-word)))

(defun go-to-outside-scope-beginning ()
  (interactive)
  (setq last_point (point))
  (er/mark-outside-pairs)
  (when (eq last_point (point)) (er/mark-outside-pairs))
  (deactivate-mark))

(defun go-to-outside-scope-end ()
  (interactive)
  (setq last_point (point))
  (er/mark-outside-pairs)
  (goto-char (region-end))
  (when (eq last_point (point)) (er/mark-outside-pairs))
  (goto-char (region-end))
  (deactivate-mark))

(defun duplicate-current-line (&optional n)
  "duplicate current line, make more than 1 copy given a numeric argument"
  (interactive "p")
  (save-excursion
    (let ((nb (or n 1))
    	  (current-line (thing-at-point 'line)))
      ;; when on last line, insert a newline first
      (when (or (= 1 (forward-line 1)) (eq (point) (point-max)))
    	(insert "\n"))

      ;; now insert as many time as requested
      (while (> n 0)
    	(insert current-line)
    	(decf n)))))

(defun my-scroll-up ()
  (interactive)
  (scroll-up-line 5))

(defun my-scroll-down ()
  (interactive)
  (scroll-down-line 5))

(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(setq superword 1)

(defun toggle-superword-subword ()
  (interactive)
  (if (= superword 1)
      (progn (setq superword 0)
             (global-superword-mode 0)
             (global-subword-mode 1))
    (progn (setq superword 1)
           (global-subword-mode 0)
           (global-superword-mode 1))))

(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(defun open-next-line ()
  (interactive)
  (end-of-line)
  (newline-and-indent))

(defun open-prev-line ()
  (interactive)
  (previous-line)
  (end-of-line)
  (newline-and-indent))

(defun set-empty-mark ()
  (interactive)
  (push-mark))

(defun expand-region-and-delete ()
  (interactive)
  (if (= superword 0)
      (progn (er/mark-word)
        (kill-region (region-beginning) (region-end)))
    (progn (easy-mark)
           (kill-region (region-beginning) (region-end)))))

(defun expand-region-and-copy ()
  (interactive)
  (if (= superword 0)
      (progn (er/mark-word)
             (kill-ring-save (region-beginning) (region-end)))
    (progn (easy-mark)
           (kill-ring-save (region-beginning) (region-end)))))

(defun list-new-line ()
  (interactive)

  (setq now (point))
  (setq now-line (line-number-at-pos))

  (setq open-paren (search-backward "("))

  (goto-char (symbol-value 'now))

  (setq backward-comma (search-backward ","))

  (goto-char (max (symbol-value 'open-paren) (symbol-value 'backward-comma)))
  (forward-char)

  (when (eq (symbol-value 'now-line) (line-number-at-pos))
    (newline)
    (indent-for-tab-command))

  (setq now (point))

  (setq forward-comma (search-forward ","))

  (goto-char (symbol-value 'now))

  (setq close-paren (- (search-forward ")") 1))

  (goto-char (min (symbol-value 'forward-comma) (symbol-value 'close-paren)))

  (newline)
  (indent-for-tab-command))

(defun comment-paragraph-forward ()
  (interactive)
  (mark-paragraph)
  (comment-or-uncomment-region-or-line)
  (forward-paragraph))

(defun comment-paragraph-backward ()
  (interactive)
  (backward-paragraph)
  (mark-paragraph)
  (comment-or-uncomment-region-or-line))

(global-set-key (kbd "<home>") 'smarter-move-beginning-of-line)
(global-set-key (kbd "<end>") 'move-end-of-line)
(global-set-key (kbd "M-<up>") 'forward-sexp)
(global-set-key (kbd "M-<down>") 'backward-sexp)
(global-set-key (kbd "C-<left>") 'left-word)
(global-set-key (kbd "C-<right>") 'right-word)
(global-set-key (kbd "C-,") 'my-scroll-down)
(global-set-key (kbd "C-.") 'my-scroll-up)
(global-unset-key (kbd "C-j"))
(global-unset-key (kbd "C-u"))
(global-set-key (kbd "C-j") 'toggle-superword-subword)
(global-superword-mode 1)
(global-set-key (kbd "C-a") 'mark-whole-buffer)
(global-set-key (kbd "C-q") 'kill-ring-save)
(global-set-key (kbd "C-S-<up>") 'move-line-up)
(global-set-key (kbd "C-S-<down>") 'move-line-down)
(global-set-key (kbd "C-c C-d") 'duplicate-current-line)
(global-set-key (kbd "C-o") 'open-next-line)
(global-set-key (kbd "C-S-o") 'open-prev-line)
(global-set-key (kbd "C-p") 'kill-paragraph)
(global-set-key (kbd "C-S-p") 'backward-kill-paragraph)

(defhydra hydra-kill ()
  "Command"
  ("<down>" kill-paragraph)
  ("<up>" backward-kill-paragraph))

(defhydra hydra-jump ()
  "Command"
  ("en" flymake-goto-next-error :exit t)
  ("ep" flymake-goto-prev-error :exit t)
  ("<up>" go-to-outside-scope-end)
  ("<down>" go-to-outside-scope-beginning)
  ("f <down>" treesit-beginning-of-defun :exit t)
  ("f <up>" treesit-end-of-defun :exit t))

(defhydra hydra-motions (global-map "<escape>")
  "Command"
  ("k" hydra-kill/body :exit t)
  ("mm" set-empty-mark)
  ("mp" mark-paragraph)
  ("mf" mark-defun)
  ("ln" list-new-line)
  ("\\p" comment-paragraph-forward)
  ("\\bp" comment-paragraph-backward)
  ("t_" string-inflection-underscore)
  ("t-" string-inflection-kebab-case)
  ("tc" string-inflection-lower-camelcase)
  ("tC" string-inflection-camelcase)
  ("tu" string-inflection-upcase)
  ("<up>" treesit-beginning-of-defun)
  ("<down>" treesit-end-of-defun)
  ("c" eval-and-replace :exit t)
  ("j" hydra-jump/body :exit t)
  ("." hydra-repeat))

;; (treesit-beginning-of-thing "if_expression")
;; (treesit-end-of-thing "if_expression")
;; (treesit-thing-at-point "if_expression" 'nested)

(provide 'layer-motions)
