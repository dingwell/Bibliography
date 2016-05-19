#!/bin/bash
# Quick tool for making commits

BIBFILE=bibliography.bib  # This file will be sorted using bibtool
BIBTOOL=pybliographic     # Bibliography manager

get_yes_no(){
  # read input until either y,Y,n or N is entered
  # then return 0 for y/Y or 1 for n/N
  local ANS=""
  local RETVAL=""
  while read -r -n 1 -s ANS; do
    if [[ $ANS = [YyNn] ]]; then  # Check if a valid key was pressed
      if [[ $ANS = [Yy] ]]; then  # Answer is: Yes
        RETVAL=0
      else                        # Answer is: No
        RETVAL=1
      fi
      break
    fi
  done
  return $RETVAL
}

ensure_process_not_running(){
  local PNAME=$1
  local PID_BIBTOOL=""
  echo "Looking for a running instance of '$PNAME'"
  if PID_BIBTOOL=$(pgrep -f "$PNAME"); then
    echo "Found running instance of '$PNAME' (pid = $PID_BIBTOOL)"
    echo "Please, close application before continuing."
    while PID_BIBTOOL=$(pgrep -f "$PNAME"); do
      echo "Process still running..."
      read -n1 -p "Close application with pid = $PID_BIBTOOL and press any key to continue: " key
      echo ""
    done
  fi
}

sort_bibliography(){
  local BIBFILE=$1
  echo 'bibtool -s "'"$BIBFILE"'" > tmp.bib'
  bibtool -s $BIBFILE > tmp.bib
  if [[ $? == 0 ]]; then # If sorting worked, replace original file with sorted
      mv -v tmp.bib $BIBFILE
  fi
}


## MAIN ##
# Ensure that no instance of the bibtool is running:
ensure_process_not_running "$BIBTOOL" 

# Sort references:
sort_bibliography $BIBFILE

# Output changes:
echo "Changes since last release:"
git diff

# Prompt user to validate:
echo "Is it ok to proceed with the commit? [Y/N]"
get_yes_no || exit 0

# Make the commit:
git commit -a

# Push to master:
git push origin master

# Query user whether to re-launch reference manager:
#   BIBTOOL will be launched as an independent process
#   all messages (stdout+stderr) will be re-directed to ~/.xsession-errors
echo "(Re-)launch reference manager ($BIBTOOL)? [Y/N]"
if get_yes_no; then
  $BIBTOOL "$BIBFILE" >> $HOME/.xsession-errors 2>&1 &!
fi

