(import spork/path)
(use osprey)

(def version "0.0.1")

(defn clean
  ```Clean up build artifacts```
  []
  (try
    (do
      (os/rm (path/join "build" "janet.js"))
      (os/rm (path/join "build" "janet.wasm"))
      (os/rmdir "build"))
    ([err] )))


(defn build
  ```Build wasm module.  Emsdk must be installed and runnable in the current
  shell -- on linux, for example, `source emsdk_env.sh` in the emsdk directory.```
  []
  (def stat (os/stat "build"))
  (when (nil? stat)
    (os/mkdir "build"))
  (def result
    (try
      (do
        (os/execute
          @["emcc" "-o" (path/join "build" "janet.js")
            (path/join "janet" "janet.c")
            (path/join "janet" "play.c")
            "-s" "EXPORTED_FUNCTIONS=['_run_janet']"
            "-s" "EXTRA_EXPORTED_RUNTIME_METHODS=['ccall','cwrap']"]
          :p))
      ([err] (eprint "Can't run emcc.  Ensure emcc is installed and in your path, and emsdk_defs.sh has been sourced into your current environment"))))
  (when (not= result 0)
    (eprint "Error running emcc.  Build failed.")))

(defn install
  ```Move build artifacts into site tree```
  []
  (try
    (do
      (os/rm (path/join "static" "js" "janet.js"))
      (os/rm (path/join "static" "js" "janet.wasm")))
    ([err]))
  (os/rename (path/join "build" "janet.js") (path/join "static" "js" "janet.js"))
  (os/rename (path/join "build" "janet.wasm") (path/join "static" "js" "janet.wasm")))

#(GET "/" (redirect "play.html"))

(defn serve
  ```Serve playground. Optional host:port.```
  [&opt host]
  (default host "localhost:8000")
  (def [addr port] (string/split ":" host))
  (when (or (nil? addr) (nil? port) (nil? (scan-number port)))
    (eprint "Invalid host:port string")
    (os/exit 1))
  (enable :static-files "static/")
  (server (scan-number port) addr))

