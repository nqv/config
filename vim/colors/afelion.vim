" Vim color
" Author: Quoc-Viet Nguyen

" First remove all existing highlighting.
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "afelion"

hi Normal ctermbg=Black ctermfg=LightGray guibg=Black guifg=Gainsboro

hi SpecialKey term=bold ctermfg=Blue guifg=Gray20
"hi NonText term=bold cterm=bold ctermfg=Red gui=bold guifg=Blue
"hi IncSearch term=reverse cterm=reverse gui=reverse
"hi Search term=reverse ctermbg=3 guibg=Gold2

"WinEnd	term=bold ctermbg=LightGrey guibg=LightGrey
hi Directory term=bold ctermfg=Cyan guifg=SkyBlue
hi ErrorMsg term=standout ctermfg=LightGray ctermbg=Red guifg=White guibg=Red
"Search	term=reverse ctermbg=Yellow guibg=Yellow
"MoreMsg	term=bold cterm=bold ctermfg=Green gui=bold guifg=Green
"ModeMsg	term=bold cterm=bold gui=bold
hi LineNr term=underline ctermbg=DarkGray ctermfg=DarkBlue guifg=Gray30 guibg=Gray10
"Question    term=standout cterm=bold ctermfg=Green gui=bold guifg=Green
"StatusLine  term=reverse cterm=reverse gui=reverse
"Title	term=bold cterm=bold ctermfg=Blue gui=bold guifg=Blue
"Visual	term=reverse cterm=reverse gui=reverse
"WarningMsg  term=standout ctermfg=Red guifg=Red
"Cursor	guibg=Green
hi ColorColumn ctermbg=DarkBlue ctermfg=LightGray guibg=Gray4

"hi StatusLine ctermbg=Black ctermfg=White guibg=#4c4c4c guifg=fg gui=bold
"hi StatusLineNC ctermbg=Black ctermfg=Gray guibg=#404040 guifg=fg gui=none
hi TabLine ctermfg=LightGray ctermbg=Black guibg=#6e6e6e guifg=fg gui=underline
"hi TabLineFill ctermfg=LightGray guibg=#6e6e6e guifg=fg gui=underline
hi TabLineSel ctermfg=LightGray ctermbg=DarkBlue guibg=bg guifg=fg gui=bold
"hi VertSplit term=reverse cterm=reverse gui=bold guifg=White guibg=Gray45

"hi Title term=bold ctermfg=5 gui=bold guifg=DeepPink3
"hi Visual term=reverse cterm=reverse gui=reverse guifg=Grey80 guibg=fg
"hi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
"hi WarningMsg term=standout ctermfg=1 gui=bold guifg=Red
hi WildMenu term=standout ctermbg=DarkBlue ctermfg=LightGray guifg=Black guibg=Yellow
" Popup
hi Pmenu ctermfg=1 ctermbg=DarkBlue ctermfg=LightGray guifg=LightGray guibg=Gray30
hi PmenuSel ctermbg=Yellow ctermfg=Black guifg=Black guibg=Yellow gui=none
"hi Folded term=standout ctermfg=Red ctermbg=7 guifg=Black guibg=#e3c1a5
"hi FoldColumn term=standout ctermfg=4 ctermbg=7 guifg=DarkBlue guibg=Gray80
hi DiffAdd term=bold ctermfg=LightGray ctermbg=DarkBlue guifg=White guibg=RoyalBlue
hi DiffChange term=bold ctermfg=LightGray ctermbg=DarkGreen guifg=White guibg=ForestGreen
hi DiffDelete term=bold ctermfg=LightGray ctermbg=Magenta gui=bold guifg=White guibg=DarkRed
hi DiffText term=reverse ctermfg=LightGray ctermbg=Red guifg=DarkRed guibg=DarkSeaGreen
"hi Cursor guifg=bg guibg=fg
"hi lCursor guifg=bg guibg=fg

" Colors for syntax highlighting
hi Comment cterm=none ctermfg=Blue guifg=DarkOliveGreen
hi Constant ctermfg=DarkGreen guifg=RoyalBlue
  hi String ctermfg=Green guifg=RoyalBlue
  hi Character ctermfg=Green guifg=SteelBlue
  hi Number ctermfg=Green guifg=DarkGoldenRod
  hi Boolean cterm=bold ctermfg=Green guifg=DarkKhaki
  hi Float ctermfg=Green guifg=GoldenRod
hi Special ctermfg=Yellow guifg=DarkKhaki
hi Identifier ctermfg=Cyan guifg=RosyBrown
  hi Function ctermfg=Cyan guifg=RosyBrown
hi Statement ctermfg=White gui=none guifg=MediumTurquoise
  hi Conditional ctermfg=Red guifg=Chocolate
  hi Repeat ctermfg=Red guifg=IndianRed
  hi Label ctermfg=Brown guifg=Brown
  hi Operator ctermfg=Cyan guifg=MediumSeaGreen
  hi Keyword cterm=bold ctermfg=Cyan guifg=MediumTurquoise
hi PreProc ctermfg=DarkMagenta guifg=MediumPurple
  hi Include ctermfg=DarkMagenta guifg=MediumPurple
  hi Define ctermfg=Magenta guifg=MediumPurple
  hi Macro ctermfg=Magenta guifg=MediumPurple
  hi PreCondit ctermfg=Magenta guifg=MediumPurple
hi Type cterm=bold ctermfg=Green gui=none guifg=MediumSeaGreen
  hi Structure cterm=bold ctermfg=DarkGreen guifg=MediumSeaGreen
  hi StorageClass cterm=bold ctermfg=DarkGreen guifg=MediumSeaGreen
  hi Typedef cterm=bold ctermfg=DarkGreen guifg=MediumSeaGreen
"hi Ignore ctermfg=7 guifg=bg
hi Error term=reverse cterm=bold ctermfg=LightGray ctermbg=Red gui=bold guifg=White guibg=Red
hi Todo term=standout cterm=bold ctermfg=LightBlue ctermbg=Black gui=bold guifg=Black guibg=Yellow
"hi Underlined ctermbg=Black ctermfg=White guibg=bg guifg=#00a0ff gui=underline
hi SignColumn ctermbg=DarkGray guibg=Gray10

"*Comment	any comment
"*Constant	any constant
" String		a string constant: "this is a string"
" Character	a character constant: 'c', '\n'
" Number		a number constant: 234, 0xff
" Boolean	a boolean constant: TRUE, false
" Float		a floating point constant: 2.3e10
"*Identifier	any variable name
" Function	function name (also: methods for classes)
"*Statement	any statement
" Conditional	if, then, else, endif, switch, etc.
" Repeat		for, do, while, etc.
" Label		case, default, etc.
" Operator	"sizeof", "+", "*", etc.
" Keyword	any other keyword
"
"*PreProc	generic Preprocessor
" Include	preprocessor #include
" Define		preprocessor #define
" Macro		same as Define
" PreCondit	preprocessor #if, #else, #endif, etc.
"*Type		int, long, char, etc.
" StorageClass	static, register, volatile, etc.
" Structure	struct, union, enum, etc.
" Typedef	A typedef
"*Special	any special symbol
"*Error		any erroneous construct
"*Todo		anything that needs extra attention
