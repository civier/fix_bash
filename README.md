# fix_bash

The bash shell is notoriously out-of-date with modern programming languages. Not surprising given that it was born (again ;-) ) in 1989, two years before Python. It also tries to keep compatibility with the ancient 1979 Bourne shell, which doesn't help.

That said, there are several flags that can be set to change the behaviour to be more similar to what we expect from a programming language. Moreover, traps can be added to catch certain errors and print a more informative error messages than those provided by bash by default.

The fix_bash.sh script does just this. Simply source it in the beginning of your bash scripts using:
source fix_bash.sh
and your script will behave the way you expect it to.

You may source fix_bash.sh also when starting an interactive bash session on the terminal, but BE SURE to add the -i flag (for interactive):
source fix_bash.sh -i
otherwise, unexpected behaviour might occur. Be especially careful if sourcing fix_bash.sh automatically when opening a terminal (e.g., putting it in .bashrc), as failing to include the -i flag might block you from logging into the server.

WORD OF CAUTION #1: the setting changed by fix_bash.sh WILL NOT propagate to other bash scripts you may call from your scripts / the terminal, so you need to source fix_bash.sh from each and every script you write.
WORD OF CAUTION #2: the setting changed by fix_bash.sh WILL propagate to other bash scripts that you source using the source command, and it might make them stop working (as many bash scripts unfortunately assume that bash is not working like standard programming languages). Sourcing bash scripts is common for install/configuration scripts that need to set-up your working environment in interactive bash sessions. In these instances, it is advised to source fix_bash.sh only after the install/configuration scripts were sourced.
