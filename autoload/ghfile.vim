function! ghfile#GetLink(reponame) abort
  let l:path = shellescape(expand('%'))
  let l:path = substitute(l:path, a:reponame, "")
  let l:path = substitute(l:path, "/home/"..getenv('USER').."/Repos/", "", "")
  let l:ghlink = system("ghfile "..a:reponame.."/tree/main/"..l:path)

  return l:ghlink
endfunction

function! ghfile#CopyCurrentFileGithub() abort
  let l:response = system("echo -n $(basename $(git rev-parse --show-toplevel))")

  if len(l:response) >= 0
    let l:reponame = l:response
  else
    let l:reponame = input("Tell me the repo name: ")
  endif

  let l:ghlink = ghfile#GetLink(l:reponame)

  if executable("yank")
    call system("yank "..l:ghlink)
    echohl Function | echomsg "Saved on the clipboard"
  endif
endfunction

function! ghfile#OpenCurrentFileGithub() abort
  let l:response = system("echo -n $(basename $(git rev-parse --show-toplevel))")

  if len(l:response) >= 0
    let l:reponame = l:response
  else
    let l:reponame = input("Tell me the repo name: ")
  endif

  let l:ghlink = ghfile#GetLink(l:reponame)

  if executable("explorer.exe")
    call system("explorer.exe "..l:ghlink)
    if executable("yank")
      call system("yank "..l:ghlink)
      echohl Function | echomsg "Saved on the clipboard"
    endif
  else
    echomsg l:ghlink
  endif
endfunction
