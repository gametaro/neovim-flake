local M = {}

---@param lnum integer
---@param col integer
---@return string
local function get_char_at(lnum, col)
  local line = vim.fn.getline(lnum)
  if col > vim.api.nvim_strwidth(line) then return ' ' end
  return vim.fn.strcharpart(vim.fn.strpart(line, col - 1), 0, 1)
end

function M.highlight()
  vim.api.nvim_create_autocmd('ColorScheme', {
    desc = 'Tweak default colorscheme',
    group = vim.api.nvim_create_augroup('highlight', {}),
    pattern = 'default',
    callback = function()
      local bg = vim.o.background == 'dark' and 'NvimDark' or 'NvimLight'
      local fg = vim.o.background == 'dark' and 'NvimLight' or 'NvimDark'

      vim.api.nvim_set_hl(0, '@variable.member', { default = true, link = 'Identifier' })
      vim.api.nvim_set_hl(0, '@variable.parameter', { default = true, link = 'Identifier' })
      vim.api.nvim_set_hl(0, 'Constant', { fg = fg .. 'Yellow' })
      vim.api.nvim_set_hl(0, 'Delimiter', { fg = fg .. 'Grey3' })
      vim.api.nvim_set_hl(0, 'Operator', { fg = fg .. 'Grey3' })
      vim.api.nvim_set_hl(0, 'WinSeparator', { fg = bg .. 'Grey4' })
      vim.api.nvim_set_hl(
        0,
        'StatusLine',
        { fg = fg .. 'Grey2', bg = bg .. 'Grey4', cterm = { reverse = true } }
      )
      vim.api.nvim_set_hl(0, 'PmenuSel', { bg = bg .. 'Grey4' })
      vim.api.nvim_set_hl(0, 'Underlined', { fg = fg .. 'Blue', underline = true })
      vim.api.nvim_set_hl(0, 'FlashLabel', { bg = bg .. 'Blue' })
      vim.api.nvim_set_hl(0, 'TelescopeNormal', { default = true, link = 'Pmenu' })
      vim.api.nvim_set_hl(0, 'TelescopeSelection', { default = true, link = 'PmenuSel' })

      vim.g.terminal_color_0 = bg .. 'Grey2'
      vim.g.terminal_color_1 = fg .. 'Red'
      vim.g.terminal_color_2 = fg .. 'Green'
      vim.g.terminal_color_3 = fg .. 'Yellow'
      vim.g.terminal_color_4 = fg .. 'Blue'
      vim.g.terminal_color_5 = fg .. 'Magenta'
      vim.g.terminal_color_6 = fg .. 'Cyan'
      vim.g.terminal_color_7 = fg .. 'Grey2'
      vim.g.terminal_color_8 = bg .. 'Grey2'
      vim.g.terminal_color_9 = fg .. 'Red'
      vim.g.terminal_color_10 = fg .. 'Green'
      vim.g.terminal_color_11 = fg .. 'Yellow'
      vim.g.terminal_color_12 = fg .. 'Blue'
      vim.g.terminal_color_13 = fg .. 'Magenta'
      vim.g.terminal_color_14 = fg .. 'Cyan'
      vim.g.terminal_color_15 = fg .. 'Grey2'
    end,
  })
end

function M.option()
  vim.o.autowriteall = true
  vim.o.backup = true
  vim.opt.backupdir:remove('.')
  vim.o.cmdheight = 0
  vim.o.completeopt = 'menu,menuone,noselect,popup,fuzzy'
  vim.o.confirm = true
  vim.o.diffopt =
    'internal,filler,closeoff,algorithm:histogram,indent-heuristic,vertical,linematch:60'
  vim.o.exrc = true
  vim.o.fillchars = 'eob:·'
  vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.o.foldlevelstart = 99
  vim.o.foldmethod = 'expr'
  vim.o.foldtext = ''
  vim.o.ignorecase = true
  vim.o.jumpoptions = 'view,clean'
  vim.o.mouse = 'ar'
  vim.o.mousemoveevent = true
  -- vim.o.modeline = false
  vim.o.updatetime = 300
  vim.o.sessionoptions = 'buffers,tabpages,folds'
  vim.o.shada = vim.o.shada .. ',r/tmp/,r/private/,r/nix/store/,rzipfile:,rterm:,rhealth:'
  vim.o.shortmess = 'atToOCFIWcs'
  vim.o.showcmd = false
  vim.o.showmode = false
  vim.o.signcolumn = 'yes'
  vim.o.smartcase = true
  vim.o.smoothscroll = true
  vim.o.spelllang = 'en,cjk'
  vim.o.spelloptions = 'camel,noplainbuffer'
  vim.o.splitkeep = 'screen'
  vim.o.termguicolors = true
  vim.o.tabclose = 'uselast'
  vim.o.undofile = true
  vim.o.virtualedit = 'all'
  vim.o.wildignorecase = true
  vim.o.wildoptions = 'fuzzy,pum,tagfile'
  vim.o.wrap = false
