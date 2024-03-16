#!/bin/sh

## First check if the system is already installed:
needInstall=false
/bin/cells admin config check > /dev/null 2>&1
if [ $? -ne 0  ] ; then
    needInstall=true
fi

# Exit immediately in case of error. See https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html for more details about the set builtin.
set -e

if [ "$needInstall" = true -a "$1" = "/bin/cells" -a "$2" = "start" ]; then
	## Remove the first 2 args (aka: /bin/cells start) 
	shift 2
	## And re-add /bin/cells configure
	set -- /bin/cells configure "$@"
fi

# Solve issue when no bind is defined on configure
if [ "$needInstall" = true -a "$2" = "configure" -a "xxx$/bin/cells_BIND" = "xxx" ]; then   
	# we have to check in ENV and all flags
	bindFlag=false
	for currArg in "$@"
	do
		case $currArg in --bind*)
			bindFlag=true
		esac
	done

	if [ "$bindFlag" = false ]; then
		set -- "$@" --bind :8080
	fi 
fi

# Convenience shortcuts to avoid having to retype '/bin/cells start' before the flags:
# We check if first arg starts with a dash (typically `-f` or `--some-option`) 
# And prefix arguments with '/bin/cells start' or 'cells configure' command in such case 
if [ "${1#-}" != "$1" ]; then
	if [ "$1" = "-h" -o "$1" = "--help"  ]; then
		set -- /bin/cells "$@"	
	elif [ "$needInstall" = true ]; then
		set -- /bin/cells configure "$@"
	else
		set -- /bin/cells start "$@"
	fi
fi

# Workaround issue of key generation at first run until it is fixed.
/bin/cells version > /dev/null

if [ "$2" != "version" ]; then
	echo "### $(/bin/cells version)"
fi 
echo "### About to execute: [$@]"

exec "$@"
