# janet-playground

A WebAssembly based playground for Janet (https://janet-lang.org)
like that of https://play.golang.org

The goal is to allow for sharing of "runnable" example code
in the Janet community. 

## Use cases

**Case A:** Just trying out some code without having to fire up an editor or even install Janet.

**Case B:** Creating online documentation where the examples are executable.

**Case C:** For sharing live code with others for discussion purposes.

## Public demo site

There is a public demo of one way that you can deploy the playground (to
support "Case A" and "Case B" described above) at: https://externalweb.s3.amazonaws.com/play/index.html

Public availability of use case C above is a work in progress.

## Installation

You must ensure that you have installed emscripten (emsdk) > 2.0
and that it is in your path and executable.  (Generally you have
to do something like source ./emsdk_env.sh in the emsdk install directory.)

Then:

```
jpm install https://github.com/MikeBeller/janet-playground.git
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
said, the web repl *does* permit sequential execution of Janet forms,
with subsequent forms operating on the same running fiber as the previous
forms.  That is not how janet-playground works.  It is "one shot".  Creates
and interpreter, runs the example, and then de-inits janet.

**Q: How do I share code using the playground (cases B and C above)?**

A: Coming soon.

## Note of thanks to Go Playground

This code is styled based on the go playground, and uses it's style
sheet static/style.css .  As such, portions of this code
may be Copyright (C) 2014 The Go Authors.  See: 
https://github.com/golang/playground

