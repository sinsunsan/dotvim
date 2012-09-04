" Un exemple de fichier vimrc.
"
" Mainteneur :  Bram Moolenaar <Bram@vim.org>
" Dernières modifications : 9 Sep 1999
"
" Pour l'utiliser, copiez le dans
"     pour Unix et OS/2 :  ~/.vimrc
"            pour Amiga :  s:.vimrc
" pour MS-DOS and Win32 :  $VIM\_vimrc
 
" install pathogen plugin
" https://github.com/tpope/vim-pathogen/blob/master/README.markdown
call pathogen#infect()
syntax on
filetype plugin indent on


set nocompatible        " Utilise les défauts Vim (bien mieux !)
set bs=2                " autorise l'effacement de tout en mode insertion
"set ai                  " toujours utiliser l'auto-indentation
set backup              " Conserver un fichier de sauvegarde
 
set viminfo='20,\"50    " Lit/écrit un fichier .viminfo, ne sauve pas plus
                        " de 50 lignes de registres
 
set history=50          " Conserve 50 lignes d'historique des commandes
set ruler               " Montre toujours la position du curseur


" N'utilise pas le mode Ex, utilise Q pour le formatage
map Q gq
 
" p en mode Visuel remplace le texte sélectionné par le registre "".
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Active la coloration syntaxique lorsque le terminal dispose de couleurs
" Active aussi la coloration de la dernière chaîne recherchée.
if &t_Co> 2 || has("gui_running")
 syntax on
 set hlsearch
endif

" Ne lance la partie suivante que si le support des autocommandes a été inclus
" lors de la compilation
if has("autocmd")

 " Dans les fichiers textes, toujours limiter la longueur du texte à 78
 " caractères
 autocmd BufRead *.txt set tw=78
 augroup cprog

 " Supprime toutes les autocommandes cprog
 au!

 " Lors du début d'édition d'un fichier :
 "   Pour les fichiers C et C++ active le formatage des
 "   commentaires et l'indentation C
 "   Pour les autres fichiers, les désactive.
 "   Ne pas changer l'ordre, il est important que la ligne
 "   avec * arrive avant.
 autocmd FileType *      set formatoptions=tcql nocindent comments&
 autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
 augroup END
 augroup gzip

 " Supprime toutes les autocommandes gzip
 au!

 " Active l'édition des fichiers gzippés
 " Active le mode binaire avant de lire le fichier
 autocmd BufReadPre,FileReadPre        *.gz,*.bz2 set bin
 autocmd BufReadPost,FileReadPost      *.gz call GZIP_read("gunzip")
 autocmd BufReadPost,FileReadPost      *.bz2 call GZIP_read("bunzip2")
 autocmd BufWritePost,FileWritePost    *.gz call GZIP_write("gzip")
 autocmd BufWritePost,FileWritePost    *.bz2 call GZIP_write("bzip2")
 autocmd FileAppendPre                 *.gz call GZIP_appre("gunzip")
 autocmd FileAppendPre                 *.bz2 call GZIP_appre("bunzip2")
 autocmd FileAppendPost                *.gz call GZIP_write("gzip")
 autocmd FileAppendPost                *.bz2 call GZIP_write("bzip2")

 " Après la lecture du fichier compressé : décompresse le texte dans le
 " buffer avec "cmd"
 fun! GZIP_read(cmd)
 let ch_save = &ch
 set ch=2
 execute "'[,']!" . a:cmd
 set nobin
 let &ch = ch_save
 execute ":doautocmd BufReadPost " . expand("%:r")
 endfun
 
 " Après l'écriture du fichier compressé : compresse le fichier écrit avec "cmd"
 fun! GZIP_write(cmd)
 if rename(expand("<afile>"), expand("<afile>:r")) == 0
 execute "!" . a:cmd . " <afile>:r"
 endif
 endfun
 
// Drupal vim settings http://drupal.org/node/29325
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent

 if has("autocmd")
  " Drupal *.module and *.install files.
  augroup module
    autocmd BufRead,BufNewFile *.module set filetype=php
    autocmd BufRead,BufNewFile *.install set filetype=php
    autocmd BufRead,BufNewFile *.test set filetype=php
    autocmd BufRead,BufNewFile *.inc set filetype=php
    autocmd BufRead,BufNewFile *.profile set filetype=php
    autocmd BufRead,BufNewFile *.view set filetype=php
  augroup END
endif
syntax on


 " Avant l'ajout au fichier compressé : décompresse le fichier avec "cmd"
 fun! GZIP_appre(cmd)
 execute "!" . a:cmd . " <afile>"
 call rename(expand("<afile>:r"), expand("<afile>"))
 endfun
 augroup END

 " Ce qui suit est désactivé, car il change la liste de sauts. On ne peut pas utiliser
 " CTRL-O pour revenir en arrière dans les fichiers précédents plus d'une fois.
 if 0
 " Lors de l'édition d'un fichier, saute toujours à la dernière position du curseur.
 " Ceci doit se trouver après les commandes de décompression.
 autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
 endif
endif " has("autocmd")

" Pour faire des espaces à la place des tabulations
set tabstop=2 shiftwidth=2 expandtab


" pas de fichiers swap http://thehumblecoder.wordpress.com/2006/08/08/vim-swap-and-backup-files/
set nobackup
set nowritebackup
set noswapfile

" http://smartic.us/2009/04/06/code-folding-in-vim/
"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use


" change runtime path to add vim 
set runtimepath+=$HOME/.vim/plugin

" reopen a file at last line 
" http://superuser.com/questions/111016/vim-open-file-at-location-that-was-last-viewed
if has("autocmd")
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal g'\"" |
  \ endif
endif
