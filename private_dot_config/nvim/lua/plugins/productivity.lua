return {
	{
		"nvim-neorg/neorg",
		dependencies = { "benlubas/neorg-interim-ls" },
		lazy = false,
		version = "*",
		opts = {
			load = {
				["core.completion"] = { config = { engine = { module_name = "external.lsp-completion" } } },
				["core.concealer"] = {},
				["core.defaults"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							docs = "~/Documents",
							work_docs = "~/Documents/work/docs",
							work_tasks = "~/Documents/work/tasks",
						},
					},
				},
				-- ["core.export"] = {},
				["core.integrations.treesitter"] = {},
				["core.journal"] = { config = { workspace = "docs" } },
				["core.presenter"] = { config = { zen_mode = "zen-mode" } },
			},
		},
		build = ":Neorg sync-parsers",
	},
}
