#!/bin/bash
#
# My lurker after run of lurker-regenerate gets its /var/lib/lurker/www/ deleted
# somehow. Priority get it useable. Once find time, investigate, and maybe
# report the bug.
#
if [ ! -n "$1" ]; then
	echo "give full path to the backup of /var/lib/lurker/www/ tar.gz archive"
	echo "It must have been tar-gzip archived from /, i.e. so that"
	echo "tar tf that_archive"
	echo "var/lib/lurker/www/"
	echo "var/lib/lurker/www/mindex/"
	echo "..."
	# I'm including it as var_lib_lurker_www_180213_bak_OK.tar.gz in the repo.
	echo "I use $HOME/BAK/var_lib_lurker_www_[timestamp_here]_bak_OK.tar.gz"
	echo "which was previosly completely pruned of any non-necessary html pages"
	exit 0
fi
lurker_www_bak=$1
echo $lurker_www_bak: $lurker_www_bak
ls -l $lurker_www_bak
if [ ! -e $lurker_www_bak ]; then
	echo "The:"
	echo "$lurker_www_bak"
	echo "that you gave, does not exist:"
	echo "ls -l \$lurker_www_bak"
	ls -l $lurker_www_bak
	exit 1
fi
echo "First is the echo of the command string to run."
echo "Once you hit Enter that string will be actually issued and executed."
#echo lurker-regenerate 
#read FAKE
#lurker-regenerate 
echo "tar tf $lurker_www_bak | head"
read FAKE
if [ ! -e "/var/lib/lurker/www/" ]; then
	#tar tf $lurker_www_bak | head
	echo "tar xf \$lurker_www_bak -C /"
	read FAKE
	tar xf $lurker_www_bak -C /
	echo "cd /var/lib/lurker/"
	#cd /var/lib/lurker/
	#ls -l
	#read FAKE
	#echo ls -lR
	#read FAKE
	#ls -lR
	#read FAKE
	echo "cd -"
	read FAKE
	cd -
	#echo "/etc/init.d/apache2 restart"
	#read FAKE
	#/etc/init.d/apache2 restart
else
	echo "The /var/lib/lurker/www/ exists! Maybe no need to restore it? Pls. peruse:"
	echo "ls -l /var/lib/lurker/"
	read FAKE
	ls -l /var/lib/lurker/
	echo "ls -lR /var/lib/lurker/www/"
	read FAKE
	ls -lR /var/lib/lurker/www/
fi
