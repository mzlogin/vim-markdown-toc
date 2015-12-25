exec "silent! source " . "../ftplugin/markdown.vim"

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
call ASSERT(GetHeadingLinkTest("`Hello World`", "GFM") ==# "hello-world-2")
call ASSERT(GetHeadingLinkTest("_Hello_World_", "GFM") ==# "hello_world")
call ASSERT(GetHeadingLinkTest(",", "GFM") ==# "")
call ASSERT(GetHeadingLinkTest(",", "GFM") ==# "-1")
call ASSERT(GetHeadingLinkTest("No additional spaces before / after punctuation in fullwidth form", "GFM") ==# "no-additional-spaces-before--after-punctuation-in-fullwidth-form")
call ASSERT(GetHeadingLinkTest("No additional spaces before/after punctuation in fullwidth form", "GFM") ==# "no-additional-spaces-beforeafter-punctuation-in-fullwidth-form")

" Redcarpet Test Cases
call ASSERT(GetHeadingLinkTest("-Hello-World-", "Redcarpet") ==# "hello-world")
call ASSERT(GetHeadingLinkTest("_Hello_World_", "Redcarpet") ==# "hello_world")
call ASSERT(GetHeadingLinkTest("(Hello()World)", "Redcarpet") ==# "hello-world")
call ASSERT(GetHeadingLinkTest("让 Discuz! 局域网内可访问", "Redcarpet") ==# "让-discuz-局域网内可访问")
call ASSERT(GetHeadingLinkTest('"你好"世界"', "Redcarpet") ==# "quot-你好-quot-世界-quot")
call ASSERT(GetHeadingLinkTest("'你好'世界'", "Redcarpet") ==# "39-你好-39-世界-39")
call ASSERT(GetHeadingLinkTest("&你好&世界&", "Redcarpet") ==# "amp-你好-amp-世界-amp")
call ASSERT(GetHeadingLinkTest("`-ms-text-autospace` to the rescue?", "Redcarpet") ==# "ms-text-autospace-to-the-rescue")

echo "" . g:passCaseCount . " cases pass, " . g:errorCaseCount . " cases error"
