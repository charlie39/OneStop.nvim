
local buf = -1
local winid = -1

local layout = {}
layout = require 'onestop'.defaults.layout
local h = layout.height
local w = layout.width

local M = {}


function M.float(input, root_dir)

  layout.row = math.ceil((vim.api.nvim_get_option("lines") - h)/2 - 1)
  layout.col = math.ceil((vim.api.nvim_get_option("columns") - w)/2)

  buf = vim.api.nvim_create_buf(false, false)

  vim.api.nvim_buf_set_option(buf, "filetype", "Floaterm")
  vim.api.nvim_buf_set_option(buf, "modifiable", true)

  winid = vim.api.nvim_open_win(buf, true,layout)
  local cmd = vim.env.SHELL .. ' -c "cd  ' .. root_dir .. '; ' .. input .. '"'
  vim.fn.termopen(cmd)

end

function M.toggle_float()
  if buf ~= -1 then
    if winid ~= -1 then
      if vim.api.nvim_win_is_valid(winid) then
        if vim.api.nvim_get_current_win() == winid then
          vim.api.nvim_win_close(winid, 0)
        else
          vim.api.nvim_set_current_win(winid)
        end
      elseif vim.api.nvim_buf_is_valid(buf) then
        winid = vim.api.nvim_open_win(buf, true, layout)
      else
        vim.notify("re-run the command")
      end
    else
      winid = vim.api.nvim_open_win(buf, true, layout)
    end
  end
end

return M
