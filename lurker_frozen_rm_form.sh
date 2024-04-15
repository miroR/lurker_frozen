#!/bin/bash
#
# lurker_frozen_rm_form.sh
#
# Copyright (C) 2018 Miroslav Rovis, <http://www.CroatiaFidelis.hr/>
# Use this at your own risk!
# released under BSD license, see LICENSE, or assume general BSD license,
#
# frozen lurker (wget -m -nH http://some/where.html lurker download, not live
# with CGI) is only HTML, so content btwn <form and /form> tags: removed.
#
# Dirty, but works for me. Lurker is (too little) used. E.g. you don't even get
# it in Gentoo (my former home distro:
# Need help creating ebuild for "lurker"
# https://forums.gentoo.org/viewtopic-t-228582.html
# ). Should be used. Nicer, offers great threads (though improvable, to get
# them like in Mutt), good searching, as few mail-to-web programs do. See:
# Dng mailing list [note: the Devuan mailing list]
# https://mailinglists.dyne.org/cgi-bin/mailman/listinfo/dng
#
# If you're among the very few people who might need this, and not very
# advanced, a tip: uncomment all the '#read FAKE' lines, and study what the
# script does. You should get your wget mirrored local lurker mail archive free
# of all content within form tags (which are a user-confusing part on a frozen
# HTML-only lurker download). Pls. see:
# http://www.croatiafidelis.hr/foss/cenz/iskon-tcom-mr/
# to get what I mean.
#
# I think this could be used on live lurker archives on the internet, but
# haven't tried. In that use the legal aspect of mirroring might need to be
# looked at.
#

echo find ./ -name '*.html' \> ls-1
#read FAKE
find ./ -name '*.html' > ls-1
mv -iv ls-1 ls-1_RAW

for i in $(<ls-1_RAW); do
	if (grep -q '<form ' $i); then
		echo $i >> ls-1
	fi	
done
ls -l ls-1 ls-1_RAW
#read FAKE
sha_1=$(sha256sum ls-1|cut -d' ' -f1)
sha_2=$(sha256sum ls-1_RAW|cut -d' ' -f1)
if [ "$sha_1" == "$sha_2" ]; then rm -v ls-1_RAW ; fi
#read FAKE

for i in $(<ls-1); do
	#cat $i
	#read FAKE
	sed -i.bak 's/></>\n</g' $i
	#read FAKE
	#cat $i
	#read FAKE
	while ( grep -q '<form ' $i ); do
		echo cat $i \| grep -A3000 '<form ' \| grep \'\/form>\' \| wc -l
		cat $i | grep -A3000 '<form ' | grep '\/form>' | wc -l
		#read FAKE
		cat $i | grep -A3000 '<form ' > rm_form_tmp_RAW
		ls -l rm_form_tmp_RAW
		#read FAKE
		echo "cat rm_form_tmp_RAW | grep -m1 -B300 '\/form>'"
		#read FAKE
		cat rm_form_tmp_RAW | grep -m1 -B300 '\/form>'
		#read FAKE
		cat rm_form_tmp_RAW | grep -m1 -B300 '\/form>' > rm_form_tmp
		ls -l rm_form_tmp rm_form_tmp_RAW
		#read FAKE 
		echo cat rm_form_tmp
		#read FAKE
		cat rm_form_tmp
		#read FAKE
		echo diff $i rm_form_tmp
		#read FAKE
		diff $i rm_form_tmp
		#read FAKE
		echo diff $i rm_form_tmp | grep -v '< '
		#read FAKE
		diff $i rm_form_tmp | grep -v '< '
		#read FAKE
		echo diff $i rm_form_tmp \| grep '< ' \| sed ...
		#read FAKE
		diff $i rm_form_tmp | grep '< ' | sed 's/< //' > ${i}r
		#read FAKE
		ls -l $i ${i}r
		echo mv -v ${i}r $i
		#read FAKE
		mv -v ${i}r $i
		#read FAKE
	done
