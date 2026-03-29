(use-package org-roam
  :ensure t
  :custom
  (org-roam-dailies-directory "journals/")
  (org-roam-complete-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?" :target
      (file+head "pages/${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)))
  :config
  (org-roam-db-autosync-enable))

(use-package org-table-sticky-header :ensure t)

(setq org-link-frame-setup
      '((vm . vm-visit-folder-other-frame)
        (vm-imap . vm-visit-imap-folder-other-frame)
        (gnus . org-gnus-no-new-news)
        (file . find-file)  ; This changes the default behavior
        (wl . wl-other-frame)))

(setq org-agenda-files nil)

(define-key org-mode-map (kbd "M-.") 'org-open-at-point)
(define-key org-mode-map (kbd "M-,") 'org-mark-ring-goto)
(define-key org-mode-map (kbd "C-,") 'my-scroll-down)
(define-key org-mode-map (kbd "C-.") 'my-scroll-up)
(define-key org-mode-map (kbd "C-c C-d") 'duplicate-current-line)

;; (add-hook 'org-mode-hook #'toggle-truncate-lines)
(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook 'org-indent-mode)
(add-hook 'org-mode-hook 'org-table-sticky-header-mode)
;; (add-hook 'org-mode-hook 'olivetti-mode)

(setq org-fontify-quote-and-verse-blocks t)
(setq org-cycle-separator-lines -1)
(setq org-confirm-babel-evaluate nil)

(defun org-recalculate-all ()
  (interactive)
  (org-babel-execute-buffer)
  (org-table-recalculate-buffer-tables))

(defhydra hydra-motions (global-map "<escape>")
  "Command"
  ("orj" org-roam-dailies-capture-today :exit t)
  ("ort" org-roam-dailies-goto-today :exit t)
  ("orb" org-roam-buffer-toggle :exit t)
  ("orf" org-roam-node-find :exit t)
  ("orl" org-roam-node-insert :exit t)
  ("oi" org-toggle-inline-images :exit t)
  ("oc" org-capture :exit t)
  ("oa" org-recalculate-all :exit t)
  ("ot" org-table-recalculate-buffer-tables :exit t))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (ditaa . t)
   (emacs-lisp . t)
   ))

(setq org-babel-python-command "python3")
(setq org-babel-ditaa-java-cmd "java")
(setq org-ditaa-jar-path "~/ditaa.jar")

(setq org-capture-templates
      '(("p" "Payment" table-line (file+headline "~/.org/pages/accounting.org" "Log")
         "| %t | %^{Expenses|Income|Savings|Savings Withdrawal} | %^{Category|Food|Home|Transport|Utilities} | %^{Amount} | %^{Rate} | %^{Comment} | | | |"
         :immediate-finish t)))

(defun my/sum-by-category-month-simple (table-name category column year month)
  "Sum values in COLUMN where category matches CATEGORY for specific YEAR-MONTH."
  (let ((sum 0))
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward (format "^[ \t]*#\\+NAME:[ \t]*%s" table-name) nil t)
        (forward-line 1)
        (org-table-analyze)
        (let ((end (org-table-end)))
          (while (< (point) end)
            (when (org-at-table-p)
              (let ((row-data (org-table-get-row)))
                ;; row-data is a list of cell values
                (when (and (listp row-data)
                           (>= (length row-data) column)
                           (string-match (format "<%d-%02d-" year month)
                                       (or (nth 0 row-data) ""))
                           (string-match "Expense" (or (nth 1 row-data) ""))
                           (string= category (nth 2 row-data)))
                  (setq sum (+ sum (string-to-number
                              (or (nth (1- column) row-data) "0")))))))
            (forward-line 1)))))
    sum))

