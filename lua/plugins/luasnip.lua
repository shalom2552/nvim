return {
  "L3MON4D3/LuaSnip",
  opts = function(_, opts)
    -- Exit snippet session if you move the cursor outside the snippet region
    opts.region_check_events = "InsertEnter"
    opts.delete_check_events = "TextChanged"
  end,
}
