#!/bin/bash
#
# mail_bkp_rsync_sample_1.sh
#
# Copyright (C) 2015 Miroslav Rovis, <http://www.CroatiaFidelis.hr/>
# Use this at your own risk!
# released under BSD license, see LICENSE, or assume general BSD license,
#
# fixing, and uniting my mail archives, Archives are gotten with Mutt, that
# sends mail via Postfix, and downloads mail with Getmail, along with sorting
# mail with Maildrop.
#
# The issue here is Mutt, by user action, having moved mail, which mutt does by
# totally renaming each mail moved to other maildir, *at file level*. So rsync
# can't know which mails are same.  Only grep'ing for Message-ID can find it
# out. Long work, bad...
#
# I'll place this script in the lurker_frozen repo that I'm creating for
# publishing a mail collection using lurker, and some bash scripting, for some
# particular legal/moral issues that I have, even though, strictly speaking, it
# does not belong to it.
#
# But, potentially, these scripts samples can be useful for somebody sorting
# their mail archive snapshots into one complete archive, which can be an issue
# very much related with the issues dealt with in my lurker_frozen repo.
#
# These mail_bkp_rsync_sample_X.sh is what I used to make me one complete mail
# archive for a longer period with many snapshots. I.e., I used them to, while
# not losing any mails, neither have any duplicates for that period. The
# Maildir_151007/ and Maildir_150921/ were maildir snapshots that I used
# (151007 is 2015-10-07, 150921 is 2015-09-21).
#
# I'm actually posting these dirty scripts as samples, Only one script should
# be there, but I might do that only if I work some day on my really old mail
# backup, ever (because the last few years I have done with these scripts).
# likely not happening soon.
#

if [ $# -eq 0 ]; then
	 echo "give two dirs for rsync'ing (read the script)"
	exit 0
fi

mdir_fro=$1
mdir_to=$2

echo \$mdir_fro: $mdir_fro # originally it was Maildir_150921 and Maildir_151007,
echo \$mdir_to: $mdir_to   # which is 2015-09-21 etc. so there are variables like
                           # other921 below

echo "############################"
echo "WARNING removing w/o warning"
echo "############################"
sleep 1

	# The start below can be as bad as:
	#$(rsync -nav --delete $mdir_fro/ $mdir_to/ | grep '/cur/1' | sed 's/\(.*\)\/cur\/14.*/\1/' | sort -u | grep 'mrovis@inethr.alsa-userlistssourceforgenet\|mrovis@inethr.cinelerralistscinelerra-cvorg\|mrovis@inethr.cinelerraskolelinuxno\|mrovis@inethr.mailmanskolelinuxno\|mrovis@inethr.mailmanwiresharkorg\|mrovis@inethr.mencoder-usersmplayerhqhu\|mrovis@inethr.mplayer-usersmplayerhqhu\|mrovis@inethr.wireshark-userswiresharkorg'); do
	#rsync -nav --delete $mdir_fro/ $mdir_to/ | grep deleting | sed 's/deleting //' | grep '/cur/1' | sed 's/\(.*\)\/cur\/14.*/\1/' | sort -u 
	#rsync -nav --delete Maildir_151007/ Maildir_150921/ | grep deleting | sed 's/deleting //' | grep '/cur/1'
	#rsync -nav --delete Maildir_151007/ Maildir_150921/ | grep deleting | sed 's/deleting //' | grep '/cur/1' | wc -l
	#rsync -nav --delete Maildir_151007/ Maildir_150921/ | grep deleting | sed 's/deleting //' | grep '/cur/1' | sort | wc -l
	#read FAKE
#for subdir in \
	for mail_part in $(rsync -nav --delete $mdir_fro/ $mdir_to/ | grep '/cur/14'); do
	#ls -ld $mdir_fro/$subdir
	#for mail in $(ls -1 $mdir_fro/$subdir/cur/* | grep '\/cur\/14'); do
		mail=$mdir_fro/$mail_part
		echo ls -l \$mail
		ls -l $mail
		msg_id=$(grep -i "^Message-ID: " $mail)
		echo \$msg_id: $msg_id
		#read FAKE
		if ! ( echo "$msg_id" | tr '\012' ' ' | sed 's/<//' | grep '<' ); then
			echo has only one \$msg_id, workable so far
		else
			echo making it workable
			echo $msg_id | sed 's/ /\n/g';
			echo $msg_id | sed 's/ /\n/g' | head -2
			msg_id=$(echo $msg_id | sed 's/ /\n/g' | head -2| sed 's/\n/ /g'| tr '\012' ' '|sed 's/ //g' | sed 's/:</: </');
			echo next echoing \$msg_id
			echo \""$msg_id"\"
		fi
		echo \$msg_id: $msg_id
		# The thing about this is, I think, if no finds, at the point below or
		# elsewhere, then if lists it all forever...  I know i can get the
		# pid=$! if I first send it to background... But how exactly. Maybe:
		grep -rIl "$msg_id" $mdir_to/ & pid=$! && sleep 10 && kill $pid &
		#grep -rIl "$msg_id" $mdir_to/
		echo next various comparisons to \$mail
		grep -rIl "$msg_id" $mdir_to/ | grep -v $mail | wc -l
		num_mails_921=$(grep -rIl "$msg_id" $mdir_to/ | grep -v $mail | wc -l) 
		if [ "$num_mails_921" != "0" ]; then
			if [ "$num_mails_921" == "1" ]; then
				echo is unique
				other921=$(grep -rIl "$msg_id" $mdir_to/ | grep -v $mail );
				echo ls -l \$other921
				ls -l $other921
				echo diff -s $mail $other921
				if ( diff -s $mail $other921 ); then
					if [ "$mail" != "$other921" ]; then
						sha256sum $mail
						sha256sum $mail | cut -d' ' -f1
						mail_sum=$(sha256sum $mail | cut -d' ' -f1)
						sha256sum $other921
						sha256sum $other921 | cut -d' ' -f1
						other921_sum=$(sha256sum $other921 | cut -d' ' -f1)
						if [ "$mail_sum" == "$other921_sum" ]; then
							rm -v $mail # First is testing with 'rm -iv', then turn to 'rm -v'
						fi
					fi
				else
					num_ln_diff=$( diff -s $mail $other921 | wc -l )
					echo \$num_ln_diff: $num_ln_diff
					if [ "$num_ln_diff" -lt 7 ]; then
						if ( diff -s $mail $other921 | grep '> Content-Length: ' ); then
							rm -v $mail # See a few lines above
						fi
					fi
				fi
			else echo is NOT unique
			fi
			# remains to be done:
			#echo grep -rI "$msg_id" $mdir_fro/
			#read FAKE
			#grep -rI "$msg_id" $mdir_fro/
			#newer=$(grep -rIl "$msg_id" $mdir_fro/)
			#ls -l $newer
		else
			echo no other than the \$mail at start of this loop instance
		fi
	done
#	echo OUTER DONE
#done

