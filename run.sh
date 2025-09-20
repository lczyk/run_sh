#!/usr/bin/env bash
# https://github.com/MarcinKonowalczyk/run_sh
# Bash script run by a keyboard shortcut, called with the current file path $1
# This is intended as an example, but also contains a bunch of useful path partitions
# Feel free to delete everything in here and make it do whatever you want.

printf "Hello from run script! ^_^\n"

# spellchecker: ignore Marcin Konowalczyk lczyk
__VERSION__="0.2.4"
__AUTHOR__="Marcin Konowalczyk @lczyk"
__LICENSE__="MIT-0"

# The directory of the main project from which this script is running
# https://stackoverflow.com/a/246128/2531987
ROOT_FOLDER="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
ROOT_FOLDER="${ROOT_FOLDER%/*}"   # Strip .vscode folder
PROJECT_NAME="${ROOT_FOLDER##*/}" # Project name

FULL_FILE_PATH="$1"
_RELATIVE_FILE_PATH="${FULL_FILE_PATH##*"$ROOT_FOLDER"/}" # Relative path of the current file

# Split the relative file path into an array
# shellcheck disable=SC2206
RELATIVE_PATH_PARTS=(${_RELATIVE_FILE_PATH//\// })
DEPTH=${#RELATIVE_PATH_PARTS[@]}
DEPTH=$((DEPTH - 1))

# Couple of useful variables
FILENAME="${RELATIVE_PATH_PARTS[$DEPTH]}"

# If the file has an extension, get it otherwise set it to empty string
EXTENSION="" && [[ "$FILENAME" == *.* ]] && EXTENSION="${FILENAME##*.}"

########################################

GREEN='\033[0;32m';YELLOW='\033[0;33m';RED='\033[0;31m';PURPLE='\033[0;34m';DARK_GRAY='\033[1;30m';NC='\033[0m';

function logo() {
    TEXT=(
        " ______   __  __   __   __ " "    " "    ______   __  __   "
        "/\\  == \\ /\\ \\/\\ \\ /\\ \"-.\\ \\ " "    " "  /\\  ___\\ /\\ \\_\\ \\  "
        "\\ \\  __< \\ \\ \\_\\ \\\\\\ \\ \\-. \\ " "  __" " \\ \\___ \\\\\\ \\  __ \\ "
        " \\ \\_\\ \\_\\\\ \\_____\\\\ \\_\\ \"\\_\\ " "/\\_\\" " \\/\\_____\\\\ \\_\\ \\_\\"
        "  \\/_/ /_/ \\/_____/ \\/_/ \\/_/ " "\\/_/" "  \\/_____/ \\/_/\\/_/"
    )
    printf "$PURPLE%s$DARK_GRAY%s$PURPLE%s$NC\n" "${TEXT[0]}" "${TEXT[1]}" "${TEXT[2]}"
    printf "$PURPLE%s$DARK_GRAY%s$PURPLE%s$NC\n" "${TEXT[3]}" "${TEXT[4]}" "${TEXT[5]}"
    printf "$PURPLE%s$DARK_GRAY%s$PURPLE%s$NC\n" "${TEXT[6]}" "${TEXT[7]}" "${TEXT[8]}"
    printf "$PURPLE%s$DARK_GRAY%s$PURPLE%s$NC\n" "${TEXT[9]}" "${TEXT[10]}" "${TEXT[11]}"
    printf "$PURPLE%s$DARK_GRAY%s$PURPLE%s ${DARK_GRAY}v%s$NC\n" "${TEXT[12]}" "${TEXT[13]}" "${TEXT[14]}" "${_VERSION}"
    printf "\n"
}

function info() {
    printf "PROJECT_NAME        : $GREEN%s$NC  # project name (name of the project folder)\n" "$PROJECT_NAME"
    printf "RELATIVE_PATH_PARTS : $GREEN%s$NC  # relative path of the current file split into an array\n" "${RELATIVE_PATH_PARTS[*]}"
    printf "DEPTH               : $GREEN%s$NC  # depth of the current file (number of folders deep)\n" "${DEPTH}"
    printf "FILENAME            : $GREEN%s$NC  # just the filename (equivalent to RELATIVE_PATH_PARTS[DEPTH])\n" "${FILENAME}"
    printf "EXTENSION           : $GREEN%s$NC  # just the extension of the current file\n" "${EXTENSION}"
    printf "ROOT_FOLDER         : $GREEN%s$NC  # full path to the root folder of the project\n" "${ROOT_FOLDER}"
    printf "FULL_FILE_PATH      : $GREEN%s$NC  # full path of the current file\n" "${FULL_FILE_PATH}"
}

VERBOSE=true
# VERBOSE=false
[ "${RELATIVE_PATH_PARTS[0]}" = ".vscode" ] && [ "${RELATIVE_PATH_PARTS[$DEPTH]}" = "run.sh" ] && [ $DEPTH -eq 1 ] && VERBOSE=true
if $VERBOSE; then
    logo
    info
    exit 0
fi

function fatal() { printf "${RED}%s${NC}\n" "$1"; exit 1; }

################################################################################
################################################################################

# Do some other stuff here.

_EXAMPLE_MAKEFILE=false
if [ "$_EXAMPLE_MAKEFILE" = true ]; then
    # Run the makefile if you're currently editing the makefile
    if [ "$FILENAME" = "makefile" ]; then
        printf "About to run the makefile!\n"
        make
        exit 0
    fi
fi

_EXAMPLE_PYTEST=false
if [ "$_EXAMPLE_PYTEST" = true ]; then
    # Run the test if you're currently editing a python test file
    if [ "$EXTENSION" = "py" ] && [ "${RELATIVE_PATH_PARTS[0]}" = "tests" ]; then
        command -v pytest &>/dev/null || fatal "pytest could not be found, please install it!"
        printf "Running pytest for %s\n" "$FILENAME"
        pytest -s -x -k "${FILENAME%.*}"
        exit 0
    fi
fi


_EXAMPLE_CMAKE=false
if [ "$_EXAMPLE_CMAKE" = true ]; then
    
    TARGET="goo" # cmake target
    
    if [ ! -d "$ROOT_FOLDER/build" ]; then
        # If the build folder doesn't exist, create it and run cmake
        (
            mkdir "$ROOT_FOLDER/build"
            cd "$ROOT_FOLDER/build" || fatal "Could not cd to build folder"
            cmake ..
        )
    fi

    make --directory="$ROOT_FOLDER/build/"; OUT=$?;
    if [ $OUT == 0 ]; then
        printf "Running %s\n" "$TARGET"
        "$ROOT_FOLDER/build/$TARGET"; OUT=$?;
        if [ $OUT == 0 ]; then
            # shellcheck disable=SC2059
            printf "${GREEN}Success!${NC}\n";
        else
            printf "${RED}%s failed with %s${NC}\n" "$TARGET" "$OUT";
        fi
    else
        # spellchecker: ignore smake
        printf "${RED}make failed with %s${NC}\n" "$OUT";
        printf "maybe delete the content of the build folder, rerun cmake and try again?\n";
    fi
    exit $OUT
fi

################################################################################

# Got to the end of the script. I guess there's nothing to do.

printf "Nothing to do for ${GREEN}%s${NC}\n" "$FULL_FILE_PATH"