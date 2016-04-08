EMACS_FOLDER=~/.emacs.d

all: backup

backup:
	rm -R emacs.d
	cp -R ~/.emacs.d ./emacs.d
	cp ~/.emacs emacs.el

destroy:
	rm -R ~/.emacs.d/
	rm ~/.emacs

restore:
	cp -R emacs.d/ ~/.emacs.d/
	cp emacs.el ~/.emacs