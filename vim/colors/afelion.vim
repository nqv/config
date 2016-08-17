" Vim colorscheme for 8-color terminals
" Author: Quoc-Viet Nguyen
" http://vimdoc.sourceforge.net/htmldoc/syntax.html#:colorscheme
hi clear
if exists("syntax_on")
  syntax reset
endif
let colors_name = "afelion"

set background=dark
hi Normal ctermfg=LightGray ctermbg=Black cterm=NONE guifg=LightGray guibg=Black gui=NONE
hi LineNr ctermfg=Blue ctermbg=DarkGray cterm=NONE guifg=Blue guibg=DarkGray gui=NONE
hi Pmenu ctermfg=Black ctermbg=LightGray cterm=NONE guifg=Black guibg=LightGray gui=NONE
hi PmenuSel ctermfg=Black ctermbg=Yellow cterm=NONE guifg=Black guibg=Yellow gui=NONE

hi WarningMsg ctermfg=Black ctermbg=Yellow cterm=NONE guifg=Black guibg=Yellow gui=NONE
hi ErrorMsg ctermfg=White ctermbg=Red cterm=NONE guifg=White guibg=Red gui=NONE
hi ColorColumn ctermbg=NONE cterm=reverse guibg=NONE gui=reverse
hi SpecialKey ctermfg=Blue cterm=NONE guifg=Blue gui=NONE
hi NonText ctermfg=Blue cterm=bold guifg=Blue gui=bold
hi Directory ctermfg=White cterm=bold guifg=White gui=bold
hi MoreMsg ctermfg=NONE cterm=reverse guifg=NONE gui=reverse
hi Question ctermfg=NONE cterm=reverse guifg=NONE gui=reverse
hi Visual ctermfg=Black ctermbg=LightGray cterm=NONE guifg=Black guibg=LightGray gui=NONE
hi Search ctermfg=Black ctermbg=Yellow cterm=NONE guifg=Black guibg=Yellow gui=NONE
hi Title ctermfg=Magenta cterm=bold guifg=Magenta gui=bold
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi CursorColumn ctermfg=NONE ctermbg=NONE cterm=reverse guifg=NONE guibg=NONE gui=reverse
hi CursorLine ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline

hi DiffText ctermfg=Black ctermbg=LightGray cterm=NONE guifg=Black guibg=LightGray gui=NONE
hi DiffAdd ctermfg=Black ctermbg=Green cterm=NONE guifg=Black guibg=Green gui=NONE
hi DiffDelete ctermfg=Black ctermbg=Red cterm=NONE guifg=Black guibg=Red gui=NONE
hi DiffChange ctermfg=Black ctermbg=Yellow cterm=NONE guifg=Black guibg=Yellow gui=NONE

hi Comment ctermfg=Cyan cterm=NONE guifg=Cyan gui=NONE
hi Constant ctermfg=Green cterm=NONE guifg=Green gui=NONE
hi Identifier ctermfg=White cterm=NONE guifg=White gui=NONE
hi Statement ctermfg=White cterm=NONE guifg=White gui=NONE
hi PreProc ctermfg=Magenta cterm=NONE guifg=Magenta gui=NONE
hi Type ctermfg=Green cterm=NONE guifg=Green gui=None
hi Special ctermfg=Yellow cterm=NONE guifg=Yellow gui=NONE

hi Error ctermfg=White ctermbg=Red cterm=NONE guifg=White guibg=Red gui=NONE
hi Todo ctermfg=Black ctermbg=Yellow cterm=NONE guifg=Black guibg=Yellow gui=NONE
