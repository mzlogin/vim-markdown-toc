if exists("g:loaded_MarkdownTocPlugin")
    finish
endif
let g:loaded_MarkdownTocPlugin = 1

if !exists("g:vmt_auto_update")
    let g:vmt_auto_update = 1
endif

if !exists("g:vmt_dont_insert_marker")
    let g:vmt_dont_insert_marker = 0
endif

let g:GFMHeadingIds = {}

function! s:HeadingLineRegex()
    return "^[#]\\{1,6} "
endfunction

function! s:GetSections(beginRegex, endRegex)
    let l:winview = winsaveview()
    let l:sections = {}

    normal! gg
    let l:flags = "Wc"
    let l:beginLine = 0
    let l:regex = a:beginRegex
    while search(l:regex, l:flags)
        let l:lineNum = line(".")
        if l:beginLine == 0
            let l:beginLine = l:lineNum
            let l:regex = a:endRegex
        else
            let l:sections[l:beginLine] = l:lineNum
            let l:beginLine = 0
            let l:regex = a:beginRegex
        endif
        let l:flags = "W"
    endwhile

    call winrestview(l:winview)

    return l:sections
endfunction

function! s:GetCodeSections()
    let l:codeSections = {}

    call extend(l:codeSections, <SID>GetSections("^```", "^```"))
    call extend(l:codeSections, <SID>GetSections("^{% highlight", "^{% endhighlight"))

    return l:codeSections
endfunction

function! s:IsLineInCodeSections(codeSections, lineNum)
    for beginLine in keys(a:codeSections)
        if a:lineNum > str2nr(beginLine)
            if a:lineNum < a:codeSections[beginLine]
                return 1
            endif
        endif
    endfor

    return 0
endfunction

function! s:GetHeadingLines()
    let l:winview = winsaveview()
    let l:headingLines = []
    let l:codeSections = <SID>GetCodeSections()

    let l:headingLineRegex = <SID>HeadingLineRegex()
    let l:flags = "W"

    while search(l:headingLineRegex, l:flags) != 0
        let l:line = getline(".")
        let l:lineNum = line(".")
        if <SID>IsLineInCodeSections(l:codeSections, l:lineNum) == 0
            call add(l:headingLines, l:line)
        endif
    endwhile

    call winrestview(l:winview)

    return l:headingLines
endfunction

function! s:GetHeadingLevel(headingLine)
    let l:sharps = split(a:headingLine, " ")[0]
    return len(l:sharps)
endfunction

function! s:GetHeadingLinkGFM(headingName)
    let l:headingLink = tolower(a:headingName)

    let l:headingLink = substitute(l:headingLink, "\\%^_\\+\\|_\\+\\%$", "", "g")
    let l:headingLink = substitute(l:headingLink, "[^[:alnum:]\u4e00-\u9fbf _-]", "", "g")
    let l:headingLink = substitute(l:headingLink, " ", "-", "g")

    if l:headingLink ==# ""
        let l:nullKey = "<null>"
        if has_key(g:GFMHeadingIds, l:nullKey)
            let g:GFMHeadingIds[l:nullKey] += 1
            let l:headingLink = l:headingLink . "-" . g:GFMHeadingIds[l:nullKey]
        else
            let g:GFMHeadingIds[l:nullKey] = 0
        endif
    elseif has_key(g:GFMHeadingIds, l:headingLink)
        let g:GFMHeadingIds[l:headingLink] += 1
        let l:headingLink = l:headingLink . "-" . g:GFMHeadingIds[l:headingLink]
    else
        let g:GFMHeadingIds[l:headingLink] = 0
    endif

    return l:headingLink
endfunction

function! s:GetHeadingLinkRedcarpet(headingName)
    let l:headingLink = tolower(a:headingName)

    let l:headingLink = substitute(l:headingLink, "<[^>]\\+>", "", "g")
    let l:headingLink = substitute(l:headingLink, "&", "&amp;", "g")
    let l:headingLink = substitute(l:headingLink, "\"", "&quot;", "g")
    let l:headingLink = substitute(l:headingLink, "'", "&#39;", "g")

    let l:headingLink = substitute(l:headingLink, "[ \\-&+\\$,/:;=?@\"#{}|\\^\\~\\[\\]`\\*()%.!']\\+", "-", "g")
    let l:headingLink = substitute(l:headingLink, "-\\{2,}", "-", "g")
    let l:headingLink = substitute(l:headingLink, "\\%^[\\-_]\\+\\|[\\-_]\\+\\%$", "", "g")

    return l:headingLink
endfunction

function! s:GetHeadingName(headingLine)
    let l:headingName = join(split(a:headingLine, " ")[1:-1], " ")
    let l:headingName = substitute(l:headingName, "^ \\+", "", "g")
    let l:headingName = substitute(l:headingName, " \\+$", "", "g")
    return l:headingName
endfunction

function! s:GetHeadingLink(headingName, markdownStyle)
    if a:markdownStyle ==# "GFM"
        return <SID>GetHeadingLinkGFM(a:headingName)
    elseif a:markdownStyle ==# "Redcarpet"
        return <SID>GetHeadingLinkRedcarpet(a:headingName)
    endif
