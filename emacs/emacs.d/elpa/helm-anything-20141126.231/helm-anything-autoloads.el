;;; helm-anything-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (directory-file-name (or (file-name-directory #$) (car load-path))))

;;;### (autoloads nil "helm-anything" "helm-anything.el" (0 0 0 0))
;;; Generated autoloads from helm-anything.el

(autoload 'helm-anything-resume "helm-anything" "\
Resurrect previously invoked `helm' or `anything'.
Called with a prefix arg, allow choosing among all existing
helm/anything buffers.  i.e choose among various helm/anything sessions.
Called from lisp, you can specify a buffer-name as a string with PARG.

\(fn PARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "helm-anything" '("helm-anything")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; helm-anything-autoloads.el ends here
