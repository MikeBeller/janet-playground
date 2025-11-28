# janet-playground

A WebAssembly based playground for Janet (https://janet-lang.org)
like that of https://play.golang.org

Intended to enable sharing of "runnable" example code in the Janet community. 

Currently the janet.wasm artifact produced here is used by the "playground"
functionality in [JanetDocs](https://janetdocs.com/playground)

## Installation

### Prerequisites

You must have janet and JPM installed.

You can build the WASM artifact using a locally installed emcc or
using emcc via docker.

To use local emcc, you must first install emscripten (emsdk) > 2.0
and ensure that it is in your path and executable.  (Generally you have
to do something like source ./emsdk_env.sh in the emsdk install directory.)

To use docker, make sure docker is running and that you have docker
privileges.

# Clone and install janet playground

```sh
git clone https://github.com/MikeBeller/janet-playground.git
cd janet-playground
jpm install 
```

# Create the WASM binary

```
./playground update-janet v1.4.1   #  or 'latest' for latest
./playground build  # or build-docker for docker emcc
./playground install  # artifacts now available in public dir
```

# Run it on port 8000

```
./playground serve
```

Then point your browser to http://localhost:8000/ to try it out.

## To Update Janet Version In JanetDocs

After building as per above copy janet.wasm and janet.js from the
`public/js` directory of this repository to the `public/playground`
directory of the janetdocs repository.

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

