if exists("g:loaded_MarkdownTocPlugin")
    finish
endif
"let g:loaded_MarkdownTocPlugin = 1

function! s:HeadingLineRegex()
    return "^[#]\\{1,6} "
endfunction

function! s:GetHeadingLines()
    let l:winview = winsaveview()
    let l:headingLines = []
    let l:headingLineRegex = <SID>HeadingLineRegex()
    let l:flags = "Wc"
    normal! gg

    while search(l:headingLineRegex, l:flags) != 0
        let l:line = getline(".")
        call add(l:headingLines, l:line)

        let l:flags = "W"
    endwhile

    call winrestview(l:winview)

    return l:headingLines
endfunction

function! s:GetHeadingLevel(headingLine)
    let l:sharps = split(a:headingLine, " ")[0]
    return len(l:sharps)
endfunction

function! s:GetHeadingLink(headingName, markdownStyle)
    let l:headingLink = tolower(a:headingName)

    if a:markdownStyle ==# "GFM"
        let l:headingLink = substitute(l:headingLink, "/", "", "g")
        let l:headingLink = substitute(l:headingLink, "\"", "", "g")
    elseif a:markdownStyle ==# "Redcarpet"
        if l:headingLink[0] ==# "-"
            let l:headingLink = l:headingLink[1:-1]
        endif

        let l:headingLink = substitute(l:headingLink, "/", "-", "g")

        if l:headingLink[0] ==# "\""
            let l:quote = "quot"
            let l:headingLink = l:headingLink[1:-1]
            if len(l:headingLink) > 0
                let l:quote = l:quote . "-"
            endif
            let l:headingLink = l:quote . l:headingLink
        endif

        if l:headingLink[-1] ==# "\""
            let l:quote = "quot"
            let l:headingLink = l:headingLink[0:-2]
            if len(l:headingLink) > 0
                let l:quote = "-" . l:quote
            endif
            let l:headingLink = l:headingLink . l:quote
        endif

        let l:headingLink = substitute(l:headingLink, "\"", "-quot-", "g")
    endif

    let l:headingLink = substitute(l:headingLink, " ", "-", "g")
    let l:headingLink = substitute(l:headingLink, "!()", "", "g")

    return l:headingLink
endfunction

function! s:GenToc(markdownStyle)
    let l:headingLines = <SID>GetHeadingLines()
    let l:levels = []
    
    for headingLine in l:headingLines
        call add(l:levels, <SID>GetHeadingLevel(headingLine))
    endfor

    let l:minLevel = min(l:levels)

    let l:i = 0
    for headingLine in l:headingLines
        let l:headingName = join(split(headingLine, " ")[1:-1], " ")
        let l:headingIndents = l:levels[i] - l:minLevel

        let l:headingLink = <SID>GetHeadingLink(l:headingName, a:markdownStyle)

        let l:heading = repeat("\t", l:headingIndents)
        let l:heading = l:heading . "* [" . l:headingName . "]"
        let l:heading = l:heading . "(#" . l:headingLink . ")"

        put =l:heading

        let l:i += 1
    endfor

endfunction

command! GenTocGFM :call <SID>GenToc("GFM")
command! GenTocRedcarpet :call <SID>GenToc("Redcarpet")
