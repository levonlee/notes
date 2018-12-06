# notes
My notes

## run.bat

Windows
```
set HOME=C:\Users\Li\notes
C:\emacs\emacs-26.1-x86_64\bin\runemacs.exe notes.org
```

Ubuntu
- Change HOME directory so that Emacs loads current dir's `.emacs` not the default `~/.emacs`
- `-L` : add current dir to the list of directories Emacs searches for the Lisp files (e.g. elpa files under current dir `.emacs.d/elpa/*`)

```
#!/bin/bash
HOME=~/li/notes emacs -L . notes.org
```