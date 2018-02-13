#!/bin/bash
#
# lurker_mails_by_subj.sh
#
# All this work is useless! (This is a testimony of a failed script.)
# (only this one script, I mean :) )
#
# It is absolutely impossible! Bash can not be used on mailbox with emails of
# various encodings all mixed up, unicode UTF-8, iso8809-1, iso8802-2, maybe
# others (a lurker archive is essentially a mailbox). No such thing as launch
# grep, and wc on such mailbox, which is what I mostly used in this script, and
# get the right number of lines and output messages precisely carved out, no
# way! E.g. UTF-8 is two bytes, and how could Bash know about it? How does it
# make the transition to iso8809-2 of the next mail in the mailbox right?...
# Bash came to be before there was such a thing as multibyte encodings. It
# surely has been taught about it, but is lacking in that respect. Where
# exactly the lines were mixed and how, would be a matter of detailed studying,
# no time, but it surely is because of the mixed encodings in one file.
#
# And I doubt (but don't know, I am indeed less certain of it) that sed could
# be used either. But sed is so high-brow, I read its info pages, but haven't
# managed to understand all of it. And if also with sed Bash wouldn't work
# anyway on these mixed encodings file, giving it a try would be another day
# lost.
#
# So I leave this in my lurker_frozen repo as a testimony of a failed script.
# Of what Bash can not do... Mastering Perl, I guess, is my future hours of
# work, some day.
#
function ask()
{
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}

lurker_list="iskon-tcom-mr_180209_033913_O"
srch_subj="^Subject:.*zahtjeva.*"

lurker_list_wc_l=$(cat $lurker_list | wc -l)
echo "We will work on the list $lurker_list, which is $lurker_list_wc_l lines"
echo \$srch_subj: $srch_subj
#read FAKE
#echo $srch_subj | sed "s/\^Subject:\.\*\([[:alnum:]]*\).*\.\*/\1/"
srch_subj_norm=$(echo $srch_subj | sed "s/\^Subject:\.\*\([[:alnum:]]*\).*\.\*/\1/")
echo "Normalized name for this regexp (to be used for creating tmp files) will be:"
echo \$srch_subj_norm: $srch_subj_norm
read FAKE
check_srch_subj_norm=$(echo check_${srch_subj_norm})
check_srch_subj_norm="0"
echo \$check_srch_subj_norm: $check_srch_subj_norm
read FAKE

echo "grep -a $srch_subj $lurker_list"
#read FAKE
grep -a $srch_subj $lurker_list
echo "grep -a $srch_subj $lurker_list | wc -l"
#read FAKE
grep -a $srch_subj $lurker_list | wc -l
#read FAKE
num_msg_with_subj=$(grep -a $srch_subj $lurker_list | wc -l)
echo "That is: $num_msg_with_subj containing the regexp \"$srch_subj\""
echo "We'll next try to list all of the messages, one by one."
#read FAKE
> GREP_${srch_subj_norm}.txt;
ls -l GREP_${srch_subj_norm}.txt;
# using $lurker_list_wc_l because it can't be more needed
echo "Enter \"1\" without quotes if you deem this test is no more necessary on this \$srch_subj ("$srch_subj"):"
read check_srch_subj_norm
echo \$check_srch_subj_norm: $check_srch_subj_norm
echo "Set i to different than 1?"
ask
if [ "$?" == 0 ]; then
	read i
else
	i=1
fi
if [ "$check_srch_subj_norm" != "1" ]; then
	while [ "$i" -lt "$(echo $num_msg_with_subj + 1|bc)" ]; do
		# this should list all finds, every time one more:
		#grep -B$lurker_list_wc_l -m${i} $srch_subj $lurker_list | grep $srch_subj
		grep -a -A1 -B$lurker_list_wc_l -m${i} $srch_subj $lurker_list | grep $srch_subj | wc -l
		#read FAKE
		# And now we want to check that all subjects are right (mail is sorted in
		# threads by subject --and by "Message-ID"s--, when subject maimed, as my
		# provider do --apparently on purpose--, no thread, message is stranded,
		# conversation becomes incomprehensible; on purpose is maiming of both
		# the subjects and the Message-ID's, of the latter maybe further below
		# or in some other script)
		#grep -a -A1 -B$lurker_list_wc_l -m${i} $srch_subj $lurker_list | grep -a -A1 $srch_subj | tail -2
		#read FAKE
		# But that must be done auto. Redirected in a file and sorted uniq, and if
		# only two lines, OK.
		grep -a -A1 -B$lurker_list_wc_l -m${i} $srch_subj $lurker_list | grep -a -A1 $srch_subj | tail -2 \
			>> GREP_${srch_subj_norm}.txt
		#read FAKE
		let i=$i+1
	done
	echo "cat GREP_${srch_subj_norm}.txt | sort -u"
	#read FAKE
	cat GREP_${srch_subj_norm}.txt | sort -u
	echo "Enter \"1\" without quotes if you deem this test is no more necessary on this \$srch_subj ("$srch_subj"):"
	read check_srch_subj_norm
	echo \$check_srch_subj_norm: $check_srch_subj_norm
