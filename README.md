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

```sh
[ -d ".vscode" ] || mkdir ".vscode"
SOURCE="https://raw.githubusercontent.com/MarcinKonowalczyk/run_sh/master/run.sh"
TARGET=".vscode/run.sh"
[ -f "$TARGET" ] && mv $TARGET $TARGET~
curl $SOURCE > $TARGET
chmod u+x $TARGET
```

## One-liners

Make a .vscode folder in the current directory (aka your project) and download the latest run.sh script from `MarcinKonowalczyk/run_sh/master`. If a run.sh script already existed, back it up to run.sh~. This is useful if you already wrote a bunch of behaviours and you don't wanna accidentally overwrite them.

```sh
[ -d .vscode ] || mkdir .vscode; [ -f .vscode/run.sh ] && mv .vscode/run.sh .vscode/run.sh~; curl https://raw.githubusercontent.com/MarcinKonowalczyk/run_sh/master/run.sh > .vscode/run.sh && chmod u+x .vscode/run.sh;
```

If you do this often, you can set it up as an alias. For bash/zsh (in `~/.bashrc` / `~/.zshrc`):

```sh
alias runsh="[ -d .vscode ] || mkdir .vscode; [ -f .vscode/run.sh ] && mv .vscode/run.sh .vscode/run.sh~; curl https://raw.githubusercontent.com/MarcinKonowalczyk/run_sh/master/run.sh > .vscode/run.sh && chmod u+x .vscode/run.sh;"
```

or in `~/.config/fish/config.fish`:

```sh
# alias for downloading run.sh
functions --erase runsh
function runsh
    [ -d .vscode ] || mkdir .vscode;
    [ -f .vscode/run.sh ] && mv .vscode/run.sh .vscode/run.sh~;
    curl https://raw.githubusercontent.com/MarcinKonowalczyk/run_sh/master/run.sh > .vscode/run.sh && chmod u+x .vscode/run.sh;
end
```


## Test

```sh
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
- [x] Rework the default `run.sh` script. Make the variables to have slightly more descriptive names.
