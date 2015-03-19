(require 'package)

(menu-bar-mode -1)
(tool-bar-mode -1)

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)

(package-initialize)

(defvar required-packages
  '(
    evil evil-surround evil-visualstar
    zenburn-theme solarized-theme
    yasnippet
    company
    ) "a list of packages to ensure are installed at launch.")

; my-packages.el
(require 'cl)

; method to check if all packages are installed
(defun packages-installed-p ()
  (loop for p in required-packages
		when (not (package-installed-p p)) do (return nil)
		finally (return t)))

; if not all packages are installed, check one by one and install the missing ones.
(unless (packages-installed-p)
  ; check for new packages (package versions)
  (message "%s" "Emacs is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  ; install the missing packages
  (dolist (p required-packages)
	(when (not (package-installed-p p))
	  (package-install p))))

;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-font-lock-mode 1)
(xterm-mouse-mode 1)
(load-theme 'zenburn t)

(require 'evil)
(evil-mode 1)

(require 'yasnippet)
(yas-global-mode 1)

(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay .3)

;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:slant italic))))
 )
