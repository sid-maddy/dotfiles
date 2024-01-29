local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

LSPCONFIG_BASE_SERVER_CONFIG = {}

require('lazy').setup({
    -- Colorscheme
    {
        'Shatur/neovim-ayu',
        priority = 1000,
        config = function() require('ayu').colorscheme() end,
    },
    {
        'folke/tokyonight.nvim',
        lazy = true,
        opts = {
            style = 'night',
        },
        config = function(_, opts)
            require('tokyonight').setup(opts)

            vim.cmd([[colorscheme tokyonight]])
        end,
    },
    {
        'nyoom-engineering/oxocarbon.nvim',
        lazy = true,
        config = function() vim.cmd([[colorscheme oxocarbon]]) end,
    },
    {
        'EdenEast/nightfox.nvim',
        lazy = true,
        config = function() vim.cmd([[colorscheme carbonfox]]) end,
    },
    {
        'dasupradyumna/midnight.nvim',
        lazy = true,
        config = function() vim.cmd([[colorscheme midnight]]) end,
    },

    -- Icons: Required for multiple plugins
    {
        'nvim-tree/nvim-web-devicons',
        lazy = true,
    },

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'Shatur/neovim-ayu', 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                icons_enabled = true,
                theme = 'ayu',
                component_separators = '|',
                section_separators = { left = '', right = '' },
            },
            sections = {
                lualine_a = {
                    { 'mode', separator = { left = '' }, right_padding = 2 },
                },
                lualine_b = { 'filename', 'branch' },
                lualine_c = { 'fileformat' },
                lualine_x = {},
                lualine_y = { 'filetype', 'progress' },
                lualine_z = {
                    { 'location', separator = { right = '' }, left_padding = 2 },
                },
            },
            inactive_sections = {
                lualine_a = { 'filename' },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { 'location' },
            },
            extensions = { 'fugitive', 'lazy', 'trouble' },
        },
    },

    -- Start page
    {
        'goolord/alpha-nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = function()
            local dashboard = require('alpha.themes.dashboard')
            local fortune = require('alpha.fortune')

            dashboard.section.buttons.val = {
                dashboard.button('e', '  New file', ':enew <BAR> startinsert <CR>'),
                dashboard.button('<Leader> p', '  Find file'),
                dashboard.button('<Leader> k r', '  Frecent files'),
                dashboard.button('<Leader> k f', '  Find in all files'),
                dashboard.button('<Leader> k b', '  Buffers'),
                dashboard.button('<Leader> k t', '  Tree-sitter'),
                dashboard.button('<Leader> k d', '  Diagnostics'),
                dashboard.button('q', '  Quit Neovim', ':qa<CR>'),
            }
            dashboard.section.footer.val = fortune()

            return dashboard.config
        end,
    },

    require('plugins.tree-sitter'),

    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',

            'rafamadriz/friendly-snippets',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            'lukas-reineke/cmp-rg',

            'petertriho/cmp-git',
            'davidsierradz/cmp-conventionalcommits',
        },
        config = function()
            -- Set up nvim-cmp.
            local cmp = require('cmp')

            -- Set up snippets
            require('luasnip.loaders.from_vscode').lazy_load()

            unpack = unpack or table.unpack
            cmp.setup({
                completion = { keyword_length = 1 },
                snippet = {
                    expand = function(args) require('luasnip').lsp_expand(args.body) end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-j>'] = cmp.mapping.scroll_docs(4),
                    ['<C-k>'] = cmp.mapping.scroll_docs(-4),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'rg' },
                }, {
                    { name = 'buffer' },
                }),
            })

            cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources(
                    { { name = 'git' }, { name = 'conventionalcommits' } },
                    { { name = 'buffer' } }
                ),
            })

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = { { name = 'buffer' } },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
            })
        end,
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'svermeulen/vimpeccable',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            local vimp = require('vimp')
            local lspconfig = require('lspconfig')

            local efm = require('plugins.efm')

            -- Mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            local opts = { 'override', 'silent' }
            vimp.nnoremap(opts, '<Leader>e', function() vim.diagnostic.open_float() end)
            vimp.nnoremap(opts, '[d', function() vim.diagnostic.goto_prev() end)
            vimp.nnoremap(opts, ']d', function() vim.diagnostic.goto_next() end)
            vimp.nnoremap(opts, '<Leader>q', function() vim.diagnostic.setloclist() end)

            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
            local on_attach = function(_, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                -- Mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                vimp.add_buffer_maps(bufnr, function()
                    vimp.nnoremap(opts, 'gD', function() vim.lsp.buf.declaration() end)
                    vimp.nnoremap(opts, 'gd', function() vim.lsp.buf.definition() end)
                    vimp.nnoremap(opts, 'K', function() vim.lsp.buf.hover() end)
                    vimp.nnoremap(opts, 'gi', function() vim.lsp.buf.implementation() end)
                    vimp.nnoremap(opts, '<C-k>', function() vim.lsp.buf.signature_help() end)
                    vimp.nnoremap(opts, '<Leader>wa', function() vim.lsp.buf.add_workspace_folder() end)
                    vimp.nnoremap(opts, '<Leader>wr', function() vim.lsp.buf.remove_workspace_folder() end)
                    vimp.nnoremap(
                        opts,
                        '<Leader>wl',
                        function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end
                    )
                    vimp.nnoremap(opts, '<Leader>D', function() vim.lsp.buf.type_definition() end)
                    vimp.nnoremap(opts, '<Leader>rn', function() vim.lsp.buf.rename() end)
                    vimp.nnoremap(opts, '<Leader>ca', function() vim.lsp.buf.code_action() end)
                    vimp.nnoremap(opts, 'gr', function() vim.lsp.buf.references() end)
                    vimp.nnoremap(opts, '<Leader>f', function()
                        vim.lsp.buf.format({
                            async = true,
                            filter = function(client) return client.name ~= 'tsserver' end,
                        })
                    end)
                    vimp.vnoremap(opts, '<Leader>f', function() vim.lsp.buf.range_formatting() end)
                end)
            end

            -- Use a loop to conveniently call 'setup' on multiple servers and
            -- map buffer local keybindings when the language server attaches
            local servers = {
                astro = {},
                bashls = {},
                denols = {
                    root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
                },
                dockerls = {},
                efm = efm,
                gopls = {},
                jsonnet_ls = {},
                prismals = {},
                pyright = {},
                racket_langserver = {},
                ruby_ls = {},
                ruff_lsp = {},
                solargraph = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = 'LuaJIT' },
                            diagnostics = { globals = { 'vim' } },
                            workspace = {
                                library = vim.api.nvim_get_runtime_file('', true),
                            },
                            telemetry = { enable = false },
                        },
                    },
                },
                taplo = {},
                terraformls = {},
                tsserver = {
                    root_dir = lspconfig.util.root_pattern('package.json'),
                },
                yamlls = {},
            }
            local config = { on_attach = on_attach }
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            for lsp, lsp_config in pairs(servers) do
                local server_config = vim.tbl_deep_extend('force', config, lsp_config, { capabilities = capabilities })
                lspconfig[lsp].setup(server_config)
            end

            LSPCONFIG_BASE_SERVER_CONFIG = config
        end,
    },

    -- Debug Adapter Protocol (DAP)
    -- "mfussenegger/nvim-dap",

    -- File picker
    -- TODO: Configure layout and theme of telescope.nvim
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'Shatur/neovim-ayu',
            'nvim-tree/nvim-web-devicons',
            'nvim-lua/plenary.nvim',

            'nvim-telescope/telescope-frecency.nvim',
            'benfowler/telescope-luasnip.nvim',
        },
        config = function()
            local vimp = require('vimp')
            local telescope = require('telescope')
            local telescope_builtin = require('telescope.builtin')

            telescope.setup({
                defaults = { theme = 'ivy' },

                -- Extensions
                extensions = {
                    -- Frecency
                    frecency = {
                        db_safe_mode = false,
                    },
                },
            })
            telescope.load_extension('frecency')
            telescope.load_extension('luasnip')

            local opts = { 'override', 'silent' }
            vimp.nnoremap(
                opts,
                '<Leader>p',
                function()
                    telescope_builtin.find_files({
                        find_command = { 'fd', '--type', 'f', '--color', 'never', '--hidden' },
                    })
                end
            )
            vimp.nnoremap(opts, '<Leader>kgf', function() telescope_builtin.git_files() end)
            vimp.nnoremap(opts, '<Leader>kr', function() telescope.extensions.frecency.frecency() end)
            vimp.nnoremap(opts, '<Leader>kf', function() telescope_builtin.live_grep() end)
            vimp.nnoremap(opts, '<Leader>kb', function() telescope_builtin.buffers() end)
            vimp.nnoremap(opts, '<Leader>kt', function() telescope_builtin.treesitter() end)
            vimp.nnoremap(opts, '<Leader>kd', function() telescope_builtin.diagnostics() end)
        end,
    },

    -- Helpers
    'tpope/vim-repeat',
    'tpope/vim-surround',
    'svermeulen/vimpeccable',

    -- Diagnostics
    {
        'folke/trouble.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            use_diagnostic_signs = true,
        },
    },

    -- Play nice with other editors
    {
        'editorconfig/editorconfig-vim',
        init = function() vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*', 'scp://.*' } end,
    },

    -- Commenting
    {
        'numToStr/Comment.nvim',
        opts = {},
    },
    {
        'danymat/neogen',
        dependencies = 'nvim-treesitter/nvim-treesitter',
        opts = {},
    },

    -- Git
    'tpope/vim-fugitive',
    {
        'lewis6991/gitsigns.nvim',
        opts = {},
    },

    {
        'https://codeberg.org/esensar/nvim-dev-container',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = {
            attach_mounts = {
                always = true,
                neovim_config = {
                    enabled = true,
                    options = { 'readonly' },
                },
                neovim_data = { enabled = true },
                neovim_state = { enabled = true },
            },
        },
    },

    -- Focus… on the active split
    {
        'nvim-focus/focus.nvim',
        opts = {},
    },

    -- Focus… on the active code
    {
        'folke/twilight.nvim',
        opts = {
            dimming = {
                inactive = true,
            },
        },
    },

    ----------------------------------------------------
    -- Language support
    ----------------------------------------------------
    -- Chezmoi support
    'alker0/chezmoi.vim',

    -- Earthly support
    {
        'earthly/earthly.vim',
        ft = 'Earthfile',
    },

    -- Go support
    {
        'fatih/vim-go',
        ft = { 'go', 'gomod', 'gosum', 'gowork' },
        init = function() vim.g.go_metalinter_enabled = { 'all' } end,
    },

    -- Helm support
    {
        'towolf/vim-helm',
        ft = 'helm',
    },

    -- Hy support
    {
        'hylang/vim-hy',
        ft = 'hy',
        init = function()
            vim.g.hy_enable_conceal = 1
            vim.g.hy_conceal_fancy = 1
        end,
    },

    -- Jinja support
    {
        'HiPhish/jinja.vim',
        ft = '*.jinja',
    },

    -- Org mode
    {
        'nvim-neorg/neorg',
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-neorg/neorg-telescope' },
        ft = 'norg',
        opts = {
            load = {
                ['core.completion'] = {},
                ['core.concealer'] = {},
                ['core.defaults'] = {},
                ['core.dirman'] = {
                    config = {
                        workspaces = {
                            docs = '~/Documents',
                            work_docs = '~/Documents/work/docs',
                            work_tasks = '~/Documents/work/tasks',
                        },
                    },
                },
                -- ["core.export"] = {},
                -- ["core.integrations.telescope"] = {},
                ['core.integrations.treesitter'] = {},
                ['core.journal'] = { config = { workspace = 'docs' } },
                ['core.presenter'] = { config = { zen_mode = 'zen-mode' } },
                ['core.qol.toc'] = {},
            },
        },
        build = ':Neorg sync-parsers',
    },

    -- Rust
    {
        'simrat39/rust-tools.nvim',
        ft = 'rust',
        dependencies = {
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            local rust_tools = require('rust-tools')

            rust_tools.setup({
                server = vim.tbl_deep_extend('force', LSPCONFIG_BASE_SERVER_CONFIG, {
                    settings = {
                        ['rust-analyzer'] = {
                            checkOnSave = { command = 'clippy' },
                            inlayHints = { locationLinks = false },
                        },
                    },
                    { capabilities = require('cmp_nvim_lsp').default_capabilities },
                }),
            })
            rust_tools.inlay_hints.enable()
        end,
    },

    -- Scala
    {
        'scalameta/nvim-metals',
        ft = 'scala',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            METALS_CONFIG = require('metals').bare_config()
            METALS_CONFIG.init_options = {
                statusBarProvider = 'show-message',
                isHttpEnabled = true,
                compilerOptions = { snippetAutoIndent = false },
            }
            METALS_CONFIG.settings = {
                -- bloopVersion = "1.4.13-76-34e8105f",
                excludedPackages = { 'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl' },
                showImplicitArguments = true,
                useGlobalExecutable = true,
            }

            METALS_CONFIG.capabilities = require('cmp_nvim_lsp').default_capabilities

            -- TODO: Rewrite in pure Lua.
            vim.cmd([[
                augroup metals
                au!
                au FileType java,scala,sbt lua require("metals").initialize_or_attach(METALS_CONFIG)
                augroup end
            ]])
        end,
    },
}, {
    dev = { path = '~/Documents/github/nvim' },
    install = { colorscheme = { 'ayu' } },
})
