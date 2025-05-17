return {
    "kkoomen/vim-doge",
    config = function()
        vim.g.doge_doc_standard_python = 'doxygen'
        vim.keymap.set('n', '<Leader>dg', '<Plug>(doge-generate)')
    end
}
