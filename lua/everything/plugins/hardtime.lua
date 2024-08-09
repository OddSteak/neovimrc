return {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
        disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil" },

        -- enable arrow keys
        disabled_keys = {
            ["<Up>"] = {},
            ["<Down>"] = {},
            ["<Right>"] = {},
            ["<Left>"] = {},
        },
    }
}
