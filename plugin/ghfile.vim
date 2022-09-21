command! -range GBrowse call ghfile#OpenCurrentFileGithub(<range>,<line1>,<line2>)
command! -range GCopy call ghfile#CopyCurrentFileGithub(<range>,<line1>,<line2>)
