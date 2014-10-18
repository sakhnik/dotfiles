(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)

(package-initialize)

(defvar required-packages
  '(
    evil
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

(require 'font-lock)
(copy-face 'italic 'font-lock-comment-face)
(setq font-lock-comment-face 'italic)

(require 'evil)
(evil-mode 1)
