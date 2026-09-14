local util = {}

local function mapfn(mode)
  return function(lhs, rhs, opts)
    opts = vim.tbl_extend("force", { silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

util.map = mapfn({ "n", "v", "o" })
util.imap = mapfn("i")
util.nmap = mapfn("n")
util.vmap = mapfn("v")

return util
