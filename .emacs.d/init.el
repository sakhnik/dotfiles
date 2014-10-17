(global-font-lock-mode 1)
(xterm-mouse-mode 1)

(require 'font-lock)
(copy-face 'italic 'font-lock-comment-face)
(setq font-lock-comment-face 'italic)

(add-to-list 'load-path "~/.emacs.d/undo-tree")
(require 'undo-tree)

(add-to-list 'load-path "~/.emacs.d/evil")
(setq evil-shift-width 4)
(require 'evil)
(evil-mode 1)
