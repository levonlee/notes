#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
emacs -nw -l "$DIR/.emacs" --debug-init "$DIR/notes.org"
