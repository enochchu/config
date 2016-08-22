(require 'package)

(add-to-list 'package-archives
	'("melpa" . "https://melpa.org/packages/"))

(when (< emacs-major-version 24)
	(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(package-initialize)

(when (memq window-system '(mac ns))
	(tool-bar-mode -1)
	(exec-path-from-shell-initialize))

(when (eq system-type 'darwin)
	(tool-bar-mode -1)

	(if (find-font (font-spec :name "Source Code Pro"))
		(set-default-font "Source Code Pro 10")))

(when (eq system-type 'gnu/linux)
	(if (find-font (font-spec :name "Inconsolata"))
		(set-default-font "Inconsolata 10")))

(load-theme 'zenburn t)
(require 'evil-multiedit)

(autopair-global-mode t)
(evil-mode 1)
(global-auto-complete-mode t)
(indent-guide-global-mode)
(smooth-scrolling-mode 1)
(tool-bar-mode -1)
(setq column-enforce-comments 80)
(setq inhibit-startup-message t)
(setq initial-major-mode 'text-mode)
(setq initial-scratch-message "")
(setq mode-require-final-newline nil)
(setq mouse-wheel-scroll-amount '(3 ((shift) . 3)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)
(setq scroll-step 1)
(setq require-final-newline nil)
(setq ring-bell-function 'ignore)
(setq-default indent-tabs-mode t)
(setq-default tab-width 4)
(setq-default truncate-lines 1)

(define-key evil-visual-state-map "R" 'evil-multiedit-match-all)
(define-key evil-normal-state-map (kbd "M-d") 'evil-multiedit-match-and-next)
(define-key evil-visual-state-map (kbd "M-d") 'evil-multiedit-match-and-next)
(define-key evil-normal-state-map (kbd "M-D") 'evil-multiedit-match-and-prev)
(define-key evil-visual-state-map (kbd "M-D") 'evil-multiedit-match-and-prev)
(define-key evil-visual-state-map (kbd "C-M-D") 'evil-multiedit-restore)
(define-key evil-multiedit-state-map (kbd "RET") 'evil-multiedit-toggle-or-restrict-region)
(define-key evil-motion-state-map (kbd "RET") 'evil-multiedit-toggle-or-restrict-region)
(define-key evil-multiedit-state-map (kbd "C-n") 'evil-multiedit-next)
(define-key evil-multiedit-state-map (kbd "C-p") 'evil-multiedit-prev)
(define-key evil-multiedit-insert-state-map (kbd "C-n") 'evil-multiedit-next)
(define-key evil-multiedit-insert-state-map (kbd "C-p") 'evil-multiedit-prev)
(evil-ex-define-cmd "ie[dit]" 'evil-multiedit-ex-match)


(global-set-key (kbd "C-]") 'etags-select-find-tag-at-point)
(global-set-key (kbd "C-c /") 'helm-ag-this-file)
(global-set-key (kbd "C-c a") 'ace-jump-mode)
(global-set-key (kbd "C-c b") 'helm-buffers-list)
(global-set-key (kbd "C-c d") 'helm-find-files)
(global-set-key (kbd "C-c e") 'helm-etags-select)
(global-set-key (kbd "C-c f") 'fiplr-find-file)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c t") 'etags-select-find-tag)
(global-set-key (kbd "C-x C-d") 'helm-ls-git-ls)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key [f2] 'evil-mode)
(global-set-key [f3] 'whitespace-mode)
(global-set-key [f4] 'whitespace-cleanup)
(global-set-key [f5] 'column-enforce-mode)
(global-set-key [f6] 'sort-lines)
(global-set-key [f8] 'sr-speedbar-toggle)

;; Multiple Cursors Key Bindlings
(global-set-key (kbd "C-S-d C-S-d") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-word-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-word-like-this)

;; No Window shortcuts
(if (display-graphic-p)
	(progn
		(global-set-key (kbd "C-c f") 'fiplr-find-file))
	(global-set-key (kbd "C-c f") 'fzf))

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

(defun go-to-column (column)
	(interactive "nColumn: ")
	(move-to-column column t))