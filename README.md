# janet-playground

A WebAssembly based playground for Janet (https://janet-lang.org)
like that of https://play.golang.org

Intended to enable sharing of "runnable" example code in the Janet community. 

Currently the janet.wasm artifact produced here implements the "playground"
functionality in [JanetDocs](https://janetdocs.com/playground)

## Installation

You must ensure that you have installed emscripten (emsdk) > 2.0
and that it is in your path and executable.  (Generally you have
to do something like source ./emsdk_env.sh in the emsdk install directory.)

Then:

```
jpm install https://github.com/MikeBeller/janet-playground.git
./playground update-janet 1.16 # or whatever release version you want
./playground build
./playground install
./playground serve  # starts a server on localhost:8000
```

Then point your browser to http://localhost:8000/ to try it out.

## FAQ

**Q: How does this relate to the web repl on https://janet-lang.org?**

A: The web repl on janet-lang.org, as currently constituted, can only be
used for use case "A" above.  And even there, because it doesn't allow
multi-line editing, it's difficult to use for any larger examples.  That
said, the janet-lang.org web repl *does* permit sequential execution of
Janet forms, with subsequent forms operating on the same running fiber
as the previous forms.  By contrast, janet-playground creates
an interpreter, runs the example, and then de-inits janet.

## Note of thanks to Go Playground

The playground UI is styled based on the go playground, and uses it's style
sheet static/style.css .  As such, portions of this code may be
Copyright (C) 2014 The Go Authors.  See: https://github.com/golang/playground

