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
read NOP
tar tf $lurker_www_bak | head
echo "(tar tf $lurker_www_bak | head)"
if [ -n "$2" ]; then
    list_name="$2"
    echo \$list_name: $list_name
    echo "and is there a list named so?"
    if ( grep Alias /etc/apache2/conf-enabled/lurker.conf | grep $list_name ); then
        echo "Yes. Will untar and rename to (untar as) $list_name."
    fi
else
    echo "Not given a list name in \$2. I need y/Y to proceed and untar as:"
    ask "/var/lib/lurker/www/ (if not exists)"
    if [ "$?" == 0 ]; then
        if [ ! -e "/var/lib/lurker/www/" ]; then
            echo "Will do."
        else
            echo "The /var/lib/lurker/www/ exists! Maybe no need to restore it? Pls. peruse:"
            echo "ls -l /var/lib/lurker/"
            read FAKE
            ls -l /var/lib/lurker/
            echo "ls -lR /var/lib/lurker/www/"
            read FAKE
            ls -lR /var/lib/lurker/www/
            exit 0
        fi
    fi
    list_name="www"
fi
TMP="$(mktemp -d "/tmp/$$.XXXXXXXX")"
ls -ld $TMP
tar xf $lurker_www_bak -C $TMP
cd $TMP
mv -v var/lib/lurker/www $list_name
if [ ! -e "/var/lib/lurker/$list_name" ]; then
    mv -v $list_name /var/lib/lurker/
    ls -ld /var/lib/lurker/$list_name
    echo "(ls -ld /var/lib/lurker/$list_name)"
    echo "ls -lR /var/lib/lurker/$list_name"
    read NOP
    ls -lR /var/lib/lurker/$list_name
    echo "(ls -lR /var/lib/lurker/$list_name)"
fi
