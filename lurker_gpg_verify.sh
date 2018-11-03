#!/bin/bash
#
# As usual, Unix of some kind only (tested on Linux only)
#

# PGP-verifies raw emails from lurker. (Can be adapted for other purposes.)
#
# Save raw email that is PGP-signed and run:
# lurker_gpg_verify.sh <that-email>
#
# Or save the raw email one by one in a dir, or...
#
# Or collect all mail in one move (i.e. by copying that dir) from a deployed
# (or "frozen") lurker's <some-list>/mbox/, into somewhere where you can
# experiment/recreate those emails from backup.
#
# It works with GnuPG 2, which is, in the *nix world, the majority of currently
# signed emails.
#
# BUG: It does not work with old, or just GnuPG 1 PGP-signed emails. Rare,
# nowadays. Not a priority (but should be easy to do).
#
# BUG: It does not work with Elliptic Curve keys. Not yet. Priority because I'm
# very interested in this, but no time.
#
# For the relatively few people who care to learn and who care for encryption
# because there is no privacy without it, and neither security, and actually
# --try to understand-- there is no free life these late dacades of total
# surveillance without your own using of your computers securely and freely
# and, when you wish so: privately.
#
# For those, first: man pages! Know all the options that I used to grep, diff,
# split. It's there for the willing to learn... And there's the important
# oneliner for sed, see below my comment.
#
# Once you've got the knack of it, comment out all "read FAKE" lines, except for
# "read FAKE_permanent" lines.
#

