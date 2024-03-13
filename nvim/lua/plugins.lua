return {
   {
      "folke/tokyonight.nvim",
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other start plugins
      config = function()
         -- load the colorscheme here
         vim.cmd([[colorscheme tokyonight]])
      end,
   },

   -- Language Server config.
   {
      "neovim/nvim-lspconfig",
      dependencies = { "aerial.nvim", "coq_nvim" },
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

         if vim.fn.executable("gopls") ~= 0 then
            print("LspSetup: setting up for gopls")
            lspconfig.gopls.setup(opts)
         end

         if vim.fn.executable("tsserver") ~= 0 then
            print("LspSetup: setting up for tsserver")
            lspconfig.tsserver.setup(opts)
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
   },

   -- Completion plugin.
   {
      "ms-jpq/coq_nvim",
      branch = "coq",
      init = function()
         -- coq settings. This has to precede require('coq').
         vim.g.coq_settings = {
            ["auto_start"] = true,
            ["keymap.manual_complete"] = "<C-C>",
            ["xdg"] = true,
         }
      end,
   },

   -- Bundled data for coq_nvim.
   {
      "ms-jpq/coq.artifacts",
      branch = "artifacts",
   },

   -- Outline viewer.
   {
      "stevearc/aerial.nvim",
      config = function()
         vim.keymap.set("n", "<Leader>go", ":AerialToggle left<CR>", { silent = true })

         require("aerial").setup()
      end,
   },

   -- Lua library for nvim.
   { "nvim-lua/plenary.nvim" },
   -- Github copilot.
   {
      "github/copilot.vim",
      config = function()
         vim.keymap.set(
            "i",
            "<C-J>",
            "copilot#Accept('<CR>')",
            { silent = true, noremap = true, expr = true, replace_keycodes = false }
         )
         vim.g.copilot_no_tab_map = true
         vim.g.copilot_filetypes = { python = true }
      end,
   },
   -- A plugin for fancy fonts.
   { "ryanoasis/vim-devicons" },

   { "nvim-tree/nvim-web-devicons", lazy = true },

   -- A fuzzy finder.
   {
      "nvim-telescope/telescope.nvim",
      init = function()
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
               file_ignore_patterns = { "^.git/" },
            },
         })
      end,
   },

   -- An extension of Telescope.
   {
      "nvim-telescope/telescope-file-browser.nvim",
      requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
      dependencies = { "telescope.nvim" },
      config = function()
         require("telescope").load_extension("file_browser")
         vim.api.nvim_set_keymap(
            "n",
            "<Leader>fe",
            ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
            { noremap = true, silent = true }
         )
      end,
   },

   -- Handles extra whitespaces.
   {
      "ntpeters/vim-better-whitespace",
      init = function()
         -- Remove trailing spaces on save.
         vim.api.nvim_create_autocmd("BufWrite", {
            pattern = { "*" },
            command = ":StripWhitespace",
         })
      end,
   },

   -- EditorConfig plugin.
   { "editorconfig/editorconfig-vim" },

   -- Better '.' command.
   { "tpope/vim-repeat" },

   -- A comment-out plugin.
   { "tpope/vim-commentary" },

   -- Highlights a word under the cursor.
   { "RRethy/vim-illuminate" },

   -- Better word object handling.
   {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      config = function()
         require("nvim-surround").setup()
      end,
   },

   -- A prettier git-diff.
   {
      "sindrets/diffview.nvim",
      init = function()
         vim.keymap.set("n", "<Leader>da", ":DiffviewOpen<CR>", { silent = true })
         vim.keymap.set("n", "<Leader>dr", ":DiffviewRefresh<CR>", { silent = true })
         vim.keymap.set("n", "<Leader>dd", ":DiffviewFileHistory %<CR>", { silent = true })
      end,
   },

   -- A Git extension.
   {
      "NeogitOrg/neogit",
      dependencies = { "nvim-lua/plenary.nvim" },
      init = function()
         vim.keymap.set("n", "<Leader>ng", ":Neogit<CR>", { silent = true })
      end,
      config = function()
         require("neogit").setup({})
      end,
   },

   -- An extension for Git diff and operations.
   -- This shows git-diff on the screen gutter area, previews hunks, deleted lines, and blames.
   {
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
   },

   -- Opens the repository page in a web browser.
   { "almo7aya/openingh.nvim" },

   -- A better spell checker.
   {
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
            "datetime",
            "deduplicate",
            "estie",
            "fuga",
            "hoge",
            "jupyter",
            "okta",
            "piyo",
            "terraform",
            "unmarshal",
            "quickfix",
            "usecase",
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
   },

   -- from LazyVim
   -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/treesitter.lua

   -- Treesitter is a new parser generator tool that we can
   -- use in Neovim to power faster and more accurate
   -- syntax highlighting.
   {
      "nvim-treesitter/nvim-treesitter",
      version = false, -- last release is way too old and doesn't work on Windows
      build = ":TSUpdate",
      event = { "BufReadPost", "BufNewFile", "BufWritePre" },
      init = function(plugin)
         -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
         -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
         -- no longer trigger the **nvim-treesitter** module to be loaded in time.
         -- Luckily, the only things that those plugins need are the custom queries, which we make available
         -- during startup.
         require("lazy.core.loader").add_to_rtp(plugin)
         require("nvim-treesitter.query_predicates")
      end,
      dependencies = {
         {
            "nvim-treesitter/nvim-treesitter-textobjects",
            config = function()
               -- When in diff mode, we want to use the default
               -- vim text objects c & C instead of the treesitter ones.
               local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
               local configs = require("nvim-treesitter.configs")
               for name, fn in pairs(move) do
                  if name:find("goto") == 1 then
                     move[name] = function(q, ...)
                        if vim.wo.diff then
                           local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                           for key, query in pairs(config or {}) do
                              if q == query and key:find("[%]%[][cC]") then
                                 vim.cmd("normal! " .. key)
                                 return
                              end
                           end
                        end
                        return fn(q, ...)
                     end
                  end
               end
            end,
         },
      },
      cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
      keys = {
         { "<c-space>", desc = "Increment selection" },
         { "<bs>", desc = "Decrement selection", mode = "x" },
      },
      ---@type TSConfig
      ---@diagnostic disable-next-line: missing-fields
      opts = {
         highlight = { enable = true },
         indent = { enable = true },
         ensure_installed = {
            "bash",
            "c",
            "diff",
            "html",
            "javascript",
            "jsdoc",
            "json",
            "jsonc",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "regex",
            "rust",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "xml",
            "yaml",
         },
         incremental_selection = {
            enable = true,
            keymaps = {
               init_selection = "<C-space>",
               node_incremental = "<C-space>",
               scope_incremental = false,
               node_decremental = "<bs>",
            },
         },
         textobjects = {
            move = {
               enable = true,
               goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
               goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
               goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
               goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
            },
         },
      },
      ---@param opts TSConfig
      config = function(_, opts)
         if type(opts.ensure_installed) == "table" then
            ---@type table<string, boolean>
            local added = {}
            opts.ensure_installed = vim.tbl_filter(function(lang)
               if added[lang] then
                  return false
               end
               added[lang] = true
               return true
            end, opts.ensure_installed)
         end
         require("nvim-treesitter.configs").setup(opts)
      end,
   },

   -- Show context of the current function
   {
      "nvim-treesitter/nvim-treesitter-context",
      event = { "BufReadPost", "BufNewFile", "BufWritePre" },
      enabled = true,
      opts = { mode = "cursor", max_lines = 3 },
      keys = {
         {
            "<leader>ut",
            function()
               local tsc = require("treesitter-context")
               tsc.toggle()
            end,
            desc = "Toggle Treesitter Context",
         },
      },
   },

   -- Automatically add closing tags for HTML and JSX
   {
      "windwp/nvim-ts-autotag",
      event = { "BufReadPost", "BufNewFile", "BufWritePre" },
      opts = {},
   },
}
