return {
	{
		'stevearc/conform.nvim',
		event = { 'BufWritePre' },
		cmd = { 'ConformInfo' },
		opts = {
			formatters_by_ft = {
				lua = { 'stylua' },
				python = { 'ruff_organize_imports', 'ruff_format' },
				html = { 'prettier' },
				json = { 'prettier' },
				yaml = { 'prettier' },
				markdown = { 'prettier' },
				sh = { 'shfmt' },
				terraform = { 'terraform_fmt' },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = 'fallback',
			},
			formatters = {
				stylua = {
					prepend_args = { '--no-editorconfig' },
				},
				shfmt = {
					prepend_args = { '-i', '4' },
				},
				ruff_organize_imports = {
					command = 'ruff',
					args = { 'check', '--fix', '--select', 'I', '--stdin-filename', '$FILENAME', '-' },
					stdin = true,
				},
			},
		},
	},
	{
		'mfussenegger/nvim-lint',
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			local lint = require 'lint'
			lint.linters_by_ft = {
				python = { 'ruff' },
				make = { 'checkmake' },
			}
			vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
				callback = function()
					if vim.bo.modifiable then
						lint.try_lint()
					end
				end,
			})
		end,
	},
}
