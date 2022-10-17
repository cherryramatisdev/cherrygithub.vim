function! s:mountLinkIfRange(ghlink, range, line1, line2) abort
  if a:range != 0
    return a:ghlink.."#L"..a:line1.."-".."#L"..a:line2
  else
    return a:ghlink
  endif
endfunction

function! ghfile#GetLink(reponame) abort
  let l:path = shellescape(expand('%'))
  let l:path = substitute(l:path, a:reponame.."/", "", "")
  let l:path = substitute(l:path, "/home/"..getenv('USER').."/Repos/", "", "")
  let l:ghlink = system("ghfile "..a:reponame.."/tree/main/"..l:path)

  return l:ghlink
endfunction

function! ghfile#CopyCurrentFileGithub(range, line1, line2) abort
  let l:response = system("echo -n $(basename $(git rev-parse --show-toplevel))")

  if len(l:response) >= 0
    let l:reponame = l:response
  else
    let l:reponame = input("Tell me the repo name: ")
  endif

  let l:ghlink = s:mountLinkIfRange(ghfile#GetLink(l:reponame), a:range, a:line1, a:line2)

  if executable("pbcopy")
    call system("echo "..l:ghlink.."| pbcopy")
    echohl Function | echomsg "Saved on the clipboard"
  elseif executable("yank")
    call system("yank "..l:ghlink)
    echohl Function | echomsg "Saved on the clipboard"
  endif
endfunction

function! ghfile#OpenCurrentFileGithub(range, line1, line2) abort
  let l:response = system("echo -n $(basename $(git rev-parse --show-toplevel))")

  if len(l:response) >= 0
    let l:reponame = l:response
  else
    let l:reponame = input("Tell me the repo name: ")
  endif

  let l:ghlink = s:mountLinkIfRange(ghfile#GetLink(l:reponame), a:range, a:line1, a:line2)

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
