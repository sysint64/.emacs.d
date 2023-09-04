(require 'package)

(setq package-enable-at-startup nil)
(setq mac-command-modifier 'control)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(load-file (concat user-emacs-directory "loader.el"))
(load-layers)

(set-face-font 'default "Hack-12")
;; (require 'theme-dark)
(setq inhibit-startup-screen t)
