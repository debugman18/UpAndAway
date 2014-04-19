#!/bin/bash
#  File: scml_wrapper.sh
#  Author: simplex
#  Created: 2014-04-19
#  Last Update: 2014-04-19
#  Notes:


if [[ -z "$SCML_COMPILER" ]]; then
	echo "Environment SCML_COMPILER with the path to the scml compiler executable expected." >&2
	exit 1
fi


# Args which are not options.
PRIMARY_ARGS=()
OPTS=()

for(( i = 1 ; i <= $#; i++ )); do
	arg="${!i}"
	if [[ "$arg" == -* ]]; then
		OPTS+=("$arg")
	else
		PRIMARY_ARGS+=("$arg")
	fi
done

SCML_FILE=${PRIMARY_ARGS[0]}
MODDIR=${PRIMARY_ARGS[1]}

if [[ ! "$SCML_FILE" == *.scml ]]; then
	echo "ERROR: SCML file expected as first parameter, got '$SCML_FILE'" >&2
	exit 1
fi
if [[ ! -r "$SCML_FILE" ]]; then
	echo "ERROR: The SCML file '$SCML_FILE' does not exist or is not readable." >&2
	exit 1
fi
SCML_FILE="`realpath "$SCML_FILE"`"

if [[ ! "$MODDIR" || ! -d "$MODDIR" ]]; then
	echo "ERROR: Mod directory expected as second parameter, got '$MODDIR'" >&2
	exit 1
fi
MODDIR="`realpath "$MODDIR"`"

if [[ -z "$MODTOOLS_TEMP_DIR" ]]; then
	MODTOOLS_TEMP_DIR=`mktemp -d`
	trap "rm -rf $MODTOOLS_TEMP_DIR" EXIT
fi
MODTOOLS_TEMP_DIR="`realpath "$MODTOOLS_TEMP_DIR"`"
export MODTOOLS_TEMP_DIR

if [[ -z "$MODTOOLS_LOG" && ! -z "$MODDIR" && -d "$MODDIR/log" ]]; then
	MODTOOLS_LOG="$MODDIR/log/scml_log.txt"
fi
MODTOOLS_LOG="`realpath "$MODTOOLS_LOG"`"
export MODTOOLS_LOG

"$SCML_COMPILER" "${OPTS[@]}" "$SCML_FILE" "$MODDIR" >/dev/null </dev/null
exit $?
