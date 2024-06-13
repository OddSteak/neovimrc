return {
    'alexghergh/nvim-tmux-navigation',

    config = function()
        local nvim_tmux_nav = require('nvim-tmux-navigation')

        nvim_tmux_nav.setup({
            disable_when_zoomed = true -- defaults to false
        })

        -- vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
        -- vim.keymap.set('n', "<A-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
        -- vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
        -- vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
        -- vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
        -- vim.keymap.set('n', "<A-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)

        vim.g.Netrw_UserMaps = [["<C-l>","MoveCursorToWindowOnTheRight"]]
        MoveCursorToWindowOnTheRight = function()
            nvim_tmux_nav.NvimTmuxNavigateRight()
        end
    end
}