dotmethod
===
obj.method(x) in racket (generalized)

documentation: http://pkg-build.racket-lang.org/doc/dotmethod/index.html

Example:
```racket
#lang dotmethod racket
dotmethod list? lst.ref(i)
  (list-ref lst i)
dotmethod hash? hsh.ref
  (case-lambda
    [(key) (hash-ref hsh key)]
    [(key else) (hash-ref hsh key else)])
let ([lox '(a b c d)])
  lox.ref(2)
let ([ht (hash 'a 1 'b 2 'c 3)])
  ht.ref('a)
```
