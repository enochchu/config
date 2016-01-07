all: backup

backup:
	cp ~/.atom/config.cson config.cson
	cp ~/.atom/keymap.cson keymap.cson
	cp ~/.atom/styles.less style.less
	apm list --installed --bare > packages.list

restore:
	cp config.cson ~/.atom/config.cson
	cp keymap.cson ~/.atom/keymap.cson
	cp style.less ~/.atom/styles.less
	apm install `cat packages.list`
