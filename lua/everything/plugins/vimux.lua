return {
    "preservim/vimux",
    config = function()
        vim.keymap.set("n", "<leader>mk", "<cmd>VimuxPromptCommand<cr>")
        vim.keymap.set("n", "<leader>mp", "<cmd>VimuxRunLastCommand<cr>")
    end
}