done
echo "All '<form ' should be done away with by now".
echo "Next is various unnecessary text string captions to those forms and some delete-trashes."
read NOP

if [ ! -e "ls-1" ]; then
    find ./ -name '*.html' > ls-1
fi
for i in $(<ls-1); do
	#cat $i
	#read FAKE
	#sed -i.bak 's/></>\n</g' $i
	#read FAKE
	#cat $i
	#read FAKE
	while ( grep -q 'Search the archive for matching messages\|Search for messages within this mailing list which contain the following keywords\|Search for messages within this thread which contain the following keywords' $i ); do
		cat $i | grep 'Search the archive for matching messages\|Search for messages within this mailing list which contain the following keywords\|Search for messages within this thread which contain the following keywords' | wc -l
		#read FAKE
		cat $i | grep -C1 'Search the archive for matching messages\|Search for messages within this mailing list which contain the following keywords\|Search for messages within this thread which contain the following keywords' > rm_form_tmp
		#ls -l rm_form_tmp
		#cat rm_form_tmp
		#read FAKE
		#echo diff $i rm_form_tmp
		#read FAKE
		#diff $i rm_form_tmp
		#read FAKE
		echo diff $i rm_form_tmp | grep -v '< '
		#read FAKE
		diff $i rm_form_tmp | grep -v '< '
		#read FAKE
		echo diff $i rm_form_tmp \| grep '< ' \| sed ...
		#read FAKE
		diff $i rm_form_tmp | grep '< ' | sed 's/< //' > ${i}r
		#read FAKE
		ls -l $i ${i}r
		#echo mv -v ${i}r $i
		#read FAKE
		mv -v ${i}r $i
		#read FAKE
	done
done

for i in $(<ls-1); do
	#cat $i
	#read FAKE
	#sed -i.bak 's/></>\n</g' $i
	#read FAKE
	#cat $i
	#read FAKE
	while ( grep -q 'Jump to those messages within this mailing list which are nearest to the following date' $i ); do
		cat $i | grep 'Jump to those messages within this mailing list which are nearest to the following date' | wc -l
		#read FAKE
		cat $i | grep -C1 'Jump to those messages within this mailing list which are nearest to the following date' > rm_form_tmp
		#ls -l rm_form_tmp
		#cat rm_form_tmp
		#read FAKE
		#echo diff $i rm_form_tmp
		#read FAKE
		#diff $i rm_form_tmp
		#read FAKE
		echo diff $i rm_form_tmp | grep -v '< '
		#read FAKE
		diff $i rm_form_tmp | grep -v '< '
		#read FAKE
		echo diff $i rm_form_tmp \| grep '< ' \| sed ...
		#read FAKE
		diff $i rm_form_tmp | grep '< ' | sed 's/< //' > ${i}r
		#read FAKE
		ls -l $i ${i}r
		#echo mv -v ${i}r $i
		#read FAKE
		mv -v ${i}r $i
		#read FAKE
	done
done

for i in $(<ls-1); do
	#cat $i
	#read FAKE
	#sed -i.bak 's/></>\n</g' $i
	#read FAKE
	#cat $i
	#read FAKE
	while ( grep -q 'Use the keyword.*to restrict your search to this' $i ); do
		cat $i | grep 'Use the keyword.*to restrict your search to this' | wc -l
		#read FAKE
		cat $i | grep -C1 'Use the keyword.*to restrict your search to this' > rm_form_tmp
		#ls -l rm_form_tmp
		#cat rm_form_tmp
		#read FAKE
		#echo diff $i rm_form_tmp
		#read FAKE
		#diff $i rm_form_tmp
		#read FAKE
		#echo diff $i rm_form_tmp | grep -v '< '
		#read FAKE
		#diff $i rm_form_tmp | grep -v '< '
		#read FAKE
		#echo diff $i rm_form_tmp \| grep '< ' \| sed ...
		#read FAKE
		diff $i rm_form_tmp | grep '< ' | sed 's/< //' > ${i}r
		#read FAKE
		#ls -l $i ${i}r
		#echo mv -v ${i}r $i
		#read FAKE
		mv -v ${i}r $i
		#read FAKE
	done
