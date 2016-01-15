all: backup

backup:
	rm -R emacs.d/
	mkdir -p emacs.d/elpa
	cp -R ~/.emacs.d/elpa/ emacs.d/elpa/
	cp ~/.emacs emacs.el

restore:
	cp -R emacs.d/ ~/.emacs.d/
	cp emacs.el ~/.emacs