end

function M.keymap()
  vim.keymap.set('', '<space>', '')
  vim.keymap.set('c', '<c-a>', '<home>')
  vim.keymap.set('c', '<c-b>', '<left>')
  vim.keymap.set('c', '<c-f>', '<right>')
  vim.keymap.set('c', '<m-b>', '<s-left>')
  vim.keymap.set('c', '<m-f>', '<s-right>')
  vim.keymap.set('n', '<c-t>', '')
  vim.keymap.set('n', '<c-t>c', '<cmd>tabclose<cr>')
  vim.keymap.set('n', '<c-t>f', '<cmd>tabfirst<cr>')
  vim.keymap.set('n', '<c-t>l', '<cmd>tablast<cr>')
  vim.keymap.set('n', '<c-t>n', '<cmd>tabnew<cr>')
  vim.keymap.set('n', '<c-t>o', '<cmd>tabonly<cr>')
  vim.keymap.set('n', 'qo', '<cmd>copen<cr>')
  vim.keymap.set('n', 'qc', '<cmd>cclose<cr>')
  vim.keymap.set('n', 'cn', '*``cgn')
  vim.keymap.set('n', 'cN', '*``cgN')
  vim.keymap.set('x', 'p', 'P')
  vim.keymap.set('x', 'P', 'p')
  vim.keymap.set(
    'ca',
    'E',
    function() return vim.fn.getcmdtype() == ':' and 'e' or 'E' end,
    { expr = true }
  )
  vim.keymap.set(
    'ca',
    'H',
    function() return vim.fn.getcmdtype() == ':' and 'h' or 'H' end,
    { expr = true }
  )
  vim.keymap.set(
    'ca',
    'W',
    function() return vim.fn.getcmdtype() == ':' and 'w' or 'W' end,
    { expr = true }
  )
  vim.keymap.set('t', '<esc>', '<c-\\><c-n>')
  vim.keymap.set('t', '<c-^>', '<c-\\><c-n><c-^>')
  vim.keymap.set(
    't',
    '<c-r>',
    function() return '<c-\\><c-n>"' .. vim.fn.nr2char(vim.fn.getchar()) .. 'pi' end,
    { expr = true }
  )
  vim.keymap.set('n', 'x', '"_x')
  vim.keymap.set('n', '-', '<cmd>edit %:p:h<cr>')
  vim.keymap.set('n', 'cd', '<cmd>cd %:p:h<bar>pwd<cr>')
  vim.keymap.set('n', 'gm', '<cmd>message<cr>')
  vim.keymap.set('s', '<bs>', '<bs>i')
  vim.keymap.set('s', '<c-h>', '<c-h>i')
  vim.keymap.set(
    { 'n', 'x', 'o' },
    '0',
    function() return vim.fn.virtcol('.') == vim.fn.indent('.') + 1 and '0' or '^' end,
    { expr = true, desc = 'To line start or first non-blank character' }
  )
  vim.keymap.set(
    { 'n', 'x', 'o' },
    '$',
    function()
      return vim.fn.virtcol('.') == vim.api.nvim_strwidth(vim.fn.getline('.'):match('.*%S')) and '$'
        or 'g_'
    end,
    { expr = true, desc = 'To line end or last non-blank character' }
  )

  vim.keymap.set('n', '\\c', '<cmd>setlocal cursorline!<cr>')
  vim.keymap.set('n', '\\f', '<cmd>setlocal foldenable!<cr>')
  vim.keymap.set('n', '\\l', '<cmd>setlocal list!<cr>')
  vim.keymap.set('n', '\\n', '<cmd>setlocal number!<cr>')
  vim.keymap.set('n', '\\N', '<cmd>setlocal relativenumber!<cr>')
  vim.keymap.set('n', '\\w', '<cmd>setlocal wrap!<cr>')
  vim.keymap.set('n', '\\d', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end)
  vim.keymap.set(
    'n',
    '\\i',
    function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end
  )

  vim.keymap.set({ 'i', 's' }, '<esc>', function()
    vim.snippet.stop()
    return '<esc>'
  end, { expr = true })

  vim.keymap.set('n', 'dq', vim.diagnostic.setqflist)
  vim.keymap.set('n', 'dl', vim.diagnostic.setloclist)

  vim.keymap.set('n', 'zS', vim.show_pos)

  ---@type table<string, table<integer, integer>>
  local terminals = vim.defaulttable(function() return {} end)
  vim.keymap.set('n', 't', function()
    local count = vim.v.count1
    local cwd = vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(0))
    local buf = terminals[cwd][count]
    if buf and vim.api.nvim_buf_is_loaded(buf) then
      vim.cmd.buffer(buf)
      return
    end
    vim.cmd.terminal()
    terminals[cwd][count] = vim.api.nvim_get_current_buf()
  end)

  vim
    .iter({
      I = { v = '<c-v>I', V = '<c-v>^o^I', ['\22'] = 'I' },
      A = { v = '<c-v>A', V = '<c-v>0o$A', ['\22'] = 'A' },
      gI = { v = '<c-v>0I', V = '<c-v>0o$I', ['\22'] = '0I' },
    })
    :each(function(k, v)
      vim.keymap.set('x', k, function() return v[vim.api.nvim_get_mode().mode] end, { expr = true })
    end)
