#!/bin/bash
#
# lurker_frozen_rm_form_rewrite.sh           <-- The main script of the repo.
#
# rewrite live lurker mail pages where content btwn form tags originally
# belongs, for non-interactive HTML-only frozen lurker snapshot of live lurker.
#
# Copyright (C) 2018 Miroslav Rovis, <https://www.CroatiaFidelis.hr/>
# Use this at your own risk!
# released under BSD license, see LICENSE, or assume general BSD license,
#
# frozen lurker (wget -m -nH http://some/where.html lurker download, not live
# with CGI) is only HTML, so content btwn <form and /form> tags: removed.
#
# I have an email archive with all the correspondence with some misdeeds of my
# providers (the previous and the current one), the issues with that archive is
# also mails by the provider being deliberately without In-Reply-To headers, as
# well as with regularly maimed subject headers. I have, keeping the original
# lurker's own mailbox of the list in question, edited a copied instance of
# that lurker's mailbox (it's just gunzip'ing it somewhere), and manipulated
# the necessary headers in that copy by inserting the Message-ID of the message
# to which the particular provider's mail was a reply to, inserting that
# Message-ID as In-Reply-To header of course. Manual work that was, expensive
# in terms of time.
#
# And the lurker_frozen_rm_form.sh which I first wrote is now not sufficient
# for me. What I want to do with this script is: remove the forms as in the
# previous script just mentioned, but also insert links to the original maimed
# mails that have hardly any threads because of the missing In-Reply-To and the
# ruined subjects headers. For two reasons. The first: original emails are
# still original emails, even though the mail standards are so very lacking
# that email, in their headers part, can not at all easily be verifiable... And
# the second: that's abusing of mail, and abusing against users, what those
# mailmasters did to me, and which they have a habit with many other users
# ("Croatian" Telekom, or "Hrvatski" Telekom, is over 80% of the internet in
# Croatia). I'm trying to cry out publicly and get those kind of behavior
# change for the better in my Croatia, because I'm ashamed of it, and the
# public in Croatia should be, and the outcry should change that!
#
# So I want to have two archives, each with it's own mails and threads pages.
# The original emails archive, with the maimed subject and hardly any threads,
# and information very obfuscated because you have hard time finding how the
# conversation evolved, those original emails in each of it's pages would link
# to the same exact email page on the corrected emails archive, where the
# threads are easy to follow, and information is, but only through this
# (primitive) reverse engineering, restored and (more) clear.
# And in the corrected emails archive there would be the same kind of link, but
# in the reverse direction.
#
# (
# I wrote only that the information in the corrected emails archive is (more)
# clear. There is another correction to be made, and that is, the idiotic HTML
# entities, and HTML in general, when it is without text, still make some email
# pages hard to read.  But that's a separate script to make, and probably in
# Perl, to modify those offending emails by decrypting the base64 parts,
# automatically converting the HTML entities, and even re-encrypting those
# parts of the particular mail back to base 64. Later, who knows when...
# )
#
# Dirty, but works for me. Lurker is (too little) used. E.g. you don't even get
# it in Gentoo Portage (my former home distro:
# Need help creating ebuild for "lurker"
# https://forums.gentoo.org/viewtopic-t-228582.html
# ). Should be used. Nicer, offers great threads (though improvable, to get
# them like in Mutt), good searching, as few mail-to-web programs do. See:
# Dng mailing list [note: the Devuan mailing list, my current home distro]
# https://mailinglists.dyne.org/cgi-bin/mailman/listinfo/dng
#
# If you're among the very few people who might need this, and not very
# advanced, a tip: uncomment all the '#read FAKE' lines, and study what the
# script does. You should get, e.g. your wget mirrored local lurker mail
# archive free of all content within form tags (which are a user-confusing part
# on a frozen HTML-only lurker download). Pls. see:
# http://www.croatiafidelis.hr/foss/cenz/iskon-tcom-mr/ to get what I mean.
#
# I think this could be used on live lurker archives on the internet, but
# haven't tried (I tried it only on my SOHO Apache2 run Lurker). In that use
# the legal aspect of mirroring might need to be looked at. 
# (
# A note is due here: if you want to see what I managed to do with this script
# of mine:
# https://www.croatiafidelis.hr/foss/cenz/iskon-tcom-mr/
# you'll find disclaimers by my current provider in all of their emails. Don't
# worry about those. I stipulated before I accepted the contract they offered
# that I do not accept blank ban on revealing my correspondence with them, and
# they contracted me as user anyway. Maybe they even simply didn't have a
# choice anyway, but I'm not a lawyer actually... Still, I think bans of such
# kind need to be lifted not only by providers in Croatia, but in other
# countries too.  What? They're going to abuse you, and you can't publish what
# they did? C'mon!
# )
#
# To run this successfully (among other prerequisites, the most prominent being
# some understanding of Bash :) ), place, in top dir of, respectively, your
# original emails lurker created and wget downloaded archive, and your restored
# twin archive of the same, the snippets that I placed in:
# lurker_replace_snippets.O/
# lurker_replace_snippets.R/
# Of course, modifiy them to your liking.
#

