#! /bin/bash
# Expanded bash script

# This file. In the vscode keybinding this comes from ${file}
FILE="$0";

# The directory of this file (expanded.sh).
# In keyboding this is the dirname of the $FILE
PWD=$(pwd);

# script file to search for
SCRIPT=".vscode/run.sh";

# Echo to see what's up
echo "FILE = $FILE";
echo "PWD = $PWD";
echo "SCRIPT = $SCTIPT";

while :; do
    RUN="$PWD/$SCRIPT";
    if [[ -e $RUN ]]; then
        echo "Run script found at $RUN";
        "$RUN" "$FILE";
        break;
    else
        echo "No $RUN found";
    fi;
    if [[ $PWD != "/" && $PWD != "~" ]]; then :; else
        echo "No $SCRIPT found";
        break;
    fi;
    PWD=$(dirname "$PWD");
done