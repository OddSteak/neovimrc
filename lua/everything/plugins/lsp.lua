return {
    "neovim/nvim-lspconfig",
    dependencies = {
        'nvim-java/nvim-java',
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
        },
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

        vim.lsp.config('jdtls', {})
        vim.lsp.enable('jdtls')

        vim.lsp.config('java', {})
        vim.lsp.enable('java')

        vim.lsp.config('fidget', {})
        vim.lsp.enable('fidget')

        vim.lsp.config('mason', {})
        vim.lsp.enable('mason')

        vim.lsp.config("mason-lspconfig", {
            ensure_installed = {
                "cssls",
                "html",
                "lua_ls",
                "pyright",
                "ruff",
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
                    vim.lsp.config(server_name, {
                        capabilities = capabilities
                    })
                    vim.lsp.enable(server_name)
                end,

                ["lua_ls"] = function()
                    vim.lsp.config('luals', {
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
                    })
                    vim.lsp.enable('luals')
                end,

                ["clangd"] = function()
                    vim.lsp.config('clangd', {
                        capabilities = capabilities,
                        cmd = {
                            "clangd",
                            "--fallback-style=Webkit",
                            "--background-index", "--suggest-missing-includes",
                            "--all-scopes-completion", "--completion-style=detailed",
                            "--offset-encoding=utf-16",
                        }
                    })
                    vim.lsp.enable('clangd')
                end,

                ["pyright"] = function()
                    vim.lsp.config('pyright', {
                        capabilities = capabilities,
                        settings = {
                            python = {
                                analysis = {
                                    autoSearchPaths = true,
                                    diagnosticMode = "openFilesOnly",
                                    useLibraryCodeForTypes = true,
                                    autoImportCompletions = true
                                }
                            }
                        }
                    })

                    vim.lsp.enable('pyright')
                end,

                ["ruff"] = function()
                    vim.lsp.config('ruff', {
                        capabilities = capabilities,
                        settings = {
                            lint = {
                                -- https://docs.astral.sh/ruff/rules/#pydocstyle-d
                                select = { "D" },
                                pydocstyle = {
                                    -- https://docs.astral.sh/ruff/settings/#lintpydocstyle
                                    convention = "google"
                                }
                            }
                        }
                    })

                    vim.lsp.enable('pyright')
                end,
            }
        })

        vim.lsp.config.luasnip = {
            history = true,
            updateevents = "TextChanged,TextChangedI",
            enable_autosnippets = true,
            use_show_condition = false
        }

        require("luasnip.loaders.from_vscode").lazy_load()

        -- local cmp_select = { behavior = cmp.SelectBehavior.Select }
        vim.lsp.config('cmp', {
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
