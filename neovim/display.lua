-- colors
vim.opt.termguicolors = true
vim.cmd [[colorscheme gruvbox]]
vim.cmd [[syntax on]]

-- highlight current line
vim.opt.cursorline = true

-- highlight search results
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- display line numbers
vim.opt.number = true

-- always show the status line
vim.opt.laststatus = 2

-- embedded terminal
vim.cmd [[
  augroup terminal_settings
    autocmd!
    autocmd TermOpen * set bufhidden=hide
    autocmd TermOpen * setlocal nonumber norelativenumber
  augroup END
]]

-- notify when files change on disk (aggregated notification)
vim.cmd [[
  " Global storage for changed buffers
  let g:changed_buffers = []
  let g:notification_timer = -1

  function! ShowChangedBuffers()
    if len(g:changed_buffers) > 0
      " Build a single-line message for all buffers
      if len(g:changed_buffers) == 1
        let l:msg = "Buffer reloaded: " . g:changed_buffers[0]
      else
        let l:msg = len(g:changed_buffers) . " buffers reloaded: "
        let l:buffer_list = join(g:changed_buffers, ", ")
        let l:msg = l:msg . l:buffer_list
      endif

      " Display the message
      echohl WarningMsg
      echo l:msg
      echohl None

      let g:changed_buffers = []
    endif
    let g:notification_timer = -1
  endfunction

  augroup file_change_notification
    autocmd!
    " When a file changes, collect its name and schedule notification
    autocmd FileChangedShellPost *
      \ call add(g:changed_buffers, expand("<afile>:t")) |
      \ if g:notification_timer != -1 | call timer_stop(g:notification_timer) | endif |
      \ let g:notification_timer = timer_start(300, {-> ShowChangedBuffers()})
  augroup END
]]
