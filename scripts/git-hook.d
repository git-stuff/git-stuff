#!/bin/sh

set -e

_HOOKS="${0}.d"

for _FILE in "${_HOOKS}"/*
do
	if [ -x "${_FILE}" ]
	then
		"${_FILE}" "${@}" || true
	fi
done
