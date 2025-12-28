return {
   -- colorscheme.
   {
      "folke/tokyonight.nvim",
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other start plugins
      config = function()
         -- load the colorscheme here
         vim.cmd([[colorscheme tokyonight]])
      end,
   },

   -- Turns IME off when leaving Insert.
   {
      "keaising/im-select.nvim",
      config = function()
         require("im_select").setup({
            default_im_select = "com.apple.keylayout.ABC",
         })
      end,
   },

   -- Sends buffer content to console REPL.
   {
      "jpalardy/vim-slime",
      config = function()
         vim.g.slime_target = "tmux"
         vim.g.slime_python_ipython = 1
         vim.g.slime_default_config = {
            socket_name = "default",
            target_pane = "{last}",
         }
         vim.g.slime_dont_ask_default = 1

         vim.keymap.set("n", "<Leader>ip", function()
            local s, e = require("helper-ipython").detect_cell_range()
            vim.cmd(string.format("%d,%dSlimeSend", s, e))
         end)
      end,
   },

   -- Lua library for nvim.
   { "nvim-lua/plenary.nvim" },

   -- A plugin for fancy fonts.
   { "nvim-tree/nvim-web-devicons", default = true },

   -- EditorConfig plugin.
   { "editorconfig/editorconfig-vim" },

   -- A comment-out plugin.
   { "tpope/vim-commentary" },

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

   -- Highlights a word under the cursor.
   { "RRethy/vim-illuminate" },

   -- A filer.
   {
      "nvim-mini/mini.files",
      version = false,
      config = function()
         require("mini.files").setup()
      end,
      keys = {
         {
            "<Leader>b",
            ":lua require('mini.files').open(vim.fn.expand('%:p:h'))<CR>",
            desc = "Open mini.files",
            silent = true,
         },
      },
   },

   -- Diff viewer.
   {
      "nvim-mini/mini.diff",
      config = function()
         local diff = require("mini.diff")
         diff.setup({
            -- Disabled by default
            source = diff.gen_source.none(),
         })
      end,
   },

   -- Surround text objects.
   {
      "nvim-mini/mini.surround",
      config = function()
         require("mini.surround").setup()
      end,
   },

   -- Shows indent lines.
   {
      "nvim-mini/mini.indentscope",
      config = function()
         require("mini.indentscope").setup()
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
         -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
         "MunifTanjim/nui.nvim",
      },
   },

   -- Outline viewer.
   {
      "stevearc/aerial.nvim",
      config = function()
         require("aerial").setup()
      end,
      keys = {
         { "<Leader>go", ":AerialToggle left<CR>", desc = "Toggle aerial", silent = true },
      },
   },

   -- A fuzzy finder.
   {
      "nvim-telescope/telescope.nvim",
      lazy = true,
      keys = {
         { "<Leader>ff", ":Telescope find_files hidden=true<CR>", desc = "Find files", silent = true },
         { "<Leader>fm", ":Telescope marks<CR>", desc = "Marks", silent = true },
         { "<Leader>fr", ":Telescope live_grep<CR>", desc = "Live grep", silent = true },
         { "<Leader>fb", ":Telescope buffers<CR>", desc = "Buffers", silent = true },
         { "<Leader>fh", ":Telescope help_tags<CR>", desc = "Help tags", silent = true },
         { "<Leader>fk", ":Telescope keymaps<CR>", desc = "Keymaps", silent = true },
         { "<Leader>fo", ":Telescope vim_options<CR>", desc = "Vim options", silent = true },
         { "<Leader>fgd", ":Telescope git_bcommits<CR>", desc = "Git buffer commits", silent = true },
         { "<Leader>fgb", ":Telescope git_branches<CR>", desc = "Git branches", silent = true },
      },
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
      lazy = true,
      config = function()
         require("telescope").load_extension("file_browser")
      end,
      keys = {
         {
            "<Leader>fe",
            ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
            desc = "File browser",
            noremap = true,
            silent = true,
         },
      },
   },

   -- A prettier git-diff.
   {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
   },

   -- An extension for Git diff and operations.
   -- This shows git-diff on the screen gutter area, previews hunks, deleted lines, and blames.
   {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
         require("gitsigns").setup({
            current_line_blame = true,
            on_attach = function(bufnr)
               local gitsigns = package.loaded.gitsigns

               vim.keymap.set("n", "<Leader>dP", gitsigns.preview_hunk, { buffer = bufnr, silent = true })
               vim.keymap.set("n", "<Leader>dp", gitsigns.preview_hunk_inline, { buffer = bufnr, silent = true })

               vim.keymap.set("n", "<Leader>dh", gitsigns.reset_hunk, { buffer = bufnr, silent = true })
               vim.keymap.set("v", "<Leader>dh", function()
                  gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
               end, { buffer = bufnr, silent = true })

               vim.keymap.set("n", "<Leader>dt", gitsigns.toggle_deleted, { buffer = bufnr, silent = true })

               vim.keymap.set("n", "<Leader>dd", gitsigns.diffthis, { buffer = bufnr, silent = true })
               vim.keymap.set("n", "<Leader>dD", function()
                  gitsigns.diffthis("~")
               end, { buffer = bufnr, silent = true })

               vim.keymap.set("n", "<Leader>db", function()
                  gitsigns.blame_line({ full = true })
               end, { buffer = bufnr, silent = true })

               vim.keymap.set("n", "<Leader>dQ", function()
                  gitsigns.setqflist("all")
               end, { expr = true, buffer = bufnr, silent = true })
               vim.keymap.set("n", "<Leader>dq", gitsigns.setqflist, { expr = true, buffer = bufnr, silent = true })
            end,
         })
      end,
   },

   -- Opens the repository page in a web browser.
   {
      "almo7aya/openingh.nvim",
      cmd = { "OpenInGHFile", "OpenInGHRepo", "OpenInGHFileLine" },
      lazy = true,
   },

   -- Completion.
   {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
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

   -- Language Server config.
   {
      "neovim/nvim-lspconfig",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = { "hrsh7th/cmp-nvim-lsp" },
      config = function()
         local lspconfig = vim.lsp.config
         local capabilities = vim.lsp.protocol.make_client_capabilities()
         local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
         if ok_cmp then
            -- Update opts if nvim-cmp is available.
            capabilities = cmp.default_capabilities()
         else
            print("LspSetup: nvim-cmp not found")
         end
         local base = {
            capabilities = capabilities,
            flags = { debounce_text_changes = 150 },
         }

         vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(ev)
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
         })

         local function setup(_, server, extra)
            local cfg = vim.tbl_deep_extend("force", base, extra or {})
            vim.lsp.config(server, cfg)
            vim.lsp.enable(server)
         end

         if vim.fn.exepath("terraform-ls") ~= "" then
            setup({ "terraform", "tf", "hcl" }, "terraformls")
         end

         local has_ruff = vim.fn.exepath("ruff") ~= ""
         if has_ruff then
            setup({ "python" }, "ruff")
         end
         if vim.fn.exepath("pyright") ~= "" then
            setup({ "python" }, "pyright", {
               settings = {
                  python = {
                     pythonPath = vim.fn.exepath("python"),
                  },
                  pyright = {
                     disableOrganizeImports = has_ruff,
                  },
               },
            })
         end

         if vim.fn.exepath("rust-analyzer") ~= "" then
            setup({ "rust" }, "rust_analyzer")
         end

         if vim.fn.exepath("typescript-language-server") ~= "" then
            setup({ "typescript", "typescriptreact", "javascript", "javascriptreact" }, "ts_ls")
         end

         if vim.fn.exepath("lua-language-server") ~= "" then
            setup({ "lua" }, "lua_ls", {
               settings = {
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
               },
            })
         end
      end,
   },

   -- Previews LSP code actions.
   {
      "aznhe21/actions-preview.nvim",
      lazy = true,
      config = function()
         require("actions-preview").setup({
            telescope = {
               sorting_strategy = "ascending",
               layout_strategy = "vertical",
               layout_config = {
                  width = 0.8,
                  height = 0.9,
                  prompt_position = "top",
                  preview_cutoff = 20,
                  preview_height = function(_, _, max_lines)
                     return max_lines - 15
                  end,
               },
            },
         })
      end,
      keys = {
         {
            "<Leader>gf",
            function()
               require("actions-preview").code_actions()
            end,
            desc = "Code actions",
            silent = true,
         },
      },
   },

   {
      "kosayoda/nvim-lightbulb",
      event = { "LspAttach" },
      config = function()
         require("nvim-lightbulb").setup({
            autocmd = { enabled = true },
            sign = { enabled = false },
            virtual_text = { enabled = true },
         })
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
         vim.g.copilot_filetypes = { python = true, rust = true, typescript = true, typescriptreact = true }
      end,
   },

   -- Claude Code.
   {
      "coder/claudecode.nvim",
      dependencies = { "folke/snacks.nvim" },
      config = true,
      keys = {
         { "<leader>a", nil, desc = "AI/Claude Code" },
         { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
         { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
         { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
         { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
         { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
         { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
         { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
         {
            "<leader>as",
            "<cmd>ClaudeCodeTreeAdd<cr>",
            desc = "Add file",
            ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
         },
         -- Diff management
         { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
         { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
      },
   },

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
            "quickfix",
            "raise",
            "terraform",
            "unmarshal",
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

   -- Treesitter
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      dependencies = {
         "nvim-treesitter/nvim-treesitter-textobjects",
      },
      config = function()
         local configs = require("nvim-treesitter.configs")

         configs.setup({
            ensure_installed = { "lua", "vim", "vimdoc", "typescript", "javascript", "html", "rust", "python" },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
         })
      end,
   },

   -- from LazyVim
   -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/treesitter.lua

   -- Automatically add closing tags for HTML and JSX
   {
      "windwp/nvim-ts-autotag",
      ft = { "html", "xml", "javascriptreact", "typescriptreact", "vue", "svelte" },
      event = "InsertEnter",
      config = true,
   },
}
