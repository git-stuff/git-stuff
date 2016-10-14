#!/bin/sh

set -e

PROGRAM="GIT\\\-STUFF"
VERSION="$(cat ../VERSION)"

DATE="$(LC_ALL=C date +%Y\\\\-%m\\\\-%d)"

DAY="$(LC_ALL=C date +%d)"
MONTH="$(LC_ALL=C date +%m)"
YEAR="$(LC_ALL=C date +%Y)"

echo "Updating version headers..."

for MANPAGE in en/*
do
	SECTION="$(basename ${MANPAGE} | awk -F. '{ print $2 }')"

	sed -i -e "s|^.TH.*$|.TH ${PROGRAM} ${SECTION} ${DATE} ${VERSION} \"Git Stuff\"|" ${MANPAGE}
done

# European date format
for _LANGUAGE in de es fr it
do
	if ls po/${_LANGUAGE}/*.po > /dev/null 2>&1
	then
		for _FILE in po/${_LANGUAGE}/*.po
		do
			sed -i  -e "s|^msgstr .*.${YEAR}-.*$|msgstr \"${DAY}.${MONTH}.${YEAR}\"|g" \
				-e "s|^msgstr .*.${YEAR}\"$|msgstr \"${DAY}.${MONTH}.${YEAR}\"|g" \
			"${_FILE}"
		done
	fi
done

# Brazilian date format
if ls po/pt_BR/*.po > /dev/null 2>&1
then
	for _FILE in po/pt_BR/*.po
	do
		sed -i  -e "s|^msgstr .*.${YEAR}-.*$|msgstr \"${DAY}-${MONTH}-${YEAR}\"|g" \
			-e "s|^msgstr .*-${YEAR}\"$|msgstr \"${DAY}-${MONTH}-${YEAR}\"|g" \
		"${_FILE}"
	done
fi
