return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'caddy',
        'cmake',
        'comment',
        'commonlisp',
        'cpp',
        'csv',
        'dart',
        'desktop',
        'dot',
        'earthfile',
        'ebnf',
        'editorconfig',
        'embedded_template',
        'gotmpl',
        'gpg',
        'graphql',
        'groovy',
        'hjson',
        'hocon',
        'htmldjango',
        'http',
        'ini',
        'java',
        'javadoc',
        'jinja',
        'jinja_inline',
        'jq',
        'jsonnet',
        'just',
        'kcl',
        'kdl',
        'kotlin',
        'latex',
        'make',
        'mermaid',
        'nginx',
        'nickel',
        'passwd',
        'pem',
        'powershell',
        'promql',
        'properties',
        'proto',
        'pymanifest',
        'rego',
        'requirements',
        'robots',
        'scheme',
        'scss',
        'ssh_config',
        'svelte',
        'templ',
        'textproto',
        'thrift',
        'tmux',
        'todotxt',
        'tsv',
        'typst',
        'udev',
        'vue',
        'xresources',
      })
    end,
  },
}
