all: backup

backup:
	rm -R emacs.d/
	mkdir emacs.d/
	cp -R ~/.emacs.d/elpa/ emacs.d/
	cp ~/.emacs emacs.el

restore:
	cp -R emacs.d/ ~/.emacs.d/
	cp emacs.el ~/.emacs