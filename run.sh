# https://github.com/MarcinKonowalczyk/run_sh
# Bash script run by a keyboard shortcut, called with the current file path $1
# This is intended as an example, but also contains a bunch of useful path partitions
# Feel free to delete everything in here and make it do whatever you want.

echo "Hello from run script! ^_^"

# The directory of the main project from which this script is running
# https://stackoverflow.com/a/246128/2531987
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT="${ROOT%/*}" # Strip .vscode folder
NAME="${ROOT##*/}" # Project name
PWD=$(pwd);

# Extension, filename and directory parts of the file which triggered this
# http://mywiki.wooledge.org/BashSheet#Parameter_Operations
FILE="$1"
FILENAME="${FILE##*/}" # Filename with extension
FILEPATH="${FILE%/*}" # Path of the current file
FILE_FOLDER="${FILEPATH##*/}" # Folder in which the current file is located (could be e.g. a nested subdirectory)
EXTENSION="${FILENAME##*.}" # Just the extension
ROOT_FOLDER="${1##*$ROOT/}" && ROOT_FOLDER="${ROOT_FOLDER%%/*}" # folder in the root directory (not necessarily the same as FILE_FOLDER)
[ $ROOT_FOLDER != $FILENAME ] || ROOT_FOLDER=""

# Echo of path variables
# VERBOSE=true
VERBOSE=false
[ "$FILE_FOLDER" = ".vscode" ] && [ "$FILENAME" = "run.sh" ] && VERBOSE=true

if $VERBOSE; then
    # https://stackoverflow.com/a/5947802/2531987
    GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'; NC='\033[0m'

    LOGO=true
    if $LOGO; then
        PURPLE='\033[0;34m'; DARK_GRAY='\033[1;30m';
        TEXT=(
            " ______   __  __   __   __ " "    " "    ______   __  __   "
            "/\\  == \\ /\\ \\/\\ \\ /\\ \"-.\\ \\ " "    " "  /\\  ___\\ /\\ \\_\\ \\  "
            "\\ \\  __< \\ \\ \\_\\ \\\\\\ \\ \\-.  \\ " "  __" " \\ \\___  \\\\\\ \\  __ \\ "
            " \\ \\_\\ \\_\\\\\\ \\_____\\\\\\ \\_\\\\\\\"\\_\\ " "/\\_\\\\" " \\/\\_____\\\\\\ \\_\\ \\_\\\\"
            "  \\/_/ /_/ \\/_____/ \\/_/ \\/_/ " "\\/_/" "  \\/_____/ \\/_/\\/_/"
        )
        echo -e "$PURPLE${TEXT[0]}$DARK_GRAY${TEXT[1]}$PURPLE${TEXT[2]}$NC"
        echo -e "$PURPLE${TEXT[3]}$DARK_GRAY${TEXT[4]}$PURPLE${TEXT[5]}$NC"
        echo -e "$PURPLE${TEXT[6]}$DARK_GRAY${TEXT[7]}$PURPLE${TEXT[8]}$NC"
        echo -e "$PURPLE${TEXT[9]}$DARK_GRAY${TEXT[10]}$PURPLE${TEXT[11]}$NC"
        echo -e "$PURPLE${TEXT[12]}$DARK_GRAY${TEXT[13]}$PURPLE${TEXT[14]}$NC"
        echo -e ""
    fi

    echo -e "ROOT       : $GREEN${ROOT}$NC  # root directory of the project"
    echo -e "NAME       : $GREEN${NAME}$NC  # project name"
    echo -e "PWD        : $GREEN${PWD}$NC  # pwd"
    echo -e "FILE       : $GREEN${FILE}$NC # full file information"
    echo -e "FILENAME   : $GREEN${FILENAME}$NC  # current filename"
    echo -e "FILEPATH   : $GREEN${FILEPATH}$NC  # path of the current file"
    echo -e "FILE_FOLDER : $GREEN${FILE_FOLDER}$NC  # folder in which the current file is located"
    echo -e "EXTENSION  : $GREEN${EXTENSION}$NC  # just the extension of the current file"
    if [ $ROOT_FOLDER ]; then
        if [ $ROOT_FOLDER != $FILE_FOLDER ]; then
            echo -e "ROOT_FOLDER : $GREEN${ROOT_FOLDER}$NC # folder in the root directory"
        else
            echo -e "ROOT_FOLDER : ${YELLOW}<same as FILE_FOLDER>${NC}"
        fi
    else
        echo -e "ROOT_FOLDER : ${YELLOW}<file in ROOT>${NC}"
    fi
fi

##################################################

# Do some other stuff here. In this case run the makefile if
# you're currently editing the makefile
if [ "$FILENAME" = "makefile" ]; then
    echo "About to run the makefile!";
    make;
fi