echo find ./ -name '*.html' \> ls-1
#read FAKE
find ./ -name '*.html' > ls-1
sort -r ls-1 > ls-1r
mv -v ls-1r ls-1
mv -v ls-1 ls-1_RAW

for i in $(cat ls-1_RAW); do
	if (grep -q '<form ' $i); then
		echo $i >> ls-1
	fi	
done
ls -l ls-1 ls-1_RAW
#read FAKE
sha_1=$(sha256sum ls-1|cut -d' ' -f1)
sha_2=$(sha256sum ls-1_RAW|cut -d' ' -f1)
if [ "$sha_1" != "$sha_2" ]; then rm -v ls-1_RAW ; fi
#read FAKE

for i in $(cat ls-1); do
	rm -v part_*
	cat $i
	#read FAKE
	sed -i.bak 's/></>\n</g' $i
	#read FAKE
	cat $i
	#read FAKE
	if [ -e "part_ALL.ls-1" ]; then  rm -v part_ALL.ls-1 ; fi
	while ( grep -q '<form ' $i ); do
		i_wc_l=$(cat $i | wc -l)
		echo "The file \$i: $i"
		echo "has \$i_wc_l: $i_wc_l lines"
		echo "cat $i \| grep -A${i_wc_l} '<form ' \| grep \'\/form>\' \| wc -l"
		#read FAKE
		cat $i | grep -A${i_wc_l} '<form ' | grep '\/form>' | wc -l
		form_wc_l=$(cat $i | grep -A${i_wc_l} '<form ' | grep '\/form>' | wc -l)
		echo \$form_wc_l: $form_wc_l
		#read FAKE
		# So far all is about same as in lurker_frozen_rm_form.sh
		# But here we diverge. So far seen three different cgi called:
		# bounce.cgi
		# jump.cgi
		# keyword.cgi
		echo "The file $i has these type(s) of form(s):"
		cat $i | grep '<form '
		#read FAKE
		# each with its own accompanying HTML. I want to replace
		# each form of that HTML file with something else, or optionally,
		# simply remove the entire content btwn the form tags.
		#
		# Here function to write, or next function nearer to the top is used
		#
		form_wc_l_plus_1=$(echo $form_wc_l+1|bc)
		echo \$form_wc_l_plus_1: $form_wc_l_plus_1
		#read FAKE
		form_num=1
		while [ "$form_num" -lt "$form_wc_l_plus_1" ]; do
			# The first '<form ' instance is now dealt with. The text before it
			# is stowed away (to be reused later).
			echo \$i_wc_l: $i_wc_l
			echo \$form_num: $form_num
			cat $i | grep -m1 '<form ' \
				| sed "s$<form action=\"http://localhost/cgi-lurker/\(.*\)\.cgi\".*$\1_cgi$" \
				> part_${form_num}_type_cgi
			ls -l part_${form_num}_type_cgi
			cat part_${form_num}_type_cgi
			#read FAKE
			cat $i | grep -B${i_wc_l} -m1 '<form ' | grep -v '<form ' \
				> part_${form_num}_before
			ls -l part_${form_num}_before
			#read FAKE
			echo cat part_${form_num}_before
			#read FAKE
			cat part_${form_num}_before
			#read FAKE
			# Here again about same as in lurker_frozen_rm_form.sh, just we'll
			# use the more correct $i_wc_l instead of approximative 3000 value
			# and rename rm_form_tmp_RAW to part_${form_num}_after
			cat $i | grep -A${i_wc_l} '<form ' > part_${form_num}_after
			ls -l part_${form_num}_after
			#read FAKE
			echo "cat part_${form_num}_after | grep -m1 -B${i_wc_l} '\/form>'"
			#read FAKE
			cat part_${form_num}_after | grep -m1 -B${i_wc_l} '\/form>'
			#read FAKE
			cat part_${form_num}_after | grep -m1 -B${i_wc_l} '\/form>' \
				> part_${form_num}_after_form
			ls -l part_${form_num}_after_form part_${form_num}_after
			#read FAKE 
			echo cat part_${form_num}_after_form
			#read FAKE
			cat part_${form_num}_after_form
			#read FAKE
			echo diff part_${form_num}_after part_${form_num}_after_form
			#read FAKE
			diff part_${form_num}_after part_${form_num}_after_form
			#read FAKE
			echo "diff part_${form_num}_after part_${form_num}_after_form | grep -v '< '"
			#read FAKE
			diff part_${form_num}_after part_${form_num}_after_form | grep -v '< '
			#read FAKE
			echo "diff part_${form_num}_after part_${form_num}_after_form | grep '< ' \| sed ..."
			#read FAKE
			diff part_${form_num}_after part_${form_num}_after_form | grep '< ' \
				| sed 's/< //' > part_${form_num}_after_no_form_${form_num}
			#read FAKE
			ls -l $i part_${form_num}_after_no_form_${form_num}
			#read FAKE
			echo mv -v  part_${form_num}_after_no_form_${form_num} $i
			#read FAKE
			mv -v  part_${form_num}_after_no_form_${form_num} $i
			#read FAKE
			# on condition that no '<form ' is left
			cat $i | grep -A${i_wc_l} '<form ' | grep '\/form>' | wc -l
			form_wc_l=$(cat $i | grep -A${i_wc_l} '<form ' | grep '\/form>' | wc -l)
			echo \$form_wc_l: $form_wc_l
			#read FAKE
			if [ "$form_wc_l" -eq "0" ]; then
				echo "the last stretch to end: part_${form_num}_last"
				cp -a $i part_${form_num}_last
			fi
			let form_num=$form_num+1
		done
	done
	echo \$form_wc_l_plus_1: $form_wc_l_plus_1
	form_num=1
	# Bad condition. Here is is always true
	while [ "$form_num" -lt "$form_wc_l_plus_1" ]; do
		echo \$form_wc_l_plus_1: $form_wc_l_plus_1
		# on condition that no '<form ' is left
		cat $i | grep -A${i_wc_l} '<form ' | grep '\/form>' | wc -l
		form_wc_l=$(cat $i | grep -A${i_wc_l} '<form ' | grep '\/form>' | wc -l)
		echo \$form_wc_l: $form_wc_l
		#read FAKE
		echo part_${form_num}_before >> part_ALL.ls-1
		if [ -e "part_${form_num}_type_cgi" ]; then
			echo part_${form_num}_type_cgi >> part_ALL.ls-1
		fi
		if [ -e "part_${form_num}_last" ]; then
			echo part_${form_num}_last >> part_ALL.ls-1
		fi
		let form_num=$form_num+1
	done
	echo cat part_ALL.ls-1
	#read FAKE
	cat part_ALL.ls-1
	#read FAKE
	# In the part_ALL.ls-1 is the list. The part_[number]_before and
	# part_[number]_after files are parts of the original mail page before and
	# after the form tag(s) with (their) content(s).
	# The part_[number]_type_cgi contains the keyword (sed'ed out from the
	# particular tag) telling us what kind of form was removed, so we can
	# tailor what to insert according to the type of the form (the bounce.cgi
	# (bounce_cgi for this script) is usually in top right of the mail page in
	# lurker live, where language can be chosen, the jump.cgi (jump_cgi) is in
	# middle top to jump do other times emails, and the keyword.cgi
	# (keyword_cgi) in middle bottom.
	#
	# The list is consecutive, so that it can be cat'ed the files by the names
	# as in each line of it.
	#
	# All that is now needed is make the right snippet for the
	# part_${form_num}_type_cgi of the list, and maybe sed that list to a new
	# list with the sed'ing: 's/type_cgi/replace_html_fragment/' and then cat
	# the (now all) files of the list (consecutively ordered, remember) to the
	# old filename, replacing the old filename entirely that way.
	#
	# One last somewhat complex hurdle is: based on the current file name, make
	# the link to the other parallel web mailbox (see the long explanation much
	# nearer to the top), but only if it exists in the parallel web mailbox.
	#
	# Let's do it. Oh, I don't care how dirty this is. Only may it work. I'll
	# make a separate file snippets it the very top dir of the web frozen
	# lurker mailbox where this script is run.
	#
	# Oh, and the names are hardwired. I guess few people will need this, and
	# the few that do, must already have some basic programming skills anyway,
	# and they will figure out how to use this script for their purposes.
	#
	ls -l $i
	ls -l $i.bak
	#read FAKE
	# Work above having been done, restore the file (the mail page) from backup:
	mv -v $i.bak $i
	ls -l $i
	#read FAKE

	# But the part_ALL.ls-1 need another touch. The part_[number]_type_cgi are
	# better to contain the type in the filename.
	mv -v part_ALL.ls-1 part_ALL.ls-1_RAW
	for type_cgi_file in $(grep type_cgi part_ALL.ls-1_RAW); do
		name_cgi=$(cat $type_cgi_file)
		ls -l $type_cgi_file
		echo \$name_cgi: $name_cgi
		name_cgi=$(echo $name_cgi|sed 's/_cgi//')
		echo \$name_cgi: $name_cgi
		cat part_ALL.ls-1_RAW | sed "s/$type_cgi_file/${type_cgi_file}_${name_cgi}/" \
			> part_ALL.ls-1
		echo cat part_ALL.ls-1
		cat part_ALL.ls-1
		#read FAKE
		# And truncate the renamed file
		echo "cat part_ALL.ls-1 | grep ${type_cgi_file}_${name_cgi}"
		cat part_ALL.ls-1 | grep ${type_cgi_file}_${name_cgi}
		#read FAKE
		cgi_markerfile_renamed=$(cat part_ALL.ls-1 | grep ${type_cgi_file}_${name_cgi})
		echo \$cgi_markerfile_renamed: $cgi_markerfile_renamed
		echo "mv -v $type_cgi_file $cgi_markerfile_renamed"
		mv -v $type_cgi_file $cgi_markerfile_renamed
		ls -l $cgi_markerfile_renamed
		cat $cgi_markerfile_renamed
		#read FAKE
		> $cgi_markerfile_renamed
		ls -l $cgi_markerfile_renamed
		#read FAKE
		cat part_ALL.ls-1
		#read FAKE
		mv -v part_ALL.ls-1 part_ALL.ls-1_RAW
	done
	mv -v part_ALL.ls-1_RAW part_ALL.ls-1
	#read FAKE
	# The other archive is the complement archive. Full path is either:
	# /var/www/html/foss/cenz/iskon-tcom-mr-O/
	# or
	# /var/www/html/foss/cenz/iskon-tcom-mr/
	# (or better without the last '/').
	pwd
	pwd | sed 's$/var/www/html/foss/cenz/$$'
	cur_archive=$(pwd | sed 's$/var/www/html/foss/cenz/$$')
	#read FAKE
	echo \$cur_archive: $cur_archive
	#read FAKE
	if [ "$cur_archive" == "iskon-tcom-mr" ]; then
		echo "We're in the fixed In-Reply-To's, Subject's and threads archive"
		echo "We need to link to the maimed messed-up archive:"
		echo \$cur_archive: $cur_archive
		link_archive="iskon-tcom-mr-O" # O for ORIG
		echo \$link_archive: $link_archive
		#read FAKE
		# and more the work here?
	else
		echo "We're in the maimed messed-up archive:"
		echo \$cur_archive: $cur_archive
		echo "Will link to the fixed In-Reply-To's, Subject's and threads archive"
		link_archive="iskon-tcom-mr"
		echo \$link_archive: $link_archive
		#read FAKE
		# and more the work here?
	fi
	echo "Again: "
	echo \$cur_archive: $cur_archive
	echo \$link_archive: $link_archive
	#read FAKE
	
	# Test whether file by same name exist in the $link_archive (mostly they
	# do, but not all).
	ls -l ../$cur_archive/$i
	ls -l ../$link_archive/$i
	# Finally re-creating the $i file
	if [ -e "${i}_NEW" ]; then rm -v ${i}_NEW ; fi
	for file_frag in $(cat part_ALL.ls-1); do
		# So I can practise and change what I insert in the new file, there are
		# separate files to cat into $file_frag
		echo $file_frag | sed 's/.*cgi_\(.*\)/fract_\1.txt/'
		file_frag_r=$(echo $file_frag | sed 's/.*cgi_\(.*\)/fract_\1.txt/')
		echo \$file_frag_r: $file_frag_r
		echo cat $file_frag_r
		#read FAKE
		cat $file_frag_r
		#read FAKE
		#echo "CRITICAL"
		#read FAKE
		if [ "$file_frag_r" != "$file_frag" ]; then
			cat $file_frag_r > $file_frag
		fi
		#read FAKE
		echo cat $file_frag
		#read FAKE
		cat $file_frag
		#read FAKE
		echo "grep \$cur_archive $file_frag"
		grep \$cur_archive $file_frag
		#read FAKE
		if ( grep \$cur_archive $file_frag ) ; then
			cat $file_frag | sed "s/\$cur_archive/$cur_archive/"
			#read FAKE
			echo \$i: $i
			echo ls -l $i
			#read FAKE
			ls -l $i
			#read FAKE
			sed -i.bak "s/\$cur_archive/$cur_archive/" $file_frag
			diff $file_frag.bak $file_frag
			#read FAKE
		fi
		echo "grep \$link_archive $file_frag"
		grep \$link_archive $file_frag
		#read FAKE
		if ( grep \$link_archive $file_frag ) ; then
			cat $file_frag | sed "s/\$link_archive/$link_archive/"
			#read FAKE
			echo \$i: $i
			echo ls -l $i
			#read FAKE
			ls -l $i
			#read FAKE
			sed -i.bak "s/\$link_archive/$link_archive/" $file_frag
			diff $file_frag.bak $file_frag
			#read FAKE
		fi
		echo grep REPLACETHIS $file_frag
		grep REPLACETHIS $file_frag
		if ( grep REPLACETHIS $file_frag ); then
			# This can be improved, but currently the only string replaced at
			# such place is the $i of the outer loop.
			echo "CRITICAL"
			#read FAKE
			echo cat $file_frag
			#read FAKE
			cat $file_frag
			#read FAKE
			# $i not friendly for sed, as is in ls-1 list of files to convert,
			# because it start with './'
			echo $i | sed 's$\./\(.*\)$\1$'
			i_r=$(echo $i | sed 's$\./\(.*\)$\1$') # 'r' for real
			echo \$i_r: $i_r
			#read FAKE
			echo "cat $file_frag | sed \"s_REPLACETHIS_${i_r}_\""
			#read FAKE
			cat $file_frag | sed "s_REPLACETHIS_${i_r}_"
			#read FAKE
			echo \$i_r: $i_r
			echo ls -l $i_r
			#read FAKE
			ls -l $i_r
			#read FAKE
			sed -i.bak "s_REPLACETHIS_${i_r}_" $file_frag
			if [ -e "/var/www/html/foss/cenz/$link_archive/${i_r}" ]; then
				ls -l /var/www/html/foss/cenz/$link_archive/${i_r}
				#read FAKE
			else
				cat fract_bounce_NONE.txt > $file_frag
				#read FAKE
			fi
			diff $file_frag.bak $file_frag
			#read FAKE
		fi
		ls -l $file_frag
		ls -l $file_frag | awk '{ print $5 }'
		size=$(ls -l $file_frag | awk '{ print $5 }')
		#if [ "$size" -gt "20000" ]; then less $file_frag ; else cat $file_frag ; fi
		#read FAKE
		cat $file_frag >> ${i}_NEW
	done
	ls -l ${i}_NEW $i
	#read FAKE
	mv -v ${i}_NEW $i
	#read FAKE
done
