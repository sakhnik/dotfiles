;;(setq load-path (append (list nil "~/.emacs.d") load-path))
(global-font-lock-mode 1)
(xterm-mouse-mode 1)
;;(require 'redo)

;;(setq viper-mode t)                ; enable Viper at load time
;;(setq viper-ex-style-editing nil)  ; can backspace past start of insert / line
;;(require 'viper)                   ; load Viper
;;(require 'vimpulse)                ; load Vimpulse
;;(setq woman-use-own-frame nil)     ; don't create new frame for manpages
;;(setq woman-use-topic-at-point t)  ; don't prompt upon K key (manpage display)

;;(set-foreground-color "gray")
;;(set-background-color "black")
;;(set-default-font "-sony-fixed-medium-r-normal-*-*-170-*-*-*-*-*-*")

;; Prepare utf-8 to work
;;(set-default-font "-*-*-medium-r-normal-*-14-*-*-*-*-*-iso10646-1")
;;(set-language-environment 'UTF-8)
;;(set-terminal-coding-system 'utf-8)
;;(set-keyboard-coding-system 'utf-8)
;;(prefer-coding-system 'mule-utf-8)
;;(setq default-input-method 'russian-computer)
;;(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

(autoload 'vala-mode "vala-mode" "Major mode for editing Vala code." t)
(add-to-list 'auto-mode-alist '("\.vala$" . vala-mode))
(add-to-list 'auto-mode-alist '("\.vapi$" . vala-mode))
(add-to-list 'file-coding-system-alist '("\.vala$" . utf-8))
(add-to-list 'file-coding-system-alist '("\.vapi$" . utf-8))
