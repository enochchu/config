(require 'package)

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
					(not (gnutls-available-p))))
	   (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))

(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(package-initialize)

(autopair-global-mode t)

(menu-bar-mode -1)

(tool-bar-mode -1)

(color-theme-sanityinc-tomorrow-blue)

(add-hook 'after-init-hook 'global-company-mode)

;; Setup - Auto Complete
(global-auto-complete-mode t)

;; Setup - Whitespace
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

;; General Settings
(setq column-enforce-comments 80)
(setq-default indent-tabs-mode nil)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq initial-major-mode 'text-mode)
(setq initial-scratch-message "")
(setq mode-require-final-newline nil)
(setq mouse-wheel-follow-mouse 't)
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-scroll-amount '(3 ((shift) . 3)))
(setq require-final-newline nil)
(setq ring-bell-function 'ignore)
(setq scroll-step 1)
(setq-default indent-tabs-mode t)
(setq-default tab-width 4)
(setq-default truncate-lines 1)

;; Global Set Keys (General)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-c b") 'buffer-menu)
(global-set-key (kbd "C-c l") 'locate)
(global-set-key (kbd "C-c w") 'other-window)

;; Global Set Keys (Ace Jump Mode)
(global-set-key (kbd "C-c a") 'ace-jump-mode)

;; Global Set Keys (Evil Mode Toggle)
(global-set-key (kbd "<f2>") 'evil-mode)

;; Global Set Keys (EACL)
(global-set-key (kbd "C-x C-l") 'eacl-complete-line)
(global-set-key (kbd "C-x C-;") 'eacl-complete-statement)

;; Fiplr Settings
(setq fiplr-ignored-globs
	'((directories (".git" ".svn" "bin"))a
	(files ("*.jpg" "*.png" "*.zip" "*~" "*.class" "*.jar" "*.war" ".DS_Store"))))

;; Personal Notes
;; C-SPACE: begin a selection ("set mark")
;; C-a: move cursor to start of line
;; C-n: move cursor to next line
;; C-u -4 C-x TAB Deindent
;; C-u 4 C-x TAB Indent
;; C-y: paste ("yank")
;; M-w: copy region
