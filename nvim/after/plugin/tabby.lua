local mocha = require("catppuccin.palettes").get_palette("frappe")
local tabby = require("tabby.tabline")

require("tabby.tabline").use_preset("tab_only", {
  theme = {
    --   fill = "TabLineFill",     -- tabline background
    --   head = "TabLine",         -- head element highlight
    current_tab = { fg = mocha.lavender, bg = mocha.base, style = "bold" },
    --   tab = "TabLine",          -- other tab label highlight
    --   win = "TabLine",          -- window highlight
    --   tail = "TabLine",         -- tail element highlight
  },
  -- nerdfont = true,            -- whether use nerdfont
  -- tab_name = {
  --   name_fallback = "function({tabid}), return a string",
  -- },
  -- buf_name = {
  --   mode = "'unique'|'relative'|'tail'|'shorten'",
  -- },
})
