#!/bin/bash
# This will sort the bibliography file by reference key
# I use this since pybliographic is a bit annoying and will
# re-sort the actual contents of the bib-file if you open
# the file, sort it (or search for something) and then save
# the changes.
# Git does not like this...
#
# So from here on, I will (hopefully) run this script before
# each commit.

BIBFILE=bibliography.bib

echo "Looking for an installed version of bibtool"
which bibtool || {
  echo "exiting now!"
  exit 1
}

echo 'bibtool -s "'"$BIBFILE"'" > tmp.bib'
bibtool -s $BIBFILE > tmp.bib
if [[ $? == 0 ]]; then
  mv -v tmp.bib $BIBFILE
fi
