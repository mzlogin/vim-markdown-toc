exec "silent! source " . "../ftplugin/markdown.vim"

let g:caseCount = 0
let g:passCaseCount = 0
let g:errorCaseCount = 0

function! AssertEquals(v1, v2)
    let l:result = (a:v1 ==# a:v2)
    let g:caseCount += 1
    if l:result != 0
        let g:passCaseCount += 1
        echo "case " . g:caseCount . " pass"
    else
        let g:errorCaseCount += 1
        echoe "case " . g:caseCount . " error, left `" . a:v1 . "`, right `" . a:v2 . "`"
    endif
endfunction

" GFM Test Cases {{{
let g:GFMHeadingIds = {}

call AssertEquals(GetHeadingLinkTest("# 你好！", "GFM"), "你好")
call AssertEquals(GetHeadingLinkTest("## Hello World", "GFM"), "hello-world")
call AssertEquals(GetHeadingLinkTest("### Hello World", "GFM"), "hello-world-1")
call AssertEquals(GetHeadingLinkTest("## Hello World", "GFM"), "hello-world-2")
call AssertEquals(GetHeadingLinkTest("## Hello World 2", "GFM"), "hello-world-2-1")
call AssertEquals(GetHeadingLinkTest("#### `Hello World`", "GFM"), "hello-world-3")
call AssertEquals(GetHeadingLinkTest("##### _Hello_World_", "GFM"), "hello_world")
call AssertEquals(GetHeadingLinkTest("###### ,", "GFM"), "")
call AssertEquals(GetHeadingLinkTest("# ,", "GFM"), "-1")
call AssertEquals(GetHeadingLinkTest("## No additional spaces before / after punctuation in fullwidth form", "GFM"), "no-additional-spaces-before--after-punctuation-in-fullwidth-form")
call AssertEquals(GetHeadingLinkTest("### No additional spaces before/after punctuation in fullwidth form", "GFM"), "no-additional-spaces-beforeafter-punctuation-in-fullwidth-form")
call AssertEquals(GetHeadingLinkTest("####   Hello    Markdown    ", "GFM"), "hello----markdown")
call AssertEquals(GetHeadingLinkTest("####Heading without a space after the hashes", "GFM"), "heading-without-a-space-after-the-hashes")
call AssertEquals(GetHeadingLinkTest("### heading with trailing hashes ###", "GFM"), "heading-with-trailing-hashes")
call AssertEquals(GetHeadingLinkTest("### heading with trailing hashes###", "GFM"), "heading-with-trailing-hashes-1")
call AssertEquals(GetHeadingLinkTest("### heading with trailing hashes ends with spaces ###  ", "GFM"), "heading-with-trailing-hashes-ends-with-spaces-")
call AssertEquals(GetHeadingLinkTest("### heading with trailing hashes nested with spaces # #  #  ", "GFM"), "heading-with-trailing-hashes-nested-with-spaces----")
call AssertEquals(GetHeadingLinkTest("### [vim-markdown-toc](https://github.com/mzlogin/vim-markdown-toc)", "GFM"), "vim-markdown-toc")
call AssertEquals(GetHeadingLinkTest("### [vim-markdown-toc-again][1]", "GFM"), "vim-markdown-toc-again")
call AssertEquals(GetHeadingLinkTest("### ![vim-markdown-toc-img](/path/to/a/png)", "GFM"), "vim-markdown-toc-img")
call AssertEquals(GetHeadingLinkTest("### ![](/path/to/a/png)", "GFM"), "-2")
call AssertEquals(GetHeadingLinkTest("### 1.1", "GFM"), "11")
call AssertEquals(GetHeadingLinkTest("### heading with some \"special\" \(yes, special\) chars: les caractères unicodes", "GFM"), "heading-with-some-special-yes-special-chars-les-caractères-unicodes")
call AssertEquals(GetHeadingLinkTest("## 初音ミクV3について", "GFM"), "初音ミクv3について")
call AssertEquals(GetHeadingLinkTest("# 안녕", "GFM"), "안녕")
" }}}

" GitLab Test Cases {{{
let g:GFMHeadingIds = {}

call AssertEquals(GetHeadingLinkTest("# 你好！", "GitLab"), "你好")
call AssertEquals(GetHeadingLinkTest("## Hello World", "GitLab"), "hello-world")
call AssertEquals(GetHeadingLinkTest("### Hello World", "GitLab"), "hello-world-1")
call AssertEquals(GetHeadingLinkTest("#### `Hello World`", "GitLab"), "hello-world-2")
call AssertEquals(GetHeadingLinkTest("##### _Hello_World_", "GitLab"), "hello_world")
call AssertEquals(GetHeadingLinkTest("###### ,", "GitLab"), "")
call AssertEquals(GetHeadingLinkTest("# ,", "GitLab"), "-1")
call AssertEquals(GetHeadingLinkTest("## No additional spaces before / after punctuation in fullwidth form", "GitLab"), "no-additional-spaces-before-after-punctuation-in-fullwidth-form")
call AssertEquals(GetHeadingLinkTest("### No additional spaces before/after punctuation in fullwidth form", "GitLab"), "no-additional-spaces-beforeafter-punctuation-in-fullwidth-form")
call AssertEquals(GetHeadingLinkTest("####   Hello    Markdown    ", "GitLab"), "hello-markdown")
call AssertEquals(GetHeadingLinkTest("####Heading without a space after the hashes", "GitLab"), "heading-without-a-space-after-the-hashes")
call AssertEquals(GetHeadingLinkTest("### heading with trailing hashes ###", "GitLab"), "heading-with-trailing-hashes")
call AssertEquals(GetHeadingLinkTest("### heading with trailing hashes###", "GitLab"), "heading-with-trailing-hashes-1")
call AssertEquals(GetHeadingLinkTest("### heading with trailing hashes ends with spaces ###  ", "GitLab"), "heading-with-trailing-hashes-ends-with-spaces-")
call AssertEquals(GetHeadingLinkTest("### heading with trailing hashes nested with spaces # #  #  ", "GitLab"), "heading-with-trailing-hashes-nested-with-spaces-")
call AssertEquals(GetHeadingLinkTest("### [vim-markdown-toc](https://github.com/mzlogin/vim-markdown-toc)", "GitLab"), "vim-markdown-toc")
call AssertEquals(GetHeadingLinkTest("### [vim-markdown-toc-again][1]", "GitLab"), "vim-markdown-toc-again")
call AssertEquals(GetHeadingLinkTest("### ![vim-markdown-toc-img](/path/to/a/png)", "GitLab"), "vim-markdown-toc-img")
call AssertEquals(GetHeadingLinkTest("### ![](/path/to/a/png)", "GitLab"), "-2")
call AssertEquals(GetHeadingLinkTest("### 1.1", "GitLab"), "11")
call AssertEquals(GetHeadingLinkTest("### heading with some \"special\" \(yes, special\) chars: les caractères unicodes", "GitLab"), "heading-with-some-special-yes-special-chars-les-caractères-unicodes")
call AssertEquals(GetHeadingLinkTest("## heading with Cyrillic Б б", "GitLab"), "heading-with-cyrillic-б-б")
call AssertEquals(GetHeadingLinkTest("## Ю heading starts with Cyrillic", "GitLab"), "ю-heading-starts-with-cyrillic")
" }}}

" Redcarpet Test Cases {{{
call AssertEquals(GetHeadingLinkTest("# -Hello-World-", "Redcarpet"), "hello-world")
call AssertEquals(GetHeadingLinkTest("## _Hello_World_", "Redcarpet"), "hello_world")
call AssertEquals(GetHeadingLinkTest("### (Hello()World)", "Redcarpet"), "hello-world")
call AssertEquals(GetHeadingLinkTest("#### 让 Discuz! 局域网内可访问", "Redcarpet"), "让-discuz-局域网内可访问")
call AssertEquals(GetHeadingLinkTest('##### "你好"世界"', "Redcarpet"), "quot-你好-quot-世界-quot")
call AssertEquals(GetHeadingLinkTest("###### '你好'世界'", "Redcarpet"), "39-你好-39-世界-39")
call AssertEquals(GetHeadingLinkTest("# &你好&世界&", "Redcarpet"), "amp-你好-amp-世界-amp")
call AssertEquals(GetHeadingLinkTest("## `-ms-text-autospace` to the rescue?", "Redcarpet"), "ms-text-autospace-to-the-rescue")
" }}}

" Marked Test Cases {{{
call AssertEquals(GetHeadingLinkTest("# 你好！", "Marked"), "你好！")
call AssertEquals(GetHeadingLinkTest("## Hello World", "Marked"), "hello-world")
call AssertEquals(GetHeadingLinkTest("### Hello World", "Marked"), "hello-world")
call AssertEquals(GetHeadingLinkTest("#### `Hello World`", "Marked"), "`hello-world`")
call AssertEquals(GetHeadingLinkTest("##### _Hello_World_", "Marked"), "_hello_world_")
call AssertEquals(GetHeadingLinkTest("###### ,", "Marked"), ",")
call AssertEquals(GetHeadingLinkTest("# ,", "Marked"), ",")
call AssertEquals(GetHeadingLinkTest("## No additional spaces before / after punctuation in fullwidth form", "Marked"), "no-additional-spaces-before-/-after-punctuation-in-fullwidth-form")
call AssertEquals(GetHeadingLinkTest("### No additional spaces before/after punctuation in fullwidth form", "Marked"), "no-additional-spaces-before/after-punctuation-in-fullwidth-form")
call AssertEquals(GetHeadingLinkTest("####   Hello    Markdown    ", "Marked"), "hello-markdown")
call AssertEquals(GetHeadingLinkTest("####Heading without a space after the hashes", "Marked"), "heading-without-a-space-after-the-hashes")
call AssertEquals(GetHeadingLinkTest("### heading with trailing hashes ###", "Marked"), "heading-with-trailing-hashes")
call AssertEquals(GetHeadingLinkTest("### heading with trailing hashes###", "Marked"), "heading-with-trailing-hashes")
call AssertEquals(GetHeadingLinkTest("### heading with trailing hashes ends with spaces ###  ", "Marked"), "heading-with-trailing-hashes-ends-with-spaces")
call AssertEquals(GetHeadingLinkTest("### heading with trailing hashes nested with spaces # #  #  ", "Marked"), "heading-with-trailing-hashes-nested-with-spaces-#-#")
call AssertEquals(GetHeadingLinkTest("### [vim-markdown-toc](https://github.com/mzlogin/vim-markdown-toc)", "Marked"), "[vim-markdown-toc](https://github.com/mzlogin/vim-markdown-toc)")
call AssertEquals(GetHeadingLinkTest("### [vim-markdown-toc-again][1]", "Marked"), "[vim-markdown-toc-again][1]")
call AssertEquals(GetHeadingLinkTest("### ![vim-markdown-toc-img](/path/to/a/png)", "Marked"), "![vim-markdown-toc-img](/path/to/a/png)")
call AssertEquals(GetHeadingLinkTest("### ![](/path/to/a/png)", "Marked"), "![](/path/to/a/png)")
call AssertEquals(GetHeadingLinkTest("### 1.1", "Marked"), "1.1")
call AssertEquals(GetHeadingLinkTest("### heading with some \"special\" \(yes, special\) chars: les caractères unicodes", "Marked"), "heading-with-some-\" special\"-\(yes,-special\)-chars:-les-caractères-unicodes")
" }}}

echo "" . g:passCaseCount . " cases pass, " . g:errorCaseCount . " cases error"
