# run.sh

```
 ______   __  __   __   __         ______   __  __   
/\  == \ /\ \/\ \ /\ "-.\ \       /\  ___\ /\ \_\ \  
\ \  __< \ \ \_\ \\ \ \-.  \   __ \ \___  \\ \  __ \ 
 \ \_\ \_\\ \_____\\ \_\\"\_\ /\_\ \/\_____\\ \_\ \_\
  \/_/ /_/ \/_____/ \/_/ \/_/ \/_/  \/_____/ \/_/\/_/
```

vscode keybindings script to run .vscode/run.sh in bash, passing the current file as an input. This started as a vscode hack/joke but I ended up finding this *unreasonably* useful.

Originally posted on [gist](https://gist.github.com/MarcinKonowalczyk/709e93f08e9d72f8092acd5b8d34c81f).

## Instructions

Add the following keybinding to your `keybindings.json`:

```jsonc
[
  { // Run the ./.vscode/run.sh in terminal, passing it the name of the current file if it exists
    // Also, search through parent directories to see whether there is a .vscode/run.sh there
    "key": "shift+enter",
    "command": "workbench.action.terminal.sendSequence",
    "when": "editorTextFocus",
    "args": {
      // "text": "\u0003bash -c 'FILE=\"${file}\"; PWD=$(dirname \"$FILE\"); SCRIPT=\".vscode/run.sh\"; echo \"FILE = $FILE\"; echo \"PWD = $PWD\"; echo \"SCRIPT = $SCRIPT\"; while :; do RUN=\"$PWD/$SCRIPT\"; if [[ -e $RUN ]]; then echo \"Run script found at $RUN\"; \"$RUN\" \"$FILE\"; break; else echo \"No $RUN found\"; fi; [[ $PWD != \"/\" && $PWD != \"~\" ]] || { echo \"No $SCRIPT found\" && break; }; PWD=$(dirname \"$PWD\"); done'\u000D",
      "text": "\u0003bash -c 'FILE=\"${file}\"; PWD=$(dirname \"$FILE\"); SCRIPT=\".vscode/run.sh\"; while :; do RUN=\"$PWD/$SCRIPT\"; if [[ -e $RUN ]]; then \"$RUN\" \"$FILE\"; break; fi; [[ $PWD != \"/\" && $PWD != \"~\" ]] || { echo \"No $SCRIPT found\" && break; }; PWD=$(dirname \"$PWD\"); done'\u000D"
    }
  }
]
```

Then in your project make the .vscode folder (if there isn't one there already and add `run.sh` file to it). It will be run each time you press the keybinding `shift+enter` with an editor focus.

```
[ -d ".vscode" ] || mkdir ".vscode"
SOURCE="https://raw.githubusercontent.com/MarcinKonowalczyk/run_sh/master/run.sh"
curl $SOURCE > .vscode/run.sh
chmod u+x ./.vscode/run.sh
```

## One-liner

```
[ -d ".vscode" ] || mkdir ".vscode"; curl https://raw.githubusercontent.com/MarcinKonowalczyk/run_sh/master/run.sh > .vscode/run.sh && chmod u+x ./.vscode/run.sh
```

## Test

```
cd ~
mkdir test
cd test
[ -d ".vscode" ] || mkdir ".vscode"; curl https://raw.githubusercontent.com/MarcinKonowalczyk/run_sh/master/run.sh > .vscode/run.sh && chmod u+x ./.vscode/run.sh
touch hi.txt
code hi.txt
```

And press `shift+enter`. You should see something like:

```
Hello from run script! ^_^
ROOT       : /Users/marcinkonowalczyk/test  # root directory of the project
NAME       : test  # project name
PWD        : /Users/marcinkonowalczyk/test  # pwd
FILE       : /Users/marcinkonowalczyk/test/.vscode/run.sh # full file information
FILENAME   : run.sh  # current filename
FILEPATH   : /Users/marcinkonowalczyk/test/.vscode  # path of the current file
FILE_FOLDER : .vscode  # folder in which the current file is located
EXTENSION  : sh  # just the extension of the current file
ROOT_FOLDER : <same as FILE_FOLDER>
```

# ToDo's

- [ ] ? run.fish / run.zsh
- [ ] ? script which automatically adds keyboard shortcut to keybindings.json
- [ ] ? find a workaround for something already running in the terminal (e.g. python/julia repl)
- [x] ? logo screenshot / comment block?
- [ ] Rework the default `run.sh` script. Make the variables to have slightly more descriptive names.
