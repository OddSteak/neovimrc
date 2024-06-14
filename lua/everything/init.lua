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
        -- local opts = { buffer = e.buf }
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = e.buf, desc = 'LSP: ' .. desc })
        end
        map("<leader>vd", function() vim.diagnostic.open_float() end, 'open diagnostic float')
        map('gd', function() require('telescope.builtin').lsp_definitions({jump_type="vsplit"}) end, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map("[d", function() vim.diagnostic.goto_next() end, 'next error')
        map("]d", function() vim.diagnostic.goto_prev() end, 'prev error')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