end

function M.diagnostic()
  vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
    signs = {
      text = {
        [1] = '●',
        [2] = '●',
        [3] = '●',
        [4] = '●',
      },
    },
    float = {
      header = '',
      suffix = function(diag) return string.format(' (%s)', diag.code or ''), 'Comment' end,
    },
    jump = {
      float = true,
    },
  })
end

function M.autocmd()
  local group = vim.api.nvim_create_augroup('init', {})
  ---@param event string|string[]
  ---@param opts vim.api.keyset.create_autocmd
  local function autocmd(event, opts)
    opts.group = group
    vim.api.nvim_create_autocmd(event, opts)
  end

  autocmd('TextYankPost', {
    desc = 'Highlight yanked region',
    callback = function() vim.highlight.on_yank() end,
  })

  autocmd('BufWritePost', {
    desc = 'Update diff',
    callback = function()
      if vim.wo.diff then vim.cmd.diffupdate() end
    end,
  })

  autocmd({ 'BufWritePre', 'FileWritePre' }, {
    desc = 'Create missing parent directories',
    callback = function()
      if not string.find(vim.fn.expand('%'), '://') then
        local dir = vim.fn.expand('<afile>:p:h')
        if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, 'p') end
      end
    end,
  })

  autocmd('FileType', {
    desc = 'Close current window',
    pattern = { 'checkhealth', 'help', 'man', 'qf' },
    callback = function(a)
      vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true, nowait = true })
      if a.match ~= 'help' then vim.wo[0][0].winfixbuf = true end
    end,
  })

  autocmd('VimResized', {
    desc = 'Resize window',
    callback = function() vim.cmd.wincmd('=') end,
  })

  autocmd('FileType', {
    pattern = { 'changelog', 'gitcommit', 'markdown', 'text' },
    callback = function(a)
      local buf = a.buf ---@type integer
      vim.wo[0][0].breakindent = true
      vim.wo[0][0].list = true
      vim.wo[0][0].showbreak = '> '
      vim.wo[0][0].spell = true
      vim.wo[0][0].wrap = true

      vim.keymap.set({ 'n', 'x' }, 'j', 'gj', { buffer = buf })
      vim.keymap.set({ 'n', 'x' }, 'k', 'gk', { buffer = buf })
      vim.keymap.set({ 'n', 'x' }, 'gj', 'j', { buffer = buf })
      vim.keymap.set({ 'n', 'x' }, 'gk', 'k', { buffer = buf })
    end,
  })

  autocmd('FileType', {
    desc = 'Enable auto-save',
    pattern = { 'changelog', 'markdown', 'text' },
    callback = function(a)
      local buf = a.buf ---@type integer
      local file = a.file ---@type string

      autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = buf,
        callback = function()
          if
            vim.api.nvim_buf_is_valid(buf)
            and vim.bo[buf].buftype == ''
            and vim.bo[buf].modifiable
          then
            vim.cmd.update({ file, mods = { silent = true, noautocmd = true } })
          end
        end,
      })
    end,
  })

  autocmd('FileType', {
    pattern = { 'gitcommit', 'gitrebase' },
    callback = function() vim.bo.buflisted = false end,
  })

  autocmd({ 'BufWinEnter', 'VimEnter' }, {
    desc = 'Change directory to project root',
    callback = function()
      local root = vim.fs.root(0, { '.git' })
      local pwd = vim.fn.getcwd(-1, 0)
      if root and pwd ~= root then vim.cmd.tcd(root) end
    end,
  })

  autocmd('BufRead', {
    desc = 'Restore cursor position',
    callback = function(a)
      local buf = a.buf ---@type integer
      autocmd('BufWinEnter', {
        once = true,
        buffer = buf,
        callback = function()
          local ft = vim.bo[buf].filetype
          local last_known_line = vim.api.nvim_buf_get_mark(buf, '"')[1]
          if
            not (ft:match('commit') and ft:match('rebase'))
            and last_known_line > 1
            and last_known_line <= vim.api.nvim_buf_line_count(buf)
          then
            vim.api.nvim_feedkeys('g`"', 'nx', false)
          end
        end,
      })
    end,
  })

  autocmd('TermOpen', {
    desc = 'Start in Terminal mode',
    pattern = 'term://*',
    callback = function() vim.cmd.startinsert() end,
  })

  autocmd('FileType', {
    desc = 'Starts treesitter highlighting for a buffer',
    callback = function() pcall(vim.treesitter.start) end,
  })

  autocmd('VimEnter', {
    desc = 'Load .nvim.lua on startup',
    callback = function()
      local contents = vim.secure.read('.nvim.lua')
      if contents then assert(loadstring(contents))() end
    end,
  })

  autocmd('VimEnter', {
    desc = 'Create or update spell files',
    callback = function()
      vim
        .iter(vim.fs.find(function(name) return string.match(name, '.+%.add$') end, {
          type = 'file',
          path = vim.fs.joinpath(vim.fn.stdpath('config') --[[@as string]], 'spell'),
        }))
        :each(function(add_file)
          local spell_file = add_file --[[@as string]]
            .. '.spl'
          local spell_stat = vim.uv.fs_stat(spell_file)
          if not spell_stat then vim.cmd.mkspell(add_file) end
          local add_stat = vim.uv.fs_stat(add_file)
          if add_stat and spell_stat and add_stat.mtime.sec > spell_stat.mtime.sec then
            vim.cmd.mkspell({ add_file, bang = true })
          end
        end)
    end,
  })

  autocmd({ 'TermRequest' }, {
    desc = 'Handles OSC 7 dir change requests',
    callback = function(a)
      if string.sub(vim.v.termrequest, 1, 4) == '\x1b]7;' then
        local dir = string.gsub(vim.v.termrequest, '\x1b]7;file://[^/]*', '')
        if vim.fn.isdirectory(dir) == 0 then
          vim.notify('invalid dir: ' .. dir)
          return
        end
        vim.api.nvim_buf_set_var(a.buf, 'osc7_dir', dir)
        if vim.o.autochdir and vim.api.nvim_get_current_buf() == a.buf then vim.cmd.tcd(dir) end
      end
    end,
  })

  autocmd({ 'BufEnter', 'WinEnter', 'DirChanged' }, {
    callback = function()
      if vim.b.osc7_dir and vim.fn.isdirectory(vim.b.osc7_dir) == 1 then
        vim.cmd.tcd(vim.b.osc7_dir)
      end
    end,
  })