endfunction

function! GetHeadingLinkTest(headingLine, markdownStyle)
    let l:headingName = <SID>GetHeadingName(a:headingLine)
    return <SID>GetHeadingLink(l:headingName, a:markdownStyle)
endfunction

function! s:GenToc(markdownStyle)
    let l:headingLines = <SID>GetHeadingLines()
    let l:levels = []

    let g:GFMHeadingIds = {}
    
    for headingLine in l:headingLines
        call add(l:levels, <SID>GetHeadingLevel(headingLine))
    endfor

    let l:minLevel = min(l:levels)

    if g:vmt_dont_insert_marker == 0
        put =<SID>GetBeginMarker(a:markdownStyle)
    endif

    let l:i = 0
    for headingLine in l:headingLines
        let l:headingName = <SID>GetHeadingName(headingLine)
        let l:headingIndents = l:levels[i] - l:minLevel

        let l:headingLink = <SID>GetHeadingLink(l:headingName, a:markdownStyle)

        let l:heading = repeat("\t", l:headingIndents)
        let l:heading = l:heading . "* [" . l:headingName . "]"
        let l:heading = l:heading . "(#" . l:headingLink . ")"

        put =l:heading

        let l:i += 1
    endfor

    if g:vmt_dont_insert_marker == 0
        put =<SID>GetEndMarker()
    endif
endfunction

function! s:GetBeginMarker(markdownStyle)
    return "<!-- vim-markdown-toc " . a:markdownStyle . " -->"
endfunction

function! s:GetEndMarker()
    return "<!-- vim-markdown-toc -->"
endfunction

function! s:GetBeginMarkerPattern()
    return "<!-- vim-markdown-toc \\([[:alpha:]]\\+\\) -->"
endfunction

function! s:GetEndMarkerPattern()
    return <SID>GetEndMarker()
endfunction

function! s:UpdateToc()
    let l:winview = winsaveview()

    let l:totalLineNum = line("$")

    let l:markdownStyle = <SID>GetExistsTocStyle()

    if l:markdownStyle != ""
        let [l:beginLineNumber,l:endLineNumber] = <SID>DeleteExistsToc()
        let l:isFirstLine = (l:beginLineNumber == 1)
        if l:beginLineNumber > 1
            let l:beginLineNumber -= 1
        endif

        if l:isFirstLine != 0
            call cursor(l:beginLineNumber, 1)
            put! =''
        endif

        call cursor(l:beginLineNumber, 1)
        call <SID>GenToc(l:markdownStyle)

        if l:isFirstLine != 0
            call cursor(l:beginLineNumber, 1)
            normal! dd
        endif

        " fix line number to avoid shake
        if l:winview['lnum'] > l:endLineNumber
            let l:diff = line("$") - l:totalLineNum
            let l:winview['lnum'] += l:diff
            let l:winview['topline'] += l:diff
        endif
    else
        echoe "Cannot find existing toc"
    endif

    call winrestview(l:winview)
endfunction

function! s:DeleteExistsToc()
    let l:winview = winsaveview()

    normal! gg

    let l:tocBeginPattern = <SID>GetBeginMarkerPattern()
    let l:tocEndPattern = <SID>GetEndMarkerPattern()

    let l:beginLineNumber = -1
    let l:endLineNumber= -1

    let l:flags = "Wc"
    if search(l:tocBeginPattern, l:flags) != 0
        let l:beginLineNumber = line(".")

        if search(l:tocEndPattern, l:flags) != 0
            let l:endLineNumber = line(".")
            execute l:beginLineNumber. "," . l:endLineNumber. "delete_"
        else
            echoe "Cannot find toc end marker"
            let l:beginLineNumber = -1
        endif
    endif

    call winrestview(l:winview)

    return [l:beginLineNumber,l:endLineNumber]
endfunction

function! s:GetExistsTocStyle()
    let l:winview = winsaveview()

    normal! gg

    let l:markdownStyle = ""

    let l:tocBeginPattern = <SID>GetBeginMarkerPattern()
    let l:tocEndPattern = <SID>GetEndMarkerPattern()

    let l:flags = "Wc"
    if search(l:tocBeginPattern, l:flags) != 0
        let l:line = getline(".")

        if search(l:tocEndPattern, l:flags) != 0
            let l:markdownStyle = matchlist(l:line, l:tocBeginPattern)[1]
            if l:markdownStyle != "GFM" && l:markdownStyle != "Redcarpet"
                echoe "Find unsupported markdown style"
                let l:markdownStyle = ""
            end
        endif
    endif

    call winrestview(l:winview)

    return l:markdownStyle
endfunction

command! GenTocGFM :call <SID>GenToc("GFM")
command! GenTocRedcarpet :call <SID>GenToc("Redcarpet")
command! UpdateToc :call <SID>UpdateToc()

if g:vmt_auto_update == 1
    autocmd BufWritePre *.md :silent! UpdateToc
endif
