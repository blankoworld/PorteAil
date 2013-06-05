#!/usr/bin/env sh

# install.sh

# Copy porteail directory to user's public_html

SRCDIR=${SRCDIR:-'./porteail'}
DESTDIR=${DESTDIR:-"${HOME}/public_html"}
STATICDIR=./static

staticdir_content=0
if test -d ${STATICDIR}
then
  content=`ls ${STATICDIR}|wc -l`
  if test $content -gt 0
  then
    staticdir_content=1
  fi
fi

process() {
  rm -rf ${DESTDIR}/* && cp -r ${SRCDIR}/* ${DESTDIR} && echo "...installed!"
  if test ${staticdir_content} -gt 0
  then
    cp -r ${STATICDIR}/* ${DESTDIR}
  fi
}

echo "INSTALL to ${DESTDIR}..."

if ! test -d ${SRCDIR}
then
  echo "${SRCDIR} directory not found!"
  exit 1
fi

if ! test -d ${DESTDIR}
then
  echo "${DESTDIR} directory not found!"
  exit 1
fi

echo "This will delete ${DESTDIR} content and copy ${SRCDIR} into. Are you sure [y/n]?"
read response
if [ "${response}" = "y" ]
then
  process
  exit 0
elif [ "${response}" = "Y" ]
then
  process
  exit 0
else
  exit 1
fi
