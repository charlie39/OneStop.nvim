local M = {}

M.defaults = {

  terminal = { 'st','-e'},

  layout = {
    style = 'minimal',
    relative = 'editor',
    height = math.ceil(40),
    width = math.ceil(140),
    row = math.ceil((vim.api.nvim_get_option("lines") - 40) / 2 - 1),
    col = math.ceil((vim.api.nvim_get_option("columns") - 140) / 2),
    -- border = 'single',
    border = { "┏", "─", "┓", "│", "┛", "─", "┗", "│" }
  },

  maps = {
    ['<M-I>'] = 'toggle_float',
  },

  lscmds = {
    ['jdt.ls'] = {
      "mvn spring-boot:run",
      "mvn package",
      "mvn compile",
      "mvn build",
      "mvn dependency:resolves -Dclassifier=javadoc",
      "mvn dependency:sources",
      "java -jar",
    },
    clangd = {
      "make",
      "sudo make clean install",
      "cmake",
      "cc",
    },
    rust_analyzer = {
      "cargo run",
      "cargo build",
    },
    sumneko_lua = {
      "lua",
    }
  }
}

function M.osrunner(opts)
  local terminal = M.defaults.terminal
  local clients = {}
  clients = vim.lsp.buf_get_clients()
  if next(clients) then
    for _, client in pairs(clients) do
      local filetype = {}
      if type(client.config.filetypes) == 'table' then
        for _, client_filetype in pairs(client.config.filetypes) do
          if client_filetype == vim.bo.filetype then
            filetype = vim.bo.filetype
            break
          end
        end
      elseif type(client.config.filetypes) == 'string' then
        if client.config.filetypes == vim.bo.filetype then
          filetype = vim.bo.filetype
          break
        end
      else
        filetype = vim.bo.filetype
      end
      if type(M.defaults.lscmds[client.config.name]) == 'table' and filetype ~= {} then
        local root_dir = client.config.root_dir
        local cmds = {}
        cmds = M.defaults.lscmds[client.config.name]
        vim.ui.select(cmds, { prompt = "Select command to run:" }, function(input)
          vim.fn.chdir(root_dir)
          if input == "java -jar" then
            if vim.fn.executable(terminal[1]) then
              require 'onestop.jarfile'.run_jar_file(root_dir, terminal)
              return
            end
            vim.notofy("[OneStop] set terminal to run jar files")
            return
          end
          local sp = vim.regex('sp\\(lit\\)\\?')
          local vs = vim.regex('vs\\(plit\\)\\?')
          local ext = vim.regex('ext\\(ertnal\\)\\?')
          local fl = vim.regex('fl\\(oat\\)\\?')

          -- vim.notify("opt.args passed: " .. opts.args)
          vim.notify("type(opts.args) : " .. type(opts.args))
          if sp:match_str(opts.args) then
            vim.fn.execute('split | term ' .. input)
          elseif vs:match_str(opts.args) then
            vim.fn.execute('vsplit | term ' .. input)
          elseif fl:match_str(opts.args) then
            require 'onestop.window'.float(input, root_dir)
          elseif ext:match_str(opts.args) or opts.args == '' then
            if not vim.fn.executable(terminal[1]) then
              vim.notify("[OneStop] you need to set the terminal option to run in a terminal")
              return
            end
            vim.fn.jobstart(terminal[1] .. ' ' .. terminal[2] .. ' sh -c "' .. input .. ' ;read"',
              { detach = true })
          else
            vim.notify("[OneStop] Not a proper option, press <TAB> for the list of options")
          end
        end)
      else
        vim.notify("[OneStop] No command registered for " .. client.config.name)
      end
    end
  else
    vim.notify("[OneStop] currently only works when LSP client is attached")
  end
end

local function extend_opts(opts)
  opts = opts or {}
  if next(opts) == nil then
    return
  end
  for k, v in pairs(opts) do
    if M.defaults[k] == nil then
      vim.notify(string.format('[OneStop] Not a valid key: %s', k))
    else
      if k == 'layout' then
        if type(v) ~= nil then
          M.defaults.layout = vim.tbl_extend('force', M.defaults.layout, v)
        end
      elseif k == 'lscmds' then
        if next(v) ~= nil then
          M.defaults.lscmds = vim.tbl_deep_extend('force', M.defaults.lscmds, v)
        end
      else
        M.defaults[k] = v
      end
    end
  end
end

function M.setup(opts)

  extend_opts(opts)

  for k, v in pairs(M.defaults.maps) do
    vim.keymap.set('n', k, '<cmd>lua require"onestop.window".' .. v .. '()<cr>', { noremap = true, silent = true })
  end

  vim.api.nvim_create_user_command("OSRunner", function(o) M.osrunner(o) end,
    { nargs = '?', complete = function() return { 'vsplit', 'split', 'float', 'external' } end })

end

return M
