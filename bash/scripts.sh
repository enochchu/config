function ant-deploy {
	cmd=war

	if [[ $1 ]]; then
		cmd=$1
	fi

	count=0

	while [[ $count == 0 ]]; do
		pwd

		count=`ls -1 build.xml 2>/dev/null | wc -l`

		if [ $count != 0 ]; then
			ant $cmd

			return;
		fi

		cd ..
	done
}

function gradle-deploy {
	cmd=build

	if [[ $1 ]]; then
		cmd=$1
	fi

	count=0

	while [[ $count == 0 ]]; do
		pwd

		count=`ls -1 build.gradle 2>/dev/null | wc -l`

		if [ $count != 0 ]; then
			ant $cmd

			return;
		fi

		cd ..
	done
}

function check-if-file-exists-by-count {
	return `ls -1 $1 2>/dev/null | wc -l`
}

function browse-url-to-vim {
	links -dump $1 | vim -
}

function browse-url-to-emacs {
	emacs -nw --insert <(links -dump $1)
}

function note {
	local fpath=$HOME/notes.md

	if [ "$1" == "emacs" ]; then
		emacs -nw + $fpath
	elif [ "$1" == "vim" ]; then
		vim + $fpath
	elif [ "$1" == "edit" ]; then
		vim + $fpath
	elif [ "$1" == "cat" ]; then
		cat $fpath
	elif [ "$1" == "date" ]; then
		echo '' >> $fpath
		echo '# '`date +"%m-%d-%Y-%T"` >> $fpath
		echo '---------------------' >> $fpath
	elif [ "$1" == "" ]; then
		less +G $fpath
	else
		echo '' >> $fpath
		echo $@ >> $fpath
	fi
}

function setJDK {
	sudo update-alternatives --config java
	sudo update-alternatives --config javac
	sudo update-alternatives --config javaws
	export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
	echo $JAVA_HOME
	java -version
	javac -version
}

function generate-ctags {
	ctags -R .
}

function generate-ctags-emacs {
	ctags -e -R .
}

function generate-cscope {
	find . -name '*.java' > cscope.files
	cscope -b
}

function generate-tags {
	generate-ctags
	generate-cscope
}