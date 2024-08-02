require("everything.set")
require("everything.remap")

require("everything.lazy_init")


local augroup = vim.api.nvim_create_augroup
local EveryGroup = augroup('everyGroup', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

-- reload modules
function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

vim.filetype.add({
    pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

-- highlight yanked text
autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

-- remove trailing spaces
autocmd({ "BufWritePre" }, {
    group = EveryGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
    group = EveryGroup,
    callback = function(e)
        -- don't use lsp for these units
        -- local blackcwd = "/home/dell/uwa/sem2_2024/cits2002/src"
        -- local blackcwd2 = "/home/dell/uwa/sem2_2024/cits2211/src"
        -- if vim.fn.getcwd() == blackcwd or vim.fn.getcwd() == blackcwd2 then
        --     vim.cmd("LspStop")
        -- end

        local opts = { buffer = e.buf }
        local dap = require('dap')
        local dapui = require('dapui')
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = e.buf, desc = 'LSP: ' .. desc })
        end
        map("<leader>vd", function() vim.diagnostic.open_float() end, 'open diagnostic float')
        map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map("[d", function() vim.diagnostic.goto_next() end, 'next error')
        map("]d", function() vim.diagnostic.goto_prev() end, 'prev error')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', vim.lsp.buf.document_symbol, '[D]ocument [S]ymbols')
        map('<leader>ws', vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<leader>tb', dap.toggle_breakpoint, 'Toggle Breakpoint')
        map('<leader>ct', dapui.toggle, 'dap Continue')
        map('<leader>so', dap.step_over, 'dap step over')
        map('<leader>si', dap.step_into, 'dap step into')
        map('<leader>ro', dap.repl.open, 'dap repl open')
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end
})

-- Hyprlang LSP
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    pattern = { "*.hl", "hypr*.conf" },
    callback = function(event)
        vim.lsp.start {
            name = "hyprlang",
            cmd = { "/home/dell/go/bin/hyprls" },
            root_dir = vim.fn.getcwd(),
        }
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
    end,
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
