" Vim script section
" Set region of test that starts with space x to comment
syn region  DONE      start="^ x "   end="$"
syn region  SECTIONS  start="^\~"    end="$"
" Mark tab regions with x
syn region  DONE      start="^\tx "  end="$"
" Mark undone items
syn region  UNDONE    start="^ - "   end="$"
syn region  UNDONE    start="^\t- "  end="$"

" Every time someone presses enter, include the date on next line (*DATE*)
imap <CR> <CR> - <C-R>=strftime("(*%Y-%m-%d %a %I:%M %p*)")<CR><ESC>4\|i
" Make o add the date as well
map o $a<CR>
" Map F10 so it updates list
map <F10> :py3 updateList() <CR>
" Map <F1> to mark item as done
map <F1> 0lxix<ESC> <F10>

" Set coloring
set background=dark

highlight Normal guibg=#333333 guifg=white
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

def sortSection(dateOld,vimBuffOffset):
	done = []
	notDone = []
	for line in vim.current.buffer[vimBuffOffset:]:
		if re.search(r"^ - |^\t- ", line):
			notDone.append(line)
			dateFoundStr = re.search(r"(?:[(][*])(.*)(?:[*][)])", line)
			if dateFoundStr:
				dateFound = datetime.datetime.strptime(dateFoundStr.group(1), "%Y-%m-%d %a %I:%M %p")
				if dateFound < dateOld:
					cmd = "syntax match OLD '{0}' containedin=UNDONE".format(dateFoundStr.group(1))
					vim.command(cmd)
		elif re.search(r"^ x |^\tx ", line):
			done.append(line)
		elif re.search(r"^\~", line):
			return(notDone,done,vimBuffOffset)	
		else:
			print("Broken syntax")
			quit()
		vimBuffOffset+=1

	vimBuffOffset+=1
	return (notDone,done,vimBuffOffset)

def updateList():
	dnow=datetime.datetime.now()
	dateOld = dnow - datetime.timedelta(days = 5)
	notDone = []
	done = []
	newVimBuff = []
	vimBuffOffset = 0
	vimBuffLen = len(vim.current.buffer)

	while vimBuffOffset < vimBuffLen: 
		for line in vim.current.buffer[vimBuffOffset:]:
			if re.search(r"^\~", line):
				newVimBuff.append(line)
				vimBuffOffset += 1
				notDone,done,vimBuffOffset = sortSection(dateOld,vimBuffOffset)
				for i in range(len(done)):
					newVimBuff.append(done[i])

				for i in range(len(notDone)):
					newVimBuff.append(notDone[i])

	for i in range(len(newVimBuff)):
		vim.current.buffer[i] = newVimBuff[i]
updateList()

EOF