end

function M.lsp()
  local schemastore = require('schemastore')
  local cmp_nvim_lsp = require('cmp_nvim_lsp')
  local actionlint = require('efmls-configs.linters.actionlint')
  local markdownlint = require('efmls-configs.linters.markdownlint')
  local prettier_d = require('efmls-configs.formatters.prettier_d')
  local statix = require('efmls-configs.linters.statix')
  local stylua = require('efmls-configs.formatters.stylua')
  local shfmt = require('efmls-configs.formatters.shfmt')

  vim.lsp.config('*', {
    root_markers = { '.git' },
    capabilities = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      cmp_nvim_lsp.default_capabilities()
    ),
  })

  local ts_settings = {
    implementationsCodeLens = {
      enabled = true,
    },
    referencesCodeLens = {
      enabled = true,
      showOnAllFunctions = true,
    },
    inlayHints = {
      includeInlayEnumMemberValueHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayParameterNameHints = 'all',
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayVariableTypeHintsWhenTypeMatchesName = true,
    },
  }

  vim.lsp.config('ts', {
    filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    root_markers = { 'tsconfig.json', 'package.json' },
    cmd = { 'typescript-language-server', '--stdio' },
    init_options = { hostInfo = 'neovim' },
    settings = {
      completions = { completeFunctionCalls = true },
      javascript = ts_settings,
      typescript = ts_settings,
      javascriptreact = ts_settings,
      typescriptreact = ts_settings,
      ['javascript.jsx'] = ts_settings,
      ['typescript.tsx'] = ts_settings,
    },
  })

  vim.lsp.config('eslint', {
    filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    cmd = { 'vscode-eslint-language-server', '--stdio' },
    root_markers = {
      '.eslintrc',
      '.eslintrc.cjs',
      '.eslintrc.js',
      '.eslintrc.json',
      '.eslintrc.yaml',
      '.eslintrc.yml',
      'package.json',
    },
    settings = {
      codeAction = {
        disableRuleComment = { enable = true, location = 'separateLine' },
        showDocumentation = { enable = true },
      },
      codeActionOnSave = { enable = false, mode = 'all' },
      experimental = { useFlatConfig = false },
      format = true,
      nodePath = '',
      onIgnoredFiles = 'off',
      problems = { shortenToSingleLine = false },
      quiet = false,
      rulesCustomizations = {},
      run = 'onType',
      useESLintClass = false,
      validate = 'on',
      workingDirectory = { mode = 'location' },
    },
  })

  vim.lsp.config('json', {
    filetypes = { 'json', 'jsonc' },
    cmd = { 'vscode-json-language-server', '--stdio' },
    init_options = { provideFormatter = true },
    settings = { json = { schemas = schemastore.json.schemas(), validate = { enable = true } } },
  })

  vim.lsp.config('docker', {
    filetypes = { 'dockerfile' },
    cmd = { 'docker-langserver', '--stdio' },
    root_markers = { 'Dockerfile', 'Containerfile' },
  })

  vim.lsp.config('html', {
    filetypes = { 'html' },
    cmd = { 'vscode-html-language-server', '--stdio' },
  })

  vim.lsp.config('lua', {
    filetypes = { 'lua' },
    cmd = { 'lua-language-server' },
    root_markers = { '.luarc.json' },
  })

  vim.lsp.config('python', {
    filetypes = { 'python' },
    cmd = { 'pyright-langserver', '--stdio' },
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = 'openFilesOnly',
          useLibraryCodeForTypes = true,
        },
      },
    },
  })

  vim.lsp.config('sh', {
    filetypes = { 'sh' },
    cmd = { 'bash-language-server', 'start' },
  })

  vim.lsp.config('nix', {
    filetypes = { 'nix' },
    cmd = { 'nil' },
    root_markers = { 'flake.nix' },
    settings = {
      ['nil'] = {
        formatting = { command = { 'alejandra' } },
        nix = { flake = { autoEvalInputs = true } },
      },
    },
  })

  vim.lsp.config('yaml', {
    filetypes = { 'yaml' },
    cmd = { 'yaml-language-server', '--stdio' },
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        format = true,
        schemas = {
          ['https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json'] = {
            'template.yaml',
            '*-template.yaml',
          },
        },
      },
    },
  })

  vim.lsp.config('efm', {
    cmd = { 'efm-langserver' },
    settings = {
      languages = {
        javascript = { prettier_d },
        javascriptreact = { prettier_d },
        typescript = { prettier_d },
        typescriptreact = { prettier_d },
        lua = { stylua },
        markdown = { markdownlint },
        nix = { statix },
        sh = { shfmt },
        yaml = { actionlint },
      },
    },
    init_options = {
      documentFormatting = true,
      documentRangeFormatting = true,
      codeAction = true,
      completion = true,
    },
  })

  vim.lsp.enable({
    'docker',
    'efm',
    'eslint',
    'html',
    'json',
    'lua',
    'nix',
    'python',
    'sh',
    'ts',
    'yaml',
  })

  local group = vim.api.nvim_create_augroup('lsp', {})
  vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Attach to lsp server',
    group = group,
    callback = function(a)
      local client = vim.lsp.get_client_by_id(a.data.client_id)
      if not client then return end
      local buf = a.buf --[[@as integer]]

      -- client.server_capabilities.semanticTokensProvider = nil

      if client.name == 'typescript-language-server' then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        vim.keymap.set('n', 'grA', function()
          vim.lsp.buf.code_action({
            context = {
              only = {
                ---@diagnostic disable-next-line: assign-type-mismatch
                'source.addMissingImports.ts',
                ---@diagnostic disable-next-line: assign-type-mismatch
                'source.fixAll.ts',
                ---@diagnostic disable-next-line: assign-type-mismatch
                'source.organizeImports.ts',
                ---@diagnostic disable-next-line: assign-type-mismatch
                'source.removeUnused.ts',
                ---@diagnostic disable-next-line: assign-type-mismatch
                'source.removeUnusedImports.ts',
                ---@diagnostic disable-next-line: assign-type-mismatch
                'source.sortImports.ts',
              },
              diagnostics = {},
            },
          })
        end, { buffer = buf })
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens, buf) then
        vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
          group = group,
          buffer = buf,
          callback = function() vim.lsp.codelens.refresh({ bufnr = buf }) end,
        })
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting, buf) then
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = group,
          buffer = buf,
          callback = function() vim.lsp.buf.format({ bufnr = buf, id = client.id }) end,
        })
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange, buf) then
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion, buf) then
        vim.lsp.completion.enable(true, client.id, buf, { autotrigger = false })
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, buf) then
        vim.api.nvim_create_autocmd({ 'CursorHold' }, {
          group = group,
          buffer = buf,
          callback = function()
            client:request(
              vim.lsp.protocol.Methods.textDocument_documentHighlight,
              vim.lsp.util.make_position_params(0, client.offset_encoding),
              nil,
              buf
            )
          end,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
          group = group,
          buffer = buf,
          callback = function() pcall(vim.lsp.buf.clear_references) end,
        })
      end

      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buf })
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = buf })
      vim.keymap.set('n', 'grl', vim.lsp.codelens.run, { buffer = buf })
      vim.keymap.set(
        'n',
        'grf',
        function() vim.lsp.buf.format({ async = true }) end,
        { buffer = buf }
      )
    end,
  })
