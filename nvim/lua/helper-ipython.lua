local M = {}

-- Detects the start and end lines of the current IPython cell.
function M.detect_cell_range()
   local cur = vim.fn.line(".")
   local last = vim.fn.line("$")

   -- Find the start of the cell by searching upwards for # %%
   local start = cur
   for l = cur, 1, -1 do
      local line = vim.fn.getline(l)
      if line:match("^%s*# %%%%") and l ~= cur then
         start = l + 1
         break
      elseif l == 1 then
         start = 1
      end
   end

   -- Find the end of the cell by searching downwards for # %%
   local finish = cur
   for l = cur + 1, last do
      local line = vim.fn.getline(l)
      if line:match("^%s*# %%%%") then
         finish = l - 1
         break
      elseif l == last then
         finish = last
      end
   end

   return start, finish
end

return M
