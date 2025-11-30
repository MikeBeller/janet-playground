(import spork/path)
(import sh)
(use osprey)

(def version "0.0.3")

(defn clean
  ```Clean up build artifacts```
  []
  (try
    (do
      (each pth ["fmt.jimage" "janet.js" "janet.wasm"]
        (def fuller-path (path/join "build" pth))
        (when (os/stat fuller-path)
          (os/rm fuller-path)))
      (os/rmdir "build"))
    ([err]
      (eprintf "%s" err))))

(defn build-fmt-image []
  (def env (require "spork/fmt"))
  (spit "fmt.jimage" (make-image env)))

(defn build
  ```Build wasm module.  Emsdk must be installed and runnable in the current
  shell (on linux, for example, `source emsdk_env.sh` in the emsdk directory,)
  else docker must be installed and running, and the user must have docker privileges.```
  [use-docker]
  (def stat (os/stat "build"))
  (when (nil? stat)
    (os/mkdir "build"))
  (def emcc
    (if use-docker
      @["docker" "run" "--rm"
        "-v" (string/join @[(os/cwd) ":/src"])
        "-u"  (string/trimr (sh/$< "sh" "-c" "echo $(id -u):$(id -g)"))
        "emscripten/emsdk" "emcc"]
      @["emcc"]
   ))
  (os/cd "build")
  (build-fmt-image)
  (os/cd "..")
  (def result
    (try
      (do
        (os/execute
          (array/join emcc @["-O2" "-o" (path/join "build" "janet.js")
            (path/join "janet" "janet.c")
            (path/join "janet" "play.c")
            (string "-I" "janet")
            "--embed-file" (path/join "build" "fmt.jimage")
            "-s" "EXPORTED_FUNCTIONS=['_run_janet']"
            "-s" "ALLOW_MEMORY_GROWTH=1"
            "-s" "AGGRESSIVE_VARIABLE_ELIMINATION=1"
            "-s" "EXPORTED_RUNTIME_METHODS=['ccall','cwrap']"
            ]
          )
          :p))
      ([err] (eprint "Can't run emcc.  Ensure emcc is installed and in your path, and emsdk_env.sh has been sourced into your current environment"))))
  (when (not= result 0)
    (eprint "Error running emcc.  Build failed.")))

(defn install
  ```Move build artifacts into site tree```
  []
  (try
    (do
      (os/rm (path/join "public" "js" "janet.js"))
      (os/rm (path/join "public" "js" "janet.wasm")))
    ([err]))
  (os/rename (path/join "build" "janet.js") (path/join "public" "js" "janet.js"))
  (os/rename (path/join "build" "janet.wasm") (path/join "public" "js" "janet.wasm")))

(defn get-release-file [ver name]
  (def url 
    (if (= ver "latest") 
      (path/join "https://github.com/janet-lang/janet/releases/latest/download" name)
      (path/join "https://github.com/janet-lang/janet/releases/download" ver name)
      ))
  (print "GETTING: " url)
  (os/execute ["curl" "-sfL" "-o" (path/join "janet" name) url] :xp))

(defn update-janet
  ```Download janet.j/janet.h for the requested version```
  [ver]
  (def result
    (try
      (do
        (get-release-file ver "janet.c")
        (get-release-file ver "janet.h"))
      ([err] (eprint err))))
  (when (not= result 0)
    (eprint "Error downloading requested Janet version")))

#(GET "/" (redirect "play.html"))

(defn serve
  ```Serve playground. Optional host:port.```
  [&opt host]
  (default host "localhost:8000")
  (def [addr port] (string/split ":" host))
  (when (or (nil? addr) (nil? port) (nil? (scan-number port)))
    (eprint "Invalid host:port string")
    (os/exit 1))
  (enable :static-files)
  (prin "Starting server at ")
  (print host)
  (server (scan-number port) addr))