end

function M.keyword()
  local function is_keyword_char()
    local char = get_char_at(vim.fn.line('.'), vim.fn.col('.'))
    return vim.regex('\\k'):match_str(char)
  end

  ---@param motion 'w'|'b'|'e'|'ge'
  local function keyword_motion(motion)
    for _ = 1, vim.v.count1 do
      local current_pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd.normal({ motion, bang = true })

      while not is_keyword_char() do
        local new_pos = vim.api.nvim_win_get_cursor(0)
        if current_pos[1] == new_pos[1] and current_pos[2] == new_pos[2] then break end
        vim.cmd.normal({ motion, bang = true })
        current_pos = new_pos
      end
    end
  end

  vim.iter({ 'w', 'b', 'e', 'ge' }):each(function(motion)
    vim.keymap.set({ 'n', 'x' }, motion, function() keyword_motion(motion) end)
  end)
end

function M.session()
  local group = vim.api.nvim_create_augroup('session', {})

  vim.api.nvim_create_autocmd('VimLeavePre', {
    desc = 'Save session',
    group = group,
    callback = function()
      if vim.bo.buftype ~= '' then return end
      if vim.bo.bufhidden ~= '' then return end

      if vim.fn.argc(-1) > 0 then vim.cmd('%argdelete') end
      vim.cmd.mksession({ bang = true })
    end,
  })

  vim.api.nvim_create_autocmd('VimEnter', {
    desc = 'Restore session',
    group = group,
    nested = true,
    callback = function()
      local session_file = 'Session.vim'
      if vim.fn.argc(-1) == 0 and vim.uv.fs_stat(session_file) then
        vim.cmd.source({ session_file, mods = { emsg_silent = true } })
      end
    end,
  })
