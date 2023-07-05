local ensure_packer = function()
   local fn = vim.fn
   local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
   if fn.empty(fn.glob(install_path)) > 0 then
      fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
      vim.cmd([[packadd packer.nvim]])
      return true
   end
   return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup({
   function(use)
      use("wbthomason/packer.nvim")

      -- Lua library for nvim.
      use("nvim-lua/plenary.nvim")

      -- Language Server config.
      use({
         "neovim/nvim-lspconfig",
         after = { "aerial.nvim", "coq_nvim" },
         config = function()
            local lspconfig = require("lspconfig")

            local opts = {
               on_attach = function(ev)
                  local bufnr = ev.buf

                  vim.keymap.set("n", "<Leader>gd", vim.lsp.buf.definition, { buffer = bufnr, silent = true })
                  vim.keymap.set(
                     "n",
                     "<Leader>gD",
                     ":tab split | lua vim.lsp.buf.definition()<CR>",
                     { buffer = bufnr, silent = true }
                  )
                  vim.keymap.set("n", "<Leader>gh", vim.lsp.buf.hover, { buffer = bufnr, silent = true })
                  vim.keymap.set("n", "<Leader>gi", vim.lsp.buf.implementation, { buffer = bufnr, silent = true })
                  vim.keymap.set("n", "<Leader>gH", vim.lsp.buf.signature_help, { buffer = bufnr, silent = true })
                  vim.keymap.set("n", "<Leader>gt", vim.lsp.buf.type_definition, { buffer = bufnr, silent = true })
                  vim.keymap.set("n", "<Leader>gr", vim.lsp.buf.references, { buffer = bufnr, silent = true })
                  vim.keymap.set("n", "<Leader>gR", vim.lsp.buf.rename, { buffer = bufnr, silent = true })
                  vim.keymap.set("n", "<Leader>ge", vim.diagnostic.open_float, { buffer = bufnr, silent = true })
                  vim.keymap.set("n", "<Leader>gq", vim.diagnostic.setloclist, { buffer = bufnr, silent = true })
               end,
               flags = {
                  debounce_text_changes = 150,
               },
            }

            -- coq settings. This has to precede require('coq').
            vim.g.coq_settings = {
               ["auto_start"] = true,
               ["keymap.manual_complete"] = "<Leader>.",
               ["xdg"] = true,
            }

            -- Update opts if coq is available.
            local ok, coq = pcall(require, "coq")
            if not ok then
               print("LspSetup: coq not found")
            else
               print("LspSetup: coq found. use its functionality")
               opts = coq.lsp_ensure_capabilities(opts)
            end

            -- Setup LSP servers.
            --
            if vim.fn.executable("terraform-ls") ~= 0 then
               print("LspSetup: setting up for terraform-ls")
               lspconfig.terraformls.setup(opts)
            end

            if vim.fn.executable("rust-analyzer") ~= 0 then
               print("LspSetup: setting up for rust-analyzer")
               lspconfig.rust_analyzer.setup(opts)
            end

            if vim.fn.executable("solargraph") ~= 0 then
               print("LspSetup: setting up for solargraph")
               lspconfig.solargraph.setup(opts)
            end

            if vim.fn.executable("pyright") ~= 0 then
               print("LspSetup: setting up for pyright")
               local pythonPath = vim.fn.system("which python")
               opts["python"] = {
                  pythonPath = pythonPath,
               }
               lspconfig.pyright.setup(opts)
            end

            if vim.fn.executable("lua-language-server") ~= 0 then
               print("LspSetup: setting up for lua-language-server")
               opts["settings"] = {
                  Lua = {
                     runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = "LuaJIT",
                     },
                     diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = { "vim" },
                     },
                     workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                        -- https://github.com/neovim/nvim-lspconfig/issues/1700
                        checkThirdParty = false,
                     },
                     -- Do not send telemetry data containing a randomized but unique identifier
                     telemetry = {
                        enable = false,
                     },
                  },
               }
               lspconfig.lua_ls.setup(opts)
            end
         end,
      })

      -- Completion plugin.
      use({
         "ms-jpq/coq_nvim",
         branch = "coq",
      })

      -- Bundled data for coq_nvim.
      use({
         "ms-jpq/coq.artifacts",
         branch = "artifacts",
      })

      -- Outline viewer.
      use({
         "stevearc/aerial.nvim",
         config = function()
            vim.keymap.set("n", "<Leader>go", ":AerialToggle left<CR>", { silent = true })

            require("aerial").setup()
         end,
      })

      -- A fuzzy finder.
      use({
         "nvim-telescope/telescope.nvim",
         setup = function()
            vim.keymap.set("n", "<Leader>ff", ":Telescope find_files hidden=true<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>fm", ":Telescope marks<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>fr", ":Telescope live_grep<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>fb", ":Telescope buffers<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>fh", ":Telescope help_tags<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>fk", ":Telescope keymaps<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>fo", ":Telescope vim_options<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>fgd", ":Telescope git_bcommits<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>fgb", ":Telescope git_branches<CR>", { silent = true })
         end,
         config = function()
            require("telescope").setup({
               defaults = {
                  file_ignore_patterns = { ".git/*" },
               },
            })
         end,
      })

      -- An extension of Telescope.
      use({
         "nvim-telescope/telescope-file-browser.nvim",
         requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
         after = "telescope.nvim",
         config = function()
            require("telescope").load_extension("file_browser")
            vim.api.nvim_set_keymap(
               "n",
               "<Leader>fe",
               ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
               { noremap = true, silent = true }
            )
         end,
      })

      -- A colorscheme.
      use({
         "sainnhe/gruvbox-material",
      })

      -- A colorscheme.
      use({
         "EdenEast/nightfox.nvim",

         config = function()
            vim.cmd([[colorscheme nordfox]])
         end,
      })

      -- A better syntax highlighter.
      use({
         "nvim-treesitter/nvim-treesitter",
         run = ":TSUpdate",
      })

      -- Handles extra whitespaces.
      use({
         "ntpeters/vim-better-whitespace",
         setup = function()
            -- Remove trailing spaces on save.
            vim.api.nvim_create_autocmd("BufWrite", {
               pattern = { "*" },
               command = ":StripWhitespace",
            })
         end,
      })

      -- EditorConfig plugin.
      use("editorconfig/editorconfig-vim")

      -- Better '.' command.
      use("tpope/vim-repeat")

      -- A comment-out plugin.
      use("tpope/vim-commentary")

      -- Highlights a word under the cursor.
      use("RRethy/vim-illuminate")

      -- Better word object handling.
      use({
         "kylechui/nvim-surround",
         tag = "*", -- Use for stability; omit to use `main` branch for the latest features
         config = function()
            require("nvim-surround").setup()
         end,
      })

      -- A pretty list of diagnostics, quickfix list, LSP references, etc.
      use({
         "folke/trouble.nvim",
         setup = function()
            vim.keymap.set("n", "<Leader>xx", ":TroubleToggle<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>xw", ":TroubleToggle workspace_diagnostics<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>xd", ":TroubleToggle document_diagnostics<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>xl", ":TroubleToggle loclist<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>xq", ":TroubleToggle quickfix<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>xr", ":TroubleToggle lsp_references<CR>", { silent = true })
         end,
      })

      -- A prettier git-diff.
      use({
         "sindrets/diffview.nvim",
         setup = function()
            vim.keymap.set("n", "<Leader>da", ":DiffviewOpen<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>dr", ":DiffviewRefresh<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>dd", ":DiffviewFileHistory %<CR>", { silent = true })
         end,
      })

      -- A Git extension.
      use({
         "NeogitOrg/neogit",
         requires = "nvim-lua/plenary.nvim",
         setup = function()
            vim.keymap.set("n", "<Leader>ng", ":Neogit<CR>", { silent = true })
         end,
      })

      -- A markdown reader extension.
      use({
         "ellisonleao/glow.nvim",
         config = function()
            require("glow").setup()
         end,
      })

      -- Opens the repository page in a web browser.
      use({
         "almo7aya/openingh.nvim",
         setup = function()
            vim.keymap.set("n", "<Leader>no", ":OpenInGHFileLines<CR>")
         end,
      })

      -- An extension for Git diff and operations.
      -- This shows git-diff on the screen gutter area, previews hunks, deleted lines, and blames.
      use({
         "lewis6991/gitsigns.nvim",
         config = function()
            require("gitsigns").setup({
               current_line_blame = true,
               on_attach = function(bufnr)
                  local gitsigns = package.loaded.gitsigns

                  -- Navigation
                  vim.keymap.set("n", "]c", function()
                     if vim.wo.diff then
                        return "]c"
                     end
                     vim.schedule(function()
                        gitsigns.next_hunk()
                     end)
                     return "<Ignore>"
                  end, { expr = true, buffer = bufnr, silent = true })

                  vim.keymap.set("n", "[c", function()
                     if vim.wo.diff then
                        return "[c"
                     end
                     vim.schedule(function()
                        gitsigns.prev_hunk()
                     end)
                     return "<Ignore>"
                  end, { expr = true, buffer = bufnr, silent = true })

                  vim.keymap.set("n", "<Leader>np", gitsigns.preview_hunk, { buffer = bufnr, silent = true })
                  vim.keymap.set("n", "<Leader>nd", gitsigns.toggle_deleted, { buffer = bufnr, silent = true })

                  vim.keymap.set("n", "<Leader>nb", function()
                     gitsigns.blame_line({ full = true })
                  end, { buffer = bufnr, silent = true })

                  vim.keymap.set("n", "<Leader>xh", function()
                     gitsigns.setqflist("all")
                  end, { expr = true, buffer = bufnr, silent = true })
               end,
            })
         end,
      })

      -- A better spell checker.
      use({
         "kamykn/spelunker.vim",
         config = function()
            vim.opt.spell = false
            vim.g.spelunker_check_type = 2 -- Real time spell checking.
            vim.g.spelunker_disable_uri_checking = 1
            vim.g.spelunker_disable_email_checking = 1
            vim.g.spelunker_disable_acronym_checking = 1
            vim.g.spelunker_disable_backquoted_checking = 1
            vim.g.spelunker_white_list_for_user = {
               "args",
               "augroup",
               "autocmd",
               "backend",
               "colorscheme",
               "coord",
               "estie",
               "fuga",
               "hoge",
               "okta",
               "piyo",
               "terraform",
               "unmarshal",
               "quickfix",
            }

            -- After enabling a colorscheme these highlight groups are cleared.
            -- This augroup explicitly enables highlight groups.
            vim.cmd([[
               augroup spelunker-colorscheme
                  autocmd ColorScheme *
                  \ highlight SpelunkerSpellBad cterm=underline ctermfg=247 gui=underline guifg=#9e9e9e |
                  \ highlight SpelunkerComplexOrCompoundWord cterm=underline ctermfg=NONE gui=underline guifg=NONE
               augroup END
            ]])
         end,
      })

      -- Python black support.
      use({
         "psf/black",
         branch = "stable",
         ft = "python",
      })

      -- Automatically set up your configuration after cloning packer.nvim
      -- Put this at the end after all plugins
      if packer_bootstrap then
         require("packer").sync()
      end
   end,
   config = {
      display = {
         open_fn = function()
            return require("packer.util").float({ border = "single" })
         end,
      },
   },
})
