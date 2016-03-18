" Vim colorscheme for 8-color terminals
" Author: Quoc-Viet Nguyen
" http://vimdoc.sourceforge.net/htmldoc/syntax.html#:colorscheme
hi clear
if exists("syntax_on")
  syntax reset
endif
let colors_name = "afelion"

set background=dark
hi Normal ctermfg=LightGray ctermbg=Black guifg=LightGray guibg=Black
hi LineNr ctermfg=DarkBlue ctermbg=DarkGray guifg=DarkBlue guibg=DarkGray
hi Pmenu ctermfg=Black ctermbg=LightGray guifg=Black guibg=LightGray
hi PmenuSel ctermfg=Black ctermbg=Yellow guifg=Black guibg=Yellow

hi WarningMsg ctermfg=Black ctermbg=Yellow guifg=Black guibg=Yellow
hi ErrorMsg ctermfg=White ctermbg=Red guifg=White guibg=Red
hi ColorColumn cterm=reverse ctermbg=NONE gui=reverse guibg=NONE
hi SpecialKey ctermfg=Blue guifg=Blue
hi NonText cterm=bold ctermfg=Blue gui=bold guifg=Blue
hi Directory cterm=bold ctermfg=Cyan gui=bold guifg=Cyan
hi MoreMsg cterm=reverse ctermfg=NONE gui=reverse guifg=NONE
hi Question cterm=reverse ctermfg=NONE gui=reverse guifg=NONE
hi Visual ctermfg=Black ctermbg=LightGray guifg=Black guibg=LightGray
hi Search ctermfg=Black ctermbg=Yellow guifg=Black guibg=Yellow
hi Title cterm=bold ctermfg=Magenta gui=bold guifg=Magenta

hi DiffText cterm=NONE ctermfg=Black ctermbg=LightGray gui=NONE guifg=Black guibg=LightGray
hi DiffAdd ctermfg=Black ctermbg=Green guifg=Black guibg=Green
hi DiffDelete cterm=NONE ctermfg=Black ctermbg=Red gui=NONE guifg=Black guibg=Red
hi DiffChange ctermfg=Black ctermbg=Yellow guifg=Black guibg=Yellow

hi Comment ctermfg=DarkCyan guifg=DarkCyan
hi Constant ctermfg=DarkGreen guifg=DarkGreen
hi Identifier cterm=NONE ctermfg=Cyan gui=NONE guifg=Cyan
hi Statement cterm=NONE ctermfg=White gui=NONE guifg=White
hi PreProc ctermfg=DarkMagenta guifg=DarkMagenta
hi Type ctermfg=Green gui=None guifg=Green
hi Special ctermfg=Yellow guifg=Yellow
hi Error ctermfg=White ctermbg=DarkRed guifg=White guibg=DarkRed
hi Todo ctermfg=Black ctermbg=DarkYellow guifg=Black guibg=DarkYellow
