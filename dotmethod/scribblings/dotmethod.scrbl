#lang scribble/manual

@(require scribble-code-examples
          (for-label racket dotmethod/dotmethod))

@title{dotmethod}

This package provides both a @racketmodname[dotmethod/dotmethod] module to be
required and a @hash-lang[] @racketmodname[dotmethod] lang-extension.

Both of these provide functionality for @litchar{obj.method(x)}-style method
definitions and method calls, but generalized to be used for all data types that
can be distinguished by predicates. 

@section{dotmethod/dotmethod}

@defmodule[dotmethod/dotmethod]{

A @racket[require] module intended to be used along with the
@racketmodname[sweet-exp] and @racketmodname[postfix-dot-notation]
lang-extensions together, for example:

@codeblock[#:keep-lang-line? #t]|{
#lang postfix-dot-notation sweet-exp racket
require dotmethod/dotmethod
}|}

@defidform[dotmethod]{
@codeblock[#:keep-lang-line? #t]|{
#lang postfix-dot-notation sweet-exp racket
require dotmethod/dotmethod
dotmethod pred-expr obj-id.method(args ...)
  method-body
  ...+
;or
dotmethod pred-expr obj-id.method
  method-expr ; a function expression
}|
Examples:
@code-examples[#:context #'here #:lang "postfix-dot-notation sweet-exp racket"]|{
require dotmethod/dotmethod
dotmethod list? lst.ref(i)
  (list-ref lst i)
dotmethod hash? hsh.ref
  (case-lambda ; can use case-lambda or any other expression here
    [(key) (hash-ref hsh key)]
    [(key else) (hash-ref hsh key else)])
let ([lox '(a b c d)])
  lox.ref(2) ; you could also write (lox.ref 2) or lox.ref 2 if you prefer
             ; this actually means ((ref lox) 2) in normal lisp notation
let ([ht (hash 'a 1 'b 2 'c 3)])
  values
    ht.ref('a)
    ht.ref('d 'not-found)
define adder%
  class object% (super-new)
    init-field a
    define/public add(b)
      (+ a b)
dotmethod (is-a?/c adder%) adder.add(b)
  (send adder add b)
define five-adder (make-object adder% 5)
five-adder.add(2)
}|
}

@defidform[dotmethods]{
@codeblock[#:keep-lang-line? #t]|{
#lang postfix-dot-notation sweet-exp racket
require dotmethod/dotmethod
dotmethods
  pred-expr obj-id.method(args ...)
    method-body
    ...+
  ...
}|
Examples:
@code-examples[#:context #'here #:lang "postfix-dot-notation sweet-exp racket"]|{
require dotmethod/dotmethod
dotmethods
  list? lst.ref(i)
    (list-ref lst i)
  hash? hsh.ref
    (case-lambda
      [(key) (hash-ref hsh key)]
      [(key else) (hash-ref hsh key else)])
let ([lox '(a b c d)])
  lox.ref(2)
let ([ht (hash 'a 1 'b 2 'c 3)])
  ht.ref('a)
}|
}

@section{#lang dotmethod}

@defmodule[dotmethod #:lang]{
A lang-extension for dotmethods so that
@codeblock[#:keep-lang-line? #t]|{
#lang dotmethod your-base-language
}|
Is roughly equivalent to
@codeblock[#:keep-lang-line? #t]|{
#lang afl postfix-dot-notation sweet-exp your-base-language
(require dotmethod/dotmethod)
}|
}

I say @italic{roughly}, because unlike with just blindly adding a require, it
still works properly if @racket[your-base-language] doesn't allow
require forms to be inserted like that. 

Example:
@codeblock[#:keep-lang-line? #t]|{
#lang dotmethod racket
dotmethods
  list? lst.ref(i)
    (list-ref lst i)
  hash? hsh.ref
    (case-lambda
      [(key) (hash-ref hsh key)]
      [(key else) (hash-ref hsh key else)])
let ([lox '(a b c d)])
  lox.ref(2)
let ([ht (hash 'a 1 'b 2 'c 3)])
  ht.ref('a)
}|

