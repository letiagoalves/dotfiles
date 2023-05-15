require("alvest")

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer.lua | source <afile> | PackerCompile
  augroup end
]])