fi
# That correct (manual check needed), we want to extract each message of the
# thread. I've only gradually learned sufficiently about mail and archiving
# them and lurker, some of the messages in my lurker archives are drafts, some
# are sent copies over which of couse the BCC messages are preferred when I
# sent them, and the drafts and sent of the same messages must be removed from
# the lurker archive.
#
# All the mail in lurker archive of each list start with the regexp
# "^From lurker.*".
from_lurker="^From lurker.*"
# So this shouldn't be too hard. We take each of the $num_msg_with_subj grep to
# the immediately previous $from_lurker, and grep from that to the immediately
# following $from_lurker, and that's that message.
#
# A little easier said than done. Same loop, modified and closer to real work
# now.
while [ "$i" -lt "$(echo $num_msg_with_subj + 1|bc)" ]; do
	#echo \$srch_subj: $srch_subj
	#echo \$lurker_list: $lurker_list
	#echo \$lurker_list_wc_l: $lurker_list_wc_l
	#read FAKE
	# Only here for checking. It'll spam the terminal with entire output to the
	# regexp
	#grep -a -A1 -B$lurker_list_wc_l -m${i} $srch_subj $lurker_list
	#read FAKE
	# This one lists just the $from_lurker lines. Still many, but not spamming.
	#grep -a -A1 -B$lurker_list_wc_l -m${i} $srch_subj $lurker_list \
	#	| grep "$from_lurker"
	#read FAKE
	#grep -a -A1 -B$lurker_list_wc_l -m${i} $srch_subj $lurker_list \
	#	| grep "$from_lurker" | wc -l
	#read FAKE
	echo $i
	from_lurker_wc_l=$(grep -a -A1 -B$lurker_list_wc_l -m${i} $srch_subj $lurker_list \
		| grep "$from_lurker" | wc -l)
	echo \$from_lurker_wc_l: $from_lurker_wc_l
	read FAKE
	# We now need the context after the line that is $from_lurker_wc_l in
	# order, which is the immediately previous to our $srch_subj. Again taking
	# all the context from there.
	# Only here for checking. It'll spam the terminal with entire output from the
	# regexp
	#grep -a -A1 -B$lurker_list_wc_l -m${i} $srch_subj $lurker_list \
	#	| grep -A$lurker_list_wc_l -m${from_lurker_wc_l} "$from_lurker"
	#read FAKE
	# This one lists just the $from_lurker lines. Still many, but not spamming.
	echo \$lurker_list_wc_l: $lurker_list_wc_l
	read FAKE
	grep -a -A$lurker_list_wc_l -B$lurker_list_wc_l -m${i} $srch_subj $lurker_list \
		| grep -A$lurker_list_wc_l -m${from_lurker_wc_l} "$from_lurker" | wc -l
	# So the message of ordinal $i should be btwn the $from_lurker of ordinal
	# $from_lurker_wc_l and the next $from_lurker (the ordinals are each of its own).
	# The next $from_lurker being of the ordinal $from_lurker_wc_l_plus_1
	from_lurker_wc_l_plus_1=$(echo $from_lurker_wc_l + 1|bc)
	read FAKE
	grep -a -A$lurker_list_wc_l -B$lurker_list_wc_l -m${i} $srch_subj $lurker_list \
		| grep -m${from_lurker_wc_l} "$from_lurker"
	read FAKE
	echo "Is this the last line above?"
	echo cat $lurker_list \| grep -m${from_lurker_wc_l} "$from_lurker" \| tail -1
	cat $lurker_list | grep -m${from_lurker_wc_l} "$from_lurker" | tail -1
	lines_fro_lurker_wc_l=$(cat $lurker_list | grep -m${from_lurker_wc_l} "$from_lurker" | tail -1)
	read FAKE
	echo "And this the number of lines to that last line?"
	grep -a -A$lurker_list_wc_l -B${lurker_list_wc_l} -m${i} $srch_subj $lurker_list \
		| grep -B$lurker_list_wc_l -m${from_lurker_wc_l} "$from_lurker" | wc -l
	lines_fro_lurker_wc_l=$(grep -a -A$lurker_list_wc_l -B${lurker_list_wc_l} -m${i} $srch_subj $lurker_list \
		| grep -B$lurker_list_wc_l -m${from_lurker_wc_l} "$from_lurker" | wc -l)
	echo \$lines_fro_lurker_wc_l: $lines_fro_lurker_wc_l
	read FAKE
	# Incremented by 1 the count of from_lurker_wc_l
	from_lurker_wc_l_plus_1=$(echo ${from_lurker_wc_l}+1|bc)
	echo \$from_lurker_wc_l_plus_1: ${from_lurker_wc_l_plus_1}
	read FAKE
	echo "And this the next to last \$from_lurker from the last line above?"
	echo cat $lurker_list \| grep -m${from_lurker_wc_l_plus_1} "$from_lurker" \| tail -1
	cat $lurker_list | grep -m${from_lurker_wc_l_plus_1} "$from_lurker" | tail -1
	echo "And the number of lines to it?"
	# I've noticed here different output with -a flag and without. The
	# differing parts are the ones where the encoding was, kind of, subverted
	# by the sender (the usual one that messes up the subjects and the
	# Message-ID's, see above); it can be even be encoding messed by the sender
	# of the replied to message
	#cat $lurker_list \
	#	| grep -a -B$lurker_list_wc_l -m${from_lurker_wc_l_plus_1} "$from_lurker" > TMP
	#ls -l TMP
	#read FAKE
	# Apparently better results with -a flag
	cat $lurker_list \
		| grep -a -B$lurker_list_wc_l -m${from_lurker_wc_l_plus_1} "$from_lurker" | wc -l
	lines_fro_lurker_wc_l_plus_1=$(cat $lurker_list \
		| grep -a -B$lurker_list_wc_l -m${from_lurker_wc_l_plus_1} "$from_lurker" | wc -l)
	echo \$lines_fro_lurker_wc_l_plus_1: $lines_fro_lurker_wc_l_plus_1
	read FAKE
	# The ingredients for carving out the
	# $num_msg_with_subj the ordinal of the message with the $srch_subj
	# $lurker_list_wc_l total num lines of $lurker_list
	# $lines_fro_lurker_wc_l and $lines_fro_lurker_wc_l_plus_1 the from and
	# to $from_lurker
	# First the calculation of the tail number. I think tail needs to added 1 to.
	msg_with_subj_calc_fro_tail=$(echo $lurker_list_wc_l-$lines_fro_lurker_wc_l|bc)
	msg_with_subj_calc_fro_tail=$(echo $msg_with_subj_calc_fro_tail+1|bc)
	echo \$msg_with_subj_calc_fro_tail: $msg_with_subj_calc_fro_tail
	cat $lurker_list | tail -${msg_with_subj_calc_fro_tail} | wc -l
	msg_with_subj_calc_to_head=$(echo $lines_fro_lurker_wc_l_plus_1-$lines_fro_lurker_wc_l|bc)
	echo \$msg_with_subj_calc_to_head: $msg_with_subj_calc_to_head
	echo cat $lurker_list \| tail -${msg_with_subj_calc_fro_tail} \| head -${msg_with_subj_calc_to_head}
	cat $lurker_list | tail -${msg_with_subj_calc_fro_tail} \
		| head -${msg_with_subj_calc_to_head} > ${msg_with_subj}_${i}.eml

	# Probably delete 18 lines below.
	#msg_srch_subj_norm_ord_fro=$(cat $lurker_list | grep -m${from_lurker_wc_l} "$from_lurker" | tail -1)
	#echo \$i: $i
	#echo \$msg_srch_subj_norm_ord_fro: "$msg_srch_subj_norm_ord_fro"
	#read FAKE
	#echo "That's where mail ordinal $i starts, and it ends at before:"
	#read FAKE
	#msg_srch_subj_norm_ord_to=$(echo msg_${srch_subj_norm}_${i}_to)
	#echo \$msg_srch_subj_norm_ord_to: $msg_srch_subj_norm_ord_to
	#read FAKE
	#cat $lurker_list | grep -m${from_lurker_wc_l_plus_1} "$from_lurker" | tail -1
	#msg_srch_subj_norm_ord_to=$(cat $lurker_list | grep -m${from_lurker_wc_l_plus_1} "$from_lurker" | tail -1)
	#echo \$msg_srch_subj_norm_ord_to: $msg_srch_subj_norm_ord_to
	#read FAKE
    #
	#echo "And so the message is:"
	#read FAKE
	#grep -A${lurker_list_wc_l} "$msg_srch_subj_norm_ord_fro" $lurker_list \
	#	| grep -B${lurker_list_wc_l} "$msg_srch_subj_norm_ord_to" $lurker_list
	read FAKE
	let i=$i+1
	echo $i
	read FAKE
done
