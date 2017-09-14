" Vim script section
" Set region of test that starts with space x to comment
syn region  DONE      start="^ x "   end="$"
syn region  SECTIONS  start="^\w"    end="$"
" Mark tab regions with x
syn region  DONE      start="^\tx "  end="$"
" Mark undone items
syn region  UNDONE    start="^ - "   end="$"
syn region  UNDONE    start="^\t- "  end="$"

" Every time someone presses enter, include the date on next line (*DATE*)
imap <CR> <CR> - <C-R>=strftime("(*%Y-%m-%d %a %I:%M %p*)")<CR><ESC>4\|i
" Make o add the date as well
map o $a<CR>

" Set coloring
set background=dark

highlight Normal guibg=#333333
highlight UNDONE guifg=white ctermfg=white
highlight DONE guifg=#1b6ae8 ctermfg=darkblue
highlight SECTIONS guifg=#f77671 ctermfg=brown
highlight OLD guifg=red ctermfg=red

" Check for python
if !has('python3')
	echo "Error: Required vim complied with +python3"
	finish
endif

" Start python
python3 << EOF

import vim
import re
import datetime

dnow=datetime.datetime.now()
dateOld = dnow - datetime.timedelta(days = 5)
notDone = []
done = []

for i in range(len(vim.current.buffer)):
	if re.search(r"^ - |^\t- ", vim.current.buffer[i]):
		notDone.append(vim.current.buffer[i])
		dateFoundStr = re.search(r"(?:[(][*])(.*)(?:[*][)])", vim.current.buffer[i])
		if dateFoundStr:
			dateFound = datetime.datetime.strptime(dateFoundStr.group(1), "%Y-%m-%d %a %I:%M %p")
			if dateFound < dateOld:
				cmd = "syntax match OLD '{0}' containedin=UNDONE".format(dateFoundStr.group(1))
				vim.command(cmd)
	else:
		if re.search(r"^ x |^\tx ", vim.current.buffer[i]):
			done.append(vim.current.buffer[i])


del vim.current.buffer[1:]

for i in range(len(done)):
	vim.current.buffer.append(done[i])

for i in range(len(notDone)):
	vim.current.buffer.append(notDone[i])

EOF
