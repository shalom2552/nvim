" highlight cpp manReference
if bufname('%') =~# '^man://std::'
  syntax match manReference display '[^()[:space:]]\+ (3)'
endif
