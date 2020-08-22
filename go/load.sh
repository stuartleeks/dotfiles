# simplify dlv debug etc: `dlv2  debug ./cmd/to/run arg1 arg2 ...`
dlv2() { dlv $1 $2 --headless --listen localhost:2345 --api-version 2 -- "${@:3}" ;  }
