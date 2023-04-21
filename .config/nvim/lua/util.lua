local util = {}

local function mapfn(type)
  return function(key, cmd)
    vim.api.nvim_set_keymap(type, key, cmd, { noremap = false, silent = true })
  end
end

util.map = mapfn('')
util.imap = mapfn('i')
util.nmap = mapfn('n')
util.vmap = mapfn('v')

return util
