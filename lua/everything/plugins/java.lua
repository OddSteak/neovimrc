return {
    'nvim-java/nvim-java',
    ft = {"java"},
    dependencies = {
        'nvim-java/lua-async-await',
        'nvim-java/nvim-java-refactor',
        'nvim-java/nvim-java-core',
        'nvim-java/nvim-java-test',
        'nvim-java/nvim-java-dap',
        'MunifTanjim/nui.nvim',
        'neovim/nvim-lspconfig',
        'mfussenegger/nvim-dap',
        'rcarriga/nvim-dap-ui',
        'nvim-neotest/nvim-nio',
        {
            'williamboman/mason.nvim',
            opts = {
                registries = {
                    'github:nvim-java/mason-registry',
                    'github:mason-org/mason-registry',
                },
            },
        }
    },

    config = function()
        require('java').setup()
        require("lspconfig").jdtls.setup({
            init_options = {
                bundles = {
                    vim.fn.glob(
                    "/home/dell/.m2/repository/com/microsoft/java/com.microsoft.java.debug.plugin/0.53.0/com.microsoft.java.debug.plugin-0.53.0.jar",
                        true)
                },
            },
            handlers = {
                -- By assigning an empty function, you can remove the notifications
                -- printed to the cmd
                ["$/progress"] = function(_, result, ctx) end,
            },
        })
        require("dapui").setup()
    end
}
