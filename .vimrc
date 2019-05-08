" ============ Configurações ============

" Desabilita a compatibilidade com o vi
set nocompatible

" Ativa a numeração das linhas
set number

" Cor da numeração
" hi LineNr      ctermfg=green

" Habilita o destaque de sintaxe
syntax enable

" Habilita a quebra de linha
set linebreak

" Configura o recuo de quebra
" set showbreak=...

" Recarrega o arquivo caso ele seja editado por um programa externo enquanto aberto
set autoread

" Faz o backspace funcionar
" set backspace=indent,eol,start

" Pisca a tela ao inves de bipar
set visualbell

" Ativa o menu WiLd (entre outras coisas, ativa <Ctrl>n e <Ctrl>p para navegar entre as correspondências da busca)
set wildmenu

" Destaca os resultados da busca e define as cores
set hlsearch

hi Search ctermbg=yellow ctermfg=red
hi IncSearch ctermbg=red  ctermfg=cyan

" Busca incremental
set incsearch

" Habilita o reconhecimento de arquivos
filetype on
"filetype plugin on
"filetype indent on

" Ignora a case ao pesquisar
set ignorecase

" Insere espaços no lugar de caracteres de tabulação
" set expandtab

" Define o tamanho da linha
" setlocal textwidth=78

" Define uma tabulação como sendo quatro espaços
set tabstop=4
set shiftwidth=4

" Define a exibição da linha de status
set laststatus=2
hi StatusLine ctermfg=white ctermbg=red cterm=NONE
hi StatusLineNC ctermfg=black ctermbg=black cterm=NONE
hi User1 ctermfg=red ctermbg=black
hi User2 ctermfg=black ctermbg=magenta
hi User3 ctermfg=magenta ctermbg=black
hi User4 ctermfg=black ctermbg=black
hi User5 ctermfg=blue ctermbg=black
hi User6 ctermfg=black ctermbg=blue
hi User7 ctermfg=cyan ctermbg=black
hi User8 ctermfg=black ctermbg=cyan
set statusline=\ \                 " Padding
set statusline+=%F                  " Path to the file
set statusline+=\ %1*%2*\         " Separator
set statusline+=%y                  " File type
set statusline+=\ %3*%4*\         " Separator
set statusline+=%=                  " Switch to right-side
set statusline+=\ %5*%6*\         " Separator
set statusline+=%p%%                " Line percent
set statusline+=\ %7*%8*\         " Separator
set statusline+=%l/%L               " Current line
set statusline+=\ \                 " Padding

" ============ Atalhos ============

nmap <Down> gj
nmap <Up> gk

" Salva o arquivo como root
cmap w!! w !sudo tee > /dev/null %

" Algumas funções necessitam
map <F8> :exec '!nohup mpv ' . shellescape(getline('.'), 1) . ' >/dev/null 2>&1&'<CR><CR>

" Limpa o buffer de buscas
nnoremap <silent> <F9> :set hlsearch!<CR>

" Muda a case da palavra abaixo do cursor
nnoremap cc viw~

" Move a linha atual para cima
nnoremap _ ddkP

" Deleta a linha atual no modo de inserção
inoremap <C-d> <esc>ddi

" Deleta a palavra posterior no modo de inserção
inoremap <C-b> <C-O>diw

" Alterna a numeração de linhas
map <F11> <esc>:set nu!<CR>

" Tabs
map <S-C-t> :tabnew<CR>
map <S-C-p> gT
map <S-C-n> gt
map <S-C-c> :tabc<CR>

" Janelas
nmap <silent> <leader>s <Esc>:split
nnoremap <silent> <leader>v :vsplit

" Navegação de janelas
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-l> :wincmd l<CR>

" Redimensionar janelas
nmap <silent> <S-k> :resize +5<CR>
nmap <silent> <S-j> :resize -5<CR>
nmap <silent> <S-h> :vertical resize +5<CR>
nmap <silent> <S-l> :vertical resize -5<CR>

" ============ Funções ============

" Remover linhas em branco duplicadas
" map ,d <esc>:%s/\(^\n\{2,}\)/\r/g<cr>o

" Remova todos os espaços em branco posteriores ao escrever
autocmd BufWritePre * %s/\s\+$//e

" Adiciona o shebang se o arquivo tiver a extensão .sh
function HeaderScript()
    "call setline(1, "#!/bin/sh")
	call setline(1, "#!/usr/bin/env bash")
    "call append(1,  "# Tanky Woo @ " . strftime('%Y-%m-%d', localtime()))
    normal G
    normal o
	normal o
endf
autocmd bufnewfile *.sh call HeaderScript()

" Torna executável arquivos com o shebang no início
au BufWritePost * if getline(1) =~ "^#!/bin/sh" ||
            \ getline(1) =~ "^#!/bin/bash" ||
			\ getline(1) =~ "^#!/usr/bin/env bash" | silent execute "!chmod +x <afile>" | endif

" ============ Corretor ============

" Mapeando correções para o modo de inserção
iab tambem também
iab vc você
iab nao não
