(require 'package)

(add-to-list 'package-archives
	'("melpa" . "https://melpa.org/packages/"))

(when (< emacs-major-version 24)
	(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(package-initialize)

(when (memq window-system '(mac ns))
	(exec-path-from-shell-initialize))

(when (eq system-type 'darwin)
	(tool-bar-mode -1)

	(if (find-font (font-spec :name "Source Code Pro"))
		(set-default-font "Source Code Pro 12")))

(when (eq system-type 'gnu/linux)
	(if (find-font (font-spec :name "Inconsolata"))
		(set-default-font "Inconsolata 10")))

(if (display-graphic-p)
	(progn
	  (load-theme 'sanityinc-tomorrow-night t)
	  (menu-bar-mode -1)
	  (toggle-scroll-bar -1)))

(require 'evil-multiedit)

(autopair-global-mode t)
(evil-mode 1)
(global-auto-complete-mode t)
(projectile-global-mode)
(indent-guide-global-mode)
(setq column-enforce-comments 80)
(setq inhibit-startup-message t)
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
(smooth-scrolling-mode 1)
(tool-bar-mode -1)

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

(global-set-key (kbd "C-c <left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-c <right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-c <down>") 'shrink-window)
(global-set-key (kbd "C-c <up>") 'enlarge-window)

(global-set-key (kbd "C-]") 'etags-select-find-tag-at-point)
(global-set-key (kbd "C-c /") 'helm-do-ag-this-file)
(global-set-key (kbd "C-c 1") 'ace-jump-buffer)
(global-set-key (kbd "C-c a") 'ace-jump-mode)
(global-set-key (kbd "C-c w") 'ace-window)
(global-set-key (kbd "C-c b") 'helm-buffers-list)
(global-set-key (kbd "C-c f") 'helm-grep-do-git-grep)
(global-set-key (kbd "C-c s") 'helm-do-ag)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c T") 'etags-select-find-tag)
(global-set-key (kbd "C-c t") 'helm-etags-select)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key [f1] 'neotree-toggle)
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

(defun kill-all-other-buffers ()
	"Kill all other buffers."
	(interactive)
	(mapc 'kill-buffer (delq (current-buffer) (buffer-list))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elfeed-feeds
   (quote
	("https://news.ycombinator.com/rss" "http://kotaku.com/rss" "http://www.newyorker.com/feed/news" "http://www.newyorker.com/feed/everything" "https://www.theguardian.com/uk/rss" "http://www.anandtech.com/rss/" "https://www.reddit.com/r/programming/.rss" "https://www.reddit.com/r/politics/.rss" "https://www.reddit.com/r/all/.rss" "https://www.techdirt.com/techdirt_rss.xml")))
 '(package-selected-packages
   (quote
	(w3m w3 elfeed zenburn-theme whitespace-cleanup-mode web-mode visual-regexp sx sr-speedbar smooth-scrolling smooth-scroll sass-mode regex-tool php-mode noctilux-theme neotree multiple-cursors move-text mmm-mode material-theme magit linum-relative indent-guide icicles helm-projectile helm-ls-git helm-git-files helm-git helm-ag-r helm-ag grizzl grails-mode gradle-mode git-gutter fzf fuzzy flycheck exec-path-from-shell evil-multiedit etags-select ecb dirtree-prosjekt cyberpunk-theme ctags column-enforce-mode color-theme-sanityinc-tomorrow color-theme avy-menu autopair auto-complete ag ack ace-window ace-jump-mode ace-jump-buffer))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
