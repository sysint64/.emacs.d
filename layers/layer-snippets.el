(use-package yasnippet :ensure t
  :init
  (yas-global-mode 1)
  (yas/load-directory "~/.emacs.d/snippets"))

(eval-after-load "yasnippet"
  '(define-key yas-minor-mode-map (kbd "C-c &") nil))

(defun yas-remove-duplicate-suffix (text suffix)
  (if (string-suffix-p (concat suffix suffix) text)
      (string-remove-suffix suffix text)
    text))

(defun yas-add-suffix (text suffix)
  (if (string-suffix-p suffix text)
      ""
    suffix))

(provide 'layer-snippets)
