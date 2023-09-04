(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

(setq make-backup-files         nil) ; Don't want any backup files
(setq auto-save-list-file-name  nil) ; Don't want any .saves files
(setq auto-save-default         nil) ; Don't want any auto saving

(setq mouse-wheel-progressive-speed nil)
(setq use-dialog-box nil)
(put 'dired-find-alternate-file 'disabled nil) ; disables warning

(defalias 'yes-or-no-p 'y-or-n-p)

(menu-bar-mode -1)
(tool-bar-mode -1)
(delete-selection-mode 1)
(scroll-bar-mode -1)
(setq frame-resize-pixelwise t)
(setq ring-bell-function 'ignore)
(setq input-method-use-echo-area 'nil)
(setq echo-keystrokes 0)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(setq dired-dwim-target t)
(setq-default display-line-numbers-width 3)
(set-default 'truncate-lines t)
(eval-when-compile (require 'subr-x))

(setq eldoc-idle-delay 0.75)
(setq company-idle-delay nil)
(setq flymake-no-changes-timeout 0.5)
(setq-default indent-tabs-mode nil)
(electric-pair-mode 1)

(add-hook 'elisp-mode-hook 'display-line-numbers-mode)

(use-package flycheck :ensure t)
(use-package hydra :ensure t)
(use-package undo-tree :ensure t
  :init (global-undo-tree-mode))
(use-package highlight-symbol :ensure t)

(setq hydra-is-helpful nil)

(defun save-all ()
  (interactive)[]
  (save-some-buffers 1))

(defun un-indent-by-removing-4-spaces ()
  "remove 4 spaces from beginning of of line"
  (interactive)
  (save-excursion
    (Save-Match-Data
      (beginning-of-line)
      ;; get rid of tabs at beginning of line
      (when (looking-at "^\\s-+")
        (untabify (match-beginning 0) (match-end 0)))
      (when (looking-at "^    ")
        (replace-match "")))))

(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position))
      (next-line))
    (comment-or-uncomment-region beg end)))

(defun add-100-tire-line ()
  "Fill line with `-` symbol"
  (interactive)
  (setq cursor-position (- (line-end-position) (line-beginning-position)))
  (insert-char (aref "-" 0) (- 100 cursor-position)))

(defun add-80-tire-line ()
  "Fill line with `-` symbol"
  (interactive)
  (setq cursor-position (- (line-end-position) (line-beginning-position)))
  (insert-char (aref "-" 0) (- 80 cursor-position)))

(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive) (revert-buffer t t))

(defun insert-random-uuid ()
  (interactive)
  (insert
   (downcase
    (string-trim
     (shell-command-to-string
      (cond
       ((string-equal system-type "windows-nt")
        "pwsh.exe -Command [guid]::NewGuid().toString()")
       ((string-equal system-type "darwin") ; Mac
        "uuidgen")
       ((string-equal system-type "gnu/linux")
        "uuidgen")))))))

(defun display-error-at-point ()
  (interactive)
  (setq flycheck-display-errors-function
        #'flycheck-display-error-messages-unless-error-list)
  (flycheck-display-error-at-point)
  (setq flycheck-display-errors-function nil))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
(setq flycheck-display-errors-function nil)

(global-set-key (kbd "<backtab>") 'un-indent-by-removing-4-spaces)
(global-unset-key (kbd "C-/"))
(global-set-key (kbd "C-\\") 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "C-z") 'undo-tree-undo)
(global-set-key (kbd "C-S-z") 'undo-tree-redo)
(global-set-key (kbd "C-c u") 'insert-random-uuid)
(global-set-key (kbd "C-c C-g") 'revert-buffer-no-confirm)
(global-set-key (kbd "C-<f3>") 'highlight-symbol)
(global-set-key (kbd "<f3>") 'highlight-symbol-next)
(global-set-key (kbd "S-<f3>") 'highlight-symbol-prev)
(global-set-key (kbd "M-<f3>") 'highlight-symbol-query-replace)
(global-set-key (kbd "S-C-SPC") 'set-mark-command)

;; (global-unset-key (kbd "<escape>"))
;; (define-key hydra-base-map (kbd "<escape>") 'hydra-keyboard-quit)

(defhydra hydra-general (global-map "<escape>")
  "Command"
  ("p80" add-80-tire-line :exit t)
  ("p100" add-100-tire-line :exit t)
  ("nf" make-empty-file :exit t)
  ("nd" make-directory :exit t)
  ("wa" save-all :exit t)
  ("rb" rename-buffer :exit t)
  ("se" display-error-at-point :exit t)
  ("tt" toggle-truncate-lines :exit t))

(provide 'layer-general)
