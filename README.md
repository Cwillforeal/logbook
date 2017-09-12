# logbook
A simple plugin for vim to create a todo list.

## Install
For Windows:
1. Create file $HOME/vimfile/syntax
1. Clone project into that repository
1. Locate Vim folder and open \Vim\vim80\filetype.vim
1. Add the lines:
```
" Logbook
au BufNewFile,BufRead *.logbook                            setf logbook
```
5. Create a file with a .logbook extention
