return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "github/copilot.vim",
        { 'folke/neodev.nvim', opts = {} },
    },

    lazy = false,

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local luasnip = require('luasnip')

        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())
        -- for snippets
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "cssls",
                "lua_ls",
                "pylsp",
                "bashls",
                "clangd",
                "sqlls",
                "ts_ls",
                "rust_analyzer",
                "marksman",
                "jsonls",
                "hyprls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                    disable = { 'missing-fields' },
                                },
                                completion = {
                                    callSnippet = "both"
                                },
                            }
                        }
                    }
                end,

                ["clangd"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.clangd.setup {
                        capabilities = capabilities,
                        cmd = {
                            "clangd",
                            "--fallback-style=Webkit",
                            "--background-index", "--suggest-missing-includes",
                            "--all-scopes-completion", "--completion-style=detailed",
                            "--offset-encoding=utf-16",
                        }
                    }
                end,

                ["pylsp"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pylsp.setup {
                        filetypes = { 'python' },
                        settings = {
                            configurationSources = { "flake8" },
                            formatCommand = { "black" },
                            pylsp = {
                                plugins = {
                                    -- jedi_completion = {fuzzy = true},
                                    -- jedi_completion = {eager=true},
                                    jedi_completion = {
                                        include_params = true,
                                    },
                                    jedi_signature_help = { enabled = true },
                                    jedi = {
                                        extra_paths = { '~/projects/work_odoo/odoo14', '~/projects/work_odoo/odoo14' },
                                        -- environment = {"odoo"},
                                    },
                                    pyflakes = { enabled = true },
                                    -- pylint = {args = {'--ignore=E501,E231', '-'}, enabled=true, debounce=200},
                                    pylsp_mypy = { enabled = false },
                                    pycodestyle = {
                                        enabled = true,
                                        ignore = { 'E501', 'E231' },
                                        maxLineLength = 120 },
                                    yapf = { enabled = true }
                                }
                            }
                        }
                    }
                end,
            }
        })

        luasnip.config.set_config {
            history = true,
            updateevents = "TextChanged,TextChangedI",
            enable_autosnippets = true,
            use_show_condition = false
        }

        require("luasnip.loaders.from_vscode").lazy_load()

        -- local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            sources = cmp.config.sources({
                    { name = 'luasnip',                option = { show_autosnippets = true, use_show_condition = false } },
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'path' },
                },
                {
                    { name = 'buffer' },
                }),

            mapping = cmp.mapping.preset.insert({
                ["<C-s>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<C-d>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ['<C-f>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if luasnip.expandable() then
                            luasnip.expand()
                        else
                            cmp.confirm({
                                select = true,
                            })
                        end
                    else
                        fallback()
                    end
                end),
                -- ['<C-f>'] = cmp.mapping.confirm({ select = true }),
                -- ['<C-d>'] = cmp.mapping.select_prev_item(cmp_select),
                -- ['<C-s>'] = cmp.mapping.select_next_item(cmp_select),

                -- ["<C-Space>"] = cmp.mapping.complete(),
            }),
        })
        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' },
            }
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            }),
            matching = { disallow_symbol_nonprefix_matching = false }
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = true,
                header = "",
                prefix = "",
            },
        })
        vim.cmd("Copilot disable")
    end
}