end

function M.edge()
  ---@param s string
  ---@return boolean
  local function is_blank(s) return string.match(s, '^%s*$') ~= nil end

  ---@param lnum integer
  ---@param col integer
  ---@return boolean
  local function is_block(lnum, col)
    local char = get_char_at(lnum, col)
    if is_blank(char) then
      local prev_char = col > 1 and get_char_at(lnum, col - 1) or ' '
      local next_char = get_char_at(lnum, col + 1)
      return not (is_blank(prev_char) or is_blank(next_char))
    end
    return true
  end

  ---@param next boolean
  local function jump(next)
    local start_line = vim.fn.line('.')
    local last_line = vim.fn.line('$')
    local row = start_line
    local col = vim.fn.virtcol('.')
    local step = next and 1 or -1

    local on_block = is_block(start_line, col)
    local on_edge = on_block and not is_block(start_line + step, col)

    for lnum = start_line + step, next and last_line or 1, step do
      if on_edge then
        if is_block(lnum, col) then
          row = lnum
          break
        end
      else
        if on_block then
          if not is_block(lnum, col) then
            row = lnum - step
            break
          end
        else
          if is_block(lnum, col) then
            row = lnum
            break
          end
        end
      end
    end

    vim.api.nvim_win_set_cursor(0, { row, col - 1 })
  end

  vim.keymap.set({ 'n', 'x' }, ']e', function() jump(true) end)
  vim.keymap.set({ 'n', 'x' }, '[e', function() jump(false) end)
end