(defun my/test-find-expenses ()
  "Test function to find expenses and see what's happening."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (if (re-search-forward "^[ \t]*#\\+NAME:[ \t]*payments_2025" nil t)
        (progn
          (message "Found table!")
          (forward-line 2) ; Skip to first data row
          (let ((count 0))
            (while (and (org-at-table-p) (< count 5))
              (let ((line (thing-at-point 'line t)))
                (when (string-match "Expense" line)
                  (message "Expense row: %s" (string-trim line))))
              (forward-line 1)
              (setq count (1+ count)))))
      (message "Table not found!"))))

(defun my/sum-by-category-month (table-name category column year month)
  "Sum values in COLUMN where category matches CATEGORY for specific YEAR-MONTH."
  (my/get-monthly-expense table-name category (format "%d-%02d" year month)))

(defun my/get-monthly-expense (table-name category month-string)
  "Get monthly expenses or savings for CATEGORY."
  (let ((sum 0)
        (month-pattern (format "<%s-" month-string)))
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward (format "#\\+NAME: %s" table-name) nil t)
        (forward-line 2)
        (while (org-at-table-p)
          (beginning-of-line)
          (when (looking-at "^|\\s-*\\(<[^>]+>\\)\\s-*|\\s-*\\([^|]+\\)\\s-*|\\s-*\\([^|]+\\)\\s-*|[^|]*|[^|]*|[^|]*|\\s-*\\([0-9.]+\\)")
            (let ((date (match-string 1))
                  (type (string-trim (match-string 2)))
                  (cat (string-trim (match-string 3)))
                  (amount (match-string 4)))
              (when (and (string-match month-pattern date)
                         (or (string-match "Expense" type)
                             (string= "Savings" type))  ; Include Savings
                         (string= category cat))
                (setq sum (+ sum (string-to-number amount))))))
          (forward-line 1))))
    sum))

(defun my/get-monthly-expense (table-name category month-string)
  "Get monthly expenses for CATEGORY. MONTH-STRING should be like '2025-07'."
  (let ((sum 0)
        (month-pattern (format "<%s-" month-string)))
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward (format "#\\+NAME: %s" table-name) nil t)
        (forward-line 2) ; Skip header and separator
        (while (org-at-table-p)
          (beginning-of-line)
          (when (looking-at "^|\\s-*\\(<[^>]+>\\)\\s-*|\\s-*\\([^|]+\\)\\s-*|\\s-*\\([^|]+\\)\\s-*|[^|]*|[^|]*|[^|]*|\\s-*\\([0-9.]+\\)")
            (let ((date (match-string 1))
                  (type (string-trim (match-string 2)))
                  (cat (string-trim (match-string 3)))
                  (amount (match-string 4)))
              (when (and (string-match month-pattern date)
                         (string-match "Expense" type)
                         (string= category cat))
                (message "Found: %s %s %s €%s" date type cat amount)
                (setq sum (+ sum (string-to-number amount))))))
          (forward-line 1))))
    sum))

(defun my/sum-by-category-month (table-name category column year month)
  "Sum values in COLUMN where category matches CATEGORY for specific YEAR-MONTH."
  (let ((sum 0)
        (col column)  ; Keep 1-indexed for remote range
        (month-pattern (format "<%d-%02d-" year month)))
    ;; Get the full table as a 2D range
    (let ((table-data (org-table-get-remote-range table-name "@2:@>$1..@>$9")))
      ;; Check if we got a list of rows or need to construct it
      (if (and table-data (listp (car table-data)))
          ;; We have a proper 2D list
          (dolist (row table-data)
            (when (and (>= (length row) col)
                       (nth 0 row)  ; Date
                       (nth 1 row)  ; Type
                       (nth 2 row)  ; Category
                       (nth (1- col) row)  ; Amount in column
                       (string-match month-pattern (nth 0 row))
                       (string-match "Expense" (nth 1 row))
                       (string= category (nth 2 row)))
              (setq sum (+ sum (string-to-number (nth (1- col) row))))))
        ;; We got a flat list, need to get data differently
        (let ((rows (org-table-get-remote-range table-name "@>"))
              (current-row 2))
          (while (<= current-row rows)
            (let* ((date-val (org-table-get-remote-range
                             table-name (format "@%d$1" current-row)))
                   (type-val (org-table-get-remote-range
                             table-name (format "@%d$2" current-row)))
                   (cat-val (org-table-get-remote-range
                            table-name (format "@%d$3" current-row)))
                   (amt-val (org-table-get-remote-range
                            table-name (format "@%d$%d" current-row col))))
              (when (and date-val type-val cat-val amt-val
                         (stringp date-val)
                         (string-match month-pattern date-val)
                         (string-match "Expense" type-val)
                         (string= category cat-val))
                (setq sum (+ sum (string-to-number amt-val)))))
            (setq current-row (1+ current-row))))))
    sum))