done

for i in $(<ls-1); do
	#cat $i
	#read FAKE
	#sed -i.bak 's/></>\n</g' $i
	#read FAKE
	#cat $i
	#read FAKE
	while ( grep -q 'trash.png" alt="Delete this message' $i ); do
		#cat $i | grep 'trash.png" alt="Delete this message' | wc -l
		#read FAKE
		cat $i | grep -C2 'trash.png" alt="Delete this message' > rm_form_tmp
		#ls -l rm_form_tmp
		#cat rm_form_tmp
		#read FAKE
		#echo diff $i rm_form_tmp
		#read FAKE
		#diff $i rm_form_tmp
		#read FAKE
		#echo diff $i rm_form_tmp | grep -v '< '
		#read FAKE
		#diff $i rm_form_tmp | grep -v '< '
		#read FAKE
		#echo diff $i rm_form_tmp \| grep '< ' \| sed ...
		#read FAKE
		diff $i rm_form_tmp | grep '< ' | sed 's/< //' > ${i}r
		#read FAKE
		ls -l $i ${i}r
		#echo mv -v ${i}r $i
		#read FAKE
		mv -v ${i}r $i
		#read FAKE
	done
done

for i in $(<ls-1); do
	#cat $i
	#read FAKE
	#sed -i.bak 's/></>\n</g' $i
	#read FAKE
	#cat $i
	#read FAKE
	while ( grep -q '>Jump to Group<' $i ); do
		cat $i | grep '>Jump to Group<' | wc -l
		#read FAKE
		cat $i | grep '>Jump to Group<' > rm_form_tmp
		ls -l rm_form_tmp
		cat rm_form_tmp
		#read FAKE
		#echo diff $i rm_form_tmp
		#read FAKE
		#diff $i rm_form_tmp
		#read FAKE
		echo diff $i rm_form_tmp | grep -v '< '
		#read FAKE
		diff $i rm_form_tmp | grep -v '< '
		#read FAKE
		echo diff $i rm_form_tmp \| grep '< ' \| sed ...
		#read FAKE
		diff $i rm_form_tmp | grep '< ' | sed 's/< //' > ${i}r
		#read FAKE
		ls -l $i ${i}r
		echo mv -v ${i}r $i
		#read FAKE
		mv -v ${i}r $i
		#read FAKE
	done
done

echo "Various unnecessary text string captions to those forms and some delete-trashes should been rm'ed."
echo "Next is sed Mailing List/Mail Archive, and sed mailing list/mail archive."
read NOP

for i in $(<ls-1); do
	while ( grep -q 'Mailing List' $i ); do
		cat $i | grep 'Mailing List' | wc -l
		#read FAKE
        sed -i.bak 's/Mailing List/Mail Archive/' $i
		echo diff $i.bak $i
		#read FAKE
		diff $i.bak $i
		#read FAKE
	done
done

for i in $(<ls-1); do
	while ( grep -q 'mailing list' $i ); do
		cat $i | grep 'mailing list' | wc -l
		#read FAKE
        sed -i.bak 's/mailing list/mail archive/' $i
		echo diff $i.bak $i
		#read FAKE
		diff $i.bak $i
		#read FAKE
	done
done

echo "sed Mailing List/Mail Archive, and sed mailing list/mail archive should been done."
echo "Next is the home button fix"
read NOP

echo "WARNING: this part needs to be EDITED for any other use than Pp-4395-22-posta."
read NOP
for i in $(<ls-1); do
	while ( grep -q 'splash/index.en.html' $i ); do
        sed -i.bak 's$splash/index.en.html$list/lurker-pp-4395-22-posta.en.html$' $i
		echo diff $i.bak $i
		read FAKE
		diff $i.bak $i
		read FAKE
	done
done
