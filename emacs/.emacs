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
    powerline
    magit
    projectile
    helm
    helm-projectile
    smart-tabs-mode
    markdown-mode
    yasnippet
    company
    ycmd
    company-ycmd
    rtags
    ) "a list of packages to ensure are installed at launch.")

;; my-packages.el
(require 'cl)

;; method to check if all packages are installed
(defun packages-installed-p ()
  (loop for p in required-packages
    when (not (package-installed-p p)) do (return nil)
    finally (return t)))

;; if not all packages are installed, check one by one and install the missing ones.
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
(setq auto-save-default nil) ; Disable auto save
(setq tab-width 4)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)


(require 'powerline)
(powerline-default-theme)

(setq magit-last-seen-setup-instructions "1.4.0")

(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-mode 1)
(helm-autoresize-mode 1)
(setq helm-M-x-fuzzy-match t)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(smart-tabs-insinuate 'c 'javascript)

(require 'evil)
(evil-mode 1)

(require 'yasnippet)
(yas-global-mode 1)

(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay .3)

;; markdown-mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; ycmd
(require 'ycmd)
(set-variable 'ycmd-server-command '("python2" "/home/sakhnik/.vim/bundle/ycm/third_party/ycmd/ycmd/__main__.py"))
(set-variable 'ycmd-global-config "/home/sakhnik/.vim/ycm_extra_conf.py")
(add-hook 'c-mode-common-hook 'ycmd-mode)
(add-hook 'c-mode-common-hook 'company-mode)
(add-hook 'python-mode-hook 'ycmd-mode)
(add-hook 'python-mode-hook 'company-mode)

;; company-ycmd
(require 'company-ycmd)
(company-ycmd-setup)

;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (rtags zenburn-theme zenburn yasnippet solarized-theme smart-tabs-mode powerline markdown-mode magit helm-projectile git-rebase-mode git-commit-mode evil-visualstar evil-surround company-ycmd))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:slant italic)))))
