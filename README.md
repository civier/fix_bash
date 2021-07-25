# fix_bash

The bash shell is notoriously out-of-date with modern programming languages. Not surprising given that it was born (again ;-) ) in 1989, two years before Python. It also tries to keep compatibility with the ancient 1979 Bourne shell, which doesn't help.

That said, there are several flags that can be set to change the behaviour of bash to be more similar to what we expect from a programming language. Moreover, traps can be added to catch certain errors, debug, and print more informative error messages than those provided by bash by default.

The fix_bash.sh script does just this. Simply source it in the beginning of your bash scripts using:

**source fix_bash.sh**

You may source fix_bash.sh also when starting an interactive bash session on the terminal, but BE SURE to add the -i flag (for interactive):

**source fix_bash.sh -i**

without the -i flag, unexpected behaviour might occur. Be especially careful if sourcing fix_bash.sh automatically when opening a terminal (e.g., putting it in .bashrc), as failing to include the -i flag might block you from logging into the server.

Lastly, to run a script(s) that use(s) fix_bash.sh with debug information (basically, printing out each command that is executed along with its line number), run the following in the terminal before calling the script(s):

**export INFO=1**

To turn debug information off, run this command in the terminal:

**unset INFO**


WORD OF CAUTION #1: the setting changed by fix_bash.sh WILL NOT propagate to other bash scripts you may call from your scripts / the terminal, so you need to source fix_bash.sh from each and every script you write.

WORD OF CAUTION #2: the setting changed by fix_bash.sh WILL propagate to other bash scripts that you source using the source command, and it might make them stop working (as many bash scripts unfortunately assume that bash is not working like standard programming languages). Sourcing bash scripts is common for install/configuration scripts that need to set-up your working environment in interactive bash sessions. In these instances, it is advised to source fix_bash.sh only after the install/configuration scripts were sourced.

WORD OF CAUTION #3: one of the flags that is turned on by fix_bash is -u. With this flag on, bash will print an error and exit if a command tries to access an undefined varibale. To check if a variable is defined (before trying to access it), use 

**if [ -v VARNAME ] then** ...  (replacing VARNAME with the name of the variable, without the leadinhg $)

or in the case you want to test whether input parameters were provided when the script was called, use

**if [ $# -gt 0 ] then** ...     (this checks if at least 1 input parameter was provided; to check if at least X parameters were provided, replace 0 with the value of X-1) 

WORD OF CAUTION #4: one of the most common errors when programming in bash is including a space character in an assignment command (i.e., VAR=) without putting it between quotes or escaping it with a leading slash. Because it is so obiquitous, fix_bash configures bash to print an error message just for this error. That said, to keep it simple I assume that the user only utilises single quotes after an assignment commands, and only refers to variables using ${ } (rather than an initial $ without curly brackets). If you are not using these conventions, error messages for assignment commands might be confusing/inaccurate (you are welcome to contact me on GitHub for an explanation of why these conventions make sense, at least for novice users). 


