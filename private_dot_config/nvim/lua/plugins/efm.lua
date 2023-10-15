local eslint = {
    prefix = "eslint",
    lintCommand = "eslint --no-color --format visualstudio --stdin",
    lintStdin = true,
    lintFormats = { "<text>(%l,%c): %trror %m", "<text>(%l,%c): %tarning %m" },
    rootMarkers = {
        ".eslintrc",
        ".eslintrc.cjs",
        ".eslintrc.js",
        ".eslintrc.json",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        "package.json",
    },
}

local prettier = {
    formatCommand = "prettier --no-color --stdin --stdin-filepath ${INPUT}",
    formatStdin = true,
}

local shfmt = {
    formatCommand = "shfmt -s -i 4 -bn -ci -",
    formatStdin = true,
}

local languages = {
    bash = { shfmt },
    css = { prettier },
    dockerfile = {
        {
            lintCommand = "hadolint --no-color",
            lintFormats = { "%f:%l %m" },
        },
    },
    html = { prettier },
    javascript = { prettier, eslint },
    javascriptreact = { prettier, eslint },
    json = { prettier },
    json5 = { prettier },
    jsonc = { prettier },
    less = { prettier },
    lua = {
        {
            formatCommand = "stylua --color Never -",
            formatStdin = true,
            rootMarkers = { "stylua.toml", ".stylua.toml" },
        },
        {
            prefix = "luacheck",
            lintCommand = "luacheck --codes --no-color --quiet -",
            lintStdin = true,
            lintFormats = { "%.%#:%l:%c: (%t%n) %m" },
            rootMarkers = { ".luacheckrc" },
        },
    },
    markdown = { prettier },
    python = {
        {
            formatCommand = "black --no-color --quiet --stdin-filename ${INPUT} -",
            formatStdin = true,
        },
    },
    scss = { prettier },
    sh = { shfmt },
    typescript = { prettier, eslint },
    typescriptreact = { prettier, eslint },
    yaml = { prettier },
}

local filetypes = {}
for filetype in pairs(languages) do
    filetypes[#filetypes + 1] = filetype
end

return {
    init_options = { documentFormatting = true },
    filetypes = filetypes,
    settings = { languages = languages },
}