function M.plugins()
  vim.keymap.set('n', '<c-p>', function()
    local ok = pcall(require('telescope.builtin').git_files)
    if not ok then require('telescope.builtin').find_files() end
  end)
  vim.keymap.set('n', '<c-b>', '<cmd>Telescope buffers<cr>')
  vim.keymap.set('n', '<c-g>', '<cmd>Telescope live_grep<cr>')
  vim.keymap.set('n', '<c-h>', '<cmd>Telescope help_tags<cr>')
  vim.keymap.set('n', '<c-n>', '<cmd>Telescope oldfiles<cr>')

  vim.keymap.set('n', '<leader>gC', '<cmd>Telescope git_bcommits<cr>')
  vim.keymap.set('x', '<leader>gC', '<cmd>Telescope git_bcommits_range<cr>')
  vim.keymap.set('n', '<leader>gc', '<cmd>Telescope git_commits<cr>')
  vim.keymap.set('n', '<leader>gs', '<cmd>Telescope git_status<cr>')

  require('telescope').setup({
    pickers = {
      buffers = {
        ignore_current_buffer = true,
        sort_lastused = true,
        sort_mru = true,
        only_cwd = true,
      },
      find_files = { hidden = true },
      git_files = { show_untracked = true },
      oldfiles = { only_cwd = true },
    },
  })

  vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>')
  vim.keymap.set('n', '<leader>gf', '<cmd>DiffviewFileHistory %<cr>')
  vim.keymap.set('n', '<leader>gF', '<cmd>DiffviewFileHistory<cr>')
  vim.keymap.set('x', '<leader>gf', ":'<,'>DiffviewFileHistory<cr>")
  require('diffview').setup()

  require('gitsigns').setup({
    on_attach = function(buf)
      local gs = package.loaded.gitsigns

      vim.keymap.set('n', ']c', function()
        if vim.wo.diff then
          return ']c'
        else
          vim.schedule(function() gs.next_hunk({ greedy = false }) end)
          return '<Ignore>'
        end
      end, { buffer = buf, expr = true })
      vim.keymap.set('n', '[c', function()
        if vim.wo.diff then
          return '[c'
        else
          vim.schedule(function() gs.prev_hunk({ greedy = false }) end)
          return '<Ignore>'
        end
      end, { buffer = buf, expr = true })
      vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = buf })
      vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { buffer = buf })
      vim.keymap.set(
        'x',
        '<leader>hs',
        function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }, { buffer = buf }) end
      )
      vim.keymap.set(
        'x',
        '<leader>hr',
        function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }, { buffer = buf }) end
      )
      vim.keymap.set('n', '<leader>hS', gs.stage_buffer, { buffer = buf })
      vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { buffer = buf })
      vim.keymap.set('n', '<leader>hR', gs.reset_buffer, { buffer = buf })
      vim.keymap.set('n', '<leader>hp', gs.preview_hunk_inline, { buffer = buf })
      vim.keymap.set(
        'n',
        '<leader>hb',
        function() gs.blame_line({ full = true }) end,
        { buffer = buf }
      )
      vim.keymap.set('n', '<leader>hd', gs.diffthis, { buffer = buf })
      vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end, { buffer = buf })
      vim.keymap.set('n', '<leader>hq', gs.setqflist, { buffer = buf })
      vim.keymap.set('n', '<leader>hQ', function() gs.setqflist('all') end, { buffer = buf })
      vim.keymap.set('n', '<leader>hl', gs.setloclist, { buffer = buf })
      vim.keymap.set('n', '\\hb', gs.toggle_current_line_blame, { buffer = buf })
      vim.keymap.set('n', '\\hd', gs.toggle_deleted, { buffer = buf })
      vim.keymap.set('n', '\\hw', gs.toggle_word_diff, { buffer = buf })
      vim.keymap.set(
        { 'o', 'x' },
        'ih',
        ':<c-u>Gitsigns select_hunk<cr>',
        { buffer = buf, silent = true }
      )
    end,
  })

  local cmp = require('cmp')
  cmp.setup({
    confirmation = { default_behavior = 'replace' },
    experimental = { ghost_text = true },
    mapping = cmp.mapping.preset.insert({
      ['<c-d>'] = cmp.mapping.scroll_docs(-4),
      ['<c-f>'] = cmp.mapping.scroll_docs(4),
      ['<c-Space>'] = cmp.mapping.complete(),
      ['<cr>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      {
        name = 'buffer',
        option = {
          get_bufnrs = function()
            return vim
              .iter(vim.api.nvim_list_wins())
              :map(vim.api.nvim_win_get_buf)
              :filter(vim.api.nvim_buf_is_loaded)
              :totable()
          end,
        },
      },
      { name = 'path' },
    }),
    sorting = {
      comparators = {
        function(...) return require('cmp_buffer'):compare_locality(...) end,
      },
    },
  })

  require('mini.operators').setup({
    replace = { prefix = '_' },
    exchange = { prefix = '' },
    multiply = { prefix = '' },
  })

  require('mini.surround').setup({
    mappings = {
      add = 'ys',
      delete = 'ds',
      find = '',
      find_left = '',
      highlight = '',
      replace = 'cs',
      update_n_lines = '',
    },
  })

  local gen_ai_spec = require('mini.extra').gen_ai_spec
  require('mini.ai').setup({
    custom_textobjects = {
      b = gen_ai_spec.buffer(),
      d = gen_ai_spec.diagnostic(),
      i = gen_ai_spec.indent(),
      l = gen_ai_spec.line(),
      n = gen_ai_spec.number(),
    },
    mappings = {
      around_last = '',
      inside_last = '',
    },
    silent = true,
  })

  require('mini.icons').setup({ style = 'ascii' })
  MiniIcons.mock_nvim_web_devicons()

  require('mini.git').setup()
  vim.keymap.set(
    'ca',
    'g',
    function() return vim.fn.getcmdtype() == ':' and 'Git' or 'g' end,
    { expr = true }
  )
  vim.keymap.set('n', 'gis', '<cmd>Git status<cr>')
  vim.keymap.set('n', 'gic', '<cmd>Git commit<cr>')
  vim.keymap.set('n', 'gia', '<cmd>Git commit --amend --no-edit<cr>')
  vim.keymap.set('n', 'gil', '<cmd>Git log<cr>')
  vim.keymap.set('n', 'gip', '<cmd>Git pull<cr>')
  vim.keymap.set('n', 'giP', '<cmd>Git push<cr>')

  local flash = require('flash')
  flash.setup({
    modes = {
      search = {
        enabled = true,
      },
      char = {
        keys = { 'f', 'F' },
      },
    },
  })

  vim.keymap.set({ 'n', 'x', 'o' }, 's', flash.jump)
  vim.keymap.set({ 'n', 'x', 'o' }, 'S', flash.treesitter)
  vim.keymap.set('o', 'r', flash.remote)
  vim.keymap.set({ 'o', 'x' }, 'R', flash.treesitter_search)
  vim.keymap.set('c', '<c-s>', flash.toggle)

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('fx_mappings', {}),
    pattern = 'fx',
    callback = function(a)
      local dir = vim.api.nvim_buf_get_name(a.buf)
      local buf = a.buf --- @type integer

      local function edit() vim.cmd.drop(vim.fs.joinpath(dir, vim.api.nvim_get_current_line())) end

      vim.keymap.set('n', '<cr>', function() edit() end, { buffer = buf })
      vim.keymap.set('n', '<2-LeftMouse>', function() edit() end, { buffer = buf })
      vim.keymap.set('n', '-', '<cmd>edit %:h<cr>', { buffer = buf })
      vim.keymap.set(
        'n',
        '<c-l>',
        '<cmd>nohlsearch<bar>edit!<bar>normal! <C-l><cr>',
        { buffer = buf }
      )
      vim.keymap.set('n', 'D', function()
        local file = vim.api.nvim_get_current_line()
        if file == '' then return end

        vim.ui.select({ 'Yes', 'No' }, {
          prompt = string.format('Delete "%s"?: ', file),
        }, function(choice)
          if choice and choice == 'Yes' then
            vim.fs.rm(vim.fs.joinpath(dir, file), { force = true, recursive = true })
            vim.cmd.edit()
          end
        end)
      end, { buffer = buf })
      vim.keymap.set('n', 'R', function()
        local file = vim.api.nvim_get_current_line()
        if file == '' then return end

        vim.ui.input({
          completion = 'file',
          default = file,
          prompt = string.format('Rename "%s" to: ', file),
        }, function(input)
          if input and input ~= '' then
            vim.fn.rename(vim.fs.joinpath(dir, file), vim.fs.joinpath(dir, input))
            vim.cmd.edit()
          end
        end)
      end, { buffer = buf })
    end,
  })
end

local function main()
  vim.loader.enable()

  vim.g.mapleader = ' '

  vim.g.loaded_matchit = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_rplugin = 1
  vim.g.loaded_tutor = 1

  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }

  vim.iter(M):each(function(_, m) pcall(m) end)

  vim.cmd.aunmenu('PopUp.How-to\\ disable\\ mouse')
  vim.cmd.aunmenu('PopUp.-2-')

  vim.cmd.colorscheme('tokyonight-night')
end

main()
