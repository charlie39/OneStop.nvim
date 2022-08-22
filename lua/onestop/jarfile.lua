--if jar file
local M = {}

function M.run_jar_file(root_dir, terminal)
  local jars = {}
  jars = vim.split(vim.fn.glob(root_dir .. '/target/*.jar'), '\n')
  if next(jars) == nil then
    vim.ui.input({ prompt = "Enter jar file path: ", completion = "file" }, function(path)
      vim.fn.jobstart(terminal[1] .. ' ' .. terminal[2] .. ' sh -c "java -jar ' .. path .. ';read"',
        { detach = true })
    end)
  else
    vim.ui.select(jars, { prompt = "Select jar file: " }, function(jar)
      vim.fn.jobstart(terminal[1] .. ' ' .. terminal[2] .. ' sh -c "java -jar ' .. jar .. ';read"',
        { detach = true })
    end)
  end
end

return M