if [ $# -eq 0 ]; then
    echo "give (a list of) email(s)"
    echo "(if globbing, you need to quote it, e.g.:"
    echo "$0 \"*.rfc822\")"     # I'm not such an expert to
                                # easily make this more comfortable
    exit 0
fi

function ask()    # this function borrowed from "Advanced BASH Scripting Guide"
                # (a free book) by Mendel Cooper
{
    echo -n "$@" '[y/[n]] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}


EMAILS=$1
echo \$EMAILS: $EMAILS

# Uncomment to just make this simple test, if you need it
# test
#for email in $(ls -1); do
#    grep boundary $email | grep pgp-signature
#    read FAKE
#    boundary=$(grep boundary $email | grep pgp-signature \
#        | sed 's/.*boundary="\(.*\)"/\1/')
#    echo \$boundary: $boundary
#    read FAKE
#done

# If the above gets you something like:
#         protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
# 
# rwEMma7ioTxnRzrJ
#
# per each email in that copied dir, that you should be able to go on.
#
# All dirty, but works for me... No time for cleaning...
#

for email in $EMAILS; do
    echo "Working on $email"
    grep boundary $email | grep pgp-signature
    read FAKE
    if ( grep boundary $email | grep -q pgp-signature ); then
        boundary=$(grep boundary $email | grep pgp-signature \
            | sed 's/.*boundary="\(.*\)"/\1/'|cut -d' ' -f1 | sed 's/\(.*\)".*/\1/')
        echo \$boundary: $boundary
        read FAKE
        echo "The grep'ed text from current email ($email) will be this many lines:"
        grep -A30000 -m2 $boundary $email | wc -l
        read FAKE
        echo "And it contains this many instances from the second instance,"
        echo "which should be the instance marking the start of the signed part of"
        echo "this email:"
        grep -A30000 -m2 $boundary $email | grep $boundary
        read FAKE
        grep -A30000 -m2 $boundary $email | grep -n $boundary
        read FAKE
        grep -A30000 -m2 $boundary $email | grep -v "application/pgp-signature" | grep -n $boundary
        read FAKE
        grep -A30000 -m2 $boundary $email | grep -v "application/pgp-signature" \
            | grep -A30000 -m2 $boundary | grep -n $boundary
        read FAKE
        grep -A30000 -m2 $boundary $email | grep -v "application/pgp-signature" \
            | grep -A30000 -m2 $boundary | grep -B30000 $boundary | wc -l
        from_top_wc_l=$(grep -A30000 -m2 $boundary $email | grep -v "application/pgp-signature" \
            | grep -A30000 -m2 $boundary | grep -B30000 $boundary | wc -l)
        echo \$from_top_wc_l: $from_top_wc_l
        read FAKE
        # Start procedure to extract the text to verify, and its pgp-signature.
        boundary_found_wc_l=$(grep -A30000 -m2 $boundary $email | grep -v "application/pgp-signature" \
            | grep -A30000 -m2 $boundary | grep -n $boundary|wc -l)
        echo \$boundary_found_wc_l: $boundary_found_wc_l
        read FAKE
        # We ought to have isolated three lines. First: boundary after which
        # text to verify start. Second: the one at which it ends, and signature
        # starts. Third: at which signature ends.
        if [ "$boundary_found_wc_l" == "3" ]; then
            # we assign line numbers of each boundary to variables to use later
            start_text=$(grep -A30000 -m2 $boundary $email | grep -v "application/pgp-signature" \
                | grep -A30000 -m2 $boundary | grep -n $boundary|head -1|cut -d: -f1)
            middle_text_to_sig=$(grep -A30000 -m2 $boundary $email | grep -v "application/pgp-signature" \
                | grep -A30000 -m2 $boundary | grep -n $boundary|head -2|tail -1|cut -d: -f1)
            end_sig=$(grep -A30000 -m2 $boundary $email | grep -v "application/pgp-signature" \
                | grep -A30000 -m2 $boundary | grep -n $boundary|head -3|tail -1|cut -d: -f1)
            echo \$start_text: $start_text
            echo \$middle_text_to_sig: $middle_text_to_sig
            echo \$end_sig: $end_sig
            read FAKE
            from_top_wc_l_no_start=$(echo $from_top_wc_l - $start_text|bc)
            echo \$from_top_wc_l_no_start: $from_top_wc_l_no_start
            end_stretch=$(echo $end_sig - $middle_text_to_sig|bc)
            echo \$end_stretch: $end_stretch
            read FAKE
            echo "Want to view in less the text to verify?"
            echo "(default is not to view, just hit Enter)"
            ask
            if [ "$?" == 0 ]; then
                grep -A30000 -m2 $boundary $email | grep -v "application/pgp-signature" \
                    | grep -A30000 -m2 $boundary | less
            fi
            grep -A30000 -m2 $boundary $email | grep -v "application/pgp-signature" \
                | grep -A30000 -m2 $boundary | split -d -l ${middle_text_to_sig} - $email
            read FAKE
            ls -l ${email}0?
            email_text_wc_l_raw=$(cat ${email}00 | grep -v $boundary | wc -l)
            echo \$email_text_wc_l_raw: $email_text_wc_l_raw
            let "email_text_wc_l = email_text_wc_l_raw - 1"
            echo \$email_text_wc_l: $email_text_wc_l
            read FAKE
            # 
            grep -A30000 -m2 $boundary $email | grep -v "application/pgp-signature" \
                | grep -A30000 -m2 $boundary | split -d -l ${middle_text_to_sig} - $email
            # This is the sed oneliner, although put in a larger command.
            # If the file (say file_unix.txt) is unix (lines end in LF, ascii 0x0A,
            # see man ascii), to verify that text, it needs to be converted to
            # dos, i.e. added CR (0x0D) to the end of lines, e.g.:
            # sed 's/$/\x0D/' file_unix.txt > file_dos.txt
            cat ${email}00 | grep -v $boundary | head -$email_text_wc_l | sed 's/$/\x0D/' \
                > $email.txt
            read FAKE
            echo "diff -b ${email}00 $email.txt"
            diff -b ${email}00 $email.txt
            echo
            echo -n "=-=-=-=-=-=-=-=- "
            echo -n "This is the text that should verify: "
            echo " -=-=-=-=-=-=-=-="
            echo "ls -l $email.txt"
            ls -l $email.txt
            echo " --- "
            read FAKE
            cat ${email}01 | grep -v $boundary | sed 's/^$//' > $email.sig
            echo -n "=-=-=-=-=-=- "
            echo -n "and the PGP-signature that should verify it: "
            echo " -=-=-=-=-=-="
            ls -l $email.sig
            echo " --- "
            echo
            echo "The command will be: "
            echo "gpg --verify $email.sig $email.txt"
            echo "---"
            gpg --verify $email.sig $email.txt && \
            if [ "$?" == 0 ]; then
                echo "Removing temp files..."
                read FAKE_permanent
                rm -v  ${email}0?
                echo "Next: removing also the prepared text portion that verified"
                echo "as well as its pgp-signature..."
                read FAKE
                rm -v $email.sig $email.txt
                read FAKE
            fi
            # Not exactly correct nor complete, but I don't know better atm.
            if [ -e "${email}00" ] || [ -e "$email.sig" ]; then
                echo "Verification failed, temp files not removed:"
                ls -l  ${email}0?
                ls -l $email.sig $email.txt
                echo "Pls. study the case and ascertain what caused the failure."
                read FAKE_permanent
                echo "View in less now the text to verify?"
                echo "(default is still not to view, just hit Enter)"
                ask
                if [ "$?" == 0 ]; then
                    grep -A30000 -m2 $boundary $email | grep -v "application/pgp-signature" \
                        | grep -A30000 -m2 $boundary | less
                fi
            fi
        else
            echo "Haven't studied cases with more than one signed text, if"
            echo "such exist... Need this script now for the usual cases of my"
            echo "frozen lurker archives..."
            echo "(or my program is misbehaving)."
        fi
    else
        echo "This email ($email) is not PGP-signed"
        echo "(or my program is misbehaving)."
        read FAKE
    fi
done
