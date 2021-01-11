(declare-project
  :name "janet-playground"
  :author "Mike Beller"
  :license "MIT"
  :version "0.0.1"
  :url "https://github.com/mikebeller/janet-playground"
  :repo "git+https://github.com/mikebeller/janet-playground.git"
  :dependencies ["git+https://github.com/swlkr/osprey"])

(declare-binscript
  :main "playground"
  :hardcode-syspath true)

(declare-source
  :source ["playground.janet"])

