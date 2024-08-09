return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    lazy = false,
    opts = {
        fast_wrap = {
            map = '<M-e>',
            chars = { '{', '[', '(', '"', "'" },
            pattern = [=[[%'%"%>%]%)%}%,]]=],
            end_key = '$',
            before_key = 'h',
            after_key = 'l',
            cursor_pos_before = true,
            keys = 'qwertyuiopzxcvbnmasdfghjkl',
            manual_position = true,
            highlight = 'Search',
            highlight_grey = 'Comment'
        },

        enable_check_bracket_line = false,

        check_ts = true,
        ts_config = {
            lua = { 'string' },     -- it will not add a pair on that treesitter node
            javascript = { 'template_string' },
            java = false,           -- don't check treesitter on java
        },
    },

    config = function()
        require('nvim-autopairs').setup({})
        local Rule = require('nvim-autopairs.rule')
        local npairs = require('nvim-autopairs')

        -- you can use some built-in conditions

        local cond = require('nvim-autopairs.conds')

        npairs.add_rules({
                Rule("$", "$", { "tex", "latex" })
                    :with_move(cond.move_right)
                -- don't add a pair if the next character is %
                -- :with_pair(cond.not_after_regex("%%"))
                -- don't add a pair if  the previous character is xxx
                -- :with_pair(cond.not_before_regex("xxx", 3))
                -- don't move right when repeat character
                -- :with_move(cond.none())
                -- don't delete if the next character is xx
                -- :with_del(cond.not_after_regex("xx"))
                -- disable adding a newline when you press <cr>
                    :with_cr(cond.none())
            }
        )

        -- npairs.add_rules({
        --     -- one $ is already added by previous rule
        --     Rule("$$", "$", "tex")
        --     :with_move(cond.move_right)
        -- })

        local ts_conds = require('nvim-autopairs.ts-conds')

        -- press % => %% only while inside a comment or string
        npairs.add_rules({
            Rule("%", "%", "lua")
                :with_pair(ts_conds.is_ts_node({ 'string', 'comment' })),
            Rule("$", "$", "lua")
                :with_pair(ts_conds.is_not_ts_node({ 'function' }))
        })
    end
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
}