(defun my/debug-table-data (table-name)
  "Debug function to see the raw table data."
  (let ((rows (org-table-get-remote-range table-name "@2:@>")))
    (dotimes (i (min 3 (length rows)))
      (let ((row (nth i rows)))
        (message "Row %d: %S" i row)))))

(defun my/sum-by-category-month (table-name category column year month)
  "Sum values in COLUMN where category matches CATEGORY for specific YEAR-MONTH."
  (let ((sum 0)
        (col (1- column)))
    ;; Get all rows starting from row 2
    (org-save-excursion
      (save-excursion
        ;; Find the table
        (goto-char (point-min))
        (when (re-search-forward (format "^[ \t]*#\\+NAME:[ \t]*%s" table-name) nil t)
          (forward-line 1)
          ;; Skip header and separator
          (forward-line 2)
          ;; Process each row
          (while (org-at-table-p)
            (let* ((date (org-table-get-field 1))
                   (type (org-table-get-field 2))
                   (cat (org-table-get-field 3))
                   (amount-eur (org-table-get-field column)))
              ;; Check if this row matches our criteria
              (when (and date type cat amount-eur
                         (string-match (format "<%d-%02d-" year month) date)
                         (string-match "Expense" type)
                         (string= category cat))
                (setq sum (+ sum (string-to-number amount-eur)))))
            (forward-line 1)))))
    sum))

(defun my/org-running-balance (amount-eur type &optional previous-balance)
  "Calculate running balance for org-mode payment table."
  (let* ((amount (if (stringp amount-eur)
                     (string-to-number amount-eur)
                     amount-eur))
         (prev (if previous-balance
                   (if (stringp previous-balance)
                       (string-to-number previous-balance)
                       previous-balance)
                   0)))
    (cond
     ((string= type "Set") amount)
     ((string-match "^Savings$" type) (- prev amount))
     ((string-match "Savings Withdrawal" type) (+ prev amount))
     ((string-match "Expense" type) (- prev amount))
     ((string-match "Income" type) (+ prev amount))
     (t prev))))

(defun my/org-savings-tracker (amount type &optional previous-savings)
  "Track savings balance in org-mode table.
AMOUNT is the transaction amount.
TYPE is the transaction type.
PREVIOUS-SAVINGS is the savings balance from the previous row."
  (let* ((amt (if (stringp amount) (string-to-number amount) amount))
         (prev (cond ((not previous-savings) 0)
                     ((stringp previous-savings)
                      (if (string= previous-savings "") 0
                        (string-to-number previous-savings)))
                     (t previous-savings))))
    (cond
     ((string-match "^Savings$" type) (+ prev amt))
     ((string-match "Savings Withdrawal" type) (- prev amt))
     (t prev))))

;; (let* ((variable-tuple
;;         (cond ((x-list-fonts "ETBembo")         '(:font "ETBembo"))
;;               ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
;;               ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
;;               ((x-list-fonts "Verdana")         '(:font "Verdana"))
;;               ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
;;               (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
;;        (base-font-color     (face-foreground 'default nil 'default))
;;        (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

;;   (custom-theme-set-faces
;;    'user
;;    `(org-level-8 ((t (,@headline ,@variable-tuple))))
;;    `(org-level-7 ((t (,@headline ,@variable-tuple))))
;;    `(org-level-6 ((t (,@headline ,@variable-tuple))))
;;    `(org-level-5 ((t (,@headline ,@variable-tuple))))
;;    `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
;;    `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
;;    `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
;;    `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
;;    `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))))

;; (custom-theme-set-faces
;;  'user
;;  '(org-block ((t (:inherit fixed-pitch))))
;;  '(org-code ((t (:inherit (shadow fixed-pitch)))))
;;  '(org-document-info ((t (:foreground "dark orange"))))
;;  '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
;;  '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
;;  '(org-link ((t (:foreground "royal blue" :underline t))))
;;  '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;;  '(org-property-value ((t (:inherit fixed-pitch))) t)
;;  '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;;  '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
;;  '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
;;  '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

(provide 'layer-org)
