# test_jester

```nim
nim c -r test.nim 
```

visit 127.0.0.1:8080/idx.html
or visit 127.0.0.1:8080/idx.txt

Got Error: ERR_RESPONSE_HEADERS_MULTIPLE_CONTENT_LENGTH

Because jester sends multiple content length.

```nim
# in asynchttpserver.nim
# https://github.com/nim-lang/Nim/blob/b6924383df63c91f0ad6baf63d0b1aa84f9329b7/lib/pure/asynchttpserver.nim#L102
proc respond*(req: Request, code: HttpCode, content: string,
              headers: HttpHeaders = nil): Future[void] =
  if headers != nil:
    msg.addHeaders(headers)
  msg.add("Content-Length: ")
  # this particular way saves allocations:
  msg.add content.len
  msg.add "\c\L\c\L"
  msg.add(content)
  result = req.client.send(msg)
```

```nim
# in jester
# https://github.com/dom96/jester/blob/d8a03aa4c681bc8514bb7bbf4953d380d86f5bd6/jester.nim#L202
let headers = @({
  "Content-Type": mimetype,
  "Content-Length": $fileSize
})
await req.statusContent(Http200, "", some(headers))
```

Relative codes:
https://github.com/dom96/jester/blob/d8a03aa4c681bc8514bb7bbf4953d380d86f5bd6/jester.nim#L202
https://github.com/dom96/httpbeast/blob/469fbe2eb029d0dfcb8e6b6ec0a37c52b7fc2313/src/httpbeast.nim#L332
https://github.com/nim-lang/Nim/blob/b6924383df63c91f0ad6baf63d0b1aa84f9329b7/lib/pure/asynchttpserver.nim#L102
