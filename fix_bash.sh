#################
# NAME
#	fix_bash.sh
#
# SYNOPSIS
#       source fix_bash.sh [-i]
#
# DESCRIPTION
#	See readme file on Github (https://github.com/civier/fix_bash)
#
#	The following options are available:
#
#	-i	when sourced from interactive shell
# 
# AUTHOR
#	fix_bash was originally written by Oren Civier (https://github.com/civier)
#
#################
# to do: need to check how SLURM terminate processes?

function catch_error()
{
	echo "SCRIPT ERROR: Line $1 of $2 exited with error code $3. Info above. Quitting"
	sed -n $1p $2 | grep -v '^.*=$(' | grep "^.*=.*['}] "
	echo 'THERE *MAY* BE AN UNNECESSARY SPACE IN THE ABOVE ASSIGNMENT COMMAND'
}

log () 
{
    if echo > $1
    then
        tee $1
    else
        exit_code=$?
        echo 'log: cannot create or write to log file '$1 1>&2
        exit "$exit_code"
    fi
}

set -uo pipefail
# to check if variable exists with -u turn on, use [ -v VAR_NAME ] or [ $# -gt 0 ] if arguments
shopt -s failglob lastpipe
# configure tee to exist directly if cannot create output file -- does not work on OzStar
#alias tee='tee --output-error=exit'

if [ $# -gt 0 ] && [ "$1"  == "-i" ]
then
	# interactive shell. Exiting

	trap 'echo "TERMINAL ERROR: Last interactive command exited with error code $?"' ERR
	# cannot print message, as problematic to programs like rsync
	### echo FIXED BASH FOR BETTER INTERACTIVE MODE
	return
else
	# non-interacrive shell. Setting traps and exit on error

	# Extract full path of script
	real_path="$(realpath -e $0)"

	# removed because depricated. Also, no need to do below for interactive shell, as already done on OzStar
	#export GREP_OPTIONS='--color=always'

	# print error message when script error (to do: supress this message if SIGINT or SIGTERM; currently print it, with line number 1)
	trap 'catch_error $LINENO $real_path $?' ERR
	## GOOD ## trap 'echo "ERROR: Line $LINENO of $0 exited with error code $?. Info above. Quitting"; sed -n ${LINENO}p $0 | grep -v ^\.\*=\$\( | grep ^\.\*=\.\*\  ; echo "CHECEK FOR UNNECESSARY SPACE IN THE ABOVE ASSIGNMENT COMMAND"' ERR   
	# print a message to record that process with stopped by user (to do: check how to make line number correct, if possible)
	trap '1>&2 echo ERROR: User halted execution with Ctrl-C at line $LINENO of $real_path' SIGINT
	# catch kill; if not exiting myself, so a kill <PROCESS_ID> command will be catched, but not terminate the process (to do: check how to make line number correct, if possible)
	trap '1>&2 echo ERROR: Execution halted externally at line $LINENO of $real_path; exit 143' SIGTERM
	# print DEBUG message; put it last so won't print debug messages for this file as well
	# if [ $# -gt 0 ] && [ "$1"  == "-v" ]
	if [ -v INFO ]
	then
		trap 'if [ $? -eq 0 ] && [ "$0" != bash ]; then sed -n ${LINENO}p $real_path | read -r line; 1>&2 echo "INFO: Executing line $LINENO of $real_path [$line]"; fi' DEBUG
	fi
	# non-interacrive shell. Setting traps and exit on error
	set -e

fi
