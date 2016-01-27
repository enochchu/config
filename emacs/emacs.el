(require 'package)

(add-to-list 'package-archives
	'("melpa" . "https://melpa.org/packages/"))

(when (< emacs-major-version 24)
	(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(package-initialize)

(load-theme 'material t)

(autopair-global-mode t)
(evil-mode 1)
(global-auto-complete-mode t)
(indent-guide-global-mode)
(menu-bar-mode -1)
(setq inhibit-startup-message t)
(setq initial-major-mode 'text-mode)
(setq initial-scratch-message "")
(setq mode-require-final-newline nil)
(setq require-final-newline nil)
(setq ring-bell-function 'ignore)
(setq-default indent-tabs-mode t)
(setq-default tab-width 4)
(setq-default truncate-lines 1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

(when (eq system-type 'darwin)
	(set-default-font "Source Code Pro 10"))

(when (eq system-type 'gnu/linux)
	(set-default-font "Courier 10"))

(global-set-key (kbd "C-1") 'helm-buffers-list)
(global-set-key (kbd "C-c a") 'ace-jump-mode)
(global-set-key (kbd "C-c f") 'helm-browse-project)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-j") 'move-text-down)
(global-set-key (kbd "C-k") 'move-text-up)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "TAB") 'self-insert-command)
(global-set-key [f1] 'neotree-toggle)
(global-set-key [f2] 'whitespace-mode)
(global-set-key [f3] 'whitespace-cleanup)
(global-set-key [f4] 'column-enforce-mode)
(global-set-key [f5] 'sort-lines)
(global-set-key [f8] 'sr-speedbar-toggle)

(setq fiplr-ignored-globs
	'((directories (".git" ".svn" "bin"))
	(files ("*.jpg" "*.png" "*.zip" "*~" "*.class" "*.jar" "*.war" ".DS_Store"))))

(setq org-publish-project-alist
	'(("org"
		:base-directory "./"
		:publishing-directory "./"
		:publishing-function org-html-publish-to-html
		:section-numbers nil
		:with-toc nil
	)))

(defun goto-column (column)
	(interactive "nColumn: ")
	(move-to-column column t))