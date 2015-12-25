let g:caseCount = 0
let g:passCaseCount = 0
let g:errorCaseCount = 0

function! ASSERT(var)
    let g:caseCount += 1
    if a:var != 0
        let g:passCaseCount += 1
        echo "case " . g:caseCount . " pass"
    else
        let g:errorCaseCount += 1
        echoe "case " . g:caseCount . " error"
    endif
endfunction

let g:GFMHeadingIds = {}

" GFM Test Cases
call ASSERT(GetHeadingLinkTest("你好！", "GFM") ==# "你好")
call ASSERT(GetHeadingLinkTest("Hello World", "GFM") ==# "hello-world")
call ASSERT(GetHeadingLinkTest("Hello World", "GFM") ==# "hello-world-1")
call ASSERT(GetHeadingLinkTest("_Hello_World_", "GFM") ==# "hello_world")
call ASSERT(GetHeadingLinkTest(",", "GFM") ==# "")
call ASSERT(GetHeadingLinkTest(",", "GFM") ==# "-1")
call ASSERT(GetHeadingLinkTest("No additional spaces before / after punctuation in fullwidth form", "GFM") ==# "no-additional-spaces-before--after-punctuation-in-fullwidth-form")

" Redcarpet Test Cases
"call ASSERT(GetHeadingLinkTest("让 Discuz! 局域网内可访问", "Redcarpet") ==# "让-discuz-局域网内可访问")

echo "" . g:passCaseCount . " cases pass, " . g:errorCaseCount . " cases error"
