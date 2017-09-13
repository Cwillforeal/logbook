# logbook
A simple plugin for vim to create a todo list.

## Install
For Windows:
1. Create folder $HOME/vimfile/syntax
   - Clone project into that folder
1. Locate Vim folder and open \Vim\vim80\filetype.vim

   - Add the lines:
   ```
   " Logbook
   au BufNewFile,BufRead *.logbook                            setf logbook
   ```
1. Create a file with a .logbook extention

## Usage
- The name of the list will be at the top and should have no leading spaces
- Items should be added with a CR or 'o'.  This will add the " - " and date that is needed
- Undone items start with a " - " or a "\t- "
- When you finish with an item delete the '-' and replace witha 'x'
- The list will sort after every restart
