return {
    "lervag/vimtex",
    lazy = false,

    init = function()
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_view_forward_search_on_start = false
        vim.g.vimtex_compiler_latexmk = {
            out_dir = '.latexbuild',
            aux_dir = '.latexbuild',
        }
    end
}
