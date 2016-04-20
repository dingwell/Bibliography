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

# Ensure that no running instance of pybliographic is running:
echo "Looking for a running instance of pybliographic"
if PID_BIBTOOL=$(pgrep -f pybliographic); then
  echo "Found running instance of pybligraphic (pid = $PID_BIBTOOL)"
  echo "Please, close application before continuing."
  while PID_BIBTOOL=$(pgrep -f pybliographic); do
    echo "Process still running..."
    read -n1 -p "Close application with pid = $PID_BIBTOOL and press any key to continue: " key
    echo ""
  done
fi

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
