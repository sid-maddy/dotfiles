local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = nil
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
end

return require("packer").startup({
    function(use)
        -- Packer can manage itself
        use("wbthomason/packer.nvim")
        use({
            "lewis6991/impatient.nvim",
            config = function()
                require("impatient")
            end,
        })

        -- Helpers
        use("tpope/vim-repeat")
        use("tpope/vim-surround")
        use("svermeulen/vimpeccable")

        -- Treesitter
        use({
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            config = function()
                -- TODO: Add ensure_installed
                require("nvim-treesitter.configs").setup({
                    ensure_installed = {
                        "bash",
                        "comment",
                        "css",
                        "dockerfile",
                        "go",
                        "gomod",
                        "hcl",
                        "help",
                        "hjson",
                        "html",
                        "http",
                        "javascript",
                        "jsdoc",
                        "json",
                        "json5",
                        "jsonc",
                        "lua",
                        "make",
                        "markdown",
                        "norg",
                        "python",
                        "query",
                        "regex",
                        "rst",
                        "toml",
                        "typescript",
                        "vim",
                        "yaml",
                    },
                    highlight = { enable = true },
                    incremental_selection = { enable = true },
                    indent = { enable = true },
                    rainbow = { enable = true },
                })
                vim.opt.foldmethod = "expr"
                vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            end,
        })
        use({ "nvim-treesitter/playground", requires = "nvim-treesitter/nvim-treesitter" })

        -- Play nice with other editors
        use({
            "editorconfig/editorconfig-vim",
            config = function()
                vim.g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }
            end,
        })

        -- Icons: Required for multiple plugins
        use({
            "kyazdani42/nvim-web-devicons",
            after = "neovim-ayu",
            config = function()
                require("nvim-web-devicons").setup({ default = true })
            end,
        })

        -- Completer
        -- main
        use({
            "ms-jpq/coq_nvim",
            branch = "coq",
            config = function()
                vim.g.coq_settings = { auto_start = "shut-up" }
            end,
        })
        -- Snippets
        use({ "ms-jpq/coq.artifacts", branch = "artifacts" })
        -- lua & third party sources
        use({ "ms-jpq/coq.thirdparty", branch = "3p" })

        -- LSP
        use({
            "neovim/nvim-lspconfig",
            requires = { "svermeulen/vimpeccable", "ms-jpq/coq_nvim" },
            config = function()
                local vimp = require("vimp")
                local lspconfig = require("lspconfig")
                local coq = require("coq")

                local efm = require("plugins.efm")

                -- Mappings.
                -- See `:help vim.diagnostic.*` for documentation on any of the below functions
                local opts = { "override", "silent" }
                vimp.nnoremap(opts, "<Leader>e", function()
                    vim.diagnostic.open_float()
                end)
                vimp.nnoremap(opts, "[d", function()
                    vim.diagnostic.goto_prev()
                end)
                vimp.nnoremap(opts, "]d", function()
                    vim.diagnostic.goto_next()
                end)
                vimp.nnoremap(opts, "<Leader>q", function()
                    vim.diagnostic.setloclist()
                end)

                -- Use an on_attach function to only map the following keys
                -- after the language server attaches to the current buffer
                local on_attach = function(_, bufnr)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

                    -- Mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    vimp.add_buffer_maps(bufnr, function()
                        vimp.nnoremap(opts, "gD", function()
                            vim.lsp.buf.declaration()
                        end)
                        vimp.nnoremap(opts, "gd", function()
                            vim.lsp.buf.definition()
                        end)
                        vimp.nnoremap(opts, "K", function()
                            vim.lsp.buf.hover()
                        end)
                        vimp.nnoremap(opts, "gi", function()
                            vim.lsp.buf.implementation()
                        end)
                        vimp.nnoremap(opts, "<C-k>", function()
                            vim.lsp.buf.signature_help()
                        end)
                        vimp.nnoremap(opts, "<Leader>wa", function()
                            vim.lsp.buf.add_workspace_folder()
                        end)
                        vimp.nnoremap(opts, "<Leader>wr", function()
                            vim.lsp.buf.remove_workspace_folder()
                        end)
                        vimp.nnoremap(opts, "<Leader>wl", function()
                            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                        end)
                        vimp.nnoremap(opts, "<Leader>D", function()
                            vim.lsp.buf.type_definition()
                        end)
                        vimp.nnoremap(opts, "<Leader>rn", function()
                            vim.lsp.buf.rename()
                        end)
                        vimp.nnoremap(opts, "<Leader>ca", function()
                            vim.lsp.buf.code_action()
                        end)
                        vimp.nnoremap(opts, "gr", function()
                            vim.lsp.buf.references()
                        end)
                        vimp.nnoremap(opts, "<Leader>f", function()
                            vim.lsp.buf.format({
                                async = true,
                                filter = function(client)
                                    return client.name ~= "tsserver"
                                end,
                            })
                        end)
                        vimp.vnoremap(opts, "<Leader>f", function()
                            vim.lsp.buf.range_formatting()
                        end)
                    end)
                end

                -- Use a loop to conveniently call 'setup' on multiple servers and
                -- map buffer local keybindings when the language server attaches
                -- TODO: Add more servers and their config
                local servers = {
                    bashls = {},
                    dockerls = {},
                    efm = efm,
                    gopls = {},
                    pyright = {},
                    sumneko_lua = {
                        settings = {
                            Lua = {
                                runtime = { version = "LuaJIT" },
                                diagnostics = { globals = { "vim" } },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file("", true),
                                },
                                telemetry = { enable = false },
                            },
                        },
                    },
                    tsserver = {},
                    yamlls = {},
                }
                for lsp, lsp_config in pairs(servers) do
                    local config = {
                        on_attach = on_attach,
                        flags = {
                            -- This will be the default in neovim 0.7+
                            debounce_text_changes = 150,
                        },
                    }
                    config = vim.tbl_deep_extend("force", config, lsp_config)
                    lspconfig[lsp].setup(coq.lsp_ensure_capabilities(config))
                end
            end,
        })

        -- Debug Adapter Protocol (DAP)
        -- TODO: Configure nvim-dap
        use("mfussenegger/nvim-dap")

        use({
            "scalameta/nvim-metals",
            after = "coq_nvim",
            requires = "nvim-lua/plenary.nvim",
            config = function()
                METALS_CONFIG = require("metals").bare_config()
                METALS_CONFIG.init_options = {
                    statusBarProvider = "show-message",
                    isHttpEnabled = true,
                    compilerOptions = { snippetAutoIndent = false },
                }
                METALS_CONFIG.settings = {
                    -- bloopVersion = "1.4.13-76-34e8105f",
                    excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
                    showImplicitArguments = true,
                }

                METALS_CONFIG.capabilities = coq.lsp_ensure_capabilities(vim.lsp.protocol.make_client_capabilities())

                -- TODO: Rewrite in pure Lua.
                vim.cmd([[
                    augroup metals
                        au!
                        au FileType java,scala,sbt lua require("metals").initialize_or_attach(METALS_CONFIG)
                    augroup end
                ]])
            end,
        })

        -- Colorscheme
        use({
            "Shatur/neovim-ayu",
            config = function()
                require("ayu").colorscheme()
            end,
        })

        -- Commenting
        use({
            "numToStr/Comment.nvim",
            config = function()
                require("Comment").setup()
            end,
        })
        use({
            "danymat/neogen",
            requires = "nvim-treesitter/nvim-treesitter",
            config = function()
                require("neogen").setup({})
            end,
        })

        -- File picker
        -- TODO: Configure layout and theme of telescope.nvim
        use({
            "nvim-telescope/telescope.nvim",
            after = { "neovim-ayu", "nvim-web-devicons" },
            requires = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons" },
            config = function()
                local vimp = require("vimp")
                local telescope = require("telescope")
                local telescope_builtin = require("telescope.builtin")

                telescope.setup({ defaults = { theme = "ivy" } })

                local opts = { "override", "silent" }
                vimp.nnoremap(opts, "<Leader>ff", function()
                    telescope_builtin.find_files({ find_command = { "fd", "--type", "f", "--hidden" } })
                end)
                vimp.nnoremap(opts, "<Leader>fr", function()
                    telescope.extensions.frecency.frecency()
                end)
                vimp.nnoremap(opts, "<Leader>fg", function()
                    telescope_builtin.live_grep()
                end)
                vimp.nnoremap(opts, "<Leader>fb", function()
                    telescope_builtin.buffers()
                end)
                vimp.nnoremap(opts, "<Leader>fm", function()
                    return "Jump to bookmarks"
                end)
            end,
        })
        use({
            "nvim-telescope/telescope-frecency.nvim",
            after = "telescope.nvim",
            config = function()
                require("telescope").load_extension("frecency")
            end,
            requires = { "tami5/sqlite.lua" },
        })

        -- Start page
        use({
            "goolord/alpha-nvim",
            requires = "kyazdani42/nvim-web-devicons",
            config = function()
                local alpha = require("alpha")
                local dashboard = require("alpha.themes.dashboard")
                local fortune = require("alpha.fortune")

                dashboard.section.buttons.val = {
                    dashboard.button("e", "  New file", ":enew <BAR> startinsert <CR>"),
                    dashboard.button("<Leader> f r", "  Frecency/MRU"),
                    dashboard.button("<Leader> f f", "  Find file"),
                    dashboard.button("<Leader> f g", "  Find word"),
                    dashboard.button("<Leader> f m", "  Jump to bookmarks"),
                    dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
                }
                dashboard.section.footer.val = fortune()

                alpha.setup(dashboard.config)
            end,
        })

        -- Statusline
        use({
            "nvim-lualine/lualine.nvim",
            requires = "kyazdani42/nvim-web-devicons",
            after = { "neovim-ayu", "nvim-web-devicons" },
            config = function()
                require("lualine").setup({
                    options = {
                        icons_enabled = false,
                        theme = "ayu",
                        component_separators = { left = "", right = "" },
                        section_separators = { left = "", right = "" },
                    },
                })
            end,
        })
        -- TODO: Test out feline.nvim
        --[[
        use({
        "feline-nvim/feline.nvim",
        config = function()
            require("feline").setup()
        end,
        })
        --]]

        -- Indent guides
        -- TODO: Configure indent-blankline
        use({
            "lukas-reineke/indent-blankline.nvim",
            config = function()
                require("indent_blankline").setup({
                    filetype_exclude = { "alpha", "help", "packer" },
                })
            end,
        })

        -- Splits on steroids
        use({
            "beauwilliams/focus.nvim",
            config = function()
                require("focus").setup()
            end,
        })

        -- Dim inactive buffers
        -- TODO: Configure shade.nvim
        -- FIXME: shade.nvim glitches with tabs
        use({
            "sunjon/shade.nvim",
            config = function()
                require("shade").setup({})
            end,
        })

        -- Better Quickfix
        use("kevinhwang91/nvim-bqf")

        -- Smooth scrolling
        use({
            "karb94/neoscroll.nvim",
            config = function()
                require("neoscroll").setup()
            end,
        })

        -- Rainbow parens!
        -- TODO: Check if this is still needed
        use("p00f/nvim-ts-rainbow")

        -- Git
        use("tpope/vim-fugitive")
        use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })
        use({
            "TimUntersberger/neogit",
            requires = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
            config = function()
                require("neogit").setup({
                    use_magit_keybindings = true,
                    integrations = { diffview = true },
                })
            end,
        })

        -- Chezmoi support
        use("alker0/chezmoi.vim")

        -- Hy support
        use({
            "hylang/vim-hy",
            config = function()
                vim.g.hy_enable_conceal = 1
                vim.g.hy_conceal_fancy = 1
            end,
        })

        -- Org mode
        -- TODO: Configure neorg
        use({
            "nvim-neorg/neorg",
            requires = { "nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope" },
            config = function()
                require("neorg").setup({
                    load = {
                        ["core.defaults"] = {},
                        ["core.export"] = {},
                        ["core.gtd.base"] = { config = { workspace = "tasks" } },
                        ["core.integrations.telescope"] = {},
                        -- No support for coq.nvim
                        -- ["core.norg.completion"] = {},
                        ["core.norg.dirman"] = {
                            config = {
                                workspaces = {
                                    docs = "~/Documents",
                                    tasks = "~/Documents/work/tasks",
                                },
                            },
                        },
                        ["core.norg.concealer"] = {},
                        ["core.norg.journal"] = { config = { workspace = "docs" } },
                        ["core.norg.qol.toc"] = {},
                        ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
                    },
                })
            end,
        })

        -- Zen mode
        -- TODO?: Configure zen-mode.nvim
        use({
            "folke/zen-mode.nvim",
            requires = "folke/twilight.nvim",
            config = function()
                require("zen-mode").setup({})
            end,
        })

        -- Automatically set up configuration after cloning packer.nvim
        if packer_bootstrap then
            require("packer").sync()
        end

        vim.cmd('autocmd User PackerComplete lua require("vimp").add_chord_cancellations("n", "<Leader>")')
    end,
    config = {
        display = {
            autoremove = true,
            open_fn = require("packer.util").float,
        },
    },
})
