local nvim_tmux_nav = require('nvim-tmux-navigation')
vim.g.Netrw_UserMaps = [["<C-l>","MoveCursorToWindowOnTheRight"]]
MoveCursorToWindowOnTheRight = function()
    nvim_tmux_nav.NvimTmuxNavigateRight()
end
