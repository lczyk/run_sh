# run.sh

Vscode keybinding script to run .vscode/run.sh in bash, passing the current file as an input.

## instructions

Add the keybinding to `keybindings.json`, then in your project make the .vscode folder (if there isnt one there already and add `run.sh` file to it). It will be run each time you press the keybinding `shift+enter` with an editor focus.

```
[ -d ".vscode" ] || mkdir ".vscode"
SOURCE="https://gist.githubusercontent.com/MarcinKonowalczyk/709e93f08e9d72f8092acd5b8d34c81f/raw/2a1de7e14c654f48c1cdfd8ab50fe00d067c0024/run.sh"
curl $SOURCE > .vscode/run.sh
chmod u+x ./.vscode/run.sh
```

## one-liner

```
[ -d ".vscode" ] || mkdir ".vscode"; curl https://gist.githubusercontent.com/MarcinKonowalczyk/709e93f08e9d72f8092acd5b8d34c81f/raw/2a1de7e14c654f48c1cdfd8ab50fe00d067c0024/run.sh > .vscode/run.sh && chmod u+x ./.vscode/run.sh
```

## test

```
cd ~
mkdir test
cd test
[ -d ".vscode" ] || mkdir ".vscode"; curl https://gist.githubusercontent.com/MarcinKonowalczyk/709e93f08e9d72f8092acd5b8d34c81f/raw/2a1de7e14c654f48c1cdfd8ab50fe00d067c0024/run.sh > .vscode/run.sh && chmod u+x ./.vscode/run.sh
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
FILEFOLDER : .vscode  # folder in which the current file is located
EXTENSION  : sh  # just the extension of the current file
ROOTFOLDER : <same as FILEFOLDER>
```

## todos

- [ ] automatically update links on push