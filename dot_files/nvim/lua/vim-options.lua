-- Add line numbers to side
vim.cmd("set number")
vim.cmd("set relativenumber")
-- Keep cursor in the middle of the screen
vim.cmd("set so=999")
-- Show whitespace
vim.cmd("set listchars=space:·,tab:-> ")
vim.cmd("set list")
-- indent option
vim.cmd("autocmd FileType c setlocal shiftwidth=2 tabstop=2 cindent expandtab")
vim.cmd("set cinoptions=:0,l1,g0,(0,W4,m1")
vim.cmd("autocmd FileType python setlocal shiftwidth=4 tabstop=4 cindent expandtab")
vim.api.nvim_exec([[
  autocmd BufWritePre *.c,*.h lua vim.lsp.buf.format()
]], false)
-- vim.cmd("set expandtab")
-- vim.cmd("set cinoptions=l1")
-- vim.cmd("set tabstop=4")
-- vim.cmd("set softtabstop=4")
-- vim.cmd("set shiftwidth=4")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"





