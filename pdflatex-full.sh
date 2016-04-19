#!/bin/bash
# This script will create a pdf document
# from a given latex file with bibtex referenses
# The bibtex source file must be defined within this script
# A copy of the file will be generated in the workdir
# (DO NOT set the workdir file as the source file!)
# Some filters will be applied to the workdir file (eg removal of url field)

#PRESETS
BIBFILE=~/Documents/Jobb_local/references/bibliography.bib
#BIBFILE=~/Documents/Shared/phd/bibliography_new.bib
echo "Using bibtex file: $BIBFILE"


# Backup old .bib file in workdir:
BIBDIR=$(echo $BIBFILE|sed 's|/[^/]*\.bib||')
if [ $BIBDIR == $(pwd) ]; then
  echo "Oh no! You are trying to run this script in the same directory as your original .bib file!"
  echo "Doing so would cause a mess and possibly delete all your work"
  echo "You should thank me for being nice and noticing, as I will now stop and save your file from a terrible end."
  exit 1
else  # safe to proceed
  mv -v bibliography.bib bibliography.bak

  # Create a new bibliography from the original
  # Remove the url field (since most styles used by journals print it!)
  cat $BIBFILE | sed '/url\s*=\s*[{"].*["}],/d' > bibliography.bib
  echo "There should now be a fresh bibtex file in the working directory"
fi



# If filename is given with suffix, remove it
# (not needed for most commands and only gets in the way)
FILE_NO_SUFFIX=$(echo $1|sed 's/\(.*\)\.[a-zA-Z]\{3\}/\1/')

# Clean up old supplementary files (some changes might cause errors otherwise)
#rm -v $FILE_NO_SUFFIX.aux $FILE_NO_SUFFIX.bbl
rm -v $FILE_NO_SUFFIX{.aux,.bbl}
echo $FILE_NO_SUFFIX


echo "Filename to use: $FILE_NO_SUFFIX"
# Create initial document, will be used to find what references we have
pdflatex $FILE_NO_SUFFIX
# Get the desired references from the bibliography database
bibtex $FILE_NO_SUFFIX
# Rerun pdflatex with references included
pdflatex $FILE_NO_SUFFIX
# Rerun once more to get figure/float handling correct (necessary?)
pdflatex $FILE_NO_SUFFIX

echo 'Shell script finished'
