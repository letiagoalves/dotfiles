return
{
    "ggandor/leap.nvim",
    config = function()
        for _, _4_ in ipairs({ { "n", "s", "<Plug>(leap-forward)" }, { "n", "S", "<Plug>(leap-backward)" },
            { "x", "s", "<Plug>(leap-forward)" }, { "x", "S", "<Plug>(leap-backward)" },
            { "o", "z", "<Plug>(leap-forward)" }, { "o", "Z", "<Plug>(leap-backward)" },
            { "o", "x", "<Plug>(leap-forward-x)" }, { "o", "X", "<Plug>(leap-backward-x)" } -- { "n", "gs", "<Plug>(leap-cross-window)" },
            -- { "x", "gs", "<Plug>(leap-cross-window)" },
            -- { "o", "gs", "<Plug>(leap-cross-window)" },
        }) do
            local _each_5_ = _4_
            local mode = _each_5_[1]
            local lhs = _each_5_[2]
            local rhs = _each_5_[3]
            if force_3f or ((vim.fn.mapcheck(lhs, mode) == "") and (vim.fn.hasmapto(rhs, mode) == 0)) then
                vim.keymap.set(mode, lhs, rhs, {
                    silent = true
                })
            else
            end
        end
        -- require("leap").set_default_keymaps()
    end
}
