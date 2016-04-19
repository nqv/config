" Vim colorscheme for 8-color terminals
" Author: Quoc-Viet Nguyen
" http://vimdoc.sourceforge.net/htmldoc/syntax.html#:colorscheme
hi clear
if exists("syntax_on")
  syntax reset
endif
let colors_name = "afelion"

set background=dark
hi Normal cterm=NONE ctermfg=LightGray ctermbg=Black gui=NONE guifg=LightGray guibg=Black
hi LineNr cterm=NONE ctermfg=DarkBlue ctermbg=DarkGray gui=NONE guifg=DarkBlue guibg=DarkGray
hi Pmenu cterm=NONE ctermfg=Black ctermbg=LightGray gui=NONE guifg=Black guibg=LightGray
hi PmenuSel cterm=NONE ctermfg=Black ctermbg=Yellow gui=NONE guifg=Black guibg=Yellow

hi WarningMsg cterm=NONE ctermfg=Black ctermbg=Yellow gui=NONE guifg=Black guibg=Yellow
hi ErrorMsg cterm=NONE ctermfg=White ctermbg=Red gui=NONE guifg=White guibg=Red
hi ColorColumn cterm=reverse ctermbg=NONE gui=reverse guibg=NONE
hi SpecialKey cterm=NONE ctermfg=Blue gui=NONE guifg=Blue
hi NonText cterm=bold ctermfg=Blue gui=bold guifg=Blue
hi Directory cterm=bold ctermfg=White gui=bold guifg=White
hi MoreMsg cterm=reverse ctermfg=NONE gui=reverse guifg=NONE
hi Question cterm=reverse ctermfg=NONE gui=reverse guifg=NONE
hi Visual cterm=NONE ctermfg=Black ctermbg=LightGray gui=NONE guifg=Black guibg=LightGray
hi Search cterm=NONE ctermfg=Black ctermbg=Yellow gui=NONE guifg=Black guibg=Yellow
hi Title cterm=bold ctermfg=Magenta gui=bold guifg=Magenta
hi Underlined cterm=underline ctermfg=NONE ctermbg=NONE gui=underline guifg=NONE guibg=NONE
hi CursorColumn cterm=reverse ctermfg=NONE ctermbg=NONE gui=reverse guifg=NONE guibg=NONE
hi CursorLine cterm=underline ctermfg=NONE ctermbg=NONE gui=underline guifg=NONE guibg=NONE

hi DiffText cterm=NONE ctermfg=Black ctermbg=LightGray gui=NONE guifg=Black guibg=LightGray
hi DiffAdd cterm=NONE ctermfg=Black ctermbg=Green gui=NONE guifg=Black guibg=Green
hi DiffDelete cterm=NONE ctermfg=Black ctermbg=Red gui=NONE guifg=Black guibg=Red
hi DiffChange cterm=NONE ctermfg=Black ctermbg=Yellow gui=NONE guifg=Black guibg=Yellow

hi Comment cterm=NONE ctermfg=DarkCyan gui=NONE guifg=DarkCyan
hi Constant cterm=NONE ctermfg=DarkGreen gui=NONE guifg=DarkGreen
hi Identifier cterm=NONE ctermfg=Cyan gui=NONE guifg=Cyan
hi Statement cterm=NONE ctermfg=White gui=NONE guifg=White
hi PreProc cterm=NONE ctermfg=DarkMagenta gui=NONE guifg=DarkMagenta
hi Type cterm=NONE ctermfg=Green gui=None guifg=Green
hi Special cterm=NONE ctermfg=Yellow gui=NONE guifg=Yellow
hi Error cterm=NONE ctermfg=White ctermbg=DarkRed gui=NONE guifg=White guibg=DarkRed
hi Todo cterm=NONE ctermfg=Black ctermbg=DarkYellow gui=NONE guifg=Black guibg=DarkYellow
