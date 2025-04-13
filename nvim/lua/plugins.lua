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

   {
      "keaising/im-select.nvim",
      config = function()
         require("im_select").setup({
            default_im_select = "com.apple.keylayout.ABC",
         })
      end,
   },

   -- Lua library for nvim.
   { "nvim-lua/plenary.nvim" },

   -- A plugin for fancy fonts.
   { "nvim-tree/nvim-web-devicons", default = true },

   -- Language Server config.
   {
      "neovim/nvim-lspconfig",
      dependencies = {
         "aerial.nvim",
         "mrcjkb/rustaceanvim",
      },
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

         -- Update opts if nvim-cmp is available.
         local ok, nvim_lsp = pcall(require, "cmp_nvim_lsp")
         if not ok then
            print("LspSetup: nvim-cmp not found")
         else
            opts["capabilities"] = nvim_lsp.default_capabilities()
         end

         -- Setup LSP servers.
         --
         if vim.fn.executable("terraform-ls") ~= 0 then
            lspconfig.terraformls.setup(opts)
         end

         if vim.fn.executable("solargraph") ~= 0 then
            lspconfig.solargraph.setup(opts)
         end

         if vim.fn.executable("pyright") ~= 0 then
            local pythonPath = vim.fn.system("which python")
            opts["python"] = {
               pythonPath = pythonPath,
            }
            lspconfig.pyright.setup(opts)
         end

         if vim.fn.executable("gopls") ~= 0 then
            lspconfig.gopls.setup(opts)
         end

         if vim.fn.executable("tsserver") ~= 0 then
            lspconfig.ts_ls.setup(opts)
         end

         if vim.fn.executable("lua-language-server") ~= 0 then
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

         if vim.fn.executable("rust-analyzer") ~= 0 then
            -- Here we use "rustaceanvim" plugin for rust-analyser instead of native lsp setup.
            -- This setup does not need to be done here technically,
            -- but the opts variable can be reused if we setup it here.
            local ok, rustaceanvim = pcall(require, "rustaceanvim")
            if ok then
               rustaceanvim.setup({
                  server = opts,
               })
            end
         end
      end,
   },

   ---- noice.nvim
   {
      "folke/noice.nvim",
      event = "VeryLazy",
      opts = {
         lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
               ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
               ["vim.lsp.util.stylize_markdown"] = true,
               ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            },
         },
      },
      dependencies = {
         -- "nvim-telescope/telescope.nvim",
         -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
         "MunifTanjim/nui.nvim",
         -- OPTIONAL:
         --   `nvim-notify` is only needed, if you want to use the notification view.
         --   If not available, we use `mini` as the fallback
         "rcarriga/nvim-notify",
      },
      -- config = function()
      --    require("telescope").load_extension("noice")
      -- end
   },

   {
      "hrsh7th/nvim-cmp",
      event = "VeryLazy",
      dependencies = {
         "hrsh7th/cmp-nvim-lsp",
         "hrsh7th/cmp-buffer",
         "hrsh7th/cmp-path",
         "hrsh7th/cmp-cmdline",
         "hrsh7th/cmp-calc",
         "hrsh7th/cmp-emoji",
      },
      config = function()
         local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
         end

         local cmp = require("cmp")

         cmp.setup({
            mapping = cmp.mapping.preset.insert({
               ["<C-b>"] = cmp.mapping.scroll_docs(-4),
               ["<C-f>"] = cmp.mapping.scroll_docs(4),
               ["<C-c>"] = cmp.mapping.complete(),
               ["<C-e>"] = cmp.mapping.abort(),
               ["<CR>"] = cmp.mapping.confirm({ select = true }),
               ["<Tab>"] = function(fallback)
                  if not cmp.select_next_item() then
                     if vim.bo.buftype ~= "prompt" and has_words_before() then
                        cmp.complete()
                     else
                        fallback()
                     end
                  end
               end,
               ["<S-Tab>"] = function(fallback)
                  if not cmp.select_prev_item() then
                     if vim.bo.buftype ~= "prompt" and has_words_before() then
                        cmp.complete()
                     else
                        fallback()
                     end
                  end
               end,
            }),
            sources = cmp.config.sources( -- sources
               {
                  { name = "nvim_lsp" },
               },
               {
                  { name = "buffer", keyword_length = 3 },
               },
               {
                  { name = "emoji" },
               },
               {
                  { name = "calc" },
               },
               {
                  { name = "path" },
               },
               {
                  { name = "codecompanion" },
               }
            ),
         })
         cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources( -- sources
               {
                  { name = "path" },
               },
               {
                  { name = "cmdline" },
               }
            ),
         })
         cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
               { name = "buffer" },
            },
         })
      end,
   },

   -- Outline viewer.
   {
      "stevearc/aerial.nvim",
      config = function()
         vim.keymap.set("n", "<Leader>go", ":AerialToggle left<CR>", { silent = true })

         require("aerial").setup()
      end,
   },

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

   {
      "MeanderingProgrammer/render-markdown.nvim",
      dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
      ft = { "codecompanion" },
      opts = {
         file_types = { "codecompanion" },
      },
   },

   {
      "olimorris/codecompanion.nvim",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-treesitter/nvim-treesitter",
         "banjo/contextfiles.nvim",
      },
      keys = {
         { "<Leader>aa", ":CodeCompanionChat toggle<CR>", mode = { "n", "v" }, silent = true },
         { "<Leader>ae", ":CodeCompanionAction<CR>", mode = { "n", "v" }, silent = true },
         { "<Leader>af", ":CodeCompanion<CR>", mode = { "n", "v" }, silent = true },
      },
      opts = function(_, opts)
         local base_opts = {
            adapters = {
               copilot = function()
                  return require("codecompanion.adapters").extend("copilot", {
                     schema = { model = { default = "claude-3.7-sonnet" } },
                  })
               end,
            },
            opts = {
               language = "Japanese",
            },
            display = {
               chat = {
                  auto_scroll = false,
                  show_header_separator = true,
                  -- show_settings = true,
                  window = {
                     width = 0.35,
                     position = "right",
                  },
               },
            },
            strategies = {
               chat = {
                  adapter = "copilot",
                  roles = {
                     llm = function(adapter)
                        return "  CodeCompanion (" .. adapter.formatted_name .. ")"
                     end,
                     user = "  Me",
                  },
               },
            },
         }
         local env_opts = {}

         return vim.tbl_deep_extend("force", opts, base_opts, opts)
      end,
   },

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

   {
      "LukasPietzschmann/telescope-tabs",
      config = function()
         require("telescope").load_extension("telescope-tabs")
         require("telescope-tabs").setup({
            vim.api.nvim_set_keymap(
               "n",
               "<Leader>ft",
               ":Telescope telescope-tabs list_tabs<CR>",
               { noremap = true, silent = true }
            ),
         })
      end,
      dependencies = { "nvim-telescope/telescope.nvim" },
   },

   -- Handles extra whitespaces.
   {
      "ntpeters/vim-better-whitespace",
      init = function()
         -- Remove trailing spaces on save.
         vim.api.nvim_create_autocmd("BufWrite", {
            pattern = { "*[^{md}]" },
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
         vim.keymap.set("n", "<Leader>do", ":DiffviewOpen<CR>", { silent = true })
         vim.keymap.set("n", "<Leader>dr", ":DiffviewRefresh<CR>", { silent = true })
         vim.keymap.set("n", "<Leader>df", ":DiffviewFileHistory %<CR>", { silent = true })
      end,
   },

   -- A Git extension.
   {
      "NeogitOrg/neogit",
      dependencies = { "nvim-lua/plenary.nvim" },
      init = function()
         vim.keymap.set("n", "<Leader>dd", ":Neogit<CR>", { silent = true })
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

               vim.keymap.set("n", "<Leader>dp", gitsigns.preview_hunk, { buffer = bufnr, silent = true })
               vim.keymap.set("n", "<Leader>dt", gitsigns.toggle_deleted, { buffer = bufnr, silent = true })

               vim.keymap.set("n", "<Leader>db", function()
                  gitsigns.blame_line({ full = true })
               end, { buffer = bufnr, silent = true })

               vim.keymap.set("n", "<Leader>dq", function()
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

   -- Automatically add closing tags for HTML and JSX
   {
      "windwp/nvim-ts-autotag",
      event = { "BufReadPost", "BufNewFile", "BufWritePre" },
      opts = {},
   },
}
