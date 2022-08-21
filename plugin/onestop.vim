" Title: OneStop.nvim
" Description: A repository for build tool commands and other external commands
" Last Change:  22 August 2022
" Maintainer : https://github.com/charlie39
" Email: charlie39@cock.li


if exists("g:loaded_onestop")
    finish
endif

let g:loaded_onestop = 1

lua require'onestop'.setup()
nnoremap <leader>C <cmd>OSRunner<cr>
