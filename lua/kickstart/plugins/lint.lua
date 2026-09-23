-- Linting

vim.pack.add { 'https://github.com/mfussenegger/nvim-lint' }

local lint = require 'lint'

-- Helper function to determine the best eslint executable
local function get_eslint_binary()
  -- nvim-lint provides a built-in utility to find files in parent directories
  local local_eslint = vim.fs.find({ 'node_modules/.bin/eslint' }, { path = vim.fn.getcwd(), upward = true })[1]

  if local_eslint then
    return 'eslint'
  else
    -- Fallback to the Mason-installed global eslint_d
    return 'eslint_d'
  end
end

-- Dynamically assign the linter based on project setup
local eslint_cmd = get_eslint_binary()

lint.linters_by_ft = {
  markdown = { 'markdownlint' },
  javascript = { eslint_cmd },
  javascriptreact = { eslint_cmd },
  typescript = { eslint_cmd },
  typescriptreact = { eslint_cmd },
  json = { eslint_cmd },
  jsonc = { eslint_cmd }
}


-- To allow other plugins to add linters to require('lint').linters_by_ft,
-- instead set linters_by_ft like this:
-- lint.linters_by_ft = lint.linters_by_ft or {}
-- lint.linters_by_ft['markdown'] = { 'markdownlint' }
--
-- However, note that this will enable a set of default linters,
-- which will cause errors unless these tools are available:
-- {
--   clojure = { "clj-kondo" },
--   dockerfile = { "hadolint" },
--   inko = { "inko" },
--   janet = { "janet" },
--   json = { "jsonlint" },
--   markdown = { "vale" },
--   rst = { "vale" },
--   ruby = { "ruby" },
--   terraform = { "tflint" },
--   text = { "vale" }
-- }
--
-- You can disable the default linters by setting their filetypes to nil:
-- lint.linters_by_ft['clojure'] = nil
-- lint.linters_by_ft['dockerfile'] = nil
-- lint.linters_by_ft['inko'] = nil
-- lint.linters_by_ft['janet'] = nil
-- lint.linters_by_ft['json'] = nil
-- lint.linters_by_ft['markdown'] = nil
-- lint.linters_by_ft['rst'] = nil
-- lint.linters_by_ft['ruby'] = nil
-- lint.linters_by_ft['terraform'] = nil
-- lint.linters_by_ft['text'] = nil

-- eslint_d resolves config from the linted file's path, but picks which
-- *local* eslint install to actually run from its invoking cwd. Without a
-- per-buffer cwd it falls back to its own bundled ESLint, which can be a
-- different major version than the project's (e.g. plugins calling the
-- removed `context.getFilename()` crash: "contextOrFilename.getFilename is
-- not a function"). Point it at the nearest eslint.config.* instead of
-- relying on Neovim's global cwd.
local function nearest_eslint_root(bufnr)
  local buf_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  if not buf_dir then return nil end

  local config = vim.fs.find(
    { 'eslint.config.mjs', 'eslint.config.js', 'eslint.config.cjs' },
    { path = buf_dir, upward = true }
  )[1]
  if config then return vim.fs.dirname(config) end

  local local_eslint = vim.fs.find({ 'node_modules/eslint' }, { path = buf_dir, upward = true })[1]
  return local_eslint and vim.fs.dirname(vim.fs.dirname(local_eslint)) or nil
end

-- Create autocommand which carries out the actual linting
-- on the specified events.
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function(args)
    -- Only run the linter in buffers that you can modify in order to
    -- avoid superfluous noise, notably within the handy LSP pop-ups that
    -- describe the hovered symbol using Markdown.
    if vim.bo.modifiable then
      lint.try_lint(nil, { cwd = nearest_eslint_root(args.buf) })
    end
  end,
})
